Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0285A7A9
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 22:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710802044; cv=none; b=tBx84wASX/aAxNEyrbDyvZ9Omu3esVbjtrCAKHZ9dNrhRgCrgbjY+DWcny9zhucEx06TUNOL/xMNA39ZQOsgUXiMcZdwuUnZo1fLUm84Ss9YWr8qmtLqXeu8BSXC3mQ0viLj1KUag0Ody46fIRG2d0uoAUVYG/qOoYbq6OeACMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710802044; c=relaxed/simple;
	bh=ivvYKwhvHfsgdVhD2jKQGrQXEs9uhk9K748xkEBjHiU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7PhIHsdy8+n0vtrWFp+Mujv6CCoJ/uOVDQADJ9Fi2TIP1B41etlNHxYSuCLMEes1ZnjSIgrdrWipEAylCLtPBOB6JcSVAclUuE3Rt1tXk9ujDw/YyEhYpootGN+NFXPmfjpYEns4QxOTp/dmdaGa5B3UpJhjCB73D3hlgfLGDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=sLohElm/; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="sLohElm/"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-29dedcd244dso3132024a91.0
        for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 15:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1710802042; x=1711406842; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tbpLeIymtM/H68l7O1dM/Qsm7MqheGRY9dkLUEa1FGM=;
        b=sLohElm/gZEQl96J+tA/hTFItHbO2NRixyCoJ3lqfwg3i4a/Kxxx7Kj/7sX/dyxlJp
         tJ2SdK133PMZZoDCVRgoKNNXJfgztYZkVbnSHqKDCYje3Sb6HzX8uvvUiss1RerPCPzV
         uNd+PMD6vh4cspV5jz1OVKFCnMnIILzjvYwPavsnJxlzJ1lZire4GgWSzfMIvGEziPXN
         Jl7uxTLRn6u/wlt/vM0x/+vge0GYXT6SDxqvJxj64M8cHyrGWF3ICClwAGwmLSA8/47L
         n7xg5qqjTn24Q96o3e7azilvCysI0kQYlyTdHOeyt+MO3189yOBlWNe/6rg85kG/Rv9P
         PjuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710802042; x=1711406842;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tbpLeIymtM/H68l7O1dM/Qsm7MqheGRY9dkLUEa1FGM=;
        b=c2bzycITvF073GGLrFfq1uNUqFIAe60GfInhGKRAF2gHNEWPp0R9cY+tLGzWem6glx
         UyzbglR1gI9WiRdsZAnF++eBIAOEDUm+obTW6s5a7Jf6eTxfJp74ND7OuePqrUhsMBX7
         RBYgzg2PS5J1PG9QIVzwy+sXUKmcHh5m/8Lat+Ki3dOUAojt+Lo5rE2eLA2pRo83MeFW
         xY1g8lNBmmOuolM5qStvd3LVb5TrRMugkabtsX+RGu2ovx/BcDQpNFwKgW0MQQy7hx0w
         87dDWWB05WI8MZr7U7Sv3h5MmqjcKBISyZSrEKlfwoPXeJwVkvbbRldrfIIXFbxM09ay
         Mlyw==
X-Gm-Message-State: AOJu0YzLVb+sE19Kj9lfKr48S6LBsFK4ynqRETgRv8HNMtK+T2Q1Y/zK
	IK+E7CklxX40G5sNDwPwaVmYOXINEhWWlq+OObpxfPO9YtxSv/7acISmyoJCQNwnMbsnvD3pZub
	0
X-Google-Smtp-Source: AGHT+IHBFCpU5agzYjIaGrOzeSKrj1Zu0REYcVsyCo1UYh9j3Od+IRo9pjG+JmDxeMftHSd/jLFVVw==
X-Received: by 2002:a17:90a:69a2:b0:29c:1eb6:7347 with SMTP id s31-20020a17090a69a200b0029c1eb67347mr9953932pjj.6.1710802041825;
        Mon, 18 Mar 2024 15:47:21 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-185-123.pa.nsw.optusnet.com.au. [49.180.185.123])
        by smtp.gmail.com with ESMTPSA id cv21-20020a17090afd1500b0029b59bf77b4sm8314850pjb.42.2024.03.18.15.47.19
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 15:47:20 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rmLlF-003o0F-2l
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 09:47:17 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rmLlF-0000000E82i-1a0a
	for linux-xfs@vger.kernel.org;
	Tue, 19 Mar 2024 09:47:17 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Subject: [PATCH 1/9] xfs: unmapped buffer item size straddling mismatch
Date: Tue, 19 Mar 2024 09:45:52 +1100
Message-ID: <20240318224715.3367463-2-david@fromorbit.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

