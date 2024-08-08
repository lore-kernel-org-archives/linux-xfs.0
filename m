Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB05A15A848
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 19:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723145305; cv=none; b=RVyaC1NtRzODh712moRe3wy93Qh2OrT6HwWPfRK5x9D/JbesIhwdMo/IBAbte2irC+or/dsLFOOSkgr2BJJ1V/LMnTUq+R2EcqszwttroumffbBB5pa8V7M2l9nnwYVwfE9ymIzHN6Kk5UKRcJz8w+jX3a0NTOBOCkU2VJwgBmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723145305; c=relaxed/simple;
	bh=zFcM2soOTMk6hOg67wC1ZTXuQ05EaZXZUYhL4yxgprU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iDrCB0BskSYB7wDwryheQR5AFfuY6eU5vnSBRdunWWUQXRVOkjRkieGAD3zt2TOnMSAavsNkSNJ9dJ3ZYYRPo6jadouQstBe7Ecab0NCl31lu8/VyKHltCABeYGETrrIFDXf6lE0a/vxttOBY0L3xo7mGCJBLhGwkOllIJyM4mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=1zuBMGyG; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="1zuBMGyG"
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-e0885b4f1d5so1234663276.1
        for <linux-xfs@vger.kernel.org>; Thu, 08 Aug 2024 12:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723145303; x=1723750103; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WIzimyxswBclQJjUxcfERSoum/Rvft2jVU7lz6kF1FQ=;
        b=1zuBMGyGfIABkUSBaTnSPuaCYotL+ClPGy+gh0rZb+ba/TnYUNJ3/leSd08rSB5l4q
         7QIJ0XowP0GKcOT28pMguxm1lpdkjnB/0vURHwuk4nbd3R85tbuDJaNKH0mqt/7WGZbz
         eo3S8enDy/aW/h8B1guKAFXuZbUG1WFY2VDxfz4uAEWYWT8bmkq9B+t7YXeQuSBC4dsn
         +GVjkGzRikvfAhhYyWuhhsRfEy68s+nA4AUqAsDhrxlCVuJgwxG3qdBLKbRNIQTJK9sO
         TrBjCDwmEn6mpoxEKlfYn0oZ3a9Whvfm01ykQ5d0uZbYIqFQsH72+VAbIqp/CKODXYaX
         Z0XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723145303; x=1723750103;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WIzimyxswBclQJjUxcfERSoum/Rvft2jVU7lz6kF1FQ=;
        b=T0VMAHo+fELcYMZ3Zyf04AJNZtepuQNHhZ82gT8d+qcH0v9jWeU0qVj01JrU06h3mQ
         LLw40LwRLQyF0JTPuSDKiLsLB1Skkf+q5S6034xVe/kS2mKPgEQNz7OwA+XLr9WteBFt
         cYydrnVVJXNa5PNfN3SZ0DFf/gXbb7eYAxYjjtWUJ5OaavOm4CDqf185PCXN4lQS87KM
         44m/d0eZrtbhPLtzuqQNYic7yJmwg/LSiG5Uud9p65cxjLrd9Lv1V7iOtMHPVNjjbpQP
         Ww4b1ORJt8e2srBmclWVN9XhH6LgJpm10kGFZfgUc7xd27RaJ+06ZLQjvHz3iUXrudQI
         WJEQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0eVcIM/2Vq3AfkT8Cj8yqI2bSrABXPP68aHGKDDxdnMl4GRJTUtVsl3D0Xd030OjBZ+A39J0a+YULNrMBVinsnNZa8aIGv4ha
X-Gm-Message-State: AOJu0Yz/Ssvh7cKNwxqCvh1a+IQdO3RzwZsEaZXs4PD+lqydPUWQv2di
	S+GGPgmRQZ3/wzbGFVfdFUn19Ju7VgperZzDH+LrQ0T0nUcpVOK2yCP+71ObkHg=
X-Google-Smtp-Source: AGHT+IFN2uY+aatZYl9pzjPxRfjRO57s+88T7gzgtnSck91WLFz/T2NMwe1+6pQSCfmTodKYGud9Sg==
X-Received: by 2002:a05:6902:2085:b0:e0b:f6de:2ce2 with SMTP id 3f1490d57ef6-e0e9dae2c02mr3161822276.27.1723145302883;
        Thu, 08 Aug 2024 12:28:22 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a3785e27fasm188463385a.30.2024.08.08.12.28.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 12:28:22 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v2 04/16] fanotify: introduce FAN_PRE_ACCESS permission event
Date: Thu,  8 Aug 2024 15:27:06 -0400
Message-ID: <e8d1f99389aa81f0bfbfb082f9cbaa614e59f994.1723144881.git.josef@toxicpanda.com>
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

Similar to FAN_ACCESS_PERM permission event, but it is only allowed with
class FAN_CLASS_PRE_CONTENT and only allowed on regular files and dirs.

Unlike FAN_ACCESS_PERM, it is safe to write to the file being accessed
in the context of the event handler.

This pre-content event is meant to be used by hierarchical storage
managers that want to fill the content of files on first read access.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/notify/fanotify/fanotify.c      |  3 ++-
 fs/notify/fanotify/fanotify_user.c | 17 ++++++++++++++---
 include/linux/fanotify.h           | 14 ++++++++++----
 include/uapi/linux/fanotify.h      |  2 ++
 4 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 224bccaab4cc..7dac8e4486df 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -910,8 +910,9 @@ static int fanotify_handle_event(struct fsnotify_group *group, u32 mask,
 	BUILD_BUG_ON(FAN_OPEN_EXEC_PERM != FS_OPEN_EXEC_PERM);
 	BUILD_BUG_ON(FAN_FS_ERROR != FS_ERROR);
 	BUILD_BUG_ON(FAN_RENAME != FS_RENAME);
+	BUILD_BUG_ON(FAN_PRE_ACCESS != FS_PRE_ACCESS);
 
-	BUILD_BUG_ON(HWEIGHT32(ALL_FANOTIFY_EVENT_BITS) != 21);
+	BUILD_BUG_ON(HWEIGHT32(ALL_FANOTIFY_EVENT_BITS) != 22);
 
 	mask = fanotify_group_event_mask(group, iter_info, &match_mask,
 					 mask, data, data_type, dir);
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 2e2fba8a9d20..c294849e474f 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1628,6 +1628,7 @@ static int fanotify_events_supported(struct fsnotify_group *group,
 				     unsigned int flags)
 {
 	unsigned int mark_type = flags & FANOTIFY_MARK_TYPE_BITS;
+	bool is_dir = d_is_dir(path->dentry);
 	/* Strict validation of events in non-dir inode mask with v5.17+ APIs */
 	bool strict_dir_events = FAN_GROUP_FLAG(group, FAN_REPORT_TARGET_FID) ||
 				 (mask & FAN_RENAME) ||
@@ -1665,9 +1666,15 @@ static int fanotify_events_supported(struct fsnotify_group *group,
 	 * but because we always allowed it, error only when using new APIs.
 	 */
 	if (strict_dir_events && mark_type == FAN_MARK_INODE &&
-	    !d_is_dir(path->dentry) && (mask & FANOTIFY_DIRONLY_EVENT_BITS))
+	    !is_dir && (mask & FANOTIFY_DIRONLY_EVENT_BITS))
 		return -ENOTDIR;
 
+	/* Pre-content events are only supported on regular files and dirs */
+	if (mask & FANOTIFY_PRE_CONTENT_EVENTS) {
+		if (!is_dir && !d_is_reg(path->dentry))
+			return -EINVAL;
+	}
+
 	return 0;
 }
 
@@ -1769,11 +1776,15 @@ static int do_fanotify_mark(int fanotify_fd, unsigned int flags, __u64 mask,
 		goto fput_and_out;
 
 	/*
-	 * Permission events require minimum priority FAN_CLASS_CONTENT.
+	 * Permission events are not allowed for FAN_CLASS_NOTIF.
+	 * Pre-content permission events are not allowed for FAN_CLASS_CONTENT.
 	 */
 	ret = -EINVAL;
 	if (mask & FANOTIFY_PERM_EVENTS &&
-	    group->priority < FSNOTIFY_PRIO_CONTENT)
+	    group->priority == FSNOTIFY_PRIO_NORMAL)
+		goto fput_and_out;
+	else if (mask & FANOTIFY_PRE_CONTENT_EVENTS &&
+		 group->priority == FSNOTIFY_PRIO_CONTENT)
 		goto fput_and_out;
 
 	if (mask & FAN_FS_ERROR &&
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 4f1c4f603118..5c811baf44d2 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -88,6 +88,16 @@
 #define FANOTIFY_DIRENT_EVENTS	(FAN_MOVE | FAN_CREATE | FAN_DELETE | \
 				 FAN_RENAME)
 
+/* Content events can be used to inspect file content */
+#define FANOTIFY_CONTENT_PERM_EVENTS (FAN_OPEN_PERM | FAN_OPEN_EXEC_PERM | \
+				      FAN_ACCESS_PERM)
+/* Pre-content events can be used to fill file content */
+#define FANOTIFY_PRE_CONTENT_EVENTS  (FAN_PRE_ACCESS)
+
+/* Events that require a permission response from user */
+#define FANOTIFY_PERM_EVENTS	(FANOTIFY_CONTENT_PERM_EVENTS | \
+				 FANOTIFY_PRE_CONTENT_EVENTS)
+
 /* Events that can be reported with event->fd */
 #define FANOTIFY_FD_EVENTS (FANOTIFY_PATH_EVENTS | FANOTIFY_PERM_EVENTS)
 
@@ -103,10 +113,6 @@
 				 FANOTIFY_INODE_EVENTS | \
 				 FANOTIFY_ERROR_EVENTS)
 
-/* Events that require a permission response from user */
-#define FANOTIFY_PERM_EVENTS	(FAN_OPEN_PERM | FAN_ACCESS_PERM | \
-				 FAN_OPEN_EXEC_PERM)
-
 /* Extra flags that may be reported with event or control handling of events */
 #define FANOTIFY_EVENT_FLAGS	(FAN_EVENT_ON_CHILD | FAN_ONDIR)
 
diff --git a/include/uapi/linux/fanotify.h b/include/uapi/linux/fanotify.h
index a37de58ca571..bcada21a3a2e 100644
--- a/include/uapi/linux/fanotify.h
+++ b/include/uapi/linux/fanotify.h
@@ -26,6 +26,8 @@
 #define FAN_ACCESS_PERM		0x00020000	/* File accessed in perm check */
 #define FAN_OPEN_EXEC_PERM	0x00040000	/* File open/exec in perm check */
 
+#define FAN_PRE_ACCESS		0x00080000	/* Pre-content access hook */
+
 #define FAN_EVENT_ON_CHILD	0x08000000	/* Interested in child events */
 
 #define FAN_RENAME		0x10000000	/* File was renamed */
-- 
2.43.0

