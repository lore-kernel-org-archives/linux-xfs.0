Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6287D2EC08F
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 23:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758066637; cv=none; b=UUtwGbkLxSGY+nL9//HT30WtBqT8VcSim3EV8V95wsGtaIAMmuO8PY0G7Hz/pBphGAhJq432aS62sl5BybAUemMPyUXt3cbPBekNtirneeXaGdX7JIZ/5P52/em4yiO7QduWClzK8c6f4+ic9WUbWlDN+NGEAAmfHpEaymrtCEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758066637; c=relaxed/simple;
	bh=98GkOjzNEJqwvQK/4lUwfHNtYdVVuLzxJ15LQCdn1IY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XckbMmuZy7yqlFU3+M/TViY8/iI2g401OBzTiZ0yReIzHygYU636fu/odKZxRulsy0Zy/JbxiWKRQ0HFHZHRdhxa49w7FJ0aJta0MqBrzrwWCko/SAjBoP1m6yqoGgHkiX/0+Ex6lEY/fG4tHx/lp+1wCqZTG3tK8oNv1/mZ1vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GlnT5olf; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GlnT5olf"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-32e0e150554so258970a91.1
        for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 16:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758066634; x=1758671434; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rG6E+B3mjTcSPZ6yVzAJALw0H8+ndYKaxBlvC8laKf4=;
        b=GlnT5olf53BRTZ4BIemxBvWFHgfqTpKqU2Ab80yQNnCiC/EMGB/Wh/PzU8z6kaeVF3
         /OHnctV0IfoXhqtMlsZ64wWjta7KwKZ7hBJGozMkecIPlQS+w6helKXdADof79BweY0o
         KDl814ionrLz9rVLGCqdJoverD1rjGGnFFxg3OoubtXTqk/7AIQ3thkChnPOnftXnA0g
         HFqq7Fgztoq0KHeflo/CB7eGuy2MYOPK402zl9pEpZ2daSCz7BRALlWZsAPLdbD2z8dU
         yUhrYHzH88wB1Pn0T2J6HWfey4oSNLj5uxI7pRrn6MUJx9TEUV4zTYMG7pwruxsKpD8E
         58dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758066634; x=1758671434;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rG6E+B3mjTcSPZ6yVzAJALw0H8+ndYKaxBlvC8laKf4=;
        b=KkQHnCQqKG/YuSi35AZUXZbzIDOE9J7v2ERE7gZJrD7iDBFGvWFQmshYudgc1kh44m
         dpB+X1hgQ2QgeM19YfoBx3k5ne1He3uXILZSUT4RgUlIQkq0LvLtM64crTT7qg/6bRal
         RWCyTXn/NHUKxvBFn5k8dqjv1S55Xt783KuVmWS7z4mCxdk6MM/DQ5D5dJlPr/EZkRaO
         nHYVghjX+qBQmVDGJGfL3BhliHDVL9YqkN2uuNcDvLUqeII4/ij5ev0Pnhmv4Fca+bmL
         12UM5zzY0WjnqAkf5y9UhfGMq9HfYwZIpjBj/K9z0hLLFIFw+IC7ID95CwdAB6oGLqK4
         GX2g==
X-Forwarded-Encrypted: i=1; AJvYcCVTQ8L1PLvdGo5jr8tdgtwkIkL2e+V0U2UYdtbCmKDY4sZEXl8ZnCxqzG4a8eCaJvjXycVj5TwbBGI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNca+YlkoTXUDNUCZ5TR7LOhUE84KxcCUZHCoR/ZNVt8GDRJWJ
	650EjFrlJW2V3N9MSlS7pUYOQBTOUKLJtuHlQ48WjBrQpOE03mAn1lRu
X-Gm-Gg: ASbGnctInv2+Ppd7PgimbLBj72Tjc0JmwgVtdwxL6cwNs0OOIWo1WBlyzJMYKQiGNsB
	Bf1YfdDcaPZEpJhOADPaj2jzcL4XotEoNz8gpaGv3xJ+hyowqstR+GB02348jZRkTCNuyxmsBpI
	axYe9BN6tn983CQrdmvRVuT6hPHbbMmztL7SjqXihhzdGNbxJ89TNNIGH7x7574xoyb4+4jYCS8
	kE2RUxK2Gwj0iZIBoxwaTvv7wCKQV0+ff0Wxu/eQgw0Tb6UaLkikyXs1UNDEvkZTXBbo9in9MWf
	NDLIMClGWOpi24AmAKxsIHiUOMEQscvVuDHfz9uTK2Pe0t3yM7ZUXfv38suKy/cdm4hM6WNJ/aU
	+EOgBG8Duvd16Eol+gqGD/UxTEE9XMEW69GcKD/eTw8R5KxvtD5Oo5pkxkf73zsFyJSWSdQ8aHE
	BZeF/wRZQjyr8gza6WUmFoiPyV
X-Google-Smtp-Source: AGHT+IGDxK1TSJHJMfjQoDefaoarnOiH5p2F5ClNqiomMKUWzK7J0G8impfhFApU6S2QB8fO6tB6Vw==
X-Received: by 2002:a17:90b:33cd:b0:32b:d8a9:8725 with SMTP id 98e67ed59e1d1-32ea631cd58mr4496407a91.18.1758066634546;
        Tue, 16 Sep 2025 16:50:34 -0700 (PDT)
Received: from localhost (fwdproxy-prn-054.fbsv.net. [66.220.149.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32ea101ef2fsm1520309a91.5.2025.09.16.16.50.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 16:50:34 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: brauner@kernel.org,
	miklos@szeredi.hu
Cc: hch@infradead.org,
	djwong@kernel.org,
	hsiangkao@linux.alibaba.com,
	linux-block@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com,
	linux-xfs@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 05/15] iomap: rename iomap_readpage_iter() to iomap_read_folio_iter()
Date: Tue, 16 Sep 2025 16:44:15 -0700
Message-ID: <20250916234425.1274735-6-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250916234425.1274735-1-joannelkoong@gmail.com>
References: <20250916234425.1274735-1-joannelkoong@gmail.com>
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
index 0c4ba2a63490..d6266cb702e3 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -412,7 +412,7 @@ static void iomap_bio_read_folio_range(const struct iomap_iter *iter,
 	}
 }
 
-static int iomap_readpage_iter(struct iomap_iter *iter,
+static int iomap_read_folio_iter(struct iomap_iter *iter,
 		struct iomap_readpage_ctx *ctx)
 {
 	const struct iomap *iomap = &iter->iomap;
@@ -477,7 +477,7 @@ int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops)
 	trace_iomap_readpage(iter.inode, 1);
 
 	while ((ret = iomap_iter(&iter, ops)) > 0)
-		iter.status = iomap_readpage_iter(&iter, &ctx);
+		iter.status = iomap_read_folio_iter(&iter, &ctx);
 
 	iomap_bio_submit_read(&ctx);
 
@@ -509,7 +509,7 @@ static int iomap_readahead_iter(struct iomap_iter *iter,
 		if (WARN_ON_ONCE(!ctx->cur_folio))
 			return -EINVAL;
 		ctx->cur_folio_in_bio = false;
-		ret = iomap_readpage_iter(iter, ctx);
+		ret = iomap_read_folio_iter(iter, ctx);
 		if (ret)
 			return ret;
 	}
-- 
2.47.3

