Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526D627BF93
	for <linux-xfs@vger.kernel.org>; Sat, 29 Nov 2025 09:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764406915; cv=none; b=EJaY+jpohx1fn5i2CzRzZSKuTamGRsfwvDWwnGKA3tWXUyCPA0Pzpwb+IPIYzXJaz8A2M2T1g03oMVt6SBtx47pI+KkdI9XY41VQkD4/Xwja0Y7v+J0DJNhPm0/uMdlZGiLjNpAQXneHxbXRCgCISQKC5WOhHl3GwxxmY2a7bRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764406915; c=relaxed/simple;
	bh=b80xEn7EdjxWTN/ci1ysQxp/kAR6AhTP55Nuwyj6diA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fwXIIsi/U5IFA4dqPHrYviJWxGUKYN9F17x3WZ9zf89FsnwMjzuPjI03unNyEY+KztVejYCs05JuoVanfY3Z+tqbHesEO72fiFtlRau9Y3ghDIG551UPxifsnt5RupLMT13zLf0Yu4Ps+yD2ztX05hHT19Sl73wTtYE+SN7/xw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QiV5+N+K; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QiV5+N+K"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7aad4823079so2259988b3a.0
        for <linux-xfs@vger.kernel.org>; Sat, 29 Nov 2025 01:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764406909; x=1765011709; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1fxHcLru6xJPrGlRM61sm3BLmSBVukho7BhSnyNPRbc=;
        b=QiV5+N+K8rvRLBeotMRxe/ceAipnmm4/K5XqUM9OFWx31hIlK6IZHh5SfP6vTbIT3z
         Z+HDEC8rJrsSImM8J/c3LXbLeMkemS5zgfgijEuileBY7KOVDiMbG5dSZYXtpkuV38is
         dXgCZD8NV0h3nnw/ZdQhxhkVbwOLDCAvObTBfh9MxNTN+js7T6IUtvvtL+lBf4h1xFyi
         sZHodfUm50tGwTYUEMPTjRJ1JrzOGkXJ+AMJ1viFrI0uBKsOI4WI/bkgqn7nFOFQ2ifn
         uDArfq6uqsHHo8Ts8Yna3i45vAnZ7mqN9kaEXwvif4nYBAq/6KE/UlXA8mR/DZaGWX8D
         rF0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764406909; x=1765011709;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1fxHcLru6xJPrGlRM61sm3BLmSBVukho7BhSnyNPRbc=;
        b=N5HKdd/s5wvYl/DC0SFMsfAdacCXNRYVjDCDqKLbz5ZMQnwyCKNLNHaeTIjqdFKHXu
         j5eZZGSX+75pwt4dy4xo2Bql00YXfHg9TtuOtXuGGTkdSZ2go8N4gIy5L0zebHhN71wo
         UyNjOf77zB3fFnektAnIId2lyWAVAIqNaqCu1ojNwXSNblHmASzSf19n8hk372kLYl2C
         2LBFshHZMPn0t/nmmNeTXat9s6UVbuZwRgGOArGVXZgZJ/S8mdZ0inCFWCHc1NEjRRvY
         IRkFhCFYH1jy7O2LmYy+Ov+inihaZhSGEuWnCjBvlfkKKb9EP7hHwNttF8aHE0vky67r
         l60A==
X-Forwarded-Encrypted: i=1; AJvYcCWpMP36jv8qsM8iSgDNkpPoo2DJYF13o0n+BFtQa5zQRq9E68hpWcAwlion/TYpClhC3KBcOI525Gk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwR2dSJ1d5dsB9UCXStlCO4Z8J3OFuImieF2Z9Tc0rUiv842UBK
	X5UCTNWzV/7o8+f7bv7SF0nnq9Ry5y3davg2E8+p4TAguMeXiTAyn+za
X-Gm-Gg: ASbGnctMCw4Tqpr+h4c+cT/BY1wNXRl68vGf1zcIZt8+TSZgCI0EU3qsk6iJxajChoG
	jxka0B0H3ILhhMN5qIo8h+uAiXfS5HytMNuo5HrwMM+xEKZPhGsqosbnmWTaTwMkIqy1ZSaEx/r
	Z1clmKf6TZu7N5sQDU5w+OgR/BSWIqw5K8tyyU07T0zY6+FCIN1gD/39/+TGKnEK4l0cW+4oM4o
	wb0HkIwJJKcfxDgJin9nSLdZtwfm0qB1H+LBvlV+9e07JMdis1ADZH0mtEVnKh855Xpt0/S4uwI
	AgU7NH9v6ojjVS1BnuVElquv6EuoFtEcMuPLIJS9SQXW1vQqaCvwl6OLj28jvJ6oeTUQCcExzJn
	ghMg2Z1qfxmeB3SuydeIFATlKq0IE6xgNzaf1vWwUrIoWlDaza/j0AAKv8lUoc+PHIkcYOqORY3
	qLPQ2HtvIPmRmOBY/d3CvzlqB6VA==
X-Google-Smtp-Source: AGHT+IFEuvilLkDJGqcsWwCIedr283xueadWd1RQPKrotWNJSiN6yvq7rXU8DgdpE+SxH743dNudrQ==
X-Received: by 2002:a05:7022:221a:b0:11a:2698:87c8 with SMTP id a92af1059eb24-11c9d710498mr16125897c88.1.1764406909336;
        Sat, 29 Nov 2025 01:01:49 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcae73bedsm28114394c88.0.2025.11.29.01.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Nov 2025 01:01:48 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: Johannes.Thumshirn@wdc.com,
	hch@infradead.org,
	agruenba@redhat.com,
	ming.lei@redhat.com,
	hsiangkao@linux.alibaba.com,
	csander@purestorage.com
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH v3 3/9] block: prevent race condition on bi_status in __bio_chain_endio
Date: Sat, 29 Nov 2025 17:01:16 +0800
Message-Id: <20251129090122.2457896-4-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251129090122.2457896-1-zhangshida@kylinos.cn>
References: <20251129090122.2457896-1-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

Andreas point out that multiple completions can race setting
bi_status.

The check (parent->bi_status) and the subsequent write are not an
atomic operation. The value of parent->bi_status could have changed
between the time you read it for the if check and the time you write
to it. So we use cmpxchg to fix the race, as suggested by Christoph.

Suggested-by: Andreas Gruenbacher <agruenba@redhat.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Suggested-by: Caleb Sander Mateos <csander@purestorage.com>
Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 block/bio.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 1b5e4577f4c..097c1cd2054 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -314,8 +314,9 @@ static struct bio *__bio_chain_endio(struct bio *bio)
 {
 	struct bio *parent = bio->bi_private;
 
-	if (bio->bi_status && !parent->bi_status)
-		parent->bi_status = bio->bi_status;
+	if (bio->bi_status)
+		cmpxchg(&parent->bi_status, 0, bio->bi_status);
+
 	bio_put(bio);
 	return parent;
 }
-- 
2.34.1

