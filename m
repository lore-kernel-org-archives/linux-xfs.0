Received: from sender-op-o14.zoho.eu (sender-op-o14.zoho.eu [136.143.169.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5724A33EE;
	Tue, 14 Jul 2026 17:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784050089; cv=pass; b=O8i6xCvs0qBYpy3AGHKuxNR4JIP4Upn/yWlpxR3WBdabM4RFTg3X9WC/DR1LUq3WBxGjnWoXJEMokHGC29stcq49mIDqTVBe7lxTP5N7o4HmKfZyQZs1CI2OoYjba4fF4WvNImasCgT4XVLuJS7tlr3mEiGNB4yWor7AX3r8990=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784050089; c=relaxed/simple;
	bh=+CdKXOVVRYrqjjRvEc5d1x8WFWoQfwKjiybkT7eZOYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LVtCcujb/lWdH18SItcWYjUWSXEli2cRlEMkCZcAEcx3p36KqJqLWYlfFB4F/udqF3vu1AtX/ZP+LiMn2OgO7rJbDG6zBjyMv6VQ0fQPWZqLGCIT54OB79m12ipMfcs2lbWHpl/dXxuQdc19rzk+t82Eo/u+3QveKGs9BHYfSOM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=auditcode.ai; spf=pass smtp.mailfrom=auditcode.ai; dkim=pass (1024-bit key) header.d=auditcode.ai header.i=security@auditcode.ai header.b=oFNVFQ9W; arc=pass smtp.client-ip=136.143.169.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=auditcode.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=auditcode.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=auditcode.ai header.i=security@auditcode.ai header.b="oFNVFQ9W"
ARC-Seal: i=1; a=rsa-sha256; t=1784050066; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=jYynRAuQlE6CUQPQtMDQhifqU9YOHqzlnBYKb+o+tbJqVaDsQB90KDP+c9Fht1kifJqp/hWFKZNjzBCE4zP1FiTdF9EQZFBApBUqlBii4n0PpT+7OmiywzrZ9Vhi+CQjn81GkKNdC9ncKS0UmW4dYRHAVbFG9T5PVQl/Dr+7YoU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1784050066; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=6UeP/VDZyPjcl/HdNqYzQJ9QoEouMkC4hjP+2tzge8A=; 
	b=Z9U2KvseMsYAzEmpF5LLYNzyJscTKpzd6EwR+tvHFqbPFYH9Ps/YIZYWa7YKjNLh55S6sQVidLgIwa+jKuR/nPLafjS4JtTsUwOHHpNJwpiATlw0hGVWBwWA+SyV3d4FmzbLBX3BED5Gpf7IL0nmNsWUH+dFVXqYzKK9KRoyJpQ=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=auditcode.ai;
	spf=pass  smtp.mailfrom=security@auditcode.ai;
	dmarc=pass header.from=<security@auditcode.ai>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784050066;
	s=zmail; d=auditcode.ai; i=security@auditcode.ai;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=6UeP/VDZyPjcl/HdNqYzQJ9QoEouMkC4hjP+2tzge8A=;
	b=oFNVFQ9WQ/8fsi14+IaRxftENK0sdzeIXA7ZB9V25eELENU1jSwzCNs+SqjlE5Jb
	CHVed1feclYZgL5EC7efEnQ9zGFya8qK5FnWE+0VXflZEqX2L42/TQ9v4owKKwSYqO/
	N9a9C2gQaFT5FrYkg0CyKfcQpt0gV+JNOnDP1O6w=
Received: by mx.zoho.eu with SMTPS id 1784050063328436.2612031617032;
	Tue, 14 Jul 2026 19:27:43 +0200 (CEST)
From: Ibrahim Hashimov <security@auditcode.ai>
To: cem@kernel.org,
	linux-xfs@vger.kernel.org
Cc: bfoster@redhat.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3] xfs: bounds-check buffer log item's dirty bitmap
Date: Tue, 14 Jul 2026 19:27:30 +0200
Message-ID: <20260714172730.73160-1-security@auditcode.ai>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260708225814.2568-1-security@auditcode.ai>
References: <20260708225814.2568-1-security@auditcode.ai>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

xlog_recover_do_reg_buffer() replays each dirty region described by a
buffer log item's bitmap into the buffer read for that item:

	memcpy(xfs_buf_offset(bp, (uint)bit << XFS_BLF_SHIFT),
		item->ri_buf[i].iov_base,
		nbits << XFS_BLF_SHIFT);

The destination offset (bit/nbits, from the logged dirty bitmap) and the
buffer size (from the logged blf_len) are both attacker-controlled and
otherwise unrelated, yet the only thing bounding the copy is an ASSERT(),
which compiles away on production kernels. A crafted image logging a
small blf_len together with a bitmap bit past the end of that buffer
drives the memcpy() past the buffer's allocation, corrupting adjacent
kernel heap during mount-time log recovery. This is reachable by anyone
who can get a crafted image mounted -- the malicious-filesystem threat
model XFS already guards against elsewhere.

Turn the ASSERT() into a real XFS_IS_CORRUPT() check that aborts recovery
of the buffer with -EFSCORRUPTED, consistent with the validate-and-fail
idiom already used in xlog_recover_do_inode_buffer() and
xfs_dquot_item_recover.c. xlog_recover_do_reg_buffer() therefore becomes
STATIC int and its three callers propagate the error.

Found and confirmed with KASAN on a CONFIG_XFS_DEBUG=n build: the crafted
image trips a slab-out-of-bounds write before this change and fails
recovery cleanly with -EFSCORRUPTED after it.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
Assisted-by: AuditCode-AI:2026.07
---
v3: trim the changelog per Brian Foster's review; no code change. Add a
    Fixes: tag -- the destination-bounds check has been an ASSERT since
    the initial git import (2.6.12-rc2), so it predates the git era.
v2: resend; v1 went out with an empty Subject line due to a local
    git send-email glitch (leading blank line in the patch file).

 fs/xfs/xfs_buf_item_recover.c | 48 ++++++++++++++++++++++++++++-------
 1 file changed, 39 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 02b95b89d1b5..521e5f544caf 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -461,7 +461,7 @@ xlog_recover_validate_buf_type(
  * given buffer.  The bitmap in the buf log format structure indicates
  * where to place the logged data.
  */
-STATIC void
+STATIC int
 xlog_recover_do_reg_buffer(
 	struct xfs_mount		*mp,
 	struct xlog_recover_item	*item,
@@ -489,8 +489,25 @@ xlog_recover_do_reg_buffer(
 		ASSERT(nbits > 0);
 		ASSERT(item->ri_buf[i].iov_base != NULL);
 		ASSERT(item->ri_buf[i].iov_len % XFS_BLF_CHUNK == 0);
-		ASSERT(BBTOB(bp->b_length) >=
-		       ((uint)bit << XFS_BLF_SHIFT) + (nbits << XFS_BLF_SHIFT));
+
+		/*
+		 * The bitmap is only trustworthy to the extent that it
+		 * describes a region that actually fits inside the buffer we
+		 * read in based on the (attacker-controlled) blf_len.  Do not
+		 * rely on an ASSERT() for this -- it compiles away entirely
+		 * on non-DEBUG kernels, which is exactly where this matters,
+		 * so validate it for real and abort recovery of this buffer
+		 * rather than copying past the end of it.
+		 */
+		if (XFS_IS_CORRUPT(mp, BBTOB(bp->b_length) <
+				((uint)bit << XFS_BLF_SHIFT) +
+				(nbits << XFS_BLF_SHIFT))) {
+			xfs_alert(mp,
+	"Bad buffer log item dirty bitmap (bit %d, nbits %d) for %d-byte buffer at daddr 0x%llx.",
+				bit, nbits, BBTOB(bp->b_length),
+				xfs_buf_daddr(bp));
+			return -EFSCORRUPTED;
+		}
 
 		/*
 		 * The dirty regions logged in the buffer, even though
@@ -544,6 +561,7 @@ xlog_recover_do_reg_buffer(
 	ASSERT(i == item->ri_total);
 
 	xlog_recover_validate_buf_type(mp, bp, buf_f, current_lsn);
+	return 0;
 }
 
 /*
@@ -553,7 +571,9 @@ xlog_recover_do_reg_buffer(
  * Else, treat it as a regular buffer and do recovery.
  *
  * Return false if the buffer was tossed and true if we recovered the buffer to
- * indicate to the caller if the buffer needs writing.
+ * indicate to the caller if the buffer needs writing.  *error is set if
+ * recovery of the buffer failed and the caller must abort replay of this
+ * buffer.
  */
 STATIC bool
 xlog_recover_do_dquot_buffer(
@@ -561,10 +581,12 @@ xlog_recover_do_dquot_buffer(
 	struct xlog			*log,
 	struct xlog_recover_item	*item,
 	struct xfs_buf			*bp,
-	struct xfs_buf_log_format	*buf_f)
+	struct xfs_buf_log_format	*buf_f,
+	int				*error)
 {
 	uint			type;
 
+	*error = 0;
 	trace_xfs_log_recover_buf_dquot_buf(log, buf_f);
 
 	/*
@@ -586,7 +608,7 @@ xlog_recover_do_dquot_buffer(
 	if (log->l_quotaoffs_flag & type)
 		return false;
 
-	xlog_recover_do_reg_buffer(mp, item, bp, buf_f, NULLCOMMITLSN);
+	*error = xlog_recover_do_reg_buffer(mp, item, bp, buf_f, NULLCOMMITLSN);
 	return true;
 }
 
@@ -724,7 +746,9 @@ xlog_recover_do_primary_sb_buffer(
 	xfs_rgnumber_t			orig_rgcount = mp->m_sb.sb_rgcount;
 	int				error;
 
-	xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
+	error = xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
+	if (error)
+		return error;
 
 	if (orig_agcount == 0) {
 		xfs_alert(mp, "Trying to grow file system without AGs");
@@ -1083,7 +1107,10 @@ xlog_recover_buf_commit_pass2(
 		  (XFS_BLF_UDQUOT_BUF|XFS_BLF_PDQUOT_BUF|XFS_BLF_GDQUOT_BUF)) {
 		bool	dirty;
 
-		dirty = xlog_recover_do_dquot_buffer(mp, log, item, bp, buf_f);
+		dirty = xlog_recover_do_dquot_buffer(mp, log, item, bp, buf_f,
+						     &error);
+		if (error)
+			goto out_release;
 		if (!dirty)
 			goto out_release;
 	} else if ((xfs_blft_from_flags(buf_f) & XFS_BLFT_SB_BUF) &&
@@ -1105,7 +1132,10 @@ xlog_recover_buf_commit_pass2(
 			xfs_buf_relse(rtsb_bp);
 		}
 	} else {
-		xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
+		error = xlog_recover_do_reg_buffer(mp, item, bp, buf_f,
+						   current_lsn);
+		if (error)
+			goto out_release;
 	}
 
 	/*
-- 
2.50.1 (Apple Git-155)

