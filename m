Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 08 Oct 2008 21:20:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m994JxUB000958
	for <xfs@oss.sgi.com>; Wed, 8 Oct 2008 21:19:59 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AEC7113C37E2
	for <xfs@oss.sgi.com>; Wed,  8 Oct 2008 21:21:38 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id f8AvTcbmHvmRdT5j for <xfs@oss.sgi.com>; Wed, 08 Oct 2008 21:21:38 -0700 (PDT)
Date: Thu, 9 Oct 2008 15:21:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/5]: XFS: Prevent use-after-free caused by synchronous
	inode reclaim
Message-ID: <20081009042134.GD9597@disturbed>
References: <1223416332-7026-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1223416332-7026-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org

Folks,

The following patch fixes a use after free I just found.
It appears that switching between SLAB and SLUB seems to
turn off slab/slub memory poisoning, so i dƣdn't realise
I'd be running for some time without poisoning turned on.
Once I turned poisoning back on I found this use-after-free
immediately on the first unmount trying to reclaim a clean
realtime bitmap inode.

With this patch, the netire patchset that I posted yesterday
passes xfsqa with memory poisoning turned on.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


XFS: Prevent use-after-free caused by synchronous inode reclaim

With the combined linux and XFS inode, we need to ensure that the
combined structure is not freed before the generic code is finished
with the inode. As it turns out, there is a case where the XFS inode
is freed before the linux inode - when xfs_reclaim() is called from
->clear_inode() on a clean inode, the xfs inode is freed during
that call. The generic code references the inode after the
->clear_inode() call, so this is a use after free situation.

Fix the problem by moving the xfs_reclaim() call to ->destroy_inode()
instead of in ->clear_inode(). This ensures the combined inode
structure is not freed until after the generic code has finished
with it.
---
 fs/xfs/linux-2.6/xfs_super.c |   32 ++++++++++++++------------------
 1 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index b893f8c..7e5a9b7 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -875,13 +875,18 @@ xfs_fs_alloc_inode(
 }
 
 /*
- * we need to provide an empty inode free function to prevent
- * the generic code from trying to free our combined inode.
+ * Now that the generic code is guaranteed not to be accessing
+ * the linux inode, we can reclaim the inode.
  */
 STATIC void
 xfs_fs_destroy_inode(
 	struct inode	*inode)
 {
+	xfs_inode_t		*ip = XFS_I(inode);
+
+	XFS_STATS_INC(vn_reclaim);
+	if (xfs_reclaim(ip))
+		panic("%s: cannot reclaim 0x%p\n", __func__, inode);
 }
 
 /*
@@ -958,22 +963,13 @@ xfs_fs_clear_inode(
 {
 	xfs_inode_t		*ip = XFS_I(inode);
 
-	/*
-	 * ip can be null when xfs_iget_core calls xfs_idestroy if we
-	 * find an inode with di_mode == 0 but without IGET_CREATE set.
-	 */
-	if (ip) {
-		xfs_itrace_entry(ip);
-		XFS_STATS_INC(vn_rele);
-		XFS_STATS_INC(vn_remove);
-		XFS_STATS_INC(vn_reclaim);
-		XFS_STATS_DEC(vn_active);
-
-		xfs_inactive(ip);
-		xfs_iflags_clear(ip, XFS_IMODIFIED);
-		if (xfs_reclaim(ip))
-			panic("%s: cannot reclaim 0x%p\n", __func__, inode);
-	}
+	xfs_itrace_entry(ip);
+	XFS_STATS_INC(vn_rele);
+	XFS_STATS_INC(vn_remove);
+	XFS_STATS_DEC(vn_active);
+
+	xfs_inactive(ip);
+	xfs_iflags_clear(ip, XFS_IMODIFIED);
 }
 
 STATIC void
