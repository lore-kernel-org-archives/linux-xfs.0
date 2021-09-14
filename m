Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E35F7C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:43:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C87F8610D1
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:43:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237213AbhINCop (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 22:44:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:54062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235706AbhINCoo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 22:44:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AC65610D1;
        Tue, 14 Sep 2021 02:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631587408;
        bh=jhc/LzY7PKw1UL+pDL3snu2U824RWKsMEcZQhET9ztA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=J6lkSmwBTYJ+Meogx10LxR5IUydywx5fJSVSQ07Yqr+/qlVOfzTGv6lYftM6okhod
         la1fwoqdYJdTBKW/mq4AwFI6IJOmqS79xPK9S4krl1HcXwcU41xpehsJsTpvFxnbPw
         BtXwnd5n5GwFCtih/f5YSCaXpNYcMzOhB6x7YGB9Ju0LH777d3n3ZAAZlr+N6EI5Cl
         WdZQIQp0Cix1XU79GMeY7Re6Y511yxEDVMntIHyEVaYAXwTN5wS3Y23KPERj20KlM2
         3dPTwpRf4f8g12aYXhHsUKbc/tlLvMERZcClQcf6sPfZxJ+zerELU46At3Bc4UMbZ0
         Y1AuiBH6oWmpQ==
Subject: [PATCH 38/43] libxfs: remove pointless *XFS_MOUNT* flags
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 13 Sep 2021 19:43:27 -0700
Message-ID: <163158740784.1604118.16211586847965140773.stgit@magnolia>
In-Reply-To: <163158719952.1604118.14415288328687941574.stgit@magnolia>
References: <163158719952.1604118.14415288328687941574.stgit@magnolia>
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
 include/xfs_mount.h       |    7 +------
 libxfs/init.c             |   11 ++---------
 libxfs/libxfs_priv.h      |   10 ----------
 libxlog/xfs_log_recover.c |    1 -
 5 files changed, 3 insertions(+), 30 deletions(-)


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
index 1f4f4390..41fd374a 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -77,7 +77,6 @@ typedef struct xfs_mount {
 	uint			m_alloc_set_aside; /* space we can't use */
 	uint			m_ag_max_usable; /* max space per AG */
 	struct radix_tree_root	m_perag_tree;
-	uint			m_flags;	/* global mount flags */
 	uint64_t		m_features;	/* active filesystem features */
 	unsigned long		m_opstate;	/* dynamic state flags */
 	bool			m_finobt_nores; /* no per-AG finobt resv. */
@@ -249,11 +248,7 @@ __XFS_UNSUPP_OPSTATE(readonly)
 __XFS_UNSUPP_OPSTATE(shutdown)
 
 #define LIBXFS_MOUNT_DEBUGGER		0x0001
-#define LIBXFS_MOUNT_32BITINODES	0x0002
-#define LIBXFS_MOUNT_32BITINOOPT	0x0004
-#define LIBXFS_MOUNT_COMPAT_ATTR	0x0008
-#define LIBXFS_MOUNT_ATTR2		0x0010
-#define LIBXFS_MOUNT_WANT_CORRUPTED	0x0020
+#define LIBXFS_MOUNT_WANT_CORRUPTED	0x0002
 
 #define LIBXFS_BHASHSIZE(sbp) 		(1<<10)
 
diff --git a/libxfs/init.c b/libxfs/init.c
index a96f5389..7845ba2c 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -532,13 +532,10 @@ xfs_set_inode_alloc(
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
@@ -725,7 +722,6 @@ libxfs_mount(
 	libxfs_buftarg_init(mp, dev, logdev, rtdev);
 
 	mp->m_finobt_nores = true;
-	mp->m_flags = (LIBXFS_MOUNT_32BITINODES|LIBXFS_MOUNT_32BITINOOPT);
 	xfs_set_inode32(mp);
 	mp->m_sb = *sb;
 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_KERNEL);
@@ -789,9 +785,6 @@ libxfs_mount(
 
 	xfs_da_mount(mp);
 
-	if (xfs_has_attr2(mp))
-		mp->m_flags |= LIBXFS_MOUNT_ATTR2;
-
 	/* Initialize the precomputed transaction reservations values */
 	xfs_trans_init(mp);
 
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 3fc13c52..75f26f36 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -443,16 +443,6 @@ void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
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
 

