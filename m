Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616095A0FB
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 22:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710802043; cv=none; b=JT8aiK4kDXZw1KcUfGwqtk3UvoFn5r7FV16JFXjMFNoUwtv7v1b3WxQRb5wCPtUi+hzwRu5OkjfZBql+YIRqe5ZNtc62tp3UxOFQWMKwR5ycnH1A8Ep1RhccdzKalbVtVQu4P9ObS39lV4qcjzK9n50bvNP6qBzEVzxtyXS7bw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710802043; c=relaxed/simple;
	bh=iQHJ3R1VRQl6P1iSPrb5ihz3huFQ08mRpf60HLd6tfc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I0DV/eDHkHIBr6nHqi1EAV3c1NbLqP6zCxXzSKKVq9UuZFGg2QKsfDhVDMR+AGSnq7y1PXUmdFVsLgIoNlUiE+Mnbbly0uyDpLO8yyzp4+42g1o43U6uZLUl4ZqRFFwiF7ZmqE7xFT5fAukYNELCsXlvWw+j0qf70f47sligYKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=I/X8ZBRo; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="I/X8ZBRo"
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3c396fec63aso18067b6e.0
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 15:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710802040; x=1711406840; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h5JVHHFRtp3gXxIEzQNyoJCJxo5de6rum96dhqTSxwM=;
        b=I/X8ZBRoEc1XnC4BwgLz5xldr5PrXbvUoAZSBWgwiQr5BqtHFi3zqHEcgHgAZYx0qi
         vwKPfFA2SnZeE8qV0gQbwJHx9wdjFCbfduMs1P3W3H0SKAPzOyJxRcn3UrfSTYI/TM0R
         7pnHDCZjOhp/TRnmz+28bbA7VijMEuqS0aXJdj7Meo3a8GQpwOXt7NPO3pd+x1VzFQ87
         8hks9Vfj9POGsHTvH6DHAjoVZmjy89ixSyIng/0WafF5mNRO+4+0zSwIDVSjgIyRPCMW
         22U0pfGx+0dPgo28PnJH/BOxPtxqoDcrTy8DpI9tXx8pco91xmwyUSrCM5WnDk7ptqgP
         T6uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710802040; x=1711406840;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h5JVHHFRtp3gXxIEzQNyoJCJxo5de6rum96dhqTSxwM=;
        b=AzTQWbdHb8/rg+CK/KGTcNq03C0yu0d4LWr758AymOnt7MndBxhQGiEXk0VVpv5AIw
         J4DJxu9L8W0SO5gtPQoYJnb3s/ef0zf7cEB6g/7WSYshcvs5Jap0Aqs+dgoMNZT/S3wZ
         taNP42KK3Lipuy1dp5Hp8KGPXob/LlTAVymBFRGPu4jl/3l2yRhTLVLKBTfdV9HtsWNz
         TZ5l7VdOTqMDWoiFEzSunrAhSnP6afdmEELwMPImcjFA44DY1sGHReG43GhRNc9/Vlmg
         7tGq17HDWD+giQTDHoIRXCXTFGKxjfWbexBE6uM69mIduozAvNtOLGbXC1JQm5UqpleM
         VMCQ==
X-Gm-Message-State: AOJu0YyD1v35/8xaVneiq86qOIRea5mcD9KPel0KW55APPs9PnP2pxoY
	f9HPtndS4THdDWDkafALnN+S/3Tc1GIKdZjXRlFiC4IQKVGIpp8UhsHVe5MUe1RZUjg/gmdqHt4
	7
X-Google-Smtp-Source: AGHT+IED9YjR2jKt3TDOA4OnJlagiU5T0lV9p5E9sr0EPAiIYcKMBbvlhqSvKcwUZ/0/hjEDsDw4yQ==
X-Received: by 2002:a05:6808:6485:b0:3c3:74f9:4578 with SMTP id fh5-20020a056808648500b003c374f94578mr14630173oib.16.1710802040245;
        Mon, 18 Mar 2024 15:47:20 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-185-123.pa.nsw.optusnet.com.au. [49.180.185.123])
        by smtp.gmail.com with ESMTPSA id gu25-20020a056a004e5900b006e7040519a1sm5030643pfb.216.2024.03.18.15.47.19
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 15:47:19 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rmLlG-003o0S-00
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 09:47:17 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rmLlF-0000000E82y-28oU
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 09:47:17 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 5/9] xfs: buffer items don't straddle pages anymore
Date: Tue, 19 Mar 2024 09:45:56 +1100
Message-ID: <20240318224715.3367463-6-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Unmapped buffers don't exist anymore, so the page straddling
detection and slow path code can go away now.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf_item.c | 124 ------------------------------------------
 1 file changed, 124 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 7b66d3fe4ecd..cbc06605d31c 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -56,31 +56,6 @@ xfs_buf_log_format_size(
 			(blfp->blf_map_size * sizeof(blfp->blf_data_map[0]));
 }
 
-/*
- * We only have to worry about discontiguous buffer range straddling on unmapped
- * buffers. Everything else will have a contiguous data region we can copy from.
- */
-static inline bool
-xfs_buf_item_straddle(
-	struct xfs_buf		*bp,
-	uint			offset,
-	int			first_bit,
-	int			nbits)
-{
-	void			*first, *last;
-
-	if (bp->b_folio_count == 1)
-		return false;
-
-	first = xfs_buf_offset(bp, offset + (first_bit << XFS_BLF_SHIFT));
-	last = xfs_buf_offset(bp,
-			offset + ((first_bit + nbits) << XFS_BLF_SHIFT));
-
-	if (last - first != nbits * XFS_BLF_CHUNK)
-		return true;
-	return false;
-}
-
 /*
  * Return the number of log iovecs and space needed to log the given buf log
  * item segment.
@@ -97,11 +72,8 @@ xfs_buf_item_size_segment(
 	int				*nvecs,
 	int				*nbytes)
 {
-	struct xfs_buf			*bp = bip->bli_buf;
 	int				first_bit;
 	int				nbits;
-	int				next_bit;
-	int				last_bit;
 
 	first_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size, 0);
 	if (first_bit == -1)
@@ -114,15 +86,6 @@ xfs_buf_item_size_segment(
 		nbits = xfs_contig_bits(blfp->blf_data_map,
 					blfp->blf_map_size, first_bit);
 		ASSERT(nbits > 0);
-
-		/*
-		 * Straddling a page is rare because we don't log contiguous
-		 * chunks of unmapped buffers anywhere.
-		 */
-		if (nbits > 1 &&
-		    xfs_buf_item_straddle(bp, offset, first_bit, nbits))
-			goto slow_scan;
-
 		(*nvecs)++;
 		*nbytes += nbits * XFS_BLF_CHUNK;
 
@@ -137,43 +100,6 @@ xfs_buf_item_size_segment(
 	} while (first_bit != -1);
 
 	return;
-
-slow_scan:
-	ASSERT(bp->b_addr == NULL);
-	last_bit = first_bit;
-	nbits = 1;
-	while (last_bit != -1) {
-
-		*nbytes += XFS_BLF_CHUNK;
-
-		/*
-		 * This takes the bit number to start looking from and
-		 * returns the next set bit from there.  It returns -1
-		 * if there are no more bits set or the start bit is
-		 * beyond the end of the bitmap.
-		 */
-		next_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size,
-					last_bit + 1);
-		/*
-		 * If we run out of bits, leave the loop,
-		 * else if we find a new set of bits bump the number of vecs,
-		 * else keep scanning the current set of bits.
-		 */
-		if (next_bit == -1) {
-			if (first_bit != last_bit)
-				(*nvecs)++;
-			break;
-		} else if (next_bit != last_bit + 1 ||
-		           xfs_buf_item_straddle(bp, offset, first_bit, nbits)) {
-			last_bit = next_bit;
-			first_bit = next_bit;
-			(*nvecs)++;
-			nbits = 1;
-		} else {
-			last_bit++;
-			nbits++;
-		}
-	}
 }
 
 /*
@@ -286,8 +212,6 @@ xfs_buf_item_format_segment(
 	struct xfs_buf		*bp = bip->bli_buf;
 	uint			base_size;
 	int			first_bit;
-	int			last_bit;
-	int			next_bit;
 	uint			nbits;
 
 	/* copy the flags across from the base format item */
@@ -332,15 +256,6 @@ xfs_buf_item_format_segment(
 		nbits = xfs_contig_bits(blfp->blf_data_map,
 					blfp->blf_map_size, first_bit);
 		ASSERT(nbits > 0);
-
-		/*
-		 * Straddling a page is rare because we don't log contiguous
-		 * chunks of unmapped buffers anywhere.
-		 */
-		if (nbits > 1 &&
-		    xfs_buf_item_straddle(bp, offset, first_bit, nbits))
-			goto slow_scan;
-
 		xfs_buf_item_copy_iovec(lv, vecp, bp, offset,
 					first_bit, nbits);
 		blfp->blf_size++;
@@ -356,45 +271,6 @@ xfs_buf_item_format_segment(
 	} while (first_bit != -1);
 
 	return;
-
-slow_scan:
-	ASSERT(bp->b_addr == NULL);
-	last_bit = first_bit;
-	nbits = 1;
-	for (;;) {
-		/*
-		 * This takes the bit number to start looking from and
-		 * returns the next set bit from there.  It returns -1
-		 * if there are no more bits set or the start bit is
-		 * beyond the end of the bitmap.
-		 */
-		next_bit = xfs_next_bit(blfp->blf_data_map, blfp->blf_map_size,
-					(uint)last_bit + 1);
-		/*
-		 * If we run out of bits fill in the last iovec and get out of
-		 * the loop.  Else if we start a new set of bits then fill in
-		 * the iovec for the series we were looking at and start
-		 * counting the bits in the new one.  Else we're still in the
-		 * same set of bits so just keep counting and scanning.
-		 */
-		if (next_bit == -1) {
-			xfs_buf_item_copy_iovec(lv, vecp, bp, offset,
-						first_bit, nbits);
-			blfp->blf_size++;
-			break;
-		} else if (next_bit != last_bit + 1 ||
-		           xfs_buf_item_straddle(bp, offset, first_bit, nbits)) {
-			xfs_buf_item_copy_iovec(lv, vecp, bp, offset,
-						first_bit, nbits);
-			blfp->blf_size++;
-			first_bit = next_bit;
-			last_bit = next_bit;
-			nbits = 1;
-		} else {
-			last_bit++;
-			nbits++;
-		}
-	}
 }
 
 /*
-- 
2.43.0

