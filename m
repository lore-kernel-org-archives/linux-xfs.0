Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8661494A1
	for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2024 22:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712962799; cv=none; b=jB17NcU0CjrIWGmleVMEjnrUAnuqUFf+kjJn+Rac9d8vEphTwBl2+adq15h+N+bVSWP+DapD8jXOphLNqUKGaoWaDpSAaim4ZIkYvlE7XECWmgu4kTI8pUMCTBYHLlpYJGBB3CAu6Hn/rZ9bLb5GowPGDlTqY9tP+qi6Bu44Pr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712962799; c=relaxed/simple;
	bh=rIVLVW+bBC8yBZ+b5m+XxQOExL9qTEAzQR7f8WMxTbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rgbQgfU6x84lA34sZEhdegUTfP9uWLlJKKM6AwdpYm1ODxsyXZo+Vi/yrmE+MkjeoqA/xW/Pi8qrzyHN6DYME2B9oXrQObq6UbcHjCqapmWkw1feAUqyzoMRi4fN0DcDQTPWngj5DBc23RUZ8UnWRJDSwaBeCBIqgZ7YDCt2jaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=OXhuK2Xd; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="OXhuK2Xd"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a51b008b3aeso162392366b.3
        for <linux-xfs@vger.kernel.org>; Fri, 12 Apr 2024 15:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1712962796; x=1713567596; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dJcj1JKbQx+AdrQmxw/BRHT0bI3Fvgh3nQKiMBwJNls=;
        b=OXhuK2Xdw/3OExhs2adnC9oEdteocQnD/r70QrkfiMmHBZs9r+ghj0hDlE6fCjuGw+
         VHm9S9N+7srgjT4tRFMNKR+aIb6XRO1DCE/C8U3RGlgXrfgnu8rAIVnXm/JnapNAIIm5
         OtojbNJLRFoOeY1dZPnxL1qHHnY5H0oC5TLOmeMadCIDDFw6GvkPYo9Y+BJ4hGuoRDVo
         ZwaAtgMqyMS7/vhgOuXmNLniE+ZhbkiC7mYTvhIXsV0sTeiCIQ3rNtjoT9znwPHvbZzP
         UrqvVQAFIqnboqkCB1ls8eJEg7Xdx6Mu578M0zVVa/dccrO/KfpyPelndY3lIUN0Kw9l
         hNtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712962796; x=1713567596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dJcj1JKbQx+AdrQmxw/BRHT0bI3Fvgh3nQKiMBwJNls=;
        b=mZy1LmFLeR4W57pWcw+JE2hXIlz/SV4wTbO8VmNk5xHydL/eXrZNwdc7QDURyvdy+7
         Tac81//eU4cR4DxM/0IBi2shC6I7cdc6w9NVZrPGslFsJjWIVMF0Dc06tr3z3TQjUVUP
         EAcRP4gZ1w8/+9bBeg7VXuDIUUL/WIReq1nEHj2FUr0vxHmmEaBscj4MjP6SaeKPcUeG
         UIRljIILBN+Q47ukMsHter8ojCOm0ARgPybivLgbEzpwbkZzJlPg/GSS1ayo7d1NRKM7
         z9rdLqqb4i6kgM5Dk1K+o5RK7qoY8MYpBvChgFS2Hf9FjyQrZSNa30pzyYLrbV4BdzKv
         mviA==
X-Forwarded-Encrypted: i=1; AJvYcCWWWUDejhWsiE1SyucdgEYtMpzAQitekscWgZk2NIXvGcJksprxV3g47krbcKEO1K4yPnUu1SMG2jR9QVd0LERESxl3okZ4UG8o
X-Gm-Message-State: AOJu0Yx2BQo/Qwwze4zA/xBtD+zkwnDEc/7E0vHfA66TIlCALRKKXAhc
	g/iKa6xwG8x9Lf4StM9SrFFpRhJ6GvJClbD8lzcJyd+PcRpj8c7fN9iIwq8FDyI=
X-Google-Smtp-Source: AGHT+IFebvfFfbPWloyVBdwUmNBWmPXHhouUUYh8/lIBCpO38VbFe0rG7TUm9UaWeT51bMqWZYUWcg==
X-Received: by 2002:a17:907:3ea7:b0:a51:d522:13d4 with SMTP id hs39-20020a1709073ea700b00a51d52213d4mr3442381ejc.52.1712962796149;
        Fri, 12 Apr 2024 15:59:56 -0700 (PDT)
Received: from fedora.fritz.box (aftr-82-135-80-212.dynamic.mnet-online.de. [82.135.80.212])
        by smtp.gmail.com with ESMTPSA id by20-20020a170906a2d400b00a5233cd49e9sm1295603ejb.188.2024.04.12.15.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Apr 2024 15:59:55 -0700 (PDT)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: rdunlap@infradead.org
Cc: chandan.babu@oracle.com,
	djwong@kernel.org,
	hch@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	thorsten.blum@toblux.com,
	Christoph Hellwig <hch@lst.de>
Subject: [RESEND PATCH] xfs: Fix typo in comment
Date: Sat, 13 Apr 2024 00:59:27 +0200
Message-ID: <20240412225926.207336-2-thorsten.blum@toblux.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <33c49440-8706-49e7-8bff-5df1cc828034@infradead.org>
References: <33c49440-8706-49e7-8bff-5df1cc828034@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

s/somethign/something/

Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_priv.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index e30c06ec20e3..25b6d6cdd545 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -683,7 +683,7 @@ xlog_valid_lsn(
  * flags to control the kmalloc() behaviour within kvmalloc(). Hence kmalloc()
  * will do direct reclaim and compaction in the slow path, both of which are
  * horrendously expensive. We just want kmalloc to fail fast and fall back to
- * vmalloc if it can't get somethign straight away from the free lists or
+ * vmalloc if it can't get something straight away from the free lists or
  * buddy allocator. Hence we have to open code kvmalloc outselves here.
  *
  * This assumes that the caller uses memalloc_nofs_save task context here, so
-- 
2.44.0

