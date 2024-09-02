Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5065680
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725301873; cv=none; b=KdvYQu3GX4FwaiKZB0R8FupOIEmweFXvNy21b3o/DtGdFfCjmRDr9O6QNphGbkecrUjYzA++KUi+2jCy0RSMzRNkGru6Kqk7VdevMqkoqsmlAcEs2W9I3Be8JMiHb23seuYgJwNxIxtDD6SRJ/r6jhLeq251LhwPl0hFOCOuf3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725301873; c=relaxed/simple;
	bh=8K+T8hUDe3kLobGyJGMCX+DhSoGBD/ofG7q0VuLb1Uw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rqBnb7oxmWcBkHS4B1VFs5CavP51T584VmJsOfDfO7xO/5kb9H5QVBzuuXp9KGv9SS7vnJzqVzZlCMfdd9Hl+s1kap+SpRBl+BsQpRq2DS4BS+4hzh8EkNxeIHtVfgzhNZfauuCScTmYiju062yRs0u0RKpSCiEklW8aasAiQyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P1U77ajd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P1U77ajd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A3BC4CEC2;
	Mon,  2 Sep 2024 18:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725301873;
	bh=8K+T8hUDe3kLobGyJGMCX+DhSoGBD/ofG7q0VuLb1Uw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=P1U77ajdegpFjnwsKo44SJMd1bxq/sG8nYzfrAjmbMJBgxMNmnlb3WKzZGGhlypi7
	 AZNYVLzHsojGJO53vGHeFLfOjf26y/H1PlMZRgXPZuby2pPstPyt9BrI+RRTvcQnVH
	 6dnI/BeaIf9DOgbp/HRdsHmOQ7yy6tWPS2sgHf7MVrvjncJPqpUHvbDZ1kD1FaF7tc
	 NDVkfBQCfXn1gGOLlCx3CQZsb8QzVK1Mu6WmYNWmaDtp9vu4jd6/666YiY8sCu+5Ou
	 92BBDdSH/+ro8Y3a4a717hXmug2ajXs1eAqeMjO9K/fxhT1VrZl4GcwkBzp8RKwj3S
	 M8XImD7DHXwUA==
Date: Mon, 02 Sep 2024 11:31:12 -0700
Subject: [PATCH 06/10] xfs: add xchk_setup_nothing and xchk_nothing helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <172530106865.3326080.8457881111716349121.stgit@frogsfrogsfrogs>
In-Reply-To: <172530106749.3326080.9105141649726807892.stgit@frogsfrogsfrogs>
References: <172530106749.3326080.9105141649726807892.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/common.h |   29 +++++++++--------------------
 fs/xfs/scrub/scrub.h  |   29 +++++++++--------------------
 2 files changed, 18 insertions(+), 40 deletions(-)


diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 3d5f1f6b4b7b..47148cc4a833 100644
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
@@ -72,16 +77,8 @@ int xchk_setup_dirtree(struct xfs_scrub *sc);
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
@@ -93,16 +90,8 @@ xchk_ino_dqattach(struct xfs_scrub *sc)
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
index 1bc33f010d0e..5993fcaffb2c 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -231,6 +231,11 @@ xchk_should_terminate(
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
@@ -254,31 +259,15 @@ int xchk_dirtree(struct xfs_scrub *sc);
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

