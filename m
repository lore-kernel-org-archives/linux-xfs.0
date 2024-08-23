Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99D1171A5
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372862; cv=none; b=Tupe9pjYEhORI5gGM7Yl7yQuYT4/xtYMsQDKoho6HZ+qxyiG4E3uUAo+GYoc42AHL+7RLp+BmPdVqjTGPsbBHN4x/NogcluQ48t0A1TmC8wOINNCv8ly2qNKrFkcadr/gmnaUuTplSGXZ3nZ8ZmYshn8BFQ0yj32FLvEMbhUWDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372862; c=relaxed/simple;
	bh=qFd35SAskEiLbZmUQKyZM+toOquoS0SMn2A0SlEljUw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gbi5cx3pMsPiyiWq4xzVEsUaaX5rsHvKKH3opzFj8N1bQxqSXA7vMQB3krtzm56ZKEYVCWXdRsAf5gOybAr3Dp7D3WECnymvRwLwmKx3UX9EvASnJc3p0fOeDkhPTNF4a95jiCem6Oi032ErFl+4VRZShb0BNsSIQS6F5nFORlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CLit8wLd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CLit8wLd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7BA9C32782;
	Fri, 23 Aug 2024 00:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372861;
	bh=qFd35SAskEiLbZmUQKyZM+toOquoS0SMn2A0SlEljUw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CLit8wLd4HPVa1xENI01RqmuSMmIkKJFSL7q2w7AZeKO2VcYXLyLeJHQRssx9TSdY
	 qSxU6D1ckWJSNOqloeB/NbN48llRoDv2YKbhTOuJ5QHsJqL3KIkmjd47o67AlFgV8J
	 BF/ILgpV2q64eYVBBDLAGtuDm+K28ay1CPYFPJn86NKF5Dh2aG5G+vtiuKCoHzHJih
	 Yd0+zHZ8Y6mJSFThZK8IqEnyf3XVi8UVQA5slZUVpfBb0t8viaUd69i2nZxRyf2/HX
	 tzU1Rz9UMbml/MSSAD/tj0yOoTTaJtw9JHifZ18TDH/ZlZiDMQK+uITL3thyy1z+uB
	 qcS4KjwZJMDfg==
Date: Thu, 22 Aug 2024 17:27:41 -0700
Subject: [PATCH 25/26] xfs: scrub metadir paths for rtgroup metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437088956.60592.4570792855287818081.stgit@frogsfrogsfrogs>
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

Add the code we need to scan the metadata directory paths of rt group
metadata files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h  |    5 ++-
 fs/xfs/scrub/metapath.c |   92 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 96 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 07337958fc41a..11fa3d0c38086 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -822,9 +822,12 @@ struct xfs_scrub_vec_head {
  * path checking.
  */
 #define XFS_SCRUB_METAPATH_PROBE	(0)  /* do we have a metapath scrubber? */
+#define XFS_SCRUB_METAPATH_RTDIR	(1)  /* rtrgroups metadir */
+#define XFS_SCRUB_METAPATH_RTBITMAP	(2)  /* per-rtg bitmap */
+#define XFS_SCRUB_METAPATH_RTSUMMARY	(3)  /* per-rtg summary */
 
 /* Number of metapath sm_ino values */
-#define XFS_SCRUB_METAPATH_NR		(1)
+#define XFS_SCRUB_METAPATH_NR		(4)
 
 /*
  * ioctl limits
diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
index edc1a395c4015..e5714655152db 100644
--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -20,6 +20,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_trans_space.h"
 #include "xfs_attr.h"
+#include "xfs_rtgroup.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -79,6 +80,91 @@ xchk_metapath_cleanup(
 	kfree(mpath->path);
 }
 
+/* Set up a metadir path scan.  @path must be dynamically allocated. */
+static inline int
+xchk_setup_metapath_scan(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*dp,
+	const char		*path,
+	struct xfs_inode	*ip)
+{
+	struct xchk_metapath	*mpath;
+	int			error;
+
+	if (!path)
+		return -ENOMEM;
+
+	error = xchk_install_live_inode(sc, ip);
+	if (error) {
+		kfree(path);
+		return error;
+	}
+
+	mpath = kzalloc(sizeof(struct xchk_metapath), XCHK_GFP_FLAGS);
+	if (!mpath) {
+		kfree(path);
+		return -ENOMEM;
+	}
+
+	mpath->sc = sc;
+	sc->buf = mpath;
+	sc->buf_cleanup = xchk_metapath_cleanup;
+
+	mpath->dp = dp;
+	mpath->path = path; /* path is now owned by mpath */
+
+	mpath->xname.name = mpath->path;
+	mpath->xname.len = strlen(mpath->path);
+	mpath->xname.type = xfs_mode_to_ftype(VFS_I(ip)->i_mode);
+
+	return 0;
+}
+
+#ifdef CONFIG_XFS_RT
+/* Scan the /rtgroups directory itself. */
+static int
+xchk_setup_metapath_rtdir(
+	struct xfs_scrub	*sc)
+{
+	if (!sc->mp->m_rtdirip)
+		return -ENOENT;
+
+	return xchk_setup_metapath_scan(sc, sc->mp->m_metadirip,
+			kasprintf(GFP_KERNEL, "rtgroups"), sc->mp->m_rtdirip);
+}
+
+/* Scan a rtgroup inode under the /rtgroups directory. */
+static int
+xchk_setup_metapath_rtginode(
+	struct xfs_scrub	*sc,
+	enum xfs_rtg_inodes	type)
+{
+	struct xfs_rtgroup	*rtg;
+	struct xfs_inode	*ip;
+	int			error;
+
+	rtg = xfs_rtgroup_get(sc->mp, sc->sm->sm_agno);
+	if (!rtg)
+		return -ENOENT;
+
+	ip = rtg->rtg_inodes[type];
+	if (!ip) {
+		error = -ENOENT;
+		goto out_put_rtg;
+	}
+
+	error = xchk_setup_metapath_scan(sc, sc->mp->m_rtdirip,
+			xfs_rtginode_path(rtg->rtg_rgno, type), ip);
+
+out_put_rtg:
+	xfs_rtgroup_put(rtg);
+	return error;
+}
+#else
+# define xchk_setup_metapath_rtdir(...)		(-ENOENT)
+# define xchk_setup_metapath_rtginode(...)	(-ENOENT)
+#endif /* CONFIG_XFS_RT */
+
 int
 xchk_setup_metapath(
 	struct xfs_scrub	*sc)
@@ -94,6 +180,12 @@ xchk_setup_metapath(
 		if (sc->sm->sm_agno)
 			return -EINVAL;
 		return 0;
+	case XFS_SCRUB_METAPATH_RTDIR:
+		return xchk_setup_metapath_rtdir(sc);
+	case XFS_SCRUB_METAPATH_RTBITMAP:
+		return xchk_setup_metapath_rtginode(sc, XFS_RTGI_BITMAP);
+	case XFS_SCRUB_METAPATH_RTSUMMARY:
+		return xchk_setup_metapath_rtginode(sc, XFS_RTGI_SUMMARY);
 	default:
 		return -ENOENT;
 	}

