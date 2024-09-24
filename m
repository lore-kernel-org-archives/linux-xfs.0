Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFBA1AC898;
	Tue, 24 Sep 2024 18:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727203155; cv=none; b=lFRdpBA1CXx0p+AaeUu3R9K4oKvbaQknl8tHHDNJ32JM0LZfRiOjAOew0wvx2nDL2eLmpDxSmFemtdI/IK23KIohQchbFR2E+8YtJ4BvwyEtGpSWQ4WV2C1OaK9hLhRg67h8ZpyffuLHyXmGlCRJH/LNF5DGNkMgC9uoKBj7kCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727203155; c=relaxed/simple;
	bh=QrHQCREmjZbjtLXYa0nt5gXNnVYAhJpANMGTgB1TQIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FI4yldzJf+kjHd2kEiVlvyC/AIphcwE1zWgGcuadM9b4LQri/lp3GJaPXbBgQMLkpN2yvZPriNCq4/X2XOfbBLDtnHXnkTGOSaaJRoOWaGzSwKP5Z2Jx5eeFUFwHtInR/E/FZtF717tQrnite/9rjzlIa4ED4Ca+GvcyK4c6R6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d5/uPWKT; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d5/uPWKT"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-20573eb852aso1030965ad.1;
        Tue, 24 Sep 2024 11:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727203153; x=1727807953; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mmbUGPdREXaFhRVGUVBBozF+DuSG+yeczOURWI6+Go8=;
        b=d5/uPWKTslrkcf2Z9ei0CDrBwKKFpoxtn0vmnuJ9HS7cRM9gslYW8+V32tWU0F2Vms
         zo9FTTTzpoTumTiCNLzJbcZMkFkRLZTTr+mKn0jdppoU3Mt37UK5QuVJnBPwTuBoBKnr
         XSTtz1lnTp2aUBq7jFs4LtGk0BxyDHAUO/j/P/6miRoFKlMxw4PgwCcT4O6HeB9fIEB4
         PtNlX5Doo9mV6YNKHTrA3MKemNJYFOJSowtV4vI0k9TzC4NQkg/+J1qkd5j5Rl5Z7RXg
         BtR0eqFvp/TlFg0+eHN357os0NY8b03sTdDRLqwTbfgNyHtpOuJJH7qLG3em5pdI3Cud
         lwYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727203153; x=1727807953;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mmbUGPdREXaFhRVGUVBBozF+DuSG+yeczOURWI6+Go8=;
        b=RuV3IhuCsQnT8magAGzuAb0WsKcD+90YiXqqGbQUi9UroVYQE/q3ZehD/uYs1aUr25
         snJHIcSjjnYCd+jODNUEX0/BdF/6EboYsthUpsnX9Bv5HLmM4vSptsuAuew89DQsaiwY
         csxrVCxr+9j+eK8/A2nwkhPF6H5YZGB8jWGqlLQ0qsftkoxy7foCtI1z8yGMdO/zUkbF
         txm/aK/WG0C8DF93/4NUwwJ6/oNdXjjTZ7jtrvvNom5tv3RsD+8JeFIxoVcvNc8/TKIA
         S4/3tTmNWwuHW2H31cMK3q4EeqdGvKlOX09yJL99K/d0NWcGZB1BJ0udELu38GSvnQuJ
         45aA==
X-Gm-Message-State: AOJu0YyDqSinCxypXIMUY0HXTNha4Ht/ULTICKiCmikpIBxz7dnKCIwE
	NuxAby3qnZwTAUGef0EPJJgn7AIKcAvHzIB+DmPJq10e2oNPaibMHsvp1R1+
X-Google-Smtp-Source: AGHT+IEl1/DTPPVlxVTsOCFi6B+sm6cl7VFHAejl2xqd1IIlK9aGBgQuEcko+4LdO9FYl6Bx8yCJ6g==
X-Received: by 2002:a17:90a:d18b:b0:2c9:7343:71f1 with SMTP id 98e67ed59e1d1-2e06ac390c5mr218008a91.14.1727203152647;
        Tue, 24 Sep 2024 11:39:12 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:3987:6b77:4621:58ca])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ef93b2fsm11644349a91.49.2024.09.24.11.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 11:39:12 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	cem@kernel.org,
	catherine.hoang@oracle.com,
	Dave Chinner <dchinner@redhat.com>,
	yangerkun <yangerkun@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Dave Chinner <david@fromorbit.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 11/26] xfs: buffer pins need to hold a buffer reference
Date: Tue, 24 Sep 2024 11:38:36 -0700
Message-ID: <20240924183851.1901667-12-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
In-Reply-To: <20240924183851.1901667-1-leah.rumancik@gmail.com>
References: <20240924183851.1901667-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 89a4bf0dc3857569a77061d3d5ea2ac85f7e13c6 ]

When a buffer is unpinned by xfs_buf_item_unpin(), we need to access
the buffer after we've dropped the buffer log item reference count.
This opens a window where we can have two racing unpins for the
buffer item (e.g. shutdown checkpoint context callback processing
racing with journal IO iclog completion processing) and both attempt
to access the buffer after dropping the BLI reference count.  If we
are unlucky, the "BLI freed" context wins the race and frees the
buffer before the "BLI still active" case checks the buffer pin
count.

This results in a use after free that can only be triggered
in active filesystem shutdown situations.

To fix this, we need to ensure that buffer existence extends beyond
the BLI reference count checks and until the unpin processing is
complete. This implies that a buffer pin operation must also take a
buffer reference to ensure that the buffer cannot be freed until the
buffer unpin processing is complete.

Reported-by: yangerkun <yangerkun@huawei.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
---
 fs/xfs/xfs_buf_item.c | 88 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 65 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index df7322ed73fa..023d4e0385dd 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -452,10 +452,18 @@ xfs_buf_item_format(
  * This is called to pin the buffer associated with the buf log item in memory
  * so it cannot be written out.
  *
- * We also always take a reference to the buffer log item here so that the bli
- * is held while the item is pinned in memory. This means that we can
- * unconditionally drop the reference count a transaction holds when the
- * transaction is completed.
+ * We take a reference to the buffer log item here so that the BLI life cycle
+ * extends at least until the buffer is unpinned via xfs_buf_item_unpin() and
+ * inserted into the AIL.
+ *
+ * We also need to take a reference to the buffer itself as the BLI unpin
+ * processing requires accessing the buffer after the BLI has dropped the final
+ * BLI reference. See xfs_buf_item_unpin() for an explanation.
+ * If unpins race to drop the final BLI reference and only the
+ * BLI owns a reference to the buffer, then the loser of the race can have the
+ * buffer fgreed from under it (e.g. on shutdown). Taking a buffer reference per
+ * pin count ensures the life cycle of the buffer extends for as
+ * long as we hold the buffer pin reference in xfs_buf_item_unpin().
  */
 STATIC void
 xfs_buf_item_pin(
@@ -470,13 +478,30 @@ xfs_buf_item_pin(
 
 	trace_xfs_buf_item_pin(bip);
 
+	xfs_buf_hold(bip->bli_buf);
 	atomic_inc(&bip->bli_refcount);
 	atomic_inc(&bip->bli_buf->b_pin_count);
 }
 
 /*
- * This is called to unpin the buffer associated with the buf log item which
- * was previously pinned with a call to xfs_buf_item_pin().
+ * This is called to unpin the buffer associated with the buf log item which was
+ * previously pinned with a call to xfs_buf_item_pin().  We enter this function
+ * with a buffer pin count, a buffer reference and a BLI reference.
+ *
+ * We must drop the BLI reference before we unpin the buffer because the AIL
+ * doesn't acquire a BLI reference whenever it accesses it. Therefore if the
+ * refcount drops to zero, the bli could still be AIL resident and the buffer
+ * submitted for I/O at any point before we return. This can result in IO
+ * completion freeing the buffer while we are still trying to access it here.
+ * This race condition can also occur in shutdown situations where we abort and
+ * unpin buffers from contexts other that journal IO completion.
+ *
+ * Hence we have to hold a buffer reference per pin count to ensure that the
+ * buffer cannot be freed until we have finished processing the unpin operation.
+ * The reference is taken in xfs_buf_item_pin(), and we must hold it until we
+ * are done processing the buffer state. In the case of an abort (remove =
+ * true) then we re-use the current pin reference as the IO reference we hand
+ * off to IO failure handling.
  */
 STATIC void
 xfs_buf_item_unpin(
@@ -493,24 +518,18 @@ xfs_buf_item_unpin(
 
 	trace_xfs_buf_item_unpin(bip);
 
-	/*
-	 * Drop the bli ref associated with the pin and grab the hold required
-	 * for the I/O simulation failure in the abort case. We have to do this
-	 * before the pin count drops because the AIL doesn't acquire a bli
-	 * reference. Therefore if the refcount drops to zero, the bli could
-	 * still be AIL resident and the buffer submitted for I/O (and freed on
-	 * completion) at any point before we return. This can be removed once
-	 * the AIL properly holds a reference on the bli.
-	 */
 	freed = atomic_dec_and_test(&bip->bli_refcount);
-	if (freed && !stale && remove)
-		xfs_buf_hold(bp);
 	if (atomic_dec_and_test(&bp->b_pin_count))
 		wake_up_all(&bp->b_waiters);
 
-	 /* nothing to do but drop the pin count if the bli is active */
-	if (!freed)
+	/*
+	 * Nothing to do but drop the buffer pin reference if the BLI is
+	 * still active.
+	 */
+	if (!freed) {
+		xfs_buf_rele(bp);
 		return;
+	}
 
 	if (stale) {
 		ASSERT(bip->bli_flags & XFS_BLI_STALE);
@@ -522,6 +541,15 @@ xfs_buf_item_unpin(
 
 		trace_xfs_buf_item_unpin_stale(bip);
 
+		/*
+		 * The buffer has been locked and referenced since it was marked
+		 * stale so we own both lock and reference exclusively here. We
+		 * do not need the pin reference any more, so drop it now so
+		 * that we only have one reference to drop once item completion
+		 * processing is complete.
+		 */
+		xfs_buf_rele(bp);
+
 		/*
 		 * If we get called here because of an IO error, we may or may
 		 * not have the item on the AIL. xfs_trans_ail_delete() will
@@ -538,16 +566,30 @@ xfs_buf_item_unpin(
 			ASSERT(bp->b_log_item == NULL);
 		}
 		xfs_buf_relse(bp);
-	} else if (remove) {
+		return;
+	}
+
+	if (remove) {
 		/*
-		 * The buffer must be locked and held by the caller to simulate
-		 * an async I/O failure. We acquired the hold for this case
-		 * before the buffer was unpinned.
+		 * We need to simulate an async IO failures here to ensure that
+		 * the correct error completion is run on this buffer. This
+		 * requires a reference to the buffer and for the buffer to be
+		 * locked. We can safely pass ownership of the pin reference to
+		 * the IO to ensure that nothing can free the buffer while we
+		 * wait for the lock and then run the IO failure completion.
 		 */
 		xfs_buf_lock(bp);
 		bp->b_flags |= XBF_ASYNC;
 		xfs_buf_ioend_fail(bp);
+		return;
 	}
+
+	/*
+	 * BLI has no more active references - it will be moved to the AIL to
+	 * manage the remaining BLI/buffer life cycle. There is nothing left for
+	 * us to do here so drop the pin reference to the buffer.
+	 */
+	xfs_buf_rele(bp);
 }
 
 STATIC uint
-- 
2.46.0.792.g87dc391469-goog

