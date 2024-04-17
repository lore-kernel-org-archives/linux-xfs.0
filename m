Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5552262A3
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713388859; cv=none; b=HEuauSH92Wqtd1kBDQN2Eh8n76go0/sxJhHyCk3uZKUfP1ZEKGKcl1Sp3ztRfdBBN8Sv6mxRP1RrxujCjPU3ZOVo/Y8soD2vue1YhZPERc1mbDG9eCr23BBsbyxS0ZwBMjUwHor5g44bdi28OBgQ/+uTcYHQ23adm/GtUnCl0Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713388859; c=relaxed/simple;
	bh=U39HyUBa5sCJ9GcG33tCDZf6hNKlYU7nJFLi1XxZp6w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OcjkGz05z801uLLrvZP5hNfUeTw23YIbVdHMScMpTmQ3u6qzhz8Pncn6FY80Uc3l6CDmnugLTaG7pDgG0i0+SORwnUvUiGIZbhKFsb8TGBsVUt0datjYxL2Z6eJ+HIxbcxvvXI8BN2iY2eB8FarlKGa/PZ956NmkPhnNseY2s5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CnU4HCbC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CnU4HCbC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0274C072AA;
	Wed, 17 Apr 2024 21:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713388859;
	bh=U39HyUBa5sCJ9GcG33tCDZf6hNKlYU7nJFLi1XxZp6w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CnU4HCbCRh0mcBUmS3+mO69/1RJBqJKS+a864L6pC+CURsI6QomQAtBXFrPIwJrZo
	 eWOOJdVk+6hsYxTOvd4ylV7zQfN/emwQZIZxudWvzgfa/ucnAQ1J0HyC3vB6/AyAzt
	 bZqeNOIbr+h18vWtWRX6Q8Nl9qU7gCsyaRm1dwoFeP2ZhTrHvKq/CXkrNcfXpHog8h
	 PkNfI7ypOFTzInklHRQkVCpGovLGoBNrE+lZ0/Fmo4vj6xV6FQpk1PkeZAPTZQFAmS
	 TX9uAov+B+twIRS5EoCjPVtUezr5bime0SpFATfvKvSzg0qDl04r2UDtIWoJkBAaGS
	 mN0YSTEjeJEjA==
Date: Wed, 17 Apr 2024 14:20:59 -0700
Subject: [PATCH 08/11] xfs_{db,repair}: use accessor functions for bitmap
 words
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Christoph Hellwig <hch@lst.de>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171338841857.1853034.7854621309235254567.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
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
index a8f6310fc..3b3f90e5e 100644
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
index 5180da2fc..feecc05c4 100644
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
index c40849853..73ae9de07 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -86,7 +86,7 @@ int64_t		fs_max_file_offset;
 
 /* realtime info */
 
-xfs_rtword_t	*btmcompute;
+union xfs_rtword_raw	*btmcompute;
 xfs_suminfo_t	*sumcompute;
 
 /* inode tree records have full or partial backptr fields ? */
diff --git a/repair/globals.h b/repair/globals.h
index 89f1b0e07..311cf7218 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -127,7 +127,7 @@ extern int64_t		fs_max_file_offset;
 
 /* realtime info */
 
-extern xfs_rtword_t	*btmcompute;
+extern union xfs_rtword_raw		*btmcompute;
 extern xfs_suminfo_t	*sumcompute;
 
 /* inode tree records have full or partial backptr fields ? */
diff --git a/repair/phase6.c b/repair/phase6.c
index 7b2044fd1..884b7c1ac 100644
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
index 244b59f04..213f08122 100644
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
index be24e91c9..3f1439300 100644
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

