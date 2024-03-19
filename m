Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FA564CF6
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 02:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710814554; cv=none; b=l6FzMdvfcoI8mN3r3x2eDVSbu0CfDS5uK9Q2mFJ6jciUx/gR4fMLOMxjGXDbRYkQCu8IUdL46WTMBajGYBsj0othyEo1XnoI12ebCCYg3seK0AqAW92JAiDN18hIxsWisOsRtIDOKpJWzYZ7hgfvrwsC4x5dS7Vb5ZzFlWX4NL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710814554; c=relaxed/simple;
	bh=Nx/1w8ObFqqexTihF34y/dCZY/gdnBH/rFnsQvBobvY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1iGDsdRymXcZ4G5tXZwnTLBKG4CIR4JJMhEorTCnCvnOV6ToX2mdZVGzkKmpn94PWjPqN4r5ebucRRkczGpcaKnf7Qk83FTUXC1oo6PP7bEsKDGaTmAowFcINy1ox5G7aio5INbbl0fmeIAlvkwjsYBI7pA0CagGC7VWsM+5Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Z+WFinUj; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Z+WFinUj"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1e0411c0a52so3285945ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 19:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710814552; x=1711419352; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WdmyU1Vh7bOJWtCVaI/P1X5Fp9P2636vEYJ7XiBclcA=;
        b=Z+WFinUj6oZ4oWE9ycAQWz6VJweojiAcmua2GbqSSjwvPh8L8GXeSPfloFWftU/0eR
         0tQWlqagOm6/BKmJiLbXA20XZ6mFds+5hhaDth+7Eo0oo1T6NOAuWN94uRw6d8QZ2UZh
         Tmnw+haskbMhth0vX/pUlZUGuuukuhaPSjg7IEti9DUoFyerx8q0nTzDs5Ii6aYKoxOz
         VgOqaYZ6EhVpuIQrK/ae3LS52leGGozAkR0WI3p0yZlvEJUNApUQaheBKk1ZeCEK+lyT
         boBH7a6Gp/lIdzw88p91zvM3JysuLgSUyb0/1I4RgWr/lwIXVp6TdGkolufN3Q5n992v
         aGgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710814552; x=1711419352;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WdmyU1Vh7bOJWtCVaI/P1X5Fp9P2636vEYJ7XiBclcA=;
        b=Xz7tLAJedAoX4RUB1GsuaPZ8ZapesOyeGDuefWQj0VjvgrWSuEb08RN4U67FyDktM0
         htxDp7PlumfFv/SBclP1OpYzNqEDy+SrpNe8Wi74WaRmIHKSnWw712uz1e7MYqhyxLD4
         vYPyP+sgq2RhddHKNA6/VFZoFstlgerzlDyJjf5+sylP12+LfyWMzsEmUbC9Z6e/vY2o
         TYUbKXNkONz3lb6x4yByTGoVuD9qzrTd277WIeRvE29WjTSE7PWX9maj5brKZzVpwNnb
         zOg/g6FkG2hW+OYPTE9zbC88kmNIcFDuymu87Do2Kgw1CycoN199PBhBrZl2DkWphZZS
         TDyQ==
X-Gm-Message-State: AOJu0YzyqBRFfD0ljE8Xz/EowLDi/tMiJFhCO93kQxPDCpW/E+hWLOgO
	b1++NT1j1XGDCao6vZs69g14oYQz4ufTVWglQAgiHLMWant+ktDxEIwuSaAQ4ZlFKwtxxD5TkvK
	1
X-Google-Smtp-Source: AGHT+IFjAf3NyWA4vZOt/G4fOT+F4JmkJIBOqsxdChiO2gULMfOrAp//WAY3IcsqpnF+/GhFdtc6qA==
X-Received: by 2002:a17:903:1249:b0:1dc:db57:d6e2 with SMTP id u9-20020a170903124900b001dcdb57d6e2mr1691721plh.69.1710814552280;
        Mon, 18 Mar 2024 19:15:52 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-185-123.pa.nsw.optusnet.com.au. [49.180.185.123])
        by smtp.gmail.com with ESMTPSA id m5-20020a170902db8500b001dd5b86d809sm9985813pld.279.2024.03.18.19.15.51
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 19:15:51 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rmP13-003s51-20
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 13:15:49 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rmP13-0000000Ec6n-0VKs
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 13:15:49 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 2/5] xfs: separate out inode buffer recovery a bit more
Date: Tue, 19 Mar 2024 13:15:21 +1100
Message-ID: <20240319021547.3483050-3-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240319021547.3483050-1-david@fromorbit.com>
References: <20240319021547.3483050-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

It really is a unique snowflake, so peal off from normal buffer
recovery earlier and shuffle all the unique bits into the inode
buffer recovery function.

Also, it looks like the handling of mismatched inode cluster buffer
sizes is wrong - we have to write the recovered buffer -before- we
mark it stale as we're not supposed to write stale buffers. I don't
think we check that anywhere in the buffer IO path, but lets do it
the right way anyway.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf_item_recover.c | 99 ++++++++++++++++++++++-------------
 1 file changed, 63 insertions(+), 36 deletions(-)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index dba57ee6fa6d..f994a303ad0a 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -229,7 +229,7 @@ xlog_recover_validate_buf_type(
 	 * just avoid the verification stage for non-crc filesystems
 	 */
 	if (!xfs_has_crc(mp))
-		return;
+		return 0;
 
 	magic32 = be32_to_cpu(*(__be32 *)bp->b_addr);
 	magic16 = be16_to_cpu(*(__be16*)bp->b_addr);
@@ -407,7 +407,7 @@ xlog_recover_validate_buf_type(
 	 * skipped.
 	 */
 	if (current_lsn == NULLCOMMITLSN)
-		return 0;;
+		return 0;
 
 	if (warnmsg) {
 		xfs_warn(mp, warnmsg);
@@ -567,18 +567,22 @@ xlog_recover_this_dquot_buffer(
 }
 
 /*
- * Perform recovery for a buffer full of inodes.  In these buffers, the only
- * data which should be recovered is that which corresponds to the
- * di_next_unlinked pointers in the on disk inode structures.  The rest of the
- * data for the inodes is always logged through the inodes themselves rather
- * than the inode buffer and is recovered in xlog_recover_inode_pass2().
+ * Perform recovery for a buffer full of inodes. We don't have inode cluster
+ * buffer specific LSNs, so we always recover inode buffers if they contain
+ * inodes.
+ *
+ * In these buffers, the only inode data which should be recovered is that which
+ * corresponds to the di_next_unlinked pointers in the on disk inode structures.
+ * The rest of the data for the inodes is always logged through the inodes
+ * themselves rather than the inode buffer and is recovered in
+ * xlog_recover_inode_pass2().
  *
  * The only time when buffers full of inodes are fully recovered is when the
- * buffer is full of newly allocated inodes.  In this case the buffer will
- * not be marked as an inode buffer and so will be sent to
- * xlog_recover_do_reg_buffer() below during recovery.
+ * buffer is full of newly allocated inodes.  In this case the buffer will not
+ * be marked as an inode buffer and so xlog_recover_do_reg_buffer() will be used
+ * instead.
  */
-STATIC int
+static int
 xlog_recover_do_inode_buffer(
 	struct xfs_mount		*mp,
 	struct xlog_recover_item	*item,
@@ -598,6 +602,13 @@ xlog_recover_do_inode_buffer(
 
 	trace_xfs_log_recover_buf_inode_buf(mp->m_log, buf_f);
 
+	/*
+	 * If the magic number doesn't match, something has gone wrong. Don't
+	 * recover the buffer.
+	 */
+	if (cpu_to_be16(XFS_DINODE_MAGIC) != *((__be16 *)bp->b_addr))
+		return -EFSCORRUPTED;
+
 	/*
 	 * Post recovery validation only works properly on CRC enabled
 	 * filesystems.
@@ -677,6 +688,31 @@ xlog_recover_do_inode_buffer(
 
 	}
 
+	/*
+	 * Make sure that only inode buffers with good sizes remain valid after
+	 * recovering this buffer item.
+	 *
+	 * The kernel moves inodes in buffers of 1 block or inode_cluster_size
+	 * bytes, whichever is bigger.  The inode buffers in the log can be a
+	 * different size if the log was generated by an older kernel using
+	 * unclustered inode buffers or a newer kernel running with a different
+	 * inode cluster size.  Regardless, if the inode buffer size isn't
+	 * max(blocksize, inode_cluster_size) for *our* value of
+	 * inode_cluster_size, then we need to keep the buffer out of the buffer
+	 * cache so that the buffer won't overlap with future reads of those
+	 * inodes.
+	 *
+	 * To acheive this, we write the buffer ito recover the inodes then mark
+	 * it stale so that it won't be found on overlapping buffer lookups and
+	 * caller knows not to queue it for delayed write.
+	 */
+	if (BBTOB(bp->b_length) != M_IGEO(mp)->inode_cluster_size) {
+		int error;
+
+		error = xfs_bwrite(bp);
+		xfs_buf_stale(bp);
+		return error;
+	}
 	return 0;
 }
 
@@ -840,7 +876,6 @@ xlog_recover_get_buf_lsn(
 	magic16 = be16_to_cpu(*(__be16 *)blk);
 	switch (magic16) {
 	case XFS_DQUOT_MAGIC:
-	case XFS_DINODE_MAGIC:
 		goto recover_immediately;
 	default:
 		break;
@@ -910,6 +945,17 @@ xlog_recover_buf_commit_pass2(
 	if (error)
 		return error;
 
+	/*
+	 * Inode buffer recovery is quite unique, so go out separate ways here
+	 * to simplify the rest of the code.
+	 */
+	if (buf_f->blf_flags & XFS_BLF_INODE_BUF) {
+		error = xlog_recover_do_inode_buffer(mp, item, bp, buf_f);
+		if (error || (bp->b_flags & XBF_STALE))
+			goto out_release;
+		goto out_write;
+	}
+
 	/*
 	 * Recover the buffer only if we get an LSN from it and it's less than
 	 * the lsn of the transaction we are replaying.
@@ -946,9 +992,7 @@ xlog_recover_buf_commit_pass2(
 		goto out_release;
 	}
 
-	if (buf_f->blf_flags & XFS_BLF_INODE_BUF) {
-		error = xlog_recover_do_inode_buffer(mp, item, bp, buf_f);
-	} else if (buf_f->blf_flags &
+	if (buf_f->blf_flags &
 		  (XFS_BLF_UDQUOT_BUF|XFS_BLF_PDQUOT_BUF|XFS_BLF_GDQUOT_BUF)) {
 		if (!xlog_recover_this_dquot_buffer(mp, log, item, bp, buf_f))
 			goto out_release;
@@ -965,28 +1009,11 @@ xlog_recover_buf_commit_pass2(
 	/*
 	 * Perform delayed write on the buffer.  Asynchronous writes will be
 	 * slower when taking into account all the buffers to be flushed.
-	 *
-	 * Also make sure that only inode buffers with good sizes stay in
-	 * the buffer cache.  The kernel moves inodes in buffers of 1 block
-	 * or inode_cluster_size bytes, whichever is bigger.  The inode
-	 * buffers in the log can be a different size if the log was generated
-	 * by an older kernel using unclustered inode buffers or a newer kernel
-	 * running with a different inode cluster size.  Regardless, if
-	 * the inode buffer size isn't max(blocksize, inode_cluster_size)
-	 * for *our* value of inode_cluster_size, then we need to keep
-	 * the buffer out of the buffer cache so that the buffer won't
-	 * overlap with future reads of those inodes.
 	 */
-	if (XFS_DINODE_MAGIC ==
-	    be16_to_cpu(*((__be16 *)xfs_buf_offset(bp, 0))) &&
-	    (BBTOB(bp->b_length) != M_IGEO(log->l_mp)->inode_cluster_size)) {
-		xfs_buf_stale(bp);
-		error = xfs_bwrite(bp);
-	} else {
-		ASSERT(bp->b_mount == mp);
-		bp->b_flags |= _XBF_LOGRECOVERY;
-		xfs_buf_delwri_queue(bp, buffer_list);
-	}
+out_write:
+	ASSERT(bp->b_mount == mp);
+	bp->b_flags |= _XBF_LOGRECOVERY;
+	xfs_buf_delwri_queue(bp, buffer_list);
 
 out_release:
 	xfs_buf_relse(bp);
-- 
2.43.0

