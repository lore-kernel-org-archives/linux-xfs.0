Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794445356;
	b=vFydqqbkl20b7MrMpt3hIO5nhZeKx5Jf2/RHPo3PJoaFOs8P7kBLXk0bHJCZXFWjOX9l
	 TSzbNsOivTPtPKRy25Fj/uRMUae+0XXSITi6DbFnSD6Zz6Hf7BGTmlAMBxMk0d3BsxGM1
	 xy0aNuwAwT4+7Qi5GgYkI3zfrBey7mhS4wgbO+huozIYr1Rx52D16izovBwBppsuTjp4Q
	 Y9Y8ZXUk7TegNXpWepFt1zUUaE/3RNF4NLFH8NMQ6Ds1nfFw0QNJtD6+zFT0VxnWegmC8
	 qer7srUL0mkkQdIH/j5YwI39UU94gjHHr3Y2TUu7vOIH3AnIQs3a9n+4D7zLPwkMsYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794445356;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=wdcOD6NooPR8ufc7d1pGrtab6fBn8Smwobz1ebtqowg=;
	b=iwkHmYW2PGMBa2C1j/19IZ0xQIuSwCbhEc+d7kMmlEAkrbeQr/LV2eOTfPkqivuhhcgG
	 AbrkFBc1eFUqM87pVp7ezB5FaejSIn+5hSRSWB1IbyX0R8ZWUj34RqjKQaxsQnRp0gsMC
	 /Bs+sk8OiPlCT/IG60exJGpxykYMfPuxRu3Z0a20LN0vX1wavakauDKKjGxTkSHVH+ymK
	 O1/zc7a28YtdrSneFuVnHpLYEj51Rjt4ajKospnOZc8T5M3YQKK5eUsokIu5pl80k+CMC
	 KTNgFd+Zh2fuLgvtd+T8pFnOT6HZxNR/WPA4BvjEE/VYVQ1KLbk8PRgj+r3IY3iehZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cd+Dl2XJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1453E606A8A6;
	Thu, 12 Nov 2026 01:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cd+Dl2XJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492C81F00A05;
	Thu, 12 Nov 2026 01:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794445355;
	bh=wdcOD6NooPR8ufc7d1pGrtab6fBn8Smwobz1ebtqowg=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=cd+Dl2XJUohrDIoYioTI4+/j9bMP2uS/uE4rEgvzzh6i7LE9UAoFK+Qp/vcxWL8ik
	 Xv0c73ixtmSG33x8yC78yWjsv7osjpBkcprFyoflIpS4Ot2t7rsU5uIOeBAcTh8TmP
	 7T2Y/cirjOFZUZCYJF4T3BefsT6N1GGHun3R0FIUGrBjardAtGA/2wYIfScoyMc6t4
	 sLVaDk4NZSFhdGnd0ow5W1Dttam/PbJ/Av+j4JzxMyBH1s/NkBlEGR+rAgOMybou7d
	 NQnalpjenmGel5XDaYux7M8fiPBEWCGbna5l3bZPLYco2J46E7h69ReL3/oo2lmw+u
	 Gl+hlBbANRgFA==
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
Subject: [PATCH v8 02/15] xfs: flush the shifted range before changing the file
Date: Wed, 11 Nov 2026 20:02:31 -0500
Message-ID: <20261112010229.51029-3-mason@kernel.org>
In-Reply-To: <20261112010229.51029-1-mason@kernel.org>
References: <20261112010229.51029-1-mason@kernel.org>
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
    v7->v8:
    - No change.
    
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

