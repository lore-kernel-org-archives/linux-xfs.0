Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:45492 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753823AbeGFDQd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Jul 2018 23:16:33 -0400
Date: Thu, 5 Jul 2018 20:16:29 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 19/21] xfs: repair quotas
Message-ID: <20180706031629.GK32415@magnolia>
References: <152986820984.3155.16417868536016544528.stgit@magnolia>
 <152986833543.3155.2878459585391745135.stgit@magnolia>
 <20180706015025.GT2234@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180706015025.GT2234@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jul 06, 2018 at 11:50:25AM +1000, Dave Chinner wrote:
> On Sun, Jun 24, 2018 at 12:25:35PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Fix anything that causes the quota verifiers to fail.
> > +/* Fix anything the verifiers complain about. */
> > +STATIC int
> > +xfs_repair_quota_block(
> > +	struct xfs_scrub_context	*sc,
> > +	struct xfs_buf			*bp,
> > +	uint				dqtype,
> > +	xfs_dqid_t			id)
> > +{
> > +	struct xfs_dqblk		*d = (struct xfs_dqblk *)bp->b_addr;
> > +	struct xfs_disk_dquot		*ddq;
> > +	struct xfs_quotainfo		*qi = sc->mp->m_quotainfo;
> > +	enum xfs_blft			buftype = 0;
> > +	int				i;
> > +
> > +	bp->b_ops = &xfs_dquot_buf_ops;
> > +	for (i = 0; i < qi->qi_dqperchunk; i++) {
> > +		ddq = &d[i].dd_diskdq;
> > +
> > +		ddq->d_magic = cpu_to_be16(XFS_DQUOT_MAGIC);
> > +		ddq->d_version = XFS_DQUOT_VERSION;
> > +		ddq->d_flags = dqtype;
> > +		ddq->d_id = cpu_to_be32(id + i);
> > +
> > +		xfs_repair_quota_fix_timer(ddq->d_blk_softlimit,
> > +				ddq->d_bcount, &ddq->d_btimer,
> > +				qi->qi_btimelimit);
> > +		xfs_repair_quota_fix_timer(ddq->d_ino_softlimit,
> > +				ddq->d_icount, &ddq->d_itimer,
> > +				qi->qi_itimelimit);
> > +		xfs_repair_quota_fix_timer(ddq->d_rtb_softlimit,
> > +				ddq->d_rtbcount, &ddq->d_rtbtimer,
> > +				qi->qi_rtbtimelimit);
> > +
> > +		if (xfs_sb_version_hascrc(&sc->mp->m_sb)) {
> > +			uuid_copy(&d->dd_uuid, &sc->mp->m_sb.sb_meta_uuid);
> > +			xfs_update_cksum((char *)d, sizeof(struct xfs_dqblk),
> > +					 XFS_DQUOT_CRC_OFF);
> 
> Hmmm - Do we need to reset the lsn here, too? 

Probably, but...

> What makes me think - do we check that the lsn is valid in verifiers
> and so catch/fix problems where the lsn is outside the valid range
> of the current log LSNs?

...while we use them to skip old dquot logs during log recovery, we
don't check them otherwise AFAICT.

> > +STATIC int
> > +xfs_repair_quota_data_fork(
> > +	struct xfs_scrub_context	*sc,
> > +	uint				dqtype)
> > +{
> > +	struct xfs_bmbt_irec		irec = { 0 };
> > +	struct xfs_iext_cursor		icur;
> > +	struct xfs_quotainfo		*qi = sc->mp->m_quotainfo;
> > +	struct xfs_ifork		*ifp;
> > +	struct xfs_buf			*bp;
> > +	struct xfs_dqblk		*d;
> > +	xfs_dqid_t			id;
> > +	xfs_fileoff_t			max_dqid_off;
> > +	xfs_fileoff_t			off;
> > +	xfs_fsblock_t			fsbno;
> > +	bool				truncate = false;
> > +	int				error = 0;
> > +
> > +	error = xfs_repair_metadata_inode_forks(sc);
> > +	if (error)
> > +		goto out;
> > +
> > +	/* Check for data fork problems that apply only to quota files. */
> > +	max_dqid_off = ((xfs_dqid_t)-1) / qi->qi_dqperchunk;
> > +	ifp = XFS_IFORK_PTR(sc->ip, XFS_DATA_FORK);
> > +	for_each_xfs_iext(ifp, &icur, &irec) {
> > +		if (isnullstartblock(irec.br_startblock)) {
> > +			error = -EFSCORRUPTED;
> > +			goto out;
> > +		}
> > +
> > +		if (irec.br_startoff > max_dqid_off ||
> > +		    irec.br_startoff + irec.br_blockcount - 1 > max_dqid_off) {
> > +			truncate = true;
> > +			break;
> > +		}
> > +	}
> > +	if (truncate) {
> > +		error = xfs_itruncate_extents(&sc->tp, sc->ip, XFS_DATA_FORK,
> > +				max_dqid_off * sc->mp->m_sb.sb_blocksize);
> > +		if (error)
> > +			goto out;
> > +	}
> > +
> > +	/* Now go fix anything that fails the verifiers. */
> > +	for_each_xfs_iext(ifp, &icur, &irec) {
> > +		for (fsbno = irec.br_startblock, off = irec.br_startoff;
> > +		     fsbno < irec.br_startblock + irec.br_blockcount;
> > +		     fsbno += XFS_DQUOT_CLUSTER_SIZE_FSB,
> > +				off += XFS_DQUOT_CLUSTER_SIZE_FSB) {
> > +			id = off * qi->qi_dqperchunk;
> > +			error = xfs_trans_read_buf(sc->mp, sc->tp,
> > +					sc->mp->m_ddev_targp,
> > +					XFS_FSB_TO_DADDR(sc->mp, fsbno),
> > +					qi->qi_dqchunklen,
> > +					0, &bp, &xfs_dquot_buf_ops);
> > +			if (error == 0) {
> > +				d = (struct xfs_dqblk *)bp->b_addr;
> > +				if (id == be32_to_cpu(d->dd_diskdq.d_id))
> > +					continue;
> 
> Need to release the buffer here - it's clean and passes the
> verifier, so no need to hold on to them as we may have thousands of
> them to walk here.

Ok.

> Otherwise looks ok.

Thank you for the review!

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
