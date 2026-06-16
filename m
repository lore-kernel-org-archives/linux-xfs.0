Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561843D4137
	for <linux-xfs@vger.kernel.org>; Tue, 16 Jun 2026 05:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781588357; cv=none; b=IYFX0CNG1IMTdzFyN9ZvxR3QtWp2TLdN0BEWptv8CBsXf9fnMsHIhKM59LbrTeGbi33aH1++yPdUm4UhKHOq13xlS9KiTJhHlU4LFW3kPK5ikRstUbfkoKwo2+/OdfGvy52pQgdVBIHrZe1MdN5OKz51dFGP2EXJPAAd1MM7SYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781588357; c=relaxed/simple;
	bh=iz6kPOoCxpiPqhn7/NEX7fnAerHLWhpOGk168NJLQG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CbSXrgJaCnQcUDurSDfiRUOh7/JolCuwqzxsH2ySNvbhftXbIBGweEDU2znPqoqS6sVWRPhD6WD0PHtqdHHPNqEolSFTVjL51vPFHYrPmt5mwYpMirY9/MTfBF1Er2H08Md3yFcjrVg1qeNNr56Y51eLlzR1ZOYkKi3VzjsqvAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gP2P8cT8; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gP2P8cT8"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-36d5fd50d20so3018326a91.1
        for <linux-xfs@vger.kernel.org>; Mon, 15 Jun 2026 22:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781588353; x=1782193153; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YRR1lR3ArutxodGPLaH087kIDJHJFqiFR5rmxcTXdzo=;
        b=gP2P8cT8CPrm1dUVbUT+DO7zBlXFwiDTJA0KymfcfiDVxy2mz1lw7suZrfsflhz9Fo
         /MJef4MpfkAs5s5qEiiY89QPW3cfCLc0cTIwh/szZgPmAHQBwGGXYxGeZq74ZJvRW3E2
         dIL99bFw3AditdbH9gkjWEh3gHogqC/WxGyySGRee6jm3xkKJjN0kVRQDk44l3Er7Clo
         8m8tFSG7sJDsUpkegWIviGxsfoLW2LeX++8DwGLGOwujBN0rQZTWDnBj+1VJ3Fo5hjR6
         Rx8NMhD9slrqQWa4+8nZwSVgz5+MGtCmvL5SYAn98maK6rnz9wg0UH5SetqGPNVoV298
         Z8FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781588353; x=1782193153;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YRR1lR3ArutxodGPLaH087kIDJHJFqiFR5rmxcTXdzo=;
        b=WuZbfqTZCGtWKSbvlsFtuJ1I+ewaJ1LKPUfVxc6M9opcAB/26NAro6A8LF4rtBKKhX
         4+kwKd4SArmEQR3zqeFh+zYsC6k+Gw0H3vSors954yXSHA0bztSkUhtdhIzmkzNjeC3g
         LH0Z3ZK5zvexRq4XmQXWXKxefMf8x00DUnKZNauvt6vFRNKMiS9Eyk4xc/py2IJ7lQnY
         rockyUgIouUb8fKndlkdsnlyEgfCSTlHmJotzVo2Us/rexQfLPlzotXxbMRwUVQF45/O
         oOU5X4qDRFiGu/sSMCVLtWLeEghGhdjHUmY6mb9KqvUhZHP4VjKFzxGZt8cSzuaEDOKh
         SLZA==
X-Gm-Message-State: AOJu0YwrbpO7rCmzzbLI57aATHUcSA9MBsb8x1RTWF3Q5rYiAcq75/k/
	qeALHuBaYR8wNXjGEvLWYf+iiRoNFGTwHHYwtr6T/qtCPfXwCnZd0Iva
X-Gm-Gg: Acq92OEDcmJAN00Gcch0SpY+IQgyEGfhtYPSIB6LTHZQCmLHKIWLjvZRhd8oVPJfwTH
	In4gKTkAzJPoFQqAA8GxFnjc5kpdBYABH+WVzJAx1T/BSBP9RUYwaBQDx5a/KyekAselgNBV87e
	6f5ghW4jC/ax0UcUlLUexYhBP4LWVmgAioilTCMD/aFl/tJmoUlZimrakcqcwI2z11ReI1GljJ4
	lCcrWzOW3R59lS7FODscVrjs1kLUYO3Wu3Kngw59Hgn5/+vu66j4j1YkDFSgf3DevfEr9YW2gCx
	zaqiq/tSmjvO9xOoJAuQu2Kr4DnofInYgaSgSWozR87ePx1742RP/6XWwxf0M6mGobsCaGrLChZ
	FziZzl82ZeTPydW1rrXfP06/rH43HlAy+czQ6n8tKXkqjJ19aiOFjLfcXGHovICx4dJD+K7Ri9M
	kYLTNj3/BnMtfnDtvzl03lZs2mWvUSW0xn1WoG29dGDBRcDgukZa4K2bCFB2AuhcXsqJXzgzNUR
	aGtQdqzo97ZOICp+V317VeBZlFCE3+3hVtZl/LheYSCnqVDbeYl5jB5OGNCPJoHlYjnIJs+sfZ9
	d0jLy1SHsJQK+RRl1BJDN7d5mDLuHlIJLrCtTFw=
X-Received: by 2002:a17:90b:3d01:b0:377:23bb:9b88 with SMTP id 98e67ed59e1d1-37a033e024dmr18223645a91.12.1781588353527;
        Mon, 15 Jun 2026 22:39:13 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-a.c.d33bddc1d573818c7-tp.internal (107.43.110.136.bc.googleusercontent.com. [136.110.43.107])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37c5220edd1sm1386518a91.12.2026.06.15.22.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2026 22:39:13 -0700 (PDT)
From: Aditya Srivastava <aditya.ansh182@gmail.com>
To: Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Subject: [PATCH v5 1/2] xfs: add a XFS_TRANS_WRITECOUNT_TRYLOCK flag
Date: Tue, 16 Jun 2026 05:38:49 +0000
Message-ID: <20260616053850.2188-2-aditya.ansh182@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260616053850.2188-1-aditya.ansh182@gmail.com>
References: <20260616053850.2188-1-aditya.ansh182@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>

Introduce a new transaction allocation flag, XFS_TRANS_WRITECOUNT_TRYLOCK.
When this flag is specified, __xfs_trans_alloc() attempts to obtain
freeze protection using sb_start_intwrite_trylock() instead of blocking
indefinitely on sb_start_intwrite().

If the trylock fails, the allocation is aborted gracefully: the freshly
allocated transaction handle is freed, and the function returns the
appropriate error pointer ERR_PTR(-EAGAIN), which is then propagated
to the caller by xfs_trans_alloc().

Also add an assertion in __xfs_trans_alloc() to ensure that both
XFS_TRANS_NO_WRITECOUNT and XFS_TRANS_WRITECOUNT_TRYLOCK are never
specified at the same time, as they are mutually exclusive.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Reviewed-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
---
 fs/xfs/libxfs/xfs_shared.h |  3 +++
 fs/xfs/xfs_trans.c         | 12 +++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index b1e0d9bc1f7d..68d22b6cddd3 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -164,6 +164,9 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 /* Transaction has locked the rtbitmap and rtsum inodes */
 #define XFS_TRANS_RTBITMAP_LOCKED	(1u << 9)
 
+/* Try lock filesystem superblock for freeze protection */
+#define XFS_TRANS_WRITECOUNT_TRYLOCK	(1u << 10)
+
 /*
  * Field values for xfs_trans_mod_sb.
  */
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 148cc32449c1..3860e44d6439 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -216,10 +216,18 @@ __xfs_trans_alloc(
 	struct xfs_trans	*tp;
 
 	ASSERT(!(flags & XFS_TRANS_RES_FDBLKS) || xfs_has_lazysbcount(mp));
+	ASSERT(!((flags & XFS_TRANS_NO_WRITECOUNT) &&
+		 (flags & XFS_TRANS_WRITECOUNT_TRYLOCK)));
 
 	tp = kmem_cache_zalloc(xfs_trans_cache, GFP_KERNEL | __GFP_NOFAIL);
-	if (!(flags & XFS_TRANS_NO_WRITECOUNT))
+	if (flags & XFS_TRANS_WRITECOUNT_TRYLOCK) {
+		if (!sb_start_intwrite_trylock(mp->m_super)) {
+			kmem_cache_free(xfs_trans_cache, tp);
+			return ERR_PTR(-EAGAIN);
+		}
+	} else if (!(flags & XFS_TRANS_NO_WRITECOUNT)) {
 		sb_start_intwrite(mp->m_super);
+	}
 	xfs_trans_set_context(tp);
 	tp->t_flags = flags;
 	tp->t_mountp = mp;
@@ -252,6 +260,8 @@ xfs_trans_alloc(
 	 */
 retry:
 	tp = __xfs_trans_alloc(mp, flags);
+	if (IS_ERR(tp))
+		return PTR_ERR(tp);
 	WARN_ON(mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
 	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
 	if (error == -ENOSPC && want_retry) {
-- 
2.47.3

