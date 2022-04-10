Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1274DC433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 10 Apr 2022 18:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237300AbiDJSXU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Apr 2022 14:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbiDJSXT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Apr 2022 14:23:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC7022531
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 11:21:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2798C611B8
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 18:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E3FC385A4;
        Sun, 10 Apr 2022 18:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649614866;
        bh=ONri+7eEBIzeoAl49+PB7k0IyYd8lTy3dw5jD1FKJEQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eYckxdVHYA3w3LiLA7qa7Eabw1KuPZCXgUM4ozn4KV+Yp4EStKxSUAQ8OD5T3q4JO
         1RTvu6YFDSvQ+R6nV0c4H0Fk7D3VCvjTZK1ObYcHbHoPSckF5wRgY0W9N4pCY7JzhX
         A76lSx0VaauZfKUm10Dt8hZHgRVi/W9Ht0ypEyVYn0lqQIkA9zmQ12ZYsi3XHrZykO
         FUT9Sn4Dwe5rEh3OedE/i4bLZzTW/89EWvbZ3KlIfzd+pESXEq/AxrWmb205WDX2UX
         LVUF2thyzJYbTNe73CQlIxlwk/iDnqnhxrzLJaudeUrrer21JpoDhCsLDfprxdEKd6
         ZG1ubyTvNnXow==
Subject: [PATCH 2/3] xfs: recalculate free rt extents after log recovery
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Sun, 10 Apr 2022 11:21:06 -0700
Message-ID: <164961486596.70555.15167639007811062573.stgit@magnolia>
In-Reply-To: <164961485474.70555.18228016043917319266.stgit@magnolia>
References: <164961485474.70555.18228016043917319266.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

I've been observing periodic corruption reports from xfs_scrub involving
the free rt extent counter (frextents) while running xfs/141.  That test
uses an error injection knob to induce a torn write to the log, and an
arbitrary number of recovery mounts, frextents will count fewer free rt
extents than can be found the rtbitmap.

The root cause of the problem is a combination of the misuse of
sb_frextents in the incore mount to reflect both incore reservations
made by running transactions as well as the actual count of free rt
extents on disk.  The following sequence can reproduce the undercount:

Thread 1			Thread 2
xfs_trans_alloc(rtextents=3)
xfs_mod_frextents(-3)
<blocks>
				xfs_attr_set()
				xfs_bmap_attr_addfork()
				xfs_add_attr2()
				xfs_log_sb()
				xfs_sb_to_disk()
				xfs_trans_commit()
<log flushed to disk>
<log goes down>

Note that thread 1 subtracts 3 from sb_frextents even though it never
commits to using that space.  Thread 2 writes the undercounted value to
the ondisk superblock and logs it to the xattr transaction, which is
then flushed to disk.  At next mount, log recovery will find the logged
superblock and write that back into the filesystem.  At the end of log
recovery, we reread the superblock and install the recovered
undercounted frextents value into the incore superblock.  From that
point on, we've effectively leaked thread 1's transaction reservation.

The correct fix for this is to separate the incore reservation from the
ondisk usage, but that's a matter for the next patch.  Because the
kernel has been logging superblocks with undercounted frextents for a
very long time and we don't demand that sysadmins run xfs_repair after a
crash, fix the undercount by recomputing frextents after log recovery.

Gating this on log recovery is a reasonable balance (I think) between
correcting the problem and slowing down every mount attempt.  Note that
xfs_repair will fix undercounted frextents.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_mount.c   |   41 ++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_rtalloc.c |   37 +++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_rtalloc.h |    2 ++
 3 files changed, 71 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index c5f153c3693f..53e130f803b1 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -468,6 +468,8 @@ STATIC int
 xfs_check_summary_counts(
 	struct xfs_mount	*mp)
 {
+	int			error = 0;
+
 	/*
 	 * The AG0 superblock verifier rejects in-progress filesystems,
 	 * so we should never see the flag set this far into mounting.
@@ -506,11 +508,32 @@ xfs_check_summary_counts(
 	 * superblock to be correct and we don't need to do anything here.
 	 * Otherwise, recalculate the summary counters.
 	 */
-	if ((!xfs_has_lazysbcount(mp) || xfs_is_clean(mp)) &&
-	    !xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS))
-		return 0;
+	if ((xfs_has_lazysbcount(mp) && !xfs_is_clean(mp)) ||
+	    xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS)) {
+		error = xfs_initialize_perag_data(mp, mp->m_sb.sb_agcount);
+		if (error)
+			return error;
+	}
 
-	return xfs_initialize_perag_data(mp, mp->m_sb.sb_agcount);
+	/*
+	 * Older kernels misused sb_frextents to reflect both incore
+	 * reservations made by running transactions and the actual count of
+	 * free rt extents in the ondisk metadata.  Transactions committed
+	 * during runtime can therefore contain a superblock update that
+	 * undercounts the number of free rt extents tracked in the rt bitmap.
+	 * A clean unmount record will have the correct frextents value since
+	 * there can be no other transactions running at that point.
+	 *
+	 * If we're mounting the rt volume after recovering the log, recompute
+	 * frextents from the rtbitmap file to fix the inconsistency.
+	 */
+	if (xfs_has_realtime(mp) && !xfs_is_clean(mp)) {
+		error = xfs_rtalloc_reinit_frextents(mp);
+		if (error)
+			return error;
+	}
+
+	return 0;
 }
 
 /*
@@ -784,11 +807,6 @@ xfs_mountfs(
 		goto out_inodegc_shrinker;
 	}
 
-	/* Make sure the summary counts are ok. */
-	error = xfs_check_summary_counts(mp);
-	if (error)
-		goto out_log_dealloc;
-
 	/* Enable background inode inactivation workers. */
 	xfs_inodegc_start(mp);
 	xfs_blockgc_start(mp);
@@ -844,6 +862,11 @@ xfs_mountfs(
 		goto out_rele_rip;
 	}
 
+	/* Make sure the summary counts are ok. */
+	error = xfs_check_summary_counts(mp);
+	if (error)
+		goto out_rtunmount;
+
 	/*
 	 * If this is a read-only mount defer the superblock updates until
 	 * the next remount into writeable mode.  Otherwise we would never
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index b8c79ee791af..76f50e75f99c 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1284,6 +1284,43 @@ xfs_rtmount_init(
 	return 0;
 }
 
+static int
+xfs_rtalloc_count_frextent(
+	struct xfs_mount		*mp,
+	struct xfs_trans		*tp,
+	const struct xfs_rtalloc_rec	*rec,
+	void				*priv)
+{
+	uint64_t			*valp = priv;
+
+	*valp += rec->ar_extcount;
+	return 0;
+}
+
+/*
+ * Reinitialize the number of free realtime extents from the realtime bitmap.
+ * Callers must ensure that there is no other activity in the filesystem.
+ */
+int
+xfs_rtalloc_reinit_frextents(
+	struct xfs_mount	*mp)
+{
+	uint64_t		val = 0;
+	int			error;
+
+	xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
+	error = xfs_rtalloc_query_all(mp, NULL, xfs_rtalloc_count_frextent,
+			&val);
+	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_EXCL);
+	if (error)
+		return error;
+
+	spin_lock(&mp->m_sb_lock);
+	mp->m_sb.sb_frextents = val;
+	spin_unlock(&mp->m_sb_lock);
+	return 0;
+}
+
 /*
  * Get the bitmap and summary inodes and the summary cache into the mount
  * structure at mount time.
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 539d134f4f25..62c7ad79cbb6 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -135,6 +135,7 @@ bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
 int xfs_rtalloc_extent_is_free(struct xfs_mount *mp, struct xfs_trans *tp,
 			       xfs_rtblock_t start, xfs_extlen_t len,
 			       bool *is_free);
+int xfs_rtalloc_reinit_frextents(struct xfs_mount *mp);
 #else
 # define xfs_rtallocate_extent(t,b,min,max,l,f,p,rb)    (ENOSYS)
 # define xfs_rtfree_extent(t,b,l)                       (ENOSYS)
@@ -145,6 +146,7 @@ int xfs_rtalloc_extent_is_free(struct xfs_mount *mp, struct xfs_trans *tp,
 # define xfs_rtbuf_get(m,t,b,i,p)                       (ENOSYS)
 # define xfs_verify_rtbno(m, r)			(false)
 # define xfs_rtalloc_extent_is_free(m,t,s,l,i)          (ENOSYS)
+# define xfs_rtalloc_reinit_frextents(m)                (0)
 static inline int		/* error */
 xfs_rtmount_init(
 	xfs_mount_t	*mp)	/* file system mount structure */

