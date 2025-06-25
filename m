Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA04B201017
	for <linux-xfs@vger.kernel.org>; Wed, 25 Jun 2025 22:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750891806; cv=none; b=sVCEoFhtBpvC/oYnCYkhJBlIWw79oAfOt6RRg/L7ZyFage1MF2xhpms0upM89YgpGrwJNhdvwpqvEbWHd2dh0J2zwrNJUfs4WmvHLoZsapyQ/Uq6z3lm/Ur4lvKGm8wxvEwhZXFAKaRKd3q5rb/MuHitYAF9dQqb9xick9h20Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750891806; c=relaxed/simple;
	bh=Gk7tSen17OHiwDocR2vAdXlqTtw2ONsWUlmMpiCZIgs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlMLq4X7a4CcVPPYD2J050byUpxsSWtjOqrgM7G8ULIKWStgV7/FbXhAIt/98K+99k2BsYUfOaAm5uX1zUB4qSMzvFXdbe0NZiZSHHqZHfeB0lS41dLCTSIo3Lm1iqaiSoATcq/WBkb4xd8cJTdeaaS6dNvsk8nAtThc4PScT4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=0q/AFmJO; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="0q/AFmJO"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-747fba9f962so436798b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jun 2025 15:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1750891804; x=1751496604; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zRhgioFqLv6Z9fX37+gS6b1o70qZ6l7W8w0Yn5L4Z5U=;
        b=0q/AFmJO4Yy30jmm6EEnftySeoa1iVi92uVRhlmmjsb4d/BOAaRs3+Sk0UT9doGlkd
         2N4OjhkUeWL8PMdOptlzKlgNXeHQAfsXTooE2OoLM7fEEXE9NP3N4qkO/QmJYbdFMvp3
         ukuJz2BH5/6QUWFTpR29CJXtZJW1PvY3e8nvC3Lc1A3Oy0WRVd7sny0nf/T+XGoFD5fA
         VyOSulbZINwemzokyPT2YNR8doJLp1cGOgVEc/59OFcGpmALKYF/sqwTy81qP8hELZMV
         TrqAtL3esKju8OK9Ix3GI34nT5KfApcB4LtJSbfOZlvRDKPszwimPc6Ze9cf10Q4PcoX
         iojg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750891804; x=1751496604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zRhgioFqLv6Z9fX37+gS6b1o70qZ6l7W8w0Yn5L4Z5U=;
        b=PWvCSEniG4jz0FbtugWojJTCAvNz1l/k3O4iLAJk/M0rwywY1h/hok1nCwptbnls1d
         dzisidONJc+SeceTwhxi6IM+yMgDZiYoZc3AeQ4cvLtHNd961j/xhZ6pS6QiJTCguRk9
         +lnqQHUUoRgRu2JaVMpJ9E//bMYDPRv3hODnQnD1kfToih5O+7xW3nbNSdT1vIN6h7jr
         64rm3ubuhDEiEKBp7SbssK2NlWUwvzy8vZKQj0einG7ex0+bbFnPVi1FPdCUeIjLF7UB
         YL/dkAuhr8sK/g6BgxED+DHgefylbJSIQSoqSa6d2Z8FT2YqUvoz/rrb4z1zEsK6vlZU
         R3jA==
X-Gm-Message-State: AOJu0Yx0E9vLaOQtgAy+St/9sdTMnrboypeN7B69kKy6eRmuDk3XfosY
	Hd3AJJ92nIgjGNFlfJ8fm2+VBH3dsHgMYYDFp91YfXJRCPk6yepfepxg9eqC8hMu3nskjGOiYN5
	n4qR9
X-Gm-Gg: ASbGncu6GMi8oJYBPcEO1Kc1hAxJ36MNtC7CFKo1dBM03bfWyR+XF0AmBPaFQtGfbve
	/mW4F4ZUoQw4UcmU5Axe3BxwCW83S0WxGaIcdPDU+rA1qJZTy+eswn0fUHnHfEAyxUB0ihSQACD
	iT75HQWogCu/Fk41kVTJIe0+QTx8HKMFyBNh1v5CiIC2DIbiLElB7PjCiIFcsHOBMTHbIJSwVk+
	wH1wIWcdabBJWTTMm01XSEIq8qKnxO14I8YO0pf9FJ6WAPSz5Lmpn6jUwJCT9n32p8wx35OFsg8
	Jcu85vjlLgI5yCnTxfoARgGrqFv6psPI8e/maDDj9yLbZMtBtPZ5rQ8ZlPfEjbMnG4+50lsw42h
	ikoAih6sKptDIKQNHc7YWAYxqHkz8Zfzm6/9u
X-Google-Smtp-Source: AGHT+IGMNXByJ2Iqrn+NTKGuULhx6rYK66uEOybH15Gw17u4XvGehBIbV8qjWkZ76A3cyrBKvd5McA==
X-Received: by 2002:a05:6a00:8c8a:b0:742:aed4:3e1 with SMTP id d2e1a72fcca58-74ae3e79e9emr1298881b3a.2.1750891803865;
        Wed, 25 Jun 2025 15:50:03 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-749c8859b2esm5433042b3a.136.2025.06.25.15.50.02
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 15:50:02 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.98.2)
	(envelope-from <dave@fromorbit.com>)
	id 1uUYwK-00000003FOL-14gs
	for linux-xfs@vger.kernel.org;
	Thu, 26 Jun 2025 08:50:00 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.98)
	(envelope-from <dave@devoid.disaster.area>)
	id 1uUYwK-000000061ed-0UTp
	for linux-xfs@vger.kernel.org;
	Thu, 26 Jun 2025 08:50:00 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6/7] xfs: factor out stale buffer item completion
Date: Thu, 26 Jun 2025 08:48:59 +1000
Message-ID: <20250625224957.1436116-7-david@fromorbit.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250625224957.1436116-1-david@fromorbit.com>
References: <20250625224957.1436116-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

The stale buffer item completion handling is currently only done
from BLI unpinning. We need to perform this function from where-ever
the last reference to the BLI is dropped, so first we need to
factor this code out into a helper.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf_item.c | 60 ++++++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 3e3c0f65a25c..c95826863c82 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -444,6 +444,42 @@ xfs_buf_item_pin(
 	atomic_inc(&bip->bli_buf->b_pin_count);
 }
 
+/*
+ * For a stale BLI, process all the necessary completions that must be
+ * performed when the final BLI reference goes away. The buffer will be
+ * referenced and locked here - we return to the caller with the buffer still
+ * referenced and locked for them to finalise processing of the buffer.
+ */
+static void
+xfs_buf_item_finish_stale(
+	struct xfs_buf_log_item	*bip)
+{
+	struct xfs_buf		*bp = bip->bli_buf;
+	struct xfs_log_item	*lip = &bip->bli_item;
+
+	ASSERT(bip->bli_flags & XFS_BLI_STALE);
+	ASSERT(xfs_buf_islocked(bp));
+	ASSERT(bp->b_flags & XBF_STALE);
+	ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
+	ASSERT(list_empty(&lip->li_trans));
+	ASSERT(!bp->b_transp);
+
+	if (bip->bli_flags & XFS_BLI_STALE_INODE) {
+		xfs_buf_item_done(bp);
+		xfs_buf_inode_iodone(bp);
+		ASSERT(list_empty(&bp->b_li_list));
+		return;
+	}
+
+	/*
+	 * We may or may not be on the AIL here, xfs_trans_ail_delete() will do
+	 * the right thing regardless of the situation in which we are called.
+	 */
+	xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
+	xfs_buf_item_relse(bip);
+	ASSERT(bp->b_log_item == NULL);
+}
+
 /*
  * This is called to unpin the buffer associated with the buf log item which was
  * previously pinned with a call to xfs_buf_item_pin().  We enter this function
@@ -493,13 +529,6 @@ xfs_buf_item_unpin(
 	}
 
 	if (stale) {
-		ASSERT(bip->bli_flags & XFS_BLI_STALE);
-		ASSERT(xfs_buf_islocked(bp));
-		ASSERT(bp->b_flags & XBF_STALE);
-		ASSERT(bip->__bli_format.blf_flags & XFS_BLF_CANCEL);
-		ASSERT(list_empty(&lip->li_trans));
-		ASSERT(!bp->b_transp);
-
 		trace_xfs_buf_item_unpin_stale(bip);
 
 		/*
@@ -510,22 +539,7 @@ xfs_buf_item_unpin(
 		 * processing is complete.
 		 */
 		xfs_buf_rele(bp);
-
-		/*
-		 * If we get called here because of an IO error, we may or may
-		 * not have the item on the AIL. xfs_trans_ail_delete() will
-		 * take care of that situation. xfs_trans_ail_delete() drops
-		 * the AIL lock.
-		 */
-		if (bip->bli_flags & XFS_BLI_STALE_INODE) {
-			xfs_buf_item_done(bp);
-			xfs_buf_inode_iodone(bp);
-			ASSERT(list_empty(&bp->b_li_list));
-		} else {
-			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
-			xfs_buf_item_relse(bip);
-			ASSERT(bp->b_log_item == NULL);
-		}
+		xfs_buf_item_finish_stale(bip);
 		xfs_buf_relse(bp);
 		return;
 	}
-- 
2.45.2

