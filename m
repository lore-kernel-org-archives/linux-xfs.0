Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3ABF38C5F6
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 20:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755807643; cv=none; b=Xpd6KmiL0tQXwuCLNN0dqoAGr7EtBXYzspmv3lVVcCIqeaOAtyCgnKp5oDh+lN1MaPnWovQ1R0LvMNhMbVhGVZ2hKXLEbJibsEL7xXM7BufMnF5dhO9kpPfnbz1wzIguC4Ai+OV57RRDdDPWPNkKp84UsBb0gO0LjQVdPnK/wXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755807643; c=relaxed/simple;
	bh=E1CZO0qANMqkotvvGy80SzBF1+IOn0iuawhmFtdmLq8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O22F1l/f2VlNNumIeklA+wRtTM9OtHWxP0LSvxdG9d02pVVMY5VHEnrY/0B60f9MtTOs3zIdpp5743GYseRDGekayUXGIsjlvw59ikG/FqF3lRbmfS2tLKOGAqQ+4Ca8dj+NOm5bkBGi81erPXzZrOHgoRI3ntiZHFJ99gEoz+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=yia2gpxu; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="yia2gpxu"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-71fab75fc97so13248647b3.3
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 13:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755807640; x=1756412440; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cq8CitEHOIa1E1kCzffFkimm5JhYQkJcPbJMgOYWCnc=;
        b=yia2gpxuXEbFsf+uTotXb53zaiUVeBugX9No5DdR0DnMpdpGwfDJv7sGU9aNhe7Xyx
         W70oHhLQagkGNI8ZNe7VvZX5iwYyhXsrl4kGRzIWJRVSo50NAC7C23DIEK/Gooj1Nz3T
         jXrDSdA2cJ7EQiAUwXJom4NV1uAPhUYGHSw9sYtBPOKvN5ouxLFL9Z3+SJUesVFNTgyR
         hJdmzkmt4v4ZCpSpbSRdIu6fGltc1W6KRuEy+cCdonEhilJYfINjZkYbb3FqHSkewUH3
         XjZLs3nMZjXdy9Ay8R+76anr6ZsuhGtIqvT146slkpzxBDeDnx+nsGsioiC2uNOJZDQV
         pWng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755807640; x=1756412440;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cq8CitEHOIa1E1kCzffFkimm5JhYQkJcPbJMgOYWCnc=;
        b=ZviUHHJf0ArAnNEOYFtq840Wj/GTMxnHpkST8On6Iu+j6fYO2Slh0kJ13z9oK8xvhb
         j12o35chOVYET/hCqNpIuD6LS9/VBV7dWLLhjbq11SovP5n/lWGAAPes8c2TdYgaayKk
         bkkNQZo7tGWQo+kdo0EkhQ+XE1qCXbv8/tRETisUg6Ldiuw5yz8whR5eat1RaT7WkS0j
         h/1qanSEIU/9x0RcPMYcmCv4LjfrQJpYzCzfHUi4sDL6FzkPncaeLlbh0Vq97k0lh/Lw
         DBIb0GuXJTEepa3QR8dUjtYSNbBietje8Z2+9NDfFi7MCv4M98J4OLPNkcCxhYz1uPSk
         sS/g==
X-Forwarded-Encrypted: i=1; AJvYcCVdJ0oTU72qod1BKaNME0YLKTOn/H8/+iMy4Yf0IR4P4eEKAp+zLqvqkJ9wJF9nlHKBe02dQnSp5hg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4ydNffSybnfpgfR0wA1sbqS8pA5v5WRYERWXzmhU+YA283Q+P
	GwkeVhL/MAw7tr4T2PoneaYCfKXVPap9WByEUlbKCfK3oxBRSu7rTHSXvK2XWIcfBxM=
X-Gm-Gg: ASbGncu8HOp+m3yCXmiJ0BHnEsT4TORojP/XRDY/Q6gfi7M8Of2mxTXu5fELQn2jYM/
	g2qmkG+golyavTsNy44JUI2LlJZljHMoQ1At+5ujBftzYH0hAovFbdruy36002Sba9e5ChkV1xW
	b/i+6TrynJNwBiSEGr8lnEfx6pJ33ZLgHHffH2h/3xdPwBg1fD19NH9pqhlYsumeeATqW3br8fn
	Xz9RtyTnYHS4QbSfVZaj1PcghUH++MgLRMiXzdf/cNwmq3e6HXQ/rA1I8Um6jsi49CiGiqNNuVz
	etxNt0YDVSJQVNbOUkXP4bWbe9m5vrRkAjFvTz6OED3p/7izUZar7IgwB8VuRw37Snb2vRbGKSs
	LK47gRZv3YwbF3skvd4nAiYBlf8xMZco5q4JJTMjw50HAcdK+MsbSXcWzOUs=
X-Google-Smtp-Source: AGHT+IF2O7wlpGJrENGQ2aGvG1BuhjQkjhrQFkStA83E9K3W/Lj4TvLcWt9Rj28gyNPq2k4QeOthLw==
X-Received: by 2002:a05:690c:7109:b0:71f:d22b:3526 with SMTP id 00721157ae682-71fdc2b148amr8123447b3.10.1755807639150;
        Thu, 21 Aug 2025 13:20:39 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71fd92b885fsm2500997b3.10.2025.08.21.13.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 13:20:38 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	brauner@kernel.org,
	viro@ZenIV.linux.org.uk
Subject: [PATCH 16/50] fs: change evict_inodes to use iput instead of evict directly
Date: Thu, 21 Aug 2025 16:18:27 -0400
Message-ID: <1198cd4cd35c5875fbf95dc3dca68650bb176bb1.1755806649.git.josef@toxicpanda.com>
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

At evict_inodes() time, we no longer have SB_ACTIVE set, so we can
easily go through the normal iput path to clear any inodes. Update
dispose_list() to check how we need to free the inode, and then grab a
full reference to the inode while we're looping through the remaining
inodes, and simply iput them at the end.

Since we're just calling iput we don't really care about the i_count on
the inode at the current time.  Remove the i_count checks and just call
iput on every inode we find.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/inode.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 72981b890ec6..80ad327746a7 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -933,7 +933,7 @@ static void evict(struct inode *inode)
  * Dispose-list gets a local list with local inodes in it, so it doesn't
  * need to worry about list corruption and SMP locks.
  */
-static void dispose_list(struct list_head *head)
+static void dispose_list(struct list_head *head, bool for_lru)
 {
 	while (!list_empty(head)) {
 		struct inode *inode;
@@ -941,8 +941,12 @@ static void dispose_list(struct list_head *head)
 		inode = list_first_entry(head, struct inode, i_lru);
 		list_del_init(&inode->i_lru);
 
-		evict(inode);
-		iobj_put(inode);
+		if (for_lru) {
+			evict(inode);
+			iobj_put(inode);
+		} else {
+			iput(inode);
+		}
 		cond_resched();
 	}
 }
@@ -964,21 +968,13 @@ void evict_inodes(struct super_block *sb)
 again:
 	spin_lock(&sb->s_inode_list_lock);
 	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		if (atomic_read(&inode->i_count))
-			continue;
-
 		spin_lock(&inode->i_lock);
-		if (atomic_read(&inode->i_count)) {
-			spin_unlock(&inode->i_lock);
-			continue;
-		}
 		if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
 			spin_unlock(&inode->i_lock);
 			continue;
 		}
 
-		inode->i_state |= I_FREEING;
-		iobj_get(inode);
+		__iget(inode);
 		inode_lru_list_del(inode);
 		spin_unlock(&inode->i_lock);
 		list_add(&inode->i_lru, &dispose);
@@ -991,13 +987,13 @@ void evict_inodes(struct super_block *sb)
 		if (need_resched()) {
 			spin_unlock(&sb->s_inode_list_lock);
 			cond_resched();
-			dispose_list(&dispose);
+			dispose_list(&dispose, false);
 			goto again;
 		}
 	}
 	spin_unlock(&sb->s_inode_list_lock);
 
-	dispose_list(&dispose);
+	dispose_list(&dispose, false);
 }
 EXPORT_SYMBOL_GPL(evict_inodes);
 
@@ -1108,7 +1104,7 @@ long prune_icache_sb(struct super_block *sb, struct shrink_control *sc)
 
 	freed = list_lru_shrink_walk(&sb->s_inode_lru, sc,
 				     inode_lru_isolate, &freeable);
-	dispose_list(&freeable);
+	dispose_list(&freeable, true);
 	return freed;
 }
 
-- 
2.49.0

