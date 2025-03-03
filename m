Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54281F3B87;
	Mon,  3 Mar 2025 11:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741000990; cv=none; b=Q9/8Msw0rlW3qEYua7E/ZX5ZNbbvjR+Jn6RGg+KnKvgrNHPrSuZ/m6Ph80eBIvUJnujgd095JChA06S5rK5DaTM4sTV+RhSaXPDAFSjxMmb4rwK9DBGWDxKLbId+PDEWH9y7QwaoMgXdUkd9YJc+lpFNHUhbfMk2FYlcCcaUd70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741000990; c=relaxed/simple;
	bh=pgRFXCylMnyFz+2wH2q7aqOblrt6k92oFWnlIKEiE9U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R103ZQLEwH603vWRBjyPIo+5+NVqSgyddS/6zqQyhcRl6WXu17V4JPQkHcbYjzFuYK3Jsz2c2NAYMTYXnknUKwOCimqMKXVRRp5h3gZ/9LFduy8IoWRqhtNLDFoCDh4z1RlXVrKOPf86JQqf3RU5gdAc2LQtXHdg4NfRuKcA71w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E8xLKHZJ; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E8xLKHZJ"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-22385253e2bso39305825ad.1;
        Mon, 03 Mar 2025 03:23:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741000988; x=1741605788; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EPgHkrG54K+q42US/Famf+66Z8lvveBgvmBRxljX6VA=;
        b=E8xLKHZJbJyv5Xk8JIpUC2aHLPUoZAExsKrikmTl+r1dOdVow0w/ASslleMWZdT/FC
         1l4GGZnIgApWKO3fqWCWpiHcoKVnWXmJX9hyOhzbOEb1SbmKSHODsPBDbXkY3g35Xew2
         Dl2CafdeRGnby7YJZY68EOYN+/erCApNnN7LKyAIM9JS3DNnmsXkSYJQQmP1PZsXnSih
         8eGkLDPrz/pI6Iw85GnH9k6IY+LhZT4+EWP3qdtGGRSfWLveYOf6NDlYmije0qI0AU3U
         pvf8jsHT4F4SeMwFNbuH0DS7/rxvcLfumWKKg2OU8FSjSJ1aWH/9yni6nyK0NtIwL4pn
         p+UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741000988; x=1741605788;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EPgHkrG54K+q42US/Famf+66Z8lvveBgvmBRxljX6VA=;
        b=MnEhmMRtcVEHl1KoTBaey6kMtB9mZy8kGWbWp6gNR9zd5QFIMHghvI6NgjgRO5ceM1
         2YVmBlQmB4agmZa/p5pphipw9gn4wXyIOoatn7HKMVk3dvXET3C8cJAO4asbtH7za2Xg
         3dupa1ryrjl0/UL72SBNsgvYu602G3dvZBEPt0aa2sCa0JJ3er+Zi4YRPZWZjbAvbQCz
         WEUivS6lWBg2/SHx1J0yT2Fui/i9t52KeAp78QJk4tykty2n6VPZEWmuGNCHU3Seojfz
         kjgyAMMUs/Jbntnm1uuF0xxIwdsVOeeA9N1jZASu3NfVtlLEHNa2vwySUEXfsgwYZ4YG
         7Pcw==
X-Forwarded-Encrypted: i=1; AJvYcCUbRPOcRwrPGHN9kXP8Ea2Z1JR0IPTD6836sqXQlm3re6bqbf8xzI27/2wsgz4aAkQJrHR6Qi1+jhUy@vger.kernel.org, AJvYcCUmGjC19B5tSnGFqg9ojZnuLpyJ0oqpBF/ClYk/WE1ZvTqHH+c6EabxZ+pb49BQP6S7FrIwyno+uKuSLoo=@vger.kernel.org
X-Gm-Message-State: AOJu0YySjwJUYl9G/jyQs5yDQok3lTHF0IGaknnok3yhjghhPKw9Fti2
	pJxNNXHaBC8wqHTjymSJpa0exFZ2bcEtCq7Hu3cHnmQjhWpiLY7h
X-Gm-Gg: ASbGncs8NinKWWWV5dyVBUAQb8NyA/ubokKxbc2mxaMmXa99lhSEMD1OoSHtqUZHLzR
	DvLRn37cRxyRoxCTIn0mNirdERYu/AgGiMgF50Q7eg+rM6Y2iKCd21o9BYGqqocRmLGw4rTL3Eh
	1kT2wmtqSVVAsv9xFO60dX/RFrDjSWtIUStvoMFEkmOrsjs7hlkzO5BF2ZFta7sHKuY/pFShMVl
	kjlyvdG28or7++sE39uanQsApfuUxtkdlmn0I/RDwTaO0PSSCqS5bGe3aBHibVZpuF/MR4sxB4n
	6P3z3QReSLn+AmZoUlfFYqRyHk9lsI0RwBHAhDwSbOUvD8NJOjoqwd3RwvdZ
X-Google-Smtp-Source: AGHT+IErHpp3m/+dQJ1wKnCMXfwYgqt7ZJO1PpqFe3JE/zwAUFuBPhgt4z51XeElwlMSFt2/Bc1L1Q==
X-Received: by 2002:a17:902:f607:b0:219:cdf1:a0b8 with SMTP id d9443c01a7336-22368fa8f44mr190717805ad.30.1741000987938;
        Mon, 03 Mar 2025 03:23:07 -0800 (PST)
Received: from localhost.localdomain ([119.28.17.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-223501d285csm75702485ad.34.2025.03.03.03.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Mar 2025 03:23:07 -0800 (PST)
From: Jinliang Zheng <alexjlzheng@gmail.com>
X-Google-Original-From: Jinliang Zheng <alexjlzheng@tencent.com>
To: cem@kernel.org,
	djwong@kernel.org,
	dchinner@redhat.com
Cc: alexjlzheng@tencent.com,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] xfs: don't allow log recover IO to be throttled
Date: Mon,  3 Mar 2025 19:23:01 +0800
Message-ID: <20250303112301.766938-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.41.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When recovering a large filesystem, avoid log recover IO being
throttled by rq_qos_throttle().

Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
---
 fs/xfs/xfs_bio_io.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
index fe21c76f75b8..259955f2aeb2 100644
--- a/fs/xfs/xfs_bio_io.c
+++ b/fs/xfs/xfs_bio_io.c
@@ -22,12 +22,15 @@ xfs_rw_bdev(
 	unsigned int		left = count;
 	int			error;
 	struct bio		*bio;
+	blk_opf_t		opf = op | REQ_META | REQ_SYNC;
 
 	if (is_vmalloc && op == REQ_OP_WRITE)
 		flush_kernel_vmap_range(data, count);
 
-	bio = bio_alloc(bdev, bio_max_vecs(left), op | REQ_META | REQ_SYNC,
-			GFP_KERNEL);
+	if (op == REQ_OP_WRITE)
+		opf |= REQ_IDLE;
+
+	bio = bio_alloc(bdev, bio_max_vecs(left), opf, GFP_KERNEL);
 	bio->bi_iter.bi_sector = sector;
 
 	do {
-- 
2.41.1

