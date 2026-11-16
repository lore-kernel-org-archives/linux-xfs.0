Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871108;
	b=cM0ccx75EanjPgr2Ty5NR2fAo5vxV0MkP7ItOwGt87pizKtky3DkS5ftWiagRbAsR48y
	 TrUNgaKWsOdbf6YBpEtB3vSfX/KV/bLrEgyCHuSEmWCWjlshcC16Zv1/BymDOBRsx132Q
	 sWBCNDhUCeY9AnhLjyAvVJj48fL/MI7rslxedYYcb2rCR+fADoPPHmiOVDRAJYmCjR3ME
	 7QUh07jsRBoyjSQdx9PA0IBFDZmOSImBfsjYSlMOuoOQCVph0bSq4II3Hg5vbF7jGZlMq
	 lbmgWASNx9bauOwAVJsKlBEu63TRxUQFZOTcDLqw4Yh1GBDBHL6a7jNs0bnJJzlrB0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871108;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=f9+hGlCgZNe9PwPIybNmQIwqmezHfzRR2jKhTIpEFHM=;
	b=AoGLiqr7qifrQ2t/UdFxLEWlvV1HIM+FAKIRDj4Vg1gF6MsSCW7dmGvkbOfSz+YiVAeZ
	 sL5ZlFo6o9cp4Bjge37/a+YDgG167rjnsyEQOjjBMEU3IB3cLhrBeBvk+lY63cd6GOvbB
	 x2HiraqEGSSfDWwXnUoWnhIgzAmsZou1aO+plfiz+eZ+QrJvBWJU2xJwYU2/+ihGjIJ9a
	 C3v+PZ31CKpEkm1pzPdmT8KVBUZwrBJbBMev+q3+GARo0LYmOy8mwXI0ACm24MjBwAT93
	 TIlFvN8GGQJvhmlQPy/j3uO+KlrB6ENUEVFyiMUm/RRdrJ2xipq/eYqTuMxgiheWNCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mKMYGtgo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07095606A32C
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mKMYGtgo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231C31F000CA;
	Mon, 16 Nov 2026 23:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871107;
	bh=f9+hGlCgZNe9PwPIybNmQIwqmezHfzRR2jKhTIpEFHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mKMYGtgog4FNqfvWLVz5MoW+EsTxD7Ak4gciN5cCYItV6eOxv48V6tw0DOJIjnbs4
	 9tncU9AK59Yu+PoVTiB4A+7AsV+uEk/F7ONgy6uKiePdHXU5C7a7klTqf63Wp4C3jD
	 h/kx2bwIxl8iiSShQm8cKfiqjlCMZu+JB7kPNM4/5WED13e85rUXuEo6cGX/ab2SZd
	 ZRQJi9njpZfoLIsoJ3kJD4DUCHTwhIAp42kt2+JYeCLUdMxNhz689nLA95Y5GIsPz4
	 AAJ4fXI3cU5vBXgsiEEKFDS5QTJXQWxsjUIbqTEpI7NhphjoJJicYDp6xwh8xlkoZi
	 gBRzRD0FuFEkA==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 57/59] xfs: remove redundant buffer checks from recovery replay
Date: Tue, 17 Nov 2026 10:15:14 +1100
Message-ID: <20261116231707.3625263-58-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261116231707.3625263-1-dgc@kernel.org>
References: <20261116231707.3625263-1-dgc@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The buffer item is now fully validated as it is decoded from the journal. The
replay paths can therefore trust its regions and dirty bitmap. The bitmap and
region consistency checks scattered through the buffer and inode buffer replay
loops are now redundant.

Remove the region and bitmap checks from the replay loops. The checks on buffer
contents remain, because they cannot be validated from the log item alone.

Validation now requires each run of dirty bits to map to a single logged region.
Replay therefore no longer needs to handle a dirty region split into two logged
regions. The code that trimmed each run to the length of the logged region being
copied is removed as well.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_buf_item_recover.c | 40 -----------------------------------
 1 file changed, 40 deletions(-)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index d8cec17bbb4e..bedaa25fa12e 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -487,38 +487,6 @@ xlog_recover_do_reg_buffer(
 			break;
 		nbits = xfs_contig_bits(buf_f->blf_data_map,
 					buf_f->blf_map_size, bit);
-		ASSERT(nbits > 0);
-		ASSERT(item->ri_buf[i].iov_base != NULL);
-		ASSERT(item->ri_buf[i].iov_len % XFS_BLF_CHUNK == 0);
-		/*
-		 * The bitmap is only trustworthy to the extent that it
-		 * describes a region that actually fits inside the buffer we
-		 * read in based on the (attacker-controlled) blf_len.  Do not
-		 * rely on an ASSERT() for this -- it compiles away entirely on
-		 * non-DEBUG kernels, which is exactly where this matters, so
-		 * validate it for real and abort recovery of this buffer rather
-		 * than copying past the end of it.
-		 */
-		if (XFS_IS_CORRUPT(mp, BBTOB(bp->b_length) <
-				((uint)bit << XFS_BLF_SHIFT) +
-				(nbits << XFS_BLF_SHIFT))) {
-			xfs_alert(mp,
-	"Bad buffer log item dirty bitmap (bit %d, nbits %d) for %d-byte buffer at daddr 0x%llx.",
-				bit, nbits, BBTOB(bp->b_length),
-				xfs_buf_daddr(bp));
-			return -EFSCORRUPTED;
-		}
-
-		/*
-		 * The dirty regions logged in the buffer, even though
-		 * contiguous, may span multiple chunks. This is because the
-		 * dirty region may span a physical page boundary in a buffer
-		 * and hence be split into two separate vectors for writing into
-		 * the log. Hence we need to trim nbits back to the length of
-		 * the current region being copied out of the log.
-		 */
-		if (item->ri_buf[i].iov_len < (nbits << XFS_BLF_SHIFT))
-			nbits = item->ri_buf[i].iov_len >> XFS_BLF_SHIFT;
 
 		/*
 		 * Do a sanity check if this is a dquot buffer. Just checking
@@ -557,9 +525,6 @@ xlog_recover_do_reg_buffer(
 		bit += nbits;
 	}
 
-	/* Shouldn't be any more regions */
-	ASSERT(i == item->ri_total);
-
 	xlog_recover_validate_buf_type(mp, bp, buf_f, current_lsn);
 	return 0;
 }
@@ -676,7 +641,6 @@ xlog_recover_do_inode_buffer(
 
 			nbits = xfs_contig_bits(buf_f->blf_data_map,
 						buf_f->blf_map_size, bit);
-			ASSERT(nbits > 0);
 			reg_buf_offset = bit << XFS_BLF_SHIFT;
 			reg_buf_bytes = nbits << XFS_BLF_SHIFT;
 			item_index++;
@@ -690,10 +654,6 @@ xlog_recover_do_inode_buffer(
 		if (next_unlinked_offset < reg_buf_offset)
 			continue;
 
-		ASSERT(item->ri_buf[item_index].iov_base != NULL);
-		ASSERT((item->ri_buf[item_index].iov_len % XFS_BLF_CHUNK) == 0);
-		ASSERT((reg_buf_offset + reg_buf_bytes) <= BBTOB(bp->b_length));
-
 		/*
 		 * The current logged region contains a copy of the
 		 * current di_next_unlinked field.  Extract its value
-- 
2.55.0

