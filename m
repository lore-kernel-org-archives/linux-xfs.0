Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B892D183CDB
	for <linux-xfs@vger.kernel.org>; Thu,  5 Sep 2024 18:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725560529; cv=none; b=r+vSFXH/buqs7D4Ws0pfWzfVs50nKgt0V3BG0zenozjpekaxDYbj/P9e+Ws/570jS5ZYv1SkSBlqpS8bjA6ID0/pVNlhO5O4exikGvhexNhBPuhKKfUEUcXlB7neI6qT+FDiFiFKEZ/RUuCcfHowDjVTM2DvfjmrM5eUGKwpAJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725560529; c=relaxed/simple;
	bh=pFP4c3h157ZI7rFoxzb8loQz6PI2aF7QxliRY5byF3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uMGBRCtWiKxfvQGDAMEliPTZUG8Bg9MIgWsXrfxG8C0vmWXBH/P0CMkThjAkE9o7La8DN1nifoGXcMANruxqPz5ZivPjqZfxwqDYG6OC//czWlboJBAWq5EcosVs1Ogdx6FuICH9ZC9B18KxribCDvUDl2sdFgpv1T4KRSTL7cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J8hR6UHQ; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J8hR6UHQ"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-202508cb8ebso9197935ad.3
        for <linux-xfs@vger.kernel.org>; Thu, 05 Sep 2024 11:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725560527; x=1726165327; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F2xdGx0nCi5gLiXa84V2u8HtlYeybnaUcLkdjfOqmiY=;
        b=J8hR6UHQCl/QIpW5xjII+SPGITcL3xngVk3/hxs9MS1JwpP+zDHfkdBfHrEDNSo5Sm
         A6dUu4o2dtQN1GI93dlnPC6gwdlF2znc2D3dhBmpDgoc7tgOJSC2+rUMjhrz+uq51wfb
         UvkJmgB66gQ7NahVtKQkIcad1KupR3/YbB+1xhmaaB4mtiJIndTgBWKFAUP5bU7x6ypK
         D+gjskEr5zKJNBKkoCQsI2kSGRauCgzTJ8MiPMeDq+l1ELWLF1/A+89Yy8gJudKk2O6E
         EuEtAraeVfpp4pzZBFYq8DzNpJO6PSw2E/a40z+rYKRlKCiN3yEr2sqZEnYBxBBWeeUW
         oX2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725560527; x=1726165327;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F2xdGx0nCi5gLiXa84V2u8HtlYeybnaUcLkdjfOqmiY=;
        b=fP3iWoy98Qsu+pMs9/045S0P6t4ruU81fJGBSZpdKH5xB/rJuiIQpQjNsLQ6LTq72r
         yJcx9AHxSx0duG3GpTbYDkfJnTHTudx1is8+796kSVyD8Y4hl/oLbyqtGzlRokURcVrm
         yzp2ZU8MlE+/0WUAIRBV6DJxm/iSw1KrBSwcahQI/hQbUMbCb8HZLmlI4w/8Ckd1XU/f
         xMqm8dFRb9CwPK4vUU5iS5soBWc8V6Kiqv1vuV6Z7go3Dc2pUmPDCYdp0YlQg7YOJVO4
         op0PO/kGDvws0K0SgvnzM4rZTuU5CqNGOPpA1amQTuDiBeUJjRvDqgeaRm/4SYfh4U7Y
         PfIA==
X-Gm-Message-State: AOJu0YxSJb/1IeOkfNEFf/NGEDX8dCK3TiXY5jCJX0vSvACIulbzOIJi
	HnFwl/69f9oyPHBkgDojgk+3+0/18dryln7o9YUobOEbQDb7UwQjEt4MOMRR
X-Google-Smtp-Source: AGHT+IHPVleOD2LiiMCANBVggVOc7Rj7PiappiFM0Hl5SDVFXaSY9cswP0zlsMjyb6ekhaOdz+dc+A==
X-Received: by 2002:a17:902:f60e:b0:205:500f:5dcc with SMTP id d9443c01a7336-205500f5ef1mr250974425ad.40.1725560527057;
        Thu, 05 Sep 2024 11:22:07 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2da2:d734:ef56:7ccf])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-206aea684f0sm31374395ad.271.2024.09.05.11.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2024 11:22:06 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	Long Li <leo.lilong@huaweicloud.com>,
	Long Li <leo.lilong@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 15/26] xfs: fix ag count overflow during growfs
Date: Thu,  5 Sep 2024 11:21:32 -0700
Message-ID: <20240905182144.2691920-16-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240905182144.2691920-1-leah.rumancik@gmail.com>
References: <20240905182144.2691920-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Long Li <leo.lilong@huaweicloud.com>

[ Upstream commit c3b880acadc95d6e019eae5d669e072afda24f1b ]

I found a corruption during growfs:

 XFS (loop0): Internal error agbno >= mp->m_sb.sb_agblocks at line 3661 of
   file fs/xfs/libxfs/xfs_alloc.c.  Caller __xfs_free_extent+0x28e/0x3c0
 CPU: 0 PID: 573 Comm: xfs_growfs Not tainted 6.3.0-rc7-next-20230420-00001-gda8c95746257
 Call Trace:
  <TASK>
  dump_stack_lvl+0x50/0x70
  xfs_corruption_error+0x134/0x150
  __xfs_free_extent+0x2c1/0x3c0
  xfs_ag_extend_space+0x291/0x3e0
  xfs_growfs_data+0xd72/0xe90
  xfs_file_ioctl+0x5f9/0x14a0
  __x64_sys_ioctl+0x13e/0x1c0
  do_syscall_64+0x39/0x80
  entry_SYSCALL_64_after_hwframe+0x63/0xcd
 XFS (loop0): Corruption detected. Unmount and run xfs_repair
 XFS (loop0): Internal error xfs_trans_cancel at line 1097 of file
   fs/xfs/xfs_trans.c.  Caller xfs_growfs_data+0x691/0xe90
 CPU: 0 PID: 573 Comm: xfs_growfs Not tainted 6.3.0-rc7-next-20230420-00001-gda8c95746257
 Call Trace:
  <TASK>
  dump_stack_lvl+0x50/0x70
  xfs_error_report+0x93/0xc0
  xfs_trans_cancel+0x2c0/0x350
  xfs_growfs_data+0x691/0xe90
  xfs_file_ioctl+0x5f9/0x14a0
  __x64_sys_ioctl+0x13e/0x1c0
  do_syscall_64+0x39/0x80
  entry_SYSCALL_64_after_hwframe+0x63/0xcd
 RIP: 0033:0x7f2d86706577

The bug can be reproduced with the following sequence:

 # truncate -s  1073741824 xfs_test.img
 # mkfs.xfs -f -b size=1024 -d agcount=4 xfs_test.img
 # truncate -s 2305843009213693952  xfs_test.img
 # mount -o loop xfs_test.img /mnt/test
 # xfs_growfs -D  1125899907891200  /mnt/test

The root cause is that during growfs, user space passed in a large value
of newblcoks to xfs_growfs_data_private(), due to current sb_agblocks is
too small, new AG count will exceed UINT_MAX. Because of AG number type
is unsigned int and it would overflow, that caused nagcount much smaller
than the actual value. During AG extent space, delta blocks in
xfs_resizefs_init_new_ags() will much larger than the actual value due to
incorrect nagcount, even exceed UINT_MAX. This will cause corruption and
be detected in __xfs_free_extent. Fix it by growing the filesystem to up
to the maximally allowed AGs and not return EINVAL when new AG count
overflow.

Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/libxfs/xfs_fs.h |  2 ++
 fs/xfs/xfs_fsops.c     | 13 +++++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 1cfd5bc6520a..9c60ebb328b4 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -257,6 +257,8 @@ typedef struct xfs_fsop_resblks {
 #define XFS_MAX_AG_BLOCKS	(XFS_MAX_AG_BYTES / XFS_MIN_BLOCKSIZE)
 #define XFS_MAX_CRC_AG_BLOCKS	(XFS_MAX_AG_BYTES / XFS_MIN_CRC_BLOCKSIZE)
 
+#define XFS_MAX_AGNUMBER	((xfs_agnumber_t)(NULLAGNUMBER - 1))
+
 /* keep the maximum size under 2^31 by a small amount */
 #define XFS_MAX_LOG_BYTES \
 	((2 * 1024 * 1024 * 1024ULL) - XFS_MIN_LOG_BYTES)
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 332da0d7b85c..77b14f788214 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -115,11 +115,16 @@ xfs_growfs_data_private(
 
 	nb_div = nb;
 	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
-	nagcount = nb_div + (nb_mod != 0);
-	if (nb_mod && nb_mod < XFS_MIN_AG_BLOCKS) {
-		nagcount--;
-		nb = (xfs_rfsblock_t)nagcount * mp->m_sb.sb_agblocks;
+	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
+		nb_div++;
+	else if (nb_mod)
+		nb = nb_div * mp->m_sb.sb_agblocks;
+
+	if (nb_div > XFS_MAX_AGNUMBER + 1) {
+		nb_div = XFS_MAX_AGNUMBER + 1;
+		nb = nb_div * mp->m_sb.sb_agblocks;
 	}
+	nagcount = nb_div;
 	delta = nb - mp->m_sb.sb_dblocks;
 	/*
 	 * Reject filesystems with a single AG because they are not
-- 
2.46.0.598.g6f2099f65c-goog

