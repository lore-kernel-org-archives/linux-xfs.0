Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43616 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753336AbdKVWkM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Nov 2017 17:40:12 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vAMMeBF1026868
        for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2017 14:40:12 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2edemt8tkd-4
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2017 14:40:12 -0800
From: Richard Wareing <rwareing@fb.com>
Subject: [PATCH RESEND v6 2/3] xfs: Set realtime flag based on initial allocation size
Date: Wed, 22 Nov 2017 14:40:08 -0800
Message-ID: <20171122224009.3533341-3-rwareing@fb.com>
In-Reply-To: <20171122224009.3533341-1-rwareing@fb.com>
References: <20171122224009.3533341-1-rwareing@fb.com>
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
 fs/xfs/xfs_inode.c                |  6 +++++
 fs/xfs/xfs_iomap.c                | 18 ++++++++++++--
 fs/xfs/xfs_mount.h                |  1 +
 fs/xfs/xfs_rtalloc.c              | 50 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_rtalloc.h              |  2 ++
 fs/xfs/xfs_sysfs.c                | 42 ++++++++++++++++++++++++++++++++
 10 files changed, 178 insertions(+), 3 deletions(-)

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
index 8926379..dd02a52 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4188,6 +4188,39 @@ xfs_bmapi_reserve_delalloc(
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
@@ -4238,6 +4271,8 @@ xfs_bmapi_allocate(
 
 	bma->minlen = (bma->flags & XFS_BMAPI_CONTIG) ? bma->length : 1;
 
+	xfs_bmapi_rt_data_flag(mp, bma);
+
 	/*
 	 * Only want to do the alignment at the eof if it is userdata and
 	 * allocation length is larger than a stripe unit.
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 502e0d8..6f67588 100644
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
index 6503cfa..b04363b 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1053,6 +1053,9 @@ xfs_alloc_file_space(
 		return -EINVAL;
 
 	rt = XFS_IS_REALTIME_INODE(ip);
+	if (!rt && (rt = xfs_inode_select_rt_target(ip, len)))
+		alloc_type |= XFS_BMAPI_RTDATA;
+
 	extsz = xfs_get_extsz_hint(ip);
 
 	count = len;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4ec5b7f..ed29549 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1633,6 +1633,12 @@ xfs_itruncate_extents(
 		xfs_inode_clear_cowblocks_tag(ip);
 	}
 
+	if (ip->i_d.di_nblocks == 0 && XFS_IS_REALTIME_MOUNT(mp) &&
+	    mp->m_rt_alloc_min) {
+		/* Clear realtime flag if m_rt_alloc_min policy is in place */
+		ip->i_d.di_flags &= ~XFS_DIFLAG_REALTIME;
+	}
+
 	/*
 	 * Always re-log the inode so that our permanent transaction can keep
 	 * on rolling it forward in the log.
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index f179bdf..518a9bb 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -40,6 +40,7 @@
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
 #include "xfs_reflink.h"
+#include "xfs_rtalloc.h"
 
 
 #define XFS_WRITEIO_ALIGN(mp,off)	(((off) >> mp->m_writeio_log) \
@@ -175,7 +176,11 @@ xfs_iomap_write_direct(
 	int		bmapi_flags = XFS_BMAPI_PREALLOC;
 	uint		tflags = 0;
 
+
 	rt = XFS_IS_REALTIME_INODE(ip);
+	if (!rt && (rt = xfs_inode_select_rt_target(ip, count)))
+		bmapi_flags |= XFS_BMAPI_RTDATA;
+
 	extsz = xfs_get_extsz_hint(ip);
 	lockmode = XFS_ILOCK_SHARED;	/* locked by caller */
 
@@ -985,8 +990,17 @@ xfs_file_iomap_begin(
 
 	if (((flags & (IOMAP_WRITE | IOMAP_DIRECT)) == IOMAP_WRITE) &&
 			!IS_DAX(inode) && !xfs_get_extsz_hint(ip)) {
-		/* Reserve delalloc blocks for regular writeback. */
-		return xfs_file_iomap_begin_delay(inode, offset, length, iomap);
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
+					iomap);
 	}
 
 	if (need_excl_ilock(ip, flags)) {
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e0792d0..0db9731 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -197,6 +197,7 @@ typedef struct xfs_mount {
 	uint32_t		m_generation;
 
 	bool			m_fail_unmount;
+	xfs_off_t		m_rt_alloc_min; /* Min RT allocation */
 #ifdef DEBUG
 	/*
 	 * Frequency with which errors are injected.  Replaces xfs_etest; the
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 488719d..145007b 100644
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
index 79defa7..4f058b5 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -138,6 +138,7 @@ int xfs_rtalloc_query_range(struct xfs_trans *tp,
 int xfs_rtalloc_query_all(struct xfs_trans *tp,
 			  xfs_rtalloc_query_range_fn fn,
 			  void *priv);
+bool xfs_inode_select_rt_target(struct xfs_inode *ip, xfs_off_t len);
 #else
 # define xfs_rtallocate_extent(t,b,min,max,l,f,p,rb)    (ENOSYS)
 # define xfs_rtfree_extent(t,b,l)                       (ENOSYS)
@@ -158,6 +159,7 @@ xfs_rtmount_init(
 }
 # define xfs_rtmount_inodes(m)  (((mp)->m_sb.sb_rblocks == 0)? 0 : (ENOSYS))
 # define xfs_rtunmount_inodes(m)
+# define xfs_inode_select_rt_target(i,l)		(0)
 #endif	/* CONFIG_XFS_RT */
 
 #endif	/* __XFS_RTALLOC_H__ */
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 8b2ccc2..8b425be 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -90,7 +90,49 @@ to_mp(struct kobject *kobject)
 	return container_of(kobj, struct xfs_mount, m_kobj);
 }
 
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
+#ifdef CONFIG_XFS_RT
+	ATTR_LIST(rt_alloc_min),
+#endif
 	NULL,
 };
 
-- 
2.9.5

