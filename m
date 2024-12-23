Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3297F64A
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991391; cv=none; b=LxyV/a+a6RSTx7+A9dwsNg3uB+WmVBmlSqxcx0L8yqsLufYxLMp6WD3jgITARJEwiBR0+Vrm04cAV0P+xOoGBRwPQHZXNPYtOvUg5iAhIZICgpEF6+wnjb15n8RqP2IRxR79vB9egvudC1ZV1rQfy2QoWpJxB2OZI03dfltaX9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991391; c=relaxed/simple;
	bh=gvKRscmlLuSZ3PqmWUMjmhpLJIhiAYUfYggOjzud2Bs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nSMYL156/vrqqGXOOHR9XrDPyphdG9xTml1HrePr5nOtvuYJfN29mtmHUDPVAZkYGR+BO/dPRHKUutAwr8nA/RYaGQUbvp6BQM3pR8xetDReDb+o2h64OvWsQzQn37gNt391joVxDTvimpX1pFAy/84kepF3jsY57AJnnN8SFEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eo79WGSj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eo79WGSj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F49C4CED3;
	Mon, 23 Dec 2024 22:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991391;
	bh=gvKRscmlLuSZ3PqmWUMjmhpLJIhiAYUfYggOjzud2Bs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Eo79WGSj3nq2JkzhuDthsw5Gsaq2ENMnEvY+C19fJLnyr4OmFVc1DQI+52FSFp7hT
	 QKBvIMN75vB4KMYKTfj3NIiE7r87JGBeJ9JrQIgaS7Yxr+6aNMSdE3/fP7w29SV7Ax
	 SZU95Y2E/dHSca4h3ffD9P+D8/i4ys/jJJg8JFLQNuKoqehGz7S9NLz8IAeNJrssGR
	 A4WSVgIg/Z7xw4Jr7cAC5dmTmJjG1DAgS2k1hyh2H/DXcJRT/9bhpM1jbGmiR+sQ2g
	 ORVWNMysfNEkeTEh2j27uURp7POTV8l6gcBO8c2EYBa167vFBmcR/LLZHPQZGsbw4r
	 v1N7ZQxnuQcAA==
Date: Mon, 23 Dec 2024 14:03:10 -0800
Subject: [PATCH 19/52] xfs: export the geometry of realtime groups to
 userspace
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498942786.2295836.5705409182364111403.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 3fa7a6d0c7eb264e469eaf1e3ef59b6793a853ee

Create an ioctl so that the kernel can report the status of realtime
groups to userspace.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/util.c        |    7 +++++++
 libxfs/xfs_fs.h      |   16 ++++++++++++++++
 libxfs/xfs_health.h  |    2 ++
 libxfs/xfs_rtgroup.c |   14 ++++++++++++++
 libxfs/xfs_rtgroup.h |    4 ++++
 5 files changed, 43 insertions(+)


diff --git a/libxfs/util.c b/libxfs/util.c
index 83f2f048bbe9f2..ed48e2045b484b 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -492,6 +492,13 @@ xfs_fs_mark_healthy(
 }
 
 void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometry *ageo) { }
+void
+xfs_rtgroup_geom_health(
+	struct xfs_rtgroup		*rtg,
+	struct xfs_rtgroup_geometry	*rgeo)
+{
+	/* empty */
+}
 void xfs_fs_mark_sick(struct xfs_mount *mp, unsigned int mask) { }
 void xfs_agno_mark_sick(struct xfs_mount *mp, xfs_agnumber_t agno,
 		unsigned int mask) { }
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 5c224d03270ce9..4c0682173d6144 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
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
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index 3d93b57cf57143..d34986ac18c3fa 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -278,6 +278,8 @@ xfs_inode_is_healthy(struct xfs_inode *ip)
 
 void xfs_fsop_geom_health(struct xfs_mount *mp, struct xfs_fsop_geom *geo);
 void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
+void xfs_rtgroup_geom_health(struct xfs_rtgroup *rtg,
+		struct xfs_rtgroup_geometry *rgeo);
 void xfs_bulkstat_health(struct xfs_inode *ip, struct xfs_bulkstat *bs);
 
 #define xfs_metadata_is_sick(error) \
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index f753ed5fc05588..50cfb038f03b79 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -211,6 +211,20 @@ xfs_rtgroup_trans_join(
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
 
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index fba62b26912a89..026f34f984b32f 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
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

