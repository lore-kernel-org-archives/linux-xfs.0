Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692FF148827
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733529379; cv=none; b=FZmOrfdZDgw/APWQIZ/Z6DkyOW5w2+nxUPAqpCAgqINN5yDSdfcq7lXzK+5LiENULJYlSSDCIkQHmMeREzdUmLEvLabQayC5xrkG7nY8igYrnQgsiiRgb0mJObEsbLk4qTHnD+vgnDGpdXjsGP3G7Q8EmKQTPRb7y2E6TaKFZ/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733529379; c=relaxed/simple;
	bh=gvKRscmlLuSZ3PqmWUMjmhpLJIhiAYUfYggOjzud2Bs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MW0WIY0lpnfiaBRXjjZkX1mTl+lV6kWGdEiIPoDUlQrJEmDByk/xv2FuLyi8iEUjxt+/J3V0libpRZRDOxdANnZBjs9TDPp1/SGqLl5cnERSDAphDnvcejvIDcSrKkYUYwzSsuiqvyVWBNoC64G2NobL/pksHXEoqRqpxTt8Eow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pbcplmQQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pbcplmQQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47568C4CED1;
	Fri,  6 Dec 2024 23:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733529379;
	bh=gvKRscmlLuSZ3PqmWUMjmhpLJIhiAYUfYggOjzud2Bs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pbcplmQQv3NNVBmIzEWo9XXR9+lnIYAkh4jP5uXVZfjcxDSzX4vD/tai69cKqu/fi
	 4MVlneQf6fjraZK3DL1SIPABkBBppjfshVUQKcv7i289tG5O0GV+wfRImFbMyEV6EN
	 eqNpOETZHYI8h8+uBbqUGgU7BsxZZ9Ll8WFhHeCbflmTCyZxYFoxn18T2K8Bdkm+sV
	 4Ds2UgsXic4AI2hN97aMgx+04cHWXIdjvYl1j54U3FLiEHkCUSpIQelSkg0sqbXpd3
	 Oza0682RXlzA92RxuLNfBQiN8/UG7Dtqab5/J5YyR7mN31353QWQEHGxQxaBuXeLbM
	 n0O9OsP4jrakA==
Date: Fri, 06 Dec 2024 15:56:18 -0800
Subject: [PATCH 19/46] xfs: export the geometry of realtime groups to
 userspace
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352750285.124560.7877645330844796851.stgit@frogsfrogsfrogs>
In-Reply-To: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
References: <173352749923.124560.17452697523660805471.stgit@frogsfrogsfrogs>
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

