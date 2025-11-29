Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B038275844
	for <linux-xfs@vger.kernel.org>; Sat, 29 Nov 2025 09:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764406902; cv=none; b=X2rbuVTUaxpJqK6oZpun77KDgjUcV6RbHgqbKjF6YWghAafpGkJmDbzqAIGbnA8aAkLSwnxVQPljpUTCiq7+VZR0YdTJy0404ZidKI9B1n1DxjokB0veUbj+NjbrLTRPGJJZs7mm06AqqKXBukFIwIVGjZRhpCHTSPp1x20p13c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764406902; c=relaxed/simple;
	bh=JLIdNXPMejF737Jv1xzF5GicNRibkuRDb9iX4pmjoI8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EboZp8lCOqUSw5VTqMHEO77u9lA+mIHjih6QuILcCcWvk6REbwqVGl+/F+a/ArCFOnXeRO3p/HphkXSyGNV+Z0WxNOT3VUfNGi3VoPiKGv3/nfiUXrQ1w8+fUg7LuQrEheTs+QH+dYVZ5zym0owWbAEHrnV7BIW16bZJvJ6O3Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KRn9SGir; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KRn9SGir"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7ade456b6abso2091432b3a.3
        for <linux-xfs@vger.kernel.org>; Sat, 29 Nov 2025 01:01:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764406900; x=1765011700; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3B+NwUppxNtx5dO3GeNOAlGv3QVGc2Q+cteUdMRhiTw=;
        b=KRn9SGir2pBgh1mKiywJ7/hOt0zGejR1vm2MBrEsl9f98GNlgZ/GLGwsccVj/GsjQX
         WJaVuzCpvoMb/UJx1OOcLfeoU1A/jDTVXGHxrowGhucL/qEMCFP1gcKC54LawCmjQwvH
         4LehKy4Y1P+381T+jI5VC/xbtgUkSPJ8vWy2Ve0ciJcUgnMJA+TeWj72zRDM22mSCA3+
         HaVLwYO7KEArcs+UnmlxLk2MfYaOC13SfWk+mkQ4qx3hXXJpFEIUY1uGw5HMKKQv2vIJ
         hlgUAzJiWWPKKU6SZX/HM3Tc2Mts55PI6bwy4Ie6e3qKFW36wyCvXBwAwa2vzNj5MqbY
         FzTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764406900; x=1765011700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3B+NwUppxNtx5dO3GeNOAlGv3QVGc2Q+cteUdMRhiTw=;
        b=v2TG8ZigfNWFYDzBIzfGC+61clAo+LfyMOsL2z61JqZkkXCzj9B+i/tf8/CBId5yJC
         Wv1OVgUeXZMPvhql+0OCTXqDcYMVygrmRu94Vj+exU4TiAaT091rxR/aPR0/bnw5LEES
         gE5vAU/RTmpJ2zKfWBNUrpBxfcNz9cXAQSkhhiT21fqnXJJfHVyZ6OWPHsXvfFI8pbD/
         TJWaPntoKJhxLC2fyWGX2L6JCwISCtCXfaAUT+IgiC9SMPsLWT8Mgq8+5mwCUcP+WEyD
         /UsvY2RIVf7nnxRMqj3S1NDu/10hMGPXvj5Jrr6n1dcR+fGtlC74w1o8ri9B06Lk04T2
         q1iA==
X-Forwarded-Encrypted: i=1; AJvYcCVGWf4XafsjzsaNWmsluuQPRKzAe1bkW+ZxPgTg3adv2hgJ+meRzrnyU3He9H1+3tpM0IyZ8mxT3m8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhMMry2bYH6UFMs2b0PLzr9LD3whMfFVI+cOHoDLLGgxRJhien
	Ce/NEInnaO/oY5ritRMJPD964kZwXZCt8Y5zU6XCRZp3avMtSNDMYocI
X-Gm-Gg: ASbGncuc15uFuRSzPLSvd/0aq17JeEVKH2HzodE+8b90iu8Tdb3kTqdydsKJPLVt9BL
	6hE3paBMuCtjpCUv1qikZNtvavLLLMul4VYhMvF3diHdxpHIERxpOY8AaZ3/1iWB45+pWhukvix
	OnyuZ8w1Z+4FnR77JLKlYC7tmPWnfmIILPNfq7vFW4hJYVLA/SlNgIKyEgVoARUWcCi9wt6qymm
	QgAa2yl/h9qQo+6ZAMDXGxc4lxk1U4cVpo++spjF8Z8ulyMsaWT/OgqSpsTT6yacYswCqt+CIWH
	8yxA5AJC8sGdqGiqBqzq/ubrTtbXGl8DMrkEBRp0Tuyq83p9Z+uO3Hcp7pZQN+0INh009+B3trY
	mu1OV68N5rTuctTdKH4uLFNcXEbwOQWByqqLn9ipGpkUMgv37xPljtjfgjS1kXzpZOT1stCqjgN
	4HLXelUNYRNXe5P07tVzag5pSpNgvNeefhY4Vk
X-Google-Smtp-Source: AGHT+IF9fpUjxnsoJ856uo76C4AbEbv+isvtq3QMxPEeI8s0lui+ms4Diwary4B5eKv1gtl0O4hKMQ==
X-Received: by 2002:a05:7022:ec0d:b0:11b:9386:825b with SMTP id a92af1059eb24-11dc87b150cmr7316305c88.48.1764406900072;
        Sat, 29 Nov 2025 01:01:40 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcae73bedsm28114394c88.0.2025.11.29.01.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Nov 2025 01:01:39 -0800 (PST)
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
Subject: [PATCH v3 1/9] md: bcache: fix improper use of bi_end_io
Date: Sat, 29 Nov 2025 17:01:14 +0800
Message-Id: <20251129090122.2457896-2-zhangshida@kylinos.cn>
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

