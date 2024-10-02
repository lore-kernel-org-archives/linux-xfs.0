Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C531FBA
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727833225; cv=none; b=XgaPk9xdmQMEGkFZcIMtMrRlq7yAlPPLtI2HxlmNR7w5DKiycTCXfMOP+50a+pZUrtLzWvpfWf+Gu/NmRr0AoHd8tYBk03P+OCjJvUTie4dfT5VFhBhnmaTbqAq4qSEjvE23foYsKlTngDzilkQnhkPackdcFepeWQdzQychSu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727833225; c=relaxed/simple;
	bh=octIU91dvJC7QTSpf1g04NsSgkp/76SSEC+udarKgpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DlwJfTpaCwS4nKLwGu7peS0702C/5LSFvnDS4ipYnZmvrscH/5Lt8QaXmnToZm1s+R09JB245yn2jQFNKypBtr4BT7ll33T2J4kTUpmdWU8WU7olIHOT6fWAoXkd6zWsYH495cSkLgQMZZiQF18NQ45z6IFEDrxaLQ/sAAo6+PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=Hyimm1kj; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="Hyimm1kj"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-71c702b2d50so2248817b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 01 Oct 2024 18:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1727833223; x=1728438023; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ADEbyi31TdRw5PkbTTqYB4v7r+R49eetqXpO/YsbAKY=;
        b=Hyimm1kjtLEdszTLDvcxRmc2fkYCEPYH6uCdPJmz/dB0d9W5Nipv8x8rIX8c9c6ZnY
         7J7J5uut3rrc7cAZNEPCWpZtrm51mgAM6HwUK43P7MC/zLFXvCCKG++mg06KH8LZRymS
         ulFC3qNrZfVdRGMwgYZh986OCAK1D+qptPc9v3a8nGTF/X5KDw+wDmAxfEh1lrt5MtzL
         4P8TE0YmkT70bw4gEJplHK7hr/0sfpvYCon7P0kiSYfSHWE+YURNtGzhSXhxm+XBzYQv
         GWFqIt2v8qCkA+/jqQg68LWHOCtEbhOj5Oq4aOjnMQJwZ0yWCFkLeGG9jRkdZOr++RVJ
         FQmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727833223; x=1728438023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ADEbyi31TdRw5PkbTTqYB4v7r+R49eetqXpO/YsbAKY=;
        b=kNKb78WXHPmygiZ1/Vu+P3Hkd3onUW+RWKw7Rc1UnKo5SNTmIco2Gfwid8WAwG5q7Q
         YS9a/gQI1tMyqyWUswKohbQBYRlqE1QvQGc8MExBvUY6UMdmZgnevC6y6B22c7QksHnw
         6IAZVCIez+WytRCW+GEScaG1+IzNiEyVPWU9Tyb7fWwgzABBmVU8GKiKvpG7MpZaE2Jn
         8ckF0h6L11JuR6vP43b0xB/daLzN5aZvYrVXy6DysTSe5w606pp8OC1PJPIGVMHOCdrf
         mQYV42ZHSKDeRJ7L6CW0otCxw4DsmlwEQYJ/mtdtkDQe72WSJUpqZ/3d3QvwvaZR1ly+
         j4TQ==
X-Gm-Message-State: AOJu0YxSkRVSbzL1NSTBOAw9pKfaQYAt9BP5SDrvqAPcnSEpJhXTw7GU
	O8FZ4T5Iq999VL5XbWq+8vBjtP+c9IYfIbi6tXr8ELc3oiHG/rbhR1XYSEFwfnzeS4uWlQ1Of7E
	Q
X-Google-Smtp-Source: AGHT+IEZkPzavG/0ctUXSwBmb+RiGkcau7gELiXN8VvFFwrvg3zoqeGa50a7ZkffoAiN7R5hu1C+6Q==
X-Received: by 2002:a05:6a00:1496:b0:713:e3f9:b58e with SMTP id d2e1a72fcca58-71dc5d590e3mr2822396b3a.17.1727833222634;
        Tue, 01 Oct 2024 18:40:22 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71b2649b08csm9091868b3a.11.2024.10.01.18.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2024 18:40:22 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1svoLj-00Ck8R-06;
	Wed, 02 Oct 2024 11:40:19 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.98)
	(envelope-from <dave@devoid.disaster.area>)
	id 1svoLj-0000000FxGC-1zbh;
	Wed, 02 Oct 2024 11:40:19 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-bcachefs@vger.kernel.org,
	kent.overstreet@linux.dev,
	torvalds@linux-foundation.org
Subject: [PATCH 1/7] vfs: replace invalidate_inodes() with evict_inodes()
Date: Wed,  2 Oct 2024 11:33:18 +1000
Message-ID: <20241002014017.3801899-2-david@fromorbit.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241002014017.3801899-1-david@fromorbit.com>
References: <20241002014017.3801899-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

As of commit e127b9bccdb0 ("fs: simplify invalidate_inodes"),
invalidate_inodes() is functionally identical to evict_inodes().
Replace calls to invalidate_inodes() with a call to
evict_inodes() and kill the former.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/inode.c    | 40 ----------------------------------------
 fs/internal.h |  1 -
 fs/super.c    |  2 +-
 3 files changed, 1 insertion(+), 42 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 471ae4a31549..0a53d8c34203 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -827,46 +827,6 @@ void evict_inodes(struct super_block *sb)
 }
 EXPORT_SYMBOL_GPL(evict_inodes);
 
-/**
- * invalidate_inodes	- attempt to free all inodes on a superblock
- * @sb:		superblock to operate on
- *
- * Attempts to free all inodes (including dirty inodes) for a given superblock.
- */
-void invalidate_inodes(struct super_block *sb)
-{
-	struct inode *inode, *next;
-	LIST_HEAD(dispose);
-
-again:
-	spin_lock(&sb->s_inode_list_lock);
-	list_for_each_entry_safe(inode, next, &sb->s_inodes, i_sb_list) {
-		spin_lock(&inode->i_lock);
-		if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
-			spin_unlock(&inode->i_lock);
-			continue;
-		}
-		if (atomic_read(&inode->i_count)) {
-			spin_unlock(&inode->i_lock);
-			continue;
-		}
-
-		inode->i_state |= I_FREEING;
-		inode_lru_list_del(inode);
-		spin_unlock(&inode->i_lock);
-		list_add(&inode->i_lru, &dispose);
-		if (need_resched()) {
-			spin_unlock(&sb->s_inode_list_lock);
-			cond_resched();
-			dispose_list(&dispose);
-			goto again;
-		}
-	}
-	spin_unlock(&sb->s_inode_list_lock);
-
-	dispose_list(&dispose);
-}
-
 /*
  * Isolate the inode from the LRU in preparation for freeing it.
  *
diff --git a/fs/internal.h b/fs/internal.h
index 8c1b7acbbe8f..37749b429e80 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -207,7 +207,6 @@ bool in_group_or_capable(struct mnt_idmap *idmap,
  * fs-writeback.c
  */
 extern long get_nr_dirty_inodes(void);
-void invalidate_inodes(struct super_block *sb);
 
 /*
  * dcache.c
diff --git a/fs/super.c b/fs/super.c
index 1db230432960..a16e6a6342e0 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1417,7 +1417,7 @@ static void fs_bdev_mark_dead(struct block_device *bdev, bool surprise)
 	if (!surprise)
 		sync_filesystem(sb);
 	shrink_dcache_sb(sb);
-	invalidate_inodes(sb);
+	evict_inodes(sb);
 	if (sb->s_op->shutdown)
 		sb->s_op->shutdown(sb);
 
-- 
2.45.2

