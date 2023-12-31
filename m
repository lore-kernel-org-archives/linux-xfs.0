Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6019BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m61tUBq7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84CAEC433C8;
	Sun, 31 Dec 2023 21:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057556;
	bh=Wx63+yfNOlY/RD84hnRTYOp35JMes955sIDw9nNdGsM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=m61tUBq7ILsPnTmZXzvT+Otn2Krx14bqcs+w1Com/abgfQvObGvhfJFkJAOkM8GzK
	 OXmxfuzNh/POnjzf4n3bP9zJQdckK58W0CWi2dbWvOgXzQBs6PCeEfI+kf5HN9qSfp
	 im7EsTxDPgaf1r8ngPrY49AQM7UqXaHXm7ghQhspRLAK3lhbN95TiZTebTM76x8izu
	 BM4ZMUv8oH9pi96QykBhMbZ0lzHYVSN2mY5d+RI7N6a0GHVrseiqjTj4ApaXTkpfJG
	 wXBYuIZY9ej/sAcpf1W+RyExPVbsWHfterz+e1jZAUCUxbIhvjEBMTNH8QC0miYfns
	 JZS0GrnUNPlhQ==
Date: Sun, 31 Dec 2023 13:19:16 -0800
Subject: [PATCH 14/24] xfs: export the geometry of realtime groups to
 userspace
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404846464.1763124.5701999725639143419.stgit@frogsfrogsfrogs>
In-Reply-To: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
References: <170404846187.1763124.7316400597964398308.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_fs.h         |    1 +
 fs/xfs/libxfs/xfs_fs_staging.h |   17 +++++++++++++++++
 fs/xfs/libxfs/xfs_health.h     |    2 ++
 fs/xfs/libxfs/xfs_rtgroup.c    |   14 ++++++++++++++
 fs/xfs/libxfs/xfs_rtgroup.h    |    4 ++++
 fs/xfs/xfs_health.c            |   28 ++++++++++++++++++++++++++++
 fs/xfs/xfs_ioctl.c             |   32 ++++++++++++++++++++++++++++++++
 7 files changed, 98 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index bae9ef924bf59..c5bf53c6a43ca 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -852,6 +852,7 @@ struct xfs_scrub_metadata {
 /*	XFS_IOC_SCRUBV_METADATA -- staging 60	   */
 #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
 /*	XFS_IOC_GETPARENTS ---- staging 62         */
+/*	XFS_IOC_RTGROUP_GEOMETRY - staging 63	   */
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/libxfs/xfs_fs_staging.h b/fs/xfs/libxfs/xfs_fs_staging.h
index 69d29f213af3a..1f57331487791 100644
--- a/fs/xfs/libxfs/xfs_fs_staging.h
+++ b/fs/xfs/libxfs/xfs_fs_staging.h
@@ -202,4 +202,21 @@ static inline size_t sizeof_xfs_scrub_vec(unsigned int nr)
 
 #define XFS_IOC_SCRUBV_METADATA	_IOWR('X', 60, struct xfs_scrub_vec_head)
 
+/*
+ * Output for XFS_IOC_RTGROUP_GEOMETRY
+ */
+struct xfs_rtgroup_geometry {
+	__u32 rg_number;	/* i/o: rtgroup number */
+	__u32 rg_length;	/* o: length in blocks */
+	__u32 rg_sick;		/* o: sick things in ag */
+	__u32 rg_checked;	/* o: checked metadata in ag */
+	__u32 rg_flags;		/* i/o: flags for this ag */
+	__u32 rg_pad;		/* o: zero */
+	__u64 rg_reserved[13];	/* o: zero */
+};
+#define XFS_RTGROUP_GEOM_SICK_SUPER	(1 << 0)  /* superblock */
+#define XFS_RTGROUP_GEOM_SICK_BITMAP	(1 << 1)  /* rtbitmap for this group */
+
+#define XFS_IOC_RTGROUP_GEOMETRY _IOWR('X', 63, struct xfs_rtgroup_geometry)
+
 #endif /* __XFS_FS_STAGING_H__ */
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index f5449a804c6c8..1e9938a417b42 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -302,6 +302,8 @@ xfs_inode_is_healthy(struct xfs_inode *ip)
 
 void xfs_fsop_geom_health(struct xfs_mount *mp, struct xfs_fsop_geom *geo);
 void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
+void xfs_rtgroup_geom_health(struct xfs_rtgroup *rtg,
+		struct xfs_rtgroup_geometry *rgeo);
 void xfs_bulkstat_health(struct xfs_inode *ip, struct xfs_bulkstat *bs);
 
 #define xfs_metadata_is_sick(error) \
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index 3c86a560adfe3..ed4f8aa67b158 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -569,3 +569,17 @@ xfs_rtgroup_unlock(
 	else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED)
 		xfs_rtbitmap_unlock_shared(rtg->rtg_mount, XFS_RBMLOCK_BITMAP);
 }
+
+/* Retrieve rt group geometry. */
+int
+xfs_rtgroup_get_geometry(
+	struct xfs_rtgroup	*rtg,
+	struct xfs_rtgroup_geometry *rgeo)
+{
+	/* Fill out form. */
+	memset(rgeo, 0, sizeof(*rgeo));
+	rgeo->rg_number = rtg->rtg_rgno;
+	rgeo->rg_length = rtg->rtg_blockcount;
+	xfs_rtgroup_geom_health(rtg, rgeo);
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 70968cf700fab..e6d60425faa4d 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -233,6 +233,9 @@ int xfs_rtgroup_update_secondary_sbs(struct xfs_mount *mp);
 void xfs_rtgroup_lock(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
 		unsigned int rtglock_flags);
 void xfs_rtgroup_unlock(struct xfs_rtgroup *rtg, unsigned int rtglock_flags);
+
+int xfs_rtgroup_get_geometry(struct xfs_rtgroup *rtg,
+		struct xfs_rtgroup_geometry *rgeo);
 #else
 # define xfs_rtgroup_block_count(mp, rgno)	(0)
 # define xfs_rtgroup_update_super(bp, sb_bp)	((void)0)
@@ -240,6 +243,7 @@ void xfs_rtgroup_unlock(struct xfs_rtgroup *rtg, unsigned int rtglock_flags);
 # define xfs_rtgroup_update_secondary_sbs(mp)	(0)
 # define xfs_rtgroup_lock(tp, rtg, gf)		((void)0)
 # define xfs_rtgroup_unlock(rtg, gf)		((void)0)
+# define xfs_rtgroup_get_geometry(rtg, rgeo)	(-EOPNOTSUPP)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __LIBXFS_RTGROUP_H */
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 1ec015663a6aa..b53ef95a37a54 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -529,6 +529,34 @@ xfs_ag_geom_health(
 	}
 }
 
+static const struct ioctl_sick_map rtgroup_map[] = {
+	{ XFS_SICK_RT_SUPER,	XFS_RTGROUP_GEOM_SICK_SUPER },
+	{ XFS_SICK_RT_BITMAP,	XFS_RTGROUP_GEOM_SICK_BITMAP },
+	{ 0, 0 },
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
+	for (m = rtgroup_map; m->sick_mask; m++) {
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
index b140f7ed916c9..32a52799ae826 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -995,6 +995,36 @@ xfs_ioc_ag_geometry(
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
+	if (rgeo.rg_flags || rgeo.rg_pad)
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
@@ -2081,6 +2111,8 @@ xfs_file_ioctl(
 
 	case XFS_IOC_AG_GEOMETRY:
 		return xfs_ioc_ag_geometry(mp, arg);
+	case XFS_IOC_RTGROUP_GEOMETRY:
+		return xfs_ioc_rtgroup_geometry(mp, arg);
 
 	case XFS_IOC_GETVERSION:
 		return put_user(inode->i_generation, (int __user *)arg);

