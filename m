Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709F952F6F
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713388875; cv=none; b=kursb532BqI8zULjWF+CR5n7+Y0eDnO3GYd+BfI+uu9+rsZIxOHDoBuk39ySQVhfOgJjt7KzBWjqTXd1iZB30cJgB0qRK6yC9GBelvvNBTowA6HMdYiqy5stRa5RQZzc/AnYEk/uIREydjgS1pPWLdavk+oXUYiIiMMK1BhfJPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713388875; c=relaxed/simple;
	bh=hZTw5q+G91yZ/khXHQWi5zFnVY7TD20HrSB/qsdGNBo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IqcEiGo8GGuxtS9N18DwBLPLOn41udZ3uA8tIRkzqPmWuJr6BalLSNyQIxQj7Uc2Q0VtCf1odBonWLWf0+IFDtkDt/jXMT5RbH9HQkHNrI6l2rMICrLqwzKfMxyvxWKIqSzsJ+SZhjsGY8dipWiCE8BZ2jOVbjn1cMkBgkmDpCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VIHj/DNH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VIHj/DNH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC0BC2BD11;
	Wed, 17 Apr 2024 21:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713388875;
	bh=hZTw5q+G91yZ/khXHQWi5zFnVY7TD20HrSB/qsdGNBo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VIHj/DNHNqtedfhV8bWxqQeGpEJSIPc9n/30SG+MPlMIlV6KKXv+YNZtU7rk0LIVi
	 24ePc5G+o+X995MVmB4MPd7zWZ7ADTdIUssUYxgiKZAUnlhzSFr92uuUCZl/GHBYoI
	 DmRp49mcUSw+QOj78U5jYqCvBxRC+5SBdho6snDB3pzilNt4paNXq87iZL3uhQ45xT
	 lm48oqUVpxc1ED70+qIStLKRqFQIMYBph6ZxRz0kk0bhm42wwnkP/YWHRTMQKQef6L
	 QyI/jKjoqdcrlekbZZz514KQWT7q6h+4/8rX6h8xe47tYRWePdCG4bJ+vDljuS67FW
	 yw1dVrYc8qKmQ==
Date: Wed, 17 Apr 2024 14:21:14 -0700
Subject: [PATCH 09/11] xfs_{db,repair}: use helpers for rtsummary
 block/wordcount computations
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338841872.1853034.13554903925196665377.stgit@frogsfrogsfrogs>
In-Reply-To: <171338841726.1853034.8225385129852277375.stgit@frogsfrogsfrogs>
References: <171338841726.1853034.8225385129852277375.stgit@frogsfrogsfrogs>
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

Port xfs_db and xfs_repair to use the new helper functions that compute
the number of blocks or words necessary to store the rt summary file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 db/check.c               |    8 ++++++--
 libxfs/init.c            |    8 ++++----
 libxfs/libxfs_api_defs.h |    2 ++
 repair/rt.c              |    5 ++++-
 4 files changed, 16 insertions(+), 7 deletions(-)


diff --git a/db/check.c b/db/check.c
index 3b3f90e5e..6e916f335 100644
--- a/db/check.c
+++ b/db/check.c
@@ -1944,10 +1944,14 @@ init(
 		inodata[c] = xcalloc(inodata_hash_size, sizeof(**inodata));
 	}
 	if (rt) {
+		unsigned long long	words;
+
 		dbmap[c] = xcalloc(mp->m_sb.sb_rblocks, sizeof(**dbmap));
 		inomap[c] = xcalloc(mp->m_sb.sb_rblocks, sizeof(**inomap));
-		sumfile = xcalloc(mp->m_rsumsize, 1);
-		sumcompute = xcalloc(mp->m_rsumsize, 1);
+		words = libxfs_rtsummary_wordcount(mp, mp->m_rsumlevels,
+				mp->m_sb.sb_rbmblocks);
+		sumfile = xcalloc(words, sizeof(xfs_suminfo_t));
+		sumcompute = xcalloc(words, sizeof(xfs_suminfo_t));
 	}
 	nflag = sflag = tflag = verbose = optind = 0;
 	while ((c = getopt(argc, argv, "b:i:npstv")) != EOF) {
diff --git a/libxfs/init.c b/libxfs/init.c
index 63c506a69..c903d6070 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -284,6 +284,7 @@ rtmount_init(
 {
 	struct xfs_buf	*bp;	/* buffer for last block of subvolume */
 	xfs_daddr_t	d;	/* address of last block of subvolume */
+	unsigned int	rsumblocks;
 	int		error;
 
 	if (mp->m_sb.sb_rblocks == 0)
@@ -309,10 +310,9 @@ rtmount_init(
 		return -1;
 	}
 	mp->m_rsumlevels = mp->m_sb.sb_rextslog + 1;
-	mp->m_rsumsize =
-		(uint)sizeof(xfs_suminfo_t) * mp->m_rsumlevels *
-		mp->m_sb.sb_rbmblocks;
-	mp->m_rsumsize = roundup(mp->m_rsumsize, mp->m_sb.sb_blocksize);
+	rsumblocks = xfs_rtsummary_blockcount(mp, mp->m_rsumlevels,
+			mp->m_sb.sb_rbmblocks);
+	mp->m_rsumsize = XFS_FSB_TO_B(mp, rsumblocks);
 	mp->m_rbmip = mp->m_rsumip = NULL;
 
 	/*
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index feecc05c4..e87195cb1 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -179,6 +179,8 @@
 #define xfs_rtbitmap_setword		libxfs_rtbitmap_setword
 #define xfs_rtbitmap_wordcount		libxfs_rtbitmap_wordcount
 
+#define xfs_rtsummary_wordcount		libxfs_rtsummary_wordcount
+
 #define xfs_rtfree_extent		libxfs_rtfree_extent
 #define xfs_rtfree_blocks		libxfs_rtfree_blocks
 #define xfs_sb_from_disk		libxfs_sb_from_disk
diff --git a/repair/rt.c b/repair/rt.c
index 213f08122..6ab709a00 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -34,7 +34,10 @@ rtinit(xfs_mount_t *mp)
 		do_error(
 	_("couldn't allocate memory for incore realtime bitmap.\n"));
 
-	if ((sumcompute = calloc(mp->m_rsumsize, 1)) == NULL)
+	wordcnt = libxfs_rtsummary_wordcount(mp, mp->m_rsumlevels,
+			mp->m_sb.sb_rbmblocks);
+	sumcompute = calloc(wordcnt, sizeof(xfs_suminfo_t));
+	if (!sumcompute)
 		do_error(
 	_("couldn't allocate memory for incore realtime summary info.\n"));
 }

