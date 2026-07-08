Received: from sender-op-o14.zoho.eu (sender-op-o14.zoho.eu [136.143.169.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE7C233955;
	Wed,  8 Jul 2026 22:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=136.143.169.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783550822; cv=fail; b=mcIw8YdvJnlTw2otbKA9qTrfJqfBOoZwgKB2tyNuo05lTy6Ydol2SIjd5oH5FXnFXV/NumNxgOmJ6Z0dd3uP+BfBHrcoLq0VcUuG+YWdpnGjxvEkHWS7RVH4Jd1BgSs0Z3IHtaxwbw4B4mzDuLsmjei+bpjpTL8qWJfFwbpgUQI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783550822; c=relaxed/simple;
	bh=nuflfa/JMZtrKryS5kNFbAPHIoUCjDn6vGPQiOD0A8U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FbmV7PqKKUrLNeQLH1diiMfc72guldTX4Ra7F1yH1YdX7mDIlfVdec/eYJTs2zBLmS7zavJ32lkNBtW/BHFOumczeCjGSsLiWKFZZLA7czpHgU2meoJLOqHYXm4/+l2vH6Xq260XSBvbOGDrYENzeVSPmut4cTBZH3qJvxj45+U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=auditcode.ai; spf=pass smtp.mailfrom=auditcode.ai; dkim=pass (1024-bit key) header.d=auditcode.ai header.i=security@auditcode.ai header.b=gLbiQuWq; arc=fail smtp.client-ip=136.143.169.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=auditcode.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=auditcode.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=auditcode.ai header.i=security@auditcode.ai header.b="gLbiQuWq"
ARC-Seal: i=1; a=rsa-sha256; t=1783550806; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=lhu8EZCXz1af5zWWVNCqzi62Bpuxq7/fCZVN4HcBjizKJSt7UaL4EwQ+MYcjz8EwI8B98yb0JD0KuQcJ7aex5bj99e5Ltu/og4LAPHtszKqyuj9ecMNasADQzknllEJwT6l1ayBPI1itE8wVkiBCODfvrASDi0OHmVWhnwovdlw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1783550806; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:To:To:Message-Id:Reply-To:Subject; 
	bh=VEinpIaJCAXBHJTwA2+fKD8XKFX3u30ybEPtQox1mWA=; 
	b=i7+4S7QSW3uQxmwYwFVK6FpHd4IKQ0Ji497TkHYYidYulXtsYNHBX9jPGLF6AekVYIxodmdnSE5Qs2e0RvadjJuEy/Bk/6s/NADSOkHhpU2rHWOhVAb3eRIaBg3gmTgsQz+YfR2oyr0x6Vaxc6Wo57hXsBOIvqwPc2z8dsiDBeo=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=auditcode.ai;
	spf=pass  smtp.mailfrom=security@auditcode.ai;
	dmarc=pass header.from=<security@auditcode.ai>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1783550806;
	s=zmail; d=auditcode.ai; i=security@auditcode.ai;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=VEinpIaJCAXBHJTwA2+fKD8XKFX3u30ybEPtQox1mWA=;
	b=gLbiQuWq30tKkrK06XEqk4p/ybD/W+Scrum+PkTdQLdqp/Swu4a5AjoZF7Q61skP
	t21YL/H7mTX+nYtbsYqraMl0nzZGiy563jX1+LVstiMd9eIiufNBcFubpSmBXXB4MwP
	9yKKKPcgz7Sw9ySseJvh7RKXFC3F9rj4KScXOJgY=
Received: by mx.zoho.eu with SMTPS id 1783550803024679.3771164013115;
	Thu, 9 Jul 2026 00:46:43 +0200 (CEST)
From: Ibrahim Hashimov <security@auditcode.ai>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: 
Date: Thu,  9 Jul 2026 00:46:40 +0200
Message-ID: <20260708224640.1400-1-security@auditcode.ai>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

From 9164c8d0d80694186447a0c0055c7a170f594a79 Mon Sep 17 00:00:00 2001
From: Ibrahim Hashimov <security@auditcode.ai>
Date: Wed, 8 Jul 2026 14:46:15 +0200
Subject: [PATCH] xfs: bounds-check buffer log item's dirty bitmap

xlog_recover_do_reg_buffer() replays each dirty region a buffer log
item's bitmap describes into the in-core buffer read for that log
item:

	memcpy(xfs_buf_offset(bp, (uint)bit << XFS_BLF_SHIFT),
		item->ri_buf[i].iov_base,
		nbits << XFS_BLF_SHIFT);

The only thing standing between that destination offset and the end
of "bp" is:

	ASSERT(BBTOB(bp->b_length) >=
	       ((uint)bit << XFS_BLF_SHIFT) + (nbits << XFS_BLF_SHIFT));

"bp" is sized directly from the logged, attacker-controlled
buf_f->blf_len (xlog_recover_buf_commit_pass2() ->
xfs_buf_read(..., buf_f->blf_blkno, buf_f->blf_len, ...)), while
"bit"/"nbits" come from the logged dirty bitmap (buf_f->blf_data_map),
also attacker-controlled. Nothing else relates the two: the source
side is trimmed against the log iovec length a few lines down
(item->ri_buf[i].iov_len), but the destination side has no equivalent
runtime check.

ASSERT() compiles to a no-op on production (non-DEBUG, non-XFS_WARN)
kernels, which is exactly where this matters. A dirty log record
whose buffer-log-format item logs a small blf_len (e.g. 1, a
512-byte buffer) together with a dirty bitmap bit that indexes past
that buffer drives the memcpy() above straight past the end of the
recovered buffer's backing allocation, corrupting adjacent kernel
heap memory during mount-time log recovery of a crafted (or merely
corrupt) XFS image. This is reachable by anyone who can get such an
image mounted (CAP_SYS_ADMIN in the init namespace, or automount of
removable/untrusted media) -- the standard malicious-filesystem
threat model XFS's other verifiers guard against. Found with a
KASAN-enabled kernel: a crafted image with a small blf_len and an
out-of-range bitmap bit produces a slab-out-of-bounds write during
log recovery.

Nearby recovery code already treats this class of "logged size
doesn't match reality" problem as a real runtime condition rather
than an invariant to assert on. In this very function, the dquot
sanity check a few lines below does exactly that:

	if (item->ri_buf[i].iov_len < size_disk_dquot) {
		xfs_alert(mp, "XFS: dquot too small (%zd) in %s.", ...);
		goto next;
	}

and its sibling xlog_recover_do_inode_buffer(), a little further down
in this same file, converts the equivalent destination-bounds
ASSERT() into a real XFS_IS_CORRUPT() check that aborts recovery of
the item instead of trusting the log:

	ASSERT((reg_buf_offset + reg_buf_bytes) <= BBTOB(bp->b_length));
	...
	if (XFS_IS_CORRUPT(mp, *logged_nextp == 0)) {
		xfs_alert(mp, "Bad inode buffer log record ...");
		return -EFSCORRUPTED;
	}

Give xlog_recover_do_reg_buffer() the same treatment: turn the
destination-bounds ASSERT() into a real XFS_IS_CORRUPT() check, log
it with xfs_alert() (matching xlog_recover_do_inode_buffer() and the
xfs_dquot_item_recover.c size checks), and fail recovery of this
buffer with -EFSCORRUPTED instead of copying past its end. Since the
function now needs to report failure, change it from "STATIC void"
to "STATIC int" and propagate the new error out of all three
callers:

  - xlog_recover_do_primary_sb_buffer(), which already returns int
    and already checks other error conditions inline;
  - xlog_recover_do_dquot_buffer(), which returns a "dirty" bool to
    its one caller; it gains an "int *error" out-parameter so the
    caller can distinguish "buffer intentionally skipped" from
    "buffer recovery failed";
  - the plain regular-buffer branch of
    xlog_recover_buf_commit_pass2(), which already has an in-scope
    "error" local used by the sibling branches right next to it.

This is a minimal, targeted fix: it does not change any successful
recovery path (the new check only rejects logs that were already
violating the invariant the ASSERT() was documenting), and it
mirrors the exact validate-and-fail idiom already used a few lines
away in the same file and in fs/xfs/xfs_dquot_item_recover.c.

Verified on a v6.19 KASAN-enabled kernel (CONFIG_XFS_DEBUG=n): mount
of a crafted image whose buffer log item's dirty bitmap indexes past
its logged blf_len trips a KASAN slab-out-of-bounds write in
xlog_recover_do_reg_buffer() before this patch; with the patch
applied, mounting the same image fails recovery with -EFSCORRUPTED
and no KASAN report is produced.

Cc: stable@vger.kernel.org
Signed-off-by: Ibrahim Hashimov <security@auditcode.ai>
Assisted-by: AuditCode-AI:2026.07
---
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

