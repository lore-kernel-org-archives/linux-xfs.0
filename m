Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BCB9296BAF
	for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 02:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763953067; cv=none; b=KM+8HQvS+pzaKigKP5njgMqTzBOzZRFfWU7UmdXwTlCGV67g51iBa0bpNkrKNfwH14WVlN1BzeheVON48WqCfE7geoBuf4+UfBKXTcwfl9G1cFAmiPKEXg0NcXzqW9zf54On3dMhBMg5GW4y7JHClIMu2JAInaB2AxyXBFAUn/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763953067; c=relaxed/simple;
	bh=W39EvEsOKZnDPgVc3vjL1URC280/rs9OxMSKpDWz+C0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GBaHX6QiqeQg5/PWSEmxlN5jJKEwz0gtGup8IUV8AfTZd7YwazWkcxTZUH1+oCtOoPqoE2Q+02U7YqCGXm4xzNTg5OCbKpzPPb7YaLFOaXuQ5LQUulT59DVhAPLC4wb+d6wEv0YGDHGeobOlE8W2kGWJwRSizNhp1a4tXX6admY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=es3r2e5j; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="es3r2e5j"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-29516a36affso54378505ad.3
        for <linux-xfs@vger.kernel.org>; Sun, 23 Nov 2025 18:57:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763953064; x=1764557864; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RkWhYF4f1lhsSHEbmYsrWUEDoM/XD4r0C+XpnxkiI8c=;
        b=es3r2e5jxI9XJcfPMggIH8P8nNDiDjsJ0Me9LddzgHyb1i3TMSJtaOT3/jRq3q83mZ
         O5R7VNra46ae/nXXcqHGRvbakFLvXVvWpqHttaumyNkJLv4Zb+XqcrO9csRKskEcZyrv
         zhSoSAEjliIrWF/OsSQq/t/1hosJJam+Butbg/YZhSj6E8yc6gSq1lWWg4Cw3sBgkg1M
         0we5vkxSFzU1RmteCbQwkMDswnkYpujwZsa6/YCxINQBoGxFgr5FFGrfPMRUG/vSjZ0o
         ASgA9iSHxvsS2dFmSUo1PjqiW7Utmp9ZrcYM66hXfsmuMnrQrO8uuH6nB0cm7EDVLIdt
         ImsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763953064; x=1764557864;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RkWhYF4f1lhsSHEbmYsrWUEDoM/XD4r0C+XpnxkiI8c=;
        b=jMK2TnzRmi59kbNJklQtVcIF2VclTYvTWeUE50EK832Rk6n2j0qGOesZEbLQfKt+M2
         UHomGSaK2anoDCZudl4lzZO+O7rlRCawaP+zRna78dUzBygrSYon02GMqcW7mi+GVEiG
         mC62e61nnQjoxx9iq3trwEjlV2WS3EQA9aZhvubukXheXwGS2mkCe5QDt1GDA8pEKt2x
         GKbm7Acmhe53ZPf7oy6hEzfjnksSk1cfRET6M1XD2EPja9EM/Dxyg3ZrJ4ZuXNcfH7jV
         h1QUklp2l/nskOik+uuUaJS5o6e6mj/Oix0Awxmm0sMNoJvHAsGaIJPqZpofxrIlccUB
         xJlw==
X-Forwarded-Encrypted: i=1; AJvYcCWg6TOef6bddZkFEakdQaj3La49nd8gCRoUglu/fAB8TN4HvD3bRtYkncKh7WaBEXc4IQjFGIqTcro=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiSOvuiDd74TooZjQteryHRdBNLWebEg25h71F3ZAW80mYGq2i
	2RGHW/7VAdWXvGZWiDQlmH1QDwZ7qtd7foZc06Opc+5lq2/0g6bfdQpN
X-Gm-Gg: ASbGncsYtOOD72YJ7eYLpSht2yve4OVPD75biJJQlp3i3yckmYdHTPRhC7Cm+cdpfSA
	tlqpedW7aPnMVUoHe9JZufE52pn1o1VRrTsOf+XQ9RHIc1olbE+4ah3UepYwpIIWSJBB0TaKZsa
	5I/mxTG6dScYXBi43kYftcVeYf48eZ9hmHCuQreMcuMPFeXNhMH3N5Q/5HkKZv4322PW1UijauW
	Jp0m0eeETDiDAFzJwqSIPuLUIGZbN73jzugUs8Xl13HiD9rjLcNpla+gTfvYfM0Mr8LBREPnBu6
	a9451CHQRniNSZiRHdTTf7LIUwKDsTGoaLPd4HGJ/txxxLWLt92jn1ILZXP9eWNkYcLfHKv4iq7
	gzP+g963U2KpenC1mNMjo3p7aFQIriE75FD9Nt3wNN20pDnkGF/u/tLHt2sWhKRts7IN1mg7QDy
	JXVyuPvvow7/P/XLpk2hFZAsWYk4P8DZKl/lTNbid8K/D1Lnk=
X-Google-Smtp-Source: AGHT+IH2vl9a4qHa0wFFFsUNbzMzey1IZwx6tJlzdt+jREZgI3T8WYYR2vo3qAu15ZJ2v/Ev109wPg==
X-Received: by 2002:a05:701b:2803:b0:11b:2138:476a with SMTP id a92af1059eb24-11c9d8539eamr4726588c88.27.1763953064432;
        Sun, 23 Nov 2025 18:57:44 -0800 (PST)
Received: from localhost (ip70-175-132-216.oc.oc.cox.net. [70.175.132.216])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93e6dbc8sm65938624c88.10.2025.11.23.18.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Nov 2025 18:57:44 -0800 (PST)
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
To: axboe@kernel.dk,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai@fnnas.com,
	hch@lst.de,
	sagi@grimberg.me,
	kch@nvidia.com,
	jaegeuk@kernel.org,
	chao@kernel.org,
	cem@kernel.org
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-xfs@vger.kernel.org,
	bpf@vger.kernel.org,
	Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Subject: [PATCH V2 1/5] block: ignore discard return value
Date: Sun, 23 Nov 2025 18:57:33 -0800
Message-Id: <20251124025737.203571-2-ckulkarnilinux@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20251124025737.203571-1-ckulkarnilinux@gmail.com>
References: <20251124025737.203571-1-ckulkarnilinux@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__blkdev_issue_discard() always returns 0, making the error check
in blkdev_issue_discard() dead code.

In function blkdev_issue_discard() initialize ret = 0, remove ret
assignment from __blkdev_issue_discard(), rely on bio == NULL check to
call submit_bio_wait(), preserve submit_bio_wait() error handling, and
preserve -EOPNOTSUPP to 0 mapping.

Signed-off-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
---
 block/blk-lib.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 3030a772d3aa..19e0203cc18a 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -87,11 +87,11 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 {
 	struct bio *bio = NULL;
 	struct blk_plug plug;
-	int ret;
+	int ret = 0;
 
 	blk_start_plug(&plug);
-	ret = __blkdev_issue_discard(bdev, sector, nr_sects, gfp_mask, &bio);
-	if (!ret && bio) {
+	__blkdev_issue_discard(bdev, sector, nr_sects, gfp_mask, &bio);
+	if (bio) {
 		ret = submit_bio_wait(bio);
 		if (ret == -EOPNOTSUPP)
 			ret = 0;
-- 
2.40.0

