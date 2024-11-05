Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5E318E023
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845952; cv=none; b=UpaeGfNOylEBARSAzD4m3zWLXsPGg0M8AxdyVdebhNzclMTVPmdcH1rOBRQkfbUOq7dluprDvO9rIzyqH5IoFEY2xgkKA3KNGgfzNhtxw+YvDLoLjdvzq2lVGzepMeNkXcx7Avi2/WAl1C6EGfjm/50yWOwBHrB0fnG/Qwj0gsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845952; c=relaxed/simple;
	bh=6ELm/HQBe/yWstYa81F3MRtUYQg5AAPtaCxnMwIx9Dw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eAX2fUiT5wmvDB5eYDUk3Ejbxni8IVew74ixObJo1WjrIKmkTMWawMHnzNcoG2+b110TQ9/ecIuHipDeboVC1xV8uEDCclY6w+o465XY7fWNRwfYWHsy+T3hxnyhoWq1jWd09k0L23o5xXd6vaaSyobJ3IrvrQDvU0MdS4m+bME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JVgbER/p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JVgbER/p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB09C4CECF;
	Tue,  5 Nov 2024 22:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845951;
	bh=6ELm/HQBe/yWstYa81F3MRtUYQg5AAPtaCxnMwIx9Dw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JVgbER/p6BjLFUVbj1OBufc5B9evfIokSz+qTzUKbJBU7CtVC29rppVWEahr+5hl2
	 ZmnwwP+TbW9d6rjWd7bf2UdcSkIFEnDWsfbsW6HvApnVBGHS3RK1U7R32iO/1Aoas1
	 U+k7JTcbDYn9sMG2kOxZnOjHrYUCC5pFfIA/AuECxvIDad25nBV2DTfKsV+lj3Y2fa
	 GbaQDvPbFK9ZrXWx5i8Mp8JlDT1GwKpqQe/ukhCQrNGrkekwsHbsfGeE/2n6RrNstW
	 TiWX+wdztTbc9MQDQX0GbmrphaTQOF6HvXTAepiFSSEki+qxFUdXWMnySiCGbl8ruc
	 cbOJiEZwClhVA==
Date: Tue, 05 Nov 2024 14:32:30 -0800
Subject: [PATCH 10/34] xfs: export the geometry of realtime groups to
 userspace
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084398354.1871887.13544140687893046242.stgit@frogsfrogsfrogs>
In-Reply-To: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
References: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_fs.h      |   16 ++++++++++++++++
 fs/xfs/libxfs/xfs_health.h  |    2 ++
 fs/xfs/libxfs/xfs_rtgroup.c |   14 ++++++++++++++
 fs/xfs/libxfs/xfs_rtgroup.h |    4 ++++
 fs/xfs/xfs_health.c         |   28 ++++++++++++++++++++++++++++
 fs/xfs/xfs_ioctl.c          |   35 +++++++++++++++++++++++++++++++++++
 6 files changed, 99 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 5c224d03270ce9..4c0682173d6144 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -971,6 +971,21 @@ struct xfs_getparents_by_handle {
 	struct xfs_getparents		gph_request;
 };
 
+/*
+ * Output for XFS_IOC_RTGROUP_GEOMETRY
+ */
+struct xfs_rtgroup_geometry {
+	__u32 rg_number;	/* i/o: rtgroup number */
+	__u32 rg_length;	/* o: length in blocks */
+	__u32 rg_sick;		/* o: sick things in ag */
+	__u32 rg_checked;	/* o: checked metadata in ag */
+	__u32 rg_flags;		/* i/o: flags for this ag */
+	__u32 rg_reserved[27];	/* o: zero */
+};
+#define XFS_RTGROUP_GEOM_SICK_SUPER	(1U << 0)  /* superblock */
+#define XFS_RTGROUP_GEOM_SICK_BITMAP	(1U << 1)  /* rtbitmap */
+#define XFS_RTGROUP_GEOM_SICK_SUMMARY	(1U << 2)  /* rtsummary */
+
 /*
  * ioctl commands that are used by Linux filesystems
  */
@@ -1009,6 +1024,7 @@ struct xfs_getparents_by_handle {
 #define XFS_IOC_GETPARENTS	_IOWR('X', 62, struct xfs_getparents)
 #define XFS_IOC_GETPARENTS_BY_HANDLE _IOWR('X', 63, struct xfs_getparents_by_handle)
 #define XFS_IOC_SCRUBV_METADATA	_IOWR('X', 64, struct xfs_scrub_vec_head)
+#define XFS_IOC_RTGROUP_GEOMETRY _IOWR('X', 65, struct xfs_rtgroup_geometry)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 3d93b57cf57143..d34986ac18c3fa 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -278,6 +278,8 @@ xfs_inode_is_healthy(struct xfs_inode *ip)
 
 void xfs_fsop_geom_health(struct xfs_mount *mp, struct xfs_fsop_geom *geo);
 void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
+void xfs_rtgroup_geom_health(struct xfs_rtgroup *rtg,
+		struct xfs_rtgroup_geometry *rgeo);
 void xfs_bulkstat_health(struct xfs_inode *ip, struct xfs_bulkstat *bs);
 
 #define xfs_metadata_is_sick(error) \
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index 790a0b8c137fc8..624d8b25eba0ec 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -214,6 +214,20 @@ xfs_rtgroup_trans_join(
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
+	rgeo->rg_number = rtg_rgno(rtg);
+	rgeo->rg_length = rtg->rtg_extents * rtg_mount(rtg)->m_sb.sb_rextsize;
+	xfs_rtgroup_geom_health(rtg, rgeo);
+	return 0;
+}
+
 #ifdef CONFIG_PROVE_LOCKING
 static struct lock_class_key xfs_rtginode_lock_class;
 
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index fba62b26912a89..026f34f984b32f 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -234,6 +234,9 @@ void xfs_rtgroup_unlock(struct xfs_rtgroup *rtg, unsigned int rtglock_flags);
 void xfs_rtgroup_trans_join(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
 		unsigned int rtglock_flags);
 
+int xfs_rtgroup_get_geometry(struct xfs_rtgroup *rtg,
+		struct xfs_rtgroup_geometry *rgeo);
+
 int xfs_rtginode_mkdir_parent(struct xfs_mount *mp);
 int xfs_rtginode_load_parent(struct xfs_trans *tp);
 
@@ -277,6 +280,7 @@ static inline int xfs_initialize_rtgroups(struct xfs_mount *mp,
 # define xfs_rtgroup_trans_join(tp, rtg, gf)	((void)0)
 # define xfs_update_rtsb(bp, sb_bp)	((void)0)
 # define xfs_log_rtsb(tp, sb_bp)	(NULL)
+# define xfs_rtgroup_get_geometry(rtg, rgeo)	(-EOPNOTSUPP)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __LIBXFS_RTGROUP_H */
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 9d8ee01cd163ef..c7c2e656199862 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -443,6 +443,34 @@ xfs_ag_geom_health(
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
+	xfs_group_measure_sickness(rtg_group(rtg), &sick, &checked);
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
index 1e233abed7ce6d..64cf51c8a15d06 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -40,6 +40,7 @@
 #include "xfs_file.h"
 #include "xfs_exchrange.h"
 #include "xfs_handle.h"
+#include "xfs_rtgroup.h"
 
 #include <linux/mount.h>
 #include <linux/fileattr.h>
@@ -403,6 +404,38 @@ xfs_ioc_ag_geometry(
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
+	if (!xfs_has_rtgroups(mp))
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
@@ -1225,6 +1258,8 @@ xfs_file_ioctl(
 
 	case XFS_IOC_AG_GEOMETRY:
 		return xfs_ioc_ag_geometry(mp, arg);
+	case XFS_IOC_RTGROUP_GEOMETRY:
+		return xfs_ioc_rtgroup_geometry(mp, arg);
 
 	case XFS_IOC_GETVERSION:
 		return put_user(inode->i_generation, (int __user *)arg);

