Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B01F41A4FD;
	Thu, 15 Oct 2026 04:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792037282; cv=none; b=Ux/9VymE/yqI7dWP+ysYQAu9CO41xnJzUH1bmdNqwIWUgH2LASmqTuO9kBP/9VlFQQ5pPVCCUyov5lJnQf7tem866OoAsniOPaz2VlZAdposujedRAJUsu5xlR8Bx/BApHPbIaDe24gSuyH1KPeZoAZNYBxD3d2JI1+kYBuBf3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792037282; c=relaxed/simple;
	bh=G1AgiC6ssC+96LciGvxlgTGzsp01896k0HS8aPfcYGo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZL+iCfCH8HkNyWENjnmVQAiA1ffFnHorY6wUxV6eWKqi1UA/jCBvNNeRbH3OcW+Ny0ps6B5//+hMJR3dyw7KBoaAErRO+dMIGr90jcaMsr4hF2iEeTLb8EILudRXCTVxbxEIsoPHqQnEygLWIL0rWSxZgvSRTbtVK4iaNlpYDus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gmcndNcR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gmcndNcR"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C9A90C2BD04;
	Thu, 15 Oct 2026 04:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792037281;
	bh=G1AgiC6ssC+96LciGvxlgTGzsp01896k0HS8aPfcYGo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=gmcndNcRavWy0+Gp9WTCfOfKPoiQBmEqcbT3a+ne6vKywae3PUS4VlLKlFvWZWQTz
	 0Dy2BNXkOpW6Fi6V4gw5y5hy8N9ST/wyiAulPWYjrn/jx5EVoJ4CLlcRaGGDiXgqvI
	 R5XkFGe5XSUPLJ4FWxPPZitQ5m3MiZGIsxGe3AHr5mPVWnopx+7OPKERtETJ6gnkQD
	 vIRppvcHnWo0NNo3s1oNmZHUHv3ewr+mB9H8NXNRI9VDemas+ttBjHi5GlARVl+jBl
	 mg8JtRVrAjoCP2LpcswSlcDGzHm0lnt7OifvBmPoYm+IXd0rWVpcQ6+Ygla321fJ9f
	 grdo026VkNy9g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8745CC6B34;
	Thu, 15 Oct 2026 04:08:01 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Thu, 15 Oct 2026 13:08:01 +0900
Subject: [PATCH v3 2/9] xfs: add a flag to convert unwritten extents
 without allocating blocks
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-xfs-pnfs-batch-v3-2-54fc7b2e467d@samsung.com>
References: <20261015-xfs-pnfs-batch-v3-0-54fc7b2e467d@samsung.com>
In-Reply-To: <20261015-xfs-pnfs-batch-v3-0-54fc7b2e467d@samsung.com>
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, 
 Dave Chinner <dgc@kernel.org>, Chuck Lever <cel@kernel.org>, 
 Jeff Layton <jlayton@kernel.org>, Dai Ngo <Dai.Ngo@oracle.com>, 
 Sergey Bashirov <sergeybashirov@gmail.com>, 
 Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792037279; l=4236;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=AuzPO8vBKqIzgJXVHYMjsGez3dbaifa9CQeRToZS1Oo=;
 b=r1BGx82a8OjGFTPDPzsx40Su2GgsMQuxQgTQnwe/pIYdQccdpp75JTVgI7+AED/+Ied3gkj5z
 QBMPPW3pK8ZCHzCtgg3/FVSIo6+PnhFegw3xavazUDI9R1VAR1qEx5b
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com

From: Daejun Park <daejun7.park@samsung.com>

xfs_bmapi_write() with XFS_BMAPI_CONVERT converts unwritten extents to
written ones, and allocates blocks for any hole or delalloc extent it
finds in the range. A caller that may only convert blocks that are
already allocated has to look at the mapping first, and the mapping can
change once the ILOCK is dropped.

Add XFS_BMAPI_CONVERT_ONLY. With it, xfs_bmapi_write() stops at a hole
or a delalloc extent instead of allocating blocks and returns the
mappings that it converted before it. If the range starts with a hole or
a delalloc extent, it returns -ENOSR, as it does when a delalloc
conversion maps nothing in the range. Nothing has been changed then, and
the caller decides what to do with its transaction.

A flag of this name was removed by commit 26b91c728b2d ("xfs: make COW
fork unwritten extent conversions more robust"). That one skipped the
allocation and still mapped the hole; this one stops before it.

"xfs: refuse a pNFS LAYOUTCOMMIT of a range without blocks" uses it,
which is why this is marked for stable.

Suggested-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20261013120359.GB2944@lst.de
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 14 ++++++++++++--
 fs/xfs/libxfs/xfs_bmap.h | 10 +++++++++-
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index ca49bf4a50..95c0178b44 100644
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
+		ASSERT(bma.nallocs >= *nmap ||
+		       (flags & XFS_BMAPI_CONVERT_ONLY));
 		return -ENOSR;
 	}
 	*nmap = n;
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index e9f5416e4c..fb7481e819 100644
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

-- 
2.43.0


