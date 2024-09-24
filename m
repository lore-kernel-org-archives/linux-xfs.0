Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFDD1ACDF6;
	Tue, 24 Sep 2024 18:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727203160; cv=none; b=qfVlnWzY9zd7R/8Xl7YihXhE7crVva6/d7/ikLiwAkF1Upf9Xa23lv884CqpeY+QkUjhY40tIl8F4kXNvBgcqeypuoIkFEFubSNnc8DnlhxksO+vWwXAgNALZ5mDMx8OPiKvAAewg8Pkg84nHxYzgWooY4KacN5qgnY2bjaihHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727203160; c=relaxed/simple;
	bh=sD7pQD/0+K038NkGUaU/3FEW+Cny9gBeEgOwfs5m5TQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VwTQbpv4MsSCQTIzehoc3a/DpVB7EzdAlKt/VmPDmZc0LhHeocIDYULAb1QcZmZRoJiMouzbT1gDoSq2qK3JVGcz7Azjr+TgB5OEIiO01W6E7o6MPrc48De9nyPf+Gcz2AG1DSijqfTH8ZgUxs7e4pj4qAyvJ6jaEg/7eYCWRC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IgMVLxLk; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IgMVLxLk"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2e053f42932so1203483a91.0;
        Tue, 24 Sep 2024 11:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727203158; x=1727807958; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H1SyRfWwAKY3gO3eiRjXmCJIbqZ4NJZTB59jo5dbPbU=;
        b=IgMVLxLku4ZfAO9kgSsfQ5vxCAJY2XjqGPvztLzyM0enNebLQ/kNKxaW+yduSqy8qJ
         1mF5vbtiRSspqtHnUyd65EiEQ5rEfOOjxRNtYTpKIaNd/yHUwU4t4r++DbNVDZLdJWXW
         twgL1QkwRoFerdrrHq3H8IEpCsH43y/fNS1NsXuhmYauiKboFngRnxbbzMmXYnGnkOLS
         gDG1m9hcshsFRAgg9HH9x5VH88934m2rMctyDqaQjvFB23zIiwRVcfTASuBOekbAxJHN
         N6HrihPS75Q6OtgtFwDn5WPD7OD7A+T9Ghy91TnDnUCOBoWOBSpjC3yXEeiPRhSPSh//
         XzGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727203158; x=1727807958;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H1SyRfWwAKY3gO3eiRjXmCJIbqZ4NJZTB59jo5dbPbU=;
        b=C9v7sThzzmnAz/lQnKZAW/gm3Kvls6pjhSHvCoBT1Y7jSl9RFYh14pL5ty/QEbRlRj
         HBKsCafftDWSziqxB0blLHM5E1AYLV9XjA9zVrYYbSW22OSpvBgpwIvTLfg3hMT92P1x
         7UgciNtua2nR0FsX/1q6ocGr9cnTRpdKqyOukEfuVksl1S6drW33s0613/4oJ46tiegZ
         S53OZbr72LSl4+Z5oMq5lMF/oSLctazBdZ4FOQpKDV33l1O19cYXmAwW4ojBmRRhnbsr
         RPF9NACaxvVPRkrdPO6kGM/YY5ig5ujxlcX5nFB/53J30YA8vgCqOGC+BWOREBKh7WTJ
         fFrg==
X-Gm-Message-State: AOJu0YwZTr29VKE2wj6DtV7HEUhMQ73T9GlyKFOEa9omDEi6yVke1sN8
	LPfvLA0CfglTUZ+sV16qeBpeYehyFo8L3i4BbLRVZlN7znTD3KNyaxRkxU8/
X-Google-Smtp-Source: AGHT+IGUesybN91z/Z5saarZj0D8lNq38N/1oirDgxDF8EZDnN1eyOdUm9wattO7m55Wi4U0Uu8+5w==
X-Received: by 2002:a17:90a:d496:b0:2da:936c:e5ad with SMTP id 98e67ed59e1d1-2e06afd6ec6mr84269a91.33.1727203157695;
        Tue, 24 Sep 2024 11:39:17 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:3987:6b77:4621:58ca])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dd6ef93b2fsm11644349a91.49.2024.09.24.11.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 11:39:17 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	cem@kernel.org,
	catherine.hoang@oracle.com,
	Long Li <leo.lilong@huaweicloud.com>,
	Long Li <leo.lilong@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 6.1 15/26] xfs: fix ag count overflow during growfs
Date: Tue, 24 Sep 2024 11:38:40 -0700
Message-ID: <20240924183851.1901667-16-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.46.0.792.g87dc391469-goog
In-Reply-To: <20240924183851.1901667-1-leah.rumancik@gmail.com>
References: <20240924183851.1901667-1-leah.rumancik@gmail.com>
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
Acked-by: Chandan Babu R <chandanbabu@kernel.org>
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
2.46.0.792.g87dc391469-goog

