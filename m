Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34295 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934464AbdIYToV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2017 15:44:21 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.21/8.16.0.21) with SMTP id v8PJfdbY018546
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2017 12:44:20 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2d77gd85qa-2
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2017 12:44:20 -0700
From: Richard Wareing <rwareing@fb.com>
Subject: [PATCH v5 3/3] xfs: Add realtime fallback if data device full
Date: Mon, 25 Sep 2017 12:44:18 -0700
Message-ID: <20170925194418.720146-4-rwareing@fb.com>
In-Reply-To: <20170925194418.720146-1-rwareing@fb.com>
References: <20170925194418.720146-1-rwareing@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org

- For FSes which have a realtime device configured, rt_fallback_pct forces
  allocations to the realtime device after data device usage reaches
  rt_fallback_pct.
- Useful for realtime device users to help prevent ENOSPC errors when
  selectively storing some files (e.g. small files) on data device, while
  others are stored on realtime block device.
- Set via the "rt_fallback_pct" sysfs value which is available if
  the kernel is compiled with CONFIG_XFS_RT.

Signed-off-by: Richard Wareing <rwareing@fb.com>
---
Changes since v4:
* Refactored to align with xfs_inode_select_target change
* Fallback percentage reworked to trigger on % space used on data device.
  I find this a bit more intuitive as it aligns well with "df" output.
* mp->m_rt_min_fdblocks now assigned via function call
* Better consistency on sysfs options

Changes since v3:
* None, new patch to patch set

 fs/xfs/xfs_fsops.c   |  2 ++
 fs/xfs/xfs_mount.c   | 24 ++++++++++++++++++++++++
 fs/xfs/xfs_mount.h   |  8 ++++++++
 fs/xfs/xfs_rtalloc.c | 32 ++++++++++++++++++++++++++++++++
 fs/xfs/xfs_sysfs.c   | 38 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 104 insertions(+)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 6ccaae9..80ccb14 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -610,6 +610,8 @@ xfs_growfs_data_private(
 	xfs_set_low_space_thresholds(mp);
 	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
 
+	mp->m_rt_min_free_dblocks = xfs_rt_calc_min_free_dblocks(mp);
+
 	/*
 	 * If we expanded the last AG, free the per-AG reservation
 	 * so we can reinitialize it with the new size.
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 2eaf818..e8bae5e 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1396,3 +1396,27 @@ xfs_dev_is_read_only(
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
+uint64_t
+xfs_rt_calc_min_free_dblocks(
+	struct xfs_mount	*mp)
+{
+	uint64_t	min_free_dblocks = 0;
+
+	if (!XFS_IS_REALTIME_MOUNT(mp))
+		return 0;
+
+	/* Pre-compute minimum data blocks required before
+	 * falling back to RT device for allocations
+	 */
+	min_free_dblocks = mp->m_sb.sb_dblocks * (100 - mp->m_rt_fallback_pct);
+	do_div(min_free_dblocks, 100);
+	return min_free_dblocks;
+}
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 2adc701..74dcdc3 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -198,6 +198,13 @@ typedef struct xfs_mount {
 
 	bool			m_fail_unmount;
 	uint			m_rt_alloc_min; /* Min RT allocation */
+	uint32_t		m_rt_fallback_pct; /* Fallback to realtime device if data
+										* device usage above rt_fallback_pct
+										*/
+	uint64_t		m_rt_min_free_dblocks; /* Use realtime device if free data
+											* device blocks falls below this;
+											* computed from m_rt_fallback_pct.
+											*/
 #ifdef DEBUG
 	/*
 	 * DEBUG mode instrumentation to test and/or trigger delayed allocation
@@ -463,4 +470,5 @@ int	xfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
 struct xfs_error_cfg * xfs_error_get_cfg(struct xfs_mount *mp,
 		int error_class, int error);
 
+uint64_t	xfs_rt_calc_min_free_dblocks(struct xfs_mount *mp);
 #endif	/* __XFS_MOUNT_H__ */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 421f860..c197b95 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1305,6 +1305,35 @@ void xfs_rt_alloc_min(
 }
 
 /*
+ * m_rt_min_free_dblocks is a pre-computed threshold, which controls target
+ * selection based on how many free blocks are available on the data device.
+ *
+ * If the number of free data device blocks falls below
+ * mp->m_rt_min_free_dblocks, the realtime device is selected as the target
+ * device.  If this value is not set, this target policy is in-active.
+ *
+ */
+void xfs_rt_min_free_dblocks(
+	struct xfs_mount	*mp,
+	struct xfs_inode	*ip,
+	xfs_off_t			len)
+{
+	/* Disabled */
+	if (!mp->m_rt_fallback_pct)
+		return;
+
+	/* If inode target is already realtime device, nothing to do here */
+	if(!XFS_IS_REALTIME_INODE(ip)) {
+		uint64_t	free_dblocks;
+		free_dblocks = percpu_counter_sum(&mp->m_fdblocks) -
+			mp->m_alloc_set_aside;
+		if (free_dblocks < mp->m_rt_min_free_dblocks) {
+			ip->i_d.di_flags |= XFS_DIFLAG_REALTIME;
+		}
+	}
+}
+
+/*
 * Select the target device for the inode based on either the size of the
 * initial allocation, or the amount of space available on the data device.
 *
@@ -1333,4 +1362,7 @@ void xfs_inode_select_target(
 	 * not valid if not set.
 	 */
 	xfs_rt_alloc_min(mp, ip, len);
+
+	/* Select target based on remaining free blocks on data device */
+	xfs_rt_min_free_dblocks(mp, ip, len);
 }
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 1e202a1..889b006 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -166,11 +166,49 @@ rt_alloc_min_show(
 }
 XFS_SYSFS_ATTR_RW(rt_alloc_min);
 
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
+	if (!XFS_IS_REALTIME_MOUNT(mp))
+		return -EINVAL;
+
+	if (val < 0)
+		return -EINVAL;
+
+	/* Only valid if using a real-time device */
+	mp->m_rt_fallback_pct = val;
+	mp->m_rt_min_free_dblocks = xfs_rt_calc_min_free_dblocks(mp);
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
+
 static struct attribute *xfs_mp_attrs[] = {
 #ifdef DEBUG
 	ATTR_LIST(drop_writes),
 #endif
 	ATTR_LIST(rt_alloc_min),
+	ATTR_LIST(rt_fallback_pct),
 	NULL,
 };
 
-- 
2.9.5

