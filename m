Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC27C128387
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422138; cv=none; b=QeccnvGPJ2Z6aDlnz4lRWA5WOSLCZ6fl79Rtbz2V2IBqwA6yWGaBkdHmHbhOxb+dN5NLcsky2JryVuYA1wm1s5pEwwofLQ+wKNaLNsfTjBr+605Z2BswGuJILtT9We3Shvf1n3FS6hSupiDaMcm0WweXgJ8Xm1dcMVxtdLyQMnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422138; c=relaxed/simple;
	bh=kFDG61xmSR0y1QLbJczNLJA8tEc88pnd8sbrYqUb15Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ij/cI9bcaB+uDBjAdbqkaDO3DadrRcOS1yVrVxh9Rs3ihhropEeNaxvzyBLFz9J6Wi8RDNE1cRzJTbHNmEwo2mi3E9CExkpYK9Ti0vsgv+hZjqjTdd4jrw8jYAFTtUH64fNnKEVZTlT2lsO6o8QsywRNJdrlR6OxwEnuYBhMVqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MpwClX61; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MpwClX61"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8942AC433C7;
	Tue, 26 Mar 2024 03:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422138;
	bh=kFDG61xmSR0y1QLbJczNLJA8tEc88pnd8sbrYqUb15Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MpwClX61XvN+iNwFPjX7wJCz6U1HhJrkP4X4UKcCGi9yH1IIafj0JJp/0Ff5No4LW
	 QvB0Z5ZqOx6S8A5gaZTkIRVX5M2RCrzcJqTSTNfvrBK9BR0tjyE2bhCFrB0/W2URMc
	 Zkdm9JcWtY/RmlCvEc9EVt/DCYTSpAVUKuETQrXZW9SVg0U9T6hHv6pA+qoSsiA1yH
	 lbzuA4snmrkbnpGLkxMdUI6jHM3gAvs00nOmauG3yFHgZgWHx2HKB/L/Q1IGOY1C2S
	 OXWIKZ/FBBICba1i+UTcqGk0yzZaCjZDOgUDJA5FJ9ld81DBeviLAhenkXyNzglo6w
	 QGN0iAgfj+n1g==
Date: Mon, 25 Mar 2024 20:02:18 -0700
Subject: [PATCH 11/13] xfs_{db,repair}: use helpers for rtsummary
 block/wordcount computations
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142126466.2211955.3625156857436849739.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126291.2211955.14829143192552278353.stgit@frogsfrogsfrogs>
References: <171142126291.2211955.14829143192552278353.stgit@frogsfrogsfrogs>
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
index 3b3f90e5e0c9..6e916f335b14 100644
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
index 63c506a69964..c903d60707b7 100644
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
index feecc05c4ecc..e87195cb1ac9 100644
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
index 213f0812250e..6ab709a000cb 100644
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

