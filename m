Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793135414;
	b=x9Sljvrt1WNcod1/MMqaBV8HoC7uKHRRhG/1gD9SoHTdfQcvuEX2j9a1DDeGwnH5Adol
	 xdNq/4PO5PqerUM7TxG7dTiuAhD3MFCVZKhUIDXObZLXT9AlZEGql3IHPfUT0jG08MM8T
	 X59M2rkXYGIPpBvoNUghOX8O5Kezg5q34mYy8d0Dx13sXilKfT6fI1Yp7NvnzeWUDjA+H
	 f3JHLn22VUaAtPYL3oaUVJVsAYfKziUv0UnBk7A2LJzw5NtZLwMhPW4oyAe57J/rA0Rzd
	 PZwzXtgeKf3WE9OuJnLE3M33/jQlJlWoqosl4nkum1F2C3LM39SI39N8yEfUU8OiKsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793135414;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=1JXKqGgtIMnvjajZ/W91C0JXO85yrC5CihZUyJL+s6w=;
	b=QA7xvG1TcJjm975/y5dUCVNyhT3MC/JJ1d1WdxAr+p7MIPTN/m4LaWpSpNoGHfKlvnB6
	 fMUr/1Ryutm5HCYBr5e6m2kneIJ8cnj0CPDP+3qKa/bFYKwTkaARNUnhV30ohwVNoQRgZ
	 JkWzU6AFagSCAstxJ+zaURHPxGdpAk4KYXzXSPm+lPq1NyMgS1tRBqThsjjPU4RqWLdAm
	 2Cra2ZIqli0zxOnz6ln3MxCt6AhjkOXXkgMTdv2EyVXff6gGdEFHVWTcahVruAUnLLw/f
	 umDYnYovagazwOI4kfltwcij26gBV4A1l1OXH3CBilNxH1rE4hdPkuy21GGMa8FS6Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=toxicpanda.com;
	spf=pass smtp.mailfrom=toxicpanda.com;
	dkim=pass header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=du+UUeH1;
	arc=none smtp.remote-ip=209.85.160.182
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E7360A6F41
	for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 21:10:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C0E7360A6F41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=du+UUeH1
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5351d76e1baso3137411cf.1
        for <linux-xfs@vger.kernel.org>; Tue, 27 Oct 2026 14:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793135400; x=1793740200; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1JXKqGgtIMnvjajZ/W91C0JXO85yrC5CihZUyJL+s6w=;
        b=du+UUeH1FevE4UhfTYKkUg0pxrrockf3MVtYmlIBRQv8RLTKiar5c1xXKZIQdHiT7S
         0J4m5Mn8QaNZSi1vZK/Z7AdoFTZcxF0399iSabNzoUSwWeBLziFraoh3PaUBxkszg45C
         vZUi4VaNpA3EQ/13dfzenEw/SWkt7Vx3ilhAoonBKlrU2XSRGh/nBVFDEw6hX+cDW+sW
         geRQCk8PVxVZYBJiKQa72ggVa7czD4R9JfcXLcDogDHVGQL76jg+L/Hahc1TXhhccPDC
         MQB4PYfR/ITTM3grhPDp9KWmCO8NYlVJ1OBnURnnEl6/ta5hiDwlwh5iaVfUNkz8yxo6
         zKow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793135400; x=1793740200;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1JXKqGgtIMnvjajZ/W91C0JXO85yrC5CihZUyJL+s6w=;
        b=HAXUZ7h6sPCMALCw+8dDa/420lwZ8Lk2VyQAAGRQYTpgwCcWvS/80dTPdEjJZC6sd9
         PO9S1W2oANA11FKZcB0Tnh+RaRMAVHvlXItTy6JB/MgIsbDMrP7RXUFPnz9xMl+NUPrB
         EtN4BtP+oAjw+mAAc2z6D1sJULgzZgM+mOr44umdFz1mMRQ6McbV0PD1zlnrKrzUz4I2
         VDyJzKV8hENoLx5HtFikkQtLchTIFnnj2oAPWYWx9JCqTUJsfyPx7AibH+ea3HkRSQck
         9hAQbUqVVcjtLUMKg7tw/s8lIICRvwq/k+VtAxK62/AtI3f/kfMFYQLM6f/KGG//lR4L
         VkZg==
X-Forwarded-Encrypted: i=1; AKwUvBxZt5Xj4Vgqw8/yrl1UR140zArs3v1j2n+E4eKRDlAqomVLdWFKIZ+3HiCYrSupV9RAy5jYext9uiE=@vger.kernel.org
X-Gm-Message-State: AFq9FYKrz76WggsPMt1QhFr8S43h6+NcgoOjFUbs22yTEil0+VVEWw4p
	U4ln602yTAQXJiryCNZKf0O1l1x9A5V1z+/AXLUvdapxOXts+eHt1+nbc5ucT7pYpf9uf9aeCnB
	qX4jp
X-Gm-Gg: AYBFou2wFTKztd0LoGlX3uXFJJDBetDzHYADlIw5mLP9kkWLEEr5JbPDDFYABB87p3w
	GuAaqIDCW+5f/d1jScLSonTsK65JAaUfJyYlSAq/hn322QdZq2DYuRAeIzr/WCx+Ebq4e+g+TOO
	xFQ4j5bm4oEVsTdElawc75vku7QTCF9gdQBO5tIwrw9Gd5L9BJ17B8aHSxqooUYydeYTq9BP5Jh
	Y4bqOMg8mifVG/ejUbUUjn7KgDE5vPWB0cQlYUgOCahYIl3tRWNfsrhn2XQSl8MY1TCcEK6KV7B
	MRyH4TX+wbaET2VRDZ0s0Wggx0eh995zq9KieW8kB7v3Pf6+pfa0kTdZnsUZsVo+J7sjaxd3sAS
	rl7EfOwOd2AwvWWZl/rO0kJTJ4nkpeSiteARqJk+BlJY9gTWds7tZPwASrhm8egqzQzAnt0LNA+
	4gnivyTl60+iyxJdSg11s3E3FgPRo7pgTYwyIqFiHjsiQMaTzK8m8YhQw8hsL6V42+/Vntv05Qy
	pcr71uEnSJ5UIn4QGeNM6RhFlro7cIOvPFLIMryY+LWwSUMXBkUNJ/Ok6AitJEekuNp3VuN
X-Received: by 2002:ac8:5dd3:0:b0:536:5880:18d4 with SMTP id d75a77b69052e-53fcb405265mr9279481cf.11.1793135399767;
        Tue, 27 Oct 2026 14:09:59 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.248])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-538394c5273sm88408511cf.9.2026.10.27.14.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 14:09:59 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 27 Oct 2026 21:09:35 +0000
Subject: [PATCH 09/10] ovl: handle lazytime on the upper filesystem
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-b4-ovl-containerized-sync-v1-9-802e512379a6@toxicpanda.com>
References: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
In-Reply-To: <20261027-b4-ovl-containerized-sync-v1-0-802e512379a6@toxicpanda.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Christian Brauner <brauner@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Theodore Ts'o <tytso@mit.edu>, Carlos Maiolino <cem@kernel.org>, 
 David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
 Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
 linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793135381; l=5850;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=WffpsAXKwTQqf83nJP119j1Jd4hzsWKOXiJG8yAZsIk=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QDBOAB3vsD4IIEsENxm4Cbj+yNyi7T+iuxb5c/jdPaBOmChKrtvufcHhVBDJ9B8FjWGLvLR0Lgt
 DHwCl2GL0xAA=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

With lazytime the timestamps of the upper inode stay in memory.  A pass of
the flusher writes the data and leaves them alone, for up to 12 hours, so
the overlay inode can't be clean after it: a syncfs() which only looks at
dirty overlay inodes would miss the timestamps.

Keeping it dirty for that long isn't an option either.  The flusher would
walk it every time, and a dirty inode can't be reclaimed.  The upper inode
doesn't have that problem.  It sits on a list of its own, and its
timestamps are written when its last reference goes away, which is what
happens under memory pressure.  But the overlay inode holds a reference to
it.

Do the same one level up.  When the timestamps are all that is left, give
the overlay inode I_DIRTY_TIME.  That takes it off the list which the
flusher walks, while syncfs() still gets to it.  Implement
->sync_lazytime() to pass on to the upper inode what the VFS tells the
overlay inode: on syncfs() and fsync(), when the 12 hours are over, and
when the last reference to the overlay inode goes away.

A change through the overlay to an inode which is parked like this also
writes the timestamps, because marking it dirty ends in ->sync_lazytime().

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/overlayfs/dir.c       |  1 +
 fs/overlayfs/inode.c     | 17 +++++++++++++++++
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/super.c     | 24 ++++++++++++++++++++++++
 4 files changed, 43 insertions(+)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 1194ccf981c3..fc47beffa67e 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -1489,6 +1489,7 @@ const struct inode_operations ovl_dir_inode_operations = {
 	.get_acl	= ovl_get_acl,
 	.set_acl	= ovl_set_acl,
 	.update_time	= ovl_update_time,
+	.sync_lazytime	= ovl_sync_lazytime,
 	.fileattr_get	= ovl_fileattr_get,
 	.fileattr_set	= ovl_fileattr_set,
 	.tmpfile	= ovl_tmpfile,
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 9a4bf7c2502b..858802969017 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -743,6 +743,20 @@ int ovl_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
 	return err;
 }
 
+/*
+ * The overlay inode has I_DIRTY_TIME because the upper inode has, see
+ * ovl_park_inode().  Pass it on, and keep track of the upper inode until that
+ * has been written.
+ */
+void ovl_sync_lazytime(struct inode *inode)
+{
+	struct inode *upper = ovl_inode_upper(inode);
+
+	if (upper && (inode_state_read_once(upper) & I_DIRTY_TIME))
+		mark_inode_dirty_sync(upper);
+	ovl_mark_inode_dirty(inode);
+}
+
 static const struct inode_operations ovl_file_inode_operations = {
 	.setattr	= ovl_setattr,
 	.permission	= ovl_permission,
@@ -752,6 +766,7 @@ static const struct inode_operations ovl_file_inode_operations = {
 	.get_acl	= ovl_get_acl,
 	.set_acl	= ovl_set_acl,
 	.update_time	= ovl_update_time,
+	.sync_lazytime	= ovl_sync_lazytime,
 	.fiemap		= ovl_fiemap,
 	.fileattr_get	= ovl_fileattr_get,
 	.fileattr_set	= ovl_fileattr_set,
@@ -763,6 +778,7 @@ static const struct inode_operations ovl_symlink_inode_operations = {
 	.getattr	= ovl_getattr,
 	.listxattr	= ovl_listxattr,
 	.update_time	= ovl_update_time,
+	.sync_lazytime	= ovl_sync_lazytime,
 };
 
 static const struct inode_operations ovl_special_inode_operations = {
@@ -774,6 +790,7 @@ static const struct inode_operations ovl_special_inode_operations = {
 	.get_acl	= ovl_get_acl,
 	.set_acl	= ovl_set_acl,
 	.update_time	= ovl_update_time,
+	.sync_lazytime	= ovl_sync_lazytime,
 };
 
 static const struct address_space_operations ovl_aops = {
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index f5a17bc258b6..ad1084be6191 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -867,6 +867,7 @@ static inline struct posix_acl *ovl_get_acl_path(const struct path *path,
 
 int ovl_update_time(struct inode *inode, enum fs_update_time type,
 		unsigned int flags);
+void ovl_sync_lazytime(struct inode *inode);
 bool ovl_is_private_xattr(struct super_block *sb, const char *name);
 
 struct ovl_inode_params {
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 954648d41700..631f68a97980 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -344,6 +344,28 @@ static bool ovl_upper_unfinished(struct inode *upper)
 	       (inode_state_read_once(upper) & I_SYNC);
 }
 
+/*
+ * All that is left of @inode are timestamps which lazytime holds back on the
+ * upper filesystem.  A pass which does not wait leaves them alone, for up to 12
+ * hours.  Do to the overlay inode what was done to the upper inode: with
+ * I_DIRTY_TIME it is off the list which the flusher walks, syncfs() still gets
+ * to it, and ovl_sync_lazytime() is told when the time has come.
+ *
+ * One such time is when the last reference goes away, which it never does for
+ * the upper inode as long as the overlay inode is there.  It may have gone away
+ * already.  iput() looks for I_DIRTY_TIME under i_lock before it drops the last
+ * reference, so either it sees the flag or the count is zero here.
+ */
+static void ovl_park_inode(struct inode *inode)
+{
+	if (!ovl_tracks_dirty(OVL_FS(inode->i_sb)))
+		return;
+
+	__mark_inode_dirty(inode, I_DIRTY_TIME);
+	if (!icount_read_once(inode))
+		mark_inode_dirty_sync(inode);
+}
+
 static int ovl_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	struct inode *upper = ovl_inode_upper(inode);
@@ -360,6 +382,8 @@ static int ovl_write_inode(struct inode *inode, struct writeback_control *wbc)
 
 	if (ovl_upper_unfinished(upper))
 		ovl_mark_inode_dirty(inode);
+	else if (inode_state_read_once(upper) & I_DIRTY_TIME)
+		ovl_park_inode(inode);
 
 	return ret;
 }

-- 
2.55.0

