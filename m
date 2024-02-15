Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9900B12C53A
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998974; cv=none; b=q0Tg5DVPizd6qoZWfrbtawI7nC/Dm2y8LsVTgYDc2pWK/rEV8noWL7fGfQRrrppKNRNFyU9KSz71oGZuQ2RQLV1EuYKL5h2qP34pmCBpcWwbD1BzOqk5ziYvfvNPlzcYWF8MnNxGVgUFMf1nRPplfj4QRUO9MkOQuk2GLqFeFq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998974; c=relaxed/simple;
	bh=RmXDb4XRDYLkoB9Rn4+TMfoQ5dHfGq6qvQIClnHO/Os=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLr/zUzGJnmAz/1FCPCWdwmaifIEnR3YKbLjlY9xCj1I4++b67VA/lOE05Tlq9rfcdmQVrPF3rjE8eit2smXqosl08syyaQOym8Cw4iOcD+I4w+oS77xx7YQevb54yo85Ceu175vQ1lqLBWRkptRrUmfdXe0AD8mPn5INUrw6QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GUZal3+Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GUZal3+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7787AC43390
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998974;
	bh=RmXDb4XRDYLkoB9Rn4+TMfoQ5dHfGq6qvQIClnHO/Os=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=GUZal3+ZM84XKiUwau6Kqc0Q0Du/umZrZ2fLM9TO0QI/ZbOLAwKc4s9OSDUCkvN7u
	 fyvRWxBcvYQXJcrYdwgO/Ur1Zp+e+Zrrg+/SpkZ8K3Oe1GDS2yOugiT8AUZl/phU2a
	 Fh3NU5AenUChAUT7Y63tL3VXGNNUgLXLUpPXzhci2aMw2k6OFZ+3VTMdMoDB6AijKo
	 zGrBGUj8yaBsiHjEF+1O/0FADzs8KChn2umLPlRE14l/vNU5ELThsPA3vJEgA9K5wX
	 LzmPfGkpo8WG7qplarxW5WGWFJjgIFy4Ecxtsnd0fzj9YWP0KysomG7hw42i648kRb
	 Vh67Sq8alIXjQ==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 18/35] xfs: remove XFS_BLOCKWSIZE and XFS_BLOCKWMASK macros
Date: Thu, 15 Feb 2024 13:08:30 +0100
Message-ID: <20240215120907.1542854-19-cem@kernel.org>
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

Source kernel commit: add3cddaea509071d01bf1d34df0d05db1a93a07

Remove these trivial macros since they're not even part of the ondisk
format.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_format.h   |  2 --
 libxfs/xfs_rtbitmap.c | 16 ++++++++--------
 libxfs/xfs_rtbitmap.h |  2 +-
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 0e2ee8202..ac6dd1023 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1142,8 +1142,6 @@ static inline bool xfs_dinode_has_large_extent_counts(
 
 #define	XFS_BLOCKSIZE(mp)	((mp)->m_sb.sb_blocksize)
 #define	XFS_BLOCKMASK(mp)	((mp)->m_blockmask)
-#define	XFS_BLOCKWSIZE(mp)	((mp)->m_blockwsize)
-#define	XFS_BLOCKWMASK(mp)	((mp)->m_blockwmask)
 
 /*
  * RT Summary and bit manipulation macros.
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 540cb1481..6776e45c1 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -172,7 +172,7 @@ xfs_rtfind_back(
 				return error;
 			}
 			bufp = bp->b_addr;
-			word = XFS_BLOCKWMASK(mp);
+			word = mp->m_blockwsize - 1;
 			b = &bufp[word];
 		} else {
 			/*
@@ -218,7 +218,7 @@ xfs_rtfind_back(
 				return error;
 			}
 			bufp = bp->b_addr;
-			word = XFS_BLOCKWMASK(mp);
+			word = mp->m_blockwsize - 1;
 			b = &bufp[word];
 		} else {
 			/*
@@ -336,7 +336,7 @@ xfs_rtfind_forw(
 		 * Go on to next block if that's where the next word is
 		 * and we need the next word.
 		 */
-		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
+		if (++word == mp->m_blockwsize && i < len) {
 			/*
 			 * If done with this block, get the previous one.
 			 */
@@ -381,7 +381,7 @@ xfs_rtfind_forw(
 		 * Go on to next block if that's where the next word is
 		 * and we need the next word.
 		 */
-		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
+		if (++word == mp->m_blockwsize && i < len) {
 			/*
 			 * If done with this block, get the next one.
 			 */
@@ -591,7 +591,7 @@ xfs_rtmodify_range(
 		 * Go on to the next block if that's where the next word is
 		 * and we need the next word.
 		 */
-		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
+		if (++word == mp->m_blockwsize && i < len) {
 			/*
 			 * Log the changed part of this block.
 			 * Get the next one.
@@ -631,7 +631,7 @@ xfs_rtmodify_range(
 		 * Go on to the next block if that's where the next word is
 		 * and we need the next word.
 		 */
-		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
+		if (++word == mp->m_blockwsize && i < len) {
 			/*
 			 * Log the changed part of this block.
 			 * Get the next one.
@@ -834,7 +834,7 @@ xfs_rtcheck_range(
 		 * Go on to next block if that's where the next word is
 		 * and we need the next word.
 		 */
-		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
+		if (++word == mp->m_blockwsize && i < len) {
 			/*
 			 * If done with this block, get the next one.
 			 */
@@ -880,7 +880,7 @@ xfs_rtcheck_range(
 		 * Go on to next block if that's where the next word is
 		 * and we need the next word.
 		 */
-		if (++word == XFS_BLOCKWSIZE(mp) && i < len) {
+		if (++word == mp->m_blockwsize && i < len) {
 			/*
 			 * If done with this block, get the next one.
 			 */
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 5c4325702..a382b38c6 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -146,7 +146,7 @@ xfs_rtx_to_rbmword(
 	struct xfs_mount	*mp,
 	xfs_rtxnum_t		rtx)
 {
-	return (rtx >> XFS_NBWORDLOG) & XFS_BLOCKWMASK(mp);
+	return (rtx >> XFS_NBWORDLOG) & (mp->m_blockwsize - 1);
 }
 
 /* Convert a file block offset in the rt bitmap file to an rt extent number. */
-- 
2.43.0

