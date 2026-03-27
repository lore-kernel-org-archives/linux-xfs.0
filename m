Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87682FB084
	for <linux-xfs@vger.kernel.org>; Fri, 27 Mar 2026 13:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774618288; cv=none; b=mRNS7nOh5T0Bcyoes8B/uM7EPnVVgUGQxrlTObB++RzSgJDw8M5ac6F927HBUhbKHPh+wRT3ol4oguuBL+venTHZKv11YvwW/0gov1szWC5ZIOtvTN/0tbK7u4EBUccDOiuEZU/x4vdN9lcbj6qQSJ6kl77Iu5xtBa2pQ4/zjp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774618288; c=relaxed/simple;
	bh=aWFKLLyrUGMfgtno2wrwFP6oJ6cGkB7K195WAeAuroI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FAvFE2F0eCwX25PXdB3tcHY/fbH8tF2kUD8Yb1LGHuArXOcb4bmT+boOpGAm68w8oxq4Xsxr1PL0Kxsl+fY8ehiM7Y5MQQROrPjiY+7KJKa5sr8QG4x1BRybH2LgPf3lzkivbUQ5S3/h0IQoPDzF4qSTHe+VMzGR70az8X925Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pmz+k6px; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pmz+k6px"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ad21f437eeso13599635ad.0
        for <linux-xfs@vger.kernel.org>; Fri, 27 Mar 2026 06:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774618286; x=1775223086; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vc6JenAuJhhJEAB101jmrcNR8nhg35SI5zHqwXmhxIE=;
        b=Pmz+k6pxijLRP0cqjUp4Mzd/CeOYtCzKGWpNev4OgJQNGGo7qaWLOmCTLYBOk5eOFV
         ZMmqNzB46TGnaHOiRqd+/6/bFv1wqehOe2Nylo4VtYa2ZkLVWgRSM0V7goVACfRHLSJ2
         GdKMvzaYScN2Zksrl/NN8iBhZKgAY7FGnzjmwUMo6hz8/fuaxnuF+gwvbqvZxQqQHKFN
         4oF+u2Hxh7ZG/lzHmMmzdeWGieixAU4feglexR73RZsryZYUzSYcz6XWXiGueFySlnHB
         Fz9T5Xdlqf1OAvFWv3/eTHDNPK7bOGmih+xwMfZlgIcZQYkeJwWTLrQS+T/oKqEpce3O
         9fBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774618286; x=1775223086;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vc6JenAuJhhJEAB101jmrcNR8nhg35SI5zHqwXmhxIE=;
        b=otSkyBgDvoMPwiOKwX+xSdze7TX1cpDoSuC0KHfvDbgxcaplBPHUJ2yltpmg0PJW+w
         jmfXuOS8HB4ijYxs+psgOcL4ngcm6FhDF/ITAjXJwuYwUhtxSTCxkzyh9T4aeVbt3B7j
         ZyYDBvIRgxi5hLeD1rhka6mUaNnQ48pqyTzAwazQatWekcUIWNQe9K/d2WVZhgFBXfYj
         L6rNjGqatGQ85/uEHFASE5E7gccUWrs5TjBLTZZBga6+SUIS1P/S+sPJn1jlAY7q6igO
         OFId9GbA+fHLKmkbb2KRRBHFLFsJZQXickR8FwBYbmspkjiKhK6EQq4P/6ppcsReuahj
         2L5w==
X-Gm-Message-State: AOJu0YyMzaEc287iN9xtnnuc5PFTh3ijE2ljcpacxzST3Yy/zW/WEGuE
	f574pYkhYgH/AxSISsFkuX0LAR3tpiroCbocKqIoBrnuivUQHxtXX68v
X-Gm-Gg: ATEYQzwkr8Ulv1dm7+EK9RZJEjQexJwLZUHmORjnsY77r5EIalqD4iL6wOM9Z3yW8DW
	K5OC0iBUhmDegjrrbXDZwKB/KLjO8zpO+Aoe7TPY+H6Yrv0IaBe0ux5njPjYLXvNNPLrIQ9tH7H
	nr+eC8k3k4/dlqawv9kSpWNEgi82EBxTZPHVTDUoth1f+sbUKruMvHFQ2sPlaOjd+ZpQ0Ei3gkd
	qnXB5dtG69U80mHufyUVTrrowwoUj/Neulhwix7vm3Ybx3UztaOLYnzpk1wuuG88eHS4w8gnbqp
	QkYSfGAcmSvJ6T4NDxOL2AnvEkcr0o1zMy6QAgLZous5ZEIzNg6aJUw4HuxKNOOWf9uRCNF3hoz
	Jjg63s1jHoDFKUaX2WvUT/KSQ9eksUliFV0qatTuPgvZjTa1fgkcIPAg4wz3Ypapa3U9eXD/598
	N2zYDwYcsQSkRBY7hEQA==
X-Received: by 2002:a17:902:d4cf:b0:2b0:51f6:d469 with SMTP id d9443c01a7336-2b0ce5d7ee7mr25182795ad.23.1774618286084;
        Fri, 27 Mar 2026 06:31:26 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0bc76bc66sm60170955ad.13.2026.03.27.06.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 06:31:25 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	Cen Zhang <zzzccc427@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] xfs: annotate lockless b_flags read in xfs_buf_lock
Date: Fri, 27 Mar 2026 21:11:52 +0800
Message-Id: <20260327131152.155617-1-zzzccc427@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xfs_buf_lock() reads bp->b_flags before acquiring the buffer semaphore
to check whether a stale, pinned buffer needs a log force:

    if (atomic_read(&bp->b_pin_count) && (bp->b_flags & XBF_STALE))

This races with xfs_trans_dirty_buf(), which modifies b_flags while
the buffer is locked by a transaction on another CPU.

The pre-semaphore check is a performance hint: if a stale pinned
buffer is detected, forcing the log avoids a long wait on the
semaphore.  Either outcome of the race is benign -- a false positive
triggers a harmless log force, and a false negative simply means the
caller blocks on the semaphore and the log force happens later.

Annotate the lockless read with READ_ONCE().

Fixes: ed3b4d6cdc81 ("xfs: Improve scalability of busy extent tracking")
Cc: stable@vger.kernel.org
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
 fs/xfs/xfs_buf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index d2f3c50d80e7..6819477307bd 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -988,7 +988,7 @@ xfs_buf_lock(
 {
 	trace_xfs_buf_lock(bp, _RET_IP_);
 
-	if (atomic_read(&bp->b_pin_count) && (bp->b_flags & XBF_STALE))
+	if (atomic_read(&bp->b_pin_count) && (READ_ONCE(bp->b_flags) & XBF_STALE))
 		xfs_log_force(bp->b_mount, 0);
 	down(&bp->b_sema);
 
-- 
2.34.1

