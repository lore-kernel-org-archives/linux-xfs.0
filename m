Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 530DBC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236092AbiLaB2T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:28:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236091AbiLaB2S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:28:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3C51DF18
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:28:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 906A0B81DED
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6BBC433EF;
        Sat, 31 Dec 2022 01:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450095;
        bh=TBQB+myFor72BEdjPpqdyIyQ5EVN1BYYRwIFfBcw5mk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Qlw+eDvedbOwHypAquxE752O+aFl0eKKVsC2L/ab8sMbw8ImQg4byfTal3c2BM+Z+
         L/qwRXQP6wLsYUHUcrJpInBAK4HMSu2rVeIpGcL7zu9rkuuv94THmbuJ9FcOPHzMGd
         jlKWrUR+5c27Bw/AfIYSds73UbdPGPHfO9XTyMyDc4dLcJr1QNgxXh/D7KXNYfWI6+
         kCydKrfxbQJ7fHWQYD+MmCFsReI5W5wZ2Yv1AWn7EyV5PASXXnFQjfpKCOdnzriq59
         9UIi7QQWLOO4qGPoEZaiednUABsGi+DHkNgW7rUZPfsQvu1VY9Fy7hR+DuNtcLepVl
         DmR51Emc+Dx4g==
Subject: [PATCH 03/22] xfs: check the realtime superblock at mount time
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:53 -0800
Message-ID: <167243867313.712847.15088416523614287132.stgit@magnolia>
In-Reply-To: <167243867242.712847.10106105868862621775.stgit@magnolia>
References: <167243867242.712847.10106105868862621775.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Check the realtime superblock at mount time, to ensure that the label
actually matches the primary superblock.  If the rt superblock is good,
attach it to the xfs_mount so that the log can use ordered buffers to
keep this primary in sync with the primary super on the data device.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_mount.h   |    1 +
 fs/xfs/xfs_rtalloc.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_rtalloc.h |    5 +++++
 fs/xfs/xfs_super.c   |   16 ++++++++++++++--
 4 files changed, 70 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 674938008a97..7f0a80a8dcd4 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -82,6 +82,7 @@ typedef struct xfs_mount {
 	struct super_block	*m_super;
 	struct xfs_ail		*m_ail;		/* fs active log item list */
 	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
+	struct xfs_buf		*m_rtsb_bp;	/* realtime superblock */
 	char			*m_rtname;	/* realtime device name */
 	char			*m_logname;	/* external log device name */
 	struct xfs_da_geometry	*m_dir_geo;	/* directory block geometry */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 3b13352cfbfc..9c842237c452 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1263,6 +1263,56 @@ xfs_rtallocate_extent(
 	return 0;
 }
 
+/* Read the primary realtime group's superblock and attach it to the mount. */
+int
+xfs_rtmount_readsb(
+	struct xfs_mount	*mp)
+{
+	struct xfs_buf		*bp;
+	int			error;
+
+	if (!xfs_has_rtgroups(mp))
+		return 0;
+	if (mp->m_sb.sb_rblocks == 0)
+		return 0;
+	if (mp->m_rtdev_targp == NULL) {
+		xfs_warn(mp,
+	"Filesystem has a realtime volume, use rtdev=device option");
+		return -ENODEV;
+	}
+
+	/* m_blkbb_log is not set up yet */
+	error = xfs_buf_read_uncached(mp->m_rtdev_targp, XFS_RTSB_DADDR,
+			mp->m_sb.sb_blocksize >> BBSHIFT, XBF_NO_IOACCT, &bp,
+			&xfs_rtsb_buf_ops);
+	if (error) {
+		xfs_warn(mp, "rt sb validate failed with error %d.", error);
+		/* bad CRC means corrupted metadata */
+		if (error == -EFSBADCRC)
+			error = -EFSCORRUPTED;
+		return error;
+	}
+
+	mp->m_rtsb_bp = bp;
+	xfs_buf_unlock(bp);
+	return 0;
+}
+
+/* Detach the realtime superblock from the mount and free it. */
+void
+xfs_rtmount_freesb(
+	struct xfs_mount	*mp)
+{
+	struct xfs_buf		*bp = mp->m_rtsb_bp;
+
+	if (!bp)
+		return;
+
+	xfs_buf_lock(bp);
+	mp->m_rtsb_bp = NULL;
+	xfs_buf_relse(bp);
+}
+
 /*
  * Initialize realtime fields in the mount structure.
  */
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 5ac9c15948c8..d0fd49db77bd 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -33,6 +33,9 @@ xfs_rtallocate_extent(
 	xfs_rtxnum_t		*rtblock); /* out: start rtext allocated */
 
 
+int xfs_rtmount_readsb(struct xfs_mount *mp);
+void xfs_rtmount_freesb(struct xfs_mount *mp);
+
 /*
  * Initialize realtime fields in the mount structure.
  */
@@ -81,6 +84,8 @@ int xfs_rtfile_convert_unwritten(struct xfs_inode *ip, loff_t pos,
 # define xfs_rtpick_extent(m,t,l,rb)			(-ENOSYS)
 # define xfs_growfs_rt(mp,in)				(-ENOSYS)
 # define xfs_rtalloc_reinit_frextents(m)		(0)
+# define xfs_rtmount_readsb(mp)				(0)
+# define xfs_rtmount_freesb(mp)				((void)0)
 static inline int		/* error */
 xfs_rtmount_init(
 	xfs_mount_t	*mp)	/* file system mount structure */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 737c51333d09..bfe93ca6eed4 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -44,6 +44,7 @@
 #include "scrub/rcbag_btree.h"
 #include "xfs_swapext_item.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_rtalloc.h"
 
 #include <linux/magic.h>
 #include <linux/fs_context.h>
@@ -1117,6 +1118,7 @@ xfs_fs_put_super(
 	xfs_filestream_unmount(mp);
 	xfs_unmountfs(mp);
 
+	xfs_rtmount_freesb(mp);
 	xfs_freesb(mp);
 	free_percpu(mp->m_stats.xs_stats);
 	xfs_mount_list_del(mp);
@@ -1599,9 +1601,13 @@ xfs_fs_fill_super(
 		goto out_free_sb;
 	}
 
+	error = xfs_rtmount_readsb(mp);
+	if (error)
+		goto out_free_sb;
+
 	error = xfs_filestream_mount(mp);
 	if (error)
-		goto out_free_sb;
+		goto out_free_rtsb;
 
 	/*
 	 * we must configure the block size in the superblock before we run the
@@ -1645,6 +1651,10 @@ xfs_fs_fill_super(
 		xfs_warn(mp,
 "EXPERIMENTAL metadata directory feature in use. Use at your own risk!");
 
+	if (xfs_has_rtgroups(mp))
+		xfs_warn(mp,
+"EXPERIMENTAL realtime allocation group feature in use. Use at your own risk!");
+
 	if (xfs_has_reflink(mp)) {
 		if (mp->m_sb.sb_rblocks) {
 			xfs_alert(mp,
@@ -1689,6 +1699,8 @@ xfs_fs_fill_super(
 
  out_filestream_unmount:
 	xfs_filestream_unmount(mp);
+ out_free_rtsb:
+	xfs_rtmount_freesb(mp);
  out_free_sb:
 	xfs_freesb(mp);
  out_free_stats:
@@ -1710,7 +1722,7 @@ xfs_fs_fill_super(
  out_unmount:
 	xfs_filestream_unmount(mp);
 	xfs_unmountfs(mp);
-	goto out_free_sb;
+	goto out_free_rtsb;
 }
 
 static int

