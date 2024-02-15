Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7539657872
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998960; cv=none; b=ftF/bCNuq6PEu9vw/KThmlVaZyl4qZD1nOcmseJ5v0HwUT+amc1Ev6KyL6p4LNGeEXXTqAoH93O9vQ1hqdmibmpF6GaXKB4HSSE7hkyQlj+7oPCUHqmoXrSEwouWUABkK/Zki9+VMUiZmKaqyeC1l73RRriqyJzsTuFcufpgq6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998960; c=relaxed/simple;
	bh=L6QMV4aPv1MMujgRZVU3v+++6VqNMWDsTRCOxgcTWqg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CAtihaTSTFMa0H2DHRPzFQdCPokJkinEgX3iJubyb03LipxeXqylhf4au+sca48gM9nQMaASIHqAriX5VnsrvMOaJ3TINjGQvusbLTnwjouq0RsaMmFRapkJa/GhCytsUVAFFa/P2cK2vqMezgRiRhO2uivLrsvS8E1UqbURfW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IhDo1kgH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IhDo1kgH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71731C43399
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998960;
	bh=L6QMV4aPv1MMujgRZVU3v+++6VqNMWDsTRCOxgcTWqg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=IhDo1kgH8tDu2eJOeMxQJf4IfO8ftj/IFcsyqyOVbLNK6hu0hgciY8ZgzpxzxC10y
	 3Vug4/Podpt22AH73mbhY9jGLHgWbMFrUmMg61jTEQghsCeR2C48Ib/DyJqRO2UIUz
	 mV9qJzOcRXfsLr1K17zabcFb3ubziIJeQODDPfpdafFJ3LZUBP6ga8FAfj58qWfShV
	 OkuQFaNVOvQiZkw0K108lTCxSguwi6WtH3xcsNeQK82wcJjbmycqp3QKHtdK8N5NGF
	 R/0JhkboYt8+xjc58QHnILEkdm2khwpzmvIdbvHerfZREQ3ZD0JMJypUsf/3BngJvp
	 T7GiJlQw/xskw==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 05/35] xfs: convert xfs_extlen_t to xfs_rtxlen_t in the rt allocator
Date: Thu, 15 Feb 2024 13:08:17 +0100
Message-ID: <20240215120907.1542854-6-cem@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240215120907.1542854-1-cem@kernel.org>
References: <20240215120907.1542854-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: a684c538bc14410565e8939393089670fa1e19dd

In most of the filesystem, we use xfs_extlen_t to store the length of a
file (or AG) space mapping in units of fs blocks.  Unfortunately, the
realtime allocator also uses it to store the length of a rt space
mapping in units of rt extents.  This is confusing, since one rt extent
can consist of many fs blocks.

Separate the two by introducing a new type (xfs_rtxlen_t) to store the
length of a space mapping (in units of realtime extents) that would be
found in a file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rtbitmap.c | 12 ++++++------
 libxfs/xfs_rtbitmap.h | 11 +++++------
 libxfs/xfs_types.h    |  1 +
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index bd0925c9a..976b1aca6 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -532,7 +532,7 @@ xfs_rtmodify_range(
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	start,		/* starting block to modify */
-	xfs_extlen_t	len,		/* length of extent to modify */
+	xfs_rtxlen_t	len,		/* length of extent to modify */
 	int		val)		/* 1 for free, 0 for allocated */
 {
 	xfs_rtword_t	*b;		/* current word in buffer */
@@ -688,7 +688,7 @@ xfs_rtfree_range(
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	start,		/* starting block to free */
-	xfs_extlen_t	len,		/* length to free */
+	xfs_rtxlen_t	len,		/* length to free */
 	struct xfs_buf	**rbpp,		/* in/out: summary block buffer */
 	xfs_fsblock_t	*rsb)		/* in/out: summary block number */
 {
@@ -764,7 +764,7 @@ xfs_rtcheck_range(
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	start,		/* starting block number of extent */
-	xfs_extlen_t	len,		/* length of extent */
+	xfs_rtxlen_t	len,		/* length of extent */
 	int		val,		/* 1 for free, 0 for allocated */
 	xfs_rtblock_t	*new,		/* out: first block not matching */
 	int		*stat)		/* out: 1 for matches, 0 for not */
@@ -940,7 +940,7 @@ xfs_rtcheck_alloc_range(
 	xfs_mount_t	*mp,		/* file system mount point */
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	bno,		/* starting block number of extent */
-	xfs_extlen_t	len)		/* length of extent */
+	xfs_rtxlen_t	len)		/* length of extent */
 {
 	xfs_rtblock_t	new;		/* dummy for xfs_rtcheck_range */
 	int		stat;
@@ -963,7 +963,7 @@ int					/* error */
 xfs_rtfree_extent(
 	xfs_trans_t	*tp,		/* transaction pointer */
 	xfs_rtblock_t	bno,		/* starting block number to free */
-	xfs_extlen_t	len)		/* length of extent freed */
+	xfs_rtxlen_t	len)		/* length of extent freed */
 {
 	int		error;		/* error value */
 	xfs_mount_t	*mp;		/* file system mount structure */
@@ -1114,7 +1114,7 @@ xfs_rtalloc_extent_is_free(
 	struct xfs_mount		*mp,
 	struct xfs_trans		*tp,
 	xfs_rtblock_t			start,
-	xfs_extlen_t			len,
+	xfs_rtxlen_t			len,
 	bool				*is_free)
 {
 	xfs_rtblock_t			end;
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 546dea34b..d44496101 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -26,7 +26,7 @@ typedef int (*xfs_rtalloc_query_range_fn)(
 int xfs_rtbuf_get(struct xfs_mount *mp, struct xfs_trans *tp,
 		  xfs_rtblock_t block, int issum, struct xfs_buf **bpp);
 int xfs_rtcheck_range(struct xfs_mount *mp, struct xfs_trans *tp,
-		      xfs_rtblock_t start, xfs_extlen_t len, int val,
+		      xfs_rtblock_t start, xfs_rtxlen_t len, int val,
 		      xfs_rtblock_t *new, int *stat);
 int xfs_rtfind_back(struct xfs_mount *mp, struct xfs_trans *tp,
 		    xfs_rtblock_t start, xfs_rtblock_t limit,
@@ -35,7 +35,7 @@ int xfs_rtfind_forw(struct xfs_mount *mp, struct xfs_trans *tp,
 		    xfs_rtblock_t start, xfs_rtblock_t limit,
 		    xfs_rtblock_t *rtblock);
 int xfs_rtmodify_range(struct xfs_mount *mp, struct xfs_trans *tp,
-		       xfs_rtblock_t start, xfs_extlen_t len, int val);
+		       xfs_rtblock_t start, xfs_rtxlen_t len, int val);
 int xfs_rtmodify_summary_int(struct xfs_mount *mp, struct xfs_trans *tp,
 			     int log, xfs_rtblock_t bbno, int delta,
 			     struct xfs_buf **rbpp, xfs_fsblock_t *rsb,
@@ -44,7 +44,7 @@ int xfs_rtmodify_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,
 			 xfs_rtblock_t bbno, int delta, struct xfs_buf **rbpp,
 			 xfs_fsblock_t *rsb);
 int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
-		     xfs_rtblock_t start, xfs_extlen_t len,
+		     xfs_rtblock_t start, xfs_rtxlen_t len,
 		     struct xfs_buf **rbpp, xfs_fsblock_t *rsb);
 int xfs_rtalloc_query_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		const struct xfs_rtalloc_rec *low_rec,
@@ -53,9 +53,8 @@ int xfs_rtalloc_query_range(struct xfs_mount *mp, struct xfs_trans *tp,
 int xfs_rtalloc_query_all(struct xfs_mount *mp, struct xfs_trans *tp,
 			  xfs_rtalloc_query_range_fn fn,
 			  void *priv);
-bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
 int xfs_rtalloc_extent_is_free(struct xfs_mount *mp, struct xfs_trans *tp,
-			       xfs_rtblock_t start, xfs_extlen_t len,
+			       xfs_rtblock_t start, xfs_rtxlen_t len,
 			       bool *is_free);
 /*
  * Free an extent in the realtime subvolume.  Length is expressed in
@@ -65,7 +64,7 @@ int					/* error */
 xfs_rtfree_extent(
 	struct xfs_trans	*tp,	/* transaction pointer */
 	xfs_rtblock_t		bno,	/* starting block number to free */
-	xfs_extlen_t		len);	/* length of extent freed */
+	xfs_rtxlen_t		len);	/* length of extent freed */
 
 /* Same as above, but in units of rt blocks. */
 int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index 851220021..713cb7031 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -11,6 +11,7 @@ typedef uint32_t	prid_t;		/* project ID */
 typedef uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
 typedef uint32_t	xfs_agino_t;	/* inode # within allocation grp */
 typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
+typedef uint32_t	xfs_rtxlen_t;	/* file extent length in rtextents */
 typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
 typedef uint64_t	xfs_extnum_t;	/* # of extents in a file */
 typedef uint32_t	xfs_aextnum_t;	/* # extents in an attribute fork */
-- 
2.43.0

