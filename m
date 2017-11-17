Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:34650 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751590AbdKQQ5H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 11:57:07 -0500
Date: Fri, 17 Nov 2017 08:57:06 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH for 4.15] libxfs: fix dev_t handling in inode forks
Message-ID: <20171117165706.GB17447@infradead.org>
References: <20171116011505.GH5119@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171116011505.GH5119@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

Hmm.

I guess we should just clean up the calling conventions, and keep
the conversion helpers in xfs_linux.h so that xfsprogs can turn them
into noops.

Something like the untested patch for the kernel space, xfsprogs would
then just stub out the two inlines to return the passed in value.

---
>From e0ed26ab66774c1611e71a3c290efbe4e21d483c Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Fri, 17 Nov 2017 17:55:48 +0100
Subject: xfs: abstract out dev_t conversions

And move them to xfs_linux.h so that xfsprogs can stub them out more
easily.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_fork.c |  8 ++------
 fs/xfs/xfs_linux.h             | 10 ++++++++++
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 1c90ec41e9df..c79a1616b79d 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -42,11 +42,6 @@ STATIC int xfs_iformat_local(xfs_inode_t *, xfs_dinode_t *, int, int);
 STATIC int xfs_iformat_extents(xfs_inode_t *, xfs_dinode_t *, int);
 STATIC int xfs_iformat_btree(xfs_inode_t *, xfs_dinode_t *, int);
 
-static inline dev_t xfs_to_linux_dev_t(xfs_dev_t dev)
-{
-	return MKDEV(sysv_major(dev) & 0x1ff, sysv_minor(dev));
-}
-
 /*
  * Copy inode type and data and attr format specific information from the
  * on-disk inode to the in-core inode and fork structures.  For fifos, devices,
@@ -792,7 +787,8 @@ xfs_iflush_fork(
 	case XFS_DINODE_FMT_DEV:
 		if (iip->ili_fields & XFS_ILOG_DEV) {
 			ASSERT(whichfork == XFS_DATA_FORK);
-			xfs_dinode_put_rdev(dip, sysv_encode_dev(VFS_I(ip)->i_rdev));
+			xfs_dinode_put_rdev(dip,
+					linux_to_xfs_dev_t(VFS_I(ip)->i_rdev));
 		}
 		break;
 
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 6282bfc1afa9..99562ec0de56 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -204,6 +204,16 @@ static inline kgid_t xfs_gid_to_kgid(uint32_t gid)
 	return make_kgid(&init_user_ns, gid);
 }
 
+static inline dev_t xfs_to_linux_dev_t(xfs_dev_t dev)
+{
+	return MKDEV(sysv_major(dev) & 0x1ff, sysv_minor(dev));
+}
+
+static inline xfs_dev_t linux_to_xfs_dev_t(dev_t dev)
+{
+	return sysv_encode_dev(dev);
+}
+
 /*
  * Various platform dependent calls that don't fit anywhere else
  */
-- 
2.14.2

