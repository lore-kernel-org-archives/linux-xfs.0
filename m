Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58241 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751263AbdISDwl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 23:52:41 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.21/8.16.0.21) with SMTP id v8J3nKJJ015707
        for <linux-xfs@vger.kernel.org>; Mon, 18 Sep 2017 20:52:40 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2d2p0qhfdp-3
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 18 Sep 2017 20:52:40 -0700
From: Richard Wareing <rwareing@fb.com>
Subject: [PATCH v4 3/3] xfs: Add realtime fallback if data device full
Date: Mon, 18 Sep 2017 20:52:38 -0700
Message-ID: <20170919035238.3976871-4-rwareing@fb.com>
In-Reply-To: <20170919035238.3976871-1-rwareing@fb.com>
References: <20170919035238.3976871-1-rwareing@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org

- Adds tunable option to fallback to realtime device if configured
  when data device is full.
- Useful for realtime device users to help prevent ENOSPC errors when
  selectively storing some files (e.g. small files) on data device, while
  others are stored on realtime block device.
- Set via the "rt_fallback_pct" sysfs value which is available if
  the kernel is compiled with CONFIG_XFS_RT.

Signed-off-by: Richard Wareing <rwareing@fb.com>
---
Changes since v3:
* None, new patch to patch set

 fs/xfs/xfs_bmap_util.c |  4 +++-
 fs/xfs/xfs_fsops.c     |  4 ++++
 fs/xfs/xfs_iomap.c     |  8 ++++++--
 fs/xfs/xfs_mount.c     | 27 ++++++++++++++++++++++++++-
 fs/xfs/xfs_mount.h     |  7 ++++++-
 fs/xfs/xfs_rtalloc.c   | 14 ++++++++++++++
 fs/xfs/xfs_rtalloc.h   |  3 ++-
 fs/xfs/xfs_sysfs.c     | 39 +++++++++++++++++++++++++++++++++++++++
 8 files changed, 100 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 2d253fb..9797c69 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1026,8 +1026,10 @@ xfs_alloc_file_space(
 	if (len <= 0)
 		return -EINVAL;
 
-	if (XFS_IS_REALTIME_MOUNT(mp))
+	if (XFS_IS_REALTIME_MOUNT(mp)) {
 		xfs_rt_alloc_min(ip, len);
+		xfs_rt_fallback(ip, mp);
+	}
 
 	rt = XFS_IS_REALTIME_INODE(ip);
 	extsz = xfs_get_extsz_hint(ip);
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 6ccaae9..c15e906 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -610,6 +610,10 @@ xfs_growfs_data_private(
 	xfs_set_low_space_thresholds(mp);
 	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
 
+	if (XFS_IS_REALTIME_MOUNT(mp)) {
+		xfs_set_rt_min_fdblocks(mp);
+	}
+
 	/*
 	 * If we expanded the last AG, free the per-AG reservation
 	 * so we can reinitialize it with the new size.
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 11f1c95..707ba97 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -176,8 +176,10 @@ xfs_iomap_write_direct(
 	uint		tflags = 0;
 
 
-	if (XFS_IS_REALTIME_MOUNT(mp))
+	if (XFS_IS_REALTIME_MOUNT(mp)) {
 		xfs_rt_alloc_min(ip, count);
+		xfs_rt_fallback(ip, mp);
+	}
 
 	rt = XFS_IS_REALTIME_INODE(ip);
 	extsz = xfs_get_extsz_hint(ip);
@@ -986,8 +988,10 @@ xfs_file_iomap_begin(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	if (XFS_IS_REALTIME_MOUNT(mp))
+	if (XFS_IS_REALTIME_MOUNT(mp)) {
 		xfs_rt_alloc_min(ip, length);
+		xfs_rt_fallback(ip, mp);
+	}
 
 	if (((flags & (IOMAP_WRITE | IOMAP_DIRECT)) == IOMAP_WRITE) &&
 			!IS_DAX(inode) && !xfs_get_extsz_hint(ip)) {
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 2eaf818..543e80d 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -509,7 +509,6 @@ xfs_set_low_space_thresholds(
 	}
 }
 
-
 /*
  * Set whether we're using inode alignment.
  */
@@ -1396,3 +1395,29 @@ xfs_dev_is_read_only(
 	}
 	return 0;
 }
+
+/*
+ * precalculate minimum of data blocks required, if we fall
+ * below this value, we will fallback to the real-time device.
+ *
+ * m_rt_fallback_pct can only be non-zero if a real-time device
+ * is configured.
+ */
+void
+xfs_set_rt_min_fdblocks(
+	struct xfs_mount	*mp)
+{
+	if (mp->m_rt_fallback_pct) {
+		xfs_sb_t		*sbp = &mp->m_sb;
+		xfs_extlen_t 	lsize;
+		__uint64_t 		min_blocks;
+
+		lsize = sbp->sb_logstart ? sbp->sb_logblocks : 0;
+		min_blocks = (mp->m_sb.sb_dblocks - lsize) * mp->m_rt_fallback_pct;
+		do_div(min_blocks, 100);
+		/* Pre-compute minimum data blocks required before
+		 * falling back to RT device for allocations
+		 */
+		mp->m_rt_min_fdblocks = min_blocks;
+	}
+}
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 067be3b..36676c4 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -197,7 +197,11 @@ typedef struct xfs_mount {
 	__uint32_t		m_generation;
 
 	bool			m_fail_unmount;
-        uint                    m_rt_alloc_min; /* Min RT allocation */
+	uint			m_rt_alloc_min; /* Min RT allocation */
+	__uint8_t		m_rt_fallback_pct; /* Fall back to realtime device if
+										* data dev above rt_fallback_pct
+										*/
+	__uint64_t		m_rt_min_fdblocks; /* Realtime min fdblock threshold */
 #ifdef DEBUG
 	/*
 	 * DEBUG mode instrumentation to test and/or trigger delayed allocation
@@ -463,4 +467,5 @@ int	xfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
 struct xfs_error_cfg * xfs_error_get_cfg(struct xfs_mount *mp,
 		int error_class, int error);
 
+void            xfs_set_rt_min_fdblocks(struct xfs_mount *mp);
 #endif	/* __XFS_MOUNT_H__ */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index e51cb25..f0d25a0 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1310,3 +1310,17 @@ void xfs_rt_alloc_min(
 		}
 	}
 }
+
+void xfs_rt_fallback(
+    struct xfs_inode    *ip,
+    struct xfs_mount    *mp)
+{
+    if (!XFS_IS_REALTIME_INODE(ip)) {
+        __uint64_t      free;
+        free = percpu_counter_sum(&mp->m_fdblocks) -
+            mp->m_alloc_set_aside;
+        if (free < mp->m_rt_min_fdblocks) {
+            ip->i_d.di_flags |= XFS_DIFLAG_REALTIME;
+        }
+    }
+}
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 12939d9..28f3e42 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -137,7 +137,7 @@ int xfs_rtalloc_query_all(struct xfs_trans *tp,
 			  xfs_rtalloc_query_range_fn fn,
 			  void *priv);
 void xfs_rt_alloc_min(struct xfs_inode *ip, xfs_off_t len);
-
+void xfs_rt_fallback(struct xfs_inode *ip, struct xfs_mount *mp);
 
 #else
 # define xfs_rtallocate_extent(t,b,min,max,l,f,p,rb)    (ENOSYS)
@@ -159,6 +159,7 @@ xfs_rtmount_init(
 # define xfs_rtmount_inodes(m)  (((mp)->m_sb.sb_rblocks == 0)? 0 : (ENOSYS))
 # define xfs_rtunmount_inodes(m)
 # define xfs_rt_alloc_min(i,l)                          (ENOSYS)
+# define xfs_rt_fallback(i,m)                           (ENOSYS)
 #endif	/* CONFIG_XFS_RT */
 
 #endif	/* __XFS_RTALLOC_H__ */
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 3c8dedb..c22da05 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -165,6 +165,44 @@ rt_alloc_min_show(
 	return snprintf(buf, PAGE_SIZE, "%d\n", mp->m_rt_alloc_min);
 }
 XFS_SYSFS_ATTR_RW(rt_alloc_min);
+
+STATIC ssize_t
+rt_fallback_pct_store(
+	struct kobject			*kobject,
+	const char				*buf,
+	size_t					count)
+{
+	struct xfs_mount		*mp = to_mp(kobject);
+	int						ret;
+	int						val;
+
+	ret = kstrtoint(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	/* Only valid if using a real-time device */
+	if (XFS_IS_REALTIME_MOUNT(mp) && ((val > 0) && (val <=100))) {
+		mp->m_rt_fallback_pct = val;
+		xfs_set_rt_min_fdblocks(mp);
+	} else if (val <= 0) {
+		mp->m_rt_fallback_pct = 0;
+		mp->m_rt_min_fdblocks = 0;
+	} else
+		return -EINVAL;
+
+	return count;
+}
+
+STATIC ssize_t
+rt_fallback_pct_show(
+	struct kobject          *kobject,
+	char                    *buf)
+{
+	struct xfs_mount        *mp = to_mp(kobject);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", mp->m_rt_fallback_pct);
+}
+XFS_SYSFS_ATTR_RW(rt_fallback_pct);
 #endif /* CONFIG_XFS_RT */
 
 static struct attribute *xfs_mp_attrs[] = {
@@ -173,6 +211,7 @@ static struct attribute *xfs_mp_attrs[] = {
 #endif
 #ifdef CONFIG_XFS_RT
 	ATTR_LIST(rt_alloc_min),
+	ATTR_LIST(rt_fallback_pct),
 #endif
 	NULL,
 };
-- 
2.9.5

