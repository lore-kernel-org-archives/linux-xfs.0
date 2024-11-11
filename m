Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD2C1C9DED
	for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 20:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731356383; cv=none; b=gyhRQ3WsYWTzK2JGC/xf2lmcuhLYT0DdZHw35DhG6VIdHnejQ+PKisLo4oNDq2i1dLz9xVPZ7CnNtJdJ497AVriQSegmjyZwZQMVgsswIJZu0wCQz22oD42uGCPFUoac84SKnZ9lESOR9UNCVZzqWv4RzN3sOOB3UgBQOT+6amw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731356383; c=relaxed/simple;
	bh=85dou7ENDPPY5VUOCL1jZRoxjWsulKi6BQ53aoLcHhg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RWhnP6rb3Cji2EIyZHs41gwB2OBsDwKD5LxdKhanvtqKFtPLuJmgjuSnC2tqosusaJJEAZHv/011KcCUha7dGqDlb8hPaDAJg/yTVtPTH+LGnHTpYjim7Jp7b6GR+a2877Dm7rJ+0DgiKuGtggDY6xrHzFsCrrNGjuHtDoC5mho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=rdy9/j1t; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="rdy9/j1t"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-6cbd092f7f0so33510396d6.0
        for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 12:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1731356379; x=1731961179; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9HNnqNRpeXpq6oZz7CLrI+1uWLVA6nBimiK4CaRQWps=;
        b=rdy9/j1tGzisk/Y/hiAmtx8Wl5Cvyv0EhLcYyAUxQi6CaisfwP6+n3rg/GPHRW+nmi
         Uugb7scu09cOC/bH2brS6c9Z5S3G57WHngbPyc7mnnttYOY1zL99a+kIczG6tItCFH85
         EGljfgDEIFl8Ty8HbNYCTT/NIv8BSaA7GEh+wq+a+B68eGQOAaHoKxK2pEaG4cnjuzKr
         LkIlkWyi+c5c1xmkgFo4dSRE/sdcDwjHNFYUxs1LusC2N2JrpAqJ+6qESuFeu04rsw+b
         IPVp0/9gOUiRInTwJ238lD5riKT+E0gr2YNTUZnvBjloixGsrAmFQBhPGfogr23C8WjA
         sqXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731356379; x=1731961179;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9HNnqNRpeXpq6oZz7CLrI+1uWLVA6nBimiK4CaRQWps=;
        b=GqWmGpOsAITKik4+dareRVtJcEBHEU2lyTnz8nu4goq0ychWBZ0JlVmEOFELEFEctl
         a4ATUnkju0DVrtYowEkD7r/HjuoCO5MlE1kQefxieMBe2aTN/LQIyJw03bvFnhnGhc6D
         H2beeNnUBxdskjpNh9uoPLEkcRpuqYdzKZyUx1+ARpanewS8VMFMod/baUUkQJS5dWtn
         Gmt1+JY4uxZ3xdq24plP2wqiQbTgr2qHKUOqfUSfvtGwnTKwqpQhL2PVAYFfqwQhl6af
         7XuNgU1sudHRKxxTZnNa139TCGfAqjVevD8AB9shNNkVYMxaT7hsZa+AtgS0KamWfFRw
         Ysmg==
X-Forwarded-Encrypted: i=1; AJvYcCXRRqkO6xwXpfeW50xyD6/+IxH6WbKtxpXa1+NGVPaJ98XzY9Cd+yYSSK6wdREwVqRz30v857UUEOk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZEkvcqI7UZ2RqrKFh7D1mnuvmeK/BkIvxvmSOvsiAREAHB273
	jfC7yfb3bcfApvnMs5t5sPYegl1g2qsRXsrn8leDSJ99vwvxmoabbml8iRi1Ecc=
X-Google-Smtp-Source: AGHT+IEeW5dWNNzP0Q/mSWg08VXdP/QJY4mGTFCLDa3FijIuqEGWFA/DFexUYUDI803eaDEW3J43MQ==
X-Received: by 2002:a05:6214:469b:b0:6c3:5a9a:572b with SMTP id 6a1803df08f44-6d3d01cd58emr414996d6.20.1731356379654;
        Mon, 11 Nov 2024 12:19:39 -0800 (PST)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d396643141sm63385236d6.126.2024.11.11.12.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2024 12:19:38 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	torvalds@linux-foundation.org,
	linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org,
	linux-ext4@vger.kernel.org
Subject: [PATCH v6 17/17] fs: enable pre-content events on supported file systems
Date: Mon, 11 Nov 2024 15:18:06 -0500
Message-ID: <0618e1fcc426e66545a6680c795423313b7ad8d5.1731355931.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1731355931.git.josef@toxicpanda.com>
References: <cover.1731355931.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that all the code has been added for pre-content events, and the
various file systems that need the page fault hooks for fsnotify have
been updated, add SB_I_ALLOW_HSM to the supported file systems.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/super.c   | 5 +++--
 fs/ext4/super.c    | 3 +++
 fs/xfs/xfs_super.c | 2 +-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index c64d07134122..9c3877aee9d4 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -963,7 +963,7 @@ static int btrfs_fill_super(struct super_block *sb,
 #endif
 	sb->s_xattr = btrfs_xattr_handlers;
 	sb->s_time_gran = 1;
-	sb->s_iflags |= SB_I_CGROUPWB;
+	sb->s_iflags |= SB_I_CGROUPWB | SB_I_ALLOW_HSM;
 
 	err = super_setup_bdi(sb);
 	if (err) {
@@ -2191,7 +2191,8 @@ static struct file_system_type btrfs_fs_type = {
 	.init_fs_context	= btrfs_init_fs_context,
 	.parameters		= btrfs_fs_parameters,
 	.kill_sb		= btrfs_kill_super,
-	.fs_flags		= FS_REQUIRES_DEV | FS_BINARY_MOUNTDATA | FS_ALLOW_IDMAP,
+	.fs_flags		= FS_REQUIRES_DEV | FS_BINARY_MOUNTDATA |
+				  FS_ALLOW_IDMAP,
  };
 
 MODULE_ALIAS_FS("btrfs");
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 16a4ce704460..733d71dac09e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5266,6 +5266,9 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 	/* i_version is always enabled now */
 	sb->s_flags |= SB_I_VERSION;
 
+	/* HSM events are allowed by default. */
+	sb->s_iflags |= SB_I_ALLOW_HSM;
+
 	err = ext4_check_feature_compatibility(sb, es, silent);
 	if (err)
 		goto failed_mount;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index fbb3a1594c0d..b6cd52f2289d 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1713,7 +1713,7 @@ xfs_fs_fill_super(
 		sb->s_time_max = XFS_LEGACY_TIME_MAX;
 	}
 	trace_xfs_inode_timestamp_range(mp, sb->s_time_min, sb->s_time_max);
-	sb->s_iflags |= SB_I_CGROUPWB;
+	sb->s_iflags |= SB_I_CGROUPWB | SB_I_ALLOW_HSM;
 
 	set_posix_acl_flag(sb);
 
-- 
2.43.0

