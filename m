Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9052D538A;
	Sat, 26 Oct 2024 18:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729965692; cv=none; b=ZMtE5PY8xY3R2ZtViALw902arTNaaXZkaLilGErXS0fpTeg8+tBuIzGbFNS5xrIcYUgvO3/boVR9wooxbBWrlZZMIbLpJp6pFiMCUqB2mHv8O47JQ+2D/QTHiy1qIY+RrskmiNOFjdAaCOtSvGxfd+6idDZBj8sKb38wXl5quOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729965692; c=relaxed/simple;
	bh=cX7dnLpyuAWg2Y5tu9dKUEnohBDqa9GTSOTqU8cQQ/I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SPsyTMEjz7r0L821de+vaniGK4PGBUu4wX/a9xrpkU/9i4xIjjfXWBlScRpRoZIBkhT6t06rMlLRIovcdogqVUIiHmys7DwQ3Z/HEHLSWdmyvh7oYhDgXA3Hhx3IBL8eKaknCkG6jRKQqWThSocqZ+oxtAXm1ydocTcPaP0dsn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PaWApvVq; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PaWApvVq"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-7ea8d7341e6so2244997a12.3;
        Sat, 26 Oct 2024 11:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729965690; x=1730570490; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Vx7n+lvYfx4acKCpfSYSV3abqUDWePGSSogzQMnaXSA=;
        b=PaWApvVqMl8C+i3t0TOv4PG0abbn+aYXxz7Tv39m+l6CCMw5VENmeEcIhRbx5BVtBU
         NnuLrWN98Nd2RbJWomBot2YD6wGlJDqnQdyhMv9JBGtf25w9RDvTpfHBPDol11sYYhFP
         8WDZx0io7FLtvEfBsPlh2cXDN69Uc6pwcvR0x4Si5fKucwN4zVMkV8ZIxmfvGfqt8MEO
         rI9Bw0FpDSjZh1dQTQafhCSWDXGMnWwdqCc8NT7PBhRRsWlGadvldNFpeGQfEf2vjuFK
         v/T6Pb2xGf9U8msLYZVlJRHXzU8qBH+Kzg6tlQfzWVs6UzssEQVIUFAJikkTYC//y2fb
         6g4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729965690; x=1730570490;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vx7n+lvYfx4acKCpfSYSV3abqUDWePGSSogzQMnaXSA=;
        b=Qt+gG73HvKfdMxWQR/0mQJ1zQ6hxWpcCIrjNG0jbajX+9iq11DjHCy2TWtZqtH4A6N
         40cq49Ovg+EDxji1S46tZgANtoWz/HjpnnA7gZD8CTfJyOXcnmWVEdBdR+F0j7AhgyAe
         M3QfPdiMhZ28e2BqCU1ypK8I2s31O8WTlhyfPQe8G/1J7OHGw5VMxJtSfNrhsdNS9yKv
         dB9is4vCgC3gVmuhw6lXutqBEx+kvNdQxASn/8ujUKNNy+tazvYiL8/fO6aO/mEfIzDW
         yOn8L4qAHwjWb8XZBYRtwW+QKwqeSWha0BF5GbOX8XxGjsxXPA5otu7V5e0zucjLL9wu
         1FnQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/BFKPVlG6++PP5tkd2yIgYOMEDBsC3GSVhK3PBl5WXH9DCyi7+5fpCIZCf79eU6oTZrxmL1NbpwEO@vger.kernel.org, AJvYcCXI1L+d1sRoT/vJ/ibBYOI0KzH0wp9Z74/Bz0xDL12INfOpLELE8hKbw+kAXjpLjXRzNQBTREBatReILD4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxpzz1nWiDqvkPylkecFsORtvORJym2v0l35m7S9bps6rAzXI9n
	EmcaaIlUD//loCkW1Hdgl/NTsW7wz2QnIcB/K8oEo+bTyMZU2ZqX
X-Google-Smtp-Source: AGHT+IFFTxk5AjBJDIWypGUlpf+BmaBo7RH0V0SpW7unIBn+62dXa4zxA0B4o6er3GA8aJ+UKbjlgQ==
X-Received: by 2002:a17:90b:3848:b0:2e2:aef9:8f60 with SMTP id 98e67ed59e1d1-2e8f0d531ffmr4154393a91.0.1729965689714;
        Sat, 26 Oct 2024 11:01:29 -0700 (PDT)
Received: from localhost.localdomain ([119.28.17.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e8e3572d5asm3714962a91.17.2024.10.26.11.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Oct 2024 11:01:29 -0700 (PDT)
From: alexjlzheng@gmail.com
X-Google-Original-From: alexjlzheng@tencent.com
To: cem@kernel.org,
	djwong@kernel.org
Cc: chandanbabu@kernel.org,
	dchinner@redhat.com,
	zhangjiachen.jaycee@bytedance.com,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jinliang Zheng <alexjlzheng@tencent.com>
Subject: [PATCH] xfs: fix the judgment of whether the file already has extents
Date: Sun, 27 Oct 2024 02:01:16 +0800
Message-ID: <20241026180116.10536-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.41.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jinliang Zheng <alexjlzheng@tencent.com>

When we call create(), lseek() and write() sequentially, offset != 0
cannot be used as a judgment condition for whether the file already
has extents.

This patch uses prev.br_startoff instead of offset != 0.

Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 36dd08d13293..94e7aeed9e95 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3536,7 +3536,7 @@ xfs_bmap_btalloc_at_eof(
 	 * or it's the first allocation in a file, just try for a stripe aligned
 	 * allocation.
 	 */
-	if (ap->offset) {
+	if (ap->prev.br_startoff != NULLFILEOFF) {
 		xfs_extlen_t	nextminlen = 0;
 
 		/*
-- 
2.41.1

