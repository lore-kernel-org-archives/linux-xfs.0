Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794519971;
	b=yGX4rEQe1g65ZCB6k0GkLdp55DC81FFujL1HwjWjrqmjF/ukzizHVP+hfekvsI81Iqwi
	 GCzZaxwoYbKNOLYedbg9+GIMi6dG7g4GZX73uvcDQSRRnrwaFoEr9fAvvuMdO5wDs0zpf
	 erURLAyYNVBhm3YU3l/+IfwcpF0RutFagQj5UZmhLevuOR2bp6vwYgomZ+V3v5FysKBq+
	 9vON+8Er+hBtc4dyRAqHMK0gPShxOUh94+gY0JZTEPtjjGYIAxxV7+Kqa0RHEHf0JiIrR
	 0HMHJRYVwTfw+E5T5XsuuCHcbGfOxvEitYam64tIGGO9MEArhXcnvVbOQCe8zWnBAPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794519971;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=mxKRfWymEhtiO4U6xQqttLq6lkQ7E/WLxKKc01cUC4c=;
	b=paWoZt/r1xaRj+KHPyTi2jXZysEt2rShNakFjIxL18d7n/hlinSyYWM9es4jbGtIeeBY
	 uZw9uCxcx9T/EPa1/L9g2qNIBChd9Ui9/x9CUFZSVUvkeDmog5aBrERHCbPUZpGBFOAea
	 iQ5jOMvh+/fZrhmND1QFSonU0bBPNrYbWVqvyj41XISEKAoFGz0Rz6a00p0ZyqDUK3i8+
	 KBaBJteH9EsvJmkBjP1ozQCaWiGJCnt4w634z48FYmF6L7HcqX0AxRCtG+45djWrVM7sz
	 +YfWYPB54+nTqdII+K/PC6uUX/PoQ4uNHXlyGWQA0xmhxIEG04Ehi4haqEz7B111IVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KfLiqpSl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBD3606A895;
	Thu, 12 Nov 2026 21:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KfLiqpSl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B091F000D2;
	Thu, 12 Nov 2026 21:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794519971;
	bh=mxKRfWymEhtiO4U6xQqttLq6lkQ7E/WLxKKc01cUC4c=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=KfLiqpSl3PHCiBMLu5m/RcpJz9N+6ICKzxdbrw5OPlx5UU9tQKtx0Pl+SLJr7XNxM
	 f5/Yq+/RhmVzFZ0lPjGwtzPcB2dQgHU82EJLLeAOF22qRwdo61w1efEq1MjD/dZihF
	 cfrjcd7tWpt1/w8AgIDaz7PPBSiwzfJXBI+Krra2oG8e86aPT0g8eeDcSDlN5R8y7t
	 HLNLQ3EJKjlq74RTK+Uhe3FT6U251xqgWSLE2/UqKk+bCjsHx7uc8CmOWg1aGSrWmX
	 nR3I+vtroxsj9ajWQWuHo2n3zDJkIIXcuy1jH01r1qr9JJLF6kyGpuXNEv43eM1QvY
	 cctUDt+Bl7DyA==
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
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	tz2294@columbia.edu,
	brauner@kernel.org
Subject: [PATCH v9 02/14] xfs: flush the shifted range before changing the file
Date: Thu, 12 Nov 2026 16:46:06 -0500
Message-ID: <20261112214604.67875-3-mason@kernel.org>
In-Reply-To: <20261112214604.67875-1-mason@kernel.org>
References: <20261112214604.67875-1-mason@kernel.org>
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

Notes:
    v6->v9: no change

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

