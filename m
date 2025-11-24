Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546C426F28F
	for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 23:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764028108; cv=none; b=Sysn8FzMoHj5MH+Aw73N39mVxgSoF3YJmOsShMFgZeemhsmBa20M6pcWdywgnIE+ItMovE8pialaA1o/sZzNXUmESNdemC9IIFLKw9/8k0JPxA0Vk5iOgcmD/yVoAyEp7fPNoktkFcqna7JkfL2cuagxGzTxt2UuFIPDOX/VzOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764028108; c=relaxed/simple;
	bh=LiJgbQPzVCy/nNKtdgxFtiNJpUa7IyMaSDSo31f8t5g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WbHyln55CEqw3dksK1oMLNNsgC+qsCRAqEGbTUA2oXoC9sqO6d9yV5v/18GVVCXSAuI137Blru1nsWv2fF/DaFH6t7CgGbl8ijpLr7zCG8GIN8+ieG+MKVZ2hnNyTRxCyPYvhFsAYIcyU6+9iuP3ES2I0K1Vlx7DF1CtsWOuznU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QWk8Up6s; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QWk8Up6s"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2956d816c10so57196005ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 24 Nov 2025 15:48:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764028105; x=1764632905; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x5IpKKGvYwA44MA2SdIRqzoysh0eqDWrauHh/IuigN8=;
        b=QWk8Up6sn3lYBV/iB9lZxGmffbRvzawOFw5BgJ2PYx9NHD+dLKfyI3JTqNp513mBEV
         vrxwKhuZvodq3ta/8e4Xw5HFvIU3H7v0KYCuuUctkaSPfrE0kSCNUQgtQ+u9zI4mJNlR
         9JXIbL7tPP5otS/iH/1e1KJW/G0Fae76007IVjPvsLWohUyZ/1bqGEzeiRa5Sr5fu9S1
         6c2+gnEtNhBQpacrDuwF0WcYEIRDiSmoF3icXb3ZZUFcoh31hsAyvty0UVz/c3gHwQQh
         UpRwTviaUPAqYFlZrZd5CHzBVfcGHREOtF3zC0bY4WYeylVTQn3LlTzZSOnjHYrK0m0T
         TsjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764028105; x=1764632905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=x5IpKKGvYwA44MA2SdIRqzoysh0eqDWrauHh/IuigN8=;
        b=AlAXGCWUkZeX78JFVTX5z1PjNSGR77r3YF6CkWsKoeGQqtBcN4CHmWllkjGPRUdjzS
         mAkwiAMs7Qigxa3mzdNN5Ixx0r2qImv3Rw+YGdFOFuw6qSqYzjHGGAp38+6Qbtrgfj5Q
         n3mabBznI8bEfzTsxnyiYsEGT0+QV1ZWQ4tkl4MK91KX5mNDKl8BQPgIOYHp9gsEe3cd
         aVA/nbflGqf/LBWiePQYaj340SGre2VbBBYmzsCNzjKSu4c05J4shBUgHry96OwZlA3+
         1Uu11v+Tl6PNm1Z36d7FMnvms+jEJ6Wh7ABL9NtuBVeCGoRBxuE1Zd6lswb+5kK7utcF
         7y5w==
X-Forwarded-Encrypted: i=1; AJvYcCXqVhmkWXdCy6iyqGbuqR6JDP5XsKYew2rVRRKCtYUvrYjcYkbU6LFlzXGlEcqBK9LWTNykf9LGPFw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOMz8jfFetz+izDrA+NdLUaQn7fm6irHQ9hWOHUy8xHpOdukjn
	r68+NBDQFNwkQvGLJHz+zOnFnBJFJr7NQMqyivVkqILggWCC7zCTLerZ
X-Gm-Gg: ASbGncu2pCWa6optFVUWP2sFoQXmgX8oNQsiBBbAN0PKbY/AjMvVSzEVO/z0e/nNRWG
	5RnzTCJRxp62G0rJcJQm7ISn9ZCeFT44wMzW7t8g+osKd4gK14fM5tYvJi5QOcsqMdriA3cMh29
	4R9mw1uJK1APc25qJtujqX+oQkjAdaXdNW/GWnkwmNWXFV8eOP44Vz6DPOdNUbHmQ3YiLA2BQWe
	5EeAGQlO1e7so3pCOgOWtvKcjs6Sa5yJftGie0XzsUuxMKhQNDQKz5eQyYlVcuINAqmjFS7yAsH
	mWdutD8Mgjschbf6xhhv8ySZo1+QZpfvWtE9UydC0kuOmqHattNPUkXBYIynIk6Pqkut8XR+3fy
	p8hQJI50mPhAV+5YM03mPGNKfcEMTnlzvJIUSNwGmZyksEdWV1+txBiYbCT21xCyQirp+zXBajJ
	HJUxwcI6e/lrZdaamZQpGfxLWYTe40sBALkrxZSP0HODJIo2VY6+osHI8P7A==
X-Google-Smtp-Source: AGHT+IGUjnYuQU4uZ65RexnKMVsIkRo4SljblPDkF73f7cjoVp9uAJMvqcbsbNcZ8FiTC+XwEcc2Xg==
X-Received: by 2002:a05:7022:6610:b0:11b:9386:a37b with SMTP id a92af1059eb24-11c9d870ef7mr10566206c88.42.1764028105314;
        Mon, 24 Nov 2025 15:48:25 -0800 (PST)
Received: from localhost (ip70-175-132-216.oc.oc.cox.net. [70.175.132.216])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93de6d5csm50934572c88.4.2025.11.24.15.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 15:48:25 -0800 (PST)
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
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH V3 3/6] dm: ignore discard return value
Date: Mon, 24 Nov 2025 15:48:03 -0800
Message-Id: <20251124234806.75216-4-ckulkarnilinux@gmail.com>
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

__blkdev_issue_discard() always returns 0, making all error checking
at call sites dead code.

For dm-thin change issue_discard() return type to void, in
passdown_double_checking_shared_status() remove the r assignment from
return value of the issue_discard(), for end_discard() hardcode value of 
r to 0 that matches only value returned from __blkdev_issue_discard().

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
---
 drivers/md/dm-thin.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index c84149ba4e38..77c76f75c85f 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -395,13 +395,13 @@ static void begin_discard(struct discard_op *op, struct thin_c *tc, struct bio *
 	op->bio = NULL;
 }
 
-static int issue_discard(struct discard_op *op, dm_block_t data_b, dm_block_t data_e)
+static void issue_discard(struct discard_op *op, dm_block_t data_b, dm_block_t data_e)
 {
 	struct thin_c *tc = op->tc;
 	sector_t s = block_to_sectors(tc->pool, data_b);
 	sector_t len = block_to_sectors(tc->pool, data_e - data_b);
 
-	return __blkdev_issue_discard(tc->pool_dev->bdev, s, len, GFP_NOIO, &op->bio);
+	__blkdev_issue_discard(tc->pool_dev->bdev, s, len, GFP_NOIO, &op->bio);
 }
 
 static void end_discard(struct discard_op *op, int r)
@@ -1113,9 +1113,7 @@ static void passdown_double_checking_shared_status(struct dm_thin_new_mapping *m
 				break;
 		}
 
-		r = issue_discard(&op, b, e);
-		if (r)
-			goto out;
+		issue_discard(&op, b, e);
 
 		b = e;
 	}
@@ -1188,8 +1186,8 @@ static void process_prepared_discard_passdown_pt1(struct dm_thin_new_mapping *m)
 		struct discard_op op;
 
 		begin_discard(&op, tc, discard_parent);
-		r = issue_discard(&op, m->data_block, data_end);
-		end_discard(&op, r);
+		issue_discard(&op, m->data_block, data_end);
+		end_discard(&op, 0);
 	}
 }
 
-- 
2.40.0

