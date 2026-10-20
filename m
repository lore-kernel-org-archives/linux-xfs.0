Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792465727;
	b=OcWKAsoRilmD9ElhVEGN3QPnw1LgTrMgquSpU2DGoSRVfaFulqAt1iaxvaEZ/q35YXZw
	 h9RZvOy/1fSFNRJ65Xrz06kG0PAUvKIAvftkRnoFMyyLzRO5RP9OOfkfuOcTQPyZUpCDa
	 BkYk8EmNxNYXKEqj8+iP06SRPZOosbXLt1U9Zd9mg9T0EkqDndWCZlCoCGZiBfR1Nqo2n
	 i61ovcseAJ/PgtHIHN8qP6032SKcQEZPRFd/+jiMfO97YvmsfkvmLv0taYPUBkN/y3s56
	 SsINJ0dSGEATOyf3t/jFY8wGIeW3sAJcZf5++y1rH1vgY7vP0r2v7cBqPyC175AvVZg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792465727;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=G2L/X3CIPKlN15SbNUbi09Xh+FGzqt4hwVimMbVxPrk=;
	b=3y7Llh6aWZI5fRAYunQos7o1g3PKdS9ofH1glRjdxV4V409O07QIdz+Bq5DkPlDJu6v/
	 h7w1NlQU8f6jUNtLEt6SJkgSZYcfL8l02YRaGR9R5xaM4tGpzrBDvqH9sbsznqs8EEwi4
	 E9CcOYkEoo2viAmJk3bsTA0wWdQhFF70jVaW+IbrnbY3f0VT8MtILYdFIELp+UyYXqM1G
	 pikEtTZF2jRc8FH6xQWnwF5LqXIxnCwYeZVCsvspOIj7IByQblNLMwij4EPE6o60Z36ca
	 MXilPrVL9TidLyPR7ZccajGlbwckUrWKwOOXhnwGOVdECY4ZBxo40Lp0gBW5JeN7q9Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SgRYcbXO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC72606A326;
	Tue, 20 Oct 2026 03:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SgRYcbXO
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792465727;
	b=pSgWlFjNg/B6BsUhvcNld1hz+cCBtkZ+K76JjS7n6GNrrMU/VRlkDYIwwc8ZJhMYrs04
	 +7kiC8fKo/7dobN3vHL9cZLsgujuMn2kbT3GVhsomqOPnZlTji9JhIc33paGFDFTzCREs
	 +d/0gvi+Oz2UDYu1Kb+TVvPxMW6KHFoGXPAKAIzji/2grlRrtRA1keWAh0tzwUsHwsUe9
	 9GGZGO0Q4E5LQhYYzWPtddeDMNX1jMIx377zD+QvYsVDbOuPZHBl2q69SkQNWZBdqI2TS
	 KVV7UJupIui2VOsaUeYLuV7csu+giw1W1IvRtvt75jC2Cyl1JLvPsMe1aOXhXYBGIfw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792465727;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=G2L/X3CIPKlN15SbNUbi09Xh+FGzqt4hwVimMbVxPrk=;
	b=MuuIBzxddoLhOcOVITIS1LxLrMIUFtRmO7/pKNcOzoOmOQH2YGq7TN6GtEzCtcZ6bP/d
	 VamnhYpNGe7P91sjjAIOBa0nZlIlQ/N6pW8oBMMF4AndclmIYC3Si1/j+efNsE6UAaSdq
	 FJa2YFR0yYcmcAuqy3iOYXPXeMhJxxQfsTLAkZ7QubhBNHfWB5RijdTBjn4VtN974MTox
	 T69OhCczneEf/yMKzbNWk3olmpFztbggpPtLjZXCntEyqTugqoc7H6jZ2PgSKjHgxQawm
	 m65xX+/VR5eJ9+qhrunRiwdLt0MiSQZk4c1geL+O+J11ZFU25lkFchcvx3XIc9Dyj9g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 830281F000C7;
	Tue, 20 Oct 2026 03:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792465727;
	bh=G2L/X3CIPKlN15SbNUbi09Xh+FGzqt4hwVimMbVxPrk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=SgRYcbXOV99QV1K2c08PY6KfiYO6O8tDb8m8CVf2L9Lw6/gq1BewkAZMlpP5V5zcQ
	 5s2fN0EV9j8c/CJs0NNid+C3er1SAIvpif0atUSO7Fqfu/8z9454IhKpQ/6gS72Zh9
	 X+XlS/4qn7izgTR/kfiEzrZhzWL/aLhQomr2kuIzjPYjmftx+Q5c7wsNq475TlV5tD
	 g3RvlkS7mdAJc+byFK0RubOunsE0alQ2A5MA/E8T4rCd0nz/IyWYdTzJmm8ErQKVOu
	 PSS5yUtEpIDfCwKBIOsVO1zk9+Lt4wxs/gTcEcKXnTC07+EJYrIW//b+iHgWQ/dYKo
	 51ClWE4KcVRDw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id DF7434071E;
	Tue, 20 Oct 2026 03:08:44 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Tue, 20 Oct 2026 12:08:45 +0900
Subject: [PATCH v4 2/9] xfs: add a flag to convert unwritten extents
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
Message-Id: <20261020-xfs-pnfs-batch-v4-2-9230fa2ca4a4@samsung.com>
References: <20261020-xfs-pnfs-batch-v4-0-9230fa2ca4a4@samsung.com>
In-Reply-To: <20261020-xfs-pnfs-batch-v4-0-9230fa2ca4a4@samsung.com>
To: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>, 
 Dave Chinner <dgc@kernel.org>, Chuck Lever <cel@kernel.org>, 
 Jeff Layton <jlayton@kernel.org>, Dai Ngo <Dai.Ngo@oracle.com>, 
 Sergey Bashirov <sergeybashirov@gmail.com>, 
 Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792465723; l=4281;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=LMdiz7cgREAvupMlKqMsckhym0R5xHQMlfoCvJZGlCU=;
 b=uE/Q778ZlOAYYo2B0/PNLMhX5/oAOfSxbofWQIC7VXvCsaYPaMTFAdFwj1iJUNpAhgAuAYijQ
 Qx4YUXjT6HUDgEQ+5v8dAA0N1rl+y0trrPfvUmcekRWbWDstcpNWVVK
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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


