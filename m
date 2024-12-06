Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA20B1FA172
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528379; cv=none; b=Tc6OGNsOKpIt+68e675KYbHVa1XZ287wlTU2hJhJquk5nL8WFHLzZIBbxlHMdo9PAfOEg/tpSZKcIcvvmGf9bJrd2LcOyUyUNZflS6c6+UN7CDuNbKUEB6A+7pnOgMOzqrQLWoH8DXp4VjErC2Y2SJFnEjAZiV34Aw9dwWjDANk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528379; c=relaxed/simple;
	bh=XYEdP597n1D74NX5g9WtpTlQGZCdmx8TmnMroa+Dd9I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J/sgb9ImngEjlx4qVKekN8ppKqyZD0y5zAnbUGQAjZZZBt0Lc7PxbJCemfkEj6SYuI2LDemVEhbhZ9jGbGTCMeTjVv3zn4RlhBRmTuKMvF02efA64sW6hho3C2PW8wrWxUbuy5ieSij9RlBwOJ7v+XRm5EDoaPLRm/Vy/wxcDVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pE3pxqy8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pE3pxqy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5815AC4CED1;
	Fri,  6 Dec 2024 23:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528379;
	bh=XYEdP597n1D74NX5g9WtpTlQGZCdmx8TmnMroa+Dd9I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pE3pxqy8H6VXFEx1Ig5xzmxKKaotm7wJdMqlA1MjXdL0COqE+HqYck3UEla54jT6g
	 8mbKXv0aVYr1ZaL5h8lZwHbhNqxTs5XclGgnkbCivtVc0spRbkO/S2Kkozapl+lsVL
	 fzlYCFKvO7T0j/EwnBM2ournkvntf/loD8wMbAAc1bkkrR7X2TXZ8uIY0B4M+yK2GA
	 AltfgbtQV3aM/IGM9M0qmQMPcWgfAn9ieUJ/3ZyR7WXO6WwWn6uGON5STnTRIRU0Rn
	 TBKKY9BEfWE2r1tr6Nyp7pH4zH3yi04qmItu6GrMyqHpX5lVWWLVE6DlDsXMLI142O
	 80KL18ypF3E6Q==
Date: Fri, 06 Dec 2024 15:39:38 -0800
Subject: [PATCH 36/36] xfs: check metadata directory file path connectivity
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352747425.121772.5629402600312137149.stgit@frogsfrogsfrogs>
In-Reply-To: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
References: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
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

