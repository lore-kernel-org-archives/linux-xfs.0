Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8563C4320A
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Aug 2021 22:13:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E4FC60E52
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Aug 2021 22:13:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbhHKWNy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Aug 2021 18:13:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:52548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232297AbhHKWNy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Aug 2021 18:13:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB2EA60E52;
        Wed, 11 Aug 2021 22:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628720009;
        bh=+YwG9OnEGLrc+b25OmiXoeqxbUrNB/VYSJfZ8vbi1v8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OBnRD4GDI+fGGSIn72CdrgBcelk1wBrYqEvW9lSE6SPKx9nxzJWOYY+4FSRAOuIOh
         XyDYY0nQRTJC+MUC0MT+gDcqB2LMi94aCWeoc+GWZ8Vy6jZL02qvMKz3wZwF0Kqdrw
         Hye53M7cQDWyLIwdP2XZzuqClksdvMI3ThmE0/aM28fVdxChf+fjJoBNRHmwOZayFE
         /37PvTeLO+KjyWdKed4qUkx5sv8ftsDa3z0vmVP0Ux72qI7qUryufynrohU3X8sAOc
         5L7WBeZbJI1MWuPq5KTONEDWM7RRa/BZdbY7AsmRU3mJNwgmArHUehM48R7U31ycE5
         7/FDQroBfS5KQ==
Date:   Wed, 11 Aug 2021 15:13:29 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/16] xfs: replace xfs_sb_version checks with feature
 flag checks
Message-ID: <20210811221329.GK3601443@magnolia>
References: <20210810052451.41578-1-david@fromorbit.com>
 <20210810052451.41578-6-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810052451.41578-6-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 10, 2021 at 03:24:40PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Convert the xfs_sb_version_hasfoo() to checks against
> mp->m_features. Checks of the superblock itself during disk
> operations (e.g. in the read/write verifiers and the to/from disk
> formatters) are not converted - they operate purely on the
> superblock state. Everything else should use the mount features.
> 
> Large parts of this conversion were done with sed with commands like
> this:
> 
> for f in `git grep -l xfs_sb_version_has fs/xfs/*.c`; do
> 	sed -i -e 's/xfs_sb_version_has\(.*\)(&\(.*\)->m_sb)/xfs_has_\1(\2)/' $f
> done
> 
> With manual cleanups for things like "xfs_has_extflgbit" and other
> little inconsistencies in naming.
> 
> The result is ia lot less typing to check features and an XFS binary
> size reduced by a bit over 3kB:
> 
> $ size -t fs/xfs/built-in.a
> 	text	   data	    bss	    dec	    hex	filenam
> before	1130866  311352     484 1442702  16038e (TOTALS)
> after	1127727  311352     484 1439563  15f74b (TOTALS)
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---

<snip>

> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 699066fb9052..7361830163d7 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -951,8 +951,7 @@ xfs_growfs_rt(
>  		return -EINVAL;
>  
>  	/* Unsupported realtime features. */
> -	if (xfs_sb_version_hasrmapbt(&mp->m_sb) ||
> -	    xfs_sb_version_hasreflink(&mp->m_sb))
> +	if (xfs_has_rmapbt(mp) || xfs_has_reflink(mp))

A regression test that I developed to test the act of adding a realtime
volume to an existing filesystem exposed the following failure:

--- /tmp/fstests/tests/xfs/779.out      2021-08-08 08:47:08.535033170 -0700
+++ /var/tmp/fstests/xfs/779.out.bad    2021-08-11 14:54:18.389346401 -0700
@@ -1,2 +1,4 @@
 QA output created by 779
+/opt/a is not a realtime file?
+expected file extszhint 0, got 12288
 Silence is golden

Since this test is not yet upstream, I will describe the sequence of
events:

1. Suppress SCRATCH_RTDEV when invoking _scratch_mkfs.  This creates a
   filesystem with no realtime volume attached.
2. Mount the fs with SCRATCH_RTDEV in the mount options.  The rt volume
   still has not been attached.
3. Set RTINHERIT (and EXTSZINHERIT) on the root directory.  Make sure
   the extent size hint is not a multiple of the rt extent size.
4. Call xfs_growfs -r to add the rt volume into the filesystem.
5. Create a file.  Due to RTINHERIT, the new file should be a realtime
   file.
6. Check that the file is actually a realtime file and does not have an
   extent size hint.

The regression of course happens in step 6, because xfs_growfs_rt can
add a realtime volume to an existing filesystem.  Prior to this patch,
the "has realtime?" predicate always looked at the mp->m_sb.  Now that
the feature state has been turned into a separate xfs_mount state, we
must set the REALTIME m_feature flag explicitly.

The following patch solves the regression:

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 09d4195b6427..b69cce671243 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -319,6 +319,11 @@ __XFS_HAS_FEAT(inobtcounts, INOBTCNT)
 __XFS_HAS_FEAT(bigtime, BIGTIME)
 __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
 
+static inline void xfs_add_realtime(struct xfs_mount *mp)
+{
+	mp->m_features |= XFS_FEAT_REALTIME;
+}
+
 /*
  * Flags for m_flags.
  */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 7361830163d7..4bde66fd7b5a 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1130,6 +1130,9 @@ xfs_growfs_rt(
 		error = xfs_trans_commit(tp);
 		if (error)
 			break;
+
+		/* Make sure the incore feature flags get updated */
+		xfs_add_realtime(mp);
 	}
 	if (error)
 		goto out_free;

I can fold this in if you like.

--D

>  		return -EOPNOTSUPP;
>  
>  	nrblocks = in->newblocks;
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 6ab985ee6ba2..bf9ca921ebed 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -485,7 +485,7 @@ xfs_setup_devices(
>  	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp) {
>  		unsigned int	log_sector_size = BBSIZE;
>  
> -		if (xfs_sb_version_hassector(&mp->m_sb))
> +		if (xfs_has_sector(mp))
>  			log_sector_size = mp->m_sb.sb_logsectsize;
>  		error = xfs_setsize_buftarg(mp->m_logdev_targp,
>  					    log_sector_size);
> @@ -939,7 +939,7 @@ xfs_finish_flags(
>  	int			ronly = (mp->m_flags & XFS_MOUNT_RDONLY);
>  
>  	/* Fail a mount where the logbuf is smaller than the log stripe */
> -	if (xfs_sb_version_haslogv2(&mp->m_sb)) {
> +	if (xfs_has_logv2(mp)) {
>  		if (mp->m_logbsize <= 0 &&
>  		    mp->m_sb.sb_logsunit > XLOG_BIG_RECORD_BSIZE) {
>  			mp->m_logbsize = mp->m_sb.sb_logsunit;
> @@ -961,7 +961,7 @@ xfs_finish_flags(
>  	/*
>  	 * V5 filesystems always use attr2 format for attributes.
>  	 */
> -	if (xfs_sb_version_hascrc(&mp->m_sb) &&
> +	if (xfs_has_crc(mp) &&
>  	    (mp->m_flags & XFS_MOUNT_NOATTR2)) {
>  		xfs_warn(mp, "Cannot mount a V5 filesystem as noattr2. "
>  			     "attr2 is always enabled for V5 filesystems.");
> @@ -979,7 +979,7 @@ xfs_finish_flags(
>  
>  	if ((mp->m_qflags & XFS_GQUOTA_ACCT) &&
>  	    (mp->m_qflags & XFS_PQUOTA_ACCT) &&
> -	    !xfs_sb_version_has_pquotino(&mp->m_sb)) {
> +	    !xfs_has_pquotino(mp)) {
>  		xfs_warn(mp,
>  		  "Super block does not support project and group quota together");
>  		return -EINVAL;
> @@ -1497,7 +1497,7 @@ xfs_fs_fill_super(
>  		goto out_free_sb;
>  
>  	/* V4 support is undergoing deprecation. */
> -	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
> +	if (!xfs_has_crc(mp)) {
>  #ifdef CONFIG_XFS_SUPPORT_V4
>  		xfs_warn_once(mp,
>  	"Deprecated V4 format (crc=0) will not be supported after September 2030.");
> @@ -1582,7 +1582,7 @@ xfs_fs_fill_super(
>  	sb->s_maxbytes = MAX_LFS_FILESIZE;
>  	sb->s_max_links = XFS_MAXLINK;
>  	sb->s_time_gran = 1;
> -	if (xfs_sb_version_hasbigtime(&mp->m_sb)) {
> +	if (xfs_has_bigtime(mp)) {
>  		sb->s_time_min = xfs_bigtime_to_unix(XFS_BIGTIME_TIME_MIN);
>  		sb->s_time_max = xfs_bigtime_to_unix(XFS_BIGTIME_TIME_MAX);
>  	} else {
> @@ -1614,7 +1614,7 @@ xfs_fs_fill_super(
>  			"DAX unsupported by block device. Turning off DAX.");
>  			xfs_mount_set_dax_mode(mp, XFS_DAX_NEVER);
>  		}
> -		if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> +		if (xfs_has_reflink(mp)) {
>  			xfs_alert(mp,
>  		"DAX and reflink cannot be used together!");
>  			error = -EINVAL;
> @@ -1632,7 +1632,7 @@ xfs_fs_fill_super(
>  		}
>  	}
>  
> -	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
> +	if (xfs_has_reflink(mp)) {
>  		if (mp->m_sb.sb_rblocks) {
>  			xfs_alert(mp,
>  	"reflink not compatible with realtime device!");
> @@ -1646,7 +1646,7 @@ xfs_fs_fill_super(
>  		}
>  	}
>  
> -	if (xfs_sb_version_hasrmapbt(&mp->m_sb) && mp->m_sb.sb_rblocks) {
> +	if (xfs_has_rmapbt(mp) && mp->m_sb.sb_rblocks) {
>  		xfs_alert(mp,
>  	"reverse mapping btree not compatible with realtime device!");
>  		error = -EINVAL;
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 1525636f4065..707d36556bc5 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -63,7 +63,7 @@ xfs_readlink_bmap_ilocked(
>  			byte_cnt = pathlen;
>  
>  		cur_chunk = bp->b_addr;
> -		if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +		if (xfs_has_crc(mp)) {
>  			if (!xfs_symlink_hdr_ok(ip->i_ino, offset,
>  							byte_cnt, bp)) {
>  				error = -EFSCORRUPTED;
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index b52394b0e1f4..2aa0aae7d289 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -275,7 +275,7 @@ xfs_trans_alloc(
>  	WARN_ON(resp->tr_logres > 0 &&
>  		mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
>  	ASSERT(!(flags & XFS_TRANS_RES_FDBLKS) ||
> -	       xfs_sb_version_haslazysbcount(&mp->m_sb));
> +	       xfs_has_lazysbcount(mp));
>  
>  	tp->t_magic = XFS_TRANS_HEADER_MAGIC;
>  	tp->t_flags = flags;
> @@ -364,12 +364,12 @@ xfs_trans_mod_sb(
>  	switch (field) {
>  	case XFS_TRANS_SB_ICOUNT:
>  		tp->t_icount_delta += delta;
> -		if (xfs_sb_version_haslazysbcount(&mp->m_sb))
> +		if (xfs_has_lazysbcount(mp))
>  			flags &= ~XFS_TRANS_SB_DIRTY;
>  		break;
>  	case XFS_TRANS_SB_IFREE:
>  		tp->t_ifree_delta += delta;
> -		if (xfs_sb_version_haslazysbcount(&mp->m_sb))
> +		if (xfs_has_lazysbcount(mp))
>  			flags &= ~XFS_TRANS_SB_DIRTY;
>  		break;
>  	case XFS_TRANS_SB_FDBLOCKS:
> @@ -398,7 +398,7 @@ xfs_trans_mod_sb(
>  			delta -= blkres_delta;
>  		}
>  		tp->t_fdblocks_delta += delta;
> -		if (xfs_sb_version_haslazysbcount(&mp->m_sb))
> +		if (xfs_has_lazysbcount(mp))
>  			flags &= ~XFS_TRANS_SB_DIRTY;
>  		break;
>  	case XFS_TRANS_SB_RES_FDBLOCKS:
> @@ -408,7 +408,7 @@ xfs_trans_mod_sb(
>  		 * be applied to the on-disk superblock.
>  		 */
>  		tp->t_res_fdblocks_delta += delta;
> -		if (xfs_sb_version_haslazysbcount(&mp->m_sb))
> +		if (xfs_has_lazysbcount(mp))
>  			flags &= ~XFS_TRANS_SB_DIRTY;
>  		break;
>  	case XFS_TRANS_SB_FREXTENTS:
> @@ -487,7 +487,7 @@ xfs_trans_apply_sb_deltas(
>  	/*
>  	 * Only update the superblock counters if we are logging them
>  	 */
> -	if (!xfs_sb_version_haslazysbcount(&(tp->t_mountp->m_sb))) {
> +	if (!xfs_has_lazysbcount((tp->t_mountp))) {
>  		if (tp->t_icount_delta)
>  			be64_add_cpu(&sbp->sb_icount, tp->t_icount_delta);
>  		if (tp->t_ifree_delta)
> @@ -585,7 +585,7 @@ xfs_trans_unreserve_and_mod_sb(
>  	if (tp->t_blk_res > 0)
>  		blkdelta = tp->t_blk_res;
>  	if ((tp->t_fdblocks_delta != 0) &&
> -	    (xfs_sb_version_haslazysbcount(&mp->m_sb) ||
> +	    (xfs_has_lazysbcount(mp) ||
>  	     (tp->t_flags & XFS_TRANS_SB_DIRTY)))
>  	        blkdelta += tp->t_fdblocks_delta;
>  
> @@ -595,7 +595,7 @@ xfs_trans_unreserve_and_mod_sb(
>  	    (tp->t_flags & XFS_TRANS_SB_DIRTY))
>  		rtxdelta += tp->t_frextents_delta;
>  
> -	if (xfs_sb_version_haslazysbcount(&mp->m_sb) ||
> +	if (xfs_has_lazysbcount(mp) ||
>  	     (tp->t_flags & XFS_TRANS_SB_DIRTY)) {
>  		idelta = tp->t_icount_delta;
>  		ifreedelta = tp->t_ifree_delta;
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index eb76bc5bed9d..3872ce671411 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -58,7 +58,7 @@ xfs_trans_log_dquot(
>  
>  	/* Upgrade the dquot to bigtime format if possible. */
>  	if (dqp->q_id != 0 &&
> -	    xfs_sb_version_hasbigtime(&tp->t_mountp->m_sb) &&
> +	    xfs_has_bigtime(tp->t_mountp) &&
>  	    !(dqp->q_type & XFS_DQTYPE_BIGTIME))
>  		dqp->q_type |= XFS_DQTYPE_BIGTIME;
>  
> -- 
> 2.31.1
> 
