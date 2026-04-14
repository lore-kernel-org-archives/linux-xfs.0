Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3149530B529
	for <linux-xfs@vger.kernel.org>; Tue, 14 Apr 2026 03:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776138170; cv=none; b=UYyCv2GRIX79i6tTkjk9VF9h+9kgiAVT8jY4hV8RGlF/XEI4XPLq9hmK4jm4ob4Nzjb9Y0bQ/smngEA/jXf274AkUjMUX57ruBMcZV8Q54mF/fMsdjHHOZ2WyCWfz1wBkewGL63dSIk8Md3HiVLrcvajr127+9ozsH50Q9ymbLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776138170; c=relaxed/simple;
	bh=G1zkKB5J/ZwwzO57UPK0AFrN20hSeHo66GZs4YUYlKw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rgSPSQ6/hxwYW1t8Pxqe7wPkKbWlqxJyJBWQxBf1+VUi9BY12s8FkNxgA78GXwkk08ilO0hfBdiUMDQOWsJBYL6S1aiGgc4RKY6HqBrsK6K7radA/9Xa5AbOyBdayQXXoPp/QkuQ69dBYMsgGzZjWcpjpNkDYKI9rXLCu/4Hmo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TaeDvez/; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TaeDvez/"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-35d90833cacso3088764a91.2
        for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2026 20:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776138168; x=1776742968; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bxcVRDBQYoEvUjV/D/PMX40SNzPhQnuxj7fjLILYmjM=;
        b=TaeDvez/GmrmfSWFW3V/GjcP2XU9KuVw3/oeBDDh4qIwoY14//41gQpW65X0sD1oBh
         UDaIe8fCiSGJ+ElO/6ejZVSA8nQXsMy6EHU3PG8xiY+otbYDJL+/rcwx2tV0aEi/eCj3
         gnwzAeOKwpO42r3mGlz+plFKwALfWRZZoKtQ8xjM8mZJ0dNiE/Ebh+Le7C7Au7dbldJb
         5kVhCkB4Eun1cA22p0nBbNQKzCprkuvpveWaE0G8X8j+NxONWa6JTXXouUS9QnF9TMX5
         ZCy+mlOvcbfDzMRZCu43NXxdl9VseMMk4t9otQYW2qzQiTOn73AtGb4jhqc5SS+7YyEC
         bcOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776138168; x=1776742968;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bxcVRDBQYoEvUjV/D/PMX40SNzPhQnuxj7fjLILYmjM=;
        b=WpRuJEBsBBJBYdqB7mkOWCLSRRVjd5hvhcl8z/dntxTSFSxy4xSm/m4mvbMW7S3B2y
         93XaqpzwX8YSwvOvqE85y/dqsaLr+bfX4v0zUNX6t/xNQpijw3eOT3sQQRBQB9O36sxN
         aBk/Ch/77hiNI1VWUvzUEFjMVul+r4+EdyLFqHeAAZUO6Ih/wmLCzspXf8/J2TfTM8Tz
         3LYNdRFQQy/DHj2GgwCjuwmFgLLXMH2nqeHCWoZbLyCUksMtyrHTwaUUssIX8FZsiDfx
         Y+rlXUXeAo14/RpxuvTe8utljTgQU94BS1Ww0Xo5PQapnupgEY3RNYVmGyzXPBQV4nJC
         u5WQ==
X-Gm-Message-State: AOJu0YzXKOEtKMMF8lFQONj6Ao9MlPGK7LUQPzED8Z8Mxnscafaeu/Q8
	IsPz1RydSQYL12yLH0NWoNbznFLgCR90lu06E35yAfZayMFQT2D1sIUtTeJIAQ==
X-Gm-Gg: AeBDieutlfEc+iabeCUlgdtQ7VEvPBAjktjsB0exE12ONWDW5rIxYYkp/xxfmmH8rdR
	RU1PujLqYG3qAG47BEJpQMBuWJdBlZJnRWa1zHLC4/P5DWaKRFAhH2qYOKJz69BEFfdQiFiPOr7
	ztSWhcu7vqL2h/jdSf65lS1B1O8TMuWpm18BXnZRRedQ6A8A7nAPtAepHIOZCAXPCY0XyrBmot1
	vDs9hq141j3wMDOygXiKe3pppMBZVCFQ7tEHgL41+5zM8dOvs13+bvd2Rw8gNr2mwtged9Bmi0H
	ntBR5Ob0kmLXOqjYc6kfD/b5eP+qyeCq5OR07845pdC87SKC2trbcWmLZNoPSUuzZFSb7Tri1Mk
	4fsPkN4SDlp0nH2WkeMEqlmYvv3GdFRzR27IC8T0qiMo5Viap3sWkfI13wGkDQ6bTy0OdNKUADC
	f/vcbcUsqQDo/l9I2u93wNLAq0vOyF
X-Received: by 2002:a17:903:2286:b0:2b2:dca5:101b with SMTP id d9443c01a7336-2b2dca51487mr136688535ad.12.1776138168289;
        Mon, 13 Apr 2026 20:42:48 -0700 (PDT)
Received: from zenbook ([159.196.5.243])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b45e949464sm63079895ad.24.2026.04.13.20.42.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 20:42:48 -0700 (PDT)
From: Wilfred Mallawa <wilfred.opensource@gmail.com>
To: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Alistair Francis <alistair.francis@wdc.com>,
	Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Wilfred Mallawa <wilfred.mallawa@wdc.com>,
	stable@vger.kernel.org
Subject: [PATCH] xfs: fix memory leak on error in xfs_alloc_zone_info()
Date: Tue, 14 Apr 2026 13:41:51 +1000
Message-ID: <20260414034149.1116281-3-wilfred.opensource@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wilfred Mallawa <wilfred.mallawa@wdc.com>

Currently, the 0th index of the zi_used_bucket_bitmap array is not freed on
error due to the pre-decrement then evaluate semantic of this while loop used
in xfs_alloc_zone_info(). Fix it by allowing for the i == 0 case to be covered.

Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
Cc: stable@vger.kernel.org
---
 fs/xfs/xfs_zone_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
index a851b98143c0..c64f9ab743a6 100644
--- a/fs/xfs/xfs_zone_alloc.c
+++ b/fs/xfs/xfs_zone_alloc.c
@@ -1217,7 +1217,7 @@ xfs_alloc_zone_info(
 	return zi;
 
 out_free_bitmaps:
-	while (--i > 0)
+	while (--i >= 0)
 		kvfree(zi->zi_used_bucket_bitmap[i]);
 	kfree(zi);
 	return NULL;
-- 
2.53.0

