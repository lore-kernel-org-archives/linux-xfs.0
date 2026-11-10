Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794269370;
	b=tHhVRI/5Dl51esG2P7ho4NPBRL0GwQaMCWgePMq7+6G2Wx8DghdcULowFlaKKGGDwjfx
	 3y9Sy0d03vgpx1CjUXN9KR/h6FEEunvLP9dsVGeqopp9Bta83UTNaWfqho6/gPPmEez8/
	 CXUgFH/XLs7+UC/1AKe/tLvDNFwyyelJ9nDcxIef+t4ruW1wqwyHl1sEFTQWuBuATC2t1
	 vGXe+2viDtV5bOixyXL9Eo+ECVhyHT5S2OIo5AAHi6ZwuMZSZ0bw40g6AC1Gc6n8TtAvS
	 FTxOKQdqJT3AoZm4XgmWSvdm5dE0bFh36cf5WPNOCaSY52FZdUFP+L8MdmnsyKD7Rzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794269370;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 Reply-To:MIME-Version:X-Patchwork-Hint:X-stable:
	 Content-Transfer-Encoding;
	bh=0gBtdr9V+m4tXC/nebT6AU8V4ABZsXzV3ZBwPA5XtsU=;
	b=AluPBpHrdnCpdwUczaDlLJ5OJcGq/huHkuQZLgd6i2Z1rOVE6VNo9kZ02/R0DHQoraxA
	 nGNpLfwHe0nBHq6qeRBOC8ABxKrUnSrbSLDihrNzDSuhgIdCn50R7kBzl5Q0SSaues94P
	 SmzxX2DE6CkcHRjIy9wYCNM0Fye0HJQQW07IpZrMLOiXYtD2x/8Nkc2rA/e0vleiUgBmx
	 3RsS4faH56HQ/uvM41/FXC9Z1T5jwZ/I3drWEOV7E50Nw2wzfhRfJn+TjphLcg0+/wzVd
	 nSL/Q68zLNxrxxRNz2nuG4cXkyboymNOw5QivF99zXBdtNQcTlFwoPElCBNoNXZjNIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XK6esa4t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F092606A332;
	Tue, 10 Nov 2026 00:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XK6esa4t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B554A1F0089F;
	Tue, 10 Nov 2026 00:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794269370;
	bh=0gBtdr9V+m4tXC/nebT6AU8V4ABZsXzV3ZBwPA5XtsU=;
	h=From:To:Cc:Subject:Date:Reply-To;
	b=XK6esa4tW/75fnFaqeJjfhjEEP/E7n5O7u+kt4b4HoLR5JfKkCKqbOwLPloimqNMD
	 Kj8D04fORhn1FNbnCmCdgvUvtKrSoy93rTm1L5MZsEEdp4RPjVLUdvDMZ6uamDHYRL
	 LM5cAr+VPd6HW0V93ZyLIdKlGCwZ5niOqHxBLVJypOkivqm/v2BPb7X/jciYz2SYu+
	 iKr5cHwmKa0iOJnd/dKk1m6bB8fkL50ie0f1WpRi5XfMZTbg59J1Nf9CgTRhMum63D
	 1QIbCv1cYkp8R0ca4Dgwgx9nW5b3ZRdIXaPgb0zoY6r7NKFGyI3Pgc1Gco82P6pv/b
	 wKhuRMIjnhnFQ==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	daejun7.park@samsung.com
Cc: Amir Goldstein <amir73il@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Patch "xfs: add a flag to convert unwritten extents without allocating blocks" has been added to the 7.3-stable tree
Date: Mon,  9 Nov 2026 19:09:28 -0500
Message-ID: <20261110000928.3488234-1-sashal@kernel.org>
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

to the 7.3-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     xfs-add-a-flag-to-convert-unwritten-extents-without-.patch
and it can be found in the queue-7.3 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 1a19c86b834bc065d23d3f621e0dc0c88d53c0ca
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
index d64defeda645e..fce2705c67d2e 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4128,6 +4128,8 @@ xfs_bmapi_finish(
  * Returns a negative error code on failure, including -ENOSPC when it could not
  * allocate any blocks and -ENOSR when it did allocate blocks to convert a
  * delalloc range, but those blocks were before the passed in range.
+ * With XFS_BMAPI_CONVERT_ONLY, it stops at a hole or a delalloc extent instead
+ * of allocating blocks, and returns -ENOSR if it stops before mapping anything.
  */
 int
 xfs_bmapi_write(
@@ -4187,6 +4189,8 @@ xfs_bmapi_write(
 	 */
 	ASSERT((flags & (XFS_BMAPI_PREALLOC | XFS_BMAPI_ZERO)) !=
 			(XFS_BMAPI_PREALLOC | XFS_BMAPI_ZERO));
+	ASSERT(!(flags & XFS_BMAPI_CONVERT_ONLY) ||
+	       (flags & XFS_BMAPI_CONVERT));
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
 	    XFS_TEST_ERROR(mp, XFS_ERRTAG_BMAPIFORMAT)) {
@@ -4235,6 +4239,9 @@ xfs_bmapi_write(
 		 * that we found, if any.
 		 */
 		if (need_alloc || wasdelay) {
+			if (flags & XFS_BMAPI_CONVERT_ONLY)
+				break;
+
 			bma.eof = eof;
 			bma.conv = !!(flags & XFS_BMAPI_CONVERT);
 			bma.wasdel = wasdelay;
@@ -4330,10 +4337,13 @@ xfs_bmapi_write(
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
