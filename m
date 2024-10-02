Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9784944E
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727833229; cv=none; b=sm4JFYhmzUo8EHsKUANJD83iISg6sOP4bwasXZUJrsuzcaumUZHf3UDr94lKXsJbrmOpzkd93dloV/cJKhOm4dIGfXHwJJY9i9uPQyXtKjaKyoKIfc7wtzBH56vfbcJeffj0doSALJm1WlnQgBg9FilIGyDB+dNgHWCucto7Yr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727833229; c=relaxed/simple;
	bh=fKLCm/Cgg+BtkT6PG8erpU4WyCSoo61yY/4mTCiiTfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9YPXcv9MEjjxy3zEQDPYmqLzBglN3GvAOcoP3fD948SVmebW2X33PayL4L05gWpqVnlTlU9Slm3hWBCkhXCWZ8nwRj/M1UHh43mT81/EAadmF5mA52GLnXWUZYd2mSW+gQO2odkc+zQRVzL2yGsTMqrs7qODll+dRPh+yV6dXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=rlwKY6Af; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="rlwKY6Af"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-20bc506347dso4826745ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 01 Oct 2024 18:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1727833225; x=1728438025; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vwfcVJq7o+XgwN+06xi8VPz55XdNhbrMI0UMCxMDdeo=;
        b=rlwKY6AfpFGLqmKqoVjPXRCko55NGwTtnSbW9XTXfXzLFUKCqOdlRGl4lI5GWT+mK5
         7vDNDGEt/ncWUAbh08rv7h6frb8oFwrhOSKP1z7ZwDx5G1Kv8WzJZoVRm47hbjtfz9oA
         jmMYZrNYwLEswvnV3nZKaSqrHqvXqzqUU8fkLM5wbUEcG76pmn0cAlMsCIlXV1nBjD+e
         fSmlWrjVG4Cj5WA1/D/HswkaSSFV2qTkjrc5q1aK1U4EqxiQyhmdjYgHmz/MVzx/k0lT
         40+B+ID5BFWQXQwCSzVNCvr21yLW2wD855ciMXctrWceWWsg558AG1jjFacBVQJUJX9q
         BHSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727833225; x=1728438025;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vwfcVJq7o+XgwN+06xi8VPz55XdNhbrMI0UMCxMDdeo=;
        b=bYVzFGJW4RHE00YOoOIdA/dUIG9E9/odk8RsUz7d+kWg8VeUbAOi1u6fJOCGkT25uj
         XqBYqrOPYcdIKipiW4PMKhwxqYlJu9h+Pewi+TD+6Ufcv7QB4M84JgK4Cu5I/w1JAlMU
         1/SzPMp85r0FVTnnkogM4FPoUAt1HLBrtZyaw2k42nYGONZrj1s71RBu30bNSq8Pat/6
         kh4yKfBPEIfaAbmuDn3MaY6uA4pnORib37Jnysk7wRiMJnd1R+4dqKNIudlghTGbP9vJ
         vFDsKr43ZOyDiCrD38gFlD12eolDwt0INo+WzIwGiRYlXDI0ucbLUY2BloRfOWssCqxr
         eGgA==
X-Gm-Message-State: AOJu0YzjJhnil23xeqmfl2LUQ97oU1O8ObQWuw0UpLDGTZOWUTlXOQUP
	janvPOOSE0zLgGJA30feGZ1tqoownkH9+CQDSA0QKSwFra2zZOmj/7SDGRhZxAZW9jfdwh8YKZt
	h
X-Google-Smtp-Source: AGHT+IEm41b4rrxSuTtQrNmXz+VS03pIIfUgDjrgzxeEWMyE94AIgjNykG0g2L7Q9ZQ61XJ4d+evEQ==
X-Received: by 2002:a17:903:41ce:b0:20b:b39d:9735 with SMTP id d9443c01a7336-20bc5a7fb62mr20130495ad.54.1727833225054;
        Tue, 01 Oct 2024 18:40:25 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20b37d67195sm75669825ad.37.2024.10.01.18.40.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2024 18:40:22 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1svoLj-00Ck8b-0V;
	Wed, 02 Oct 2024 11:40:19 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.98)
	(envelope-from <dave@devoid.disaster.area>)
	id 1svoLj-0000000FxGO-2SC8;
	Wed, 02 Oct 2024 11:40:19 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-bcachefs@vger.kernel.org,
	kent.overstreet@linux.dev,
	torvalds@linux-foundation.org
Subject: [PATCH 4/7] vfs: Convert sb->s_inodes iteration to super_iter_inodes()
Date: Wed,  2 Oct 2024 11:33:21 +1000
Message-ID: <20241002014017.3801899-5-david@fromorbit.com>
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

Convert all the remaining superblock inode iterators to use
super_iter_inodes(). These are mostly straight forward conversions
for the iterations that use references, and the bdev use cases that
didn't even validate the inode before dereferencing it are now
inherently safe.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 block/bdev.c           |  76 ++++++++--------------
 fs/drop_caches.c       |  38 ++++-------
 fs/gfs2/ops_fstype.c   |  67 ++++++-------------
 fs/notify/fsnotify.c   |  75 ++++++---------------
 fs/quota/dquot.c       |  79 +++++++++--------------
 security/landlock/fs.c | 143 ++++++++++++++---------------------------
 6 files changed, 154 insertions(+), 324 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index b5a362156ca1..5f720e12f731 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -1226,56 +1226,36 @@ void bdev_mark_dead(struct block_device *bdev, bool surprise)
  */
 EXPORT_SYMBOL_GPL(bdev_mark_dead);
 
+static int sync_bdev_fn(struct inode *inode, void *data)
+{
+	struct block_device *bdev;
+	bool wait = *(bool *)data;
+
+	if (inode->i_mapping->nrpages == 0)
+		return INO_ITER_DONE;
+
+	bdev = I_BDEV(inode);
+	mutex_lock(&bdev->bd_disk->open_mutex);
+	if (!atomic_read(&bdev->bd_openers)) {
+		; /* skip */
+	} else if (wait) {
+		/*
+		 * We keep the error status of individual mapping so
+		 * that applications can catch the writeback error using
+		 * fsync(2). See filemap_fdatawait_keep_errors() for
+		 * details.
+		 */
+		filemap_fdatawait_keep_errors(inode->i_mapping);
+	} else {
+		filemap_fdatawrite(inode->i_mapping);
+	}
+	mutex_unlock(&bdev->bd_disk->open_mutex);
+	return INO_ITER_DONE;
+}
+
 void sync_bdevs(bool wait)
 {
-	struct inode *inode, *old_inode = NULL;
-
-	spin_lock(&blockdev_superblock->s_inode_list_lock);
-	list_for_each_entry(inode, &blockdev_superblock->s_inodes, i_sb_list) {
-		struct address_space *mapping = inode->i_mapping;
-		struct block_device *bdev;
-
-		spin_lock(&inode->i_lock);
-		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW) ||
-		    mapping->nrpages == 0) {
-			spin_unlock(&inode->i_lock);
-			continue;
-		}
-		__iget(inode);
-		spin_unlock(&inode->i_lock);
-		spin_unlock(&blockdev_superblock->s_inode_list_lock);
-		/*
-		 * We hold a reference to 'inode' so it couldn't have been
-		 * removed from s_inodes list while we dropped the
-		 * s_inode_list_lock  We cannot iput the inode now as we can
-		 * be holding the last reference and we cannot iput it under
-		 * s_inode_list_lock. So we keep the reference and iput it
-		 * later.
-		 */
-		iput(old_inode);
-		old_inode = inode;
-		bdev = I_BDEV(inode);
-
-		mutex_lock(&bdev->bd_disk->open_mutex);
-		if (!atomic_read(&bdev->bd_openers)) {
-			; /* skip */
-		} else if (wait) {
-			/*
-			 * We keep the error status of individual mapping so
-			 * that applications can catch the writeback error using
-			 * fsync(2). See filemap_fdatawait_keep_errors() for
-			 * details.
-			 */
-			filemap_fdatawait_keep_errors(inode->i_mapping);
-		} else {
-			filemap_fdatawrite(inode->i_mapping);
-		}
-		mutex_unlock(&bdev->bd_disk->open_mutex);
-
-		spin_lock(&blockdev_superblock->s_inode_list_lock);
-	}
-	spin_unlock(&blockdev_superblock->s_inode_list_lock);
-	iput(old_inode);
+	super_iter_inodes(blockdev_superblock, sync_bdev_fn, &wait, 0);
 }
 
 /*
diff --git a/fs/drop_caches.c b/fs/drop_caches.c
index d45ef541d848..901cda15537f 100644
--- a/fs/drop_caches.c
+++ b/fs/drop_caches.c
@@ -16,36 +16,20 @@
 /* A global variable is a bit ugly, but it keeps the code simple */
 int sysctl_drop_caches;
 
-static void drop_pagecache_sb(struct super_block *sb, void *unused)
+static int invalidate_inode_fn(struct inode *inode, void *data)
 {
-	struct inode *inode, *toput_inode = NULL;
-
-	spin_lock(&sb->s_inode_list_lock);
-	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		spin_lock(&inode->i_lock);
-		/*
-		 * We must skip inodes in unusual state. We may also skip
-		 * inodes without pages but we deliberately won't in case
-		 * we need to reschedule to avoid softlockups.
-		 */
-		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
-		    (mapping_empty(inode->i_mapping) && !need_resched())) {
-			spin_unlock(&inode->i_lock);
-			continue;
-		}
-		__iget(inode);
-		spin_unlock(&inode->i_lock);
-		spin_unlock(&sb->s_inode_list_lock);
-
+	if (!mapping_empty(inode->i_mapping))
 		invalidate_mapping_pages(inode->i_mapping, 0, -1);
-		iput(toput_inode);
-		toput_inode = inode;
+	return INO_ITER_DONE;
+}
 
-		cond_resched();
-		spin_lock(&sb->s_inode_list_lock);
-	}
-	spin_unlock(&sb->s_inode_list_lock);
-	iput(toput_inode);
+/*
+ * Note: it would be nice to check mapping_empty() before we get a reference on
+ * the inode in super_iter_inodes(), but that's a future optimisation.
+ */
+static void drop_pagecache_sb(struct super_block *sb, void *unused)
+{
+	super_iter_inodes(sb, invalidate_inode_fn, NULL, 0);
 }
 
 int drop_caches_sysctl_handler(const struct ctl_table *table, int write,
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index e83d293c3614..f20862614ad6 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1714,53 +1714,10 @@ static int gfs2_meta_init_fs_context(struct fs_context *fc)
 	return 0;
 }
 
-/**
- * gfs2_evict_inodes - evict inodes cooperatively
- * @sb: the superblock
- *
- * When evicting an inode with a zero link count, we are trying to upgrade the
- * inode's iopen glock from SH to EX mode in order to determine if we can
- * delete the inode.  The other nodes are supposed to evict the inode from
- * their caches if they can, and to poke the inode's inode glock if they cannot
- * do so.  Either behavior allows gfs2_upgrade_iopen_glock() to proceed
- * quickly, but if the other nodes are not cooperating, the lock upgrading
- * attempt will time out.  Since inodes are evicted sequentially, this can add
- * up quickly.
- *
- * Function evict_inodes() tries to keep the s_inode_list_lock list locked over
- * a long time, which prevents other inodes from being evicted concurrently.
- * This precludes the cooperative behavior we are looking for.  This special
- * version of evict_inodes() avoids that.
- *
- * Modeled after drop_pagecache_sb().
- */
-static void gfs2_evict_inodes(struct super_block *sb)
+/* Nothing to do because we just want to bounce the inode through iput() */
+static int gfs2_evict_inode_fn(struct inode *inode, void *data)
 {
-	struct inode *inode, *toput_inode = NULL;
-	struct gfs2_sbd *sdp = sb->s_fs_info;
-
-	set_bit(SDF_EVICTING, &sdp->sd_flags);
-
-	spin_lock(&sb->s_inode_list_lock);
-	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		spin_lock(&inode->i_lock);
-		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) &&
-		    !need_resched()) {
-			spin_unlock(&inode->i_lock);
-			continue;
-		}
-		atomic_inc(&inode->i_count);
-		spin_unlock(&inode->i_lock);
-		spin_unlock(&sb->s_inode_list_lock);
-
-		iput(toput_inode);
-		toput_inode = inode;
-
-		cond_resched();
-		spin_lock(&sb->s_inode_list_lock);
-	}
-	spin_unlock(&sb->s_inode_list_lock);
-	iput(toput_inode);
+	return INO_ITER_DONE;
 }
 
 static void gfs2_kill_sb(struct super_block *sb)
@@ -1779,7 +1736,23 @@ static void gfs2_kill_sb(struct super_block *sb)
 	sdp->sd_master_dir = NULL;
 	shrink_dcache_sb(sb);
 
-	gfs2_evict_inodes(sb);
+	/*
+	 * When evicting an inode with a zero link count, we are trying to
+	 * upgrade the inode's iopen glock from SH to EX mode in order to
+	 * determine if we can delete the inode.  The other nodes are supposed
+	 * to evict the inode from their caches if they can, and to poke the
+	 * inode's inode glock if they cannot do so.  Either behavior allows
+	 * gfs2_upgrade_iopen_glock() to proceed quickly, but if the other nodes
+	 * are not cooperating, the lock upgrading attempt will time out.  Since
+	 * inodes are evicted sequentially, this can add up quickly.
+	 *
+	 * evict_inodes() tries to keep the s_inode_list_lock list locked over a
+	 * long time, which prevents other inodes from being evicted
+	 * concurrently.  This precludes the cooperative behavior we are looking
+	 * for. 
+	 */
+	set_bit(SDF_EVICTING, &sdp->sd_flags);
+	super_iter_inodes(sb, gfs2_evict_inode_fn, NULL, 0);
 
 	/*
 	 * Flush and then drain the delete workqueue here (via
diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 272c8a1dab3c..68c34ed94271 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -28,63 +28,14 @@ void __fsnotify_vfsmount_delete(struct vfsmount *mnt)
 	fsnotify_clear_marks_by_mount(mnt);
 }
 
-/**
- * fsnotify_unmount_inodes - an sb is unmounting.  handle any watched inodes.
- * @sb: superblock being unmounted.
- *
- * Called during unmount with no locks held, so needs to be safe against
- * concurrent modifiers. We temporarily drop sb->s_inode_list_lock and CAN block.
- */
-static void fsnotify_unmount_inodes(struct super_block *sb)
+static int fsnotify_unmount_inode_fn(struct inode *inode, void *data)
 {
-	struct inode *inode, *iput_inode = NULL;
+	spin_unlock(&inode->i_lock);
 
-	spin_lock(&sb->s_inode_list_lock);
-	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		/*
-		 * We cannot __iget() an inode in state I_FREEING,
-		 * I_WILL_FREE, or I_NEW which is fine because by that point
-		 * the inode cannot have any associated watches.
-		 */
-		spin_lock(&inode->i_lock);
-		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) {
-			spin_unlock(&inode->i_lock);
-			continue;
-		}
-
-		/*
-		 * If i_count is zero, the inode cannot have any watches and
-		 * doing an __iget/iput with SB_ACTIVE clear would actually
-		 * evict all inodes with zero i_count from icache which is
-		 * unnecessarily violent and may in fact be illegal to do.
-		 * However, we should have been called /after/ evict_inodes
-		 * removed all zero refcount inodes, in any case.  Test to
-		 * be sure.
-		 */
-		if (!atomic_read(&inode->i_count)) {
-			spin_unlock(&inode->i_lock);
-			continue;
-		}
-
-		__iget(inode);
-		spin_unlock(&inode->i_lock);
-		spin_unlock(&sb->s_inode_list_lock);
-
-		iput(iput_inode);
-
-		/* for each watch, send FS_UNMOUNT and then remove it */
-		fsnotify_inode(inode, FS_UNMOUNT);
-
-		fsnotify_inode_delete(inode);
-
-		iput_inode = inode;
-
-		cond_resched();
-		spin_lock(&sb->s_inode_list_lock);
-	}
-	spin_unlock(&sb->s_inode_list_lock);
-
-	iput(iput_inode);
+	/* for each watch, send FS_UNMOUNT and then remove it */
+	fsnotify_inode(inode, FS_UNMOUNT);
+	fsnotify_inode_delete(inode);
+	return INO_ITER_DONE;
 }
 
 void fsnotify_sb_delete(struct super_block *sb)
@@ -95,7 +46,19 @@ void fsnotify_sb_delete(struct super_block *sb)
 	if (!sbinfo)
 		return;
 
-	fsnotify_unmount_inodes(sb);
+	/*
+	 * If i_count is zero, the inode cannot have any watches and
+	 * doing an __iget/iput with SB_ACTIVE clear would actually
+	 * evict all inodes with zero i_count from icache which is
+	 * unnecessarily violent and may in fact be illegal to do.
+	 * However, we should have been called /after/ evict_inodes
+	 * removed all zero refcount inodes, in any case. Hence we use
+	 * INO_ITER_REFERENCED to ensure zero refcount inodes are filtered
+	 * properly.
+	 */
+	super_iter_inodes(sb, fsnotify_unmount_inode_fn, NULL,
+			INO_ITER_REFERENCED);
+
 	fsnotify_clear_marks_by_sb(sb);
 	/* Wait for outstanding object references from connectors */
 	wait_var_event(fsnotify_sb_watched_objects(sb),
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index ea0bd807fed7..ea9fce7acd1b 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -1017,56 +1017,40 @@ static int dqinit_needed(struct inode *inode, int type)
 	return 0;
 }
 
+struct dquot_ref_data {
+	int	type;
+	int	reserved;
+};
+
+static int add_dquot_ref_fn(struct inode *inode, void *data)
+{
+	struct dquot_ref_data *ref = data;
+	int ret;
+
+	if (!dqinit_needed(inode, ref->type))
+		return INO_ITER_DONE;
+
+#ifdef CONFIG_QUOTA_DEBUG
+	if (unlikely(inode_get_rsv_space(inode) > 0))
+		ref->reserved++;
+#endif
+	ret = __dquot_initialize(inode, ref->type);
+	if (ret < 0)
+		return ret;
+	return INO_ITER_DONE;
+}
+
 /* This routine is guarded by s_umount semaphore */
 static int add_dquot_ref(struct super_block *sb, int type)
 {
-	struct inode *inode, *old_inode = NULL;
-#ifdef CONFIG_QUOTA_DEBUG
-	int reserved = 0;
-#endif
-	int err = 0;
-
-	spin_lock(&sb->s_inode_list_lock);
-	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		spin_lock(&inode->i_lock);
-		if ((inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW)) ||
-		    !atomic_read(&inode->i_writecount) ||
-		    !dqinit_needed(inode, type)) {
-			spin_unlock(&inode->i_lock);
-			continue;
-		}
-		__iget(inode);
-		spin_unlock(&inode->i_lock);
-		spin_unlock(&sb->s_inode_list_lock);
-
-#ifdef CONFIG_QUOTA_DEBUG
-		if (unlikely(inode_get_rsv_space(inode) > 0))
-			reserved = 1;
-#endif
-		iput(old_inode);
-		err = __dquot_initialize(inode, type);
-		if (err) {
-			iput(inode);
-			goto out;
-		}
+	struct dquot_ref_data ref = {
+		.type = type,
+	};
+	int err;
 
-		/*
-		 * We hold a reference to 'inode' so it couldn't have been
-		 * removed from s_inodes list while we dropped the
-		 * s_inode_list_lock. We cannot iput the inode now as we can be
-		 * holding the last reference and we cannot iput it under
-		 * s_inode_list_lock. So we keep the reference and iput it
-		 * later.
-		 */
-		old_inode = inode;
-		cond_resched();
-		spin_lock(&sb->s_inode_list_lock);
-	}
-	spin_unlock(&sb->s_inode_list_lock);
-	iput(old_inode);
-out:
+	err = super_iter_inodes(sb, add_dquot_ref_fn, &ref, 0);
 #ifdef CONFIG_QUOTA_DEBUG
-	if (reserved) {
+	if (ref.reserved) {
 		quota_error(sb, "Writes happened before quota was turned on "
 			"thus quota information is probably inconsistent. "
 			"Please run quotacheck(8)");
@@ -1075,11 +1059,6 @@ static int add_dquot_ref(struct super_block *sb, int type)
 	return err;
 }
 
-struct dquot_ref_data {
-	int	type;
-	int	reserved;
-};
-
 static int remove_dquot_ref_fn(struct inode *inode, void *data)
 {
 	struct dquot_ref_data *ref = data;
diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index 7d79fc8abe21..013ec4017ddd 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -1223,109 +1223,60 @@ static void hook_inode_free_security_rcu(void *inode_security)
 
 /*
  * Release the inodes used in a security policy.
- *
- * Cf. fsnotify_unmount_inodes() and invalidate_inodes()
  */
+static int release_inode_fn(struct inode *inode, void *data)
+{
+
+	rcu_read_lock();
+	object = rcu_dereference(landlock_inode(inode)->object);
+	if (!object) {
+		rcu_read_unlock();
+		return INO_ITER_DONE;
+	}
+
+	/*
+	 * If there is no concurrent release_inode() ongoing, then we
+	 * are in charge of calling iput() on this inode, otherwise we
+	 * will just wait for it to finish.
+	 */
+	spin_lock(&object->lock);
+	if (object->underobj != inode) {
+		spin_unlock(&object->lock);
+		rcu_read_unlock();
+		return INO_ITER_DONE;
+	}
+
+	object->underobj = NULL;
+	spin_unlock(&object->lock);
+	rcu_read_unlock();
+
+	/*
+	 * Because object->underobj was not NULL, release_inode() and
+	 * get_inode_object() guarantee that it is safe to reset
+	 * landlock_inode(inode)->object while it is not NULL.  It is therefore
+	 * not necessary to lock inode->i_lock.
+	 */
+	rcu_assign_pointer(landlock_inode(inode)->object, NULL);
+
+	/*
+	 * At this point, we own the ihold() reference that was originally set
+	 * up by get_inode_object() as well as the reference the inode iterator
+	 * obtained before calling us.  Therefore the following call to iput()
+	 * will not sleep nor drop the inode because there is now at least two
+	 * references to it.
+	 */
+	iput(inode);
+	return INO_ITER_DONE;
+}
+
 static void hook_sb_delete(struct super_block *const sb)
 {
-	struct inode *inode, *prev_inode = NULL;
-
 	if (!landlock_initialized)
 		return;
 
-	spin_lock(&sb->s_inode_list_lock);
-	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
-		struct landlock_object *object;
+	super_iter_inodes(sb, release_inode_fn, NULL, 0);
 
-		/* Only handles referenced inodes. */
-		if (!atomic_read(&inode->i_count))
-			continue;
-
-		/*
-		 * Protects against concurrent modification of inode (e.g.
-		 * from get_inode_object()).
-		 */
-		spin_lock(&inode->i_lock);
-		/*
-		 * Checks I_FREEING and I_WILL_FREE  to protect against a race
-		 * condition when release_inode() just called iput(), which
-		 * could lead to a NULL dereference of inode->security or a
-		 * second call to iput() for the same Landlock object.  Also
-		 * checks I_NEW because such inode cannot be tied to an object.
-		 */
-		if (inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW)) {
-			spin_unlock(&inode->i_lock);
-			continue;
-		}
-
-		rcu_read_lock();
-		object = rcu_dereference(landlock_inode(inode)->object);
-		if (!object) {
-			rcu_read_unlock();
-			spin_unlock(&inode->i_lock);
-			continue;
-		}
-		/* Keeps a reference to this inode until the next loop walk. */
-		__iget(inode);
-		spin_unlock(&inode->i_lock);
-
-		/*
-		 * If there is no concurrent release_inode() ongoing, then we
-		 * are in charge of calling iput() on this inode, otherwise we
-		 * will just wait for it to finish.
-		 */
-		spin_lock(&object->lock);
-		if (object->underobj == inode) {
-			object->underobj = NULL;
-			spin_unlock(&object->lock);
-			rcu_read_unlock();
-
-			/*
-			 * Because object->underobj was not NULL,
-			 * release_inode() and get_inode_object() guarantee
-			 * that it is safe to reset
-			 * landlock_inode(inode)->object while it is not NULL.
-			 * It is therefore not necessary to lock inode->i_lock.
-			 */
-			rcu_assign_pointer(landlock_inode(inode)->object, NULL);
-			/*
-			 * At this point, we own the ihold() reference that was
-			 * originally set up by get_inode_object() and the
-			 * __iget() reference that we just set in this loop
-			 * walk.  Therefore the following call to iput() will
-			 * not sleep nor drop the inode because there is now at
-			 * least two references to it.
-			 */
-			iput(inode);
-		} else {
-			spin_unlock(&object->lock);
-			rcu_read_unlock();
-		}
-
-		if (prev_inode) {
-			/*
-			 * At this point, we still own the __iget() reference
-			 * that we just set in this loop walk.  Therefore we
-			 * can drop the list lock and know that the inode won't
-			 * disappear from under us until the next loop walk.
-			 */
-			spin_unlock(&sb->s_inode_list_lock);
-			/*
-			 * We can now actually put the inode reference from the
-			 * previous loop walk, which is not needed anymore.
-			 */
-			iput(prev_inode);
-			cond_resched();
-			spin_lock(&sb->s_inode_list_lock);
-		}
-		prev_inode = inode;
-	}
-	spin_unlock(&sb->s_inode_list_lock);
-
-	/* Puts the inode reference from the last loop walk, if any. */
-	if (prev_inode)
-		iput(prev_inode);
-	/* Waits for pending iput() in release_inode(). */
+	/* Waits for pending iput()s in release_inode(). */
 	wait_var_event(&landlock_superblock(sb)->inode_refs,
 		       !atomic_long_read(&landlock_superblock(sb)->inode_refs));
 }
-- 
2.45.2

