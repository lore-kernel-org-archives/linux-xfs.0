Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA33033EAEC
	for <linux-xfs@vger.kernel.org>; Fri, 21 Nov 2025 08:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763713107; cv=none; b=K6IIPBs+pQ++HV3E+abaLzXdRv5KAERZ1HHtjBX04X9I+RhUdLRQZ8xVWe9ZAcBtvdKmdn8SQiiAIGGVnw15/XKxWwkJ4kKCpzRREjuaKGaz3JWJWlrfn48rFTA9ic87AVE6iZUSR0J7ETMleWyH0MqJpRR6mIKgj35Zm/DzFhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763713107; c=relaxed/simple;
	bh=IQk4UzcYY75MLGhtAKmFDWXe3EWxpLfeGLiZbBZmOTA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ICVkKCgOHQ3zI6B2OLg2+E0lN6Y9hZ6vl/qFVTy5+aqEcAWxt3DT4n3ypkZBSCZyBj49rYwFy7MlW8Coursq0ngwEyA7ci7sv9C6INwG0OH+QmBa7NyNrZ808h1riBd/WmCSNxYNaUEFYZe4UXQiDvGZSwApKK/yoL2KOci2Yh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YEWAdUlV; arc=none smtp.client-ip=74.125.82.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YEWAdUlV"
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-11b6bc976d6so2581360c88.0
        for <linux-xfs@vger.kernel.org>; Fri, 21 Nov 2025 00:18:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763713105; x=1764317905; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I9uQUsysFrv2eFtHnu17b6ejhzRgB/BOqXyxbR99K8c=;
        b=YEWAdUlVaOH/noOIugrjpzRr5Z1TkuhaccO7HwzLy1gI97l8y+2OepqjkoO6I5Cwk6
         XjKxrNtnzx1FJ6TbFyDq5L49ltJZhic8K2XdrHgBydXhkuq9NAXZNW/VkDyO6V1ymexK
         2mMUF9INciXOS0RHLhDvk366rKeNzvCjbpzRM/w9Af/lnI9owrXlBCqLuirEZZVm6lY3
         VXc5bOmRgZTZSfO7azHtL5phDBkugI5J7kYA6kxu1EQl3giLOZ18uDUqaAPGnywdKn9D
         M07J51EQ2sBHSOrCtD/Q9bp7dtLCTAOZx3hh0cRK4DuN0+j/7xXaFf1vlnPYS3KLA8Se
         t9LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763713105; x=1764317905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=I9uQUsysFrv2eFtHnu17b6ejhzRgB/BOqXyxbR99K8c=;
        b=w2vzGWdG1U3Qewng7nz0a+PVEUwnSCbw1HvQth8qkkEVK0I/GDCGpfMFgnkDlE7A+E
         0dRJCuRHvfP/AWLHYjAgvCNsgWqj5xFK9EIzaIwJ40wR6Hdf192GT43IOXXu7aNUH+Bp
         Hm5KRqwEggHXyk3vZV8BuOlR3ZmLDIwp481ZVE2BFJw6FnyDPgIFvklC5pRGb23PM/ZP
         743dMBWhzX4XNr7rx0K0cBf6kMk/NNI8tKJY+kIaR5DYQl2zPYHCQ9NaCqu25T5uYIXs
         eol64nHR89KOr3m0nXvVRxADH3QTmlEXcokRjnbd2oUSvlPK3bTQRI8mSs5Xsavgx5ag
         2jzg==
X-Forwarded-Encrypted: i=1; AJvYcCUesdarwYdWF/lwiL2bMdHjNlZVve+lN2+jmmMBV7BH5YqK4AFPfw1eYEVD/Sz4jHXij9qIHr/7bVM=@vger.kernel.org
X-Gm-Message-State: AOJu0YypDtUDyf6ho0EzYULwjvygU6SxjxyRT4uVUwM2RzT/XfVqmL6B
	yQo93HxkuC/qY2x/mfjRksP5ItZwu+ukyyEcCdgIci1VRA8TXyOrfGio
X-Gm-Gg: ASbGncsw76JMYNvZc32moFcyky/joMUdnNQCxnALCFJyVRu8Hn/qeYqYQw/PY9L/h+v
	+IAx9qYou+YtImP7peVIYkMOn6JUk27IQOmUbxm/qmNnASA1cgaoEfbhk8J9Ns1Et08dDlyRoWp
	ZJ0jC1d5gv/rWlbfCFgTIrs1ELDM3YSfJkrL98fyBIUl2qfhj8BAZ7eP44S11WC3316bLR/iwJh
	j5AOAAVAJ5WyoZgjDZc2ef/ipa7VcQVOf4den4WJ1mGbkvtVN/YAaVkHI3QgeSqsgpQNl6uqbp2
	ujxG8IaIR+4hEom75eG1X5cZsLSWeb/OrtvhKxNsTJQaLvk1iER4TXy4XJ1J1KMLDxekN1ksN3j
	bNm68NxbbNKqpqx7U2UZl18NwE2LrFhUGl25N0798fzZy9BfSRCQiqaDZqU/gjOSodJZx+louX5
	038K76b/2RnwSZT57692usi8ZL9w==
X-Google-Smtp-Source: AGHT+IHMz3ddZnRtvaJ/THHwP1wUMl1t1R0JBJZczRRfd42vINt7DVj8VsCW+6dMTczCFjZ0JXIsxw==
X-Received: by 2002:a05:7022:a93:b0:11b:a738:65b2 with SMTP id a92af1059eb24-11c94aefcabmr2003355c88.5.1763713104659;
        Fri, 21 Nov 2025 00:18:24 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.43])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93e55af3sm20997352c88.7.2025.11.21.00.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 00:18:24 -0800 (PST)
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
Subject: [PATCH 6/9] fs/ntfs3: use bio_chain_and_submit for simplification
Date: Fri, 21 Nov 2025 16:17:45 +0800
Message-Id: <20251121081748.1443507-7-zhangshida@kylinos.cn>
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
 fs/ntfs3/fsntfs.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index c7a2f191254..35685ee4ed2 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -1514,11 +1514,7 @@ int ntfs_bio_pages(struct ntfs_sb_info *sbi, const struct runs_tree *run,
 		len = ((u64)clen << cluster_bits) - off;
 new_bio:
 		new = bio_alloc(bdev, nr_pages - page_idx, op, GFP_NOFS);
-		if (bio) {
-			bio_chain(bio, new);
-			submit_bio(bio);
-		}
-		bio = new;
+		bio = bio_chain_and_submit(bio, new);
 		bio->bi_iter.bi_sector = lbo >> 9;
 
 		while (len) {
@@ -1611,11 +1607,7 @@ int ntfs_bio_fill_1(struct ntfs_sb_info *sbi, const struct runs_tree *run)
 		len = (u64)clen << cluster_bits;
 new_bio:
 		new = bio_alloc(bdev, BIO_MAX_VECS, REQ_OP_WRITE, GFP_NOFS);
-		if (bio) {
-			bio_chain(bio, new);
-			submit_bio(bio);
-		}
-		bio = new;
+		bio = bio_chain_and_submit(bio, new);
 		bio->bi_iter.bi_sector = lbo >> 9;
 
 		for (;;) {
-- 
2.34.1

