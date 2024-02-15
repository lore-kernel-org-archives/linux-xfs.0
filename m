Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE68812BEB2
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998968; cv=none; b=XMpXY0kECI58mcWYmAD9N9FEqvDlP9Not2yazKW9Kw15rrOJTUQmlqOFNzZ6DXK2vMfEV7puJ4sibOQUaVNd9G70vnYUshDCsh4czOIJ6yWcNBoCCneg1Mlx10KTL07C0wjw1gd2nrhA8Jrm9RTxxnklFWBy8paE0supc/e7U18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998968; c=relaxed/simple;
	bh=ifo7fiZZWt9x9jab5yMPDYoK3W1l5WG9/s7nnehAaB8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ejm7H4GZDiQMXctBpY9PJ3klctzX6cxXV9YhmlYPEHM4nNDM/fkiD3euHfn/CNOukmJKnnhz1ioRzXs1uZQe0NMdOwoy4omzwZD7xLWnFYC0BUNfLtC/4xOkv3DS1LSHTe5x7z1Bc2LP30zrKk6xPllqVLe6C/Nbdo+pYBXKD00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OtE1rRRq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OtE1rRRq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D25C433C7
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998968;
	bh=ifo7fiZZWt9x9jab5yMPDYoK3W1l5WG9/s7nnehAaB8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=OtE1rRRqNz0xGdSO7j1Z284UCKZJntBC8eIzPCPd/zNB5FBNwP/uPOZO3aVUPe8DA
	 ee9+ToZHyL9Yz/XMaONcgNJnCkum7/MRGgdFoHP01O53DZ/bbiNjkzqt58saaDbHG7
	 PuE8j+XRa53kXr84wE+x1qvjfrsVwvg/TifDzAHTsmovqfdpb2cEWt+KTJ8CriKJ08
	 mGIIZDjbpoLzjXZ4MhqEcp/fU9MgdAuES3V6RVhoWIFMeSIHLCzvlN+5ZO5Tot4lly
	 VXal29sHboTFEBg0lFKybUS80Ao1lcOH9CIHRn/aOHaoAG2MI6hdASfXWNAHeDuAEh
	 tsInYnL8kTfpg==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 13/35] xfs: create helpers to convert rt block numbers to rt extent numbers
Date: Thu, 15 Feb 2024 13:08:25 +0100
Message-ID: <20240215120907.1542854-14-cem@kernel.org>
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

Source kernel commit: 5dc3a80d46a450481df7f7e9fe673ba3eb4514c3

Create helpers to do unit conversions of rt block numbers to rt extent
numbers.  There are three variations -- one to compute the rt extent
number from an rt block number; one to compute the offset of an rt block
within an rt extent; and one to extract both.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_bmap.c     |  8 ++++----
 libxfs/xfs_rtbitmap.c |  4 ++--
 libxfs/xfs_rtbitmap.h | 31 +++++++++++++++++++++++++++++++
 3 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 6e863c8a4..6d7fa88f9 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -5270,7 +5270,6 @@ __xfs_bunmapi(
 	int			tmp_logflags;	/* partial logging flags */
 	int			wasdel;		/* was a delayed alloc extent */
 	int			whichfork;	/* data or attribute fork */
-	xfs_fsblock_t		sum;
 	xfs_filblks_t		len = *rlen;	/* length to unmap in file */
 	xfs_fileoff_t		end;
 	struct xfs_iext_cursor	icur;
@@ -5365,8 +5364,8 @@ __xfs_bunmapi(
 		if (!isrt)
 			goto delete;
 
-		sum = del.br_startblock + del.br_blockcount;
-		div_u64_rem(sum, mp->m_sb.sb_rextsize, &mod);
+		mod = xfs_rtb_to_rtxoff(mp,
+				del.br_startblock + del.br_blockcount);
 		if (mod) {
 			/*
 			 * Realtime extent not lined up at the end.
@@ -5413,7 +5412,8 @@ __xfs_bunmapi(
 				goto error0;
 			goto nodelete;
 		}
-		div_u64_rem(del.br_startblock, mp->m_sb.sb_rextsize, &mod);
+
+		mod = xfs_rtb_to_rtxoff(mp, del.br_startblock);
 		if (mod) {
 			xfs_extlen_t off = mp->m_sb.sb_rextsize - mod;
 
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 4085f29b6..48e709a28 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1022,13 +1022,13 @@ xfs_rtfree_blocks(
 
 	ASSERT(rtlen <= XFS_MAX_BMBT_EXTLEN);
 
-	len = div_u64_rem(rtlen, mp->m_sb.sb_rextsize, &mod);
+	len = xfs_rtb_to_rtxrem(mp, rtlen, &mod);
 	if (mod) {
 		ASSERT(mod == 0);
 		return -EIO;
 	}
 
-	start = div_u64_rem(rtbno, mp->m_sb.sb_rextsize, &mod);
+	start = xfs_rtb_to_rtxrem(mp, rtbno, &mod);
 	if (mod) {
 		ASSERT(mod == 0);
 		return -EIO;
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index e2a36fc15..9df583083 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -39,6 +39,37 @@ xfs_extlen_to_rtxlen(
 	return len / mp->m_sb.sb_rextsize;
 }
 
+/* Convert an rt block number into an rt extent number. */
+static inline xfs_rtxnum_t
+xfs_rtb_to_rtx(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno)
+{
+	return div_u64(rtbno, mp->m_sb.sb_rextsize);
+}
+
+/* Return the offset of an rt block number within an rt extent. */
+static inline xfs_extlen_t
+xfs_rtb_to_rtxoff(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno)
+{
+	return do_div(rtbno, mp->m_sb.sb_rextsize);
+}
+
+/*
+ * Crack an rt block number into an rt extent number and an offset within that
+ * rt extent.  Returns the rt extent number directly and the offset in @off.
+ */
+static inline xfs_rtxnum_t
+xfs_rtb_to_rtxrem(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtbno,
+	xfs_extlen_t		*off)
+{
+	return div_u64_rem(rtbno, mp->m_sb.sb_rextsize, off);
+}
+
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */
-- 
2.43.0

