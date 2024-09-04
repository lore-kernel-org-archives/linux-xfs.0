Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A601E977A
	for <linux-xfs@vger.kernel.org>; Wed,  4 Sep 2024 20:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725481786; cv=none; b=NNWrEsjAl6UAzh8t+y2Q9Xq7CuH0o/3iNkd2QKrcfcwDLdTK/25TzTXaR3oJt48m9DlWKD9invU8YP4hwwk5hcOJbOAt1sJRAHPp60GM0FMhjxKJWvjFjt2cjRpLKo4m8iReKnVOS+deZWksz82ckvJrnVk11Ygq8H39Sy2vw3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725481786; c=relaxed/simple;
	bh=gMZpVewk5XvpBsYlFMNDabJsDOEQn4P/spwMBIBwxlA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nB3cqQ2xojmY/2RROMmsqGxcyor+OV8bjbdexKuLsfXEFszUoTkW8DCGm4JOrwbrq9syEwmBEX1TI/3yYia/hYhwuBZ0Rvbxd1fOYiCZKTLp2zU/yvaQyd8epjUU91prtIsmridxJe+Wgni137cffQjc3EQ9FSFJuFI5bpdLkHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=WP7o3YDW; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="WP7o3YDW"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-456757d8871so313891cf.0
        for <linux-xfs@vger.kernel.org>; Wed, 04 Sep 2024 13:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1725481784; x=1726086584; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Eq+9jML2+1Z0SY+HFrzR7GffDKDG9jp4/RSk9gnr/bU=;
        b=WP7o3YDWx4d2AEcbHWUemYHqy2KcYbp4F/W73qz7k/eGQrFuLVMCTseNBMISFnAqig
         8OKEKWyuM6reaNGQkDiafQmpjqEXDBLyuCPt5z1YMFvDYFPsUg0qRYltUFCM5IkMbEI3
         NkTeHSLNTir2erN7Fj6NGkL7m7zv2KpZ9kGWB/Yj2vxcyyaHSu0HTuMSG56nvSn4kX/5
         +cQpmRgedx/LNfNeHIZgIEPVW1wAcuAMWqQS/NnhZU4Qn7g6YqgItx0wmOMvAMrPgz6m
         6+3MSBfAZqm8TbulyxLPeyNVlzgzzDSBpj6jWGiTQCscIqvghf2D5RvTiyNUORLi7sur
         I2pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725481784; x=1726086584;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Eq+9jML2+1Z0SY+HFrzR7GffDKDG9jp4/RSk9gnr/bU=;
        b=bJKhr42MVXHZLghpamqT7TLjqdIdH1WiCH7jS33AFMmjYJGx+78epa4Zhk8giLpe5B
         MHBdaNnQJYzJoBFNlJgCmWqQp2aHCIMygXEpm8SGwHYfqpUKn4ZRg52hSEKxcxhLvvsu
         h5rxp8C+t3zPp6r+HgRi4nU06T5yaVYyze5lpHBVp8EyUdLxA6dzTG3O6O87yt6y6KwI
         1OPJM8+fCqDlH7Uwt7FRbQpGpRzwzCByNhcMkQSIqwCiM89zaNhj61LTfLxTLfxTv+RK
         6PWjbX8zxOQ56XGaiUUB+0d/HM2PWZQ5uZknbpx+UANYfuCJHiDQyy2PrAZYgbRyWxaU
         OiUg==
X-Forwarded-Encrypted: i=1; AJvYcCU70z0NOYMr3OBLNys+SCz+7aBBK1G8fCyrnXs7XpTfwVhjbO4KuTOWPLR5q9xFcqrPZQqT3r+WJ9A=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEs/cVihSEyZYGGw+04AMRB9ZrK4/LEuV5qEWkxgg1RfPQeYiZ
	Dt4z5nvvNaxvcdlcGHNZSItGDfABG+ZS/RZJDnMiPeOlUhgjRT9S2+LT/yvKM/tTkAq1vvAgWkR
	s
X-Google-Smtp-Source: AGHT+IEW2/ZH57qdIHT1xYE99y1ro7rMeuspqZzclDk+WG9y2YYBgpGHJd3Dr2WZ9zk9cnANiDJM0Q==
X-Received: by 2002:a05:622a:993:b0:456:87c1:59c7 with SMTP id d75a77b69052e-4571a013180mr198617071cf.57.1725481784189;
        Wed, 04 Sep 2024 13:29:44 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-45801b5312bsm1502351cf.44.2024.09.04.13.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 13:29:43 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-bcachefs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v5 18/18] fs: enable pre-content events on supported file systems
Date: Wed,  4 Sep 2024 16:28:08 -0400
Message-ID: <33151057684a62a89b45466d53671c6232c34a68.1725481503.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1725481503.git.josef@toxicpanda.com>
References: <cover.1725481503.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that all the code has been added for pre-content events, and the
various file systems that need the page fault hooks for fsnotify have
been updated, add FS_ALLOW_HSM to the currently tested file systems.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/bcachefs/fs.c   | 2 +-
 fs/btrfs/super.c   | 3 ++-
 fs/ext4/super.c    | 6 +++---
 fs/xfs/xfs_super.c | 2 +-
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 3a5f49affa0a..f889a105643b 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -2124,7 +2124,7 @@ static struct file_system_type bcache_fs_type = {
 	.name			= "bcachefs",
 	.init_fs_context	= bch2_init_fs_context,
 	.kill_sb		= bch2_kill_sb,
-	.fs_flags		= FS_REQUIRES_DEV,
+	.fs_flags		= FS_REQUIRES_DEV | FS_ALLOW_HSM,
 };
 
 MODULE_ALIAS_FS("bcachefs");
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 0eda8c21d861..201ed90a6083 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2193,7 +2193,8 @@ static struct file_system_type btrfs_fs_type = {
 	.init_fs_context	= btrfs_init_fs_context,
 	.parameters		= btrfs_fs_parameters,
 	.kill_sb		= btrfs_kill_super,
-	.fs_flags		= FS_REQUIRES_DEV | FS_BINARY_MOUNTDATA | FS_ALLOW_IDMAP,
+	.fs_flags		= FS_REQUIRES_DEV | FS_BINARY_MOUNTDATA |
+				  FS_ALLOW_IDMAP | FS_ALLOW_HSM,
  };
 
 MODULE_ALIAS_FS("btrfs");
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e72145c4ae5a..a042216fb370 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -137,7 +137,7 @@ static struct file_system_type ext2_fs_type = {
 	.init_fs_context	= ext4_init_fs_context,
 	.parameters		= ext4_param_specs,
 	.kill_sb		= ext4_kill_sb,
-	.fs_flags		= FS_REQUIRES_DEV,
+	.fs_flags		= FS_REQUIRES_DEV | FS_ALLOW_HSM,
 };
 MODULE_ALIAS_FS("ext2");
 MODULE_ALIAS("ext2");
@@ -153,7 +153,7 @@ static struct file_system_type ext3_fs_type = {
 	.init_fs_context	= ext4_init_fs_context,
 	.parameters		= ext4_param_specs,
 	.kill_sb		= ext4_kill_sb,
-	.fs_flags		= FS_REQUIRES_DEV,
+	.fs_flags		= FS_REQUIRES_DEV | FS_ALLOW_HSM,
 };
 MODULE_ALIAS_FS("ext3");
 MODULE_ALIAS("ext3");
@@ -7298,7 +7298,7 @@ static struct file_system_type ext4_fs_type = {
 	.init_fs_context	= ext4_init_fs_context,
 	.parameters		= ext4_param_specs,
 	.kill_sb		= ext4_kill_sb,
-	.fs_flags		= FS_REQUIRES_DEV | FS_ALLOW_IDMAP,
+	.fs_flags		= FS_REQUIRES_DEV | FS_ALLOW_IDMAP | FS_ALLOW_HSM,
 };
 MODULE_ALIAS_FS("ext4");
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 27e9f749c4c7..04a6ec7bc2ae 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2052,7 +2052,7 @@ static struct file_system_type xfs_fs_type = {
 	.init_fs_context	= xfs_init_fs_context,
 	.parameters		= xfs_fs_parameters,
 	.kill_sb		= xfs_kill_sb,
-	.fs_flags		= FS_REQUIRES_DEV | FS_ALLOW_IDMAP,
+	.fs_flags		= FS_REQUIRES_DEV | FS_ALLOW_IDMAP | FS_ALLOW_HSM,
 };
 MODULE_ALIAS_FS("xfs");
 
-- 
2.43.0

