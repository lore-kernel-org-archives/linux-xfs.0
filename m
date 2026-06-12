Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E2539D6FD
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 12:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781265931; cv=none; b=g1gmA+9bt/DvbZqtkR7RZ4vfK3ugHEG+vIEGnkdLVXNsjZYveN1O1+Mk6IeGcMFh05O4qXnY6WJ0kQLUYA0IpW8JWoK43ERIdCeH4Ri6xpTYNiUVv+wAdKFuJ1cP22YscD+TL8Z3ona4juEjVwdTzoBfF05LbGbR+AXcQSDh5pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781265931; c=relaxed/simple;
	bh=4YugNqzpU/MUU8LPDCZyOxYQnpDvya+z7cWnHsiF4do=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p0Ri9okBt3UDFdCNswp5m6UKkpmGZXvh73B+7pU2JGc/f7agvfdqYpOktpX2KEcEje2zQoSNGnhF7XtYUgz4OBPWFcxUzgj6ooCGstlgi2mx2rFdERQGZ+ZF0jbDx1DeQb/OtGr7Dbh8xyumlXi1KoQJPzDzgxGRDl7Lu3DxI2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BWZFp9E3; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BWZFp9E3"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-84347ad88edso569782b3a.1
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 05:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781265930; x=1781870730; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iIvjY/yXmZebAH6dkGtl5V3Mcnn9oZGqccC0KLbuVys=;
        b=BWZFp9E3BiFXCatZeDBu65polJeAPLf8ZttAxAYETCcqE4r+mXpP5m3J9VyowjFUGQ
         DmP3ymIWx7c3gwMQiZHX8aVleYn7LxahML+SNa8XAtgdD/4JQtlzqEndSxhMzvA8XshM
         dtRFnBbsfaDg92LsIu2mjBMtjKqtTglfB3Ww1ZCt6fxkTcbVWJ8FIqpP70OyYvIIuPXx
         drcr3r0Og7ObNEImvmuMjEk01uT1CSp3EBzNDSlQyM99IihIzmHdAqDZ89bHUog+I9fM
         AAkYCmjaBxDdddvNbIlMUruBhllMw4ppqM7OSWOaXU7TKKIvy+OQTHL+bHUCMCqq3V/6
         rdcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781265930; x=1781870730;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iIvjY/yXmZebAH6dkGtl5V3Mcnn9oZGqccC0KLbuVys=;
        b=TwRNCo8JJSZyOXsHtB/+wUF+GIlJ5yWJiUBbD4SGwnU5xzjceMeQjtRnGjWxFiXJA0
         wBpV8XBWOCnJBPPEf3aOuNmkMYbc5N6nA96iK8RmQZ9Oc0ZsLr0NaXNPkkcfRGpRmA75
         S5HMdqjcrSh46ge0R/qBT60Dh/TzDvWiJnEow6PllILmcfnS5aPvGsnemge4hz1kMynC
         /Hv14zBsRLwndwk44jeH2e2p6He1fJcgKapUHPJFpnb8/t2beItGFKAxg8BktzYuqCmn
         C56QzBKR1ohdR8WVS2nb4TtHI3/YsVcgaiLG1yXK8Gtp66tJltXZmn52eOOKMrinwp8Y
         3wxQ==
X-Forwarded-Encrypted: i=1; AFNElJ8X0bvQkXpj+CXlrOfDO+x6ppBzuF+hKxryBx7OO41x7+U1nYFYj9ELhuZzAScwzVbpE5JeFbjqiTc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuGWGII8I5qs83pS6I6JuWECO1iHYbRu0cLAK0dO3M6xsWckzN
	tCr256QGEY6x3is2lDAdNbmtITTXcGG1XGYrGv4hF8EYQ6E7m9NHVYwJ
X-Gm-Gg: Acq92OGvSe4K8xeJmyT8ZfrEJ99MggN+Yo9Ag1uxL5ySxoNtiXGyhITwWrxRmMvmO77
	I+OUZym6kvyyrK6dk593aAAxvZ4GiYNOidoA3G2a+2PNDcz90JHFeJAYpjpq4aPfxFKYTEQPIY2
	W3Uyumew+ftXW/TOp5tLdI0QPdxUqDgJCWwOxvF0CvxvwOwVo30y4vxwfSj7wfWf11/8qntf0yH
	L68kiIFfdfgJ8CZfnbaJEVeWQuj5Umwt9fkH7r2bFffKYqtQ+d/xXyx4yWSw5PmBcH5EOULmPbk
	ou7bvgCRy1fKiEuKjQ+KxFxZrSTopmXHMlVDFpvhuF6ScW0QVhqLdHiSh6c9b+Gn4JdHx9kBlIP
	RWXB6mvnRi5teZwVrvKWsB7uB4jmRuz9FKDPDThcDZnCxVfHPAGsXFmQK/Onfb5aiTyV2V70Szo
	Qbw4QgN6OS9rKlTBk82jQ8EMq+h2RtXjTLoxTCQEw4D1FCuWzevgP+rXmbuBL0wMD2NHQylgHmJ
	35WQuTNzyKdzFAY8JGEBnooggTd53JBfk+jGobIPoFh3t3xs9Es6J90i2J0AMFsvXLkmEJGCi20
	+G7OMA/dYHD1QoReEAYbvWq8xteaftYTIqxI
X-Received: by 2002:a05:6a00:94db:b0:832:e65:ddcd with SMTP id d2e1a72fcca58-8434ce7a608mr2852026b3a.45.1781265929826;
        Fri, 12 Jun 2026 05:05:29 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-a.c.d33bddc1d573818c7-tp.internal (139.104.87.34.bc.googleusercontent.com. [34.87.104.139])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434b048496sm2373084b3a.54.2026.06.12.05.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 05:05:29 -0700 (PDT)
From: Aditya Srivastava <aditya.ansh182@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Subject: [PATCH v3 1/2] xfs: add a XFS_TRANS_WRITECOUNT_TRYLOCK flag
Date: Fri, 12 Jun 2026 12:05:19 +0000
Message-ID: <20260612120519.2302-1-aditya.ansh182@gmail.com>
X-Mailer: git-send-email 2.43.0
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

