Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA72A3C76AF
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 11:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781263409; cv=none; b=t/bAJ/JBPvIFccWwvLQDJbbQgkAGEQsXNRY36x6dQJt8P7X48DCwF4tNOnuwBH+U5TqenHZHScPZ6kYHCD/TXZdKwz9qUppftNLwc5oGSlhZvIlyZj8iuTSObF5Ru22rk6SgptscXpOHpGsofcSZT9UZA+lqkZrYQZD0F6lbYO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781263409; c=relaxed/simple;
	bh=4YugNqzpU/MUU8LPDCZyOxYQnpDvya+z7cWnHsiF4do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j1kqq06OjPd1VN3y5IjQS1J7T3yQdloal9oYq33KWl57dbWaKqndAUA93RELe9ey1kgR97ROq9dMEJjR2SGAiZnigrZbrab7GqYKL8HqRaAzpWnbr9WnhY+/6N6aCYq+OvusMlKshc46e5XBuxI+57ITMI6SogskcBfP8EaNg58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ACiDOq2/; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ACiDOq2/"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c858cc9870aso874191a12.0
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 04:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781263406; x=1781868206; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iIvjY/yXmZebAH6dkGtl5V3Mcnn9oZGqccC0KLbuVys=;
        b=ACiDOq2/QnAZJaslyJ3nmoR2ICRxRiNLJx/ppbjy2uPNRrTXWmCgauQunczgmQzHFM
         rwChebgAQzsi2TASjszT8BMUDRxjw5WVX7c86D+CF/1/PKj11TTYG4rrxgnc4cD6xInb
         RYwmbD5Y2UyxFbTAgG7nhtF+jXpmKoWhaY73h6B2Et0jS1xPNQdoaOqDcu+QniygqS30
         e03RSARfFs6iHsIl4RQjUpZfVOo2DCDrPZe1R2QRt/R+UOvTqhrTNlstUgcCpt159XJ8
         kzeFMiEzunKCe+h2Rx06/9WkndZX8hlPsD2SIdgam3FHx0CR+NrlbSY7VGFv+0AMwh3L
         qx6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781263406; x=1781868206;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iIvjY/yXmZebAH6dkGtl5V3Mcnn9oZGqccC0KLbuVys=;
        b=m9xmWMcCXTiJD4o/5Laqd1cz/7T9DcodpQQ7QN8orW8zwB3Rko3GGLYCfPfmb+5uwN
         8wwP5pdSYYF2lay7FTtHfCuJuu1wjKSydculfSh1dXsGCwIyXtJgxkXEN/7qGfW+qe7j
         xDvfbJXOMnwCixer0baPvwibz/D84kRUBi8l/yKMZG70rRx5n/tlpR01K6vfZ3wWLlU/
         p2gNBIAGNhjvWfntvGKIOwYJGRK8A4Py7tzUOVqYN6reuCkbrDNujYtm9smCZ2saHWH3
         GPaJ4E3kwUpsHvsiZtyv6idaahXofpewVfOdSlLXjEqjch2/L8XJwK7OvD85k3EYSqIS
         dp2Q==
X-Forwarded-Encrypted: i=1; AFNElJ+Dr32BpW9UpW0LFuIWxT9KJL9QMIjuQHPOJbCQCv5xtfdTQAVkU5ULDfP2n02Rx9ThhykMrM/Vo7s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3kGB2ouMcqbNnEsS2xG4Gs99d9O2cNxNBy9CpcrYha2sCg0M+
	dKbXPsPqlIkp9Q0LHGU1gw5vvIzN8EQHqyr/7HiIAyJFstwLJYWgLCK3
X-Gm-Gg: Acq92OEuUSdiDeHvrO8z8DyezQKfFo4Rr+jv53/bVpow0XwIZdkEmDERK2NpEoJwpPS
	rL7itFHgKexgIYurzw9+BKkAyVBgc9bFwWLzxca7vCMJkuswzOEfWDHXQfbiObRZ12E0nTTnmLH
	1EujWSjLA6vDR94n+gutf7IYF7WpfaLcUCiW4g7e7BBr1JzU9ha9QHP27FD4cFQry5Hffpo7LID
	sZQQdhYXwYWCAzUO/c3VWUuC+ySaTysP/kz2/GJsz1/ASmhG4zjLfRfuBm2kd4ziaXznVvVxRam
	2h4bWPkzQmNRQlG1JFeLNtgDrksAx3sDMBN/WP9q7sp4OxnVJrjoreoa9ZYHVBKhrsTexQQs8a7
	HFvicsZTs/A3RN+IgLIP7BKMJ4FIN48uWzPlQFQ81FeNgv9FuYwCkb38cRFY/Otc4w+p521rmzS
	+tsz1rsL5uVYEX0qTOGCUsV/7hhsaKV0Rl/rCGrs1dWBYngi9InjxlKBsKL56IyzHViiMR5Bi3F
	5ZkNdMhrltxK+PupdZ28tFrCldLQ7GBdIrWw42xwfnxsBOKg6J0PZ4mAuJNDORO9W5hFCKLUYWM
	u9OPtARDCi0zNqAyYAEMg/cY0v2CuRS7Lkeu
X-Received: by 2002:a05:6a20:6a0b:b0:3b4:6af4:bdd5 with SMTP id adf61e73a8af0-3b780f3b73fmr2604030637.15.1781263405857;
        Fri, 12 Jun 2026 04:23:25 -0700 (PDT)
Received: from cs-1047136853211-default.asia-southeast1-a.c.d33bddc1d573818c7-tp.internal (139.104.87.34.bc.googleusercontent.com. [34.87.104.139])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c866519ef8dsm1808822a12.25.2026.06.12.04.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 04:23:25 -0700 (PDT)
From: Aditya Srivastava <aditya.ansh182@gmail.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Subject: [PATCH 1/2] xfs: add a XFS_TRANS_WRITECOUNT_TRYLOCK flag
Date: Fri, 12 Jun 2026 11:22:51 +0000
Message-ID: <20260612112252.1697-2-aditya.ansh182@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260612112252.1697-1-aditya.ansh182@gmail.com>
References: <20260612112252.1697-1-aditya.ansh182@gmail.com>
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

