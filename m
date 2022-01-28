Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E0CDC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Jan 2022 22:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349548AbiA1WnE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:43:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344236AbiA1WnE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jan 2022 17:43:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDADDC061714
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jan 2022 14:43:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95F2AB80D2B
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jan 2022 22:43:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45EB6C340E7;
        Fri, 28 Jan 2022 22:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643409781;
        bh=jn94/Oia5Xr4IV2Op4f0V5z4rXnXGIRIN8c6FRWCbm4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nMYk4/TbJ4liRj6Z6hez4lk/UHRueUSUEP9Lg3jriMuBjIKRSNMKf1+xWArqgpYof
         154rhne8cq5XCNdas3iSo7iWPYiZ7TWwFcN3tXTN8Dlr8QFIXrA54VGY8n3TxCDNh6
         D+S5Tlwaw1AEuQ2E8RQj389BYts5VcH48DqcrYgdzgHqh68UQR/n3Ibe6tl4C7AsDg
         nbU7SzYtGKzTHdDoQpm58YJd/wwGLUc750aJjYC1jej0l/0DX9aiew1esWuz8OYcHD
         EaJ12j5AQdDiyYkCK+2VsI5n5rPzFbA1FxeqZ+Ihq1LmdhEZaU8JrZe8U0MBTH8Nvt
         kfxEusJbt5rsw==
Date:   Fri, 28 Jan 2022 14:43:00 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v1.1 39/45] libxfs: remove pointless *XFS_MOUNT* flags
Message-ID: <20220128224300.GK13540@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
 <164263805814.860211.18062742237091017727.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164263805814.860211.18062742237091017727.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Get rid of these flags and the m_flags field, since none of them do
anything anymore.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v1.1: add some clarifying comments, maintain same inode64 behavior
---
 db/attrset.c              |   12 ++++++++----
 include/xfs_mount.h       |    9 ++-------
 libxfs/init.c             |   31 ++++---------------------------
 libxfs/libxfs_priv.h      |   10 ----------
 libxlog/xfs_log_recover.c |    8 --------
 5 files changed, 14 insertions(+), 56 deletions(-)

diff --git a/db/attrset.c b/db/attrset.c
index 98a08a49..0d8d70a8 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -107,7 +107,10 @@ attr_set_f(
 			break;
 
 		case 'n':
-			mp->m_flags |= LIBXFS_MOUNT_COMPAT_ATTR;
+			/*
+			 * We never touch attr2 these days; leave this here to
+			 * avoid breaking scripts.
+			 */
 			break;
 
 		/* value length */
@@ -169,7 +172,6 @@ attr_set_f(
 	set_cur_inode(iocur_top->ino);
 
 out:
-	mp->m_flags &= ~LIBXFS_MOUNT_COMPAT_ATTR;
 	if (args.dp)
 		libxfs_irele(args.dp);
 	if (args.value)
@@ -211,7 +213,10 @@ attr_remove_f(
 			break;
 
 		case 'n':
-			mp->m_flags |= LIBXFS_MOUNT_COMPAT_ATTR;
+			/*
+			 * We never touch attr2 these days; leave this here to
+			 * avoid breaking scripts.
+			 */
 			break;
 
 		default:
@@ -254,7 +259,6 @@ attr_remove_f(
 	set_cur_inode(iocur_top->ino);
 
 out:
-	mp->m_flags &= ~LIBXFS_MOUNT_COMPAT_ATTR;
 	if (args.dp)
 		libxfs_irele(args.dp);
 	return 0;
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 52b699f1..37398fd3 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -79,7 +79,6 @@ typedef struct xfs_mount {
 	uint			m_alloc_set_aside; /* space we can't use */
 	uint			m_ag_max_usable; /* max space per AG */
 	struct radix_tree_root	m_perag_tree;
-	uint			m_flags;	/* global mount flags */
 	uint64_t		m_features;	/* active filesystem features */
 	unsigned long		m_opstate;	/* dynamic state flags */
 	bool			m_finobt_nores; /* no per-AG finobt resv. */
@@ -250,16 +249,12 @@ __XFS_UNSUPP_OPSTATE(readonly)
 __XFS_UNSUPP_OPSTATE(shutdown)
 
 #define LIBXFS_MOUNT_DEBUGGER		0x0001
-#define LIBXFS_MOUNT_32BITINODES	0x0002
-#define LIBXFS_MOUNT_32BITINOOPT	0x0004
-#define LIBXFS_MOUNT_COMPAT_ATTR	0x0008
-#define LIBXFS_MOUNT_ATTR2		0x0010
 #define LIBXFS_MOUNT_WANT_CORRUPTED	0x0020
 
 #define LIBXFS_BHASHSIZE(sbp) 		(1<<10)
 
-extern xfs_mount_t	*libxfs_mount (xfs_mount_t *, xfs_sb_t *,
-				dev_t, dev_t, dev_t, int);
+struct xfs_mount *libxfs_mount(struct xfs_mount *mp, struct xfs_sb *sb,
+		dev_t dev, dev_t logdev, dev_t rtdev, unsigned int flags);
 int libxfs_flush_mount(struct xfs_mount *mp);
 int		libxfs_umount(struct xfs_mount *mp);
 extern void	libxfs_rtmount_destroy (xfs_mount_t *);
diff --git a/libxfs/init.c b/libxfs/init.c
index e9235a35..18cbc59e 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -490,12 +490,7 @@ rtmount_init(
 
 /*
  * Set parameters for inode allocation heuristics, taking into account
- * filesystem size and inode32/inode64 mount options; i.e. specifically
- * whether or not XFS_MOUNT_SMALL_INUMS is set.
- *
- * Inode allocation patterns are altered only if inode32 is requested
- * (XFS_MOUNT_SMALL_INUMS), and the filesystem is sufficiently large.
- * If altered, XFS_MOUNT_32BITINODES is set as well.
+ * filesystem size.
  *
  * An agcount independent of that in the mount structure is provided
  * because in the growfs case, mp->m_sb.sb_agcount is not yet updated
@@ -531,22 +526,8 @@ xfs_set_inode_alloc(
 		max_metadata = agcount;
 	}
 
-	/* Get the last possible inode in the filesystem */
-	agino =	XFS_AGB_TO_AGINO(mp, sbp->sb_agblocks - 1);
-	ino = XFS_AGINO_TO_INO(mp, agcount - 1, agino);
-
-	/*
-	 * If user asked for no more than 32-bit inodes, and the fs is
-	 * sufficiently large, set XFS_MOUNT_32BITINODES if we must alter
-	 * the allocator to accommodate the request.
-	 */
-	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) && ino > XFS_MAXINUMBER_32) {
-		xfs_set_inode32(mp);
-		mp->m_flags |= XFS_MOUNT_32BITINODES;
-	} else {
-		xfs_clear_inode32(mp);
-		mp->m_flags &= ~XFS_MOUNT_32BITINODES;
-	}
+	/* There is no inode32 mount option in userspace, so clear it. */
+	xfs_clear_inode32(mp);
 
 	for (index = 0; index < agcount; index++) {
 		struct xfs_perag	*pag;
@@ -718,7 +699,7 @@ libxfs_mount(
 	dev_t			dev,
 	dev_t			logdev,
 	dev_t			rtdev,
-	int			flags)
+	unsigned int		flags)
 {
 	struct xfs_buf		*bp;
 	struct xfs_sb		*sbp;
@@ -733,7 +714,6 @@ libxfs_mount(
 	libxfs_buftarg_init(mp, dev, logdev, rtdev);
 
 	mp->m_finobt_nores = true;
-	mp->m_flags = (LIBXFS_MOUNT_32BITINODES|LIBXFS_MOUNT_32BITINOOPT);
 	xfs_set_inode32(mp);
 	mp->m_sb = *sb;
 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_KERNEL);
@@ -799,9 +779,6 @@ libxfs_mount(
 
 	xfs_da_mount(mp);
 
-	if (xfs_has_attr2(mp))
-		mp->m_flags |= LIBXFS_MOUNT_ATTR2;
-
 	/* Initialize the precomputed transaction reservations values */
 	xfs_trans_init(mp);
 
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 2b72751d..b94ff41e 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -442,16 +442,6 @@ void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
 #define xfs_buf_mark_corrupt(bp) __xfs_buf_mark_corrupt((bp), __this_address)
 
 /* mount stuff */
-#define XFS_MOUNT_32BITINODES		LIBXFS_MOUNT_32BITINODES
-#define XFS_MOUNT_ATTR2			LIBXFS_MOUNT_ATTR2
-#define XFS_MOUNT_SMALL_INUMS		0	/* ignored in userspace */
-#define XFS_MOUNT_WSYNC			0	/* ignored in userspace */
-#define XFS_MOUNT_NOALIGN		0	/* ignored in userspace */
-#define XFS_MOUNT_IKEEP			0	/* ignored in userspace */
-#define XFS_MOUNT_SWALLOC		0	/* ignored in userspace */
-#define XFS_MOUNT_RDONLY		0	/* ignored in userspace */
-#define XFS_MOUNT_BAD_SUMMARY		0	/* ignored in userspace */
-
 #define xfs_trans_set_sync(tp)		((void) 0)
 #define xfs_trans_buf_set_type(tp, bp, t)	({	\
 	int __t = (t);					\
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index 592e4502..bb52af55 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -820,14 +820,6 @@ xlog_find_tail(
 			xlog_assign_atomic_lsn(&log->l_last_sync_lsn,
 					log->l_curr_cycle, after_umount_blk);
 			*tail_blk = after_umount_blk;
-
-			/*
-			 * Note that the unmount was clean. If the unmount
-			 * was not clean, we need to know this to rebuild the
-			 * superblock counters from the perag headers if we
-			 * have a filesystem using non-persistent counters.
-			 */
-			log->l_mp->m_flags |= XFS_MOUNT_WAS_CLEAN;
 		}
 	}
 
