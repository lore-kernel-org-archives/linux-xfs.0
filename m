Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67116C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:21:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240426AbiATAVB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:21:01 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46692 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240414AbiATAVA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:21:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8366B81A85
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:20:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3C9C004E1;
        Thu, 20 Jan 2022 00:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638058;
        bh=wwS9GCUZ5BFXlf1fMiiB2SxUYJOv20BGwry0PhKUn0o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dmO9WoUtt72t6a26axMMA0Ct1YLjt9+LG2XxQRjIyj4thqz4Dck8P2BZany3z6kh4
         2rLXiLtx5nNGG2LEynfzsN/1cCdglFDs0N7rrQIVtiAWpw13nhhrHFfdcdtk+Hh0pJ
         6kbq7nHjJyr2SmGuGjVBBmKk/lm7Kdqe01jQ7XrsnjBhEtaJTkG0kQWjotWw0d/3PQ
         D0KE0+cSKBEeyYxxCG0OBEj4OOQ12G0/sDQf/Z1vBUG3G/ruP8sz9pQIVe3LpRK2cV
         kKyxw6HqXvm2LL35OYl8vCNcFFziYbM7UckulmFjnL60kEOD/c2RvXxE22Gdb64oTU
         p2bkR8tRatTaQ==
Subject: [PATCH 39/45] libxfs: remove pointless *XFS_MOUNT* flags
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:20:58 -0800
Message-ID: <164263805814.860211.18062742237091017727.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Get rid of these flags and the m_flags field, since none of them do
anything anymore.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/attrset.c              |    4 ----
 include/xfs_mount.h       |    9 ++-------
 libxfs/init.c             |   13 +++----------
 libxfs/libxfs_priv.h      |   10 ----------
 libxlog/xfs_log_recover.c |    1 -
 5 files changed, 5 insertions(+), 32 deletions(-)


diff --git a/db/attrset.c b/db/attrset.c
index 98a08a49..6441809a 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -107,7 +107,6 @@ attr_set_f(
 			break;
 
 		case 'n':
-			mp->m_flags |= LIBXFS_MOUNT_COMPAT_ATTR;
 			break;
 
 		/* value length */
@@ -169,7 +168,6 @@ attr_set_f(
 	set_cur_inode(iocur_top->ino);
 
 out:
-	mp->m_flags &= ~LIBXFS_MOUNT_COMPAT_ATTR;
 	if (args.dp)
 		libxfs_irele(args.dp);
 	if (args.value)
@@ -211,7 +209,6 @@ attr_remove_f(
 			break;
 
 		case 'n':
-			mp->m_flags |= LIBXFS_MOUNT_COMPAT_ATTR;
 			break;
 
 		default:
@@ -254,7 +251,6 @@ attr_remove_f(
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
index e9235a35..093ce878 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -540,13 +540,10 @@ xfs_set_inode_alloc(
 	 * sufficiently large, set XFS_MOUNT_32BITINODES if we must alter
 	 * the allocator to accommodate the request.
 	 */
-	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) && ino > XFS_MAXINUMBER_32) {
+	if (ino > XFS_MAXINUMBER_32)
 		xfs_set_inode32(mp);
-		mp->m_flags |= XFS_MOUNT_32BITINODES;
-	} else {
+	else
 		xfs_clear_inode32(mp);
-		mp->m_flags &= ~XFS_MOUNT_32BITINODES;
-	}
 
 	for (index = 0; index < agcount; index++) {
 		struct xfs_perag	*pag;
@@ -718,7 +715,7 @@ libxfs_mount(
 	dev_t			dev,
 	dev_t			logdev,
 	dev_t			rtdev,
-	int			flags)
+	unsigned int		flags)
 {
 	struct xfs_buf		*bp;
 	struct xfs_sb		*sbp;
@@ -733,7 +730,6 @@ libxfs_mount(
 	libxfs_buftarg_init(mp, dev, logdev, rtdev);
 
 	mp->m_finobt_nores = true;
-	mp->m_flags = (LIBXFS_MOUNT_32BITINODES|LIBXFS_MOUNT_32BITINOOPT);
 	xfs_set_inode32(mp);
 	mp->m_sb = *sb;
 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_KERNEL);
@@ -799,9 +795,6 @@ libxfs_mount(
 
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
index 592e4502..d43914b9 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -827,7 +827,6 @@ xlog_find_tail(
 			 * superblock counters from the perag headers if we
 			 * have a filesystem using non-persistent counters.
 			 */
-			log->l_mp->m_flags |= XFS_MOUNT_WAS_CLEAN;
 		}
 	}
 

