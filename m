Received: from mail-pj1-f65.google.com (mail-pj1-f65.google.com [209.85.216.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5EEF32ED4A
	for <linux-xfs@vger.kernel.org>; Fri, 14 Nov 2025 15:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763133728; cv=none; b=fmjXPZyJgvZy2sUN13jVUQdbEzAXYApJ+Bh9PlgXG2W7zpRB6m+wbghD6Yg7eGKyDrvCEXDULD+rYPSU8SZdZsL6lDoFVqTsv3LkRk2JlXvPPkJ1Pxip4rdHmxpHZWm4RFIl8YWs+nh786iy7MRyD89Uo3H6kEUiPbk2BqKx0/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763133728; c=relaxed/simple;
	bh=MxuQ3439tCkN9wzG3jkskP1VwrEe6F3iqjTMze1yDZw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=f4/FD7Oi+ctuiTI/0I9QOZf+brfWGYEKKlBDxM6QCgb2K1cnhWM4noMcgx1CCWw/hUhrJ2cpgr+c+synYI9bu2cJtv2IWzlJ3g3vOdQ1Tp8dl3t00ceafKlrcKB9QCM14845aX9xXoHbFNP+waIArTV0SiLnx2kvx9F50RXQnD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E/VtbQli; arc=none smtp.client-ip=209.85.216.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E/VtbQli"
Received: by mail-pj1-f65.google.com with SMTP id 98e67ed59e1d1-3438231df5fso2354574a91.2
        for <linux-xfs@vger.kernel.org>; Fri, 14 Nov 2025 07:22:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763133726; x=1763738526; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=30oEX3U/fuyuD+ICsPgWp/MsngawZG4yRZy1PkVA8Yw=;
        b=E/VtbQliYmqGAu+JPAhsT+q1VhJPfjnFUiHdOcE4jPIArDamhIMxDSed4rlx7FODu3
         dBrp0s3kjN9Q/rf2tuy5iuf02cQinFeaQfFBCRIhSmX9z4GEP3C2CkZ0WOi9Ar+FWZ0+
         WyjUYszhMeoIqpMt09GcGMRC2FX0/DuWC48+A0PTkzgG9F7AdRp6OHuHTZdlhYzXwvvi
         Ghb+eGH/ErNqrl+iE5nZuGUGEDMjzfRIjgTjb7ouJrHS/byPrZcsEPkj78KIU7r8B9MZ
         dEhNpjVGqxQO3TeB3oGKAlpbjOKHXV6YdfdSxEoSZVaQgAoKh7Q4t3X/M/6x63t7VaGM
         9gYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763133726; x=1763738526;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=30oEX3U/fuyuD+ICsPgWp/MsngawZG4yRZy1PkVA8Yw=;
        b=F8DZp+a7l1hRiC13a+JwqNFdV+KD8//vCmASTQQ44sSu3LQzF0YlFsqUxhzqZpf/ad
         arVgdqg+3+5xOIV17F1milet7tO0TXMC6VkwPeIX39CF5RfLmOCHNiBIe70idhCmxkLD
         A+CPzv65n3hemQ7+ShgMjAELgdhsBw/GX1JMbunNRx4FlD5xXbvFSP0VBoX4OckTXyOl
         6gDkuTl13YzWonDGNOundeflvM5CJWTTfBQJMwXM6vk0IbNrWSMdwW+1sr2bpq5KQ+1B
         otWs+rceJjYpbfq/QbMDGSadD4MZXyNW9XyeobT52MhRK/jMQl801CsVQPidWyONIojL
         qPsg==
X-Forwarded-Encrypted: i=1; AJvYcCW+afW+fqZVwQxFiUIN+UI6ESakJTbPqnqJ3vUHLVwBrejgqr3UsdVtR229gw/hgbS9syehzkQkDxI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw//yFMCzOJ9BPUQN3pYEdvAn94QXYL1TJWJfLT9Ncb/LGXwkpK
	OMYPeRLyLTVMOcp5GF5nMFFEk9IX4LouDrPJ4naRkSHVY10MWgqFgqdfvqJ18r/e2bA/FA==
X-Gm-Gg: ASbGncsZi2KzzTTpGJpjiCruBoGxnyMfRiysw35K4g+3H3vRLY8D+DFrM3sfD4P6gQx
	ysVuz+Dz2k4YH3jaMrJCZODpOlZZcnQDI94sIjGQWDcLpLSWmMDWhlivY97SNea9mjNG5qTxnXt
	X0yiau4o4Z96m8zakz/lebWJwlT19fgEOXgPyUMlfJGwGLxj7VsuMwJJQUS0wnzxjUR4+LFpuOK
	zl9T4uMS4v9CuORuXde5evo8gjONm24E9B3k8sOjGyUI+DXljMs6ByfAUgpo1bDqLFZ0ZauiiLF
	nIEGzED6nZ2JNlkt/Tj8Bhh0m+clTWPx6KDlnCYJfGPujlQ5x2Pec6eDlmXm/AqCBVl6xYYYxQ6
	qlGbaTutgpNq+71zxbXxYTR3JyOTSfNEiUJm7DAAhq87YTafiP/FrOgR1uvPk8bftY2h8/xaI61
	8uUSY1olxJjDQKFT9Y9bc8EYgWvKwFzy3kA9ttRvoC/ie+Ahq/8msCoWvw
X-Google-Smtp-Source: AGHT+IE5qDC8/sUBhoCV3Ioa0esI3fdP2ilmA2reTm1EZjB6iaCbcERLeQ78kCl58RXIWpBQFSajCw==
X-Received: by 2002:a17:90a:ec84:b0:336:9dcf:ed14 with SMTP id 98e67ed59e1d1-343fa52bea5mr3951687a91.23.1763133725903;
        Fri, 14 Nov 2025 07:22:05 -0800 (PST)
Received: from HAOQINHUANG-MC0.tencent.com ([2409:8a00:1a23:4eb0:6d06:3a75:c0b6:55ee])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b9251ca3e9sm5613641b3a.29.2025.11.14.07.22.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 14 Nov 2025 07:22:05 -0800 (PST)
From: Haoqin Huang <haoqinhuang7@gmail.com>
To: chandan.babu@oracle.com,
	djwong@kernel.org,
	linux-xfs@vger.kernel.org
Cc: Haoqin Huang <haoqinhuang@tencent.com>,
	Rongwei Wang <zigiwang@tencent.com>
Subject: [PATCH] xfs: fix deadlock between busy flushing and t_busy
Date: Fri, 14 Nov 2025 23:21:47 +0800
Message-ID: <20251114152147.66688-1-haoqinhuang7@gmail.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Haoqin Huang <haoqinhuang@tencent.com>

In case of insufficient disk space, the newly released blocks can be
allocated from free list. And in this scenario, file system will
search ag->pagb_tree (busy tree), and trim busy node if hits.
Immediately afterwards, xfs_extent_busy_flush() will be called to
flush logbuf to clear busy tree.

But a deadlock could be triggered by xfs_extent_busy_flush() if
current tp->t_busy and flush AG meet:

The current trans which t_busy is non-empty, and:
  1. The block B1, B2 all belong to AG A, and have inserted into
     current tp->t_busy;
  2. and AG A's busy tree (pagb_tree) only has the blocks coincidentally.
  2. xfs_extent_busy_flush() is flushing AG A.

In a short word, The trans flushing AG A, and also waiting AG A
to clear busy tree, but the only blocks of busy tree also in
this trans's t_busy. A deadlock appeared.

The detailed process of this deadlock:

xfs_reflink_end_cow()
xfs_trans_commit()
xfs_defer_finish_noroll()
  xfs_defer_finish_one()
    xfs_refcount_update_finish_item()    <== step1. cow alloc (tp1)
      __xfs_refcount_cow_alloc()
        xfs_refcountbt_free_block()
          xfs_extent_busy_insert()       <-- step2. x1 x2 insert tp1->t_busy
    <No trans roll>
    xfs_refcount_update_finish_item()    <== step3: cow free (tp1)
      __xfs_refcount_cow_free()
        xfs_refcount_adjust_cow()
          xfs_refcount_split_extent()
            xfs_refcount_insert()
              xfs_alloc_ag_vextent_near()
                xfs_extent_busy_flush()  <-- step4: flush but current tp1->t_busy
                                             only has x1 x2 which incurs ag3's
                                             busy_gen can't increase.

Actually, commit 8ebbf262d468 ("xfs: don't block in busy flushing when freeing extents")
had fix a similar deadlock. But current flush routine doesn't
handle -EAGAIN roll back rightly.

The solution of the deadlock is fix xfs_extent_busy_flush() to
return -EAGAIN before deadlock, and make sure xfs_refcount_split_extent()
save the original extent and roll it back when it's callee
return -EAGAIN.

Signed-off-by: Haoqin Huang <haoqinhuang@tencent.com>
Signed-off-by: Rongwei Wang <zigiwang@tencent.com>
---
 fs/xfs/libxfs/xfs_refcount.c | 15 ++++++++++++++-
 fs/xfs/xfs_bmap_item.c       |  3 +++
 fs/xfs/xfs_extent_busy.c     |  7 +++++++
 fs/xfs/xfs_refcount_item.c   |  2 ++
 4 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 2484dc9f6d7e..0ecda9df40ec 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -429,6 +429,7 @@ xfs_refcount_split_extent(
 	struct xfs_refcount_irec	rcext, tmp;
 	int				found_rec;
 	int				error;
+	struct xfs_refcount_irec	saved_rcext;
 
 	*shape_changed = false;
 	error = xfs_refcount_lookup_le(cur, domain, agbno, &found_rec);
@@ -453,6 +454,9 @@ xfs_refcount_split_extent(
 	*shape_changed = true;
 	trace_xfs_refcount_split_extent(cur, &rcext, agbno);
 
+	/* Save the original extent for potential rollback */
+	saved_rcext = rcext;
+
 	/* Establish the right extent. */
 	tmp = rcext;
 	tmp.rc_startblock = agbno;
@@ -465,8 +469,17 @@ xfs_refcount_split_extent(
 	tmp = rcext;
 	tmp.rc_blockcount = agbno - rcext.rc_startblock;
 	error = xfs_refcount_insert(cur, &tmp, &found_rec);
-	if (error)
+	if (error) {
+		/*
+		 * If failed to insert the left extent, we need to restore the
+		 * right extent to its original state to maintain consistency.
+		 */
+		int ret = xfs_refcount_update(cur, &saved_rcext);
+
+		if (ret)
+			error = ret;
 		goto out_error;
+	}
 	if (XFS_IS_CORRUPT(cur->bc_mp, found_rec != 1)) {
 		xfs_btree_mark_sick(cur);
 		error = -EFSCORRUPTED;
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 80f0c4bcc483..1b5241bfc304 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -403,6 +403,9 @@ xfs_bmap_update_finish_item(
 		ASSERT(bi->bi_type == XFS_BMAP_UNMAP);
 		return -EAGAIN;
 	}
+	/* trigger a trans roll. */
+	if (error == -EAGAIN)
+		return error;
 
 	xfs_bmap_update_cancel_item(item);
 	return error;
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index da3161572735..c4dabee0c40d 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -631,6 +631,13 @@ xfs_extent_busy_flush(
 
 		if (alloc_flags & XFS_ALLOC_FLAG_FREEING)
 			return -EAGAIN;
+
+		/*
+		 * To avoid deadlocks if alloc_flags without any FLAG set
+		 * and t_busy is not empty.
+		 */
+		if (!alloc_flags && busy_gen == READ_ONCE(pag->pagb_gen))
+			return -EAGAIN;
 	}
 
 	/* Wait for committed busy extents to resolve. */
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 3728234699a2..1932ce86090b 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -416,6 +416,8 @@ xfs_refcount_update_finish_item(
 		       ri->ri_type == XFS_REFCOUNT_DECREASE);
 		return -EAGAIN;
 	}
+	if (error == -EAGAIN)
+		return error;
 
 	xfs_refcount_update_cancel_item(item);
 	return error;
-- 
2.43.5

