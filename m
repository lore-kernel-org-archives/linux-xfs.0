Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A2D3D667E
	for <linux-xfs@vger.kernel.org>; Tue, 14 Apr 2026 23:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776210401; cv=none; b=iidemu4aGsTaw14o78NfGQ21cnad5yE4gnUW2/5DauTffUTK13IKy4RDDY7J3VwpkzT7XxpOBPOxh8jO0DSYudf12cfwKm3K4vjj1ebwH1h1sa7TDynLkO0p6hsWpP1wWy3p3k+WiJ/yt/jVWwPdIs7ZEEHMM3v/mygnfD/rhqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776210401; c=relaxed/simple;
	bh=/2hIp5BZLooUW37+BmEgbWSArMAppLPs2okM3gNV8jo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L7fYFygkJo8nNbdwu/kFl/D674nIQfrvms8y9P/5iWn7PRJ3OKyRog5AxFlfOp74XR7s/tMVQKYnPiJOk/nJHBjrJswU8GeJ0danPZ65C7FfYDFF6OYWKbQE7Wd2NlANjY/niDKiYI2EakyuVP2ViBw0fLdV0+zxQ2RT+8LO+bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ejhHwtrB; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ejhHwtrB"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c76cce85bd9so2409045a12.1
        for <linux-xfs@vger.kernel.org>; Tue, 14 Apr 2026 16:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776210398; x=1776815198; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=e+aagt8mewkTvyv3R6Dqrd15T0YDKTqKrH1kiymIT8g=;
        b=ejhHwtrB9EqxqKBxEBH2Cyon+JDPgc9th03SRehxMCuHi/tXl8bxG+sEz+WVEe+sL2
         auQiqktdFMjf5HApILzs9foRZJAeKxvJYXN9fW1dqUjKNDsfEMhckn1kbJYHn5UKaGDS
         QWNdc6h+OF2wWw+OzZmO5liCnFwCneVC06sRksBprsSQ+R0kdZoe2NaKvOgA/E6/woiV
         3vFuVZyzPZbFFfsU1Guuoavj6w+vwI8xoXn+gMj832bsywq7xJC9uXUYsEFeCEAZq1zU
         wilfqTa8EnYVzD9Av6Uz4zq0GL3uRlWOqC9GgV3MsV5TJykuJ/HH3Jo9B/hBAqexy84G
         gWDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776210398; x=1776815198;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e+aagt8mewkTvyv3R6Dqrd15T0YDKTqKrH1kiymIT8g=;
        b=T0R/ahYrIBqc/zjrQHqCxo5jC7GIJRGV3Dt6psS8mNys/AcLjDuGSxCRqUkTWBKtjS
         zKzngRUmUEAB9aRRk499kW+90zKwiEDREFi1laLyQ4CNKRgMNOZd37hFrDH9NqK2sxcG
         SFi4FuGpraForklrX0KhRbOhuSB6YuEyzWb/0WH6+lLEWj8u+14Q3sjheI/bUYfZ4xhi
         SPAEoLtppDhmuwrCNBG1w4JhiPOX4hIvivlIZ+QSnTEvArKd8yFrvGGtCOcwJv8Pv/GC
         1AOW6RNv/Y72C77+++D3mnyv9FjAdj/h/diPKW/mM2uOBtyaEWTD6/O09ToCBGJlnI4F
         WS6A==
X-Gm-Message-State: AOJu0YwTRA7ulut8QB0hlbwyM2Vt8Cf/9fC2F+JsNxHzhuT9AF2c1WUW
	ghV98ITMSLf8l1p+tQK1j+HPtl2u9kVMBNdrJYeh7Sroj7qBP/NkQj2k46h7cA==
X-Gm-Gg: AeBDietRB8ylClDLl2NnZZKAYiahP6G99IC8tfit3UBi56Dk4d201PcYb8IcOQ3vrvq
	jp1jpm0CdYY+pMCzVu1JVuQaHDi7JR2TPOmNYMPXK+IAJW9qZalP3egc9bQkMBc74Po2WPfnbBG
	pzlXDmSyIBAMim7GBQlPtl8elOKq7OEG4D9SqkSj21taMydYj7Wl8C4ABplQcWsuwlUCeF4Jr1K
	WrlZp1caHump1JIHval2lwBklFKy+X7w3uvN9CnU4XEUFZoz3t8lOGH9HnNnBsk8lTc1KGhUdvW
	Y7vap6ONbedIKXtRAb7FwqR5OMoQUljb7Xx6BjzHQx6Zwje+Sp0UsDgVGqj3F2cs7K0rb/jAJ3n
	neeEg+g7qxxWig3KGcydW5WADqo8JxqTxpxisBEojiaywIiKgapRnRvcAFRnfeKD1PYxVob8buZ
	ivssJynFzkQAU3F81RRWtqYlcTL1olb1k85Durrkw=
X-Received: by 2002:a05:6a00:886:b0:82f:592f:2ed7 with SMTP id d2e1a72fcca58-82f592f35f5mr3850866b3a.45.1776210398171;
        Tue, 14 Apr 2026 16:46:38 -0700 (PDT)
Received: from zenbook ([203.30.245.12])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f6702f900sm153027b3a.2.2026.04.14.16.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 16:46:37 -0700 (PDT)
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
	stable@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH v2] xfs: fix memory leak on error in xfs_alloc_zone_info()
Date: Wed, 15 Apr 2026 09:45:14 +1000
Message-ID: <20260414234513.1457961-2-wilfred.opensource@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wilfred Mallawa <wilfred.mallawa@wdc.com>

Currently, the 0th index of the zi_used_bucket_bitmap array is not freed
on error due to the pre-decrement then evaluate semantic of the while
loop used in xfs_alloc_zone_info(). Fix it by allowing for the i == 0
case to be covered.

Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
Cc: stable@vger.kernel.org
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
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

