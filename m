Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A30E3218B
	for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2024 22:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705616543; cv=none; b=o/9yRekDGKpC5aOBT7aT5RnMSKwkXu04Brt5aaWjLAejNrmdBAun1p/lZgArH+DiHQTlvV4KW5BRM0n8kC3Cw/CDqLGGau9Z7+KZNvwLmuumWYzKxZ9HU5GaFQaW4WCn0Uq893The9tn2BBMfjlghgynsb+T76op67hRdWI7hqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705616543; c=relaxed/simple;
	bh=onnpTbRDByCIZ1/6zmnBOrJi9ZP31m7f7TGpM+XXNFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dMIHbpQ+BWpMnkFFZLm4x9OeqMhYVZlgkUfgTKMcP/ugqWEDwrUTM61By7dZL15OCxy8E0vCAan+yNViMJi6zoelv1P2/fz2F8as3PS9ZgtKrcjLdoL+hOmQaAWn7spNeKX/0dah6Fbc9C3dVP1LtyUjKXywKybjA+lRdqnRGgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=D9KWcC7k; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="D9KWcC7k"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1d45f182fa2so822685ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 18 Jan 2024 14:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1705616541; x=1706221341; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SIYg4fbOx5xpSV7xBsoY4WQ6ng+5chM3y1Ni3HkVJSg=;
        b=D9KWcC7kt164VbbZzWIZhYzF+r0+5vIdevppK6FkxczIJDzPvDycbuPPozaK6z9Dsc
         Em5+7uZ3h77lrEJwbWyhT6y8YQ2zelaosHHT1qFjU/BFD2nHC+Ch0SsXKL8TN3N2xBVb
         T78HizJhQEnQhvBi5SySBSy+FxASf84zPCXtnZyMXhsGBPKLXMgd5xN/X5xwfNSxI9gp
         RxoDMy70eADtrvYXaJm/z//3MssrAF1pcc1E2dTz/FMZiDJQIgMddV7oHV8/uHUUV3r5
         vKF/pxV4EvpMEYSMiKTxkaa3QH/Po2Eq+Dq1yXgdWASJwCVezXoe/5ofjVPYcDa3Q6W3
         vsqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705616541; x=1706221341;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SIYg4fbOx5xpSV7xBsoY4WQ6ng+5chM3y1Ni3HkVJSg=;
        b=QjJbZx0bARdMgbSulrmU8ikGR4jURAvSBl8nN0NrwSmvu8UV7xeRijeiA/sHy5TprB
         FpKbHJHj0GPzZH7fJxTz0eVtHwTZSf+I737A3W5Mfbrcel+LELka+5tsrwREHWFOFxkt
         JpyHDUeGUucizRP9evYYiDlOe4YGzkWcoUW3psGNWyl47p6fqlipSulqNdwXPx7hXRQ9
         fN69AOxBz4bpiFwiTUMxy2N3EoY5PcXNX9x7/ZZ0rpKYeaVsO47p3Xwp340II/bUhBDT
         OeowE/76gP1ql/Lzv7kxmqFG39tG/oyc6n7Tm3gSO0Ud9hH4B/6vMK9YhfhR1Srig4o8
         6iwA==
X-Gm-Message-State: AOJu0Yx5zgygjg4WU4NRKg7QFSTGq7byI/FWDQIr61lvC1/iC0OgCPNs
	KGeglfhsfJJsHNSJMQf4JNx4N/O3/IzObpesG5YlBT4LAKOLZiCbbFzYm80YS10aeMIT3vYMEpP
	t
X-Google-Smtp-Source: AGHT+IFvJI+inGv4x/2Vzu4CfgzR5ivHLaCvAfCWUVCseYlv9qmktZULfGpdbMDYc55IPbpJDykUzw==
X-Received: by 2002:a17:902:ee8a:b0:1d5:7220:9ff with SMTP id a10-20020a170902ee8a00b001d5722009ffmr1594374pld.117.1705616541575;
        Thu, 18 Jan 2024 14:22:21 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id p12-20020a170902eacc00b001d71729ec9csm531276pld.188.2024.01.18.14.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jan 2024 14:22:21 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rQamB-00CCGN-0h;
	Fri, 19 Jan 2024 09:22:18 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rQamA-0000000HMlm-2z8S;
	Fri, 19 Jan 2024 09:22:18 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: willy@infradead.org,
	linux-mm@kvack.org
Subject: [PATCH 1/3] xfs: unmapped buffer item size straddling mismatch
Date: Fri, 19 Jan 2024 09:19:39 +1100
Message-ID: <20240118222216.4131379-2-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118222216.4131379-1-david@fromorbit.com>
References: <20240118222216.4131379-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

We never log large contiguous regions of unmapped buffers, so this
bug is never triggered by the current code. However, the slowpath
for formatting buffer straddling regions is broken.

That is, the size and shape of the log vector calculated across a
straddle does not match how the formatting code formats a straddle.
This results in a log vector with an uninitialised iovec and this
causes a crash when xlog_write_full() goes to copy the iovec into
the journal.

Whilst touching this code, don't bother checking mapped or single
folio buffers for discontiguous regions because they don't have
them. This significantly reduces the overhead of this check when
logging large buffers as calling xfs_buf_offset() is not free and
it occurs a *lot* in those cases.

Fixes: 929f8b0deb83 ("xfs: optimise xfs_buf_item_size/format for contiguous regions")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf_item.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 43031842341a..83a81cb52d8e 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -56,6 +56,10 @@ xfs_buf_log_format_size(
 			(blfp->blf_map_size * sizeof(blfp->blf_data_map[0]));
 }
 
+/*
+ * We only have to worry about discontiguous buffer range straddling on unmapped
+ * buffers. Everything else will have a contiguous data region we can copy from.
+ */
 static inline bool
 xfs_buf_item_straddle(
 	struct xfs_buf		*bp,
@@ -65,6 +69,9 @@ xfs_buf_item_straddle(
 {
 	void			*first, *last;
 
+	if (bp->b_page_count == 1 || !(bp->b_flags & XBF_UNMAPPED))
+		return false;
+
 	first = xfs_buf_offset(bp, offset + (first_bit << XFS_BLF_SHIFT));
 	last = xfs_buf_offset(bp,
 			offset + ((first_bit + nbits) << XFS_BLF_SHIFT));
@@ -132,11 +139,13 @@ xfs_buf_item_size_segment(
 	return;
 
 slow_scan:
-	/* Count the first bit we jumped out of the above loop from */
-	(*nvecs)++;
-	*nbytes += XFS_BLF_CHUNK;
+	ASSERT(bp->b_addr == NULL);
 	last_bit = first_bit;
+	nbits = 1;
 	while (last_bit != -1) {
+
+		*nbytes += XFS_BLF_CHUNK;
+
 		/*
 		 * This takes the bit number to start looking from and
 		 * returns the next set bit from there.  It returns -1
@@ -151,6 +160,8 @@ xfs_buf_item_size_segment(
 		 * else keep scanning the current set of bits.
 		 */
 		if (next_bit == -1) {
+			if (first_bit != last_bit)
+				(*nvecs)++;
 			break;
 		} else if (next_bit != last_bit + 1 ||
 		           xfs_buf_item_straddle(bp, offset, first_bit, nbits)) {
@@ -162,7 +173,6 @@ xfs_buf_item_size_segment(
 			last_bit++;
 			nbits++;
 		}
-		*nbytes += XFS_BLF_CHUNK;
 	}
 }
 
-- 
2.43.0

