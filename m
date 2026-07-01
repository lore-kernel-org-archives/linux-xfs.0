Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50DF21CFE0
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 00:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782864717; cv=none; b=i84q7XgOGJCVvJIJ8x4FEp5ELX+lBFiQpPWejfdZkskpUFFIUx9dt3FLN5KZ25xD8/8UmELWocXYabE3sNAwSYvV9m/ihtzWX1e/jdeVs1oPjW/J5AZonzMz/KikxpSyhxIpAcS0kakQrwjGa2NfB/LpxM9RVRPKcUew4TrGwAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782864717; c=relaxed/simple;
	bh=XfGWwXuootHBZAI3s4NLMg9SyFeRWTCODggpZboQpk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ludKXnWSwuQo+wBPMhNUnL1Hu/EQIEvh3DR+cd2kqm8/WPjirxYLTKSDCueUMJmGK5B9mqdu34fZUa+1jP+mu36m1I9esiwIKzFCdD3RVk5WRH1aKDqEqhBWeQlIJk9MKTAr2baI2qh0XD++5kvBBrvZ5tFZLLtjwt0N4x63CWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WgvQMzy9; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WgvQMzy9"
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-44ae264a785so17679fac.3
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 17:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782864715; x=1783469515; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sbb4EcSwF6GBNr0pD5cD8wD0CiX9f1pyxQBHQk0CnX0=;
        b=WgvQMzy9CdJRNRtZBBGkT4Dsu+JkWadQRFZreXjjsvKNjPI6ZGhoOt6zMIBycWZ37E
         QR9aJTRR1iNErK5qjDPNsfCXdqGKOMHLZGyg7jWTxvvkNWH8+U5eizbJOISu9xF7fBUt
         pneVsdqkqi9aHx0X+d7Rtyb13JJAYtIMQ8ZXCplmV8ytbcVs++fQpfQGK0XL9tdwVJPz
         VSf7RrXQ57p/FNPBUAke/OjyK4LsIJqU315Inr73FU7DLwsDL0peo7UdIOXlhJCRe0/T
         DhY4F7re8M4qRyz7rM+o19zJPput2agqdyLlZlJnk4SwTH0pLbtqPAjSFEOoNGHHOViI
         DNxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782864715; x=1783469515;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Sbb4EcSwF6GBNr0pD5cD8wD0CiX9f1pyxQBHQk0CnX0=;
        b=QYrX34XMbaKVxMbI+vkRaXxLT1vc6ZxeQN77Yz4lwnVdluThKbdQplLgc1KobpJKWO
         ERe2HQ5s24IM6L769WH4ftzmwexUewMnLZr0DilJOKNRej8GhlAAIVRE1GVlgA3cEB96
         iIafUNFKrNiRFQsObeGSKdaPgOvU24vMXWmQOgmQq7KYTl2qm/bpwbdnhtBVdYV8daGc
         oqCKDf7eIHtdnSxMutVo5DPyYolhLQv/OF7X6GYL52Yo1zVGVrqCp//ffLW9w+7giNI4
         YkridvopTh2ku8kGh4+NordmrKycRwgJ2WYr3cB/ul//X6M9RiU70iTM5HT64vLCdbrd
         nLDQ==
X-Forwarded-Encrypted: i=1; AHgh+RredgjEHYePipUPuBIXe40BIf5c8h7qcP6T/fV4g6EuMTaitAVqNkIeCC500MsDFa9M7Z+7GRxZd8Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywb4q/HRGP081ZlF93upLTYfEO3bR3WPPYHdN+nZUP2fp6yn6Uy
	PNU6PgKpDp4KL7GxeajKPOrYnpapdLvKloq8k2DV9yBtco1VaSwiiHE1
X-Gm-Gg: AfdE7ckXmuXk4daZfGXdLoANMDPDXUu+KVtjsGGFl0mlrDrRmbLc+zPcxvhB2iJ0olC
	K4tbkuex1zd3TebgHps5pLWbtCT/G9fSystTyizNswv67X8h/iVD0r0+7Y9COGRAH8Rds9d68LR
	6DTFT7e9jghDtcnWhwPr965wD1ILSmCFlMl/YlwdIVwob6KRCtTCcupaBzR//ynayUnyWcLiyp0
	Qrc8Qlend2qjCHDQJShKze2rojhyPbXk/uUzk4iRi80w/9xaivT8a3S4jt4LU9L3nBXTZYItDmS
	FBHsx66xoAadczdojplZsS8VqV7akfLDI5KcKFyLQS88RjHJWIP+C5nQXaQhxaR7Lu37Kh+tBUy
	NK+eweBSQxQcXdgCJWL8OxxyM9kj3K5Zq3enpftjvLMlvbXVjCN/ILMfxuXtakYKxPBJdj9baSr
	Yc+dhJVqDlNDFhspy/vL4a3vrl39QI/vHlNTO34caPZE1if311ZFuqDLXOf4wmQac=
X-Received: by 2002:a05:6871:7824:b0:43a:c6c1:e40d with SMTP id 586e51a60fabf-448dc4e72acmr4916410fac.16.1782864714787;
        Tue, 30 Jun 2026 17:11:54 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:6::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-44c613c04a9sm328264fac.2.2026.06.30.17.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 17:11:54 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: brauner@kernel.org,
	hch@lst.de
Cc: djwong@kernel.org,
	willy@infradead.org,
	hsiangkao@linux.alibaba.com,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org (open list:BLOCK LAYER),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 10/18] block: convert iomap ops to ->iomap_next()
Date: Tue, 30 Jun 2026 17:09:25 -0700
Message-ID: <20260701000949.1666714-11-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260701000949.1666714-1-joannelkoong@gmail.com>
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert block iomap_ops to the new ->iomap_next() callback. This uses the
iomap_process() helper, which finishes the previous mapping if needed
and produces the next one. No functional changes are intended.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 block/fops.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/block/fops.c b/block/fops.c
index 15783a6180de..c2721e2c659b 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -453,8 +453,14 @@ static int blkdev_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	return 0;
 }
 
+static int blkdev_iomap_next(const struct iomap_iter *iter, struct iomap *iomap,
+		struct iomap *srcmap)
+{
+	return iomap_process(iter, iomap, srcmap, blkdev_iomap_begin, NULL);
+}
+
 static const struct iomap_ops blkdev_iomap_ops = {
-	.iomap_begin		= blkdev_iomap_begin,
+	.iomap_next		= blkdev_iomap_next,
 };
 
 #ifdef CONFIG_BUFFER_HEAD
-- 
2.52.0

