Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00946340A64
	for <linux-xfs@vger.kernel.org>; Fri, 21 Nov 2025 08:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763713116; cv=none; b=A0k9bN+ppZytrY8aiSrk/SC5/9uBmrRCsYigRzqUHvkyXJD/C0Cx3nGZuSAsE6ZxEzlUzpkL+pGABFoAH8bLdVACs+mcAsNbWtd+Hox9RrT3+UabKTXxrMPeHaENGNKiltQ7N/onutLIvYw8OTH66nAFlyFHVTQYD+e3dn67Cd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763713116; c=relaxed/simple;
	bh=EqzE5eAUrOzw5wQ1NpDCM3tWSo+9dLaAmuNQNwJKJDw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OYP2K94VWZtrnuyacn409sAEe4j7OfgM77PTtrTOpxmH3RYMLP5HVb7zjMea7NPCDhoGEppWOn85L2mNET5O1lOPpx2sW3mJscazVle3Cn33yE+xqGlEcAGYRfQMrESxyPAYg9pRrOT9ETvDM+37gibpvYBE4Tq9sNXAPJOPkaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jf5PxmMV; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jf5PxmMV"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-bd1b0e2c1eeso1305398a12.0
        for <linux-xfs@vger.kernel.org>; Fri, 21 Nov 2025 00:18:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763713114; x=1764317914; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yt1oIqGxOTrmRU0wY5Kf2stOafiOCOsnZEA0d2AzsC4=;
        b=Jf5PxmMVKdZPIpOS27Gp2bT1edFpEnhYtoCvSiSIWYwJQ+px8/qs6G89l+VdieseNR
         8pS4DgXx/zUR0yZ0t0Rv2pjisuK+RTrenRE1YTBaTzpYJmxlcy+D3qwNg1dWKh1ivesL
         qE4OfiRpmf5yjkZy47enau1EGnGMtCl3o17powjA/ClXoUpn/m+j7t1hg/7T/0HIuaLE
         N7vP5Rv5ROXaf/2U4yziUg0xI9xioRu77EIgRPbkzJEz534T8HJG/Tzns5aO8V9y5ZOi
         Pt+MLp4E1KQ9oQa8R1GN4NondOKA426cEiBaE6zzFWvJuycXQy7dPL1VXItcXaddtwBL
         AJsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763713114; x=1764317914;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Yt1oIqGxOTrmRU0wY5Kf2stOafiOCOsnZEA0d2AzsC4=;
        b=voNPRYVBMCScleuFLFBGBhQKR6OPg5g+rNiYtRvpzDk1yr+5wMmD9SwuXYeHXPaKoR
         MU8tsCXlcEIMfOwUNpblXgc3H1t+bLp3gQrTIGgxRZ4Inq82Qyoarl8iPfFT0lfm0JKI
         t2aGxEdQkN1+mfoxR09vvRsBJ7moRfKei0q6/hPk//69ISjYcph4DKdTf0TyvH+VLajz
         alKTPOemJB1ewkkFb/svLhb/m3o6zK2sLyW7DtaVvH/T2avShaiYl3z4w+Lqa3CkPOdF
         r9kkuMRHCy1FDetgqbIqwjekk2WCYnctKrKpRn28OssoGWXj4rjxfFSxGGsPq8KSCx1E
         9IQw==
X-Forwarded-Encrypted: i=1; AJvYcCXUUaK/k5pVhzoD4Ljh9oOY2FeJt3TZqJo6AxVg8/0CeI1NeGN+rHGRy1BEhai9w3ISSSPzUUGF1tM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6FHI6T7xoIN3yTlSLfICrlPYJjFIBMr4pxgmnAHtqnmgrmXxv
	uINdNRjbMzpDH8AScR5wdQQt9vV2rpI2al5ofsPOFb6E3WB3tnRrDffV
X-Gm-Gg: ASbGnct+/O0GMNUev/M3f+PfobXjpqCEFUmT8Tov3iBkWPSePavd3WD3m0zf2Yp1eV/
	sqJJrKHGQCL29QgRncZcbSMDOYuI3jf9oi47sljXjd+TvwGih4BuBtpx9r0qi7Rr+9M1VnjmBXK
	cpTVv26Jttr6YXRQB5HQJ9J/l0kS0uGBU80qVWxVYIzYG2sy+ApdJp5dHxymoKPa40AABEVgpHN
	he4u9t5+Jo1IVo4Ms07QRXNcCXIPzMbgDlPl0vcGr0DSW4Ck0AJV86vaGr83vkEMYcBoC/+oocU
	b/ghgw48Bv1yw0lU55f6l9JEUBDyBXHswhsLdJ4DZn0j4ubZGmIglJiGOHKjQ8YXGazKqAWFCuy
	7f7nEhl84ZBQFRSpUtaip1jz3K9WXSKTS3y2EGq/HJkMq6XJ5uOUcUGgeZ/GnLsUiegLMV7bIYE
	wB0SQrnIrdu0CWXKF833MDgP3ZI+Yc/2qIdK1K
X-Google-Smtp-Source: AGHT+IGjQz6D1HhxF/O38ExwwmQdYex30Wle92q1+zy1HDlDdyzSrgD/kMDXWQtHpmE2DiVpd2L90Q==
X-Received: by 2002:a05:7300:238e:b0:2a4:3593:c7c9 with SMTP id 5a478bee46e88-2a7194d07b7mr663198eec.9.1763713114130;
        Fri, 21 Nov 2025 00:18:34 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.43])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93e55af3sm20997352c88.7.2025.11.21.00.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 00:18:33 -0800 (PST)
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
Subject: [PATCH 9/9] nvdimm: use bio_chain_and_submit for simplification
Date: Fri, 21 Nov 2025 16:17:48 +0800
Message-Id: <20251121081748.1443507-10-zhangshida@kylinos.cn>
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
 drivers/nvdimm/nd_virtio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index c3f07be4aa2..e6ec7ceee9b 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -122,8 +122,7 @@ int async_pmem_flush(struct nd_region *nd_region, struct bio *bio)
 			return -ENOMEM;
 		bio_clone_blkg_association(child, bio);
 		child->bi_iter.bi_sector = -1;
-		bio_chain(child, bio);
-		submit_bio(child);
+		bio_chain_and_submit(child, bio);
 		return 0;
 	}
 	if (virtio_pmem_flush(nd_region))
-- 
2.34.1

