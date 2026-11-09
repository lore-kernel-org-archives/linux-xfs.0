Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794268277;
	b=wx4btCGikVizCy1tnQGcDu511mSJWlx2J/XulIeHb1NJSFl/TY0MUcVlQ/PJ9ZQnr64n
	 CkXnD+2Gt2/KROFpUWQf6laxJzhEuxMXJqqAZXO0zZgsiGyE62V64wwGBHdQeuEDxe+bj
	 DorpaPLvp+KiwatlL0rEkSYelbc4BhoecoiuVCLE+2HeG7Fe1Xu9bQq5ci5QhIzr5+v/8
	 zloZGvjTuO5givXArxWTV74UT5t9mAZBRCkZQHR1lH1R7pDghVAkEG7lf/Rc/8+wAtXQs
	 +GmTGDsoJQEfROadDuenOQDznWftVNKbK1QiGQXQ6uI3oBAOwnWwGCojxx5VAEgMWZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794268277;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=zWSSpiXIs7GUJU74turtE6kZK6M9BH3bJIxYHznb2cQ=;
	b=0XhL06xnzEfBAUwjDYkZDbrRTM7/DBvN17pFY1C4MFRxcvWpPukfaMhC8xRdcG/9uoFy
	 gH9YpzQkYJOT7S2nIKbfgF9OFZRmu8YGvp5bKJ0+P6X5ITXCnLi8tW4c/5YmqFrn+HVAq
	 0auWi7EbPPtlAxcApkI3UsfRe/mVZiV752xwgMKm7dSZxNmot94+TLsTQHgaQbnaXan0u
	 XfXMD+0XlCJHGblcariDLl0KxJ7hy5LpMS/eYturoN6sXku2gE/U1biY/iBcknLDt0YEY
	 UfPmFPgxOknzbKwk68CoW1n8PFtk/QTrhkVGzh+JTu/xjNOr6Z/P6Vm/8jOFaKO3rBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="aYLXGiO/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B99F606A337;
	Mon,  9 Nov 2026 23:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aYLXGiO/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7681E1F008A2;
	Mon,  9 Nov 2026 23:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794268276;
	bh=zWSSpiXIs7GUJU74turtE6kZK6M9BH3bJIxYHznb2cQ=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=aYLXGiO/y1apujItMYsfZF7dy6qICQtuLyEiJM+oicFrkZVHXzKSgwacRB9NPtlDV
	 H3sKgWA/KcX2yjyIGd40qxWnWa/eaQIinGExNejNusOTbKYUyQ8fgVWQ6HdlHXJ48o
	 mGSKL52G/W02HLCHciWzSjAO2RfuP4z0LYK0csnQXFtcYFpw8VIIDtc0RkuKn0Edk3
	 AURLKMckJHx3zeXoBYnJ6vqClYAZkaPGhSdQzn5+UzsfBUa1sjAX6lOkoJHHUCq7HB
	 KdkEIZfu94i2rrN4R6u9ktMw2UxocAn+apV8ZzB2NMq8IRzWuh3yXRS7OGr2UVNuJW
	 LC2F9hVt7B/ig==
From: Chris Mason <mason@kernel.org>
To: mason@kernel.org,
	tytso@mit.edu,
	cem@kernel.org,
	david@fromorbit.com,
	jack@suse.cz,
	djwong@kernel.org,
	josef@toxicpanda.com,
	hch@lst.de,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v6 02/10] xfs: flush the shifted range before changing the file
Date: Mon, 09 Nov 2026 18:51:13 -0500
Message-ID: <20261109235111.14129-3-mason@kernel.org>
In-Reply-To: <20261109235111.14129-1-mason@kernel.org>
References: <20261109235111.14129-1-mason@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

If writeback of the range to be shifted fails, collapse range on XFS can
fail with its hole already punched, and insert range with the file
already grown.

Both calls change the file first: collapse range punches its hole, and
insert range grows i_size. Only then does xfs_prepare_shift() flush the
range from the offset to EOF, and that flush fails if the writeback
fails.

The fix used here is to flush and invalidate that range before the file
is changed.

Signed-off-by: Chris Mason <mason@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 396aca8c66a9..be1f775128d1 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1201,6 +1201,22 @@ xfs_falloc_setsize(
 			&iattr);
 }

+/*
+ * Collapse and insert range change the file in several steps, and each step
+ * writes back and empties the part of the page cache that it needs.  That can
+ * fail.  Do it here for everything that is going to move, before the first
+ * step, so that a failure leaves the file as it was.  xfs_prepare_shift()
+ * starts one allocation unit before the offset, so do the same.
+ */
+static int
+xfs_falloc_flush_shift_range(
+	struct xfs_inode	*ip,
+	loff_t			offset)
+{
+	offset -= min_t(loff_t, offset, xfs_inode_alloc_unitsize(ip));
+	return xfs_flush_unmap_range(ip, offset, XFS_ISIZE(ip) - offset);
+}
+
 static int
 xfs_falloc_collapse_range(
 	struct file		*file,
@@ -1222,6 +1238,10 @@ xfs_falloc_collapse_range(
 	if (offset + len >= i_size_read(inode))
 		return -EINVAL;

+	error = xfs_falloc_flush_shift_range(XFS_I(inode), offset);
+	if (error)
+		return error;
+
 	error = xfs_collapse_file_space(XFS_I(inode), offset, len, ac);
 	if (error)
 		return error;
@@ -1263,9 +1283,10 @@ xfs_falloc_insert_range(
 	 * fork. This shifts back out beyond EOF, but creates an expectedly
 	 * written post-eof block. The insert is going to flush, unmap and
 	 * cancel prealloc across this whole range, so flush EOF now before we
-	 * bump i_size to provide consistent behavior.
+	 * bump i_size to provide consistent behavior.  Flush and unmap the rest
+	 * of the range as well, so that a failure to do so leaves i_size alone.
 	 */
-	error = filemap_write_and_wait_range(inode->i_mapping, isize, isize);
+	error = xfs_falloc_flush_shift_range(XFS_I(inode), offset);
 	if (error)
 		return error;

--
2.55.0

