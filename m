Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172DD4C7D
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608658; cv=none; b=Si+7oORyfucpFy/5xu4ILQcbibnuifj1eJsmmR04Gu35d/xhTRIHdmpQXRzEMoc5ScY39JKmVE4Ge9Svbjo6siF7dbtgIESMki3k2W2UXmcDXYsOehhPAYI2A7L6FU97UB9Kw/WIAiAyepcnxoLBHDGpBZRmm4DTymcXzdWrceU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608658; c=relaxed/simple;
	bh=BI42v6WNw7AnJS6bqx1/HwYlw9xS0lBQm4q9H3A195k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JFD+wZ7o7DEurHH31ecMpFjVaBOAbYDGZ4yd9hzaHku6UGCY0hcD73sQt/z+LrW/NUP+lGN0BMToPWBFQSHfWH8wmR4PFsihE/viLdRVDgA6cLvyRpDikkLH4fyt//qeMRFpQeMYTb0lMOq4VDccSCf5GZit6hV0esGR/0bPWlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IZrcpD8e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IZrcpD8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58B7C4CEC5;
	Fri, 11 Oct 2024 01:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608658;
	bh=BI42v6WNw7AnJS6bqx1/HwYlw9xS0lBQm4q9H3A195k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IZrcpD8eRlV+4H9rpvXuoE25WNR6RwpactpUp7OC2D8czSmqnM8yJq8x6OwUO6rvc
	 3guXge0QyHYjIsZEEOX0I62eqbfgUbPeElxKwtr53DSGuRFHTQ/Dn03huv+vKolqYy
	 U4OARsy5Rw7nJbCz3L0WMcCGzfRwVhgo5C6bXT4XlgT2xA2t2aiPzyyqPfYVsBo1df
	 cS11XGsGCpW3m7D08YtOmjDePXDcZ5kzqqO50/VS8pRYO2S4uhpFKAMfrYKT7dpwkE
	 McBKaViwXDpUztIWMHw+mp+qx7/x7IN+ABThg0iLDf5yS5F9c9Pce5m161uvIAvAp3
	 mSGoaGFQIpyZA==
Date: Thu, 10 Oct 2024 18:04:17 -0700
Subject: [PATCH 10/36] xfs: export the geometry of realtime groups to
 userspace
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860644412.4178701.5633521217539140453.stgit@frogsfrogsfrogs>
In-Reply-To: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_fs.h      |   17 +++++++++++++++++
 fs/xfs/libxfs/xfs_health.h  |    2 ++
 fs/xfs/libxfs/xfs_rtgroup.c |   15 +++++++++++++++
 fs/xfs/libxfs/xfs_rtgroup.h |    4 ++++
 fs/xfs/xfs_health.c         |   28 ++++++++++++++++++++++++++++
 fs/xfs/xfs_ioctl.c          |   35 +++++++++++++++++++++++++++++++++++
 6 files changed, 101 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 5c224d03270ce9..522da7cde84679 100644
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
index 86d6d1d26fc428..89b24df5ed806e 100644
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
index eea07545752299..8d8a8ebb8b50ff 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -192,6 +192,21 @@ xfs_rtgroup_trans_join(
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
+	rgeo->rg_capacity = rgeo->rg_length;
+	xfs_rtgroup_geom_health(rtg, rgeo);
+	return 0;
+}
+
 #ifdef CONFIG_PROVE_LOCKING
 static struct lock_class_key xfs_rtginode_lock_class;
 
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 6c958b99c0fc5a..185138837832d8 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -226,6 +226,9 @@ void xfs_rtgroup_unlock(struct xfs_rtgroup *rtg, unsigned int rtglock_flags);
 void xfs_rtgroup_trans_join(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
 		unsigned int rtglock_flags);
 
+int xfs_rtgroup_get_geometry(struct xfs_rtgroup *rtg,
+		struct xfs_rtgroup_geometry *rgeo);
+
 int xfs_rtginode_mkdir_parent(struct xfs_mount *mp);
 int xfs_rtginode_load_parent(struct xfs_trans *tp);
 
@@ -268,6 +271,7 @@ static inline int xfs_initialize_rtgroups(struct xfs_mount *mp,
 # define xfs_rtgroup_trans_join(tp, rtg, gf)	((void)0)
 # define xfs_update_rtsb(bp, sb_bp)	((void)0)
 # define xfs_log_rtsb(tp, sb_bp)	(NULL)
+# define xfs_rtgroup_get_geometry(rtg, rgeo)	(-EOPNOTSUPP)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __LIBXFS_RTGROUP_H */
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 7f0f8711ce5788..b1c709e405129f 100644
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
+	xfs_group_measure_sickness(&rtg->rtg_group, &sick, &checked);
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
index 4d5df6593af5fd..30420b09115e00 100644
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

