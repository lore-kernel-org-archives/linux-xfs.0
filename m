Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D773624C8
	for <linux-xfs@vger.kernel.org>; Wed, 14 Jan 2026 07:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768376518; cv=none; b=AcELtSld98I/ETkV6qIUku37bNjPhOYLUIw/usTmYWRAC6Ul0gikhfXpT3kKHjwmYasa8mK/6WoiObcX9Cdc3AhF5kZJEOzbYF/WfBYTrZERocUhERlhHMCLvEL3TDgNeW4McUuR0B7f/rEJ2PUXcOfOxn/IZEUpxqKR+7Uw9m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768376518; c=relaxed/simple;
	bh=+H3aAh+H9MYWBdA3obltdIOF5BErV3p/RdjTsRHDREA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZMzqfr5AKU2l6gROisygyDiR7BgGzLgBZPkdzjvy54OkJBpKusamC+J/FLhpP2+qzDmV2vnzwacb+twsvntVJa/NiBTsbIas4lquuOEsbgn/fEm0qMjerj7gTRhxESS3PJ0jXLT6WuLbALo/75RtGVghZHA3eu3F/e4EDugKnyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ICkBm14S; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ICkBm14S"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-29f102b013fso76537185ad.2
        for <linux-xfs@vger.kernel.org>; Tue, 13 Jan 2026 23:41:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768376505; x=1768981305; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=snBrbkipsnG2NrPPSCJsD8qwO3TtVqHYjFPmR+kbTww=;
        b=ICkBm14SWIotz6yZrsGoMpdITnqLw483a4lo4R7iflmomOVI5ibeA/69PxFJJwuq0M
         ZBYwMdF14IzJLYOfdWNrsV8wXzLHBPI5+vRvdrtvv1iwfHu/8UiBQMvQi8nRaz95W/99
         H6LA0p4EiucanWHc5Sd1tjuB95X8TrL6bZp7jHFuer0plZJabBfEVpCevxIKYBZYymoF
         WiC8pC2CqkOiDuBbADjI8ApJXno/nMgPgPArpkxM7txXvzdHOhk2Lb1VypkLhDtOxbW2
         zZ5l2MaSPivQJiD7JSfXf40doDhf6SJBEZGJOOh9gKI7uIItwpJsbF0wbEnSBvJ8EvpR
         LfTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768376505; x=1768981305;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=snBrbkipsnG2NrPPSCJsD8qwO3TtVqHYjFPmR+kbTww=;
        b=ZpfipQAIdypexbd1YI8GKAhVRGQX/nm2AAVrKaZsOygN1gWs0yPT7EBxiaR3SQ21Am
         Nxgkk8wrNuppeVx9oaZO7Q072s4bqYz0Vao7TTv4vkOsw+5ZzUxxj/QzToWIb58uHZP9
         C06+8hOTX+47vB1rDXJOepsIwx+Ehy420ztcY68v9YgDRZqpLN/MNao3XT2ooS5qV7qq
         l0vsuDgNjGldspObzLfzDFwo0UjwQ63Rzw/Z2tbDUQfI70877ZCiLRmbVa5Fpi15yzL5
         aibGIZ0wOfRswfom7D3F0OYzGSeKs+NZa/hQAAdgvgEqPAz3rnqzQodGKv2ge3DN1NQd
         zs5A==
X-Gm-Message-State: AOJu0YxARKPdgSKV9cdBqYchPooP3YoTsB3SvYchlnroK35qGN1h79eQ
	iLmLB+gfbpaNp4CVFsennxw8YYdF3qouICQuqxKaHGo6RZIUpkaJaUCj
X-Gm-Gg: AY/fxX6i3P91g6z9F893PhNA3e+Nl4ne5Vup3V6N8LY3Xq2i2Wn9LPQFSsTvkfHe5oh
	vCOg6/3geAbJ6kRbdDRHHwUtkeAgMCL9hTnLN4+Vz7uhHRE7MsGJ8WWtmt/ZfcJ0uk18FRXhonO
	Z7va5s+CjA1TfLd0xHBHF9UzosKacawLAVl3MyhWzO2TCbvfJk0A+Ek4DCCZ4Lz5Lr4G9GtKgjd
	7zIct9dzjoS52umNJ1lhQY5HAknf/oWN6RYIacVwTiQS5cJJwUJu6uoeSkMY40lMUs4qjm1buh7
	VYEqfwrfBJ1tkYzjEU6SjqpOsfl7c6ZdD5Ji4fHbHVnYaBb1eg2z79xSjH5sxF7bg5M7dkIweDg
	uW5hFHujoNFTQqAALw3KBe/FBqIzNP12DjmcXvyXRXHDa5wcDPWNzAyoy66Qt2JcyW49uZpQilb
	2ayV9KMJZOvaozYNqiWY7io/d8+Ag7kw==
X-Received: by 2002:a17:902:d506:b0:2a5:99e9:569d with SMTP id d9443c01a7336-2a599e9579amr22476575ad.18.1768376505152;
        Tue, 13 Jan 2026 23:41:45 -0800 (PST)
Received: from n232-175-066.byted.org ([36.110.163.107])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cb2debsm221476875ad.65.2026.01.13.23.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 23:41:44 -0800 (PST)
From: guzebing <guzebing1612@gmail.com>
To: brauner@kernel.org,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	guzebing <guzebing1612@gmail.com>,
	Fengnan Chang <changfengnan@bytedance.com>
Subject: [PATCH v2] iomap: add allocation cache for iomap_dio
Date: Wed, 14 Jan 2026 15:41:13 +0800
Message-Id: <20260114074113.151089-1-guzebing1612@gmail.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As implemented by the bio structure, we do the same thing on the
iomap-dio structure. Add a per-cpu cache for iomap_dio allocations,
enabling us to quickly recycle them instead of going through the slab
allocator.

By making such changes, we can reduce memory allocation on the direct
IO path, so that direct IO will not block due to insufficient system
memory. In addition, for direct IO, the read performance of io_uring
is improved by about 2.6%.

v2:
Factor percpu cache into common code and the iomap module uses it.

v1:
https://lore.kernel.org/all/20251121090052.384823-1-guzebing1612@gmail.com/

Suggested-by: Fengnan Chang <changfengnan@bytedance.com>
Signed-off-by: guzebing <guzebing1612@gmail.com>
---
 fs/iomap/direct-io.c | 135 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 132 insertions(+), 3 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 5d5d63efbd57..b152fd2c7042 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -56,6 +56,132 @@ struct iomap_dio {
 	};
 };
 
+#define PCPU_CACHE_IRQ_THRESHOLD	16
+#define PCPU_CACHE_ELEMENT_SIZE(pcpu_cache_list) \
+	(sizeof(struct pcpu_cache_element) + pcpu_cache_list->element_size)
+#define PCPU_CACHE_ELEMENT_GET_HEAD_FROM_PAYLOAD(payload) \
+	((struct pcpu_cache_element *)((unsigned long)(payload) - \
+				       sizeof(struct pcpu_cache_element)))
+#define PCPU_CACHE_ELEMENT_GET_PAYLOAD_FROM_HEAD(head) \
+	((void *)((unsigned long)(head) + sizeof(struct pcpu_cache_element)))
+
+struct pcpu_cache_element {
+	struct pcpu_cache_element	*next;
+	char	payload[];
+};
+struct pcpu_cache {
+	struct pcpu_cache_element	*free_list;
+	struct pcpu_cache_element	*free_list_irq;
+	int		nr;
+	int		nr_irq;
+};
+struct pcpu_cache_list {
+	struct pcpu_cache __percpu *cache;
+	size_t element_size;
+	int max_nr;
+};
+
+static struct pcpu_cache_list *pcpu_cache_list_create(int max_nr, size_t size)
+{
+	struct pcpu_cache_list *pcpu_cache_list;
+
+	pcpu_cache_list = kmalloc(sizeof(struct pcpu_cache_list), GFP_KERNEL);
+	if (!pcpu_cache_list)
+		return NULL;
+
+	pcpu_cache_list->element_size = size;
+	pcpu_cache_list->max_nr = max_nr;
+	pcpu_cache_list->cache = alloc_percpu(struct pcpu_cache);
+	if (!pcpu_cache_list->cache) {
+		kfree(pcpu_cache_list);
+		return NULL;
+	}
+	return pcpu_cache_list;
+}
+
+static void pcpu_cache_list_destroy(struct pcpu_cache_list *pcpu_cache_list)
+{
+	free_percpu(pcpu_cache_list->cache);
+	kfree(pcpu_cache_list);
+}
+
+static void irq_cache_splice(struct pcpu_cache *cache)
+{
+	unsigned long flags;
+
+	/* cache->free_list must be empty */
+	if (WARN_ON_ONCE(cache->free_list))
+		return;
+
+	local_irq_save(flags);
+	cache->free_list = cache->free_list_irq;
+	cache->free_list_irq = NULL;
+	cache->nr += cache->nr_irq;
+	cache->nr_irq = 0;
+	local_irq_restore(flags);
+}
+
+static void *pcpu_cache_list_alloc(struct pcpu_cache_list *pcpu_cache_list)
+{
+	struct pcpu_cache *cache;
+	struct pcpu_cache_element *cache_element;
+
+	cache = per_cpu_ptr(pcpu_cache_list->cache, get_cpu());
+	if (!cache->free_list) {
+		if (READ_ONCE(cache->nr_irq) >= PCPU_CACHE_IRQ_THRESHOLD)
+			irq_cache_splice(cache);
+		if (!cache->free_list) {
+			cache_element = kmalloc(PCPU_CACHE_ELEMENT_SIZE(pcpu_cache_list),
+									GFP_KERNEL);
+			if (!cache_element) {
+				put_cpu();
+				return NULL;
+			}
+			put_cpu();
+			return PCPU_CACHE_ELEMENT_GET_PAYLOAD_FROM_HEAD(cache_element);
+		}
+	}
+
+	cache_element = cache->free_list;
+	cache->free_list = cache_element->next;
+	cache->nr--;
+	put_cpu();
+	return PCPU_CACHE_ELEMENT_GET_PAYLOAD_FROM_HEAD(cache_element);
+}
+
+static void pcpu_cache_list_free(void *payload, struct pcpu_cache_list *pcpu_cache_list)
+{
+	struct pcpu_cache *cache;
+	struct pcpu_cache_element *cache_element;
+
+	cache_element = PCPU_CACHE_ELEMENT_GET_HEAD_FROM_PAYLOAD(payload);
+
+	cache = per_cpu_ptr(pcpu_cache_list->cache, get_cpu());
+	if (READ_ONCE(cache->nr_irq) + cache->nr >= pcpu_cache_list->max_nr)
+		goto out_free;
+
+	if (in_task()) {
+		cache_element->next = cache->free_list;
+		cache->free_list = cache_element;
+		cache->nr++;
+	} else if (in_hardirq()) {
+		lockdep_assert_irqs_disabled();
+		cache_element->next = cache->free_list_irq;
+		cache->free_list_irq = cache_element;
+		cache->nr_irq++;
+	} else {
+		goto out_free;
+	}
+	put_cpu();
+	return;
+out_free:
+	put_cpu();
+	kfree(cache_element);
+}
+
+#define DIO_ALLOC_CACHE_MAX		256
+static struct pcpu_cache_list *dio_pcpu_cache_list;
+
 static struct bio *iomap_dio_alloc_bio(const struct iomap_iter *iter,
 		struct iomap_dio *dio, unsigned short nr_vecs, blk_opf_t opf)
 {
@@ -135,7 +261,7 @@ ssize_t iomap_dio_complete(struct iomap_dio *dio)
 			ret += dio->done_before;
 	}
 	trace_iomap_dio_complete(iocb, dio->error, ret);
-	kfree(dio);
+	pcpu_cache_list_free(dio, dio_pcpu_cache_list);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(iomap_dio_complete);
@@ -620,7 +746,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (!iomi.len)
 		return NULL;
 
-	dio = kmalloc(sizeof(*dio), GFP_KERNEL);
+	dio = pcpu_cache_list_alloc(dio_pcpu_cache_list);
 	if (!dio)
 		return ERR_PTR(-ENOMEM);
 
@@ -804,7 +930,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	return dio;
 
 out_free_dio:
-	kfree(dio);
+	pcpu_cache_list_free(dio, dio_pcpu_cache_list);
 	if (ret)
 		return ERR_PTR(ret);
 	return NULL;
@@ -834,6 +960,9 @@ static int __init iomap_dio_init(void)
 	if (!zero_page)
 		return -ENOMEM;
 
+	dio_pcpu_cache_list = pcpu_cache_list_create(DIO_ALLOC_CACHE_MAX, sizeof(struct iomap_dio));
+	if (!dio_pcpu_cache_list)
+		return -ENOMEM;
 	return 0;
 }
 fs_initcall(iomap_dio_init);
-- 
2.20.1

