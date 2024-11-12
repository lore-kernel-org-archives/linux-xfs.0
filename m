Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23AB21A4DF
	for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 17:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731434220; cv=none; b=o1Ed+n04Y/thSLwuErXD+WiuITt+Ck0DmxG+cysB6JpNUpajimDS2UAmTrctckPgsTt/huIo0yHVKha14kYW8OXKO263wGDlUOLoi7hBp3IpwZpwGI9SofC8KoSeiYsHdqqC1LU4ULRq+pjXU2TJHp1IHb+SL7RK1yzEi3YMkWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731434220; c=relaxed/simple;
	bh=nFXm/L4ae8YekLwpIFurgFERbAtgq26xVgDJzO6g1yM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tpyJQ+HhG8KsjinrbegtKyQd8BRNGZm6DGDJ5hN4kgpZGjIsgGaoAawYVL3VUU89KQfTNczsbQA6IaGO16Ck5RqZdw4txYW1h1TCe6nD/uWAgimGt/CNMvKsIUPxtWK+v+L57pVRBN89nBdAVWaqsE/psDwHLblyiTGA0lv8xFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=f332KYpY; arc=none smtp.client-ip=209.85.219.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="f332KYpY"
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-e30d0d84d23so5270185276.3
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 09:56:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1731434217; x=1732039017; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gek1GO8SPggpZ3MPgZMTTjA2lPqNZurY73wIWpdWbQQ=;
        b=f332KYpYpBj1sNEzbQQiUwIsoXIXb740XNNn6oYti/tlb0A5yFHmlUM+Xz2fVgC3qb
         G2cOovDqa0D+gIg+M1jcuXvddsZM8+q+9+7YiIEa5bfwu9SOlpcsK/SR8Mb1CPdbeqiv
         oJvXFVWvnoxMLM+hbLDaDQoEOz/pKwJ0oLGAuAewzusuFzb7i5wvX1Bth1C7NzNjn2Ju
         RvC0tKgwPSglViSeJe1lkf+Gnxz1a/+vM5yNW74bpV0OEhxcFom4VA6pbkQOig5ExYMI
         IqRa0BafjNl5x7ificOp7pj/f5X8YnhKLAl+wMZ9X1M0LVFC9VSswIBCFh5/r31jqrwS
         RwKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731434217; x=1732039017;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gek1GO8SPggpZ3MPgZMTTjA2lPqNZurY73wIWpdWbQQ=;
        b=WdCahIkFUu/eCTXrKaQth22TPqDDNbXrfWM3LCXuTS56H01WFlLVebJmdYHVpK211K
         s9yQxYdIkFr6njrDgMOAb+EJyey+qZ2IdEloCmP2zEK2FZyb7QEcS9zB0G4L7DZHhCmJ
         0/AEtk44d1vgBAnYd7fs4DK62gF5/QGfb1nr3WL13VjBCqdVX+9J/TPCoHVe8c7xBjdd
         od6jyoz5wsaBFJNzVTHi7eX9r4AU1DeTY+dTqmHPsF+z1uIJlW2bA8TkeVatMKJ9A2ax
         fvYCYJnvkfeiKnlVZf276Gi1TifGYAZMOnnQ/vo55YyeOjh8YUl3ZgWFI4z9ni278Gp8
         F2Kg==
X-Forwarded-Encrypted: i=1; AJvYcCX4WNRfX+7QsB9J46IFGStPiKhV+2RQ4VZ3lyvN0VYWqvKQfBUmJ8WtE02GPWeDLwCJwXrHofCgzxE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjGu77myHeFFQI2MMFUrjv1EOBSpaGs+Znfe8sg1a3QwMBpUZA
	dg+8dzUX1IeKlgfr6YgkyCtI8zFi7WtUPibTdlqJPPHSwpUCn7eC45CIiMkiTT4pa0JiXqPOsEE
	N
X-Google-Smtp-Source: AGHT+IEseNU1fU18+Eb5Xypvfn1vm8TMH1JcpZ3Hifh4Ob7CJlLkVA7fH8jLCYaFBtppEHVnywJ7Bw==
X-Received: by 2002:a05:6902:1ac1:b0:e30:e59b:4a40 with SMTP id 3f1490d57ef6-e337f8822d4mr14895613276.28.1731434217050;
        Tue, 12 Nov 2024 09:56:57 -0800 (PST)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e336f1ba498sm2747524276.46.2024.11.12.09.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 09:56:56 -0800 (PST)
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
Subject: [PATCH v7 18/18] fs: enable pre-content events on supported file systems
Date: Tue, 12 Nov 2024 12:55:33 -0500
Message-ID: <476c173aa514c889cfb3d9a1dcf3bb333a223ef7.1731433903.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1731433903.git.josef@toxicpanda.com>
References: <cover.1731433903.git.josef@toxicpanda.com>
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
 fs/btrfs/super.c   | 2 +-
 fs/ext4/super.c    | 3 +++
 fs/xfs/xfs_super.c | 2 +-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 97a85d180b61..fe6ecc3f1cab 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -961,7 +961,7 @@ static int btrfs_fill_super(struct super_block *sb,
 #endif
 	sb->s_xattr = btrfs_xattr_handlers;
 	sb->s_time_gran = 1;
-	sb->s_iflags |= SB_I_CGROUPWB;
+	sb->s_iflags |= SB_I_CGROUPWB | SB_I_ALLOW_HSM;
 
 	err = super_setup_bdi(sb);
 	if (err) {
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b3512d78b55c..13b9d67a4eec 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5306,6 +5306,9 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 	/* i_version is always enabled now */
 	sb->s_flags |= SB_I_VERSION;
 
+	/* HSM events are allowed by default. */
+	sb->s_iflags |= SB_I_ALLOW_HSM;
+
 	err = ext4_check_feature_compatibility(sb, es, silent);
 	if (err)
 		goto failed_mount;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index fda75db739b1..2d1e9db8548d 100644
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

