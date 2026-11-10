Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794337465;
	b=ELlpvIa3piC0/gwZ4D/eMVGdjHRLHIgF7s8wtRWD+L4M1wtxnbyg1xd7DjutNI5yt5iF
	 g9cmgJCvTu3c4SF4pZEbQwZFenWtljMw3upOYasXD7eMsu5UMITi+J7L8UUv3SsruqEhI
	 2PkqZSTdg2x6y1+3X+xcLmLSMsqsNhXKFm8k1022H7IbQfyYiuLJ7CN1uajyCnm5t/+WE
	 O9PG7jtCOiaobONb7WJ7vQdeF5/iY1yIAew6X4vYn296gQzVMWI0TVrDYKMqVZ2gUDyR3
	 xBcm4176zGIcnQ6Z59999c8vm1DyPwrJKez827M87ipFTMhJ09oW8O9pW4bAEFp1/Fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794337465;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=0V/iQvKjgG84q8R+WBSP/QKRp/eHaP8wuEqSYnCOVKs=;
	b=Q8lSA1/81ZbUp9ixv3dh8sw6G2mkV9ogdujtZTtj2DfiwYKaTW/DcY0LQ32rsZ/jIYzL
	 7JTFEdnmip6Zlz93h7o4fsojNE+Gdl+PD7d1sWciqwuAiG3xWmFX5eFpqLff5gcwnNwV6
	 9DexbqQ/xo9z0dkUFTtk78nP/5QmD0ByziwieiJLdfDZDR/vNMHMSIQ1Tcc1yXLBXg1b2
	 qyDTL7J2gvBu4YNtr5OuEqlES62wb58roqfBWk78swFBUWn9Ey0N5Ctp6b/XepSZH55UA
	 TzbAkZIaKP9/7Qg0230mZ/gSHuhaNvCORLbHoPLXE4cyNtOSqnTeMmRs5zTt/r3AxVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NSD+rXfE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915E7606A333;
	Tue, 10 Nov 2026 19:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NSD+rXfE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10E41F008BC;
	Tue, 10 Nov 2026 19:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794337465;
	bh=0V/iQvKjgG84q8R+WBSP/QKRp/eHaP8wuEqSYnCOVKs=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=NSD+rXfERvkxcsT/V1M3WUl/xI9DmSp3IpALBS+p4hXokPKmUkFtcmQqbZjQFB71C
	 oSSyVNTtNE0FNi7OKoYqB92Hz7pxKW/Q+irH9MdiuAE5Xl3d9olty+7sL2l0jkJG4g
	 BrUO7d//MEUHyiKMrCUDi1eT5MVCYh6dPnanQdLDLq2IhImrZyV4SieG1sIaTfhTB8
	 TJe+SJ4lQ3KvRjxln4nbQnqpnQN/ipFSToV8LTg8OWPH6BPLp20M0Vi7zaxXppyth4
	 Om8ROcXBJKOk8FPMXSaIT3noVZ1Ne8UYjcE7Ttpg8u8mb0Hv/LNdPY75Dy5tK/6SN7
	 qQ5HE5Z94W4jg==
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
Subject: [PATCH v7 02/11] xfs: flush the shifted range before changing the file
Date: Tue, 10 Nov 2026 14:04:20 -0500
Message-ID: <20261110190417.32650-4-mason@kernel.org>
In-Reply-To: <20261110190417.32650-1-mason@kernel.org>
References: <20261110190417.32650-1-mason@kernel.org>
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
    v6->v7:
    - No change.

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

