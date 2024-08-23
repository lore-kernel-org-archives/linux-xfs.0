Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E660C33D8
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372628; cv=none; b=TwwoOLUvYeO0LLc/mBteHyk4Vd9tgHLbPTZgv7pm+GVUk3z5ejAZjUYvYXbChYteBBPChBSPgInXJfqt5fCET77HEKTvIj/36O/Fudw+Dz5IUYP3NIqd1eRWZRqcNX8uxebO4ZTpJ9oML3cBaD/AzfGZ5JjFt0fXMn6eEoe5WCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372628; c=relaxed/simple;
	bh=7IZIvt7yUl2cqrSyM8S5VSpUqxbN35hg4Lgi3so2FFI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fPpQPBSf2NBF35lkIb4FQfRYGuWIIuDrdz/bfpzhzfmnigNePmSXXWSbNVi5ojnj5LBazAGjDL2U57C8B5bjz3z/jiVFjoxFVycrML22MD/zvRdhLvp8qmyeF6TW+NaUfRUk0VtyGTE8QHgYezH5A7PQan3QbpPknyAKtdkdK/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SWHhoXah; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SWHhoXah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321E2C32782;
	Fri, 23 Aug 2024 00:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372627;
	bh=7IZIvt7yUl2cqrSyM8S5VSpUqxbN35hg4Lgi3so2FFI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SWHhoXahtFXsDbhrj3TENrptbWEPBp5b1ODiwWUGxzD15KsaVOKbRMG9FIGjOmx7A
	 Da80WgvVx8+zYZa8VIRtHbETlXxjkrW2ISbuhHwgY3oHRjNyc2FfB8PobF8es2SYTh
	 HAYumCSvjZDXRblnSYJ5ndzTtYTahHtXgUVLZTBX5hquJIOXdr+onCkFxap6Zx7+ee
	 o860LUqevYuFG2aDYQCuS87ZHtbZcb7DV13Ya+sVrK0xEbNxyk59VNs2512nSmwpQQ
	 5klPzAU81wpQoqZ99gEwAAxH52heva1r/1Uetxy35j6vACBDnmkq7wciNW6Q4Dcqmj
	 YUYBatwpSeB5g==
Date: Thu, 22 Aug 2024 17:23:46 -0700
Subject: [PATCH 10/26] xfs: export the geometry of realtime groups to
 userspace
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437088693.60592.13218743269576141133.stgit@frogsfrogsfrogs>
In-Reply-To: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create an ioctl so that the kernel can report the status of realtime
groups to userspace.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h      |   17 +++++++++++++++++
 fs/xfs/libxfs/xfs_health.h  |    2 ++
 fs/xfs/libxfs/xfs_rtgroup.c |   15 +++++++++++++++
 fs/xfs/libxfs/xfs_rtgroup.h |    4 ++++
 fs/xfs/xfs_health.c         |   28 ++++++++++++++++++++++++++++
 fs/xfs/xfs_ioctl.c          |   33 +++++++++++++++++++++++++++++++++
 6 files changed, 99 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 57819fea064e7..2dacc19723c37 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -971,6 +971,22 @@ struct xfs_getparents_by_handle {
 	struct xfs_getparents		gph_request;
 };
 
+/*
+ * Output for XFS_IOC_RTGROUP_GEOMETRY
+ */
+struct xfs_rtgroup_geometry {
+	__u32 rg_number;	/* i/o: rtgroup number */
+	__u32 rg_length;	/* o: length in blocks */
+	__u32 rg_capacity;	/* o: usable capacity in blocks */
+	__u32 rg_sick;		/* o: sick things in ag */
+	__u32 rg_checked;	/* o: checked metadata in ag */
+	__u32 rg_flags;		/* i/o: flags for this ag */
+	__u64 rg_reserved[13];	/* o: zero */
+};
+#define XFS_RTGROUP_GEOM_SICK_SUPER	(1U << 0)  /* superblock */
+#define XFS_RTGROUP_GEOM_SICK_BITMAP	(1U << 1)  /* rtbitmap */
+#define XFS_RTGROUP_GEOM_SICK_SUMMARY	(1U << 2)  /* rtsummary */
+
 /*
  * ioctl commands that are used by Linux filesystems
  */
@@ -1009,6 +1025,7 @@ struct xfs_getparents_by_handle {
 #define XFS_IOC_GETPARENTS	_IOWR('X', 62, struct xfs_getparents)
 #define XFS_IOC_GETPARENTS_BY_HANDLE _IOWR('X', 63, struct xfs_getparents_by_handle)
 #define XFS_IOC_SCRUBV_METADATA	_IOWR('X', 64, struct xfs_scrub_vec_head)
+#define XFS_IOC_RTGROUP_GEOMETRY _IOWR('X', 65, struct xfs_rtgroup_geometry)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 7e77e2df9704a..2da64555434d5 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -288,6 +288,8 @@ xfs_inode_is_healthy(struct xfs_inode *ip)
 
 void xfs_fsop_geom_health(struct xfs_mount *mp, struct xfs_fsop_geom *geo);
 void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
+void xfs_rtgroup_geom_health(struct xfs_rtgroup *rtg,
+		struct xfs_rtgroup_geometry *rgeo);
 void xfs_bulkstat_health(struct xfs_inode *ip, struct xfs_bulkstat *bs);
 
 #define xfs_metadata_is_sick(error) \
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index 3cb08f5cfc260..df70015c68dd0 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -259,6 +259,21 @@ xfs_rtgroup_trans_join(
 	}
 }
 
+/* Retrieve rt group geometry. */
+int
+xfs_rtgroup_get_geometry(
+	struct xfs_rtgroup	*rtg,
+	struct xfs_rtgroup_geometry *rgeo)
+{
+	/* Fill out form. */
+	memset(rgeo, 0, sizeof(*rgeo));
+	rgeo->rg_number = rtg->rtg_rgno;
+	rgeo->rg_length = rtg->rtg_extents * rtg->rtg_mount->m_sb.sb_rextsize;
+	rgeo->rg_capacity = rgeo->rg_length;
+	xfs_rtgroup_geom_health(rtg, rgeo);
+	return 0;
+}
+
 #ifdef CONFIG_PROVE_LOCKING
 static struct lock_class_key xfs_rtginode_lock_class;
 
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index f51f1a7592775..4525aaa26efc2 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -249,6 +249,9 @@ void xfs_rtgroup_unlock(struct xfs_rtgroup *rtg, unsigned int rtglock_flags);
 void xfs_rtgroup_trans_join(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
 		unsigned int rtglock_flags);
 
+int xfs_rtgroup_get_geometry(struct xfs_rtgroup *rtg,
+		struct xfs_rtgroup_geometry *rgeo);
+
 int xfs_rtginode_mkdir_parent(struct xfs_mount *mp);
 int xfs_rtginode_load_parent(struct xfs_trans *tp);
 
@@ -279,6 +282,7 @@ struct xfs_buf *xfs_log_rtsb(struct xfs_trans *tp,
 # define xfs_rtgroup_trans_join(tp, rtg, gf)	((void)0)
 # define xfs_update_rtsb(bp, sb_bp)	((void)0)
 # define xfs_log_rtsb(tp, sb_bp)	(NULL)
+# define xfs_rtgroup_get_geometry(rtg, rgeo)	(-EOPNOTSUPP)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __LIBXFS_RTGROUP_H */
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index e94a5ede103d4..b3d288df4ca20 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -485,6 +485,34 @@ xfs_ag_geom_health(
 	}
 }
 
+static const struct ioctl_sick_map rtgroup_map[] = {
+	{ XFS_SICK_RG_SUPER,	XFS_RTGROUP_GEOM_SICK_SUPER },
+	{ XFS_SICK_RG_BITMAP,	XFS_RTGROUP_GEOM_SICK_BITMAP },
+	{ XFS_SICK_RG_SUMMARY,	XFS_RTGROUP_GEOM_SICK_SUMMARY },
+};
+
+/* Fill out rtgroup geometry health info. */
+void
+xfs_rtgroup_geom_health(
+	struct xfs_rtgroup	*rtg,
+	struct xfs_rtgroup_geometry *rgeo)
+{
+	const struct ioctl_sick_map	*m;
+	unsigned int			sick;
+	unsigned int			checked;
+
+	rgeo->rg_sick = 0;
+	rgeo->rg_checked = 0;
+
+	xfs_rtgroup_measure_sickness(rtg, &sick, &checked);
+	for_each_sick_map(rtgroup_map, m) {
+		if (checked & m->sick_mask)
+			rgeo->rg_checked |= m->ioctl_mask;
+		if (sick & m->sick_mask)
+			rgeo->rg_sick |= m->ioctl_mask;
+	}
+}
+
 static const struct ioctl_sick_map ino_map[] = {
 	{ XFS_SICK_INO_CORE,	XFS_BS_SICK_INODE },
 	{ XFS_SICK_INO_BMBTD,	XFS_BS_SICK_BMBTD },
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index c5526434f66fd..6f5cd06267873 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -40,6 +40,7 @@
 #include "xfs_file.h"
 #include "xfs_exchrange.h"
 #include "xfs_handle.h"
+#include "xfs_rtgroup.h"
 
 #include <linux/mount.h>
 #include <linux/fileattr.h>
@@ -403,6 +404,36 @@ xfs_ioc_ag_geometry(
 	return 0;
 }
 
+STATIC int
+xfs_ioc_rtgroup_geometry(
+	struct xfs_mount	*mp,
+	void			__user *arg)
+{
+	struct xfs_rtgroup	*rtg;
+	struct xfs_rtgroup_geometry rgeo;
+	int			error;
+
+	if (copy_from_user(&rgeo, arg, sizeof(rgeo)))
+		return -EFAULT;
+	if (rgeo.rg_flags)
+		return -EINVAL;
+	if (memchr_inv(&rgeo.rg_reserved, 0, sizeof(rgeo.rg_reserved)))
+		return -EINVAL;
+
+	rtg = xfs_rtgroup_get(mp, rgeo.rg_number);
+	if (!rtg)
+		return -EINVAL;
+
+	error = xfs_rtgroup_get_geometry(rtg, &rgeo);
+	xfs_rtgroup_put(rtg);
+	if (error)
+		return error;
+
+	if (copy_to_user(arg, &rgeo, sizeof(rgeo)))
+		return -EFAULT;
+	return 0;
+}
+
 /*
  * Linux extended inode flags interface.
  */
@@ -1225,6 +1256,8 @@ xfs_file_ioctl(
 
 	case XFS_IOC_AG_GEOMETRY:
 		return xfs_ioc_ag_geometry(mp, arg);
+	case XFS_IOC_RTGROUP_GEOMETRY:
+		return xfs_ioc_rtgroup_geometry(mp, arg);
 
 	case XFS_IOC_GETVERSION:
 		return put_user(inode->i_generation, (int __user *)arg);

