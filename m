Return-Path: <SRS0=7G1E=ZY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA6E2C432C3
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 21:21:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB0A22070B
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 21:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbfLBVVq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Dec 2019 16:21:46 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:57299 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725834AbfLBVVq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Dec 2019 16:21:46 -0500
Received: from dread.disaster.area (pa49-179-150-192.pa.nsw.optusnet.com.au [49.179.150.192])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6375C7EADAB;
        Tue,  3 Dec 2019 08:21:42 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ibt8W-000639-Q2; Tue, 03 Dec 2019 08:21:40 +1100
Date:   Tue, 3 Dec 2019 08:21:40 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, Alex Lyakas <alex@zadara.com>
Subject: Re: [RFC PATCH] xfs: don't commit sunit/swidth updates to disk if
 that would cause repair failures
Message-ID: <20191202212140.GG2695@dread.disaster.area>
References: <20191202173538.GD7335@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202173538.GD7335@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ZXpxJgW8/q3NVgupyyvOCQ==:117 a=ZXpxJgW8/q3NVgupyyvOCQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=pxVhFHJ0LMsA:10
        a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8 a=9ED8cW1ioRrxSIyIPrUA:9
        a=I6nLyeoXaS6t03Ck:21 a=yNK0vKr6wOKR08Js:21 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Dec 02, 2019 at 09:35:38AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Alex Lyakas reported[1] that mounting an xfs filesystem with new sunit
> and swidth values could cause xfs_repair to fail loudly.  The problem
> here is that repair calculates the where mkfs should have allocated the
> root inode, based on the superblock geometry.  The allocation decisions
> depend on sunit, which means that we really can't go updating sunit if
> it would lead to a subsequent repair failure on an otherwise correct
> filesystem.
> 
> Port the computation code from xfs_repair and teach mount to avoid the
> ondisk update if it would cause problems for repair.  We allow the mount
> to proceed (and new allocations will reflect this new geometry) because
> we've never screened this kind of thing before.
> 
> [1] https://lore.kernel.org/linux-xfs/20191125130744.GA44777@bfoster/T/#m00f9594b511e076e2fcdd489d78bc30216d72a7d
....
> +/*
> + * Compute the first and last inodes numbers of the inode chunk that was
> + * preallocated for the root directory.
> + */
> +void
> +xfs_ialloc_find_prealloc(
> +	struct xfs_mount	*mp,
> +	xfs_agino_t		*first_agino,
> +	xfs_agino_t		*last_agino)
> +{
> +	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
> +	xfs_agblock_t		first_bno;
> +
> +	/*
> +	 * Pre-calculate the geometry of ag 0. We know what it looks like
> +	 * because we know what mkfs does: 2 allocation btree roots (by block
> +	 * and by size), the inode allocation btree root, the free inode
> +	 * allocation btree root (if enabled) and some number of blocks to
> +	 * prefill the agfl.
> +	 *
> +	 * Because the current shape of the btrees may differ from the current
> +	 * shape, we open code the mkfs freelist block count here. mkfs creates
> +	 * single level trees, so the calculation is pertty straight forward for

pretty.

> +	 * the trees that use the AGFL.
> +	 */
> +
> +	/* free space by block btree root comes after the ag headers */
> +	first_bno = howmany(4 * mp->m_sb.sb_sectsize, mp->m_sb.sb_blocksize);
> +
> +	/* free space by length btree root */
> +	first_bno += 1;
> +
> +	/* inode btree root */
> +	first_bno += 1;
> +
> +	/* agfl */
> +	first_bno += (2 * min(2U, mp->m_ag_maxlevels)) + 1;

min_t(xfs_agblock_t, 2, mp->m_ag_maxlevels) ?

> +
> +	if (xfs_sb_version_hasfinobt(&mp->m_sb))
> +		first_bno++;
> +
> +	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
> +		first_bno += min(2U, mp->m_rmap_maxlevels); /* agfl blocks */

same.

> +		first_bno++;
> +	}
> +
> +	if (xfs_sb_version_hasreflink(&mp->m_sb))
> +		first_bno++;
> +
> +	/*
> +	 * If the log is allocated in the first allocation group we need to
> +	 * add the number of blocks used by the log to the above calculation.
> +	 *
> +	 * This can happens with filesystems that only have a single
> +	 * allocation group, or very odd geometries created by old mkfs
> +	 * versions on very small filesystems.
> +	 */
> +	if (mp->m_sb.sb_logstart &&
> +	    XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart) == 0) {
> +
> +		/*
> +		 * XXX(hch): verify that sb_logstart makes sense?
> +		 */
> +		 first_bno += mp->m_sb.sb_logblocks;
> +	}
> +
> +	/*
> +	 * ditto the location of the first inode chunks in the fs ('/')
> +	 */
> +	if (xfs_sb_version_hasdalign(&mp->m_sb) && igeo->ialloc_align > 0) {
> +		*first_agino = XFS_AGB_TO_AGINO(mp,
> +				roundup(first_bno, mp->m_sb.sb_unit));
> +	} else if (xfs_sb_version_hasalign(&mp->m_sb) &&
> +		   mp->m_sb.sb_inoalignmt > 1)  {
> +		*first_agino = XFS_AGB_TO_AGINO(mp,
> +				roundup(first_bno, mp->m_sb.sb_inoalignmt));
> +	} else  {
> +		*first_agino = XFS_AGB_TO_AGINO(mp, first_bno);
> +	}
> +
> +	ASSERT(igeo->ialloc_blks > 0);
> +
> +	if (igeo->ialloc_blks > 1)
> +		*last_agino = *first_agino + XFS_INODES_PER_CHUNK;
> +	else
> +		*last_agino = XFS_AGB_TO_AGINO(mp, first_bno + 1);

Isn't last_agino of the first inode of the next chunk? i.e. this is
an off-by-one...

> +}
> diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
> index 323592d563d5..9d9fe7b488b8 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.h
> +++ b/fs/xfs/libxfs/xfs_ialloc.h
> @@ -152,5 +152,7 @@ int xfs_inobt_insert_rec(struct xfs_btree_cur *cur, uint16_t holemask,
>  
>  int xfs_ialloc_cluster_alignment(struct xfs_mount *mp);
>  void xfs_ialloc_setup_geometry(struct xfs_mount *mp);
> +void xfs_ialloc_find_prealloc(struct xfs_mount *mp, xfs_agino_t *first_agino,
> +		xfs_agino_t *last_agino);
>  
>  #endif	/* __XFS_IALLOC_H__ */
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 7b35d62ede9f..d830a9e13817 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -891,6 +891,9 @@ xfs_ioc_fsgeometry(
>  
>  	xfs_fs_geometry(&mp->m_sb, &fsgeo, struct_version);
>  
> +	fsgeo.sunit = mp->m_sb.sb_unit;
> +	fsgeo.swidth = mp->m_sb.sb_width;

Why?

> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index fca65109cf24..0323a89256c7 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -368,6 +368,11 @@ xfs_update_alignment(xfs_mount_t *mp)
>  	xfs_sb_t	*sbp = &(mp->m_sb);
>  
>  	if (mp->m_dalign) {
> +		uint32_t	old_su;
> +		uint32_t	old_sw;
> +		xfs_agino_t	first;
> +		xfs_agino_t	last;
> +
>  		/*
>  		 * If stripe unit and stripe width are not multiples
>  		 * of the fs blocksize turn off alignment.
> @@ -398,24 +403,38 @@ xfs_update_alignment(xfs_mount_t *mp)
>  			}
>  		}
>  
> -		/*
> -		 * Update superblock with new values
> -		 * and log changes
> -		 */
> -		if (xfs_sb_version_hasdalign(sbp)) {
> -			if (sbp->sb_unit != mp->m_dalign) {
> -				sbp->sb_unit = mp->m_dalign;
> -				mp->m_update_sb = true;
> -			}
> -			if (sbp->sb_width != mp->m_swidth) {
> -				sbp->sb_width = mp->m_swidth;
> -				mp->m_update_sb = true;
> -			}
> -		} else {
> +		/* Update superblock with new values and log changes. */
> +		if (!xfs_sb_version_hasdalign(sbp)) {
>  			xfs_warn(mp,
>  	"cannot change alignment: superblock does not support data alignment");
>  			return -EINVAL;
>  		}
> +
> +		if (sbp->sb_unit == mp->m_dalign &&
> +		    sbp->sb_width == mp->m_swidth)
> +			return 0;
> +
> +		old_su = sbp->sb_unit;
> +		old_sw = sbp->sb_width;
> +		sbp->sb_unit = mp->m_dalign;
> +		sbp->sb_width = mp->m_swidth;
> +		xfs_ialloc_find_prealloc(mp, &first, &last);

We just chuck last away? why calculate it then? And why not just
pass mp->m_dalign/mp->m_swidth into the function rather than setting
them in the sb and then having to undo the change? i.e.

		rootino = xfs_ialloc_calc_rootino(mp, mp->m_dalign, mp->m_swidth);
		if (sbp->sb_rootino != rootino) {
			.....
		}
> +
> +		/*
> +		 * If the sunit/swidth change would move the precomputed root
> +		 * inode value, we must reject the ondisk change because repair
> +		 * will stumble over that.  However, we allow the mount to
> +		 * proceed because we never rejected this combination before.
> +		 */
> +		if (sbp->sb_rootino != XFS_AGINO_TO_INO(mp, 0, first)) {
> +			sbp->sb_unit = old_su;
> +			sbp->sb_width = old_sw;
> +			xfs_warn(mp,
> +	"cannot change alignment: would require moving root inode");

"cannot change stripe alignment: ..." ?

Should this also return EINVAL, as per above when the DALIGN sb
feature bit is not set?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
