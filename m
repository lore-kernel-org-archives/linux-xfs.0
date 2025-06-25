Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11D726E6E1
	for <linux-xfs@vger.kernel.org>; Wed, 25 Jun 2025 22:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750891805; cv=none; b=VsrNTHRYTbe0QxEHKeV0o9OfwE+KKYsVi3z1nP1y5AIflGufTZVwhJBMYf09dXYqmUPrUHJH6ty/wmA4k/dcZ2EDvLmEtJzH2oTdsIqMlhrWFQqBYTGjFTsQzYwXs4wSqHJNbrXW41DYKL0YGz4489uIxbLMI75OcXTWNICTekU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750891805; c=relaxed/simple;
	bh=6bCjEgWU7v3p0baQfA4G5iQvrp8jXJfBz6Ruz5pWy44=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u2lbv5MGMQDUd1eytlEvndIXLu3z/g8Gkn3MWe1ocklowt+knfR8PQqQxZLs8C+k32qqx1aUHe5/66eaTj0ut/QjRav43CNJnGzmW9/4ooKYyEPYaRutir9eCvdpCBAr5TsDbwdeXI2KOYMeA9UlBXtG8lc5sCKOpkb2DYabRw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=0+fAZkt+; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="0+fAZkt+"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-23649faf69fso4032755ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jun 2025 15:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1750891803; x=1751496603; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9aBTu7spJ63itDWX69McuCpg+t+NVxbwSWKdRLJc9hM=;
        b=0+fAZkt+muo5Qaet85kIpNZ9fsP1aRwDp6NhCvfszUs/9+ll8fjAFBX5mUA0XVME+C
         KiXqSMvvPmPz/xsM5snzjE2n5pUUqxpr8DS7auWoFIjWyyadQMG3fD8qX802K6nDh55f
         fCoRF94d2E/MZojMW/x48xFVJtkDHEIM+YcQ/G2AcB85bcDiatjRI/w34Cici6sZnZbM
         EbHanWGWttYnSXhlCO7DYh/WNCAEK/8397vT7rsFQUFOIuTN+dobvNYGfUt9VQODxnWf
         ijmMrjnWfxQTVDzTa0wpMlPaauDzlWNYzVY4/k7ZPWNhAyTCnIjS+k/bLdmu4kLRTPYc
         TQvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750891803; x=1751496603;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9aBTu7spJ63itDWX69McuCpg+t+NVxbwSWKdRLJc9hM=;
        b=v2fvhy04BEp9OuEsXYxeVyf3ukY1bbZUZ6Y+0Zbe7ExrhO+gdp+mUNnoU7ot3oIZ1W
         1NQYBxyrpx9yfPoBZc7aa6JW5wL2y7UGX9IuB/34Pvzs4mDPL2JE1RB0oIJ+yTzWcD8b
         wFjXccOsskSkJ5LBP7P63hS/b//wztppJ2NgMcv4CeNlX7arIHN7nDnKFhfLyWGAK9AJ
         Gq4vGD/UgSLWKWpAEvljzalOWEzxi8g6nDmJyNMpgfRuhAZ/q3AoDwdkiWODwK1Lhrkv
         1V0ryGltVZm6K/foQrAxHYoUBK9JJYAouDohjyutGT6Aadoue0bFDHw/xqOzhjEcevTm
         mcOA==
X-Gm-Message-State: AOJu0YztDU5ool92LCEIVTOh5N57fg35lwTPIZMIuBmS9mSjbrHz4ML2
	E1a4Hd+zD3UBT1s0wRCdwydXKQmGVQ9z6F9z+a+/mAD6yL/8S/SX6Zo5fuxQFWl/VCjA0jclWdy
	VrkH6
X-Gm-Gg: ASbGncuRjKqESqLlDt57gxyzshJuA+krmlGLHzNhnzFZeG+tIH8RC7pUvCiTilPR4pl
	KT/OBDq90h5na82uiXAlyNL7Ui24ziFTaB2wVtaJ2+Pat5FQWjn49tWpy+dvXg2vDROQuLD97Ik
	D7If9IgmXyBWPb310tCfJWTTO3bJbzatLA2aHeuR4QeI3ya54lBAxoLWbSevQh4lN2VfEHVjdzv
	qQPzdAR4hbGs6+vdKAdYsCvolWcnfM27Ct1C5ejmebkOIxkEzK5TFiK9D13ZYayhEW1Qql6LXMV
	P5Ynx7oZrd2Z3+KZNNsqCUIzTDgXk479hjPogp/qTkDJRSKfqFGoY8EhJUxQicL+F76wTeLXHtq
	RByrc9nmGw7hDbqe44TQqXbkPKAwLY1MA+cMT
X-Google-Smtp-Source: AGHT+IGxwkAjvhfeHHJDtP2gqT61p/HkdPH6wt/UCl8ltYt8CGlkCuZOm4SXpwa+HH/Qosyx5Rb7LQ==
X-Received: by 2002:a17:902:cec2:b0:235:779:edfa with SMTP id d9443c01a7336-23824044853mr76109265ad.32.1750891802814;
        Wed, 25 Jun 2025 15:50:02 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-184-88.pa.nsw.optusnet.com.au. [49.180.184.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d83ce31asm140286255ad.63.2025.06.25.15.50.02
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 15:50:02 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.98.2)
	(envelope-from <dave@fromorbit.com>)
	id 1uUYwK-00000003FOI-0uUt
	for linux-xfs@vger.kernel.org;
	Thu, 26 Jun 2025 08:50:00 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.98)
	(envelope-from <dave@devoid.disaster.area>)
	id 1uUYwK-000000061eW-0Kjp
	for linux-xfs@vger.kernel.org;
	Thu, 26 Jun 2025 08:50:00 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 5/7] xfs: rearrange code in xfs_buf_item.c
Date: Thu, 26 Jun 2025 08:48:58 +1000
Message-ID: <20250625224957.1436116-6-david@fromorbit.com>
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

The code to initialise, release and free items is all the way down
the bottom of the file. Upcoming fixes need to these functions
earlier in the file, so move them to the top.

There is one code change in this move - the parameter to
xfs_buf_item_relse() is changed from the xfs_buf to the
xfs_buf_log_item - the thing that the function is releasing.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf_item.c | 116 +++++++++++++++++++++---------------------
 fs/xfs/xfs_buf_item.h |   1 -
 2 files changed, 58 insertions(+), 59 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 90139e0f3271..3e3c0f65a25c 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -32,6 +32,61 @@ static inline struct xfs_buf_log_item *BUF_ITEM(struct xfs_log_item *lip)
 	return container_of(lip, struct xfs_buf_log_item, bli_item);
 }
 
+static void
+xfs_buf_item_get_format(
+	struct xfs_buf_log_item	*bip,
+	int			count)
+{
+	ASSERT(bip->bli_formats == NULL);
+	bip->bli_format_count = count;
+
+	if (count == 1) {
+		bip->bli_formats = &bip->__bli_format;
+		return;
+	}
+
+	bip->bli_formats = kzalloc(count * sizeof(struct xfs_buf_log_format),
+				GFP_KERNEL | __GFP_NOFAIL);
+}
+
+static void
+xfs_buf_item_free_format(
+	struct xfs_buf_log_item	*bip)
+{
+	if (bip->bli_formats != &bip->__bli_format) {
+		kfree(bip->bli_formats);
+		bip->bli_formats = NULL;
+	}
+}
+
+static void
+xfs_buf_item_free(
+	struct xfs_buf_log_item	*bip)
+{
+	xfs_buf_item_free_format(bip);
+	kvfree(bip->bli_item.li_lv_shadow);
+	kmem_cache_free(xfs_buf_item_cache, bip);
+}
+
+/*
+ * xfs_buf_item_relse() is called when the buf log item is no longer needed.
+ */
+static void
+xfs_buf_item_relse(
+	struct xfs_buf_log_item	*bip)
+{
+	struct xfs_buf		*bp = bip->bli_buf;
+
+	trace_xfs_buf_item_relse(bp, _RET_IP_);
+
+	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
+	ASSERT(atomic_read(&bip->bli_refcount) == 0);
+
+	bp->b_log_item = NULL;
+	xfs_buf_rele(bp);
+	xfs_buf_item_free(bip);
+}
+
 /* Is this log iovec plausibly large enough to contain the buffer log format? */
 bool
 xfs_buf_log_check_iovec(
@@ -468,7 +523,7 @@ xfs_buf_item_unpin(
 			ASSERT(list_empty(&bp->b_li_list));
 		} else {
 			xfs_trans_ail_delete(lip, SHUTDOWN_LOG_IO_ERROR);
-			xfs_buf_item_relse(bp);
+			xfs_buf_item_relse(bip);
 			ASSERT(bp->b_log_item == NULL);
 		}
 		xfs_buf_relse(bp);
@@ -578,7 +633,7 @@ xfs_buf_item_put(
 	 */
 	if (aborted)
 		xfs_trans_ail_delete(lip, 0);
-	xfs_buf_item_relse(bip->bli_buf);
+	xfs_buf_item_relse(bip);
 	return true;
 }
 
@@ -729,33 +784,6 @@ static const struct xfs_item_ops xfs_buf_item_ops = {
 	.iop_push	= xfs_buf_item_push,
 };
 
-STATIC void
-xfs_buf_item_get_format(
-	struct xfs_buf_log_item	*bip,
-	int			count)
-{
-	ASSERT(bip->bli_formats == NULL);
-	bip->bli_format_count = count;
-
-	if (count == 1) {
-		bip->bli_formats = &bip->__bli_format;
-		return;
-	}
-
-	bip->bli_formats = kzalloc(count * sizeof(struct xfs_buf_log_format),
-				GFP_KERNEL | __GFP_NOFAIL);
-}
-
-STATIC void
-xfs_buf_item_free_format(
-	struct xfs_buf_log_item	*bip)
-{
-	if (bip->bli_formats != &bip->__bli_format) {
-		kfree(bip->bli_formats);
-		bip->bli_formats = NULL;
-	}
-}
-
 /*
  * Allocate a new buf log item to go with the given buffer.
  * Set the buffer's b_log_item field to point to the new
@@ -976,34 +1004,6 @@ xfs_buf_item_dirty_format(
 	return false;
 }
 
-STATIC void
-xfs_buf_item_free(
-	struct xfs_buf_log_item	*bip)
-{
-	xfs_buf_item_free_format(bip);
-	kvfree(bip->bli_item.li_lv_shadow);
-	kmem_cache_free(xfs_buf_item_cache, bip);
-}
-
-/*
- * xfs_buf_item_relse() is called when the buf log item is no longer needed.
- */
-void
-xfs_buf_item_relse(
-	struct xfs_buf	*bp)
-{
-	struct xfs_buf_log_item	*bip = bp->b_log_item;
-
-	trace_xfs_buf_item_relse(bp, _RET_IP_);
-	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
-
-	if (atomic_read(&bip->bli_refcount))
-		return;
-	bp->b_log_item = NULL;
-	xfs_buf_rele(bp);
-	xfs_buf_item_free(bip);
-}
-
 void
 xfs_buf_item_done(
 	struct xfs_buf		*bp)
@@ -1023,5 +1023,5 @@ xfs_buf_item_done(
 	xfs_trans_ail_delete(&bp->b_log_item->bli_item,
 			     (bp->b_flags & _XBF_LOGRECOVERY) ? 0 :
 			     SHUTDOWN_CORRUPT_INCORE);
-	xfs_buf_item_relse(bp);
+	xfs_buf_item_relse(bp->b_log_item);
 }
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index e10e324cd245..50dd79b59cf5 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -49,7 +49,6 @@ struct xfs_buf_log_item {
 
 int	xfs_buf_item_init(struct xfs_buf *, struct xfs_mount *);
 void	xfs_buf_item_done(struct xfs_buf *bp);
-void	xfs_buf_item_relse(struct xfs_buf *);
 bool	xfs_buf_item_put(struct xfs_buf_log_item *);
 void	xfs_buf_item_log(struct xfs_buf_log_item *, uint, uint);
 bool	xfs_buf_item_dirty_format(struct xfs_buf_log_item *);
-- 
2.45.2

