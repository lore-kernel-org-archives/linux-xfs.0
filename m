Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE60C129
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="boavxlZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4239FC433C7;
	Sun, 31 Dec 2023 22:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060107;
	bh=fo/3UPIT5NSa1VBdubce+qAawWsOg9L0Lk1kNKPicNI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=boavxlZ5ISHlpG8ZT32aL5qsKXB30QgueF8PVYTn/4t211W/GIV3GvZeO1pHdSoEc
	 meOLlY+c2kGu+y6XIYqU2WYgji5Uk8NhCKh1u6syZp8qAXK2ZLziFf41iIQj6BWfhc
	 OgkJfNUm5UpLY/Y0Sbuhq2+ynANkXbJU3xR9tHyhQAHjrQ/effIF9hUTUwC4U9XE6u
	 +edZpl8BJMOG7/ljpVaLFm1FkntkIvCAIysGJU5wehdQo6AbUQjLv+11d9KN2smAUx
	 UzmgP3jtaFCt3yygI6+iA51MG2sumOmsEWbYY+w9Ng5EKtTqmbaf4jS+o2r2RANhbm
	 YIc7BrBaxHeCQ==
Date: Sun, 31 Dec 2023 14:01:46 -0800
Subject: [PATCH 4/5] xfs: enable userspace to hide an AG from allocation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404854787.1769671.8982987186849794848.stgit@frogsfrogsfrogs>
In-Reply-To: <170404854709.1769671.12231107418026207335.stgit@frogsfrogsfrogs>
References: <170404854709.1769671.12231107418026207335.stgit@frogsfrogsfrogs>
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

Add an administrative interface so that userspace can hide an allocation
group from block allocation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_fs.h |    5 ++++
 fs/xfs/xfs_ioctl.c     |    4 +++-
 3 files changed, 62 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index a855f943cfad9..183f46edb5d15 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -1075,6 +1075,54 @@ xfs_ag_extend_space(
 	return 0;
 }
 
+/* Compute the AG geometry flags. */
+static inline uint32_t
+xfs_ag_calc_geoflags(
+	struct xfs_perag	*pag)
+{
+	uint32_t		ret = 0;
+
+	if (xfs_perag_prohibits_alloc(pag))
+		ret |= XFS_AG_FLAG_NOALLOC;
+
+	return ret;
+}
+
+/*
+ * Compare the current AG geometry flags against the flags in the AG geometry
+ * structure and update the AG state to reflect any changes, then update the
+ * struct to reflect the current status.
+ */
+static inline int
+xfs_ag_update_geoflags(
+	struct xfs_perag	*pag,
+	struct xfs_ag_geometry	*ageo,
+	uint32_t		new_flags)
+{
+	uint32_t		old_flags = xfs_ag_calc_geoflags(pag);
+	int			error;
+
+	if (!(new_flags & XFS_AG_FLAG_UPDATE)) {
+		ageo->ag_flags = old_flags;
+		return 0;
+	}
+
+	if ((old_flags & XFS_AG_FLAG_NOALLOC) &&
+	    !(new_flags & XFS_AG_FLAG_NOALLOC)) {
+		xfs_ag_clear_noalloc(pag);
+	}
+
+	if (!(old_flags & XFS_AG_FLAG_NOALLOC) &&
+	    (new_flags & XFS_AG_FLAG_NOALLOC)) {
+		error = xfs_ag_set_noalloc(pag);
+		if (error)
+			return error;
+	}
+
+	ageo->ag_flags = xfs_ag_calc_geoflags(pag);
+	return 0;
+}
+
 /* Retrieve AG geometry. */
 int
 xfs_ag_get_geometry(
@@ -1086,6 +1134,7 @@ xfs_ag_get_geometry(
 	struct xfs_agi		*agi;
 	struct xfs_agf		*agf;
 	unsigned int		freeblks;
+	uint32_t		inflags = ageo->ag_flags;
 	int			error;
 
 	/* Lock the AG headers. */
@@ -1096,6 +1145,10 @@ xfs_ag_get_geometry(
 	if (error)
 		goto out_agi;
 
+	error = xfs_ag_update_geoflags(pag, ageo, inflags);
+	if (error)
+		goto out;
+
 	/* Fill out form. */
 	memset(ageo, 0, sizeof(*ageo));
 	ageo->ag_number = pag->pag_agno;
@@ -1113,6 +1166,7 @@ xfs_ag_get_geometry(
 	ageo->ag_freeblks = freeblks;
 	xfs_ag_geom_health(pag, ageo);
 
+out:
 	/* Release resources. */
 	xfs_buf_relse(agf_bp);
 out_agi:
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 4159e96d01ae6..96688f9301e08 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -305,6 +305,11 @@ struct xfs_ag_geometry {
 #define XFS_AG_GEOM_SICK_REFCNTBT (1 << 9)  /* reference counts */
 #define XFS_AG_GEOM_SICK_INODES	(1 << 10) /* bad inodes were seen */
 
+#define XFS_AG_FLAG_UPDATE	(1 << 0)  /* update flags */
+#define XFS_AG_FLAG_NOALLOC	(1 << 1)  /* do not allocate from this AG */
+#define XFS_AG_FLAG_ALL		(XFS_AG_FLAG_UPDATE | \
+				 XFS_AG_FLAG_NOALLOC)
+
 /*
  * Structures for XFS_IOC_FSGROWFSDATA, XFS_IOC_FSGROWFSLOG & XFS_IOC_FSGROWFSRT
  */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index f85d5f142d180..d17b17e7eea1d 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -976,10 +976,12 @@ xfs_ioc_ag_geometry(
 
 	if (copy_from_user(&ageo, arg, sizeof(ageo)))
 		return -EFAULT;
-	if (ageo.ag_flags)
+	if (ageo.ag_flags & ~XFS_AG_FLAG_ALL)
 		return -EINVAL;
 	if (memchr_inv(&ageo.ag_reserved, 0, sizeof(ageo.ag_reserved)))
 		return -EINVAL;
+	if ((ageo.ag_flags & XFS_AG_FLAG_UPDATE) && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
 
 	pag = xfs_perag_get(mp, ageo.ag_number);
 	if (!pag)

