Received: from sender-op-o17.zoho.eu (sender-op-o17.zoho.eu [136.143.169.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BAD3C09FA;
	Wed, 15 Jul 2026 07:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784099865; cv=pass; b=rrm9c2g5atTqS2Ya8uyXDMSSvBqogcsl8BjnS/OvEqkVW3XPHa5sa5FhiRttCyKbJ04STlsQZsYu9uZiq4rgsTtiO8tQ3OjrYMgJB6FLlAzk5H9mkflKDHIArTaJz0EbL56o0/ZaqO8oxbOUCOyV1NIb5YPYYW2DEy85+9eBre8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784099865; c=relaxed/simple;
	bh=Pjh69Fxs6QXodbu7OZ/QWYXtd27CknmVVy+NkmseZJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ruDEMIzrznjxW0BbgISzTYz3Lhi9IOUNECHniA9l2EUJ2MZCWBH9v+RIlaFFXWOswH/TbLo2ujYHhY4SuBTKD9j3Qa+2s+M8vOJOoCgL3b10Ky0uU/q49o32VQnkcIpk20a6gU1O8V3+i5pRHJQ9rcAQ727NeG+qajXsJkndaLs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=auditcode.ai; spf=pass smtp.mailfrom=auditcode.ai; dkim=pass (1024-bit key) header.d=auditcode.ai header.i=security@auditcode.ai header.b=P9BJy97b; arc=pass smtp.client-ip=136.143.169.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=auditcode.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=auditcode.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=auditcode.ai header.i=security@auditcode.ai header.b="P9BJy97b"
ARC-Seal: i=1; a=rsa-sha256; t=1784099849; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=Rs/5+2GbK+q/eUCpFej6peRfezkXyikAO14KPKeriDOsd0PGwLU7dLBmWMN3/dkmqIbHGGnVE6AHj09PXgiEnJe66eVqmDUVRAZkvVm5kEWTWALtnKY/d5rQ/FWrDB7JvcAmmoUDgR0zfWGpP3ZjmnfkmJlGYsGrcZzxuRRELpQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1784099849; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=u2YKVYzdSC3G4ynRy9U2RFWBCwXFcNnv2ANL4LA7d9I=; 
	b=Lg34d4KSe4Y5ASF49klkezs8f1f/cvn1Z4uaA6yMVnhGDZCzvdERyfkvyGycnE/dBcT/7B42NQt9HSo0W4YUgkF9DsCAV5iw8e6K/17wSSYQhivdnHWqkyGQTHIjAnlZWGKR3+70PbLQRPiW6j7WRxLDtVshrbU0CYCB7bDmerM=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=auditcode.ai;
	spf=pass  smtp.mailfrom=security@auditcode.ai;
	dmarc=pass header.from=<security@auditcode.ai>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784099849;
	s=zmail; d=auditcode.ai; i=security@auditcode.ai;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=u2YKVYzdSC3G4ynRy9U2RFWBCwXFcNnv2ANL4LA7d9I=;
	b=P9BJy97bmfYRZyI3T1i07wHTihh8aw7+ddZW0tkYjWLJYU21osIlwXESMJnrL1uS
	9THPEBV2K84xWTrAUebWzW+7V2mRnzSjopcaQbQCJhcyBR9Huj8fgS5u7vaXHcbGm7n
	AGIjp/W8TdXant4h4OYN0Z99QschipVR9LV7AVKc=
Received: by mx.zoho.eu with SMTPS id 1784099847825869.3146106438666;
	Wed, 15 Jul 2026 09:17:27 +0200 (CEST)
From: Ibrahim Hashimov <security@auditcode.ai>
To: cem@kernel.org,
	djwong@kernel.org,
	linux-xfs@vger.kernel.org
Cc: bfoster@redhat.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v5] xfs: bounds-check buffer log item's dirty bitmap
Date: Wed, 15 Jul 2026 09:17:23 +0200
Message-ID: <20260715071723.81917-1-security@auditcode.ai>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260714175532.74257-1-security@auditcode.ai>
References: <20260714175532.74257-1-security@auditcode.ai>
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
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
v5: add the "/* write dirty buffer */" comment Darrick and Brian asked
    for above the error reset; no functional change. Carry their
    Reviewed-by tags.
v4: fold xlog_recover_do_dquot_buffer()'s bool return and error
    out-parameter into a single int return (1 if dirty, 0 if clean, or a
    negative errno on failure), per Darrick's review.
v3: trim the changelog per Brian Foster's review. Add a Fixes: tag --
    the destination-bounds check has been an ASSERT since the initial git
    import (2.6.12-rc2), so it predates the git era.
v2: resend; v1 went out with an empty Subject line due to a local
    git send-email glitch (leading blank line in the patch file).

 fs/xfs/xfs_buf_item_recover.c | 57 +++++++++++++++++++++++++++++--------------
 1 file changed, 41 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 02b95b89d1b5..240deb3f7827 100644
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
@@ -489,8 +489,24 @@ xlog_recover_do_reg_buffer(
 		ASSERT(nbits > 0);
 		ASSERT(item->ri_buf[i].iov_base != NULL);
 		ASSERT(item->ri_buf[i].iov_len % XFS_BLF_CHUNK == 0);
-		ASSERT(BBTOB(bp->b_length) >=
-		       ((uint)bit << XFS_BLF_SHIFT) + (nbits << XFS_BLF_SHIFT));
+		/*
+		 * The bitmap is only trustworthy to the extent that it
+		 * describes a region that actually fits inside the buffer we
+		 * read in based on the (attacker-controlled) blf_len.  Do not
+		 * rely on an ASSERT() for this -- it compiles away entirely on
+		 * non-DEBUG kernels, which is exactly where this matters, so
+		 * validate it for real and abort recovery of this buffer rather
+		 * than copying past the end of it.
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
@@ -544,6 +560,7 @@ xlog_recover_do_reg_buffer(
 	ASSERT(i == item->ri_total);
 
 	xlog_recover_validate_buf_type(mp, bp, buf_f, current_lsn);
+	return 0;
 }
 
 /*
@@ -552,10 +569,10 @@ xlog_recover_do_reg_buffer(
  * (ie. USR or GRP), then just toss this buffer away; don't recover it.
  * Else, treat it as a regular buffer and do recovery.
  *
- * Return false if the buffer was tossed and true if we recovered the buffer to
- * indicate to the caller if the buffer needs writing.
+ * Return 0 if the buffer was not recovered (tossed), 1 if it was recovered and
+ * needs writing, or a negative errno if recovery of the buffer failed.
  */
-STATIC bool
+STATIC int
 xlog_recover_do_dquot_buffer(
 	struct xfs_mount		*mp,
 	struct xlog			*log,
@@ -564,6 +581,7 @@ xlog_recover_do_dquot_buffer(
 	struct xfs_buf_log_format	*buf_f)
 {
 	uint			type;
+	int			error;
 
 	trace_xfs_log_recover_buf_dquot_buf(log, buf_f);
 
@@ -571,7 +589,7 @@ xlog_recover_do_dquot_buffer(
 	 * Filesystems are required to send in quota flags at mount time.
 	 */
 	if (!mp->m_qflags)
-		return false;
+		return 0;
 
 	type = 0;
 	if (buf_f->blf_flags & XFS_BLF_UDQUOT_BUF)
@@ -584,10 +602,12 @@ xlog_recover_do_dquot_buffer(
 	 * This type of quotas was turned off, so ignore this buffer
 	 */
 	if (log->l_quotaoffs_flag & type)
-		return false;
+		return 0;
 
-	xlog_recover_do_reg_buffer(mp, item, bp, buf_f, NULLCOMMITLSN);
-	return true;
+	error = xlog_recover_do_reg_buffer(mp, item, bp, buf_f, NULLCOMMITLSN);
+	if (error)
+		return error;
+	return 1;
 }
 
 /*
@@ -724,7 +744,9 @@ xlog_recover_do_primary_sb_buffer(
 	xfs_rgnumber_t			orig_rgcount = mp->m_sb.sb_rgcount;
 	int				error;
 
-	xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
+	error = xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
+	if (error)
+		return error;
 
 	if (orig_agcount == 0) {
 		xfs_alert(mp, "Trying to grow file system without AGs");
@@ -1081,11 +1103,11 @@ xlog_recover_buf_commit_pass2(
 			goto out_release;
 	} else if (buf_f->blf_flags &
 		  (XFS_BLF_UDQUOT_BUF|XFS_BLF_PDQUOT_BUF|XFS_BLF_GDQUOT_BUF)) {
-		bool	dirty;
-
-		dirty = xlog_recover_do_dquot_buffer(mp, log, item, bp, buf_f);
-		if (!dirty)
+		error = xlog_recover_do_dquot_buffer(mp, log, item, bp, buf_f);
+		if (error <= 0)
 			goto out_release;
+		/* write dirty buffer */
+		error = 0;
 	} else if ((xfs_blft_from_flags(buf_f) & XFS_BLFT_SB_BUF) &&
 			xfs_buf_daddr(bp) == 0) {
 		error = xlog_recover_do_primary_sb_buffer(mp, item, bp, buf_f,
@@ -1105,7 +1127,10 @@ xlog_recover_buf_commit_pass2(
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
