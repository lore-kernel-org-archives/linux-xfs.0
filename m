Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5751AD49
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372173; cv=none; b=Fe+pUWoxthCFyBtitQlj83xgWYRR/2+z71WTE/1QhYyCLFNkdk5FKUvG8vrPSWOi2gFdTlOFXWRp/WZZ/OrKz8OSYdAP0cU7+Zj1s/OfDgiFqhF5f77hza35tpPRM6Fj9FnAlYrqha1ku28jkMKgCU2ksIgQHRdFBfYXVJwz+4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372173; c=relaxed/simple;
	bh=GDcTW74R+eO2uTLKY0/lYmBr6EfW56QBA7mMFjRtfzU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BcjILwyoHiE0k2o8uOKADLD5CVJn46CHxTzCVdWHRaQddPuzasQDz/whwi2HlTd9jRz9GauOQBt3BpJWduBgICAMQZmz4jlrTvVDM3yccdV/LZ1oHu+1qqltXemC4QbnVGt4qKjbyoY+JA3aIOh07sc6JTpWBwxn9Wh8VhigGGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tTx+q1bk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tTx+q1bk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED50C32782;
	Fri, 23 Aug 2024 00:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372173;
	bh=GDcTW74R+eO2uTLKY0/lYmBr6EfW56QBA7mMFjRtfzU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tTx+q1bkgiHwHsCep/Kit0ur4EsJUkcyhufM1xzdiTiXkE8QPvLQXkUDSRxw/Wo61
	 rKrbxJsecYu/ftnp0jNT1x620io0CmFZFMJKxdB4yrsL0URsffsj0FXIHDDFYcYx8m
	 ofDbRm+b3bZcG/YWLGs7wSasw+hLCeEBIwIfqXHaajL1KPnemPMYLWn71X374DnZnx
	 ppBATw8O4saaJMbgSvtjd6rWyp1Gel0JshP8ZHTN8CGtnM9QRhWqGe0TzYEcwCnzgd
	 vlohhujA/cbCvVZcXmzDAXlqJxAOk9xfWno67fUtO5n1CLSahjAZZVs0GbRJBd4K43
	 JDZG++U4YjMCQ==
Date: Thu, 22 Aug 2024 17:16:13 -0700
Subject: [PATCH 06/24] xfs: add xchk_setup_nothing and xchk_nothing helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437087346.59588.5144524048217225071.stgit@frogsfrogsfrogs>
In-Reply-To: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
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

Add common helpers for no-op scrubbing methods.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
[hch: split from a larger patch]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/common.h |   29 +++++++++--------------------
 fs/xfs/scrub/scrub.h  |   29 +++++++++--------------------
 2 files changed, 18 insertions(+), 40 deletions(-)


diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 96fe6ef5f4dc7..27e5bf8f7c60b 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -53,6 +53,11 @@ int xchk_checkpoint_log(struct xfs_mount *mp);
 bool xchk_should_check_xref(struct xfs_scrub *sc, int *error,
 			   struct xfs_btree_cur **curpp);
 
+static inline int xchk_setup_nothing(struct xfs_scrub *sc)
+{
+	return -ENOENT;
+}
+
 /* Setup functions */
 int xchk_setup_agheader(struct xfs_scrub *sc);
 int xchk_setup_fs(struct xfs_scrub *sc);
@@ -73,16 +78,8 @@ int xchk_setup_metapath(struct xfs_scrub *sc);
 int xchk_setup_rtbitmap(struct xfs_scrub *sc);
 int xchk_setup_rtsummary(struct xfs_scrub *sc);
 #else
-static inline int
-xchk_setup_rtbitmap(struct xfs_scrub *sc)
-{
-	return -ENOENT;
-}
-static inline int
-xchk_setup_rtsummary(struct xfs_scrub *sc)
-{
-	return -ENOENT;
-}
+# define xchk_setup_rtbitmap		xchk_setup_nothing
+# define xchk_setup_rtsummary		xchk_setup_nothing
 #endif
 #ifdef CONFIG_XFS_QUOTA
 int xchk_ino_dqattach(struct xfs_scrub *sc);
@@ -94,16 +91,8 @@ xchk_ino_dqattach(struct xfs_scrub *sc)
 {
 	return 0;
 }
-static inline int
-xchk_setup_quota(struct xfs_scrub *sc)
-{
-	return -ENOENT;
-}
-static inline int
-xchk_setup_quotacheck(struct xfs_scrub *sc)
-{
-	return -ENOENT;
-}
+# define xchk_setup_quota		xchk_setup_nothing
+# define xchk_setup_quotacheck		xchk_setup_nothing
 #endif
 int xchk_setup_fscounters(struct xfs_scrub *sc);
 int xchk_setup_nlinks(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index ab143c7a531e8..c688ff4fc7fc4 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -232,6 +232,11 @@ xchk_should_terminate(
 	return false;
 }
 
+static inline int xchk_nothing(struct xfs_scrub *sc)
+{
+	return -ENOENT;
+}
+
 /* Metadata scrubbers */
 int xchk_tester(struct xfs_scrub *sc);
 int xchk_superblock(struct xfs_scrub *sc);
@@ -256,31 +261,15 @@ int xchk_metapath(struct xfs_scrub *sc);
 int xchk_rtbitmap(struct xfs_scrub *sc);
 int xchk_rtsummary(struct xfs_scrub *sc);
 #else
-static inline int
-xchk_rtbitmap(struct xfs_scrub *sc)
-{
-	return -ENOENT;
-}
-static inline int
-xchk_rtsummary(struct xfs_scrub *sc)
-{
-	return -ENOENT;
-}
+# define xchk_rtbitmap		xchk_nothing
+# define xchk_rtsummary		xchk_nothing
 #endif
 #ifdef CONFIG_XFS_QUOTA
 int xchk_quota(struct xfs_scrub *sc);
 int xchk_quotacheck(struct xfs_scrub *sc);
 #else
-static inline int
-xchk_quota(struct xfs_scrub *sc)
-{
-	return -ENOENT;
-}
-static inline int
-xchk_quotacheck(struct xfs_scrub *sc)
-{
-	return -ENOENT;
-}
+# define xchk_quota		xchk_nothing
+# define xchk_quotacheck	xchk_nothing
 #endif
 int xchk_fscounters(struct xfs_scrub *sc);
 int xchk_nlinks(struct xfs_scrub *sc);

