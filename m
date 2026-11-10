Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794270126;
	b=L4QYfMM8F/Lu30CUc/Enveqo38QW/QQjy2rbKELhDbgGkXyL90u6/3rNYpvswYM8Oamt
	 sjmh75y6raUkZ5CrehC7bHJ1EXgy1DMrx8NR7MveVAagtGfze9YpRBqEGfgVOlCcBBNWo
	 RXL5q2NUioyIBzKvVkGwX/Tyu0s3+ka75ye+0qP/Wc4kVJexdLB20QvCJB89X/hfY4Bpb
	 0BjcJQdVE1xbnh9f5gCN8XvXzjeTrxFMdM08VLLcZ0pDxyyuwP9j8LfDJT3v2A7qCp4rV
	 XW9K7bEP5508+DstbUFRMwDPLqjp1wtmR9Mw5EVFOS6KU7N0ZIzvrzQRjUL6vnqmV0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794270126;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=g9zRU35e/WThdnKeYRLACVdi36r5+FtlsJWIllgW0Y4=;
	b=HFNRSc/NpMzHhSo/iWpP1uY2xM8bd+YkxFuEb0cvdh04jGGCUkMQwXZ/haducsyFfQWF
	 dZIMfpue6qYke/8+b/IEvIU20Ba5dWGPJ7GjseOZJMg1AsVBuOcgiY8kF/XFOsO2Yq406
	 kNOEuMMBEshWXQM9JSp+mXXTCQ7rEADzXZSVcVqMPca1dRXbCA1omsqPQAFYo9xCtRm+N
	 FL+GgTXiOEFtqYfVAitEKVUHQD59PFuIJ8WkfdcCJ7/YpRFmMp8azCytV+qh06whHj8fq
	 cIc9WNM7uonsIwlDpo/tJONH9Tm9i6JY+VpQCJ3nzl3jXgaCyWZ9U8ISZ43BTx9iLFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bWx1o2PJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36AE606A321;
	Tue, 10 Nov 2026 00:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bWx1o2PJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADAC61F008A1;
	Tue, 10 Nov 2026 00:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794270125;
	bh=g9zRU35e/WThdnKeYRLACVdi36r5+FtlsJWIllgW0Y4=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=bWx1o2PJX5IVwOeZfRRj+r4zHqyy8sfTbd+WKkk4yJPzTfTJZ5pPbqvX8UeJCS8Xk
	 FQVSYdzkc00et7a+bryRUYj05HBUwkPzRgoYE4WkrcScJvULRtHhdaEaRrWAnuA065
	 2xiC17mSrjfmB8cz74yW+iZZcyxfQ2LoE9NQOVTf0GO2sMokdt4IpteX9CK9SFVLW2
	 t48IyRxDaB8bL71rZ7a/kCq975hPrqyEylzoI/nw/ptpSfD+MO72O9VyTFehoD+vqF
	 1hdh7Ia2dk9jSolWOcQqJ3kAouC+/BV9ABaEYkA5JO3iXsV7dFuNGlSLwh0YUVWccQ
	 1AsmIhAbEIGtg==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	daejun7.park@samsung.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: add a flag to convert unwritten extents without allocating blocks" has been added to the 6.18-stable tree
Date: Mon,  9 Nov 2026 19:22:03 -0500
Message-ID: <20261110002203.3505592-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
Reply-To: stable@vger.kernel.org
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

This is a note to let you know that I've just added the patch titled

    xfs: add a flag to convert unwritten extents without allocating blocks

to the 6.18-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-add-a-flag-to-convert-unwritten-extents-without-.patch
and it can be found in the queue-6.18 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 2c2bcea650d618d064014b9903b9fa848a0024b6
Author: Daejun Park <daejun7.park@samsung.com>
Date:   Thu Oct 29 11:22:59 2026 +0900

    xfs: add a flag to convert unwritten extents without allocating blocks
    
    [ Upstream commit f3ca3498dfe624f9b604c934263538a3acd55af5 ]
    
    xfs_bmapi_write() with XFS_BMAPI_CONVERT also allocates blocks for
    holes and delalloc extents in the range. Add XFS_BMAPI_CONVERT_ONLY for
    callers that may only convert already allocated blocks. It stops at a
    hole or delalloc extent, and returns -ENOSR if it stops before mapping
    anything.
    
    Marked for stable because "xfs: refuse a pNFS LAYOUTCOMMIT of a range
    without blocks" needs it.
    
    Suggested-by: Christoph Hellwig <hch@lst.de>
    Link: https://lore.kernel.org/r/20261013120359.GB2944@lst.de
    Cc: stable@vger.kernel.org
    Signed-off-by: Daejun Park <daejun7.park@samsung.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
    Signed-off-by: Carlos Maiolino <cem@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index bdffade9848f8..8fc6ee96e1f56 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4130,6 +4130,8 @@ xfs_bmapi_finish(
  * Returns a negative error code on failure, including -ENOSPC when it could not
  * allocate any blocks and -ENOSR when it did allocate blocks to convert a
  * delalloc range, but those blocks were before the passed in range.
+ * With XFS_BMAPI_CONVERT_ONLY, it stops at a hole or a delalloc extent instead
+ * of allocating blocks, and returns -ENOSR if it stops before mapping anything.
  */
 int
 xfs_bmapi_write(
@@ -4189,6 +4191,8 @@ xfs_bmapi_write(
 	 */
 	ASSERT((flags & (XFS_BMAPI_PREALLOC | XFS_BMAPI_ZERO)) !=
 			(XFS_BMAPI_PREALLOC | XFS_BMAPI_ZERO));
+	ASSERT(!(flags & XFS_BMAPI_CONVERT_ONLY) ||
+	       (flags & XFS_BMAPI_CONVERT));
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
 	    XFS_TEST_ERROR(mp, XFS_ERRTAG_BMAPIFORMAT)) {
@@ -4237,6 +4241,9 @@ xfs_bmapi_write(
 		 * that we found, if any.
 		 */
 		if (need_alloc || wasdelay) {
+			if (flags & XFS_BMAPI_CONVERT_ONLY)
+				break;
+
 			bma.eof = eof;
 			bma.conv = !!(flags & XFS_BMAPI_CONVERT);
 			bma.wasdel = wasdelay;
@@ -4332,10 +4339,13 @@ xfs_bmapi_write(
 	 *
 	 * To avoid a successful return with *nmap set to 0, return the magic
 	 * -ENOSR error code for this particular case so that the caller can
-	 * handle it.
+	 * handle it. The same goes for XFS_BMAPI_CONVERT_ONLY stopping at a
+	 * hole or a delalloc extent at the start of the range, in which case
+	 * nothing has been changed.
 	 */
 	if (!n) {
-		ASSERT(bma.nallocs >= *nmap);
+		ASSERT((flags & XFS_BMAPI_CONVERT_ONLY) ? bma.nallocs == 0 :
+							  bma.nallocs >= *nmap);
 		return -ENOSR;
 	}
 	*nmap = n;
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index d5f2729305fad..76d25e5d5d9cb 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -90,6 +90,13 @@ struct xfs_bmalloca {
 /* Try to align allocations to the extent size hint */
 #define XFS_BMAPI_EXTSZALIGN	(1u << 11)
 
+/*
+ * Use with XFS_BMAPI_CONVERT to convert unwritten extents without allocating
+ * blocks. Stop at a hole or a delalloc extent: return the mappings found so
+ * far, or -ENOSR if there are none.
+ */
+#define XFS_BMAPI_CONVERT_ONLY	(1u << 12)
+
 #define XFS_BMAPI_FLAGS \
 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
 	{ XFS_BMAPI_METADATA,	"METADATA" }, \
@@ -102,7 +109,8 @@ struct xfs_bmalloca {
 	{ XFS_BMAPI_COWFORK,	"COWFORK" }, \
 	{ XFS_BMAPI_NODISCARD,	"NODISCARD" }, \
 	{ XFS_BMAPI_NORMAP,	"NORMAP" },\
-	{ XFS_BMAPI_EXTSZALIGN,	"EXTSZALIGN" }
+	{ XFS_BMAPI_EXTSZALIGN,	"EXTSZALIGN" }, \
+	{ XFS_BMAPI_CONVERT_ONLY,	"CONVERT_ONLY" }
 
 
 static inline int xfs_bmapi_aflag(int w)
