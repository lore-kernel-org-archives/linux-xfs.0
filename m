Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D9B1B0414
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688629; cv=none; b=hVF1vkQrifoNiP3Vor36P6mZXLgs45tG//eze4xH4EzUstVjnE72uUgJfcSN5Otl4Aaac6cHSPe3L/33AktD8YYlOjoB7nV3sQT/J2o5WUyk22YeP8U5XtdgRxF3FBiuSC2HgcHoCYo2R78RGUKiIW1MlfNQzUigW5zGMlKlyMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688629; c=relaxed/simple;
	bh=T+R0DUVU6aRc3tSIpZJ+ojcFn5JJ6Xtu2UgxoZ9j92Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ecMD32+HRXfDuDrtYEUE6VlMLAlMhdeva1j5V4zmlN3UcFlU/VTAwH+7YDA/vm8KCfiyP7xBxiHV75Gt7JVfhjB3V2U+MZgUbWWSyzsYdv1vqRjNzjN17O9829VnLFGxIRt3VX/CdPzMsLgyW7ka1Hl4wBN+11/kXw8wOqt5eVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gDEdVmPF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gDEdVmPF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5923C4CED2;
	Tue, 31 Dec 2024 23:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688628;
	bh=T+R0DUVU6aRc3tSIpZJ+ojcFn5JJ6Xtu2UgxoZ9j92Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gDEdVmPFY1HmS/lT8Nm9fzB0bDK+tCtG3xYWM21GwcxfQLmvb6ol2Yvlzj+ssPp46
	 eXA3VQPyVrfZARmXon2dbtKgzIGbFbsS14vr6NM4dUc1BK1SrGIAeYBP7lIo7WY/Qg
	 giuOkEblBuyNmPjV6U29yCSCpmbrWTyNb62SYcNMHhRIh5SjzcyqrixcMaCPmj+LKZ
	 OKy0vswKfNsICWp4p+z19iUKeDA+H+ibpoBTOORZ0Jme/Nb+Q+fzOFNeMp83QMKk/m
	 MInrIqZPzoR2uKj9Dvoq2vGf7jXR874wc3FFF15+u5UCMgt6gOe3J7TNs5nqLi4aVK
	 wzWZY/FZiaIJw==
Date: Tue, 31 Dec 2024 15:43:48 -0800
Subject: [PATCH 3/5] xfs: enable userspace to hide an AG from allocation
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568777054.2709441.1315096884845974561.stgit@frogsfrogsfrogs>
In-Reply-To: <173568777001.2709441.13781927144429990672.stgit@frogsfrogsfrogs>
References: <173568777001.2709441.13781927144429990672.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/xfs_ag.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_fs.h |    5 +++++
 2 files changed, 59 insertions(+)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 462d16347cadb9..b3e21e0d26a36c 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -930,6 +930,54 @@ xfs_ag_extend_space(
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
@@ -941,6 +989,7 @@ xfs_ag_get_geometry(
 	struct xfs_agi		*agi;
 	struct xfs_agf		*agf;
 	unsigned int		freeblks;
+	uint32_t		inflags = ageo->ag_flags;
 	int			error;
 
 	/* Lock the AG headers. */
@@ -951,6 +1000,10 @@ xfs_ag_get_geometry(
 	if (error)
 		goto out_agi;
 
+	error = xfs_ag_update_geoflags(pag, ageo, inflags);
+	if (error)
+		goto out;
+
 	/* Fill out form. */
 	memset(ageo, 0, sizeof(*ageo));
 	ageo->ag_number = pag_agno(pag);
@@ -968,6 +1021,7 @@ xfs_ag_get_geometry(
 	ageo->ag_freeblks = freeblks;
 	xfs_ag_geom_health(pag, ageo);
 
+out:
 	/* Release resources. */
 	xfs_buf_relse(agf_bp);
 out_agi:
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 12463ba766da05..b391bf9de93dbf 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -307,6 +307,11 @@ struct xfs_ag_geometry {
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

