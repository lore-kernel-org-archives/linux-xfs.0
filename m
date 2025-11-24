Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806E821C167
	for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 23:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764028105; cv=none; b=HLpF2sQzkhxxrVEZ7U5s2A39+Abb29cc88S2pJ3zJPw1FusYLTaM9swEz9kK/P/ODXWbV4Wa+CE3ihNSloJA7L3Ouobg/FByhWfL7Fgl5JMMFJWIw2CPTv9H1O5JYFxiKfLIQiht23NNGS2ARiinPok3zC2mIJfrRdwHGIeA5nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764028105; c=relaxed/simple;
	bh=O/JUDf1xQdyUKKqPMxOm/ySwho1/juV+ixb/yhr4OcA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PDboGCFA8WNoq4/K/fXZIZEUcHLP4J7T521TRshimn8F+YiIeahwSEcF8UB6bBopkjT1oNTRGYTnY9rzW2ypO7DNcNXJ6ogHXXRPvR7ysybY8nQYAqHhAuDF0lPlM3j9MffvNjnevpQhD8L4cqitX+biFL8mqbris4tcOHZaaMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fyRvwB0P; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fyRvwB0P"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-29844c68068so53056805ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 15:48:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764028103; x=1764632903; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YcqbQ5S4JXXbau3fgh6ZbMU20qGzRcIfkGSPAKTqhkc=;
        b=fyRvwB0PwJyRFVMmj9BwngRdyh1FxB+k80U4l3kSgDZisjLtKwedeBZ3WsHlXzv4LW
         smguUguTqO4ye5EUVlnlvpwehhBTfYAqQ/x5sNJHqkipIoz1rFFOO/xvS/2DbnpZKGWU
         NT7VSCuaOqINYCuFj77EXlZa539ZIvO0qNkghSekpJ5G0ksAQiFu5ykpDGTAVN31tJfk
         64rRkgLXr7NPb8V3l2WHWDXRrJhsD4fRRbJez9GqQhUbppDygfJEiz8/8/j6tRnC4bcU
         2SvXeNYZLlS+Zu8IJeuLKXeJkDs+fSU0LrJknD6fbkf69ZraKuFmm52FKSe5bUPXEgYv
         Qv0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764028103; x=1764632903;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YcqbQ5S4JXXbau3fgh6ZbMU20qGzRcIfkGSPAKTqhkc=;
        b=uV2zmJri0Hoz+kBcknJlsoAMrzSm6a5br5PqESya1eyMXkFR2DAqXtmJSOh1WzkP+H
         6l8sN6zx1iat/HfBF4R3n9YxMeXHGZevoS3qnLTASevgCUNDNEOKKmM4wbmDyCHo1sRa
         K9C0UqrJ2rA++jdAaH2IzmQF9av3xGiWLwFXruLevTLb+qF/4OgeLti5l+U244sWb8Oo
         6iVQny6kwDenJ3EJ43vTnNhj6xonaKgl5FMfJeBZyzJGWByGPOacS4T8vzRvtTcbI22a
         qU1/rpWdggDUkXZGg4bL/8JZW2lL9wDe6hc2bEhbd9sBYjWQgndpwZvRWujan6oruGpl
         SYow==
X-Forwarded-Encrypted: i=1; AJvYcCUOESnCa524WMp2fakDufR1roPHVvRgs9qlSO8gECw9090i3oZHIwJp4GXGvhP4EFGFhddEQxE8UTw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAai7TkY5EjEw4Od0rBun9FoL6EIlUKqkO6sMvXqfI7vmbM9Ur
	pdYFWuG6V+EhhmpMDdU2g9QuJIzHDRFIi4BZx/KgsWOTxNIwztS9vYSL
X-Gm-Gg: ASbGnctbAPnb3/ZyUsolMTUmsKr4+CGoeqTXXG5YzXztGkQKqfvC6aettbB9PNC8liv
	0uzytIClT/UAGOMqFPuk9Kje3DC7uV9lymOC8kMD2O95M336Kh5BG2yH9dsY9KnED0FDyZo7Ey5
	K3xACT7onb/ZrmC29Voy16bDWq2nkkE3PmwhuGRX+FFqDfGuagvusZCHH5SOGUeeKTumhxyxnfT
	zZqxiw2y/WUNcenaTa2T5XCG/zLq41dGArV9hISW5+MxkJ1qqcuvGWvYuWqlKB4KdQB4M588pDp
	FC8LUW0jvyl5QYG0BEEgPkLA6i9MJznd6ao9uZtWn+aeDoBKz20nkqOJed59RWs2H/lpyuzsYFo
	oKF1fYCb91U9qkoEzpH53Oqf13P5CzJe8vIDtPh6+gClQVXOqiTLsv69dw100+jJ8NJ27rlMvQi
	BQNqS6T1YYw0TtVNl1wHIgIVw+4glSDayzGKg7tE1k4JC04DE=
X-Google-Smtp-Source: AGHT+IH9F80PvdpBpbojg7Y02KngkDHXsfXBdGLUzofDSvSvFO71NKJ3uHp3bN/w9c26If04NsQEQQ==
X-Received: by 2002:a05:7022:d45:b0:11b:c1ab:bdd0 with SMTP id a92af1059eb24-11c9d863a0amr6183635c88.35.1764028102624;
        Mon, 24 Nov 2025 15:48:22 -0800 (PST)
Received: from localhost (ip70-175-132-216.oc.oc.cox.net. [70.175.132.216])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93cd457dsm72215056c88.0.2025.11.24.15.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 15:48:22 -0800 (PST)
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
	Chaitanya Kulkarni <ckulkarnilinux@gmail.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH V3 1/6] block: ignore discard return value
Date: Mon, 24 Nov 2025 15:48:01 -0800
Message-Id: <20251124234806.75216-2-ckulkarnilinux@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
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

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
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

