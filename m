Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DF71B0414
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688238; cv=none; b=mcyMVstfT3VcW8z/2zLH3J0xxxjDqkChRjrzHanM2N6ojSHxone5HvsqQCwG0NfAk15Bgt/+0rGiYiAlpv/uZ1rLgsAgzfhzmATO/pjv5ewD3jMsTP1AJo2CMdPoYSPwxTNKAyma8nDBaYRhaVSPB7Wk0qH+su4875ad1s26TVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688238; c=relaxed/simple;
	bh=Qd+cg/HDMBw+HHeO1vMop+1SumkaqmCfQTnb0hOx9QI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kj/aNoZPCkcjfm8ekM/8S8l2RSwAMHOc2Fyz6KQDbrhJHSRBltzbGS+CLaezjc3kkUlKxSbxtZi7w6FsEv+YTLLIfQ+GLBLMS2VvFOdrY5LC1ua1M3+APpdZK65qU/Wb8wgm9VLZFaegE4zd10kCV1qFN5dhXeI7iFQpVyO8U6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BImphp+v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BImphp+v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30AEC4CED2;
	Tue, 31 Dec 2024 23:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688237;
	bh=Qd+cg/HDMBw+HHeO1vMop+1SumkaqmCfQTnb0hOx9QI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BImphp+vlGBgn1SflNdiWqu6ALeGo8aK9ftoHmfLg2ggkKIOiYmQUUkQwFzUu+lip
	 1sI2IGpqcIuc3dMKDZSvaeFKJCmP6s+YE70qi/oPxsk3HkAtIrLA91W7A/Gwu7cYQO
	 6BcACEMNARoeBSXrXh5VnSdxLKXHa8lg1g9wO+czZUwyeJ6WqmZ/hI21J+rPd+DP+J
	 N3w5igFN+rBerrjnrXnrjLEkd0pxfRYp3t+1NN0/rc8rAMysPBIbFxogFp2Yr7pS/6
	 n8V09sZa8WQmT+F9U+AX41hsWdriGcojtnXVxyC5FX56gV+GDU+QvYHMIGvayyNLA9
	 hmlUI08OxNtHA==
Date: Tue, 31 Dec 2024 15:37:17 -0800
Subject: [PATCH 4/5] xfs: enable userspace to hide an AG from allocation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568753392.2704399.9749035148819907124.stgit@frogsfrogsfrogs>
In-Reply-To: <173568753306.2704399.16022227525226280055.stgit@frogsfrogsfrogs>
References: <173568753306.2704399.16022227525226280055.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_ag.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_fs.h |    5 ++++
 fs/xfs/xfs_ioctl.c     |    4 +++-
 3 files changed, 62 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 1e65cd981afd49..c538a5bfb4e330 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -932,6 +932,54 @@ xfs_ag_extend_space(
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
@@ -943,6 +991,7 @@ xfs_ag_get_geometry(
 	struct xfs_agi		*agi;
 	struct xfs_agf		*agf;
 	unsigned int		freeblks;
+	uint32_t		inflags = ageo->ag_flags;
 	int			error;
 
 	/* Lock the AG headers. */
@@ -953,6 +1002,10 @@ xfs_ag_get_geometry(
 	if (error)
 		goto out_agi;
 
+	error = xfs_ag_update_geoflags(pag, ageo, inflags);
+	if (error)
+		goto out;
+
 	/* Fill out form. */
 	memset(ageo, 0, sizeof(*ageo));
 	ageo->ag_number = pag_agno(pag);
@@ -970,6 +1023,7 @@ xfs_ag_get_geometry(
 	ageo->ag_freeblks = freeblks;
 	xfs_ag_geom_health(pag, ageo);
 
+out:
 	/* Release resources. */
 	xfs_buf_relse(agf_bp);
 out_agi:
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 12463ba766da05..b391bf9de93dbf 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
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
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d3cf62d81f0d17..874e2def3d6e63 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -385,10 +385,12 @@ xfs_ioc_ag_geometry(
 
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

