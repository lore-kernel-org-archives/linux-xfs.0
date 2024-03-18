Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0BFE5A4FF
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 22:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710802044; cv=none; b=Gj5CUT654qWJ9FZf3fn0Sa/sRT32n9JrrwCdQ6veJV7e0qp95ZisTaAVBZYDpezLV+iCO79S1Te1Hg9wCCYa1HJaQTINO+zHU1wgVbuM4C7+Mvd8cqpFylkbcC45a4QiuyAq5jb4Y0EwldQicolFf2uD224dKLAuAuUmWcZ6iAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710802044; c=relaxed/simple;
	bh=KN/Bekd5u8kmVYWQj6HoyUbqcjubE34QZTtgTLDzCH8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SoNNNedIIljdQgMYITeMAiqPPVruo55vj4JWtutbw/0OaCsPLK4RvfzGggCQEE76BXUXDAOa/cfJFiMhweAiBRWznxJ9KgPqLUWkGQCBMi2r19gyWNZt6B0YXr0z2+QgjOSP95skVEKjX8ARsLkMNmuLdJd/Rpb7OwjoEKDN+pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=IUuXa1hN; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="IUuXa1hN"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1def59b537cso21867295ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 15:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710802041; x=1711406841; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ymVBZWX72zOa9zV5H9Y6kFP3Mz8BBFTTAkZU4R1MIwM=;
        b=IUuXa1hNwbtaE5+D+mU9sHLt/OgYtRDQAOdF60AbTpMewIsVtCv+HmRGaKHohx0sIH
         5L4T4LOc9Plcw4gYdZvYT4Yqhu7VDcbGlmIUxaPOcymuQFGQqR0qrFSlJdLJh41SO4bS
         6uCU5/SlF9gZOQGqtfwTvKktB+IAwLozJYEAOY29JZVlYVT94aRKO2+gvrhQ4u0tnK7U
         OIL6ITJg0dN0sZCc0+AOGAjfqvwAEnWON2g1k/1Lz5IbhtXCBvbhoTt5WpIyThNFa17H
         1XhxyxauNirQO8j775UtL9MQV8WKTWbKG+pTvPMCAgM11GP51OacEQlG/0LzDwsnOCzT
         nSoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710802041; x=1711406841;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ymVBZWX72zOa9zV5H9Y6kFP3Mz8BBFTTAkZU4R1MIwM=;
        b=ZYo0jHIJWUwVBfJ6Mi8GICcnLLEjQbewKtYNcmrexPSi9hq7+BZd8lUtvgP0Nqqx2w
         pJmcSnkSgKqbdfjd+GtomeZa5y/XZc/3/o7hoDC5nGPbJWV0kkgJTqSuUGCDXyBtoyLl
         DxmfFBMkZvbq/Q+yaZpILGmRQuvXVQLrxPaEZveDiZEBD/7/hdVrrSTbSkzOD9DzoDOK
         zpkiiAwbWG2s9FcR05i9O7s+X/dgP6WQRJpowuZcV9X99EGD1omPh9eB7MKELcTpLksa
         de/HPS0P9GYqtQSApGOLn3meOpqd6g8OPs4f53ZofC9j/92XpQRppbzUBSHeyLqu/rXn
         X1XQ==
X-Gm-Message-State: AOJu0Yxa7HTJLgc+fgHrQgYsYD2H1U8RV65Qtd5y4JtrNYpHkVWqiUke
	onB5GTMfnqC91VNI3MwS/JCxFmGcb0l3Dq3KUXV4AyBReOYWiLZea8vXFOybM5YdSk13tbV4CrC
	D
X-Google-Smtp-Source: AGHT+IF9cvaQBWYkA38Qs/H2y2WdTwdoinpxX3b0BB8NAD9p5ueddmWIdxbHygKXSCcslubATapm7g==
X-Received: by 2002:a17:903:1c4:b0:1dd:e159:3e32 with SMTP id e4-20020a17090301c400b001dde1593e32mr14301409plh.57.1710802041068;
        Mon, 18 Mar 2024 15:47:21 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-185-123.pa.nsw.optusnet.com.au. [49.180.185.123])
        by smtp.gmail.com with ESMTPSA id h5-20020a170902680500b001d8f111804asm10033169plk.113.2024.03.18.15.47.19
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 15:47:20 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rmLlG-003o0b-0D
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 09:47:17 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rmLlF-0000000E836-2Jqq
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 09:47:17 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 6/9] xfs: map buffers in xfs_buf_alloc_folios
Date: Tue, 19 Mar 2024 09:45:57 +1100
Message-ID: <20240318224715.3367463-7-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240318224715.3367463-1-david@fromorbit.com>
References: <20240318224715.3367463-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

With the concept of unmapped buffer gone, there is no reason to not
vmap the buffer pages directly in xfs_buf_alloc_folios.

[dchinner: port to folio-enabled buffers.]

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c | 37 ++++++-------------------------------
 1 file changed, 6 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 2cd3671f3ce3..a77e2d8c8107 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -469,18 +469,7 @@ xfs_buf_alloc_folios(
 		XFS_STATS_INC(bp->b_mount, xb_page_retries);
 		memalloc_retry_wait(gfp_mask);
 	}
-	return 0;
-}
 
-/*
- *	Map buffer into kernel address-space if necessary.
- */
-STATIC int
-_xfs_buf_map_folios(
-	struct xfs_buf		*bp,
-	xfs_buf_flags_t		flags)
-{
-	ASSERT(bp->b_flags & _XBF_FOLIOS);
 	if (bp->b_folio_count == 1) {
 		/* A single folio buffer is always mappable */
 		bp->b_addr = folio_address(bp->b_folios[0]);
@@ -513,8 +502,13 @@ _xfs_buf_map_folios(
 		} while (retried++ <= 1);
 		memalloc_nofs_restore(nofs_flag);
 
-		if (!bp->b_addr)
+		if (!bp->b_addr) {
+			xfs_warn_ratelimited(bp->b_mount,
+				"%s: failed to map %u folios", __func__,
+				bp->b_folio_count);
+			xfs_buf_free_folios(bp);
 			return -ENOMEM;
+		}
 	}
 
 	return 0;
@@ -816,18 +810,6 @@ xfs_buf_get_map(
 			xfs_perag_put(pag);
 	}
 
-	/* We do not hold a perag reference anymore. */
-	if (!bp->b_addr) {
-		error = _xfs_buf_map_folios(bp, flags);
-		if (unlikely(error)) {
-			xfs_warn_ratelimited(btp->bt_mount,
-				"%s: failed to map %u folios", __func__,
-				bp->b_folio_count);
-			xfs_buf_relse(bp);
-			return error;
-		}
-	}
-
 	/*
 	 * Clear b_error if this is a lookup from a caller that doesn't expect
 	 * valid data to be found in the buffer.
@@ -1068,13 +1050,6 @@ xfs_buf_get_uncached(
 	if (error)
 		goto fail_free_buf;
 
-	error = _xfs_buf_map_folios(bp, 0);
-	if (unlikely(error)) {
-		xfs_warn(target->bt_mount,
-			"%s: failed to map folios", __func__);
-		goto fail_free_buf;
-	}
-
 	trace_xfs_buf_get_uncached(bp, _RET_IP_);
 	*bpp = bp;
 	return 0;
-- 
2.43.0

