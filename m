Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9AD2ED161
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 08:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318776; cv=none; b=JD/YKFY5/nTEMmg6K2b2UbxDmBcyRRQz01tWfP+Nv4j166xFvcYF6M/kd9h73Wdh3oeh7kKUjU1gW9D1uYjgvv3UdqlT6Fa0wOWDH9blKzyBvQVA3qxT8tt8Y6K8tV2WkZCz4++nlwnZ73l2DgM2WQjH3gXMyFZ4wJZf5oTpvZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318776; c=relaxed/simple;
	bh=JLIdNXPMejF737Jv1xzF5GicNRibkuRDb9iX4pmjoI8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Hdblm6XZNwx1+fXXiRVWeDXbtfWNjrSNWb5HckTM6edy60RaBHBGw54zuunZMfa338pXNihYzCn6aJqf881cbrnnDFAfuLOGHMM3iNh9df5giZd0tHlZsuuVn/ZM71Qpl9U7AZgV7pGx1RBEl2+OeKd/UF19PeU9yD7JBCmQdzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e3h5NxD2; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e3h5NxD2"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7b7828bf7bcso1846148b3a.2
        for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 00:32:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318773; x=1764923573; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3B+NwUppxNtx5dO3GeNOAlGv3QVGc2Q+cteUdMRhiTw=;
        b=e3h5NxD2+pjCU+SL4YYCXLOBvl2ZfbIVgZx0v94A5jYGGMy2YxzoJ2BvRB7sgYqCdG
         apEykxsswt4QE1e00J7/lg5wXxqaMckUKsKxLIzybNLFlVgVWGDFACNNWv+GOn8a1L8o
         lTIX9cnHDuZU6moNC2Mdj4bmo8eT8y5ikd79d5IfF03notzdK4Ug8TgTE9SeYdrqnMy0
         TXU4PRVHxeX8OJWhf8QHfhfDRnfR8kIZ/9I9MnoVuoSK8rYuvGayN8OcY+3lOOJXkS0b
         6sed7j4zSDFJ81iwNkdCcFDzQzIkXpi+lm/oZPlfQXMghV5QtreY6YfBaYgs0Qr3VYRG
         gaQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318773; x=1764923573;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3B+NwUppxNtx5dO3GeNOAlGv3QVGc2Q+cteUdMRhiTw=;
        b=VdKVst1+emRBr+8gs3WzfClvK4EbWXDeKSw9WJSP/VJ7vAAUDsYBw7jh4S79j5dFrQ
         05E4VKkFblN3BWtJXwzvDu7D6bOjx9MTLtOay7MKqFEuuEnKuyUXjWB1MT1CLppkyF0j
         lC0cg6EGukUshTdlm34Eoa8PX7wT11QuGpCUCZzjfsZVRI0Ga2R6PQ5wVcDm+urANtb3
         tr3QqoxQo+iIv0H1QaZoyZPK2IRKOBtonOu5/IZpqUffKsGeUZ+oLlzXkY5MUe9+HZdA
         o+uwe7N69brREYmkScb196jw/Bm+xQXXINgiZ2Z3jxJqAbhMlQVMOirv2alC5iPi90X/
         cn+g==
X-Forwarded-Encrypted: i=1; AJvYcCUwg1iBXdGjj0PLKBH5IGUvvBeQE5+Vv9w0IlPY6m0ngc0hYVS0a4jhjhsZo9ZgmxVlwZVy0D6wYoc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYHRJKRxJnmO3NqY7XsgEbTMqJJug6ZvRFAR7/Z6j52S0auJ16
	B/inzvqgjTytqGXgii+TyLxGxsrSADCmPHc8pk1f8rTMO0FYnMWPiqSa
X-Gm-Gg: ASbGncvTxyvP5se6GEJr0U1KYnuDDZdn68uobamV2o9CPbRK3d7UGYomJH0ajFzdif5
	nd6VNhiiqeMS8zPBImVku+EticPO8K/XmtxiYQ8ur5ZCNJevc8t5OL7tACzvFIwpqm1BL6xsbpN
	HLTAjEiMi8WsxeXz+5+9uM4lZuUKICrlB5r6Q8JZkqVN+5YE3Moi/65yc6DaALALBXYa58JTeMp
	vDMGyJu25oaMb/rGPZGVS7SQiuCoYAR3Uoisqv1yGOEvblYnsE+spmSM58V3PZQ5az3s+y7aI3O
	D3gI77inqEjFvg+KwbGZQvfyPJM9PefWz2nlGz5mSIBwm/+w7DRHOV2jXwwGek9cR2sV3SFpOc+
	QmaWcGdkZw+ZchDfgfLKjRCFlJ2eGmD127bFH0Qhox6nf/rFdAWkprd9Pf0Paa0pDl/znbdLgsk
	gi5CjKgdTKLy2FRdPixHLbk9Vd8g==
X-Google-Smtp-Source: AGHT+IExpRIXm/rx9JSaduyyoo433z0edlCZgYRCixn+2l+uiE9AooEQRv+QW8QlPPxN5lYcC0yJLw==
X-Received: by 2002:a05:7022:2390:b0:11b:2de8:6271 with SMTP id a92af1059eb24-11c9d8635bcmr22508225c88.39.1764318773026;
        Fri, 28 Nov 2025 00:32:53 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:32:52 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: Johannes.Thumshirn@wdc.com,
	hch@infradead.org,
	gruenba@redhat.com,
	ming.lei@redhat.com,
	siangkao@linux.alibaba.com
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	gfs2@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH v2 03/12] md: bcache: fix improper use of bi_end_io
Date: Fri, 28 Nov 2025 16:32:10 +0800
Message-Id: <20251128083219.2332407-4-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251128083219.2332407-1-zhangshida@kylinos.cn>
References: <20251128083219.2332407-1-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

Don't call bio->bi_end_io() directly. Use the bio_endio() helper
function instead, which handles completion more safely and uniformly.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 drivers/md/bcache/request.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index af345dc6fde..82fdea7dea7 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1104,7 +1104,7 @@ static void detached_dev_end_io(struct bio *bio)
 	}
 
 	kfree(ddip);
-	bio->bi_end_io(bio);
+	bio_endio(bio);
 }
 
 static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
@@ -1121,7 +1121,7 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
 	ddip = kzalloc(sizeof(struct detached_dev_io_private), GFP_NOIO);
 	if (!ddip) {
 		bio->bi_status = BLK_STS_RESOURCE;
-		bio->bi_end_io(bio);
+		bio_endio(bio);
 		return;
 	}
 
@@ -1136,7 +1136,7 @@ static void detached_dev_do_request(struct bcache_device *d, struct bio *bio,
 
 	if ((bio_op(bio) == REQ_OP_DISCARD) &&
 	    !bdev_max_discard_sectors(dc->bdev))
-		bio->bi_end_io(bio);
+		detached_dev_end_io(bio);
 	else
 		submit_bio_noacct(bio);
 }
-- 
2.34.1

