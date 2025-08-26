Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4878737058C
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 15:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756222915; cv=none; b=G5NlfmeaL7KJnzie+VzKFRJIanozCVkSArY7kzdirrQhWUDvCdzTqdzjXQugmeDEHPqXpnQhDw75YZaKJ5sFP/5TF1RI3u2Q6L36D+YdFJTtqlB/u+c6wFv9TInnL0NiTTWJsh1kBLeuHgLdc/eXPys4UbkTqooiVwgdW+BkUTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756222915; c=relaxed/simple;
	bh=15ZHaqifmUtXWBqCOA5JgpHFW/qiYG0R+Rgr6AbrTT0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtJJBRcTP0PdTXODYPuMcJD3VVQ2MAJ8xIz2OmUzW2zC5oZ7xbCsJbkDS3QDvXw5dF3HGYSDFjRuQI6bi6JCkoBzzE/KnesuNYriU1men+xfM+o9Q1o3FSBtXuOZ7I+IJzcayzYikDVQlQl+9WLRNNV4ZTgMp4/Q5BDhhi4roQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=xN5y2SSr; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="xN5y2SSr"
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e952a2d1813so2875462276.0
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 08:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1756222913; x=1756827713; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uVly6FxrnKPpCOutqFXtYnP9ubQ0AZJgXeTB84dIAZo=;
        b=xN5y2SSrcEr+y4YFjJrz/CqWqxmKDdbxvfMtq+eNSmraeQTtt3+Blc7gLZ4VUS2Ppo
         dXq8glu6chYeLj14rqGrlouI3msT7/+wS/zWRMPA5fnCC6t8TWqd+Kclk+kMeBZCls+k
         iyl+zHki8wuQKgexcSE7zDjRqFSuni6vOga+TRELBJly2hcT8ssQekSAjKYAQYuYZd6L
         ApYMSYho0CKC74ifJqUS5sznHVHfDPEam/CIcuxr56csfYc4ZQcKWS/9UPgkkx+V13ge
         4dQeTroBSNGpHdzYrUpIhn3jqO1wryoE8XdSTfefRSF/4zap7NRUe6gkNmpW9qjJpPlO
         CgEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756222913; x=1756827713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uVly6FxrnKPpCOutqFXtYnP9ubQ0AZJgXeTB84dIAZo=;
        b=KqfIIxf8Bh1v9BwtUIiojloqm+VSZ6OlRhjCiR7ZaR9SAqUEZjXjoeNyo7fJApukw0
         eMJ3DclVx3vGf6SCVpJdR+X7Eelz4rf3daqmuk7qonANV53nLVU7xfyZEX6jy8LLsVqO
         eyViEKSYMoF5nx17i/81L2DYFC6/54z1wSV5M2j/CW/Lb9GmepC3GbGqQRNC2hE0x/Jo
         2NEcsZ1rnWtWyUlQNemFygiCfOMzKS43yrNFjIH0uTOQRDFAVKv5TSu9sJ7lHeXxuVhS
         GDPyq9Kyc0ywRGWdjbZQIBJR/MdVK7gh9CGVHzW79gOpsbfzhO33lnf7cZFcE4VFkPfO
         y63A==
X-Forwarded-Encrypted: i=1; AJvYcCXw+zsD+WXRpaQ25KHcwwWtMxu+JoA4bdlN+sZMIBnBmzkhL8dphzN3g5c2ENd223+rjOZHXMgzjls=@vger.kernel.org
X-Gm-Message-State: AOJu0YwM7BHRXnK15uIYC/3IG2D8/JgTrcoqnRMR5WiCudc5whvxQvX6
	QtTfEcAejQ7UdKpDuyCQneYum4KnpWaEZzKOUEeTSzCMXsWDmH87BSaATic6vctRlS0=
X-Gm-Gg: ASbGncuAAbfugbnegc53KpByxIeJK79UwZC/pSZrLEp+Fv4vUzuAkr96k8kuQCvtvHh
	gZQXbe69shGMCGquMA96z5+WTL4VHlw2cCA8F6RCThNWVMXy14xK+YipNzFS2kWfqm7zEa2yoiI
	miA70G7aZZO9rCyPdLKivuSRu/M08fK38svUdTx824iwCbhlHtk4pjddD9YX/n3caYV7DPitqK5
	tqTXVvU+5Rmcl1KENCmZha1+oL1+3UqgVn7EFsPB7IrdIaVSUfCfKqAc7OQBYQNraqSV7I8zg2Y
	+prY9UzQTa9ehWzCwA1B4OXmMna0GhNEf1sibyh7fbFPCQHojvCZDg5aAuz8bV018ON2QoG3CzC
	ZHgEoOxbo1Jmq6sIIr5xKvRPPSb7wMWjQA7gPa6ntTiYFJ3VCW2frdQPpd9sy7EKI1gISOA==
X-Google-Smtp-Source: AGHT+IHs9eajH2WM3NXgIzvKjebg01fyf2ACuZ9khHqmbOf6soY9xqnUvsrLiHhUDAZayHz34q7R/A==
X-Received: by 2002:a05:6902:f82:b0:e95:7f3:4c7d with SMTP id 3f1490d57ef6-e951c37dcf7mr18808774276.47.1756222913189;
        Tue, 26 Aug 2025 08:41:53 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e96db453574sm890302276.9.2025.08.26.08.41.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 08:41:52 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk,
	amir73il@gmail.com
Subject: [PATCH v2 44/54] btrfs: remove references to I_FREEING
Date: Tue, 26 Aug 2025 11:39:44 -0400
Message-ID: <9bc7048e07162c9169f9b098b0bb7577749ce11e.1756222465.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1756222464.git.josef@toxicpanda.com>
References: <cover.1756222464.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We do not need the BUG_ON in our evict truncate code, and in the
invalidate path we can simply check for the i_count == 0 to see if we're
evicting the inode.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 69aab55648b9..ea6884e5c791 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -5338,7 +5338,6 @@ static void evict_inode_truncate_pages(struct inode *inode)
 	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
 	struct rb_node *node;
 
-	ASSERT(inode->i_state & I_FREEING);
 	truncate_inode_pages_final(&inode->i_data);
 
 	btrfs_drop_extent_map_range(BTRFS_I(inode), 0, (u64)-1, false);
@@ -7448,7 +7447,7 @@ static void btrfs_invalidate_folio(struct folio *folio, size_t offset,
 	u64 page_start = folio_pos(folio);
 	u64 page_end = page_start + folio_size(folio) - 1;
 	u64 cur;
-	int inode_evicting = inode->vfs_inode.i_state & I_FREEING;
+	int inode_evicting = icount_read(&inode->vfs_inode) == 0;
 
 	/*
 	 * We have folio locked so no new ordered extent can be created on this
-- 
2.49.0

