Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A918C2D0F8
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 21:57:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 584BC20747
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 21:57:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731251AbgELV5x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 17:57:53 -0400
Received: from sandeen.net ([63.231.237.45]:34642 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728362AbgELV5x (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 May 2020 17:57:53 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 6E07A15B33;
        Tue, 12 May 2020 16:57:36 -0500 (CDT)
Subject: Re: [PATCH 1/2] xfs_repair: check quota values if quota was loaded
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <158930841417.1920396.3792994124679376951.stgit@magnolia>
 <158930842141.1920396.3267253462483632882.stgit@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <f7c0eae0-1095-100d-0b5e-ed6fd83b7cad@sandeen.net>
Date:   Tue, 12 May 2020 16:57:51 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <158930842141.1920396.3267253462483632882.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/12/20 1:33 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If the filesystem looks like it had up to date quota information, check
> it against what's in the filesystem and report if we find discrepancies.
> This closes one of the major gaps in corruptions that are detected by
> xfs_check vs. xfs_repair.

I'm musing about whether this should be (temporarily?) something we can
disable, either due to bugs or extraordinary memory use?

Speaking of memory use, does the memory calculation in main() need to
be updated if quota checking is going to allocate a bazillion dquot nodes?

/*
 * Adjust libxfs cache sizes based on system memory
 * filesystem size and inode count.
 * ...

ok and you just pointed out in realtime that the stuff allocated for rmap
isn't in here either.  ;)  Sooooo maybe this memory calculation needs
attention in any case?  

And we realized we can't size quota memory needs because we can't read the
on-disk dquots yet... this sounds like a different problem to fix (or not) :(

> While we're at it, fix the alphabetization of the makefile targets.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/Makefile     |   69 ++++++-
>  repair/phase7.c     |   21 ++
>  repair/quotacheck.c |  522 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  repair/quotacheck.h |   14 +
>  4 files changed, 612 insertions(+), 14 deletions(-)
>  create mode 100644 repair/quotacheck.c
>  create mode 100644 repair/quotacheck.h
> 
> 
> diff --git a/repair/Makefile b/repair/Makefile
> index 8cc1ee68..e3a74adc 100644
> --- a/repair/Makefile
> +++ b/repair/Makefile
> @@ -9,16 +9,65 @@ LSRCFILES = README
>  
>  LTCOMMAND = xfs_repair
>  
> -HFILES = agheader.h attr_repair.h avl.h bload.h bmap.h btree.h \
> -	da_util.h dinode.h dir2.h err_protos.h globals.h incore.h protos.h \
> -	rt.h progress.h scan.h versions.h prefetch.h rmap.h slab.h threads.h
> -
> -CFILES = agheader.c attr_repair.c avl.c bload.c bmap.c btree.c \
> -	da_util.c dino_chunks.c dinode.c dir2.c globals.c incore.c \
> -	incore_bmc.c init.c incore_ext.c incore_ino.c phase1.c \
> -	phase2.c phase3.c phase4.c phase5.c phase6.c phase7.c \
> -	progress.c prefetch.c rmap.c rt.c sb.c scan.c slab.c threads.c \
> -	versions.c xfs_repair.c
> +HFILES = \
> +	agheader.h \
> +	attr_repair.h \
> +	avl.h \

...

all this prooooobabbly should be a different patch.


>  LLDLIBS = $(LIBXFS) $(LIBXLOG) $(LIBXCMD) $(LIBFROG) $(LIBUUID) $(LIBRT) \
>  	$(LIBPTHREAD) $(LIBBLKID)
> diff --git a/repair/phase7.c b/repair/phase7.c
> index c2996470..47e76b56 100644
> --- a/repair/phase7.c
> +++ b/repair/phase7.c
> @@ -15,6 +15,7 @@

...



> +/* Find a qc_rec in the incore cache, or allocate one if need be. */
> +static struct qc_rec *
> +qc_rec_get(
> +	struct qc_dquots	*dquots,
> +	uint32_t		id,
> +	bool			can_alloc)
> +{
> +	struct qc_rec		*qrec;
> +	struct avl64node	*node;
> +
> +	pthread_mutex_lock(&dquots->lock);
> +	node = avl64_find(&dquots->tree, id);
> +	if (!node && can_alloc) {
> +		qrec = calloc(sizeof(struct qc_rec), 1);
> +		if (qrec) {
> +			qrec->id = id;
> +			node = avl64_insert(&dquots->tree, &qrec->node);
> +			if (!node)
> +				free(qrec);
> +			pthread_mutex_init(&qrec->lock, NULL);
> +		}
> +	}
> +	pthread_mutex_unlock(&dquots->lock);
> +
> +	return container_of(node, struct qc_rec, node);

this can blow up w/ node == NULL here if !can_alloc and not found, etc.

> +}
> +
> +/* Bump up an incore dquot's counters. */
> +static void
> +qc_adjust(
> +	struct qc_dquots	*dquots,
> +	uint32_t		id,
> +	uint64_t		bcount,
> +	uint64_t		rtbcount)
> +{
> +	struct qc_rec		*qrec = qc_rec_get(dquots, id, true);
> +
> +	pthread_mutex_lock(&qrec->lock);
> +	qrec->bcount += bcount;
> +	qrec->rtbcount += rtbcount;
> +	qrec->icount++;
> +	pthread_mutex_unlock(&qrec->lock);
> +}
> +
> +/* Count the realtime blocks allocated to a file. */
> +static xfs_filblks_t
> +qc_count_rtblocks(
> +	struct xfs_inode	*ip)
> +{
> +	struct xfs_iext_cursor	icur;
> +	struct xfs_bmbt_irec	got;
> +	xfs_filblks_t		count = 0;
> +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> +	int			error;
> +
> +	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> +		error = -libxfs_iread_extents(NULL, ip, XFS_DATA_FORK);
> +		if (error) {
> +			do_warn(
> +_("could not read ino %"PRIu64" extents, err=%d\n"),
> +				ip->i_ino, error);
> +			chkd_flags = 0;
> +			return 0;
> +		}
> +	}
> +
> +	for_each_xfs_iext(ifp, &icur, &got)
> +		if (!isnullstartblock(got.br_startblock))
> +			count += got.br_blockcount;
> +	return count;
> +}
> +
> +/* Add this inode's information to the quota counts. */
> +void
> +quotacheck_adjust(
> +	struct xfs_mount	*mp,
> +	xfs_ino_t		ino)
> +{
> +	struct xfs_inode	*ip;
> +	uint64_t		blocks;
> +	uint64_t		rtblks = 0;
> +	int			error;
> +
> +	/*
> +	 * If the fs doesn't have any quota files to check against, skip this
> +	 * step.
> +	 */
> +	if (!user_dquots && !group_dquots && !proj_dquots)
> +		return;
> +
> +	/* Skip if a previous quotacheck adjustment failed. */
> +	if (chkd_flags == 0)
> +		return;
> +
> +	/* Quota files are not included in quota counts. */
> +	if (ino == mp->m_sb.sb_uquotino ||
> +	    ino == mp->m_sb.sb_gquotino ||
> +	    ino == mp->m_sb.sb_pquotino)
> +		return;
> +
> +	error = -libxfs_iget(mp, NULL, ino, 0, &ip, &xfs_default_ifork_ops);
> +	if (error) {
> +		do_warn(_("could not iget %"PRIu64" for quotacheck, err=%d\n"),

"iget" vs "read" vs "open" again... just looking for some consistent do_warn
phrasing for quota inodes.

> +				ino, error);
> +		chkd_flags = 0;
> +		return;
> +	}
> +
> +	/* Count the file's blocks. */
> +	if (XFS_IS_REALTIME_INODE(ip))
> +		rtblks = qc_count_rtblocks(ip);
> +	blocks = ip->i_d.di_nblocks - rtblks;
> +
> +	if (user_dquots)
> +		qc_adjust(user_dquots, i_uid_read(VFS_I(ip)), blocks, rtblks);
> +	if (group_dquots)
> +		qc_adjust(group_dquots, i_gid_read(VFS_I(ip)), blocks, rtblks);
> +	if (proj_dquots)
> +		qc_adjust(proj_dquots, ip->i_d.di_projid, blocks, rtblks);
> +
> +	libxfs_irele(ip);
> +}
> +
> +/* Compare this on-disk dquot against whatever we observed. */
> +static void
> +qc_check_dquot(
> +	struct xfs_disk_dquot	*ddq,
> +	struct qc_dquots	*dquots)
> +{
> +	struct qc_rec		*qrec;
> +	struct qc_rec		empty = {
> +		.bcount		= 0,
> +		.rtbcount	= 0,
> +		.icount		= 0,
> +	};
> +	uint32_t		id = be32_to_cpu(ddq->d_id);
> +
> +	qrec = qc_rec_get(dquots, id, false);
> +	if (!qrec)
> +		qrec = &empty;
> +
> +	if (be64_to_cpu(ddq->d_bcount) != qrec->bcount) {
> +		do_warn(_("%s id %u has bcount %llu, expected %"PRIu64"\n"),
> +				qflags_typestr(dquots->type), id,
> +				be64_to_cpu(ddq->d_bcount), qrec->bcount);
> +		chkd_flags = 0;
> +	}
> +
> +	if (be64_to_cpu(ddq->d_rtbcount) != qrec->rtbcount) {
> +		do_warn(_("%s id %u has rtbcount %llu, expected %"PRIu64"\n"),
> +				qflags_typestr(dquots->type), id,
> +				be64_to_cpu(ddq->d_rtbcount), qrec->rtbcount);
> +		chkd_flags = 0;
> +	}
> +
> +	if (be64_to_cpu(ddq->d_icount) != qrec->icount) {
> +		do_warn(_("%s id %u has icount %llu, expected %"PRIu64"\n"),
> +				qflags_typestr(dquots->type), id,
> +				be64_to_cpu(ddq->d_icount), qrec->icount);
> +		chkd_flags = 0;
> +	}
> +
> +	/*
> +	 * Mark that we found the record on disk.  Skip locking here because
> +	 * we're checking the dquots serially.
> +	 */
> +	qrec->flags |= QC_REC_ONDISK;
> +}
> +
> +/* Walk every dquot in every block in this quota file extent and compare. */

can we be consistent in comments & warnings that when we're operaring on the
quota inode itself, we call it the quota inode and not a file?  "file" sounds
liek the bad old V1 vfs quota stuff where you could actually see the quota file.

> +static int
> +qc_walk_extent(
> +	struct xfs_inode	*ip,
> +	struct xfs_bmbt_irec	*map,
> +	struct qc_dquots	*dquots)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_buf		*bp;
> +	struct xfs_dqblk	*dqb;
> +	xfs_filblks_t		dqchunklen;
> +	xfs_filblks_t		bno;
> +	unsigned int		dqperchunk;
> +	int			error = 0;
> +
> +	dqchunklen = XFS_FSB_TO_BB(mp, XFS_DQUOT_CLUSTER_SIZE_FSB);
> +	dqperchunk = libxfs_calc_dquots_per_chunk(dqchunklen);
> +
> +	for (bno = 0; bno < map->br_blockcount; bno++) {
> +		unsigned int	dqnr;
> +		uint64_t	dqid;
> +
> +		error = -libxfs_buf_read(mp->m_dev,
> +				XFS_FSB_TO_DADDR(mp, map->br_startblock + bno),
> +				dqchunklen, 0, &bp, &xfs_dquot_buf_ops);
> +		if (error) {
> +			do_warn(
> +_("cannot read %s file %"PRIu64", block %"PRIu64", disk block %"PRIu64", err=%d\n"),
> +				qflags_typestr(dquots->type), ip->i_ino,
> +				map->br_startoff + bno,
> +				map->br_startblock + bno, error);
> +			chkd_flags = 0;
> +			return error;
> +		}
> +
> +		dqb = bp->b_addr;
> +		dqid = map->br_startoff * dqperchunk;
> +		for (dqnr = 0;
> +		     dqnr < dqperchunk && dqid <= UINT_MAX;
> +		     dqnr++, dqb++, dqid++)
> +			qc_check_dquot(&dqb->dd_diskdq, dquots);
> +		libxfs_buf_relse(bp);
> +	}
> +
> +	return error;
> +}
> +
> +/* Check the incore quota counts with what's on disk. */
> +void
> +quotacheck_verify(
> +	struct xfs_mount	*mp,
> +	unsigned int		type)
> +{
> +	struct xfs_bmbt_irec	map;
> +	struct xfs_iext_cursor	icur;
> +	struct xfs_inode	*ip;
> +	struct xfs_ifork	*ifp;
> +	struct qc_dquots	*dquots = NULL;
> +	struct avl64node	*node, *n;
> +	xfs_ino_t		ino = NULLFSINO;
> +	uint16_t		qflag = 0;
> +	int			error;
> +
> +	switch (type) {
> +	case XFS_DQ_USER:
> +		ino = mp->m_sb.sb_uquotino;
> +		dquots = user_dquots;
> +		qflag = XFS_UQUOTA_CHKD;
> +		break;
> +	case XFS_DQ_GROUP:
> +		ino = mp->m_sb.sb_gquotino;
> +		dquots = group_dquots;
> +		qflag = XFS_GQUOTA_CHKD;
> +		break;
> +	case XFS_DQ_PROJ:
> +		ino = mp->m_sb.sb_pquotino;
> +		dquots = proj_dquots;
> +		qflag = XFS_PQUOTA_CHKD;
> +		break;
> +	}
> +
> +	/*
> +	 * If there's no incore records or there were errors in collecting
> +	 * them, bail out early.  No sense in complaining about more garbage.
> +	 */
> +	if (!dquots || !(chkd_flags & qflag))
> +		return;

It confuses me a little bit to check dquots as well as (chkd_flags & qflag)
which seems to imply that one could be true and not the other; I'm not sure
that's the case.

> +
> +	error = -libxfs_iget(mp, NULL, ino, 0, &ip, &xfs_default_ifork_ops);
> +	if (error) {
> +		do_warn(
> +	_("could not open %s file %"PRIu64" for quotacheck, err=%d\n"),

same here, let's say "read inode" not "open file" - etc in other places.

> +			qflags_typestr(type), ino, error);
> +		chkd_flags = 0;
> +		return;
> +	}
> +
> +	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> +	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> +		error = -libxfs_iread_extents(NULL, ip, XFS_DATA_FORK);
> +		if (error) {
> +			do_warn(
> +	_("could not read %s file %"PRIu64" extents, err=%d\n"),
> +				qflags_typestr(type), ip->i_ino, error);
> +			chkd_flags = 0;
> +			goto err;
> +		}
> +	}
> +
> +	/* Walk each extent of the quota file and compare counters. */
> +	for_each_xfs_iext(ifp, &icur, &map) {
> +		if (map.br_startblock != HOLESTARTBLOCK) {
> +			error = qc_walk_extent(ip, &map, dquots);
> +			if (error)
> +				goto err;
> +		}
> +	}
> +
> +	/* Complain about counters that weren't seen on disk. */

Can this be made a little more clear about what was seen where and what
didn't match?  So this is "we found an inode for an ID that doesn't have
a corresponding dquot tracking it"

> +	qc_dquots_foreach(dquots, node, n) {
> +		struct qc_rec	*qrec;
> +
> +		qrec = container_of(node, struct qc_rec, node);
> +		if (!(qrec->flags & QC_REC_ONDISK)) {
> +			do_warn(
> +_("%s id %u not seen on disk (bcount %"PRIu64" rtbcount %"PRIu64" icount %"PRIu64")\n"),

this could be clearer too? maybe "no quota record found for ...?"

> +				qflags_typestr(type), qrec->id,
> +				qrec->bcount, qrec->rtbcount, qrec->icount);
> +			chkd_flags = 0;
> +		}
> +	}
> +err:
> +	libxfs_irele(ip);
> +}
> +
> +/*
> + * Decide if we want to run quotacheck on a particular quota type.  Returns
> + * true only if the inode isn't lost, the fs says quotacheck ran, and the inode
> + * pointer isn't "unset".

which pointer?  and what does "unset" mean?  Do you mean NULLFSINO?

> + */
> +static inline bool
> +qc_has_quotafile(
> +	struct xfs_mount	*mp,
> +	unsigned int		type)
> +{
> +	bool			lost;
> +	xfs_ino_t		ino;
> +	unsigned int		qflag;
> +
> +	switch (type) {
> +	case XFS_DQ_USER:
> +		lost = lost_uquotino;
> +		ino = mp->m_sb.sb_uquotino;
> +		qflag = XFS_UQUOTA_CHKD;
> +		break;
> +	case XFS_DQ_GROUP:
> +		lost = lost_gquotino;
> +		ino = mp->m_sb.sb_gquotino;
> +		qflag = XFS_GQUOTA_CHKD;
> +		break;
> +	case XFS_DQ_PROJ:
> +		lost = lost_pquotino;
> +		ino = mp->m_sb.sb_pquotino;
> +		qflag = XFS_PQUOTA_CHKD;
> +		break;
> +	default:
> +		return false;
> +	}
> +
> +	if (lost)
> +		return false;
> +	if (!(mp->m_sb.sb_qflags & qflag))
> +		return false;
> +	if (ino == NULLFSINO || ino == 0)
> +		return false;
> +	return true;
> +}

-Eric
