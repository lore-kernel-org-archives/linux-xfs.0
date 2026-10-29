Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793240581;
	b=2ElYbOU2DjkjRsXhtzcqIHexPGSPHmf9DHegK9Pj0yrtmH4MiWeA62UEWYb9YZ/tJC85
	 52vyBbfAt6/gKFuO4Ryu7nE2lwaXL1oZfcZ93j1oebMGb8K043wFnMaLCiQUHTXvVq9f+
	 19vGjT9OhrHPLajn3/T7B5ymR8ZNtX6ZwW2e4oHlBlZUIf6YX6VVMgKNfSOfv8e8ZsN9V
	 Gf0g1p9t3MsM4HQpN1WHOUqJgLKYy9Oret4TBbZmq3KkwV6FoJTYN8uJYYC/8EpaEpT6I
	 ZNensupQzGplKfEUNzbEPVxkuCO+8oZoU+e1qOQspURY2Yxxjpslrqstf+9bxP7SpMA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793240581;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=hqNfs2NE19Lk8UiKV1hAXpX0TcKlOiSMTVZSq4xF+7g=;
	b=0ji6bVhcBMDj28CwhiegytGrXpwd52pnV9A5zEROekBI114DvDokkJg7LaX/W5XNdyC1
	 Cq6axTlNXlF7cVMXjfXkYSZEvwgNKG+2rhTb0GhwtyLrec/e6PdU2CnrxhciNbmIkrUjL
	 dTR60qvCeSk50xkGHXeSzvQ71Mrk/ARYObkRRAEvSArF6kOsPd68bT7Lyj1JHAwjWWE23
	 6nOpEV2lNbyVF66KZVVEejOCcQF8mtCagr5gbbpykzNRAglRE5TN+qp7PJxzaMzYc3CgR
	 9hC9Fbf/3Z6CyAyN6mOSO8qNJ3joLb8UtcOsy9pPm+LxGLrJdOyYFxWTeO85uHsD6WQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="A2vg/r5N";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B51606A32F;
	Thu, 29 Oct 2026 02:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A2vg/r5N
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793240581;
	b=A1Zw4scEt7Pl+2y5NRv5BpaGdYe8GRsK0oDhPQ20AWZS810rmWoHQE5V419IVCWXwfwi
	 9Vj5+jKoyVpxAxAeXqeFA/EbOkAP82aH1T56yqWo+iq6dPzRYB7Jqc57qY+TzFU+DWn8Q
	 F4jAP22TMPvB78f/uqHOMmc2/Fc1eINiBiObQGjrxbLFGbwXtJ4zamr0J5sBR9XEW+5lV
	 96Qn8GlHSmVMqhYxW6FfDxwFj+cDMxcKiCQbvFwdQTOCIU58AuZsMq5N9bC6FCdIvEBO2
	 oVmKIk9HE/3LZiXidSKD8p+6SrY5wyosM5w3NjcWJ50W2cnAMBbmSb/Ett8P5F8SaoA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793240581;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=hqNfs2NE19Lk8UiKV1hAXpX0TcKlOiSMTVZSq4xF+7g=;
	b=fk7EewiuPhbRV3iIHPqFxiioIcOX7ki/EsrVitOsLC/Mrl3sEQQSxpxlDbyevEk53Hu/
	 caaD3RE9MoOabvKjNyzUWsqQUs+2eBfUS7BUyQbjudAA8pFdGgY1SWTnIbNjVHIVs2mWM
	 rNO6prrWU1jrT3lSuW6orIBQq0GznLQTz36kfzyEh1jI5Ws/F6PmstrkUMRZ7Q9jvwn38
	 1L3avJjaauLTwMUfU27nuD2mGELk3h8i7bHlu5YhigTm2+eFnjd/4+yinvh3F9uRw1Xp4
	 iXA76WwoGi9j5HMvhNsfsGo/grIN0zl06/ly6WuLqwKlClZ4ekHZmWfOrkNfzVjn4rA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 56B291F031E3;
	Thu, 29 Oct 2026 02:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793240580;
	bh=hqNfs2NE19Lk8UiKV1hAXpX0TcKlOiSMTVZSq4xF+7g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=A2vg/r5N0EgaKvDfYwmjHyBUMBvzkjSCY7QTaQ7eRLSvqFZ8u+xp4l7FJ8q4P418w
	 h5cjFgoLkaooi6sVQ5KFi5I/KMk6jFE/mDNfGBt/zxKiVrvpkiq6wi9xjkvjYvfA5F
	 AnFqIBGUIXMOlgtwQrHboHM/yVkNDfvQP8uZz6yKWZpN1x59C01hXJeBWfl39fqWAG
	 5mflA4vUhybDAMCiu9mWtqiXVQLd2Ns7HCn9bF/O/wnjlKryvkTIWf/+c5WAy2x3+4
	 HbDExuQ5eUSuNTSman8nkujnRW5Xqe0IUxikkolnd4xfsVqWbkfoEq40kMmjx3LtMJ
	 qcqDPh/wkvQNQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id C57F04568A;
	Thu, 29 Oct 2026 02:22:58 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Thu, 29 Oct 2026 11:22:59 +0900
Subject: [PATCH v5 2/9] xfs: add a flag to convert unwritten extents
 without allocating blocks
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261029-xfs-pnfs-batch-v5-2-ef8d2eafb7fa@samsung.com>
References: <20261029-xfs-pnfs-batch-v5-0-ef8d2eafb7fa@samsung.com>
In-Reply-To: <20261029-xfs-pnfs-batch-v5-0-ef8d2eafb7fa@samsung.com>
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, 
 Dave Chinner <dgc@kernel.org>, Pankaj Raghav <p.raghav@samsung.com>, 
 Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 Dai Ngo <Dai.Ngo@oracle.com>, Sergey Bashirov <sergeybashirov@gmail.com>, 
 Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793240577; l=3695;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=9oitVIyIwMLmkXH/HPATnA5/bicH866vOldpPI08Rew=;
 b=vBCTTTeRCevpX+Tmxy8ZFLNcsJLpLi+yHRkc5Gyk2Y7rmTcDuch5364nqJJ8t6/4fgE7jplfB
 NQyOVPYoYywB99yg9CicYLP8dyYtWpkMfcydJxrH1PNIHC6JG3Hh+un
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

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
---
 fs/xfs/libxfs/xfs_bmap.c | 14 ++++++++++++--
 fs/xfs/libxfs/xfs_bmap.h | 10 +++++++++-
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index ca49bf4a50..050522c58b 100644
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


