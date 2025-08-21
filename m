Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CEF38B647
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807632; cv=none; b=EHfugAz+yj7FngiaZUbbVvDfBQLkQqpSbghAH39GOBLF161iuxEJQvxFx4Q/MydlfOLP9BPnXUyQng/dpKEEY+f7GhcIaMRIRe39HGO6khoH7PgB8NY1UO80ltNpzpcICUqxgo1EyzXgaXEvf6vmYpagR0JHSQifkgPWgpcrtAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807632; c=relaxed/simple;
	bh=ai2oUzPAcRJzj4bWGdjdsYHnumyQaMH/ub0qR04Gbgw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8cwKnZ9lZL/mcbTkBQARZ393oZDLpsMv78bMWHq7xB6pYPFbNVTQVpOIyyjx7C4oJbrxy1JV1RxST06Ily+Ws3/+992aN32dZPH6Dr/2St+hY7RNoMTI+sWYxBUhA2AQq9iXgRRqw3FGCy3/aO0e3HfLPj85WPMnFIANS5qOD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=HJIyusrn; arc=none smtp.client-ip=209.85.219.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="HJIyusrn"
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-e931cddb0e2so1153795276.3
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807630; x=1756412430; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=opvoMbW1BQLT38gew8BsXyJcIC3tejqT6ZRE2IoYWVw=;
        b=HJIyusrn5p0YqzySCgPuwSXTOrj7WUWgzNcKljJ2uIU1Qr6qdPlsRaXxP0hgg5d1fY
         2GeN+mvpFQiaS0E6lymLMIlFUTHaB+Mbk7WNMGMCOq5QKW1pxr3F9zb0r77rLPUfw2mh
         ZOZwSh3R6+VhSC1+PxMeHs+KRTjW3F7tJqUH7dZ6ehPRmvjtMej4e8eo3tPV1VjB4Smc
         T+ulJHIQlNFYGdNtM7VW/VM/nMAqJbp1vKYAYBfCRt4IIdlbvCX8aK0TMloY6rRtk0x4
         i/FVeln2imLP8DO36EUzBkLJK9I82l3G0SyhpNc5H15Pf8j3nV/2fEqVSA21ScSdJP5S
         p25w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807630; x=1756412430;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=opvoMbW1BQLT38gew8BsXyJcIC3tejqT6ZRE2IoYWVw=;
        b=bHJ7H/13+r9/ok9jYUpIJ6+G08k5N0GuEu2lVk0qv+sNy7J56dnKBB8pQrF4f/qBQT
         S6SZ3Ayc7EKnrvapv9kJNP7BU7JTt6Zhk6shz5jG1h4DKTnuNPEij+dt49USmwgs1ZxA
         2HKt/xcvZXfrQM6p6758/HaQO4IQdjt8kjVLMQvPBT6g5v1ETbHna3Rl2zZxK1ktCQhd
         nvZJSGOHI7ojUBMf/SV59LqA7YpIgqh5FA4kNcjp9ic4q6+z/wHKkYj5pc8VN/hI9quy
         bcmPtMs15i5zlC/8qnJ6+dIiAS3rmWINmq7xQ7VLXQBYjTiyDfPrteB2fs1NcyBR97Xq
         2CHw==
X-Forwarded-Encrypted: i=1; AJvYcCWKomZ5DQGwiipei0nrQsgVArQ8cLhCBO+ZFPJUQdeILJzxlwGcELqD5oSTW4nfh4G/XdSX2mldajU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvQzfI8F4QkDLknfI6JAtLSA3/D65Ithkq+KI4YGKzGKgp8a4o
	1uZfRdeeBw276kPbEngpuT3/x77Y0qFidO+MZFWcLq8vJAbbuDr2jbteozBd8ye4DwA=
X-Gm-Gg: ASbGnctDNubsNh+TBwCBdC1tjqCqU4YwueCgojQ5S5Romftql79Y/yAGD6LBCgCixFo
	6gaWnLlHj1sC+7eeDh84A784v47eSgY3k/nyTs+VKUjuZXkYtR4miiuitPnSxJIwKjgn1vYJ+pX
	xqxyYGH1Wiy4L9L2JAnP2OqIxQIFPB3/t1RptZZ6moas7pnWzDgjj8xNw5o39qyw2kROdvzqtAR
	17tIsCDNJ6NnG0fGwpad3oTUqBXmmMeosxIQhhYrFyyH/LHJlecIVVqPaQNSmABedj174vVwbKy
	Sq5+kUhG7aERTbw3APAZ5eFc0PyRPy9wGNKJitiLwWvZWxkM4JUUFbsyeOTJQcRLZTY+V60oejI
	NG0ict9F6RbB0elXqOatgb94maYTYnLgXe+JQZy+X7nqUk7hb3ZVWnHMkGuE=
X-Google-Smtp-Source: AGHT+IHyIwzTgpEWg8XzW3K6HAoMrfMJMt75D5zXrJVqgdg8vv7vwKweBunmDYNPDq3GubatUhjj2Q==
X-Received: by 2002:a05:6902:6b07:b0:e93:3e42:63ca with SMTP id 3f1490d57ef6-e951c3c4751mr826219276.30.1755807630352;
        Thu, 21 Aug 2025 13:20:30 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e951c976124sm141967276.34.2025.08.21.13.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:20:29 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 10/50] fs: stop accessing ->i_count directly in f2fs and gfs2
Date: Thu, 21 Aug 2025 16:18:21 -0400
Message-ID: <b8e6eb8a3e690ce082828d3580415bf70dfa93aa.1755806649.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755806649.git.josef@toxicpanda.com>
References: <cover.1755806649.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of accessing ->i_count directly in these file systems, use the
appropriate __iget and iput helpers.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/f2fs/super.c      | 4 ++--
 fs/gfs2/ops_fstype.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 1db024b20e29..2045642cfe3b 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1750,7 +1750,7 @@ static int f2fs_drop_inode(struct inode *inode)
 	if ((!inode_unhashed(inode) && inode->i_state & I_SYNC)) {
 		if (!inode->i_nlink && !is_bad_inode(inode)) {
 			/* to avoid evict_inode call simultaneously */
-			atomic_inc(&inode->i_count);
+			__iget(inode);
 			spin_unlock(&inode->i_lock);
 
 			/* should remain fi->extent_tree for writepage */
@@ -1769,7 +1769,7 @@ static int f2fs_drop_inode(struct inode *inode)
 			sb_end_intwrite(inode->i_sb);
 
 			spin_lock(&inode->i_lock);
-			atomic_dec(&inode->i_count);
+			iput(inode);
 		}
 		trace_f2fs_drop_inode(inode, 0);
 		return 0;
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index efe99b732551..c770006f8889 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1754,7 +1754,7 @@ static void gfs2_evict_inodes(struct super_block *sb)
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
-		atomic_inc(&inode->i_count);
+		__iget(inode);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&sb->s_inode_list_lock);
 
-- 
2.49.0

