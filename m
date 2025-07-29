Received: from mail.cybernetics.com (mail.cybernetics.com [72.215.153.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FF4298989
	for <linux-xfs@vger.kernel.org>; Tue, 29 Jul 2025 16:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=72.215.153.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753806314; cv=none; b=QQlJxNXkyyUEmf3aywZUcoG4tAtq2+8i6R/L1/3znrm3w+ubysJ2JC/Gk56Ri2i+7AKJKz6ZWoKNYznV7076UMyLR2vwJAw/F9nicrdXkp5gz+syq/HqCwZmtctlb1BbIr5ORi28PqNR/z0L+Y5ZBG3zq69jwf/4JrhDK9krHHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753806314; c=relaxed/simple;
	bh=EwQssKw4MFI0b8DOO/jMo2dMW5T35D5KT9R1zjlTE8U=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=HIfHHYhG5b9MzKxxRQcQJNQ4OoOTbijmI27pzljSI+gA5aboM+x7ySJ7/+v4nxwrTGMt73PjwCwUHx9zazApEVqXbdmy0oBShtQ61MieM0mI1UyfgZafAl+kM/JApopXkrRPAqF253rw3Cc446Ag4FOqJnzO6gghKEXPZp7KyI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com; spf=pass smtp.mailfrom=cybernetics.com; dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b=E87k4PUE; arc=none smtp.client-ip=72.215.153.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cybernetics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cybernetics.com header.i=@cybernetics.com header.b="E87k4PUE"
Received: from cybernetics.com ([10.10.4.126]) by mail.cybernetics.com with ESMTP id GlbT4Fwzm4ik2ySl; Tue, 29 Jul 2025 12:12:37 -0400 (EDT)
X-Barracuda-Envelope-From: tonyb@cybernetics.com
X-Barracuda-RBL-Trusted-Forwarder: 10.10.4.126
X-ASG-Whitelist: Client
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cybernetics.com; s=mail;
	bh=JRBFo+iaoV9LA1JO9CrpPbhQ4jDDfGQVXrT94xqApNo=;
	h=Content-Transfer-Encoding:Content-Type:Subject:From:Cc:To:Content-Language:
	MIME-Version:Date:Message-ID; b=E87k4PUEZDKXqav3kMl7covqlZtXje26RUGNmgR/5ouUl
	IZle9c8ZBVo4sQKSeENJC3w0uZvwDSI+1sL4chEmGxEXkRcDs7kF0DGKlk4liWP5TYwrDlsZ4x6t3
	rNKNGH/Byja1GpSUer+03ERh2n1GEFQ2DS4DqMm/hApOXDCZU=
Received: from [10.157.2.224] (HELO [192.168.200.1])
  by cybernetics.com (CommuniGate SPEC SMTP 8.0.5)
  with ESMTPS id 14113433; Tue, 29 Jul 2025 12:12:37 -0400
Message-ID: <b122fa8c-f6a0-4dee-b998-bde65d212c11@cybernetics.com>
X-Barracuda-RBL-Trusted-Forwarder: 10.157.2.224
Date: Tue, 29 Jul 2025 12:12:37 -0400
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
 Christian Brauner <brauner@kernel.org>, "Darrick J. Wong"
 <djwong@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: linux-raid@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH 1/2] md/raid0,raid4,raid5,raid6,raid10: fix bogus io_opt value
Content-Type: text/plain; charset=UTF-8
X-ASG-Orig-Subj: [PATCH 1/2] md/raid0,raid4,raid5,raid6,raid10: fix bogus io_opt value
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: UNKNOWN[10.10.4.126]
X-Barracuda-Start-Time: 1753805557
X-Barracuda-URL: https://10.10.4.122:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Virus-Scanned: by bsmtpd at cybernetics.com
X-Barracuda-Scan-Msg-Size: 4897
X-ASG-Debug-ID: 1753805557-1cf43947df80170001-7j46Zh

md-raid currently sets io_min and io_opt to the RAID chunk and stripe
sizes and then calls queue_limits_stack_bdev() to combine the io_min and
io_opt values with those of the component devices.  The io_opt size is
notably combined using the least common multiple (lcm), which does not
work well in practice for some drives (1), resulting in overflow or
unreasonable values.

dm-raid, on the other hand, sets io_min and io_opt through the
raid_io_hints() function, which is called after stacking all the queue
limits of the component drives, so the RAID chunk and stripe sizes
override the values of the stacking.

Change md-raid to be more like dm-raid by setting io_min and io_opt to
the RAID chunk and stripe sizes after stacking the queue limits of the
component devies.  This fixes /sys/block/md0/queue/optimal_io_size from
being a bogus value like 3221127168 to being the correct RAID stripe
size.

(1) SATA disks attached to mpt3sas report io_opt = 16776704, or
2^24 - 512.  See also commit 9c0ba14828d6 ("blk-settings: round down
io_opt to physical_block_size").

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
 drivers/md/md.c     | 15 +++++++++++++++
 drivers/md/raid0.c  |  4 ++--
 drivers/md/raid10.c |  4 ++--
 drivers/md/raid5.c  |  4 ++--
 4 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0f03b21e66e4..decf593d3bd7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5837,11 +5837,15 @@ EXPORT_SYMBOL_GPL(mddev_stack_rdev_limits);
 int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev)
 {
 	struct queue_limits lim;
+	unsigned int io_min;
+	unsigned int io_opt;
 
 	if (mddev_is_dm(mddev))
 		return 0;
 
 	lim = queue_limits_start_update(mddev->gendisk->queue);
+	io_min = lim.io_min;
+	io_opt = lim.io_opt;
 	queue_limits_stack_bdev(&lim, rdev->bdev, rdev->data_offset,
 				mddev->gendisk->disk_name);
 
@@ -5851,6 +5855,17 @@ int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev)
 		queue_limits_cancel_update(mddev->gendisk->queue);
 		return -ENXIO;
 	}
+	switch (mddev->level) {
+	case 0:
+	case 4:
+	case 5:
+	case 6:
+	case 10:
+		/* Preserve original chunk size and stripe size. */
+		lim.io_min = io_min;
+		lim.io_opt = io_opt;
+		break;
+	}
 
 	return queue_limits_commit_update(mddev->gendisk->queue, &lim);
 }
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index d8f639f4ae12..657e66e92e14 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -382,12 +382,12 @@ static int raid0_set_limits(struct mddev *mddev)
 	md_init_stacking_limits(&lim);
 	lim.max_hw_sectors = mddev->chunk_sectors;
 	lim.max_write_zeroes_sectors = mddev->chunk_sectors;
-	lim.io_min = mddev->chunk_sectors << 9;
-	lim.io_opt = lim.io_min * mddev->raid_disks;
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err)
 		return err;
+	lim.io_min = mddev->chunk_sectors << 9;
+	lim.io_opt = lim.io_min * mddev->raid_disks;
 	return queue_limits_set(mddev->gendisk->queue, &lim);
 }
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c9bd2005bfd0..ea5147531ceb 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4011,12 +4011,12 @@ static int raid10_set_queue_limits(struct mddev *mddev)
 
 	md_init_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
-	lim.io_min = mddev->chunk_sectors << 9;
-	lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
 	lim.features |= BLK_FEAT_ATOMIC_WRITES;
 	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
 	if (err)
 		return err;
+	lim.io_min = mddev->chunk_sectors << 9;
+	lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
 	return queue_limits_set(mddev->gendisk->queue, &lim);
 }
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ca5b0e8ba707..bba647c38cff 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7727,8 +7727,6 @@ static int raid5_set_limits(struct mddev *mddev)
 	stripe = roundup_pow_of_two(data_disks * (mddev->chunk_sectors << 9));
 
 	md_init_stacking_limits(&lim);
-	lim.io_min = mddev->chunk_sectors << 9;
-	lim.io_opt = lim.io_min * (conf->raid_disks - conf->max_degraded);
 	lim.features |= BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE;
 	lim.discard_granularity = stripe;
 	lim.max_write_zeroes_sectors = 0;
@@ -7736,6 +7734,8 @@ static int raid5_set_limits(struct mddev *mddev)
 	rdev_for_each(rdev, mddev)
 		queue_limits_stack_bdev(&lim, rdev->bdev, rdev->new_data_offset,
 				mddev->gendisk->disk_name);
+	lim.io_min = mddev->chunk_sectors << 9;
+	lim.io_opt = lim.io_min * (conf->raid_disks - conf->max_degraded);
 
 	/*
 	 * Zeroing is required for discard, otherwise data could be lost.

base-commit: 038d61fd642278bab63ee8ef722c50d10ab01e8f
-- 
2.43.0

