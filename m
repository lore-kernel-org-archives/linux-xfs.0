Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC2119ABD8
	for <linux-xfs@vger.kernel.org>; Fri, 26 Sep 2025 00:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758846575; cv=none; b=HQLYfp2C91Z3D3gWJ/9wgqHzJmuIFbN4AsBpRdt2g1oxZFCioW+tLOxDFBReY/OH5BWNJMHjaMsknH+ywkTfCqmcTCuyJohhzWBjI/pHDIchVdB5a2hnWFLuCC9c75STjSg/kbmMr8t7GU7xOxCCnUZUf7yHd+AQDvhRcARxmzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758846575; c=relaxed/simple;
	bh=s6mhJfy1wLr9wwae+98XWped88EO8RR6Rj9hVh2fPUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AwV0gwzOQl3PfUGJdv645Ga+WMgNIWpyDTzhFO9UrNmWl/x1IyutmMW1/x1ODVJCMYkQ0x8+dTJ5zZXhSDboyzedFGZgSj4S9h2E+UqPF8PaIXzrpDnwuLUjdk/0Olj+BRzzN26yoik46ceXY0nEBU/fDpjHRxHwVf1n/T3g2C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LM2AkNDj; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LM2AkNDj"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-273a0aeed57so32233515ad.1
        for <linux-xfs@vger.kernel.org>; Thu, 25 Sep 2025 17:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758846573; x=1759451373; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+b5voxvHVAQ9evPBAMJkr0K4640egjfoU7iv7FHQ8OE=;
        b=LM2AkNDj6wNzRUiWXRrGj8H72x5v9FO2ZH47PZW7DoFbxWYb91OQBPRIfx64+WnGPO
         Wmdn+UiUT9dWBUS21y1ZK0+8q5FEUjpBQZEhWo+7nTw+q9lC1mHu8Q866MKSO/UDFYVo
         sF7oEU3/iXz5W2MH83TusynjOgnUEn16cN9QWCd156ZorxKMOJL3tIDhvJLCRZuuGKt1
         WQVA87hChY+VIvQaKOEymRaH9jWzNHnjqruFWod6Qzeib8NfAdFvdhHqXm3dewazpz4L
         K0DzqofrbMBdkBH4nW9zex6hFic7B8zKK0EIX1WAprjTMeFj8FdSV9VOzc0t75iuU8fK
         10aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758846573; x=1759451373;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+b5voxvHVAQ9evPBAMJkr0K4640egjfoU7iv7FHQ8OE=;
        b=OQFxmL2lzcUYng53eRlCpD2gPu6eQ1TGiaFrV9x4QY8ianmNKdrtGRLS9t9bHHQdM1
         rEKVZ1/SAhpDGzFRRkW0OgMO8mSkqYzzC0wz9YeWXCLkLZLAScYypsJjLa2ZEN3CuUaC
         G5AsvdcLQ7O3gUPZm753gOoMqI7u2BfSYek2PclN5ZlLqiLA8ZEt8G04wKhQ0lHOzffj
         Xm4BqwPmSQiy4FCetBT/FTwMhFH3oISx9RmROEKycjuEO3VnY3GKwXHVBJiiqt+yWrsd
         YDyEne7HE3R9vUmB6qky/oQaedwsdanW1ayKApZpRlf8CaWuGONes1FuBWoXtnyNd1+6
         JfXA==
X-Forwarded-Encrypted: i=1; AJvYcCXUUNTePeXjVuMM6wfEL6JNElmY2WwNYzdEW5vHLDtN+v2AgmiHJdAu1Sh9PzWfsPw8CLcTbqA9i8k=@vger.kernel.org
X-Gm-Message-State: AOJu0YwG558Xg4nOcNroihgkFe4dgnui+aEzJMn25fsWxrmEZ/Q2RV+v
	qzJV38K6Xn+VocumbbR74kd47+vFGPtn91zoQLE5LDY+yA4ZOsHnUtjr
X-Gm-Gg: ASbGncslWdhclotI0HB0nmncO21LdWErUwJfkdH3sXHe3h5VHudITVUEsAiO4DCOJGL
	R1TQZVM0aanStguv+a3LnLYRCzlIvr4pL9d+1b7DdAx4pYh++NxcXpe4EBKQQcjOjpppU4fUvL4
	4C3h+XhcQ30gj6PvxagIpQ2bX9JuNSFV9suzln12O9mKhMhr5FTRm+wsYRcJ07t/lDDkpw3yTb9
	CJhpGj6+7WISWapjYdniBG20Fz/L0y4MkL/Mpxbyb0uwnUlUZkUa6JYnWT4+RI6tcJ85BSN3CH/
	tL4afnWlzrss/sZYUDwDrEPIvfEpOMx47lpYnSrLYwVPK8ryqNaHXza5RtvbaZHU2yCVyN6ghp7
	14aWYpeoxh9CmZ7WwKQwhLS7gpD+I5l2wyygWgEtxPsaAn04J
X-Google-Smtp-Source: AGHT+IEHIVx4kLA4F6aUCgGEHZ0YDmnSl35bmhbet6WjaurCHoQfC42jLR71Pq42gzogAiSpCmWQBg==
X-Received: by 2002:a17:902:db0e:b0:26b:3cb5:a906 with SMTP id d9443c01a7336-27ed722bb32mr50893315ad.16.1758846573101;
        Thu, 25 Sep 2025 17:29:33 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:9::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed6ad1d45sm36470675ad.141.2025.09.25.17.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 17:29:32 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: brauner@kernel.org,
	miklos@szeredi.hu
Cc: djwong@kernel.org,
	hch@infradead.org,
	hsiangkao@linux.alibaba.com,
	linux-block@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com,
	linux-xfs@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v5 05/14] iomap: rename iomap_readpage_iter() to iomap_read_folio_iter()
Date: Thu, 25 Sep 2025 17:26:00 -0700
Message-ID: <20250926002609.1302233-6-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250926002609.1302233-1-joannelkoong@gmail.com>
References: <20250926002609.1302233-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

->readpage was deprecated and reads are now on folios.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap/buffered-io.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index dbe5783ee68c..23601373573e 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -422,7 +422,7 @@ static void iomap_bio_read_folio_range(const struct iomap_iter *iter,
 	}
 }
 
-static int iomap_readpage_iter(struct iomap_iter *iter,
+static int iomap_read_folio_iter(struct iomap_iter *iter,
 		struct iomap_readpage_ctx *ctx)
 {
 	const struct iomap *iomap = &iter->iomap;
@@ -487,7 +487,7 @@ int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops)
 	trace_iomap_readpage(iter.inode, 1);
 
 	while ((ret = iomap_iter(&iter, ops)) > 0)
-		iter.status = iomap_readpage_iter(&iter, &ctx);
+		iter.status = iomap_read_folio_iter(&iter, &ctx);
 
 	iomap_bio_submit_read(&ctx);
 
@@ -521,7 +521,7 @@ static int iomap_readahead_iter(struct iomap_iter *iter,
 				return -EINVAL;
 			ctx->cur_folio_in_bio = false;
 		}
-		ret = iomap_readpage_iter(iter, ctx);
+		ret = iomap_read_folio_iter(iter, ctx);
 		if (ret)
 			return ret;
 	}
-- 
2.47.3

