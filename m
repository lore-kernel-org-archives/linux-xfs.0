Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C8A1553A1
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 19:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723145303; cv=none; b=Ky6VeYzwE0uA44zNnSeI/Rjxm3k7WiT68vmPzTfSLo+Xrpw4dQGi5i+WqrFuVV7HT+Dq0rjKPkpx1jM8Wrb6RWL7pDrr3TrV/kP0lHxtqWqlItFzHXQNuzZlW814m7Qas/oon//YYo4vtdjggppFizO0nPSjt4GGVgxjud4m4KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723145303; c=relaxed/simple;
	bh=AjMEINZmgDlFiuIMbDg0DxklpTafNFhb5Kj9+SN+Xhg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nb1+zZU1os5jBbAdynpPQ5CZ6YyQJsHMCwRvu0kG5hKhkz5lbKppdzNG/astdLkhjD+H0Suv+1pbjqaG3XUS7j0VpOzt9/9tagc+Pkiuy9SZjSERMG5M0JBd8zX1AuRSaG5+8JZdUJ+V4iMcapuO5cKJ9dRPo/QwpjCZ7U1uQc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=VmZuSm0W; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="VmZuSm0W"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-70930f8eabbso455656a34.1
        for <linux-xfs@vger.kernel.org>; Thu, 08 Aug 2024 12:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723145300; x=1723750100; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RfzczfZaBcEy/mBP9fMeuoTBUjG4OtJdJggqfPPwrUM=;
        b=VmZuSm0WsRD7m1XbH8Hsgb+/+gcZ/7QMskVskALgsuwDe/4zz8M4OP1RPEeRDRNJ1h
         5vo+x6Bal8d8RDcS3A58ML6ZqZoJSrFsGennFj2GiqBglwZc4SazictEe1tHoeoP3oW3
         j0rcejq5unt2oHjIhjRryNc0bx6eV8AjmJZ1uryJhiIF8aY/OHItRl9er3RAj+8zCX+j
         jAFa0dav9KlLhcDqEds30LorzVaw9KOMsT8zPa07Br9M69qYfgl1zYjJZGZAQheORnkK
         xHo+mceRW2SCaRbDVl4hGT22bTyDx/f/zPsB1UoROrI52gg5sst6C0Y4h5/1l0xYoij2
         n2cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723145300; x=1723750100;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RfzczfZaBcEy/mBP9fMeuoTBUjG4OtJdJggqfPPwrUM=;
        b=b0+ls6bwciDkwSflJJlNLebIE0ExLVfXjQhLmepnQBJzjdRy9h+lXPzXGJIfKLcZtp
         JNVfUC1vdvbBCJYqiFh1WjJKNPI42I+xIQwIuWG6/fzzQ1N0OU6Oc2NAZvd1khbqqCw+
         +yx+0W0T2NS9/JmsXa+DduMT/rwimJbNto2RUWTQ6Lji1yG0S3WMH9s0SQoKFg74jBdT
         4GGysCJdSmuvbyxtbtxxYgtfqNHNf1dEXGMID+KaXri3vLPPMG3+Mw+U6FPwNGb1YPTi
         X5u28RPM7iy9ozPpyvuwducEc3xqrn2zRPcpoACRBR7223HEcbS7Sn9ykUPMyUfzXy2n
         ZX1A==
X-Forwarded-Encrypted: i=1; AJvYcCV/ACMTR9KekJndBDdrwNOUIiN9fmdxD5dHViWl68ZmQ7mLCjBc70Zdu21PCzxEVKTqPpdNhBjsPN9M63kBbu1eTSrfu2qzSX0P
X-Gm-Message-State: AOJu0YyDINnMK5P+SNMNJdsMA810t4IvaEtaCoass/hxijcZ3HBQTiUX
	7YsfKazgAwKL+lsPDysgpq78D0VHtRIuaJBqwUR6nlizcX4ZY+0uT9OLEJxxjKs=
X-Google-Smtp-Source: AGHT+IFLYp5VTPJUoVcL4vvQ9CTbr2LLDuMn9IUx4rBw9P/IpMywByjToDcaLuZIzEi2P8UI2UosKA==
X-Received: by 2002:a05:6830:61cd:b0:703:5ba3:581b with SMTP id 46e09a7af769-70b4fc2f6bamr4011410a34.5.1723145300564;
        Thu, 08 Aug 2024 12:28:20 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-451c8717bbcsm15607261cf.35.2024.08.08.12.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 12:28:20 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v2 02/16] fsnotify: introduce pre-content permission event
Date: Thu,  8 Aug 2024 15:27:04 -0400
Message-ID: <83e50a373eb541de178bfbbc518a4be2bacb2372.1723144881.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1723144881.git.josef@toxicpanda.com>
References: <cover.1723144881.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Amir Goldstein <amir73il@gmail.com>

The new FS_PRE_ACCESS permission event is similar to FS_ACCESS_PERM,
but it meant for a different use case of filling file content before
access to a file range, so it has slightly different semantics.

Generate FS_PRE_ACCESS/FS_ACCESS_PERM as two seperate events, same as
we did for FS_OPEN_PERM/FS_OPEN_EXEC_PERM.

FS_PRE_MODIFY is a new permission event, with similar semantics as
FS_PRE_ACCESS, which is called before a file is modified.

FS_ACCESS_PERM is reported also on blockdev and pipes, but the new
pre-content events are only reported for regular files and dirs.

The pre-content events are meant to be used by hierarchical storage
managers that want to fill the content of files on first access.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/notify/fsnotify.c             |  2 +-
 include/linux/fsnotify.h         | 27 ++++++++++++++++++++++++---
 include/linux/fsnotify_backend.h | 13 +++++++++++--
 security/selinux/hooks.c         |  3 ++-
 4 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 272c8a1dab3c..1ca4a8da7f29 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -621,7 +621,7 @@ static __init int fsnotify_init(void)
 {
 	int ret;
 
-	BUILD_BUG_ON(HWEIGHT32(ALL_FSNOTIFY_BITS) != 23);
+	BUILD_BUG_ON(HWEIGHT32(ALL_FSNOTIFY_BITS) != 25);
 
 	ret = init_srcu_struct(&fsnotify_mark_srcu);
 	if (ret)
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 278620e063ab..028ce807805a 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -133,12 +133,13 @@ static inline int fsnotify_file(struct file *file, __u32 mask)
 
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
 /*
- * fsnotify_file_area_perm - permission hook before access to file range
+ * fsnotify_file_area_perm - permission hook before access/modify of file range
  */
 static inline int fsnotify_file_area_perm(struct file *file, int perm_mask,
 					  const loff_t *ppos, size_t count)
 {
-	__u32 fsnotify_mask = FS_ACCESS_PERM;
+	struct inode *inode = file_inode(file);
+	__u32 fsnotify_mask;
 
 	/*
 	 * filesystem may be modified in the context of permission events
@@ -147,7 +148,27 @@ static inline int fsnotify_file_area_perm(struct file *file, int perm_mask,
 	 */
 	lockdep_assert_once(file_write_not_started(file));
 
-	if (!(perm_mask & MAY_READ))
+	/*
+	 * Generate FS_PRE_ACCESS/FS_ACCESS_PERM as two seperate events.
+	 */
+	if (perm_mask & MAY_READ) {
+		int ret = fsnotify_file(file, FS_ACCESS_PERM);
+
+		if (ret)
+			return ret;
+	}
+
+	/*
+	 * Pre-content events are only reported for regular files and dirs.
+	 */
+	if (!S_ISDIR(inode->i_mode) && !S_ISREG(inode->i_mode))
+		return 0;
+
+	if (perm_mask & MAY_WRITE)
+		fsnotify_mask = FS_PRE_MODIFY;
+	else if (perm_mask & MAY_READ)
+		fsnotify_mask = FS_PRE_ACCESS;
+	else
 		return 0;
 
 	return fsnotify_file(file, fsnotify_mask);
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 8be029bc50b1..200a5e3b1cd4 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -56,6 +56,9 @@
 #define FS_ACCESS_PERM		0x00020000	/* access event in a permissions hook */
 #define FS_OPEN_EXEC_PERM	0x00040000	/* open/exec event in a permission hook */
 
+#define FS_PRE_ACCESS		0x00080000	/* Pre-content access hook */
+#define FS_PRE_MODIFY		0x00100000	/* Pre-content modify hook */
+
 /*
  * Set on inode mark that cares about things that happen to its children.
  * Always set for dnotify and inotify.
@@ -77,8 +80,14 @@
  */
 #define ALL_FSNOTIFY_DIRENT_EVENTS (FS_CREATE | FS_DELETE | FS_MOVE | FS_RENAME)
 
-#define ALL_FSNOTIFY_PERM_EVENTS (FS_OPEN_PERM | FS_ACCESS_PERM | \
-				  FS_OPEN_EXEC_PERM)
+/* Content events can be used to inspect file content */
+#define FSNOTIFY_CONTENT_PERM_EVENTS (FS_OPEN_PERM | FS_OPEN_EXEC_PERM | \
+				      FS_ACCESS_PERM)
+/* Pre-content events can be used to fill file content */
+#define FSNOTIFY_PRE_CONTENT_EVENTS  (FS_PRE_ACCESS | FS_PRE_MODIFY)
+
+#define ALL_FSNOTIFY_PERM_EVENTS (FSNOTIFY_CONTENT_PERM_EVENTS | \
+				  FSNOTIFY_PRE_CONTENT_EVENTS)
 
 /*
  * This is a list of all events that may get sent to a parent that is watching
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 55c78c318ccd..2997edf3e7cd 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3406,7 +3406,8 @@ static int selinux_path_notify(const struct path *path, u64 mask,
 		perm |= FILE__WATCH_WITH_PERM;
 
 	/* watches on read-like events need the file:watch_reads permission */
-	if (mask & (FS_ACCESS | FS_ACCESS_PERM | FS_CLOSE_NOWRITE))
+	if (mask & (FS_ACCESS | FS_ACCESS_PERM | FS_PRE_ACCESS |
+		    FS_CLOSE_NOWRITE))
 		perm |= FILE__WATCH_READS;
 
 	return path_has_perm(current_cred(), path, perm);
-- 
2.43.0

