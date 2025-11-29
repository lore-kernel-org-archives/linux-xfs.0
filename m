Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29EB289824
	for <linux-xfs@vger.kernel.org>; Sat, 29 Nov 2025 09:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764406940; cv=none; b=Uhu9RKnz8pdsRgkBDfSpZIJODpjXvlTNR72UwMuNtTTv0UT53nONKn0W6IDUaH4gwuBvLHBWoebbEVcH7j8N7RPutsuh5FVnZeRnh9ZZR5vv8pvTGWVXcETw9qwC2Z+Xti9uCSbSZyS5eKnHc0K8bxX3H2B42IVaoc+ot+X6Jss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764406940; c=relaxed/simple;
	bh=MIUxfeIlXsLJb7D1x07khmxiQaV6FMQZLzsNI6cDMOY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EIX7S9zsVhKzizBpEptHkyyZM45oL9XHk0W4GvFY0nXthJyt92DuFU18iWKcriZckMvIbdnsuJ3yHZERSjw3eIuWO4Ex0dwrXlWsFZzN1gSyxqCojZ88BQop1TkH8UNafdLfneoCnWBjAFS3+RUNQGh55FJXOwKzLrLvyVASSSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LWAD7FOh; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LWAD7FOh"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7aab7623f42so2804951b3a.2
        for <linux-xfs@vger.kernel.org>; Sat, 29 Nov 2025 01:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764406937; x=1765011737; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rZsPDOjyUTRUehf6LhbOb026Dy93eapwVzPzgOc2prg=;
        b=LWAD7FOhwxa9hK+N/TjbMpaozNTbYaOFlFfBFIkFx3IRXMvFPQxK0dBvqeuprMX8hQ
         WtWIKhyhJdL7tgKbRz4kjA9XtQ0xCyuZ7Us8cRZuTSRdyYizUVED7L6DNAzm15FBB5+X
         G5asqaq3DDVlM/G0dBAPwI0DSmb1ll6qtEwsg2iCDXZi+WJJDMh8w+iMQwrmlH1fUp0M
         ZU8ghg2rx/1HT1LpWHFAMP66d0PvkRhjwjyR9UzTcYnZTtVjAi+zUY+A8WK5JSkbXJwd
         i6e5F7qsIkGgfsqQ4oj8zEgP7PtrSoMRVbyWUr+snjj7SZqW95SR+gLU9WacDEe61W7m
         +8+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764406937; x=1765011737;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rZsPDOjyUTRUehf6LhbOb026Dy93eapwVzPzgOc2prg=;
        b=OeI10aeJ9hMGuFeH9cd+dyPS0HwMxN02JeFfaZLjJerD++SibX/63P4HxhQC6nVAtu
         pYXQIeSN7RJ0B97OWCZ61N3SMsIQPrXd6csuPO9fKzkGDH+ADQvdVM70X+m/4B0Y5QKF
         2EjAKWj9KGKasosyk1xJePCYI9yAMfB931a45YYqt/Lkz6VIKIxzWtN+Ft+LEiwMkA0T
         SgQhLCnNyR7oe8rzYEOo7OTEZ82uNhExtvDyGgY/wuah42u8A13JCWnLzsiFcMFMokKw
         rcimrXyaUMS0EbXNEJZ5hZrJU1VGa+Z/OW5RRGeWeNGaoaFCTGMRKsQMGZcWrzwXinWn
         AsJA==
X-Forwarded-Encrypted: i=1; AJvYcCU4Ql5wbNQJMP1ce0yKwu8BiuC4EgNs569C2lofEOil5AqVT8MaY44hfiJP8yYD4W4Daguyw1vdbTo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9IKLiHLJzzfE0KUB3CEM0cZ97+PlD20JKNIpWI1DfRIuHehAL
	5gRNZRFlrzwVvR2wHSikY1QLAUlI39CFrKhXNH95RvFkD7a1qiHqoKAj
X-Gm-Gg: ASbGnct6piXV4kjyrcPh1LmJG1Gdg0jN78KcXjqDRZZHDaC0QepfKkWX3Z6VjNCKZJW
	Jk7Y5jFfwk/aaHtXjWfnaPFgbXV6a+55I7QFXYTIWlMPm7KVqHJc5emTOgqrC92+F1DmATSWR7i
	WPtn+7L/xhcpu/3dmFHkgJjQArXlvhh+aY1T6p/m+PwiU8b6qu3m0CBJiza8VFlOEo3wntRWIpc
	bV16f2WkmhhQiBrOowRQGUxqCElF85W1ncMNZa2enYl3/ji0+H7/Insvut9Zs4ta/6iF/zGgUJH
	IGSqs+RE7QlFvrBMtgXs7iDeHBLXoWSgIgEqMPi7qBsOK9zXw3aT2O4J2dsDa96A5Ow/k7VCtwB
	aL6O9ZC37AkQmhnBuyu4xFuDONNZlDkYo53kpaHT0+2SLFOFev2BK9uH8yNwjO2TJLNsOgZeXDW
	CPu8tRb9nqsI9GqpzU7vvSlStpI0Ob20jZ15/n
X-Google-Smtp-Source: AGHT+IHpE1uuYkahAmmHKZA5JS6JfSHwBl8orO/VCsXf8iMEXJ8J7PutjW87+hKd6ib1GUoYGhEBPQ==
X-Received: by 2002:a05:7022:41:b0:11b:b1ce:277a with SMTP id a92af1059eb24-11c9d8482b1mr17984181c88.28.1764406937164;
        Sat, 29 Nov 2025 01:02:17 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcae73bedsm28114394c88.0.2025.11.29.01.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Nov 2025 01:02:16 -0800 (PST)
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
Subject: [PATCH v3 9/9] nvdimm: Replace the repetitive bio chaining code patterns
Date: Sat, 29 Nov 2025 17:01:22 +0800
Message-Id: <20251129090122.2457896-10-zhangshida@kylinos.cn>
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

Replace duplicate bio chaining logic with the common
bio_chain_and_submit helper function.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 drivers/nvdimm/nd_virtio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index c3f07be4aa2..e6ec7ceee9b 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -122,8 +122,7 @@ int async_pmem_flush(struct nd_region *nd_region, struct bio *bio)
 			return -ENOMEM;
 		bio_clone_blkg_association(child, bio);
 		child->bi_iter.bi_sector = -1;
-		bio_chain(child, bio);
-		submit_bio(child);
+		bio_chain_and_submit(child, bio);
 		return 0;
 	}
 	if (virtio_pmem_flush(nd_region))
-- 
2.34.1

