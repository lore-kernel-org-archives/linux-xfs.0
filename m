Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59F2273D76
	for <linux-xfs@vger.kernel.org>; Tue, 18 Nov 2025 07:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763451771; cv=none; b=cHI0K9tvCm5K3EVrzMvVDgU0uGlboG440PhhchfVrGvCRClhJzvLd9bLGZ+tZcVueJlNrrRANcsUFshiQIV96/vYvXG6lf2oW3giazRsuPcKqisaJIVAEculF0VWaBriMfxdtpflKwXyYmmqNkj6XENjERGsmPqxVL3JC5tDDts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763451771; c=relaxed/simple;
	bh=3y+14w/RWgc7QectdYOrrunQMgiyUfFCpyaPphbOlAI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GaHWltZhFY8XQ4Dp6o/tnA5pLtfCpSumnIR9yerSBI2CsQmBPP6PZnO8aEAI5ikI5eWXWnh/eQCbOqV4ANWKdtATc8YGjbRXxFgmRKtVbLTJZhmQhIVBxL70q7bQ3yjk6Y+E9MEknyQu6j+9vTybtjsjeCroJ9hyA5rzoYxsR64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Urv0Oub2; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Urv0Oub2"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3434700be69so6959537a91.1
        for <linux-xfs@vger.kernel.org>; Mon, 17 Nov 2025 23:42:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763451768; x=1764056568; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NxywsA1nA8TGs2RT9uGSCEgSdjJBrPjC0KiHZ/jaP8E=;
        b=Urv0Oub27QTPivc1vObIBohINVYf07zESAeg3E4nJkaoBdCuJEcGdivBltjxtUSLHg
         dZKce6G8l5OgzhFw7KWsMhLPCkI07BIyYCz+yX8KgVi8e4xZ2kY84pm3FNQc4Hkd5wB4
         CgjXQFJU/wr7eVxopVNEyfR+zgEK7vSikaccTqenWVdJjUf7KLrvJAkkfRDQkKh3ZFML
         6uYv+W/S+myuF8YHRdhQ9GFzPGUTV1kZC/vvavHbyHu5KFdswzzHtCPHlrX1LO7qKE4Z
         qRi94zY6R1Ra+sAawuQMvAVTGvGZNNuTxo4JbTE55PM+n250Ij8MNysf+INv3/96UJwd
         3v9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763451768; x=1764056568;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NxywsA1nA8TGs2RT9uGSCEgSdjJBrPjC0KiHZ/jaP8E=;
        b=QN+FmjdlmJoz+f9pgu2zBx6++yY9KDlmpwGr6ac7tkQRLFHVHbhwiqwTMH5hZGaUsZ
         a2mgMt7wgXMJqw1hbc0APjMMYCDVYxfdR5H966TDzzf11c76VRf0DM1h5FHFBcgfT8PB
         Q6w2HC6p3DtetDE2aVbXUdTUahfE+gUIEUXISFrgpTWEkNSVOcll/LTKdxMipU0Rm/Wf
         xQiGrToRC5Q3tzXMo74+dxuQPCf/ejA1iZr5El3+tkL4FOkolcjtZ3JPVDRJwt4iceiF
         ke6mJuKsusqWAXeD8pVA9V8irjXrJK9c0ERPtppzmumEdeQ6AIG9yruBz0NTm6sxdZ3e
         21iA==
X-Forwarded-Encrypted: i=1; AJvYcCVuWCI44a/1TJbSdzGEYzvmfFLw1mzTbqRB8L4WX8rUq7uOrz7WBh8VNgargfrjYFe318GdKxMF2Jo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9SuQHe3Qiwrk9PS64pjZqUv0lopHoyDClAlFqrgAn5A48yYO/
	ztVpigr44NjpsBmwJ6svBqy5HJxoZbiR83g9RjcPZR60b4/NIyMfD1QS
X-Gm-Gg: ASbGncvANa5LMmnyuVJOGew1upM/xjTNXZIEszBYJX2Hs2+XMs56o7OqnzyfDCA31B4
	GTpnbKJE3jIAFiV/FHDg+3G9UJFuw0RSv7H0Ohz671za6xSfolva90qLm2CIY/wSIrtzFTSktfV
	c4nv5rV+4IWmdao7J7RMmc6ovP9vFzsIP0D6pGpxKtBfMYHbdPBvVN+zipzdcHz/P0jRvTDV4nV
	0+9lgQ+wgGmiBYtBOWXrUQIqqpwAV4XCXagcapwF4VAX3/RNxGUv8kYZ8dwdvIwoHJxfFRNEFon
	p58DS4M6tfAuFzoXRjbJI1m7Hdvnt8Ew3UnecUEpMhfLx94RkDw3TB6Rvb/AoZE8yMlDFCT4vPw
	fJH0cW2QoWLOG07C0AC4x4RJn15yKH4fMWrUgRwIBRgZ9Du97Lasm12rIMoIWhkI5D5oU+AeKxf
	Fl5ovZ6KuDhy/uL+WubTxGq1C/ilqTEH6uW39hIwDQzuq3SfjwO/q0d0K+vg==
X-Google-Smtp-Source: AGHT+IEP4Fiq1WYi0fQwUxT7w8CcXRrYGmKQQRpSmtx18AEGOxK4QGIRV7JKkjFv4nGOrRKeWjhvWA==
X-Received: by 2002:a05:7022:69aa:b0:11b:3742:1257 with SMTP id a92af1059eb24-11b4120ca2amr9929883c88.34.1763451767829;
        Mon, 17 Nov 2025 23:42:47 -0800 (PST)
Received: from localhost (ip70-175-132-216.oc.oc.cox.net. [70.175.132.216])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11b06088625sm58814092c88.8.2025.11.17.23.42.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 23:42:47 -0800 (PST)
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
To: linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-xfs@vger.kernel.org
Cc: axboe@kernel.dk,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com,
	hch@lst.de,
	sagi@grimberg.me,
	kch@nvidia.com,
	jaegeuk@kernel.org,
	chao@kernel.org,
	cem@kernel.org,
	Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Subject: [RFC PATCH] block: change __blkdev_issue_discard() return type to void
Date: Mon, 17 Nov 2025 23:42:43 -0800
Message-Id: <20251118074243.636812-1-ckulkarnilinux@gmail.com>
X-Mailer: git-send-email 2.40.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__blkdev_issue_discard() always returns 0, making all error checking
at call sites dead code. The function simply stops allocating bios 
and returns 0.

Discard operations are advisory/optimization, not critical. Some callers
have dead error checking code expecting wrong return codes such as
-ENOTSUPP when 0 is only returned. 

This patch changes __blkdev_issue_discard() return type to void and
removes dead error checking code from all call sites:

* Block layer:
  blk-lib.c: Remove return value, update blkdev_issue_discard() caller

* Device mapper:
  dm-thin.c: Change issue_discard() to void, update both callers
  md.c: Simplify conditional to just check for NULL bio

* NVMe target:
  io-cmd-bdev.c: Remove dead error handling and error_slba assignment

* Filesystems:
  f2fs/segment.c: Preserve fault injection
  xfs/xfs_discard.c: Update both xfs_discard_extents() and
  xfs_discard_rtdev_extents() to remove dead error checks

Signed-off-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
---
Hi,

Due to involvement of all the subsystem making it as an RFC, ideally
it shuoldn't be an RFC.

-ck
---
 block/blk-lib.c                   |  7 +++----
 drivers/md/dm-thin.c              | 12 +++++-------
 drivers/md/md.c                   |  4 ++--
 drivers/nvme/target/io-cmd-bdev.c |  7 +------
 fs/f2fs/segment.c                 |  2 +-
 fs/xfs/xfs_discard.c              | 17 +++--------------
 include/linux/blkdev.h            |  2 +-
 7 files changed, 16 insertions(+), 35 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 3030a772d3aa..ca78ec6b5326 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -60,7 +60,7 @@ struct bio *blk_alloc_discard_bio(struct block_device *bdev,
 	return bio;
 }
 
-int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
+void __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, struct bio **biop)
 {
 	struct bio *bio;
@@ -68,7 +68,6 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	while ((bio = blk_alloc_discard_bio(bdev, &sector, &nr_sects,
 			gfp_mask)))
 		*biop = bio_chain_and_submit(*biop, bio);
-	return 0;
 }
 EXPORT_SYMBOL(__blkdev_issue_discard);
 
@@ -90,8 +89,8 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	int ret;
 
 	blk_start_plug(&plug);
-	ret = __blkdev_issue_discard(bdev, sector, nr_sects, gfp_mask, &bio);
-	if (!ret && bio) {
+	__blkdev_issue_discard(bdev, sector, nr_sects, gfp_mask, &bio);
+	if (bio) {
 		ret = submit_bio_wait(bio);
 		if (ret == -EOPNOTSUPP)
 			ret = 0;
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
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 41c476b40c7a..7fc0bb7a3814 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9041,8 +9041,8 @@ void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
 {
 	struct bio *discard_bio = NULL;
 
-	if (__blkdev_issue_discard(rdev->bdev, start, size, GFP_NOIO,
-			&discard_bio) || !discard_bio)
+	__blkdev_issue_discard(rdev->bdev, start, size, GFP_NOIO, &discard_bio);
+	if (!discard_bio)
 		return;
 
 	bio_chain(discard_bio, bio);
diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-cmd-bdev.c
index 8d246b8ca604..f26010c46c33 100644
--- a/drivers/nvme/target/io-cmd-bdev.c
+++ b/drivers/nvme/target/io-cmd-bdev.c
@@ -366,16 +366,11 @@ static u16 nvmet_bdev_discard_range(struct nvmet_req *req,
 		struct nvme_dsm_range *range, struct bio **bio)
 {
 	struct nvmet_ns *ns = req->ns;
-	int ret;
 
-	ret = __blkdev_issue_discard(ns->bdev,
+	__blkdev_issue_discard(ns->bdev,
 			nvmet_lba_to_sect(ns, range->slba),
 			le32_to_cpu(range->nlb) << (ns->blksize_shift - 9),
 			GFP_KERNEL, bio);
-	if (ret && ret != -EOPNOTSUPP) {
-		req->error_slba = le64_to_cpu(range->slba);
-		return errno_to_nvme_status(req, ret);
-	}
 	return NVME_SC_SUCCESS;
 }
 
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index b45eace879d7..e6078176f733 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1346,7 +1346,7 @@ static int __submit_discard_cmd(struct f2fs_sb_info *sbi,
 		if (time_to_inject(sbi, FAULT_DISCARD)) {
 			err = -EIO;
 		} else {
-			err = __blkdev_issue_discard(bdev,
+			__blkdev_issue_discard(bdev,
 					SECTOR_FROM_BLOCK(start),
 					SECTOR_FROM_BLOCK(len),
 					GFP_NOFS, &bio);
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index ee49f20875af..f82cc07806df 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -116,7 +116,6 @@ xfs_discard_extents(
 	struct xfs_extent_busy	*busyp;
 	struct bio		*bio = NULL;
 	struct blk_plug		plug;
-	int			error = 0;
 
 	blk_start_plug(&plug);
 	list_for_each_entry(busyp, &extents->extent_list, list) {
@@ -126,18 +125,10 @@ xfs_discard_extents(
 
 		trace_xfs_discard_extent(xg, busyp->bno, busyp->length);
 
-		error = __blkdev_issue_discard(btp->bt_bdev,
+		__blkdev_issue_discard(btp->bt_bdev,
 				xfs_gbno_to_daddr(xg, busyp->bno),
 				XFS_FSB_TO_BB(mp, busyp->length),
 				GFP_KERNEL, &bio);
-		if (error && error != -EOPNOTSUPP) {
-			xfs_info(mp,
-	 "discard failed for extent [0x%llx,%u], error %d",
-				 (unsigned long long)busyp->bno,
-				 busyp->length,
-				 error);
-			break;
-		}
 	}
 
 	if (bio) {
@@ -149,7 +140,7 @@ xfs_discard_extents(
 	}
 	blk_finish_plug(&plug);
 
-	return error;
+	return 0;
 }
 
 /*
@@ -496,12 +487,10 @@ xfs_discard_rtdev_extents(
 
 		trace_xfs_discard_rtextent(mp, busyp->bno, busyp->length);
 
-		error = __blkdev_issue_discard(bdev,
+		__blkdev_issue_discard(bdev,
 				xfs_rtb_to_daddr(mp, busyp->bno),
 				XFS_FSB_TO_BB(mp, busyp->length),
 				GFP_NOFS, &bio);
-		if (error)
-			break;
 	}
 	xfs_discard_free_rtdev_extents(tr);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f0ab02e0a673..b05c37d20b09 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1258,7 +1258,7 @@ extern void blk_io_schedule(void);
 
 int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask);
-int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
+void __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, struct bio **biop);
 int blkdev_issue_secure_erase(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp);
-- 
2.40.0

