Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:45517 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725942AbeHTIDD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Aug 2018 04:03:03 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1frc7b-0006Rz-4F
        for linux-xfs@vger.kernel.org; Mon, 20 Aug 2018 14:48:55 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1frc7b-0000QD-38
        for linux-xfs@vger.kernel.org; Mon, 20 Aug 2018 14:48:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/10] xfs: consolidate mount option features in m_features
Date: Mon, 20 Aug 2018 14:48:44 +1000
Message-Id: <20180820044851.414-4-david@fromorbit.com>
In-Reply-To: <20180820044851.414-1-david@fromorbit.com>
References: <20180820044851.414-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

This provides separation of mount time feature flags from runtime
mount flagsi and mount option state. It also makes the feature
checks use the same interface as the superblock features. i.e. we
don't care if the feature is enabled by superblock flags or mount
options, we just care if it's enabled or not.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.h | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 92d947f17c69..74a128fe316b 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -225,6 +225,21 @@ typedef struct xfs_mount {
 #define XFS_FEAT_META_UUID	(1ULL << 20)	/* metadata UUID */
 #define XFS_FEAT_REALTIME	(1ULL << 21)	/* realtime device present */
 
+#define XFS_FEAT_WSYNC		(1ULL << 22)	/* synchronous metadata ops */
+#define XFS_FEAT_DIRSYNC	(1ULL << 23)	/* synchronous directory ops */
+#define XFS_FEAT_DISCARD	(1ULL << 24)	/* discard unused blocks */
+#define XFS_FEAT_GRPID		(1ULL << 25)	/* group-ID assigned from directory */
+#define XFS_FEAT_SMALL_INUMS	(1ULL << 26)	/* user wants 32bit inodes */
+#define XFS_FEAT_IKEEP		(1ULL << 27)	/* keep empty inode clusters*/
+#define XFS_FEAT_SWALLOC	(1ULL << 28)	/* stripe width allocation */
+#define XFS_FEAT_FILESTREAMS	(1ULL << 29)	/* enable the filestreams
+						   allocator */
+#define XFS_FEAT_DAX		(1ULL << 30)	/* TEST ONLY! */
+#define XFS_FEAT_COMPAT_IOSIZE	(1ULL << 31)	/* don't report large preferred
+						 * I/O size in stat() */
+#define XFS_FEAT_NORECOVERY	(1ULL << 32)	/* no recovery - dirty fs */
+#define XFS_FEAT_NOUUID		(1ULL << 33)	/* ignore uuid during mount */
+
 #define __XFS_HAS_FEAT(name, NAME) \
 static inline bool xfs_has_ ## name (struct xfs_mount *mp) \
 { \
@@ -250,6 +265,7 @@ static inline void xfs_feat_remove_ ## name (struct xfs_mount *mp) \
 }
 
 
+/* superblock features */
 __XFS_HAS_ADDFEAT(attr, ATTR)
 __XFS_HAS_FEAT(nlink, NLINK)
 __XFS_HAS_ADDFEAT(quota, QUOTA)
@@ -274,6 +290,26 @@ __XFS_HAS_FEAT(metauuid, META_UUID)
 __XFS_HAS_FEAT(realtime, REALTIME)
 
 
+/*
+ * Mount features
+ *
+ * These do not change dynamically - features that can come and go,
+ * such as 32 bit inodes and read-only state, are kept as flags rather than
+ * features.
+ */
+__XFS_HAS_FEAT(wsync, WSYNC)
+__XFS_HAS_FEAT(dirsync, DIRSYNC)
+__XFS_HAS_FEAT(discard, DISCARD)
+__XFS_HAS_FEAT(grpid, GRPID)
+__XFS_HAS_FEAT(small_inums, SMALL_INUMS)
+__XFS_HAS_FEAT(ikeep, IKEEP)
+__XFS_HAS_FEAT(swalloc, SWALLOC)
+__XFS_HAS_FEAT(filestreams, FILESTREAMS)
+__XFS_HAS_FEAT(dax, DAX)
+__XFS_HAS_FEAT(compat_iosize, COMPAT_IOSIZE)
+__XFS_HAS_FEAT(norecovery, NORECOVERY)
+__XFS_HAS_FEAT(nouuid, NOUUID)
+
 /*
  * Flags for m_flags.
  */
-- 
2.17.0
