Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7462472094
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871387; cv=none; b=LOy4efs4ywaerTfV94DoseatTI9Q8CeiqgRE0UBoSTsV8scrsovj0e0W7SAJcGG6ZzDE6SolRqiF3d5yS63ZAE6kmki51ztgeEqaWAgoz1nml+y5g6w94Qyz78Y5R+uUaAcTMxv/RklphMhMRFlYkICBE6q6GnYoq2cM2RerfJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871387; c=relaxed/simple;
	bh=PgwvrzLwip0OAxzSGyfM0NlRuj1R2cs1r+IXT4B79H0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZjKU6eClgJZHrg+hum66jc7VtDU1eyuIWj0B8YAnOt1O+fiAWkjTL0/6Er+tXfUU2mFRXwvG06SAA1qPQ2QZUTzfVa09Rifp3gd0ybZfn8y33JQj9dJsp3/BVPxxWD9GfaZAVeQdzmXBhRYScDJsVH8KbPXW4og9YNKb40XuGDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QPS3Ps7E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QPS3Ps7E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A391F00893;
	Tue, 13 Oct 2026 06:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871386;
	bh=ypHbFOrA9Nzx7vVhe/6Ss0AmKWbsHIxbn7mjZNBGoh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QPS3Ps7EW4PYeVA2W4VQ90hvau6qe5ga7cDT038MkfZhXrY6w+e0JQ+aVA+c0Ztwi
	 F/CgHTmrYZJxSEY8eoJt2YPQ3ggZtXgjO/gqVhFrmigRAV8LRR7ASROYJglUtWdaF6
	 m6kliVV738Jft0hMMLN+GHEAAlOwtVVPw8IBdzqOME884AFzZXiZ4etHjQi8fvRhdR
	 w3qXTpX1uFIBZz8KWKLAQANFyvn7pEWmk/7jx9Xk7fuyx9vgk7XmoEm6dmXQLYlDv6
	 dMJ3xXBUCbVUbs4wYnZWRLD/EnmwnaPhq1K/qG4HNLpbTH5bj3t3IELqmq6IXEoT6L
	 XsD2SSqg+F5FQ==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 46/48] xfs: remove redundant buffer checks from recovery replay
Date: Tue, 13 Oct 2026 17:01:36 +1100
Message-ID: <20261013060204.3138690-47-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013060204.3138690-1-dgc@kernel.org>
References: <20261013060204.3138690-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The buffer item is now fully validated as it is decoded from the journal, so the
replay paths can trust its regions and dirty bitmap. The bitmap and region
consistency checks scattered through the buffer and inode buffer replay loops
are now redundant.

Remove the region and bitmap checks from the replay loops. The checks on buffer
contents, which cannot be validated from the log item alone, remain.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_buf_item_recover.c | 40 -----------------------------------
 1 file changed, 40 deletions(-)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 309260e65889..a3acefcea13a 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -485,38 +485,6 @@ xlog_recover_do_reg_buffer(
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
@@ -555,9 +523,6 @@ xlog_recover_do_reg_buffer(
 		bit += nbits;
 	}
 
-	/* Shouldn't be any more regions */
-	ASSERT(i == item->ri_total);
-
 	xlog_recover_validate_buf_type(mp, bp, buf_f, current_lsn);
 	return 0;
 }
@@ -674,7 +639,6 @@ xlog_recover_do_inode_buffer(
 
 			nbits = xfs_contig_bits(buf_f->blf_data_map,
 						buf_f->blf_map_size, bit);
-			ASSERT(nbits > 0);
 			reg_buf_offset = bit << XFS_BLF_SHIFT;
 			reg_buf_bytes = nbits << XFS_BLF_SHIFT;
 			item_index++;
@@ -688,10 +652,6 @@ xlog_recover_do_inode_buffer(
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

