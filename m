Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3316CC2D0F8
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 22:49:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFBBC206B7
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 22:49:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="js34yEWn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgELWtA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 18:49:00 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38550 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgELWtA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 18:49:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CMl5gk144041;
        Tue, 12 May 2020 22:48:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=FaunPBAxpvT77nStzCdQSiezfM6h929JyH9hRkqANcY=;
 b=js34yEWnfbexACJ1BfEMcEMT99XVJ4rnQ8KPx6LrAqp5UcGF5n3HfCJGQjtYEIeLDdR1
 kVEVt9ZK0WtZaNN/Zr44hB1HJHdwT9EIsrAzPQyXSctWGuKr/5xfH+nduiNbSzZA6fev
 mkdht44Ol2J4NzNaODi7cPKa+CkvhECrsz8Aab5z5FpIOUqhPcMMWLVwGzZLqJvVesTe
 7W8IjRJo9PzUrA+LMdcGm0obQXiyQoNuR9arYAsM6/uD7yNvoqG+dxZ3joJWRQ4+LjXX
 Jln4OeEuBVPlBH75wd/9MTXGhmy2P8pOYesvEiWRqmgytnXdUj8uwpzyV9E93ZIbXkPD 7g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3100xw94ck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 22:48:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CMlwYm154631;
        Tue, 12 May 2020 22:48:54 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 3100yd7mrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 22:48:54 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04CMmrZH002005;
        Tue, 12 May 2020 22:48:53 GMT
Received: from localhost (/10.159.139.160)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 May 2020 15:48:53 -0700
Date:   Tue, 12 May 2020 15:48:52 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_repair: check quota values if quota was loaded
Message-ID: <20200512224852.GM6714@magnolia>
References: <158930841417.1920396.3792994124679376951.stgit@magnolia>
 <158930842141.1920396.3267253462483632882.stgit@magnolia>
 <f7c0eae0-1095-100d-0b5e-ed6fd83b7cad@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7c0eae0-1095-100d-0b5e-ed6fd83b7cad@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=5 adultscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005120170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 lowpriorityscore=0
 suspectscore=5 mlxlogscore=999 clxscore=1015 cotscore=-2147483648
 mlxscore=0 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005120170
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 12, 2020 at 04:57:51PM -0500, Eric Sandeen wrote:
> On 5/12/20 1:33 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > If the filesystem looks like it had up to date quota information, check
> > it against what's in the filesystem and report if we find discrepancies.
> > This closes one of the major gaps in corruptions that are detected by
> > xfs_check vs. xfs_repair.
> 
> I'm musing about whether this should be (temporarily?) something we can
> disable, either due to bugs or extraordinary memory use?

Ok, I'll add -o noquota to disable the quotacheck.

> Speaking of memory use, does the memory calculation in main() need to
> be updated if quota checking is going to allocate a bazillion dquot nodes?

Hm, probably, but I can't think of a good way to guess how many dquots
we're going to need without opening the quota inodes.

> /*
>  * Adjust libxfs cache sizes based on system memory
>  * filesystem size and inode count.
>  * ...
> 
> ok and you just pointed out in realtime that the stuff allocated for rmap
> isn't in here either.  ;)  Sooooo maybe this memory calculation needs
> attention in any case?  

It does, but that's going to be tricky.  For non-reflink filesystems,
the worst case is 24 bytes for each non-free block to store the rmap
records.

For rmap+reflink filesystems the upper theoretical limit is
(blocks_used * 2^32) * 24 bytes to store the rmap records because
infinite sharing; and half again to store the 12-byte refcount records.

However, we can't figure out what the /real/ sharing factor is without
scanning the filesystem, which is probably why I never did much with
this. :(

> And we realized we can't size quota memory needs because we can't read the
> on-disk dquots yet... this sounds like a different problem to fix (or not) :(

<nod>

> > While we're at it, fix the alphabetization of the makefile targets.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  repair/Makefile     |   69 ++++++-
> >  repair/phase7.c     |   21 ++
> >  repair/quotacheck.c |  522 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  repair/quotacheck.h |   14 +
> >  4 files changed, 612 insertions(+), 14 deletions(-)
> >  create mode 100644 repair/quotacheck.c
> >  create mode 100644 repair/quotacheck.h
> > 
> > 
> > diff --git a/repair/Makefile b/repair/Makefile
> > index 8cc1ee68..e3a74adc 100644
> > --- a/repair/Makefile
> > +++ b/repair/Makefile
> > @@ -9,16 +9,65 @@ LSRCFILES = README
> >  
> >  LTCOMMAND = xfs_repair
> >  
> > -HFILES = agheader.h attr_repair.h avl.h bload.h bmap.h btree.h \
> > -	da_util.h dinode.h dir2.h err_protos.h globals.h incore.h protos.h \
> > -	rt.h progress.h scan.h versions.h prefetch.h rmap.h slab.h threads.h
> > -
> > -CFILES = agheader.c attr_repair.c avl.c bload.c bmap.c btree.c \
> > -	da_util.c dino_chunks.c dinode.c dir2.c globals.c incore.c \
> > -	incore_bmc.c init.c incore_ext.c incore_ino.c phase1.c \
> > -	phase2.c phase3.c phase4.c phase5.c phase6.c phase7.c \
> > -	progress.c prefetch.c rmap.c rt.c sb.c scan.c slab.c threads.c \
> > -	versions.c xfs_repair.c
> > +HFILES = \
> > +	agheader.h \
> > +	attr_repair.h \
> > +	avl.h \
> 
> ...
> 
> all this prooooobabbly should be a different patch.

DOH.  Will fix.

> >  LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBXCMD) $(LIBFROG) $(LIBUUID) $(LIBRT) \
> >  	$(LIBPTHREAD) $(LIBBLKID)
> > diff --git a/repair/phase7.c b/repair/phase7.c
> > index c2996470..47e76b56 100644
> > --- a/repair/phase7.c
> > +++ b/repair/phase7.c
> > @@ -15,6 +15,7 @@
> 
> ...
> 
> 
> 
> > +/* Find a qc_rec in the incore cache, or allocate one if need be. */
> > +static struct qc_rec *
> > +qc_rec_get(
> > +	struct qc_dquots	*dquots,
> > +	uint32_t		id,
> > +	bool			can_alloc)
> > +{
> > +	struct qc_rec		*qrec;
> > +	struct avl64node	*node;
> > +
> > +	pthread_mutex_lock(&dquots->lock);
> > +	node = avl64_find(&dquots->tree, id);
> > +	if (!node && can_alloc) {
> > +		qrec = calloc(sizeof(struct qc_rec), 1);
> > +		if (qrec) {
> > +			qrec->id = id;
> > +			node = avl64_insert(&dquots->tree, &qrec->node);
> > +			if (!node)
> > +				free(qrec);
> > +			pthread_mutex_init(&qrec->lock, NULL);
> > +		}
> > +	}
> > +	pthread_mutex_unlock(&dquots->lock);
> > +
> > +	return container_of(node, struct qc_rec, node);
> 
> this can blow up w/ node == NULL here if !can_alloc and not found, etc.

Fixed.

> > +}
> > +
> > +/* Bump up an incore dquot's counters. */
> > +static void
> > +qc_adjust(
> > +	struct qc_dquots	*dquots,
> > +	uint32_t		id,
> > +	uint64_t		bcount,
> > +	uint64_t		rtbcount)
> > +{
> > +	struct qc_rec		*qrec = qc_rec_get(dquots, id, true);
> > +
> > +	pthread_mutex_lock(&qrec->lock);
> > +	qrec->bcount += bcount;
> > +	qrec->rtbcount += rtbcount;
> > +	qrec->icount++;
> > +	pthread_mutex_unlock(&qrec->lock);
> > +}
> > +
> > +/* Count the realtime blocks allocated to a file. */
> > +static xfs_filblks_t
> > +qc_count_rtblocks(
> > +	struct xfs_inode	*ip)
> > +{
> > +	struct xfs_iext_cursor	icur;
> > +	struct xfs_bmbt_irec	got;
> > +	xfs_filblks_t		count = 0;
> > +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> > +	int			error;
> > +
> > +	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> > +		error = -libxfs_iread_extents(NULL, ip, XFS_DATA_FORK);
> > +		if (error) {
> > +			do_warn(
> > +_("could not read ino %"PRIu64" extents, err=%d\n"),
> > +				ip->i_ino, error);
> > +			chkd_flags = 0;
> > +			return 0;
> > +		}
> > +	}
> > +
> > +	for_each_xfs_iext(ifp, &icur, &got)
> > +		if (!isnullstartblock(got.br_startblock))
> > +			count += got.br_blockcount;
> > +	return count;
> > +}
> > +
> > +/* Add this inode's information to the quota counts. */
> > +void
> > +quotacheck_adjust(
> > +	struct xfs_mount	*mp,
> > +	xfs_ino_t		ino)
> > +{
> > +	struct xfs_inode	*ip;
> > +	uint64_t		blocks;
> > +	uint64_t		rtblks = 0;
> > +	int			error;
> > +
> > +	/*
> > +	 * If the fs doesn't have any quota files to check against, skip this
> > +	 * step.
> > +	 */
> > +	if (!user_dquots && !group_dquots && !proj_dquots)
> > +		return;
> > +
> > +	/* Skip if a previous quotacheck adjustment failed. */
> > +	if (chkd_flags == 0)
> > +		return;
> > +
> > +	/* Quota files are not included in quota counts. */
> > +	if (ino == mp->m_sb.sb_uquotino ||
> > +	    ino == mp->m_sb.sb_gquotino ||
> > +	    ino == mp->m_sb.sb_pquotino)
> > +		return;
> > +
> > +	error = -libxfs_iget(mp, NULL, ino, 0, &ip, &xfs_default_ifork_ops);
> > +	if (error) {
> > +		do_warn(_("could not iget %"PRIu64" for quotacheck, err=%d\n"),
> 
> "iget" vs "read" vs "open" again... just looking for some consistent do_warn
> phrasing for quota inodes.

I'll tighten the messaging to '[user|group|project] quota inode X" vs.
"file X".

> > +				ino, error);
> > +		chkd_flags = 0;
> > +		return;
> > +	}
> > +
> > +	/* Count the file's blocks. */
> > +	if (XFS_IS_REALTIME_INODE(ip))
> > +		rtblks = qc_count_rtblocks(ip);
> > +	blocks = ip->i_d.di_nblocks - rtblks;
> > +
> > +	if (user_dquots)
> > +		qc_adjust(user_dquots, i_uid_read(VFS_I(ip)), blocks, rtblks);
> > +	if (group_dquots)
> > +		qc_adjust(group_dquots, i_gid_read(VFS_I(ip)), blocks, rtblks);
> > +	if (proj_dquots)
> > +		qc_adjust(proj_dquots, ip->i_d.di_projid, blocks, rtblks);
> > +
> > +	libxfs_irele(ip);
> > +}
> > +
> > +/* Compare this on-disk dquot against whatever we observed. */
> > +static void
> > +qc_check_dquot(
> > +	struct xfs_disk_dquot	*ddq,
> > +	struct qc_dquots	*dquots)
> > +{
> > +	struct qc_rec		*qrec;
> > +	struct qc_rec		empty = {
> > +		.bcount		= 0,
> > +		.rtbcount	= 0,
> > +		.icount		= 0,
> > +	};
> > +	uint32_t		id = be32_to_cpu(ddq->d_id);
> > +
> > +	qrec = qc_rec_get(dquots, id, false);
> > +	if (!qrec)
> > +		qrec = &empty;
> > +
> > +	if (be64_to_cpu(ddq->d_bcount) != qrec->bcount) {
> > +		do_warn(_("%s id %u has bcount %llu, expected %"PRIu64"\n"),
> > +				qflags_typestr(dquots->type), id,
> > +				be64_to_cpu(ddq->d_bcount), qrec->bcount);
> > +		chkd_flags = 0;
> > +	}
> > +
> > +	if (be64_to_cpu(ddq->d_rtbcount) != qrec->rtbcount) {
> > +		do_warn(_("%s id %u has rtbcount %llu, expected %"PRIu64"\n"),
> > +				qflags_typestr(dquots->type), id,
> > +				be64_to_cpu(ddq->d_rtbcount), qrec->rtbcount);
> > +		chkd_flags = 0;
> > +	}
> > +
> > +	if (be64_to_cpu(ddq->d_icount) != qrec->icount) {
> > +		do_warn(_("%s id %u has icount %llu, expected %"PRIu64"\n"),
> > +				qflags_typestr(dquots->type), id,
> > +				be64_to_cpu(ddq->d_icount), qrec->icount);
> > +		chkd_flags = 0;
> > +	}
> > +
> > +	/*
> > +	 * Mark that we found the record on disk.  Skip locking here because
> > +	 * we're checking the dquots serially.
> > +	 */
> > +	qrec->flags |= QC_REC_ONDISK;
> > +}
> > +
> > +/* Walk every dquot in every block in this quota file extent and compare. */
> 
> can we be consistent in comments & warnings that when we're operaring on the
> quota inode itself, we call it the quota inode and not a file?  "file" sounds
> liek the bad old V1 vfs quota stuff where you could actually see the quota file.

<nod>

> > +static int
> > +qc_walk_extent(
> > +	struct xfs_inode	*ip,
> > +	struct xfs_bmbt_irec	*map,
> > +	struct qc_dquots	*dquots)
> > +{
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +	struct xfs_buf		*bp;
> > +	struct xfs_dqblk	*dqb;
> > +	xfs_filblks_t		dqchunklen;
> > +	xfs_filblks_t		bno;
> > +	unsigned int		dqperchunk;
> > +	int			error = 0;
> > +
> > +	dqchunklen = XFS_FSB_TO_BB(mp, XFS_DQUOT_CLUSTER_SIZE_FSB);
> > +	dqperchunk = libxfs_calc_dquots_per_chunk(dqchunklen);
> > +
> > +	for (bno = 0; bno < map->br_blockcount; bno++) {
> > +		unsigned int	dqnr;
> > +		uint64_t	dqid;
> > +
> > +		error = -libxfs_buf_read(mp->m_dev,
> > +				XFS_FSB_TO_DADDR(mp, map->br_startblock + bno),
> > +				dqchunklen, 0, &bp, &xfs_dquot_buf_ops);
> > +		if (error) {
> > +			do_warn(
> > +_("cannot read %s file %"PRIu64", block %"PRIu64", disk block %"PRIu64", err=%d\n"),
> > +				qflags_typestr(dquots->type), ip->i_ino,
> > +				map->br_startoff + bno,
> > +				map->br_startblock + bno, error);
> > +			chkd_flags = 0;
> > +			return error;
> > +		}
> > +
> > +		dqb = bp->b_addr;
> > +		dqid = map->br_startoff * dqperchunk;
> > +		for (dqnr = 0;
> > +		     dqnr < dqperchunk && dqid <= UINT_MAX;
> > +		     dqnr++, dqb++, dqid++)
> > +			qc_check_dquot(&dqb->dd_diskdq, dquots);
> > +		libxfs_buf_relse(bp);
> > +	}
> > +
> > +	return error;
> > +}
> > +
> > +/* Check the incore quota counts with what's on disk. */
> > +void
> > +quotacheck_verify(
> > +	struct xfs_mount	*mp,
> > +	unsigned int		type)
> > +{
> > +	struct xfs_bmbt_irec	map;
> > +	struct xfs_iext_cursor	icur;
> > +	struct xfs_inode	*ip;
> > +	struct xfs_ifork	*ifp;
> > +	struct qc_dquots	*dquots = NULL;
> > +	struct avl64node	*node, *n;
> > +	xfs_ino_t		ino = NULLFSINO;
> > +	uint16_t		qflag = 0;
> > +	int			error;
> > +
> > +	switch (type) {
> > +	case XFS_DQ_USER:
> > +		ino = mp->m_sb.sb_uquotino;
> > +		dquots = user_dquots;
> > +		qflag = XFS_UQUOTA_CHKD;
> > +		break;
> > +	case XFS_DQ_GROUP:
> > +		ino = mp->m_sb.sb_gquotino;
> > +		dquots = group_dquots;
> > +		qflag = XFS_GQUOTA_CHKD;
> > +		break;
> > +	case XFS_DQ_PROJ:
> > +		ino = mp->m_sb.sb_pquotino;
> > +		dquots = proj_dquots;
> > +		qflag = XFS_PQUOTA_CHKD;
> > +		break;
> > +	}
> > +
> > +	/*
> > +	 * If there's no incore records or there were errors in collecting
> > +	 * them, bail out early.  No sense in complaining about more garbage.
> > +	 */
> > +	if (!dquots || !(chkd_flags & qflag))
> > +		return;
> 
> It confuses me a little bit to check dquots as well as (chkd_flags & qflag)
> which seems to imply that one could be true and not the other; I'm not sure
> that's the case.

Hm, yeah.  We zero chkd_flags on any error so this could be turned into:

if (!quots || !chkd_flags)
	return;

Admittedly this quotacheck code is sort of phoning it in, because it
doesn't correct any of the quota counters; repair still just clears the
CHKD flags and we let the kernel fix it next time.  Maybe that's fine,
since otherwise repair would have to learn how to allocate and
initialize blocks in the dquot inodes.

> > +
> > +	error = -libxfs_iget(mp, NULL, ino, 0, &ip, &xfs_default_ifork_ops);
> > +	if (error) {
> > +		do_warn(
> > +	_("could not open %s file %"PRIu64" for quotacheck, err=%d\n"),
> 
> same here, let's say "read inode" not "open file" - etc in other places.


Fixed.

> > +			qflags_typestr(type), ino, error);
> > +		chkd_flags = 0;
> > +		return;
> > +	}
> > +
> > +	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> > +	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> > +		error = -libxfs_iread_extents(NULL, ip, XFS_DATA_FORK);
> > +		if (error) {
> > +			do_warn(
> > +	_("could not read %s file %"PRIu64" extents, err=%d\n"),
> > +				qflags_typestr(type), ip->i_ino, error);
> > +			chkd_flags = 0;
> > +			goto err;
> > +		}
> > +	}
> > +
> > +	/* Walk each extent of the quota file and compare counters. */
> > +	for_each_xfs_iext(ifp, &icur, &map) {
> > +		if (map.br_startblock != HOLESTARTBLOCK) {
> > +			error = qc_walk_extent(ip, &map, dquots);
> > +			if (error)
> > +				goto err;
> > +		}
> > +	}
> > +
> > +	/* Complain about counters that weren't seen on disk. */
> 
> Can this be made a little more clear about what was seen where and what
> didn't match?  So this is "we found an inode for an ID that doesn't have
> a corresponding dquot tracking it"

	/*
	 * We constructed incore dquots to account for every file we saw on
	 * disk, and then walked all on-disk dquots to compare.  Complain about
	 * incore dquots that weren't touched during the comparison, because
	 * that means something is missing from the dquot file.
	 */


> > +	qc_dquots_foreach(dquots, node, n) {
> > +		struct qc_rec	*qrec;
> > +
> > +		qrec = container_of(node, struct qc_rec, node);
> > +		if (!(qrec->flags & QC_REC_ONDISK)) {
> > +			do_warn(
> > +_("%s id %u not seen on disk (bcount %"PRIu64" rtbcount %"PRIu64" icount %"PRIu64")\n"),
> 
> this could be clearer too? maybe "no quota record found for ...?"

I'll change it to:
"project quota record for id 31337 not found on disk..."

> 
> > +				qflags_typestr(type), qrec->id,
> > +				qrec->bcount, qrec->rtbcount, qrec->icount);
> > +			chkd_flags = 0;
> > +		}
> > +	}
> > +err:
> > +	libxfs_irele(ip);
> > +}
> > +
> > +/*
> > + * Decide if we want to run quotacheck on a particular quota type.  Returns
> > + * true only if the inode isn't lost, the fs says quotacheck ran, and the inode
> > + * pointer isn't "unset".
> 
> which pointer?  and what does "unset" mean?  Do you mean NULLFSINO?

Sorry, I meant the ondisk pointer to the quota inode; and either
NULLFSINO or zero.  I'll make the comment say both of those things.

> > + */
> > +static inline bool
> > +qc_has_quotafile(
> > +	struct xfs_mount	*mp,
> > +	unsigned int		type)
> > +{
> > +	bool			lost;
> > +	xfs_ino_t		ino;
> > +	unsigned int		qflag;
> > +
> > +	switch (type) {
> > +	case XFS_DQ_USER:
> > +		lost = lost_uquotino;
> > +		ino = mp->m_sb.sb_uquotino;
> > +		qflag = XFS_UQUOTA_CHKD;
> > +		break;
> > +	case XFS_DQ_GROUP:
> > +		lost = lost_gquotino;
> > +		ino = mp->m_sb.sb_gquotino;
> > +		qflag = XFS_GQUOTA_CHKD;
> > +		break;
> > +	case XFS_DQ_PROJ:
> > +		lost = lost_pquotino;
> > +		ino = mp->m_sb.sb_pquotino;
> > +		qflag = XFS_PQUOTA_CHKD;
> > +		break;
> > +	default:
> > +		return false;
> > +	}
> > +
> > +	if (lost)
> > +		return false;
> > +	if (!(mp->m_sb.sb_qflags & qflag))
> > +		return false;
> > +	if (ino == NULLFSINO || ino == 0)
> > +		return false;
> > +	return true;
> > +}

Thx for the livereview. :)

--D

> -Eric
