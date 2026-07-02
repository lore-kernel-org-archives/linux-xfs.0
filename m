Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE6730C165
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 16:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009214; cv=none; b=dITIZlzb679KFJbU+CNrt5i5mBiZ02/woPsXvp0uHbPRkKXvIYt6wo736qJnhp6Gq/dICWCfwGQozf0nltxeHoepOIPM9QrGuMr1rExHANM7xkBKOfT0Nk4TKUaGecgjkxUit7gkvqxoCPPnkhakbBQYJcB3y4LLFouLsDvTDlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009214; c=relaxed/simple;
	bh=hd/KnioQWmudvkWXFR2Y3w4lP4sXrN/VhJbBatsilqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b8QREENTpSzt5Yq3CUByTiLoaHIqFBx5RCQR+soMO7NnisyKXxU9s+Gbd3ZOHA6huzkHB2GWP/bhq3W7npuGbjbWU9HA8IBT3NHpnZHHKeVq49k/DFqM99ySARLbROUojRxGmtfO7cuqby6gVQmpqkPrd1thzips926CSYiik4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nRorN8jR; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nRorN8jR"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2caced6038eso188515ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 02 Jul 2026 09:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783009213; x=1783614013; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3V2XF7IpvUaoqYobAeekIuEjDScP1OqWQm25VbqHVnQ=;
        b=nRorN8jR7qEw22b33+FcOm/mFwqnhRspa34/EEZIjcGNtzCYyV0Ty80/CXdanjAfY5
         Ew4FbSYcDhK8y60W0jPwlyTH/UtN3DRm1zf6+oo+odX/JWahHenuRzxn7rWWUNMWbwua
         PonN8+aKw8hwhSwHN8c7YyID1vLqy14o/XNeFdUk54tLBCtKz9Ky1BTKUiStDCJelU0N
         tvOY5PoPLVMvA2yC4pNZ46Tzr5BhN5H7kn/p3FR/fQzW4lbNMjF1HpoPI1ICGdIcLHLA
         0Khe5TymXM6WJWwZ4uTtyC18Um6NILKJoaK4BUHe+jhspL3tFNVMUAzmH5goaLy2BV3p
         HoHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783009213; x=1783614013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3V2XF7IpvUaoqYobAeekIuEjDScP1OqWQm25VbqHVnQ=;
        b=hesL4qVUE1kBKybWrpxryOyrj55PMX7Pnj0yH5NlZciEPzv85iKfyObHgyDPD0wAlQ
         nUr/5lzlU9UGdkNUxGei73yBHnPjHf/Df/SwWrkdzj9mJiTbjkQeZr/V6UctB8G5T6Xi
         s8oUK+o7L1AXHXtyyiaHo91Q0XzPga+CHuU5xnIlhZTuuZ2AZMd1Q03z5fp981E/dxdN
         Zy9zj5+tDWbXFiJQQzpucmmcDsqcVzNuaNQr7lUTahzzCqeNOBoFUAYu5O6/6xusDZAF
         ajQgBNoTwemMryLrhBpluVGv8RndPf/+F1FFXAGmAJdqxRjNHOCzXm+HzRXwxZf4lsnq
         hoWw==
X-Gm-Message-State: AOJu0YyB5rDcbY56Va0TbUiGy7oeg7A5EGknn4Py+PocG0o7TPFVKSr5
	oeNPX5uRmbtyhWJlK0bubVfn9o3dqm4mLSUXLzaWtLmKFEo/y5mOObZWkNmZZ5vJ
X-Gm-Gg: AfdE7cmoGrb6EdmyiXKaMbMrmqnmd3l6TTHMyPD4Ch14k9zOyQUGQbYbSqJo0r6817Y
	0TwzrSed3LGyVdoC4oivTnkBKLjHvM+ZfWl1DtzCQZZ2fE+Dr6oNqm8MYFwjB1T/NmhTSeQSGGN
	vkfSFlD8FdbhovKW+lOu/DxkGPc6uSMG820dybtT/o8LcXBJaQcbcHs1VChhSlRcIV7ozksr/q2
	kTNXl9hkqK9AgR3swxoF78XrYImjsuEgqOPFrQsjtkB6G3sboC6jHDQxVYyyU4wDMJ26EGyTB31
	ZO2+B0OQv6CwF8+WjhBed0pdxw9QgSP4vGOw9d1F+GVGmO+XE64+bvRYEVdw6ULnPA+tGVwH9iw
	C11wxC6lxqfTRKMoeJrAFnWop4D1SJB5ack1+3S+TXd9LB9YZKzbb1YCZZU4EVeSMLBukuoUlJK
	3GEoDOvB9a6XGMGB8qwK0iwUsjKJpf08zz3tHGH0+9jzE0tpyF2Y4By3S1LQ==
X-Received: by 2002:a17:902:d4cd:b0:2c9:994c:9a5 with SMTP id d9443c01a7336-2cacb1c6f95mr4456045ad.30.1783009212475;
        Thu, 02 Jul 2026 09:20:12 -0700 (PDT)
Received: from fx.tailc0aff1.ts.net ([206.206.192.132])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b3c85b345sm16493826c88.10.2026.07.02.09.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 09:20:11 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 2/3] xfs: splice unsorted log items back to the transaction after the loop
Date: Thu,  2 Jul 2026 09:19:59 -0700
Message-ID: <20260702162000.3548359-3-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260702162000.3548359-1-bestswngs@gmail.com>
References: <20260702162000.3548359-1-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On error, xlog_recover_reorder_trans() splices the leftover sort_list
items back to trans->r_itemq inside the loop before breaking out.  The
loop tail already splices the per-fate lists back, so do sort_list there
too, guarded by the assert that used to sit after the loop.

No functional change.  It drops the duplicated splice so the next patch
can add another error case without repeating it.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 fs/xfs/xfs_log_recover.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index a1b373c68f0e..103b2a79667b 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1912,12 +1912,6 @@ xlog_recover_reorder_trans(
 			xfs_warn(log->l_mp,
 				"%s: unrecognized type of log operation (%d)",
 				__func__, ITEM_TYPE(item));
-			/*
-			 * return the remaining items back to the transaction
-			 * item list so they can be freed in caller.
-			 */
-			if (!list_empty(&sort_list))
-				list_splice_init(&sort_list, &trans->r_itemq);
 			error = -EFSCORRUPTED;
 			break;
 		}
@@ -1945,7 +1939,15 @@ xlog_recover_reorder_trans(
 		}
 	}
 
-	ASSERT(list_empty(&sort_list));
+	/*
+	 * Return the remaining items back to the transaction item list so they
+	 * can be freed in caller.  This should only happen when we encounter
+	 * an error.
+	 */
+	if (!list_empty(&sort_list)) {
+		ASSERT(error);
+		list_splice_init(&sort_list, &trans->r_itemq);
+	}
 	if (!list_empty(&buffer_list))
 		list_splice(&buffer_list, &trans->r_itemq);
 	if (!list_empty(&item_list))
-- 
2.43.0

