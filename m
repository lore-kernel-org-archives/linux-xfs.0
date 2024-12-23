Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDAB19048A
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990390; cv=none; b=na43y4pBPOAeVZG4yGquHnAYbq4Q2lApXLFRfVV0U/vPV123XkpnCpoZIpmr3SsEyMF3cEyrbIYL2lbMB2ij74zWu54YJHR3A7Grj6we6oVRHtE266l537WaQ33LveV/zq4NaWJqPnDPwfHierDanv7GM+T60OskkaIvhWdmaUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990390; c=relaxed/simple;
	bh=XYEdP597n1D74NX5g9WtpTlQGZCdmx8TmnMroa+Dd9I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rk8DbmCQCJRihuUjEwb+K2EGlknRSHZJ0ZznDYmEKGgff2TrG9kF9eyE2w7DswEaij+cCRpAd9uIlaJETr66lWrsGFxDISd4ZSoQ9SyldbtnY1Y4gbyDoFZFSS2PbaW9tREr0fHl+wMSwz36Ks+lZfMHrLxzc3H0qFJgGaQfrSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fns1/8iw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fns1/8iw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8205FC4CED3;
	Mon, 23 Dec 2024 21:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990390;
	bh=XYEdP597n1D74NX5g9WtpTlQGZCdmx8TmnMroa+Dd9I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fns1/8iwEhHHepbtLH8Ghm/vl956oV6ju53kwFvx6WXsHrcCILtNwDdSTnLl8Sfu4
	 yGjktQ6qeMKmbDTIQR+LN+dA1sXar05KiDEFEZL3hzlN9ZTGdzzl4dBNl+2/xyPo8j
	 wPbP0FmDmHedcw33FZ7or4mtVYzj8IeGtjhJP0Z8nJ6dn8o/GbhGJSqqarQdFRskw9
	 snJxdoUcuMv0tMb3+/FX0tINlbdaV4IniUCUOJNIP7pZvB3XLO8YQXCtnxS6A/ww6Y
	 M9V4vIbKpPb/ZwKMRUSZxytr653KSIjAK7iwQw1SooYVxyxeRpRMs5P7t9cpDIqqU2
	 KPKthLfTQQXIg==
Date: Mon, 23 Dec 2024 13:46:30 -0800
Subject: [PATCH 36/36] xfs: check metadata directory file path connectivity
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498940494.2293042.9286700350983497113.stgit@frogsfrogsfrogs>
In-Reply-To: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
References: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: b3c03efa5972f084e40104307dbe432359279cf2

Create a new scrubber type that checks that well known metadata
directory paths are connected to the metadata inode that the incore
structures think is in use.  For example, check that "/quota/user" in
the metadata directory tree actually points to
mp->m_quotainfo->qi_uquotaip->i_ino.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h     |   13 ++++++++++++-
 libxfs/xfs_health.h |    4 +++-
 2 files changed, 15 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index b05e6fb1470351..faa38a7d1eb019 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -199,6 +199,7 @@ struct xfs_fsop_geom {
 #define XFS_FSOP_GEOM_SICK_QUOTACHECK	(1 << 6)  /* quota counts */
 #define XFS_FSOP_GEOM_SICK_NLINKS	(1 << 7)  /* inode link counts */
 #define XFS_FSOP_GEOM_SICK_METADIR	(1 << 8)  /* metadata directory */
+#define XFS_FSOP_GEOM_SICK_METAPATH	(1 << 9)  /* metadir tree path */
 
 /* Output for XFS_FS_COUNTS */
 typedef struct xfs_fsop_counts {
@@ -732,9 +733,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_NLINKS	26	/* inode link counts */
 #define XFS_SCRUB_TYPE_HEALTHY	27	/* everything checked out ok */
 #define XFS_SCRUB_TYPE_DIRTREE	28	/* directory tree structure */
+#define XFS_SCRUB_TYPE_METAPATH	29	/* metadata directory tree paths */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	29
+#define XFS_SCRUB_TYPE_NR	30
 
 /*
  * This special type code only applies to the vectored scrub implementation.
@@ -812,6 +814,15 @@ struct xfs_scrub_vec_head {
 
 #define XFS_SCRUB_VEC_FLAGS_ALL		(0)
 
+/*
+ * i: sm_ino values for XFS_SCRUB_TYPE_METAPATH to select a metadata file for
+ * path checking.
+ */
+#define XFS_SCRUB_METAPATH_PROBE	(0)  /* do we have a metapath scrubber? */
+
+/* Number of metapath sm_ino values */
+#define XFS_SCRUB_METAPATH_NR		(1)
+
 /*
  * ioctl limits
  */
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index f90e8dfc050000..a23df94319e5fb 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -63,6 +63,7 @@ struct xfs_da_args;
 #define XFS_SICK_FS_QUOTACHECK	(1 << 4)  /* quota counts */
 #define XFS_SICK_FS_NLINKS	(1 << 5)  /* inode link counts */
 #define XFS_SICK_FS_METADIR	(1 << 6)  /* metadata directory tree */
+#define XFS_SICK_FS_METAPATH	(1 << 7)  /* metadata directory tree path */
 
 /* Observable health issues for realtime volume metadata. */
 #define XFS_SICK_RT_BITMAP	(1 << 0)  /* realtime bitmap */
@@ -107,7 +108,8 @@ struct xfs_da_args;
 				 XFS_SICK_FS_PQUOTA | \
 				 XFS_SICK_FS_QUOTACHECK | \
 				 XFS_SICK_FS_NLINKS | \
-				 XFS_SICK_FS_METADIR)
+				 XFS_SICK_FS_METADIR | \
+				 XFS_SICK_FS_METAPATH)
 
 #define XFS_SICK_RT_PRIMARY	(XFS_SICK_RT_BITMAP | \
 				 XFS_SICK_RT_SUMMARY)

