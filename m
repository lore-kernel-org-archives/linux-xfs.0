Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158E433F8A0
	for <linux-xfs@vger.kernel.org>; Fri, 21 Nov 2025 08:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763713111; cv=none; b=UdIRwG3IqvR2gwbLwYhPyKQvR4MSs5eoFUFVvFB/iyFYxQvgHuO9v6hikz4ARQ3JYPMs2iJtUsdKjQbRL+0pMMVOO4Hsr86cHEgaD56L/Wx664LBTrqV5NmV8wt1LF52+KoVvjci7NyIt6Gc1DZ4E4MM2wPYQVFcvtZmnSECTlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763713111; c=relaxed/simple;
	bh=9fX1h1fO3q+pLGnSgKJ0rzYXjH5JwLqWD06FUxR/tqo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NEA3viLhTjs7Hag3BkeZx/UvBDaK4DHiTOWp4LNuRa59c2i6kWMbQNJ+S5pBywDcMs/Nefe97z6KIwFpiCr6xekb39+qMGBdD0D9WGIItRA92kWe3QLfz2stIuRjzApg8X+2sv123Zh6Co6GNA7u8uWHMMcURsmv72LuiQebmzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UkvMICQO; arc=none smtp.client-ip=74.125.82.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UkvMICQO"
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-11b6bc976d6so2581407c88.0
        for <linux-xfs@vger.kernel.org>; Fri, 21 Nov 2025 00:18:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763713108; x=1764317908; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=teKvOHrBXVsyNlkTSBs+xMQTFkH6mnVNybU85CGmBRM=;
        b=UkvMICQOAa9lvM00pS6KYtx10LvrXamhBy5CpqQJPkSK2KiPS+uvLI+oBYO2vti4u/
         welt4xopdNnhjGmgdJlTb/3+PERlNpnhKwr6VGWosG5Rag7Q5nQzhpd0dv3knEBfDxrD
         6TEh1PNMDAk4IWMVeHlTzyT0WLZsVolgisdElvVD264vS155XKJ/j2+WjCmgek5bKtAg
         96MBPLoViy+GAfUkOz/eVHpT3g+eMOCZxFk7AKra0Fuc3E/2L7Hf5hqXiOb2N7uUIIYY
         Fm7j+hrwyNhEl0nddmgkBKqzLfsxbAeYn8+nBwSeCBFknOYljpoZH46guWb7CncRIY8R
         NOWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763713108; x=1764317908;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=teKvOHrBXVsyNlkTSBs+xMQTFkH6mnVNybU85CGmBRM=;
        b=q1xrHTwCqZtXmHB+eaC/5MIOvz7f5IxKyodB78mYj2h04xSK3qSiH5ovPXk/xjMZg3
         NcO9m+xfvEWlHW599XTEMG2cJ2711C6Q/iCBdCLAsdN6j2erEdgYQk/M0zha8v5CczmA
         afZxrtbCKcaC+B5Jidk1RmC6H1YswggUuaBwNyz0BYSqTAQ77XL6MBTjp9I/mbGqyEhJ
         8ARo7n9EjevYtaJt8Zy3w2D1IA6eLHa2i994k5uIWCeQyHaZD9ap8HuI7/j8cjpNwoB0
         pYYb3PJmH5Eh74/sO7+O0hTHaM7rhvY4QFGqPMqCq86ChSLejqP5kqClEHh74o47yIhQ
         Vwtw==
X-Forwarded-Encrypted: i=1; AJvYcCVP6HaykPBET/5mm353ucI8MaG58iP/4TBK4adpYvAh8N5LXCi0u9sxii/CMa6HvH80r583yjGkM7M=@vger.kernel.org
X-Gm-Message-State: AOJu0YyF8Rxr65S8XLlObhdoyoZLRKwRq0HGCOxACCG/enJtbypllzx/
	88eqGvI02FDjV67RbL2S1jGzPOkAMRBLD7TvJ8xwJtMs/lr6UfUUZ1KE
X-Gm-Gg: ASbGncuQovGloQBo6UCsbRgOUxqOougIxSkDjLQ2Ars1pHZ42rDnb/YMiVffEwJpaoD
	a+OHku5JZFv4XHmxDE7JthGs13sQCeS1ev5EORvMUEoFfzSpCYwnM+gLTUqzTWQ/ZOozQPbOveO
	j/8KmQVX3Z1+eHOiv/nxAd8a0uZ04M0cCCzT9vnajlOHu/bHjQ24G6q4Cxl+8N+lpEJ88KpfXNM
	rv3XCuLWj/O2p58ggrT7TaJrNgnV1RhzE66VPnS17guwV9WFacMZhllafyT6nEJv6AbsjoGyByw
	UMb/6QsVgIb8fOBBpynJ8f2b3SGOkdKkvWyeY7GF0hwqiN3+QENwOvC/OQxkbdw+Z5/L0+XNTSV
	QSJxfNYL/qhba5eWu6vnx2hGNFIFLZnhifoorP9CK5XV3Bx0NJizXcIW6mM319zrF1JAZjNRzrl
	v9nxURFnBEFgJrxQpiqKKnsp50hQ==
X-Google-Smtp-Source: AGHT+IFrMbMVzab5Rj4WbT0evERr8uBJOd6ao5iaP3Dv1k5XAo7Ky5wuHi6tXAqFVzNQo5RQ6s2gYA==
X-Received: by 2002:a05:7022:fb0b:b0:119:e569:f85d with SMTP id a92af1059eb24-11c94b90cb3mr1713151c88.20.1763713107996;
        Fri, 21 Nov 2025 00:18:27 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.43])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93e55af3sm20997352c88.7.2025.11.21.00.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 00:18:27 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	gfs2@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH 7/9] zram: use bio_chain_and_submit for simplification
Date: Fri, 21 Nov 2025 16:17:46 +0800
Message-Id: <20251121081748.1443507-8-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251121081748.1443507-1-zhangshida@kylinos.cn>
References: <20251121081748.1443507-1-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 drivers/block/zram/zram_drv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index a4307465753..084de60ebaf 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -730,8 +730,7 @@ static void read_from_bdev_async(struct zram *zram, struct page *page,
 	bio = bio_alloc(zram->bdev, 1, parent->bi_opf, GFP_NOIO);
 	bio->bi_iter.bi_sector = entry * (PAGE_SIZE >> 9);
 	__bio_add_page(bio, page, PAGE_SIZE, 0);
-	bio_chain(bio, parent);
-	submit_bio(bio);
+	bio_chain_and_submit(bio, parent);
 }
 
 static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
-- 
2.34.1

