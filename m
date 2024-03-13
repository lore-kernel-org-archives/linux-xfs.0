Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2692DB652
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294752; cv=none; b=JggIRCTosjgcEBRrotC6tmlb94QIbiDP90TejrnK0iF9s44Be/4ONLfLr3yIliz0VR6SW9Iww6HJvPsJQIt58eDzJ1crnxjJrn6b1PjmLmw4pZVnIY8jt88M/6YtTUJB6+H0m0+XCmNq5Febg6k5m8705apdf4U2HCm+iyMXxjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294752; c=relaxed/simple;
	bh=5FmKQfTrzcyjB8+1Pi1zqIQWOlODYHw8hTyoCN+8Lj8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BvOA+be9zccGIdl+6oYLdbVTgFOvTOKgY9KC9r4rBfCBvrIf8aWc85yPmkWn0v3ScXwRJODujfwV6t2nbC+xbSp3inLmVRtsiHmK/D+srE2yNUHwluS0+IHvH9TD+qRzM117FShsQ3MQDLGbGlNysAW14n02i6LraEwvCRmm9mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZCqlYLis; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZCqlYLis"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F306FC433C7;
	Wed, 13 Mar 2024 01:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710294752;
	bh=5FmKQfTrzcyjB8+1Pi1zqIQWOlODYHw8hTyoCN+8Lj8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZCqlYLismEeQ194pLm8KNnbpv0cNNJA43AWTJdvKvfPydtQTYp9zvmwoDm6N8905O
	 LrA/XfFEYuGOWQLk4QyO11hb/7GRmy15wDtNdhXObzG8QPd28rjyK4KCHETrcmZVUk
	 /fgVDNa+47nnQm/mm7pDtrHRLJSouQUnA+8CWJjyWuEI7OC++rCJbADcN6EEO55IWM
	 4QLYjntFx+5a05FEiHS67QHAmB2aQ1/9WUIUqiElykP1TJuI4eHKEJfa9XAC3kh5xB
	 G+he4zOmDJYAtPeHhH7BZ84z0KhBbaM5dnR68sxab8b3xd9F3aPMACuptiAYJmUyh9
	 zf/oszxhi65sA==
Date: Tue, 12 Mar 2024 18:52:31 -0700
Subject: [PATCH 11/13] xfs_{db,repair}: use helpers for rtsummary
 block/wordcount computations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171029430715.2061422.7561733503744206333.stgit@frogsfrogsfrogs>
In-Reply-To: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
References: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
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

