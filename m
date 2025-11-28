Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AF02FD1A5
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 08:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318801; cv=none; b=LOVbzGHcC58/iX31P51wlFah20Vhf5rGvXy2S6cDSvjXc3YIQCauH0ZJlefuQyErx7WHHIAj3Pu+A+zwQ07JWx/FNwAh+96zE1f8dkAPcpwcYPbKdO8esf2H32zrwVnCG9i9cGdaeItKXo1PKoSlnxC3Ku69hDrSkTtz98kQVpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318801; c=relaxed/simple;
	bh=Hfn+I4xKib6YHUNH+g6fjmCyECLvbavw8yPYoNL/5CA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dijvbtkWhee/iLK7CZ2nLB+tT+qSoh1/i6vAOfqvRTZFV+LEsBBjxccurF9tV9qWKrlGM6dAC9F07wec1mc++FKg2CVp+J2QevV/vzLUtORUfGr5ImexN83e//nq681A9iqd1ex+D8BjujspUCdd48PJpwHF5S8tpsnsghq3O0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OUi/xMAG; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OUi/xMAG"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7ba55660769so1359806b3a.1
        for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 00:33:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764318799; x=1764923599; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vdyx9mvaY+8x+eK9XImqi9TsYLR1v6CaCbGe/GD/N5s=;
        b=OUi/xMAG412JYQWqySKUfzoBptHS4/Qe8BOfLx1Cl7Ol+ZrysScGuSCbCSD832sagK
         E2WVayGv/dFEuvs3uezePHhpenkhUJLWlEWRdXBi0+7UKy4yLs1/7RbnYaoYGFlgMvpC
         ifZxtMlbt5rIFtBO7OFqKBQ1L4bCpYAdoX2eDKAz4KVeJqP0rWJAhziBh5ZQJZMY/DNy
         H0HbeiwnWIhXZ9LZnKl1d6uWdhJoY2QxPPZd2n1+PQMGtQPJj/gMdhpIVwsNWsx0Lykp
         PnNT804fJRSb5AQKhnUVPvisdKk7jejR5ztxyrbImwCfmqeTl42L6fq7+FW91/eRitbr
         LDnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764318799; x=1764923599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vdyx9mvaY+8x+eK9XImqi9TsYLR1v6CaCbGe/GD/N5s=;
        b=A5+tvJMlSQO06pzB5pnsf4qciAs+OMcmxbMdYYQDrAhdIv4kLs8DJDD+wYAFI8u14+
         PiaEx9j+WC1vpgkQgj7LwYoIgEDJJ2Pt+ldq8/7zHUSP4qOPvj0hyyeypTFFQVniaw8w
         wN567qSRNJccHQKWy8UJ3r15N14DVUzzWNvLHPL+23QQgw/fj4fb96O4/Mo1rqYktQwJ
         mlsPFSqB53/YyyxtYYUlUbgnYWtvN7irTO2x2PGEDyO8Akcj7ofKd+jLBsMSsA+D/eRa
         5qDoxwjAeYF7K4dDsL40wELk3uZ6Y6YbDLVMevADi3j5bCfZeXldTmMoE8X8KUZ7VV/2
         nGjA==
X-Forwarded-Encrypted: i=1; AJvYcCX/GZNYa2BfMl87Xd0LLEFHMCJ0KgziPxnXL8WfTC67hbkowPVOjCrqMqNB+ql4D35y0IwIKWe0+80=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWl3hu8e/4Xqfu9EM65jDAL4yt3Hzl9BJG+o1AP7fCI1PBdMUz
	nQM0ee/x0ghyL1AbRnsVc1VGIQMi0ItuASaoJnKZz2BOU0d/WM5oYIqo
X-Gm-Gg: ASbGncuS5BvmLKhbOe6SLZZc1ObnIxSbyMaTqXJg4eyXECl/lGNKLiLNmi4e8i8q/NH
	+HRaN9drtGj00nie5Sdft0sRVivbCWeZtzYNyCuxY+Dk7zS2cwFK+TxD6mSEdsIe+/B3g3mPtcy
	3I6UVZ6LMnS/0mJGpqqkAmUwndZ4NGb2iFBK1+8XWvqbptWtoCRbONztgcm5eBVZ823LNbT/SoT
	wU9q+pHucn6zEqABHe1xhEXmPyg+YyUgcOJzPmipeiSNEVMhVbi7eeMrMV+kcQjt90OuZMfIp2f
	Iq7Jc6NYbqC3WYXUIrSrp1rCyki5vmnOLiUcRGBB8vDOMDg4ysGT29uRoNUKVYDxolE66IrcquM
	exUaKXViqxvsib4WLgM8YogMtnQdljOs6ZWQceYAoAFj0nvCN8fksHaUny+qkRpo2Cl1BZapuf0
	aq7qkYsm6Qe3Q5FFHCQha83AiBAQ==
X-Google-Smtp-Source: AGHT+IHKXq8x9elSCjEHks4N7hQUevj8WxDVP5HKi9llAEtlIQFfHNb05BLq+B1Nz6uA8fi9DHZiww==
X-Received: by 2002:a05:7022:671f:b0:119:e56b:91f2 with SMTP id a92af1059eb24-11c9d870411mr17436186c88.35.1764318798796;
        Fri, 28 Nov 2025 00:33:18 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcaed5f6bsm20941371c88.1.2025.11.28.00.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 00:33:18 -0800 (PST)
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
Subject: [PATCH v2 08/12] block: Replace the repetitive bio chaining code patterns
Date: Fri, 28 Nov 2025 16:32:15 +0800
Message-Id: <20251128083219.2332407-9-zhangshida@kylinos.cn>
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

Replace duplicate bio chaining logic with the common
bio_chain_and_submit helper function.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 fs/squashfs/block.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index a05e3793f93..5818e473255 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -126,8 +126,7 @@ static int squashfs_bio_read_cached(struct bio *fullbio,
 			if (bio) {
 				bio_trim(bio, start_idx * PAGE_SECTORS,
 					 (end_idx - start_idx) * PAGE_SECTORS);
-				bio_chain(bio, new);
-				submit_bio(bio);
+				bio_chain_and_submit(bio, new);
 			}
 
 			bio = new;
-- 
2.34.1

