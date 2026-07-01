Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE71E4192FA
	for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2026 15:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782920342; cv=none; b=K7TVsb4gPPvF4s8zUqBRaSCb2kX824NUeK/glu4EfrD4vwAKbDEYQywn0oqt+MuOnl/p8iXKoLiGZdDNIKa2CKWo5S0WVJVvXeFjVGr2z97AztL0LcaAXcLd0Kal50fG1rP17x3OfqIR6TSSoDiHxZ5BBLmqf69sk6CsA4GnHu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782920342; c=relaxed/simple;
	bh=oy/6K7Ir6vTd+3B6gVCiNkhEtO7HalAuu/jjBAVh84E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t2H7nBhvLGX/lgtXp0/5+WQUrLEXSH0xbkqLiVTImS7Q4Lj6xs3EVgjk7wi+1lymYq7zEysdt97ofkQFsNXVUI2omcpTdFf7ZYVKphLxKDfYzeHO1w9fDv4cvpFFZk3Rl78KzNFkBkRLpPt2j4Kny3kTUb1hMCc2NXR2kSiZWcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kFuXZWy3; arc=none smtp.client-ip=74.125.82.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kFuXZWy3"
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-1384ebe7a10so1373425c88.1
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jul 2026 08:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782920341; x=1783525141; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mWXgMDPYqZPJvhrfAzRgEF01XjTKWBz4YWYzD68wM08=;
        b=kFuXZWy3D31Hvzf6gRt39vNlV1EA0i8I7xOpR3StHEoZxuUROZmTypfAr2R0RKeOdO
         KONFYqB1Gmc3l5vcJE18MYMCuXnyzdQsrwV2wqZhX58yEGDxxphMhTpYz+qYeGIFDScV
         c83OkDRRur7vcOP+o4P1J21OeuWFIbj5K1HJybxB3QaamOEn5eeVuPFTK8Unsh/a6eDJ
         zU75lbiCONqgwbU6tbXPh8Sv0JUpNk45/GDDa3wJaEBJ07ED340sPVX3GnqP5U0EBFqG
         es+vvvgitJjYoV61zu++kSLCiV48bvrx12+sPBTTojPqGhHGE6wRzGzkRbwV+u0k94is
         79AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782920341; x=1783525141;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mWXgMDPYqZPJvhrfAzRgEF01XjTKWBz4YWYzD68wM08=;
        b=qkn35DGHFudqBpRna/EpNlmLFqqNEkoFZyHK+r66Qem3dIHwUCRmWkR/AH8FGYH8jb
         YCOO6Woz1ZLDtkdEc/AJwicsatvMhXqCAbYICsHuRyhHwheNaunV86YmF1fbRIuFaWx4
         x21yeazvmndzoBcgw3qDuVVj1dvzXLQoejaD7HFyEfbo/rkwXx1uAS8OnDTbYe218UpF
         wA/ZKx06hibdeRfTc1P9jq+24BSrdjXiCIMnw3P1TJfOMmtGeEtVZ4wnrNurMavT70Fg
         36KzMls3BZu0b0+IQTCleNdSMHhbVK+GfwW1XoygLhX10zCTAwUpmSFaYlD+Ng13M2t2
         rmmA==
X-Gm-Message-State: AOJu0YwSG/CndqHDNmbQpUIz2ELjsSUTAuq83d88UTpI30Rx/699A8o/
	v3+ROy4vh4r8Ee8krK3+gRavsU16/jl/hrbEY5AC4e5x1QFuAwSux25YYGXEqTv46fk=
X-Gm-Gg: AfdE7clXS/c2+VMO5W4rc4tJqcKJHIP4CBE9xOE3HunPEgo1oRgKjfiDMIpyT8rU9TW
	tudalno/HZiHhQZO6nmUwk05KSY7V8k6YsXAaQBeaGmyIzpzuvXzTZZ1KosuMjrcY5LN/3M/CZc
	upDg4yarQLtBTLKEnmrZxcytJaiIHcXN9yQI1tKrnZplU78/jNSyXDk2BM+QT9WIqXIgTiFsr/Y
	DhZYDEKCBXO2l8xZc8P61tA7D/bATMVh9rF5KAOEEWrUeBiroY564x1wJ2ZT4S529d71ik03ICM
	h+AA9qsdEzXvs3PpHJMEmiSHc6px3+8gA+WPKfn5maBFNzgH0nZRCBEi3PX37vr62j6dA32KlAF
	pnpVmAgFKmrmV1PseV5D46/hv7VXRZ16LGbbeRjoDOVr/gxo6Q0VluRdyUkAim6ojMxQ656cSl1
	pYDnFqnFEO61fEH8SI2u+Vf++ZC1bveHUdbqdAH0ocqM/UDCXO9XUMgh7xTQ==
X-Received: by 2002:a05:7022:312:b0:137:eac4:82b3 with SMTP id a92af1059eb24-13b36d9f4fcmr1950779c88.17.1782920340782;
        Wed, 01 Jul 2026 08:39:00 -0700 (PDT)
Received: from fx.tailc0aff1.ts.net ([206.206.192.132])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b2cd1be7bsm15761678c88.1.2026.07.01.08.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 08:39:00 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>
Subject: [PATCH v2 1/3] xfs: drop ASSERT(0) on unrecognized log item type
Date: Wed,  1 Jul 2026 08:38:31 -0700
Message-ID: <20260701153833.3155514-3-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260701153833.3155514-2-bestswngs@gmail.com>
References: <20260701153833.3155514-2-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The item type passed to ITEM_TYPE() comes from the on-disk log, so a
fuzzed or crafted image can reach the "unrecognized type" path in
xlog_recover_reorder_trans() and trip its ASSERT(0) on a
CONFIG_XFS_DEBUG kernel.  The -EFSCORRUPTED return handles it fine; drop
the assert.

Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 fs/xfs/xfs_log_recover.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 5f984bf5698a..a1b373c68f0e 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1912,7 +1912,6 @@ xlog_recover_reorder_trans(
 			xfs_warn(log->l_mp,
 				"%s: unrecognized type of log operation (%d)",
 				__func__, ITEM_TYPE(item));
-			ASSERT(0);
 			/*
 			 * return the remaining items back to the transaction
 			 * item list so they can be freed in caller.
-- 
2.43.0

