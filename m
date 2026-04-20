Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF5013D51E
	for <linux-xfs@vger.kernel.org>; Mon, 20 Apr 2026 06:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776665800; cv=none; b=N1fr4YL6+AtzT+VzhXjYJoXOR/yZ/ujsKrPUi7MoyB5n03NCtTJW/AA47F5RJCdPBfxUwJ2TMVzVepxwhYMP8KTBM8SWm1jy/05opFYz/sCDhJU6QOzBNCK4+ng4gkIObfysjh9kdVHb0mxXqaZaeQGI2O1kNOn+DvSTyI3etDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776665800; c=relaxed/simple;
	bh=l3l5LStnrkBdnCMkbwCq/lTh+1cpa2xztmlxm2P6lrg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Lzo0bVmsacNUJ1q6LIifOYAXUUievN/6ulDAhv8oPxZ4AY+YfvuG+4Cr7QRs5j3rsaXI4pDYR6s6O8sKw7ukpEhOZ9nEFlBlAJ5YfPOPznpMuffAPPc86m8ImcuFvCGGIgI15oCmWf/GyVLXsWcda42jsvvSjFKUCO8E2Zh3BWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LnZ4j5QA; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LnZ4j5QA"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2b4650d5f5cso8987475ad.0
        for <linux-xfs@vger.kernel.org>; Sun, 19 Apr 2026 23:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776665798; x=1777270598; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sq8jVjaQsEQ037YnID8m/bdOr18FV4DJuvGfBEXqq74=;
        b=LnZ4j5QAGU9lxr4ThzR3NWilS8l0d1Wxnb87+ltQeGp4VmTGkP9gN5//CoaAKoYHHx
         XhEfKa9+5jkhV6TNEd694cXefTyv+YmpYxugD9Xwjv2RnS7ukKlYBJNDOr/UfyNlC9nD
         FuUsTjt+39epxCjHPmNEd3I/E4gXyQczOhNluibtmjKLAU9UFa786+XIk+t/AmHJNfzD
         aenFiA/2iNIXVLBnJ/gb2WyLQu/5vk/Hphz2rHR0VGQ+H877Y5ylntnby9RvMuFoNU0J
         5NiSSFzO4ZI6lgWhNOVGfjQoME97zbyDkusHX2HJh216v663dW51mL2Q03c5TnQmv38A
         6jPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776665798; x=1777270598;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sq8jVjaQsEQ037YnID8m/bdOr18FV4DJuvGfBEXqq74=;
        b=ZPBM6CBtnC8jmVseZ5DiHgizWXjHQ8oqu9o8MetU9z2jpcpMBJSHnip0sY9jz7Q65o
         f6tldJtTDCYFQ5+N0m4MejfEPcNCpY+keIK2iahO/EAwFvUwdCUtbH79fL6/nFpm1Owk
         RPSyvV1hOocQF40p5sKxs9TYIHMGSsbk0p/c6hCo58PKE4ntaW6Xsylmzo4sWrCOnBOS
         IKR+5ahtM0sc+djCwhGTELeEfMQw2pyi1wKzUCsjKH+9P4leLX9IoZ9H2Xv4b274MSnb
         MtWP1bi1sR8XL53QyeVeyCfVettGCpWisSuU7NQ+dKQtYpo/ykMVWJPG/TsKMY+cCJBv
         xxNw==
X-Forwarded-Encrypted: i=1; AFNElJ9E2K35Hj7O8r6ZY9B61aM4iHGc4t/4HJWWwZKyFinCcbz/nm1EwKhQXbEwQr4RJaLzKcv/oMfX66o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5kw8eRSdn81Y3lN0vc1tGQXWW/dZUeamA7mwsk5jAd1M5aqE3
	ZAU6FpCMX2abVHnrgjdd82cyfa+iYsXdEr2Qp6PdSyqoI9hoRUAvvXQn
X-Gm-Gg: AeBDietewFaKvdNHu0ZUSWBCiROifZoA66V0vzyBtofy0ihiYOhQtMjhZVWP8Vmmqcb
	38I3Ihq/5RvZlk2peohUTlhwdW1ZnQzj+FlS+PoUZ4IAKXDk3FCCbIID9zm3W8DH95Sh2US/Wzj
	GHEmwWKq/cL/+9xoAXdpqT7//85VVkpfZr2YtNONzk36tHTl36EGaBqELIeMWXz4h9coOtelnDK
	MchxymcWoFZ3+0xRsTpbOwxCEWEq2HJZwq/NuqDhaq0LItkNgh7NBH8XI0wDF0eq8vcYelt7ZOW
	YcVEvmSO6pjgERQskWqsRAMycvX5MkCiQ8EEB7M/9YdPkA7ltLQTfuxwr4Lm+uH6rvwcUPjhtsw
	rYTO4CTpuUoHG16sW3gyPUnPel+wKmTyS46KwXt22Dm8x5rJAI80l4dsiFxx5Q9rjgH9twpDoTO
	WU4jFJH7RxCPdwVzsmEATtq7Lzk1RiYmcwukDK4V4KEUO3k1RFoQ54SLgthZ9hyBm2Fw==
X-Received: by 2002:a17:902:d590:b0:2b0:608d:d8a8 with SMTP id d9443c01a7336-2b5f9e8e4a9mr122014005ad.1.1776665798486;
        Sun, 19 Apr 2026 23:16:38 -0700 (PDT)
Received: from localhost.localdomain ([2408:8740:c4ff:1::4])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2b5fa9ff8d6sm88586055ad.1.2026.04.19.23.16.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Apr 2026 23:16:37 -0700 (PDT)
From: Fengnan Chang <fengnanchang@gmail.com>
X-Google-Original-From: Fengnan Chang <changfengnan@bytedance.com>
To: brauner@kernel.org,
	djwong@kernel.org,
	hch@infradead.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Cc: lidiangang@bytedance.com,
	Fengnan Chang <changfengnan@bytedance.com>
Subject: [PATCH v2] iomap: avoid memset iomap when iter is done
Date: Mon, 20 Apr 2026 14:16:30 +0800
Message-Id: <20260420061630.62077-1-changfengnan@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When iomap_iter() finishes its iteration (returns <= 0), it is no longer
necessary to memset the entire iomap and srcmap structures.

In high-IOPS scenarios (like 4k randread NVMe polling with io_uring),
where the majority of I/Os complete in a single extent map, this wasted
memory write bandwidth, as the caller will just discard the iterator.
Use this command to test:
taskset -c 30 ./t/io_uring -p1 -d512 -b4096 -s32 -c32 -F1 -B1 -R1 -X1
-n1 -P1 /mnt/testfile
IOPS improve about 5% on ext4 and XFS.

However, we MUST still call iomap_iter_reset_iomap() to release the
folio_batch if IOMAP_F_FOLIO_BATCH is set, otherwise we leak page
references. Therefore, split the cleanup logic: always release the
folio_batch, but skip the memset() when ret <= 0.

Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
---
 fs/iomap/iter.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index c04796f6e57f..e4a29829591a 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -6,17 +6,13 @@
 #include <linux/iomap.h>
 #include "trace.h"
 
-static inline void iomap_iter_reset_iomap(struct iomap_iter *iter)
+static inline void iomap_iter_clean_fbatch(struct iomap_iter *iter)
 {
 	if (iter->iomap.flags & IOMAP_F_FOLIO_BATCH) {
 		folio_batch_release(iter->fbatch);
 		folio_batch_reinit(iter->fbatch);
 		iter->iomap.flags &= ~IOMAP_F_FOLIO_BATCH;
 	}
-
-	iter->status = 0;
-	memset(&iter->iomap, 0, sizeof(iter->iomap));
-	memset(&iter->srcmap, 0, sizeof(iter->srcmap));
 }
 
 /* Advance the current iterator position and decrement the remaining length */
@@ -102,10 +98,14 @@ int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
 		ret = 0;
 	else
 		ret = 1;
-	iomap_iter_reset_iomap(iter);
+	iomap_iter_clean_fbatch(iter);
+	iter->status = 0;
 	if (ret <= 0)
 		return ret;
 
+	memset(&iter->iomap, 0, sizeof(iter->iomap));
+	memset(&iter->srcmap, 0, sizeof(iter->srcmap));
+
 begin:
 	ret = ops->iomap_begin(iter->inode, iter->pos, iter->len, iter->flags,
 			       &iter->iomap, &iter->srcmap);
-- 
2.39.5 (Apple Git-154)

