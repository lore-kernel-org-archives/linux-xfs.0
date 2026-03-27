Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF482ED154
	for <linux-xfs@vger.kernel.org>; Fri, 27 Mar 2026 13:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774618376; cv=none; b=dXPzv1BJu3TnYpSf9CjjQJA7gA4bDBFJlnqwH6dWBjsQxoV6QaUoT8G2nbccmAA/kgiFijrMMU8g3GC8PJ1Uy/imX1NIzanclRcH8PpuIK3gW3mHsipNhVtNl3FAArups0AXW70Irr/Ci//MAIHjrkz/q45VxuVNt/IuPnR9IqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774618376; c=relaxed/simple;
	bh=PNjh+nBtoovM25MVmCPA4ZyoI9w3XN6jgyoE16tARQM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QSzqbzyLgL7JWvZnJelAylTO4RnduWNfflJyVp3npNg9434Es/r7XzH+a+nFb0nFX+zlik2bRTrqLijPrelyAwvTEFlTNgFK9YQjdBXZOeRaKEXl0d7A/JO4QCgS9Ijughkv8MrCQck9ryVwI40vEK4L9mr0moh+4jeCw4wWfSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HVAsYc/h; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HVAsYc/h"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2addb31945aso16971565ad.1
        for <linux-xfs@vger.kernel.org>; Fri, 27 Mar 2026 06:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774618374; x=1775223174; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EONMaUpVytMI8mDTZgVkhsH1HsODfwxhYYTYobffMbc=;
        b=HVAsYc/hEzGlJ8sfhC3A85W9aLu2mel2OEhfeLtDX+VrhsAi+GaB2KyYXVM9eFaXVN
         Jj8CCKRuTI15YZ1aPJaYfflEZKA0AslUbkL1G2T80ctAygOT6Gyog+CYtFbPnjZQ1SVc
         mahvRN4Z7UUd0RRDRhuVnOF/CiWvOs6RFX6iocsYGjIwTqNHFUiZME6fcAkpGZCibkfP
         gZW9cHvn4wfcGVR9UsgOHpPlDw29rq1eOkqS186n/ufIEPiKebVgyBrlc8s0wIW+bqbk
         8LTvoFDUFI+p7XC3aQMj0V8kK9kM6oaGrMf94H9LZcXiaTACi5PYpLf6kDrNGf+riEFN
         z5ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774618374; x=1775223174;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EONMaUpVytMI8mDTZgVkhsH1HsODfwxhYYTYobffMbc=;
        b=fSdGkl+C/Oya78qxyhea/Ip8k4jZ2E8XlHLeQzZ2n87U7Jjgv6JlZsxs5Y+lA+zc5g
         AS0uen0XIY7mvQMfEAIJH/+9OT+w6A/yvr4pVjHBbFYeU8oCVgQV8erDjaOZDlQ7bpAi
         Cj5Gq1HeJ7Yc4/qr60IAO/Z9xK5gxOv/VQnRiuBuvuAr6WML8qO0boS3yW0s8C7NOBxt
         RrY83dhFV/Lai/qAbRKToUFjE8oaWFUHZdfHFrlMjmNCcIhLEPc14Qphki9Iu5EJ3Wni
         EtXIAY0Y6+0DsSo51C9Z482ppxJmXhP+bR5901PUA0NAIn3sA/5tzg1ffP4I/FEFc/Yu
         BkUA==
X-Gm-Message-State: AOJu0YwXlpcUATjzlUEANLFBadsWJraoh7xf7xGvX1p01K7wgF2HVzQr
	BPJF0vcIMRApJkt4L63B3CpRYM+lSzZHz/j5tHmZrJ++rQ4Y8zZLmsB8
X-Gm-Gg: ATEYQzxUI+kphn/+jYkjuxnfhXQlSf1rUp3iWdXtmsa7MKciis7woaOsdeQ27BckGDg
	FZ95qcc1AfFYJTxKXVRnMtd933mJQXfG5Etaf6FAKh9gWDgYEJ436Lb06kYi6ZNs6Ec5aR4kg8D
	A/bRrilCNdAPliIr1Yhz/Grb4mUCDEDuAzbpVJaDW3OrQG5waVNZeCBwUZ293S3usn5xE4ZO48N
	cJsZHHsHxirUO7jH0sEU5BXso+AsPfZT68DyaVGsG63VzPi1vUCV9IGzi37mvlE4Dz8pqh6wGYH
	JDrt6pDHuQA2hD2xnma4oCfvq3fQq6DiaRSzckcU9huR/r+Y4t3fQX8poLpSB7d3AqE5+7/1hMM
	2aWElBRQcp8nxhjn3ky7ZNgX1pNED2bDKbmLyAdOSl+SzpMuWXu6OexVY7surzYTDCLAMcw09S6
	4rxqjqdbHz5MVos8CcNtkegNofOdHX
X-Received: by 2002:a17:903:1ac4:b0:2b2:3eec:c75f with SMTP id d9443c01a7336-2b23eecd14fmr677615ad.28.1774618373775;
        Fri, 27 Mar 2026 06:32:53 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0bc7b8adasm82689115ad.33.2026.03.27.06.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 06:32:53 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	Cen Zhang <zzzccc427@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] xfs: annotate lockless bli_flags access in buf item paths
Date: Fri, 27 Mar 2026 21:14:48 +0800
Message-Id: <20260327131448.156177-1-zzzccc427@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_buf_item_unpin() and xfs_buf_item_committed() read bip->bli_flags
without holding the buffer lock, while xfs_buf_item_release() clears
XFS_BLI_LOGGED, XFS_BLI_HOLD, and XFS_BLI_ORDERED under that lock.
This can happen when an older checkpoint still holds a CIL reference to
the BLI while a new transaction is finishing with the buffer.

The lockless readers only test XFS_BLI_STALE and
XFS_BLI_INODE_ALLOC_BUF, which are disjoint from the bits being
cleared, so correctness is not affected in practice.  However, the
plain C accesses still constitute a data race that may allow the
compiler to optimize them in unexpected ways (e.g., load tearing or
fused reloads), so they should be marked explicitly.

Annotate the two lockless reads with READ_ONCE(), make the clearing
store in xfs_buf_item_release() a WRITE_ONCE(), and use READ_ONCE() in
the buf-item tracepoint that may snapshot bli_flags without the lock.

Fixes: 8e1238508633 ("xfs: remove stale parameter from ->iop_unpin method")
Fixes: 71e330b59390 ("xfs: Introduce delayed logging core code")
Cc: stable@vger.kernel.org
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
 fs/xfs/xfs_buf_item.c | 18 +++++++++++-------
 fs/xfs/xfs_trace.h    |  2 +-
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 8487635579e5..c3d0dc17ee10 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -502,7 +502,8 @@ xfs_buf_item_unpin(
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 	struct xfs_buf		*bp = bip->bli_buf;
-	int			stale = bip->bli_flags & XFS_BLI_STALE;
+	unsigned int		flags = READ_ONCE(bip->bli_flags);
+	int			stale = flags & XFS_BLI_STALE;
 	int			freed;
 
 	ASSERT(bp->b_log_item == bip);
@@ -679,13 +680,14 @@ xfs_buf_item_release(
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
 	struct xfs_buf		*bp = bip->bli_buf;
-	bool			hold = bip->bli_flags & XFS_BLI_HOLD;
-	bool			stale = bip->bli_flags & XFS_BLI_STALE;
+	unsigned int		flags = bip->bli_flags;
+	bool			hold = flags & XFS_BLI_HOLD;
+	bool			stale = flags & XFS_BLI_STALE;
 	bool			aborted = test_bit(XFS_LI_ABORTED,
 						   &lip->li_flags);
-	bool			dirty = bip->bli_flags & XFS_BLI_DIRTY;
+	bool			dirty = flags & XFS_BLI_DIRTY;
 #if defined(DEBUG) || defined(XFS_WARN)
-	bool			ordered = bip->bli_flags & XFS_BLI_ORDERED;
+	bool			ordered = flags & XFS_BLI_ORDERED;
 #endif
 
 	trace_xfs_buf_item_release(bip);
@@ -705,7 +707,8 @@ xfs_buf_item_release(
 	 * per-transaction state from the bli, which has been copied above.
 	 */
 	bp->b_transp = NULL;
-	bip->bli_flags &= ~(XFS_BLI_LOGGED | XFS_BLI_HOLD | XFS_BLI_ORDERED);
+	WRITE_ONCE(bip->bli_flags,
+		   flags & ~(XFS_BLI_LOGGED | XFS_BLI_HOLD | XFS_BLI_ORDERED));
 
 	/* If there are other references, then we have nothing to do. */
 	if (!atomic_dec_and_test(&bip->bli_refcount))
@@ -792,10 +795,11 @@ xfs_buf_item_committed(
 	xfs_lsn_t		lsn)
 {
 	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
+	unsigned int		flags = READ_ONCE(bip->bli_flags);
 
 	trace_xfs_buf_item_committed(bip);
 
-	if ((bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF) && lip->li_lsn != 0)
+	if ((flags & XFS_BLI_INODE_ALLOC_BUF) && lip->li_lsn != 0)
 		return lip->li_lsn;
 	return lsn;
 }
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 813e5a9f57eb..2069534bb0c1 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -895,7 +895,7 @@ DECLARE_EVENT_CLASS(xfs_buf_item_class,
 	),
 	TP_fast_assign(
 		__entry->dev = bip->bli_buf->b_target->bt_dev;
-		__entry->bli_flags = bip->bli_flags;
+		__entry->bli_flags = READ_ONCE(bip->bli_flags);
 		__entry->bli_recur = bip->bli_recur;
 		__entry->bli_refcount = atomic_read(&bip->bli_refcount);
 		__entry->buf_bno = xfs_buf_daddr(bip->bli_buf);
-- 
2.34.1

