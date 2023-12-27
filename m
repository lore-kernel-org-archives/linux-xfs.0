Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226C37EF
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C/PgQ9Jk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A73C433C7;
	Mon,  1 Jan 2024 00:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069536;
	bh=sRu7lxnEjcAk7fTqGL8LwMYVhy92nBbxnWn/ApW9fDk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=C/PgQ9JkveZqRBN6vfb9JCqLmGv/XA4zbfRxrlvjtAymQc/XElSTF8gwch+P6mVXJ
	 jOggCUWcvRFTLMei+5rmtj7/KOQYwYH0KfCRBKin2cuHbIDh/1jbEjikrzhzfAdYoT
	 tgkO2JLaNkxRy1iA5s5KVevTluYdoFtDWsJnD+BrlHP6AN8IFSMXoAsdeYht7sSQAC
	 0CqcA/h5UxZ1nkw+jIu18K6GkYRYzgBhlFCr5nRfDtoiitnB3yjXf69hKJCHU8YD+z
	 4MIij7U7ZEEZDLOFZ29dqrfeLzGITMNN+QDpnGedTpeQCcMBJnqVec+mWqE55hWGE4
	 +rA+ocRwj6Vsg==
Date: Sun, 31 Dec 2023 16:38:56 +9900
Subject: [PATCH 3/5] xfs: enable userspace to hide an AG from allocation
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405019603.1820520.5253949405191543987.stgit@frogsfrogsfrogs>
In-Reply-To: <170405019560.1820520.7145960948523376788.stgit@frogsfrogsfrogs>
References: <170405019560.1820520.7145960948523376788.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_ag.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_fs.h |    5 +++++
 2 files changed, 59 insertions(+)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index c639e8e07d7..abc0a9d89c5 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -1073,6 +1073,54 @@ xfs_ag_extend_space(
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
@@ -1084,6 +1132,7 @@ xfs_ag_get_geometry(
 	struct xfs_agi		*agi;
 	struct xfs_agf		*agf;
 	unsigned int		freeblks;
+	uint32_t		inflags = ageo->ag_flags;
 	int			error;
 
 	/* Lock the AG headers. */
@@ -1094,6 +1143,10 @@ xfs_ag_get_geometry(
 	if (error)
 		goto out_agi;
 
+	error = xfs_ag_update_geoflags(pag, ageo, inflags);
+	if (error)
+		goto out;
+
 	/* Fill out form. */
 	memset(ageo, 0, sizeof(*ageo));
 	ageo->ag_number = pag->pag_agno;
@@ -1111,6 +1164,7 @@ xfs_ag_get_geometry(
 	ageo->ag_freeblks = freeblks;
 	xfs_ag_geom_health(pag, ageo);
 
+out:
 	/* Release resources. */
 	xfs_buf_relse(agf_bp);
 out_agi:
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 4159e96d01a..96688f9301e 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
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

