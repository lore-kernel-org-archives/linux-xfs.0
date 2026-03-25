Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B3923183F
	for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2026 19:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.139.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774467556; cv=none; b=Kdra3yKkUJDbu2QfYHq+70oXsB92GlgyQGySxaAzYM4pBZ55cVdRFM36oWfhSbT26fspNpL3NCD8wKoS39VThBes1TsOdc8qV6VO/XDkVA7s6C4IkO1pv9h9LttBLeQevFbHdqgAQjs9oxSSrYKhY4p9Ek20Ko57LN1SgJ3VoMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774467556; c=relaxed/simple;
	bh=/KDtCfPcROGMHktI+sYIoy1sJXxmr+t5YwMIoFyxNlk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=S+RPCHG+zSiBGTDeVVajaUQy9Je+9QGrY/v7ZImH9sQUw2NRxv5w0M3IwkrqFX6l4E1MSvvgWwG9CPpLU6OedD6pYDCzOe7eoRl7QzCSjjVB1sTpaT/KKGGGVaMPx7o24f35dlVtdFxj4Q3Waq1Bkg1TaToB19aXQxciVXWOfLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu; spf=pass smtp.mailfrom=columbia.edu; dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b=W1TdmHAg; arc=none smtp.client-ip=148.163.139.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=columbia.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=columbia.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.b="W1TdmHAg"
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62PJSjcT937543
	for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2026 15:30:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=hCcp
	+9kU8miIdEe20LAeTwI4JkSmuzG2q+hEwpZi3Vg=; b=W1TdmHAgxdl1P3Jt415K
	mDMuXC1UZ38fH1pCdmPKkiGohuKsIY1BtpAKPFqF+lIJQhgQdYdxNmq0tBln+Sxi
	fPo2lZn/xTrr7aF03NAH5D7o5dhQ7+BnqTNuev7JxaZBdfr7G70Mgv6aC67YHW6I
	jiNkss/3Gc3BnDCLsPz4kOq4H0P3arP/tm4ywo+FaBzzT+wYpZi3+xYTVHK+aRCm
	JPQkw9rJlEHkxRJkqF13de3U36pc5j9+MK4SNkjL0L6/hXAbd+/klpJMM5KCVdqx
	7xFJfUckpL/QeBuUOmtLU/DH2jbtDRoN06GcP8GdoC+DVlnJMZbwsJFM28SMa1+f
	IA==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4d4h98ayhq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2026 15:30:41 -0400 (EDT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-50b4ca7e7c2so7143401cf.3
        for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2026 12:30:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774467041; x=1775071841;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hCcp+9kU8miIdEe20LAeTwI4JkSmuzG2q+hEwpZi3Vg=;
        b=WUsYmsry2SZ6mA2JYEOPzKJqtaHayBWfiw4M/JeqAxjQuRf3V9xnTUdkzsl5BApRBf
         zzxgukRTu0ebFQULmCkyNmfADkhARkj/4BIqmpCE+RS20XazcXFRNsgyLgOWL1yF4ofq
         0ds4Ar+5DOd0jSAJeJFDTuMqfYFS/3cZeyyrqA2ICUBN2hovQgVFA5ZSCpar9ZkGl1HI
         DTCFpl9prW21cHo2+3owBoxK2B0/i41ygS83gMDOFa6Z+u6KNRlrEWqXAaEOcVcfi7FT
         uKm1OryGQ9EO7jS+77I42m264K0o/I694aS+HaweI1EBE93gT7B59SxgU9hUnswqAUjN
         G1rw==
X-Forwarded-Encrypted: i=1; AJvYcCUBrbgyoymEsN4cvh4f9ygFNTOyUuhIBWKz9UM20utzlVdflW6zV1nptCAvEdjD/AdRA/KHqwfGTBE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlxZcvMca9sltg8JzPzcfua/IwoRmSJNbZSsE+NyZDhoFeZAH5
	ia3hH3y4KpWQaXuNVC/DMcmmfaoAijNTtSOqGmQZ5GV+jyzPsKVAlhsMh1ZmvPEXenCTcrzunSi
	DnEq9ybyx9qJRJ1/NCNelwtzzS6mgW+N75oOhRAyJDUCwmQ/qDkcma703KBYRj7XBmA==
X-Gm-Gg: ATEYQzz1Ei37zWg4yCR4DYIlUFIZQR8J6wJEIa4Bu6CaL4PBpdFlyMLXsSKAYrYCZzF
	WJmZuyPuDzzM59VLhb3uog/aHfa40q06KS5GCR6833cAGhEMdqAwhujnP5A4lahzF1Y3f0SeKNA
	ewORMaOY9JrmTNQM1trS14vNiUldyXjNPeeo6/6smeZfrhgy77W9xH/hPsfDKNegCuI+mWvn66X
	+MC/uXjMZB5UkkQf8BWxXKs3+2wRKZDUzCnPoAvTjx/dn0OA4BMQZmYMo2qcBGfBP+ZM7dpKOjL
	onWdJEu2CFVsCu3a4ECpj/PEOfC9+RKrUPwgoG/+NUiiy5NNv4qakwSl+osEgfh/BqMW62ZeHFF
	/ym1y9WDhI9/1tqQtTzWXbrDKSG1cMWbWzfcpdQ==
X-Received: by 2002:a05:622a:8356:b0:50b:4f75:c925 with SMTP id d75a77b69052e-50b80d34c05mr57540551cf.24.1774467040645;
        Wed, 25 Mar 2026 12:30:40 -0700 (PDT)
X-Received: by 2002:a05:622a:8356:b0:50b:4f75:c925 with SMTP id d75a77b69052e-50b80d34c05mr57539811cf.24.1774467040081;
        Wed, 25 Mar 2026 12:30:40 -0700 (PDT)
Received: from [127.0.1.1] ([129.236.226.199])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b9234e3a3sm5534221cf.19.2026.03.25.12.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 12:30:39 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 25 Mar 2026 14:43:00 -0400
Subject: [PATCH RFC v4 1/3] block: add BIO_COMPLETE_IN_TASK for
 task-context completion
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260325-blk-dontcache-v4-1-c4b56db43f64@columbia.edu>
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
In-Reply-To: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774464193; l=4684;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=/KDtCfPcROGMHktI+sYIoy1sJXxmr+t5YwMIoFyxNlk=;
 b=yUgCWQ4ZcEeNTx5iojZlwuLJ75/zRFsFdFta96TVVGE0YTzeH6B4RKXjHrIwyFGw3hTK3rhgt
 gf2gbHu8FZ6CWKrHyJPeTOd+yuu9FyglPNZhfk8bDp7xeu7U5SJLlSh
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI1MDE0MiBTYWx0ZWRfX7+/+Cbyp9nSO
 KbL0KLlr7ywt1b9lPE58cZgKDanfbH6Wpt87LYOe/mm08J1dJIW9bEQ+VQzwuhLypq9D0jbtwSx
 ZxDFCjFkD9llVdh1LMdllSJsMoDRp7hGzf+BQFr18H4FcPsYx1vjwRAwKJxmYEE8Fvd3POzVFcd
 dBZ3MzZhFgQHf8iRh4KAOeXzk/yJDNEQ5AalhiMt1mpUBUlBJmM5hGNCSguLij3Mml5BxOiXDPh
 eQYL+10snK9BI0qSuGtd5+75kcte35hDElilGEeFbUqp58tIPycI4vSXDi2pZc5PuqDY5N0kXN5
 tmQ81sXM2BMit/fdDw50lOx0BcNe4vvL16sQA31OBKwD1xFJ3GK5LsgOHUTjZCw/bQ5zKtnFOPO
 pe4vfZyQeanztiRQqdVm9lnUXElu8GIRsZACPob90uYH5TR4sjLUR4Bv/tvAqZJUs0LKio4f0iN
 4b4eCCYcVf+O19SkITQ==
X-Proofpoint-ORIG-GUID: 2khywW63sXgawwQ0ZQZgDJkqwpQVaX7g
X-Proofpoint-GUID: 2khywW63sXgawwQ0ZQZgDJkqwpQVaX7g
X-Authority-Analysis: v=2.4 cv=Ht572kTS c=1 sm=1 tr=0 ts=69c437e1 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=QOUmeeuX5y9IvSxXHa6D2A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=JfrnYn6hAAAA:8 a=QQSmTEQkt36Rj1JXOw4A:9 a=QEXdDO2ut3YA:10
 a=uxP6HrT_eTzRwkO_Te1X:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11740
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=10 lowpriorityscore=10 bulkscore=10
 clxscore=1015 priorityscore=1501 spamscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603250142

Some bio completion handlers need to run in task context but bio_endio()
can be called from IRQ context (e.g. buffer_head writeback). Add a
BIO_COMPLETE_IN_TASK flag that bio submitters can set to request
task-context completion of their bi_end_io callback.

When bio_endio() sees this flag and is running in non-task context, it
queues the bio to a per-cpu list and schedules a work item to call
bi_end_io() from task context. A CPU hotplug dead callback drains any
remaining bios from the departing CPU's batch.

This will be used to enable RWF_DONTCACHE for block devices, and could
be used for other subsystems like fscrypt that need task-context bio
completion.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 block/bio.c               | 84 ++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/blk_types.h |  1 +
 2 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index 8203bb7455a9..69ee0d93041f 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -18,6 +18,7 @@
 #include <linux/highmem.h>
 #include <linux/blk-crypto.h>
 #include <linux/xarray.h>
+#include <linux/local_lock.h>
 
 #include <trace/events/block.h>
 #include "blk.h"
@@ -1714,6 +1715,60 @@ void bio_check_pages_dirty(struct bio *bio)
 }
 EXPORT_SYMBOL_GPL(bio_check_pages_dirty);
 
+struct bio_complete_batch {
+	local_lock_t lock;
+	struct bio_list list;
+	struct work_struct work;
+};
+
+static DEFINE_PER_CPU(struct bio_complete_batch, bio_complete_batch) = {
+	.lock = INIT_LOCAL_LOCK(lock),
+};
+
+static void bio_complete_work_fn(struct work_struct *w)
+{
+	struct bio_complete_batch *batch;
+	struct bio_list list;
+
+again:
+	local_lock_irq(&bio_complete_batch.lock);
+	batch = this_cpu_ptr(&bio_complete_batch);
+	list = batch->list;
+	bio_list_init(&batch->list);
+	local_unlock_irq(&bio_complete_batch.lock);
+
+	while (!bio_list_empty(&list)) {
+		struct bio *bio = bio_list_pop(&list);
+		bio->bi_end_io(bio);
+	}
+
+	local_lock_irq(&bio_complete_batch.lock);
+	batch = this_cpu_ptr(&bio_complete_batch);
+	if (!bio_list_empty(&batch->list)) {
+		local_unlock_irq(&bio_complete_batch.lock);
+
+		if (!need_resched())
+			goto again;
+
+		schedule_work_on(smp_processor_id(), &batch->work);
+		return;
+	}
+	local_unlock_irq(&bio_complete_batch.lock);
+}
+
+static void bio_queue_completion(struct bio *bio)
+{
+	struct bio_complete_batch *batch;
+	unsigned long flags;
+
+	local_lock_irqsave(&bio_complete_batch.lock, flags);
+	batch = this_cpu_ptr(&bio_complete_batch);
+	bio_list_add(&batch->list, bio);
+	local_unlock_irqrestore(&bio_complete_batch.lock, flags);
+
+	schedule_work_on(smp_processor_id(), &batch->work);
+}
+
 static inline bool bio_remaining_done(struct bio *bio)
 {
 	/*
@@ -1788,7 +1843,9 @@ void bio_endio(struct bio *bio)
 	}
 #endif
 
-	if (bio->bi_end_io)
+	if (!in_task() && bio_flagged(bio, BIO_COMPLETE_IN_TASK))
+		bio_queue_completion(bio);
+	else if (bio->bi_end_io)
 		bio->bi_end_io(bio);
 }
 EXPORT_SYMBOL(bio_endio);
@@ -1974,6 +2031,21 @@ int bioset_init(struct bio_set *bs,
 }
 EXPORT_SYMBOL(bioset_init);
 
+/*
+ * Drain a dead CPU's deferred bio completions. The CPU is dead so no locking
+ * is needed -- no new bios will be queued to it.
+ */
+static int bio_complete_batch_cpu_dead(unsigned int cpu)
+{
+	struct bio_complete_batch *batch = per_cpu_ptr(&bio_complete_batch, cpu);
+	struct bio *bio;
+
+	while ((bio = bio_list_pop(&batch->list)))
+		bio->bi_end_io(bio);
+
+	return 0;
+}
+
 static int __init init_bio(void)
 {
 	int i;
@@ -1988,6 +2060,16 @@ static int __init init_bio(void)
 				SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
 	}
 
+	for_each_possible_cpu(i) {
+		struct bio_complete_batch *batch =
+			per_cpu_ptr(&bio_complete_batch, i);
+
+		bio_list_init(&batch->list);
+		INIT_WORK(&batch->work, bio_complete_work_fn);
+	}
+
+	cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "block/bio:complete:dead",
+				NULL, bio_complete_batch_cpu_dead);
 	cpuhp_setup_state_multi(CPUHP_BIO_DEAD, "block/bio:dead", NULL,
 					bio_cpu_dead);
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 8808ee76e73c..d49d97a050d0 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -322,6 +322,7 @@ enum {
 	BIO_REMAPPED,
 	BIO_ZONE_WRITE_PLUGGING, /* bio handled through zone write plugging */
 	BIO_EMULATES_ZONE_APPEND, /* bio emulates a zone append operation */
+	BIO_COMPLETE_IN_TASK, /* complete bi_end_io() in task context */
 	BIO_FLAG_LAST
 };
 

-- 
2.39.5

