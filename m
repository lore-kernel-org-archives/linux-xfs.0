Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71831EB5F8
	for <linux-xfs@vger.kernel.org>; Wed,  6 May 2026 01:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778029547; cv=none; b=CdZeG0Fkcdsa7nM4ctcrVRM+HLeopkvQWKp5R0ywsB78LcX8WHit7ZON1PwHYcYyJgNYkOfDWzsB9T9/rdZhhsBuTL4GsRErt1Tum+YnIJZXrewkV1FvNl0Y7UOp1xnDKj5pgp1fi8LKTFs9wOjyKJw8mgM9vIp2HBKVHSVyrvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778029547; c=relaxed/simple;
	bh=es4nNkQvw9RkbvnfhA8gDq/y3/eD9NZZ6kUxrsHKmMo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Pjou6tOdH9gBViDSjfGhFLMwFgmNueiMKQNy0yAn1oU87rLnDEQcpLGrGRZxn1Q4lJk1VjWpAqBHfy+00BHb9rWK2G13xCRsqoEo4qqau+rIlTMNiGYZwJQraeJMi2ctyI2tajN8j6lR5vEzGtl9DCkzQw7cCpl2pCZr6S3LwgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UHL3kwLK; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UHL3kwLK"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2b7d3ecc10dso53952445ad.2
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2026 18:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778029545; x=1778634345; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bYn9EWYy6d6qNj1bK/TNzgSNgeUONhEknxsFBug8LyU=;
        b=UHL3kwLKHbHKJZ5eRNEsGLcMlZ55mnBwnRwb4XumC/LbkrpoYUu4vGKwc/zeTuehSx
         z6Om51KZQY4rCFz8y511etMe2859Na0C+AmeBZ6ye2mi4uEYoMLx0KuK1DtWRtonBIF1
         Xws1qzYmTSGSWEibQkeI+veWQxYM3no0ECJnvaZ/frv7iJlnLgXKL0nLit37Uf9JKBvI
         I3UPy5+Uo2pwl6zo5XoKUUuYB42UNs9PSQdDf6nTpobvwkw+vhjh94wPA/WixyS3IQZP
         8UmMUJhPupc0/TegM6z0mVQD788O0AU/0SNklvMsOYOab/dn3wnjZX3Fo90CR1o6jGMI
         7wRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778029545; x=1778634345;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bYn9EWYy6d6qNj1bK/TNzgSNgeUONhEknxsFBug8LyU=;
        b=bgSV2RQOjOma4abSNiOX84ShIVPkLFGKeLZu4OrhtXkOQMCJjiW+1urpOtcu/PEhCz
         eLRGEyRRJRxW/QfuIfTr0SM3J5NNLTm0GxuDfqL/X8OV3PTsRNMA9QUYt8PXg9+4qqFz
         XZaMwTYqb4KSnd3ed+E/dNTwU0iwV+BX1xe+In2deuhLU3/2iXxojDj6RwYRQjsEO1lF
         BmZTDOHuck/2MxFIRsxoeDRmLYcvkusTzGj220Nc42aATGgOlB6pBFiyF8KUoXD8JXT4
         xnJHs8PpLE5spPhUK8mUXtfIrU/aW4t+8tdV/hwJyi2IrGR08B+muXoGEAANgV8t31me
         lwnw==
X-Gm-Message-State: AOJu0Yw06Qee3AWtRu2kItC19GzTB+7K6gBYEPyYg8JnkspLA1H4L0bA
	ei+L3N5MpSOwYOMhvD6vjnQd1I6wSbwqrVPwO8MmxjQ+R4ci90F0iX8X
X-Gm-Gg: AeBDieuf5LjGHEJIgFhZt6mTT1DEoCMP9HvjJtZlUMmBN1W0hq7C6bABxdqYmGdYvkA
	Sibi2OOEG8/h3e0NVr56tEqGOKmrT/h1UaqD2pZqnc6PKOgOFp8AWeO1g+Kzz8wE48CaiVi0amB
	2K5WS6CGlJ3CBkBEf7ou37m+5hUoKy1LVKOu/50IiFgknsrHHSNSM8xGnBnbUORECRjzrR/59dk
	97FnyE50OBJUfF8oDJgd+4xiOtKtMl4lhJ9QA5coDFQdY0LxCshbMK/P8PcfN2NZEWdC+6omd34
	ifuoIM3VqU2TkYCNuUcFc4iy5zMP+QOrRkpHZX6Emaepv/EYlaT0Hq90XWUJXVBF2fZIsNbAHlS
	QN7lD+GWLXSkW8XuO28gT3fDjhgokBKnEYQVIHWCTaCTGMCu0KJZ8B2Wwk/HPktAAXzqFonSCFH
	c0RvUAG8N6raPLXAKncHBzsTjrU6I+5XB+LYEuAY8=
X-Received: by 2002:a17:903:1a23:b0:2b7:aba0:ac10 with SMTP id d9443c01a7336-2ba78f52dfdmr12284915ad.11.1778029545085;
        Tue, 05 May 2026 18:05:45 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ba7ca106e8sm5215295ad.62.2026.05.05.18.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 18:05:44 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	Cen Zhang <zzzccc427@gmail.com>
Subject: [PATCH] xfs: order log tail accounting before grant head returns
Date: Wed,  6 May 2026 09:05:33 +0800
Message-Id: <20260506010533.3282845-1-zzzccc427@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The log reservation fast path computes available space from l_tail_space
and a grant head without taking the AIL lock.  CIL completion moves a
committed checkpoint's consumed bytes from grant-head accounting to
l_tail_space by advancing the AIL head/tail accounting before subtracting
the same amount from both grant heads.

That transfer must not be observed as a smaller grant head with the old
l_tail_space value.  Such a mixed snapshot makes the free-space calculation
spuriously larger by the transferred amount and can allow a reservation
that should have waited.

The existing smp_wmb()/smp_rmb() comments describe that intent, but the
reader samples l_tail_space after the read barrier and before the grant
head.  In addition, the writer orders a normal store against unordered
atomic64_sub() operations, for which the atomic documentation specifies
smp_mb__before_atomic().

Put the write-side barrier immediately before the grant-head atomic
subtractions.  Sample the grant head before l_tail_space on the read side.
This makes observing returned grant space imply visibility of the matching
tail-space accounting update.

Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
 fs/xfs/xfs_log.c     | 21 +++++++++++++--------
 fs/xfs/xfs_log_cil.c |  1 -
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f807f8f4f7058..de56c707027d9 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -113,17 +113,21 @@ xlog_grant_return_space(
 {
 	int64_t		diff = xlog_lsn_sub(log, new_head, old_head);
 
+	/*
+	 * Publish the tail-space update before dropping the grant heads so
+	 * readers cannot observe returned grant space without the matching
+	 * tail-space accounting.
+	 */
+	smp_mb__before_atomic();
 	xlog_grant_sub_space(&log->l_reserve_head, diff);
 	xlog_grant_sub_space(&log->l_write_head, diff);
 }
 
 /*
  * Return the space in the log between the tail and the head.  In the case where
- * we have overrun available reservation space, return 0. The memory barrier
- * pairs with the smp_wmb() in xlog_cil_ail_insert() to ensure that grant head
- * vs tail space updates are seen in the correct order and hence avoid
- * transients as space is transferred from the grant heads to the AIL on commit
- * completion.
+ * we have overrun available reservation space, return 0.  Sample the grant
+ * head before l_tail_space so that seeing returned grant space implies seeing
+ * the matching tail-space update from xlog_grant_return_space().
  */
 static uint64_t
 xlog_grant_space_left(
@@ -131,10 +135,11 @@ xlog_grant_space_left(
 	struct xlog_grant_head	*head)
 {
 	int64_t			free_bytes;
+	s64			grant;
 
-	smp_rmb();	/* paired with smp_wmb in xlog_cil_ail_insert() */
-	free_bytes = log->l_logsize - READ_ONCE(log->l_tail_space) -
-			atomic64_read(&head->grant);
+	grant = atomic64_read(&head->grant);
+	smp_rmb();	/* paired with smp_mb__before_atomic in xlog_grant_return_space */
+	free_bytes = log->l_logsize - READ_ONCE(log->l_tail_space) - grant;
 	if (free_bytes > 0)
 		return free_bytes;
 	return 0;
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index edc368938f305..ea0efabdc9990 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -876,7 +876,6 @@ xlog_cil_ail_insert(
 	 * available on return, only for it to disappear again immediately as
 	 * the AIL head update accounts in the log tail space.
 	 */
-	smp_wmb();	/* paired with smp_rmb in xlog_grant_space_left */
 	xlog_grant_return_space(ailp->ail_log, old_head, ailp->ail_head_lsn);
 
 	/* unpin all the log items */
