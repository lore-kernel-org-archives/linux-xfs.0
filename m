Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6506B2FF661
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 08:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318822; cv=none; b=CEols/iqARTBs5ujsk05ZE7eT2uRE1mNFOpBqyTGVOfaCWZjMfKzmR2t7soEyHRnmS2BCTrGM77lncF2JVFv0WUEsCazrVnlnopT1Vs2JeHVIBRQFwjocUgom4ID+DpCP3Slqm/Nq2wiThE9NWxeJbNyuf0i+7xSDS6SOGceIPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318822; c=relaxed/simple;
	bh=HTuaf3JKiz2KHLk/jbQPL7NkOb05byK6j+tq4J3zrGM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aBiihAcfhLmzgWe0CagzjiUuccsjqQPGrWqYShrz9BeTjDsHwyDwHenyHO72Udnc0EByjLcdDGOA8PSLuL6gyGdQi35HVRRKjMj+x1ZT0bRhoYZdDE2M424LCTcWjEWHhAh46bBOdu4g9+dWk1duP2l8DuBDJ7C+0mThB1WduzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iTjE6bRE; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iTjE6bRE"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-bc09b3d3afeso942621a12.0
        for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 00:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318818; x=1764923618; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9JuZTiXTtCfnBMrxTr4djU8x13PVqvGl4QPuQVkzEeA=;
        b=iTjE6bREmVJASqSDl8EFaPBpPk/0T4H/LQbXF3pe7HyptW+mMYa99/LJ8ElLXOMM3F
         Sd1Bb+StN9LTrgQtOJzA6Z8y5oi6xmzg45HAPvfnFx+7OKFhMyj44RqbRm9UkKJoweJy
         bsF1I7MI7UIuCSy11JPccmNBjPR82TIbC3pVXwWKyyzcaAMz9jRUxwSAU9z/POeNlFWI
         EMtBGBCOQdRelgl/DqzIfbJRW4w0G8qWR76cpDznOwZD2usTxkCnrWWfCkyCLcI3LbJb
         jI0DV8r8w2K4Q06tnvQKwq4aJEa4N6MXeLCER59iAVqSwHrVlaUpfJsJSLc2Ihsc9loy
         ramQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318818; x=1764923618;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9JuZTiXTtCfnBMrxTr4djU8x13PVqvGl4QPuQVkzEeA=;
        b=dT9Fbp7fMBB2VHoHqcf1HUGFESx66qdBcDRWY83bRFowVqJXuZxBYs+cXfyguOMLPY
         vmzQV1YfaYsTCt0dgzW30ZK5kvOirI1WtVcKHT4icm9bzDwuyiVwyHYZAvZxlxUxH7uk
         WF79nkdDG2J6sEnyLD7titGGwmmjf3fTkLGz263tMXw2ILodZRMozT01W9eVH6frbyHd
         pbvZK+A0Xj+HsrsSSwraKJ9/T7HmafiIJ0PIO8RH4V3Jtahf90fg6wm/c49suJgGXx5K
         lxI5Yg/irh60vu908fw9gtg85Lj6BPLp0krxUYS10TPaNON0O9G07KgwkzdJTBPLLoH0
         F1gA==
X-Forwarded-Encrypted: i=1; AJvYcCWZsyZIVZBBe9cH3BbP7178EyymHnoyoINrw2ZpFBJWMWXtG1D0R1oz1jRHy1/2tEQyPTCKJwG3N1Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIflZn1IdmfLkbv0XYJmWVxHmYQqA2SHgINMVATBDitolzsX4w
	u+tq770C4oUVmUWkQcUv2IFyvSoI2uS245U9jcHUADwAPMqHBfv1ApZh
X-Gm-Gg: ASbGnctxR+msRWiSNVtGc/yWleB9ywIoCoxYF2IhIF6Uh/4DHgsKTgtA1tt35Ij5zxO
	c3AXREYz0SvADWVNUP0mo8Wpsfbe5Y1fyzQmgmM4Iqgbqn0slq6n+H9thmQ/Vw7k/gXpRpviisp
	k7TovZyemi/1qILz0vizxX7Gt1Fm5FTmqYH9Fu5kxnEQpXbJZlMVtBavpBTqQJ7qN5wymEkMVsw
	ykPiAO+nf7Hxxru+0RHl0h03NtbFqGFTaygZHVE/81Ptw5iGLBQBXR2O2xrfy9YQilkmz2Pijbw
	A2Wu7kUbCGdh6q0DaBb/dWJen2yvxwCd9a2V9CxokBsl765clL/qZP95SfEYd5pHoVHL4mqv8XW
	t2t6s7zcEkpUUFrfBCYqX6jHVqaHGW80RiB1/urCFMRfYmQJGHKHtOT2vqxb52lEXEJrkqsSiqG
	FA3QxjnrIXhvGdjb2CppvEjxX5Zw==
X-Google-Smtp-Source: AGHT+IEiYKFOm1UmbHzu9Io+L0ipF/pftCo6ih2XEqCkxPLrZNrFMt6HrxgMvpe9BJ/P01XRe5CPUg==
X-Received: by 2002:a05:7301:162a:b0:2a4:3593:ddd7 with SMTP id 5a478bee46e88-2a71953bfaamr12018765eec.4.1764318818087;
        Fri, 28 Nov 2025 00:33:38 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:33:37 -0800 (PST)
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
Subject: [PATCH v2 12/12] nvmet: use bio_chain_and_submit to simplify bio chaining
Date: Fri, 28 Nov 2025 16:32:19 +0800
Message-Id: <20251128083219.2332407-13-zhangshida@kylinos.cn>
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

Replace repetitive bio chaining patterns with bio_chain_and_submit.
Note that while the parameter order (prev vs new) differs from the
original code, the chaining order does not affect bio chain
functionality.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 drivers/nvme/target/io-cmd-bdev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index 8d246b8ca60..4af45659bd2 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -312,8 +312,7 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *req)
 					opf, GFP_KERNEL);
 			bio->bi_iter.bi_sector = sector;
 
-			bio_chain(bio, prev);
-			submit_bio(prev);
+			bio_chain_and_submit(prev, bio);
 		}
 
 		sector += sg->length >> 9;
-- 
2.34.1

