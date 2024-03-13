Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD17B654
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294736; cv=none; b=ArHrPx/felPtZBKm2ISIndEMaABHZ4V9g+wI+B33UElNYJiagmJCYGpSviplybbREDW4dnfrc5ISRxyaOq+nl8Tn01gV5dY75/RjRnitV37iL69E+FGdPz0QM1X2gpwC0Tbi2dS60yRGNAiPWazyFAbXxOmTzQspsseIS2hexa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294736; c=relaxed/simple;
	bh=jw3McEZBVTId8p3N9tHHPXOWR0Fk/HoL138sPUtz7cE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=umtKHFrQdoiJ3TPvGG3tGlZaRuz9HY7sOy4dgIKekcqI0ccE9j9ehB+ZHWzw5pNqTqVJ2e5PUBNRbtb0ZmPZfUew2IpJBLQfQjwZJokX5JCzAweJFI3MGnLTzShxMvkAMzo36DqywPcxNZneP6hUVb07eI5HSRl/Jaa/rrW3Fgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n4Gtajl4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n4Gtajl4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D17C433C7;
	Wed, 13 Mar 2024 01:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710294736;
	bh=jw3McEZBVTId8p3N9tHHPXOWR0Fk/HoL138sPUtz7cE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=n4Gtajl4T85OVONs32YjDc+hjgvzdkQjEMsnv3FPEmHcEUVN0BLdfeynWstZsXrS/
	 PhHuFB8AaJeB0bf8BM2YdogM9RAGcFkhJrh0moC8zUcqGbnLeSdIY9xqH1YDxc4bno
	 KsZnyS/EME9JhL7crczpuVvv78j/2ex9NkCawEoEh1NK4sj8ISERyWNc5lNieXmGje
	 DJr49x9o0dGXSO02OWwOrD3dzTdl+Hmcohwxcmf08Q1TA6a09HavEUIxOfiv0YHykN
	 NNOOiujqFwpHwyxnPFdgOGrtJK81eIuXdI1VSTL93ux6qrRZfPRi5oh4KUnVT3Aak4
	 r3jy7txoY+Ivg==
Date: Tue, 12 Mar 2024 18:52:16 -0700
Subject: [PATCH 10/13] xfs_{db,repair}: use accessor functions for bitmap
 words
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029430701.2061422.2336669086852112996.stgit@frogsfrogsfrogs>
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

Port xfs_db and xfs_repair to use get and set functions for rtbitmap
words so that we can redefine the ondisk format with a specific
endianness.  Note that this requires the definition of a distinct type
for ondisk rtbitmap words so that the compiler can perform proper
typechecking as we go back and forth.

In the upcoming rtgroups feature, we're going to fix the problem that
rtwords are written in host endian order, which means we'll need the
distinct rtword/rtword_raw types.

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c               |   13 ++++++++++++-
 libxfs/libxfs_api_defs.h |    2 ++
 repair/globals.c         |    2 +-
 repair/globals.h         |    2 +-
 repair/phase6.c          |    2 +-
 repair/rt.c              |   22 ++++++++++++++++------
 repair/rt.h              |    6 ++----
 7 files changed, 35 insertions(+), 14 deletions(-)


diff --git a/db/check.c b/db/check.c
index a8f6310fcd25..3b3f90e5e0c9 100644
--- a/db/check.c
+++ b/db/check.c
@@ -3606,12 +3606,20 @@ process_rtbitmap(
 	xfs_rtword_t	*words;
 
 	bitsperblock = mp->m_sb.sb_blocksize * NBBY;
+	words = malloc(mp->m_blockwsize << XFS_WORDLOG);
+	if (!words) {
+		dbprintf(_("could not allocate rtwords buffer\n"));
+		error++;
+		return;
+	}
 	bit = extno = prevbit = start_bmbno = start_bit = 0;
 	bmbno = NULLFILEOFF;
 	while ((bmbno = blkmap_next_off(blkmap, bmbno, &t)) != NULLFILEOFF) {
 		struct xfs_rtalloc_args	args = {
 			.mp		= mp,
 		};
+		xfs_rtword_t	*incore = words;
+		unsigned int	i;
 
 		bno = blkmap_get(blkmap, bmbno);
 		if (bno == NULLFSBLOCK) {
@@ -3636,7 +3644,9 @@ process_rtbitmap(
 		}
 
 		args.rbmbp = iocur_top->bp;
-		words = (xfs_rtword_t *)xfs_rbmblock_wordptr(&args, 0);
+		for (i = 0; i < mp->m_blockwsize; i++, incore++)
+			*incore = libxfs_rtbitmap_getword(&args, i);
+
 		for (bit = 0;
 		     bit < bitsperblock && extno < mp->m_sb.sb_rextents;
 		     bit++, extno++) {
@@ -3670,6 +3680,7 @@ process_rtbitmap(
 		offs = xfs_rtsumoffs(mp, log, start_bmbno);
 		sumcompute[offs]++;
 	}
+	free(words);
 }
 
 static void
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 5180da2fcea6..feecc05c4ecc 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -175,6 +175,8 @@
 #define xfs_rmap_lookup_le_range	libxfs_rmap_lookup_le_range
 #define xfs_rmap_query_range		libxfs_rmap_query_range
 
+#define xfs_rtbitmap_getword		libxfs_rtbitmap_getword
+#define xfs_rtbitmap_setword		libxfs_rtbitmap_setword
 #define xfs_rtbitmap_wordcount		libxfs_rtbitmap_wordcount
 
 #define xfs_rtfree_extent		libxfs_rtfree_extent
diff --git a/repair/globals.c b/repair/globals.c
index c40849853b8f..73ae9de075de 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -86,7 +86,7 @@ int64_t		fs_max_file_offset;
 
 /* realtime info */
 
-xfs_rtword_t	*btmcompute;
+union xfs_rtword_raw	*btmcompute;
 xfs_suminfo_t	*sumcompute;
 
 /* inode tree records have full or partial backptr fields ? */
diff --git a/repair/globals.h b/repair/globals.h
index 89f1b0e078f3..311cf72189f3 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -127,7 +127,7 @@ extern int64_t		fs_max_file_offset;
 
 /* realtime info */
 
-extern xfs_rtword_t	*btmcompute;
+extern union xfs_rtword_raw		*btmcompute;
 extern xfs_suminfo_t	*sumcompute;
 
 /* inode tree records have full or partial backptr fields ? */
diff --git a/repair/phase6.c b/repair/phase6.c
index 7b2044fd1dbb..884b7c1ac2b5 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -572,7 +572,7 @@ fill_rbmino(xfs_mount_t *mp)
 	struct xfs_buf	*bp;
 	xfs_trans_t	*tp;
 	xfs_inode_t	*ip;
-	xfs_rtword_t	*bmp;
+	union xfs_rtword_raw	*bmp;
 	int		nmap;
 	int		error;
 	xfs_fileoff_t	bno;
diff --git a/repair/rt.c b/repair/rt.c
index 244b59f04ce5..213f0812250e 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -29,7 +29,7 @@ rtinit(xfs_mount_t *mp)
 	 * handled by incore_init()
 	 */
 	wordcnt = libxfs_rtbitmap_wordcount(mp, mp->m_sb.sb_rextents);
-	btmcompute = calloc(wordcnt, sizeof(xfs_rtword_t));
+	btmcompute = calloc(wordcnt, sizeof(union xfs_rtword_raw));
 	if (!btmcompute)
 		do_error(
 	_("couldn't allocate memory for incore realtime bitmap.\n"));
@@ -39,14 +39,24 @@ rtinit(xfs_mount_t *mp)
 	_("couldn't allocate memory for incore realtime summary info.\n"));
 }
 
+static inline void
+set_rtword(
+	struct xfs_mount	*mp,
+	union xfs_rtword_raw	*word,
+	xfs_rtword_t		value)
+{
+	word->old = value;
+}
+
 /*
  * generate the real-time bitmap and summary info based on the
  * incore realtime extent map.
  */
 int
-generate_rtinfo(xfs_mount_t	*mp,
-		xfs_rtword_t	*words,
-		xfs_suminfo_t	*sumcompute)
+generate_rtinfo(
+	struct xfs_mount	*mp,
+	union xfs_rtword_raw	*words,
+	xfs_suminfo_t		*sumcompute)
 {
 	xfs_rtxnum_t	extno;
 	xfs_rtxnum_t	start_ext;
@@ -75,7 +85,7 @@ generate_rtinfo(xfs_mount_t	*mp,
 	 */
 	while (extno < mp->m_sb.sb_rextents)  {
 		freebit = 1;
-		*words = 0;
+		set_rtword(mp, words, 0);
 		bits = 0;
 		for (i = 0; i < sizeof(xfs_rtword_t) * NBBY &&
 				extno < mp->m_sb.sb_rextents; i++, extno++)  {
@@ -98,7 +108,7 @@ generate_rtinfo(xfs_mount_t	*mp,
 
 			freebit <<= 1;
 		}
-		*words = bits;
+		set_rtword(mp, words, bits);
 		words++;
 
 		if (extno % bitsperblock == 0)
diff --git a/repair/rt.h b/repair/rt.h
index be24e91c95ec..3f1439300686 100644
--- a/repair/rt.h
+++ b/repair/rt.h
@@ -11,10 +11,8 @@ struct blkmap;
 void
 rtinit(xfs_mount_t		*mp);
 
-int
-generate_rtinfo(xfs_mount_t	*mp,
-		xfs_rtword_t	*words,
-		xfs_suminfo_t	*sumcompute);
+int generate_rtinfo(struct xfs_mount *mp, union xfs_rtword_raw *words,
+		xfs_suminfo_t *sumcompute);
 
 void check_rtbitmap(struct xfs_mount *mp);
 void check_rtsummary(struct xfs_mount *mp);

