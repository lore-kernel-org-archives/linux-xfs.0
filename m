Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9AF3E95BD
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 11:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781265005; cv=none; b=gCDPgTzYbd6o3v4Bj5cqNFAvVdQfn+jLLgvaDz0JHYTrj29cfC5F6b8FSQG8DUgALm0qpNCDItoPTfE9Qt8Et7Eupr8wHlxDuObPICGCQJunIikN/ROpE4wFe8mvxVsSkUuXdZ7dMhl/6eBtuzeEW2d941T5r7fWZy8Bgt015ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781265005; c=relaxed/simple;
	bh=4YugNqzpU/MUU8LPDCZyOxYQnpDvya+z7cWnHsiF4do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/xi7c71vfC467fsLq4MskX83nOGzLe/yTk99xdJZLAlVntvZLscuTklFj7mStK2qIaSLMTPlg7J6PPUUEtn+Hg19vd68trBUztEalMcZLMTDaPVUYTqt3pKYrxyC4MPuySVOVh1u/g2Jsde7JJdU0BLW1iLZcIsrF734Yrs58g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GeePiQKb; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GeePiQKb"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2c0c2a68d01so5950335ad.1
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 04:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781265003; x=1781869803; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iIvjY/yXmZebAH6dkGtl5V3Mcnn9oZGqccC0KLbuVys=;
        b=GeePiQKbBUDZMrMJV8Sa305TmMLskzmE0dzbVtM0P4oZEU1QCbLjLlVwcU3qXA2LiG
         ecqIw+VmUP25ezUeOxMeYO1cvdNh8SW0X0+1Ru2J4JJ6lZPDcLndpwb4ckugir+pEkYF
         FJyuO2we3cV1CaqOp17y4dIC6eF+v4n769MegsM1MsDBeDjNhfvQ+eQ+UKZqZDM8NDLC
         N0+zPIdjaokhqAoHKuvmnrWSw9cA/ZaE+zbhSPCTxpN7MmSH21cBqSsqrj7qyxv0Il+0
         JyaqeXMr5J1+S63/vR1a4KxJOS8GC4yKogH5iqRC8XDDYT4mZDtK/WVs89txFr9NNKWS
         lhMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781265003; x=1781869803;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iIvjY/yXmZebAH6dkGtl5V3Mcnn9oZGqccC0KLbuVys=;
        b=UvGalRsFXqjipcLFFGYHGG+FfvYqIW5QSs1eMoL4jt4iorf8EOag483L73ub3imwRs
         lyBfYxxfKnskoWZadcc4dIbZ6G5wt0pTahxDzJB+89MVrW9jCNZgbRugM8YLYVYcesx4
         3eD9Dc0lXdImvUu6N20u3zrBfEQ3aCZ+UfA23GttjOWhAdEIGUAHy9VDHJONxscvOHOD
         pAp2e0Fz2IUF80w0m60CB7RWHZXH6lVDQKy/R0ZNVsdM/QSwS50PQL4+JdcGKnSkGEME
         Q+/aGq7/ZKwe48Fn3C0PSoYFtBotihIasiSvi7vF/aVN11chNfGdNveiJ6JI2yAt42HR
         /nog==
X-Forwarded-Encrypted: i=1; AFNElJ9SWRBuqhoz4MNAq1SPD5q2DP9XFsXV1RxdP/FuEX8gYi8Ggzm4T+B5aCB0FND09OpTGxZoV6Y+NR4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9x9fW9iir0kcSQqP6ZyFKaWIj0sipgGqHbRnWbggvzK0DMYLB
	t9WEf+KhKbqkfmw+5XHSQSB+68K94QQ1T0CVjrGv7hFZ7bkDz0DEMgx4
X-Gm-Gg: Acq92OFcHbXPSVnivdMpbduGOkUHPOmdyuWC1B0tXxNbucny6yjT0fRVJgCT+egu5Fm
	4z0wcG51VyhSrQdl7y/IKaHfWlLf71P4BnS/70zEXvzEOOehaUmEa69YhorMLXefm8mYhW2QbY9
	iE3dwfdKPIiiZGn2wLsIDLcTO5C5D5MC9UAjLcc/hV5o1OyVfCNynwF+nZ9Z5OvuwkoaQlym3SZ
	8O+mXQuTeCFWQBfV0kZqoszfKern+EDwz/++DPdXdxJ2sTZna7bIfzCxFJPaF506WjNtif8zF1r
	3KrcXN/2ynvcqab+t+5VqtzS4kN61RzyGwR0Td3zICPn8b2Ns+2jIx5tjtATOQ+Yvt0+my5B0MO
	PG4p8fo/xVzRqu/E02WpUnmEdc4eLZrkASYAK5iOsIQsQl9ri4phoNwOuhMe5hrMPWL5EQ2AmUO
	k3VKAcmFYlwjL0lCVLJDC9I/2e5VSu6CAx4j/M7nOMAnOcCEngQ/+oYVBIWPDFXSXM0BDa4B8la
	O0RdJmYR4mFiT4UHuP1UW3i9b4NN+ak8exZND4ETHLEb9G+NjlVftclViVrCi1+9qx+3zsfBDB3
	Ou/3A15lxMSWWOdRj7TAgBAOuKNpMtw1G29s
X-Received: by 2002:a17:903:19eb:b0:2c1:ee75:56bb with SMTP id d9443c01a7336-2c41188b334mr29525215ad.20.1781265003541;
        Fri, 12 Jun 2026 04:50:03 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-a.c.d33bddc1d573818c7-tp.internal (139.104.87.34.bc.googleusercontent.com. [34.87.104.139])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c43307a259sm19993085ad.68.2026.06.12.04.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 04:50:03 -0700 (PDT)
From: Aditya Srivastava <aditya.ansh182@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Subject: [PATCH v2 1/2] xfs: add a XFS_TRANS_WRITECOUNT_TRYLOCK flag
Date: Fri, 12 Jun 2026 11:49:16 +0000
Message-ID: <20260612114917.2192-2-aditya.ansh182@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260612114917.2192-1-aditya.ansh182@gmail.com>
References: <20260612114917.2192-1-aditya.ansh182@gmail.com>
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

