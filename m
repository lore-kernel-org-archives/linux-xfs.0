Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36062 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1757096AbdJKCi4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Oct 2017 22:38:56 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.21/8.16.0.21) with SMTP id v9B2Xe7Y009401
        for <linux-xfs@vger.kernel.org>; Tue, 10 Oct 2017 19:38:56 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2dha5503s6-4
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 10 Oct 2017 19:38:56 -0700
From: Richard Wareing <rwareing@fb.com>
Subject: [PATCH v6 2/3] xfs: Set realtime flag based on initial allocation size
Date: Tue, 10 Oct 2017 19:37:51 -0700
Message-ID: <20171011023752.1373259-3-rwareing@fb.com>
In-Reply-To: <20171011023752.1373259-1-rwareing@fb.com>
References: <20171011023752.1373259-1-rwareing@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org

- The rt_alloc_min sysfs option automatically selects the device (data
  device, or realtime) based on the size of the initial allocation of the
  file.
- This option can be used to route the storage of small files (and the
  inefficient workloads associated with them) to a suitable storage
  device such a SSD, while larger allocations are sent to a traditional
  HDD.
- Supports writes via O_DIRECT, buffered (i.e. page cache), and
  pre-allocations (i.e. fallocate)
- Available only when kernel is compiled w/ CONFIG_XFS_RT option.

Signed-off-by: Richard Wareing <rwareing@fb.com>
---
Changes since v5:
* xfs_inode_select_target renamed to xfs_inode_select_rt_target and returns
  boolean to indicate if realtime device target is desired.
* Introduction of XFS_BMAPI_RTDATA which provides signal to the
  xfs_bmapi_allocate function the realtime flag must be set on the inode & the
  inode logged.
* Manual setting of the realtime flag by ioctl or directory rt inherit flag
  now takes precedence over the policy.
* Documentation

Changes since v4:
* Added xfs_inode_select_target function to hold target selection
  code
* XFS_IS_REALTIME_MOUNT check now moved inside xfs_inode_select_target
  function for better gating
* Improved consistency in the sysfs set behavior
* Style fixes

Changes since v3:
* Now functions via initial allocation regardless of O_DIRECT, buffered or
  pre-allocation code paths.  Provides a consistent user-experience.
* I Did do some experiments putting this in the xfs_bmapi_write code path
  however pre-allocation accounting unfortunately prevents this cleaner
  approach.  As such, this proved to be the cleanest and functional approach.
* No longer a mount option, now a sysfs tunable

 Documentation/filesystems/xfs.txt | 21 +++++++++++++++-
 fs/xfs/libxfs/xfs_bmap.c          | 35 +++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_bmap.h          |  3 +++
 fs/xfs/xfs_bmap_util.c            |  3 +++
 fs/xfs/xfs_inode.c                | 18 +++++++++-----
 fs/xfs/xfs_iomap.c                | 19 ++++++++++++---
 fs/xfs/xfs_mount.h                |  1 +
 fs/xfs/xfs_rtalloc.c              | 50 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_rtalloc.h              |  2 ++
 fs/xfs/xfs_sysfs.c                | 42 ++++++++++++++++++++++++++++++++
 10 files changed, 184 insertions(+), 10 deletions(-)

diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
index 3b9b5c1..0763972 100644
--- a/Documentation/filesystems/xfs.txt
+++ b/Documentation/filesystems/xfs.txt
@@ -94,7 +94,7 @@ default behaviour.
 	When inode64 is specified, it indicates that XFS is allowed
 	to create inodes at any location in the filesystem,
 	including those which will result in inode numbers occupying
-	more than 32 bits of significance. 
+	more than 32 bits of significance.
 
 	inode32 is provided for backwards compatibility with older
 	systems and applications, since 64 bits inode numbers might
@@ -467,3 +467,22 @@ the class and error context. For example, the default values for
 "metadata/ENODEV" are "0" rather than "-1" so that this error handler defaults
 to "fail immediately" behaviour. This is done because ENODEV is a fatal,
 unrecoverable error no matter how many times the metadata IO is retried.
+
+Realtime Device Sysfs Options
+=============================
+
+When using a realtime sub-volume, the following sysfs options are supported:
+
+  /sys/fs/xfs/<dev>/rt_alloc_min
+  (Units: bytes  Min: 0  Default: 0  Max: INT_MAX)
+	When set, the file will be allocated blocks from the realtime device if the
+	initial allocation request size (in bytes) is equal to or above this value.
+	For XFS use-cases where appends are unlikely or not supported, this option
+	can be used to place smaller files on a the data device (typically an SSD),
+	while larger files are placed on the realtime device (typically an HDD).
+
+	Any files which have the realtime flag set by an ioctl call or realtime
+	inheritance flag on the directory will not be affected by this option.
+	Buffered, direct IO and pre-allocation are supported.
+
+	Setting the value to "0" disables this behavior.
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a7048eaf..deb9ffd 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4185,6 +4185,39 @@ xfs_bmapi_reserve_delalloc(
 	return error;
 }
 
+/*
+ * This function will set the XFS_DIFLAG_REALTIME flag on the inode if
+ * the XFS_BMAPI_RTDATA flag is set on the xfs_bmalloca struct.
+ *
+ * This function is only valid for realtime mounts, and only on the initial
+ * allocation for the file.
+ *
+ */
+void
+xfs_bmapi_rt_data_flag(
+	struct xfs_mount	*mp,
+	struct xfs_bmalloca	*bma)
+{
+
+	/* Only valid if this is a realtime mount */
+	if (!XFS_IS_REALTIME_MOUNT(mp))
+		return;
+
+	/* Only valid if file is empty */
+	if (!(bma->datatype & XFS_ALLOC_INITIAL_USER_DATA))
+		return;
+
+	/* Nothing to do, realtime flag already set */
+	if (bma->ip->i_d.di_flags & XFS_DIFLAG_REALTIME)
+		return;
+
+	/* Set realtime flag and log it if RTDATA flag is set */
+	if (bma->flags & XFS_BMAPI_RTDATA) {
+		bma->ip->i_d.di_flags |= XFS_DIFLAG_REALTIME;
+		bma->logflags |= XFS_ILOG_CORE;
+	}
+}
+
 static int
 xfs_bmapi_allocate(
 	struct xfs_bmalloca	*bma)
@@ -4235,6 +4268,8 @@ xfs_bmapi_allocate(
 
 	bma->minlen = (bma->flags & XFS_BMAPI_CONTIG) ? bma->length : 1;
 
+	xfs_bmapi_rt_data_flag(mp, bma);
+
 	/*
 	 * Only want to do the alignment at the eof if it is userdata and
 	 * allocation length is larger than a stripe unit.
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index c35a14f..57bf954 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -113,6 +113,9 @@ struct xfs_extent_free_item
 /* Only convert delalloc space, don't allocate entirely new extents */
 #define XFS_BMAPI_DELALLOC	0x400
 
+/* Allocate to realtime device */
+#define XFS_BMAPI_RTDATA	0x800
+
 #define XFS_BMAPI_FLAGS \
 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
 	{ XFS_BMAPI_METADATA,	"METADATA" }, \
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 9e3cc21..7c07ec9 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1027,6 +1027,9 @@ xfs_alloc_file_space(
 		return -EINVAL;
 
 	rt = XFS_IS_REALTIME_INODE(ip);
+	if (!rt && (rt = xfs_inode_select_rt_target(ip, len)))
+		alloc_type |= XFS_BMAPI_RTDATA;
+
 	extsz = xfs_get_extsz_hint(ip);
 
 	count = len;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ec9826c..f9e2deb 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1620,12 +1620,18 @@ xfs_itruncate_extents(
 	if (error)
 		goto out;
 
-	/*
-	 * Clear the reflink flag if we truncated everything.
-	 */
-	if (ip->i_d.di_nblocks == 0 && xfs_is_reflink_inode(ip)) {
-		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
-		xfs_inode_clear_cowblocks_tag(ip);
+	if (ip->i_d.di_nblocks == 0) {
+		/*
+		 * Clear the reflink flag if we truncated everything.
+		 */
+		if (xfs_is_reflink_inode(ip)) {
+			ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
+			xfs_inode_clear_cowblocks_tag(ip);
+		}
+		/* Clear realtime flag if m_rt_alloc_min policy is in place */
+		if (XFS_IS_REALTIME_MOUNT(mp) && mp->m_rt_alloc_min) {
+			ip->i_d.di_flags &= ~XFS_DIFLAG_REALTIME;
+		}
 	}
 
 	/*
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 94e5bdf..4c545c0 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -40,6 +40,7 @@
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
 #include "xfs_reflink.h"
+#include "xfs_rtalloc.h"
 
 
 #define XFS_WRITEIO_ALIGN(mp,off)	(((off) >> mp->m_writeio_log) \
@@ -174,7 +175,11 @@ xfs_iomap_write_direct(
 	int		bmapi_flags = XFS_BMAPI_PREALLOC;
 	uint		tflags = 0;
 
+
 	rt = XFS_IS_REALTIME_INODE(ip);
+	if (!rt && (rt = xfs_inode_select_rt_target(ip, count)))
+		bmapi_flags |= XFS_BMAPI_RTDATA;
+
 	extsz = xfs_get_extsz_hint(ip);
 	lockmode = XFS_ILOCK_SHARED;	/* locked by caller */
 
@@ -983,9 +988,17 @@ xfs_file_iomap_begin(
 
 	if (((flags & (IOMAP_WRITE | IOMAP_DIRECT)) == IOMAP_WRITE) &&
 			!IS_DAX(inode) && !xfs_get_extsz_hint(ip)) {
-		/* Reserve delalloc blocks for regular writeback. */
-		return xfs_file_iomap_begin_delay(inode, offset, length, flags,
-				iomap);
+		/*
+		 * For non-odirect writes, check if this will be allocated to
+		 * realtime, if so we by-pass xfs_file_iomap_begin_delay as if
+		 * the inode was already marked realtime (see xfs_get_extsz_hint).
+		 * The actual setting of the realtime flag on the inode will be
+		 * done later on.
+		 */
+		if (!xfs_inode_select_rt_target(ip, XFS_FSB_TO_B(mp, length)))
+			/* Reserve delalloc blocks for regular writeback. */
+			return xfs_file_iomap_begin_delay(inode, offset, length,
+					flags, iomap);
 	}
 
 	if (need_excl_ilock(ip, flags)) {
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 9fa312a..e64936f 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -197,6 +197,7 @@ typedef struct xfs_mount {
 	__uint32_t		m_generation;
 
 	bool			m_fail_unmount;
+	xfs_off_t		m_rt_alloc_min; /* Min RT allocation */
 #ifdef DEBUG
 	/*
 	 * DEBUG mode instrumentation to test and/or trigger delayed allocation
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index c57aa7f..4866e52 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1284,3 +1284,53 @@ xfs_rtpick_extent(
 	*pick = b;
 	return 0;
 }
+
+/*
+ * If allocation length is less than rt_alloc_min threshold select the
+ * data device.   Otherwise, select the realtime device.
+ */
+bool
+xfs_rt_alloc_min(
+	struct xfs_mount	*mp,
+	xfs_off_t		len)
+{
+	if (!mp->m_rt_alloc_min)
+		return false;
+
+	if (len >= mp->m_rt_alloc_min)
+		return true;
+
+	return false;
+}
+
+/*
+* Select the target device for the inode based on either the size of the
+* initial allocation, or the amount of space available on the data device.
+*
+*/
+bool
+xfs_inode_select_rt_target(
+	struct xfs_inode	*ip,
+	xfs_off_t		len)
+{
+	struct xfs_mount    *mp = ip->i_mount;
+
+	/* If the mount does not have a realtime device configured, there's
+	 * nothing to do here.
+	 */
+	if (!XFS_IS_REALTIME_MOUNT(mp))
+		return false;
+
+	/* You cannot select a new device target once blocks have been allocated
+	 * (e.g. fallocate() beyond EOF), or if data has been written already.
+	 */
+	if (ip->i_d.di_nextents)
+		return false;
+	if (ip->i_d.di_size)
+		return false;
+
+	/* Select realtime device as our target based on the value of
+	 * mp->m_rt_alloc_min.  Target selection code if not valid if not set.
+	 */
+	return xfs_rt_alloc_min(mp, len);
+}
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index f13133e..76868d2 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -136,6 +136,7 @@ int xfs_rtalloc_query_range(struct xfs_trans *tp,
 int xfs_rtalloc_query_all(struct xfs_trans *tp,
 			  xfs_rtalloc_query_range_fn fn,
 			  void *priv);
+bool xfs_inode_select_rt_target(struct xfs_inode *ip, xfs_off_t len);
 #else
 # define xfs_rtallocate_extent(t,b,min,max,l,f,p,rb)    (ENOSYS)
 # define xfs_rtfree_extent(t,b,l)                       (ENOSYS)
@@ -155,6 +156,7 @@ xfs_rtmount_init(
 }
 # define xfs_rtmount_inodes(m)  (((mp)->m_sb.sb_rblocks == 0)? 0 : (ENOSYS))
 # define xfs_rtunmount_inodes(m)
+# define xfs_inode_select_rt_target(i,l)		(0)
 #endif	/* CONFIG_XFS_RT */
 
 #endif	/* __XFS_RTALLOC_H__ */
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 80ac15f..954398d 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -129,10 +129,52 @@ XFS_SYSFS_ATTR_RW(drop_writes);
 
 #endif /* DEBUG */
 
+#ifdef CONFIG_XFS_RT
+STATIC ssize_t
+rt_alloc_min_store(
+	struct kobject		*kobject,
+	const char		*buf,
+	size_t			count)
+{
+	struct xfs_mount	*mp = to_mp(kobject);
+	int			ret;
+	int			val;
+
+	ret = kstrtoint(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	/* Only valid if using a real-time device */
+	if(!XFS_IS_REALTIME_MOUNT(mp))
+		return -EINVAL;
+
+	if (val >= 0)
+		mp->m_rt_alloc_min = val;
+	else
+		return -EINVAL;
+
+	return count;
+}
+
+STATIC ssize_t
+rt_alloc_min_show(
+	struct kobject		*kobject,
+	char			*buf)
+{
+	struct xfs_mount	*mp = to_mp(kobject);
+
+	return snprintf(buf, PAGE_SIZE, "%lld\n", mp->m_rt_alloc_min);
+}
+XFS_SYSFS_ATTR_RW(rt_alloc_min);
+#endif
+
 static struct attribute *xfs_mp_attrs[] = {
 #ifdef DEBUG
 	ATTR_LIST(drop_writes),
 #endif
+#ifdef CONFIG_XFS_RT
+	ATTR_LIST(rt_alloc_min),
+#endif
 	NULL,
 };
 
-- 
2.9.5

