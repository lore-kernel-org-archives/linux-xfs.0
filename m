Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D9B15A873
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 19:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723145306; cv=none; b=WTiX73YXofXwKbIXR0OHWFA1xUl7k9d4KvBkhR0U+R0SrHzNLtO4XUSMElZFb3oPEu+ZfyNJx7d4JIi2q/DSbHv/Fj7ZsgwFTLYMXqcMiY04n921svU4BjVioKhZgfSwHxr8tZvYzyy5y0AXhxvpcXuUwJ4y/+W2TMzR8FD7w84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723145306; c=relaxed/simple;
	bh=iunaa8k8tOjCE0fjxciqNBkoFDQCNOOCmaZxaYuGWPk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=URC8lQiG23otQcIRk2D4XwlyLcxbzko6Y3VWIYaCXmOIpiyY+VXEq67UshRGdhaSrahB2uELWjnKf+Rg61j0njAPh5JJEKGRkVG+CcKzAy4H8QOjjWQwAj3hG8xZ1+rrkc3ogoKwEGhvYMjgnnAfJC0PtuUvsHXaOCN0ilbRz6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=202xW/HY; arc=none smtp.client-ip=209.85.222.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="202xW/HY"
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-826fee202d3so499734241.1
        for <linux-xfs@vger.kernel.org>; Thu, 08 Aug 2024 12:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723145304; x=1723750104; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sw6Pmt3QfBKQRU9ccrV2L9s4E/3XEH78F2jlIvWLGp4=;
        b=202xW/HYgel/bPyV7njYVtSLFibzSq4whf28Yefobx9bry8t4ALHMgF05YIZt3zApu
         3zZOetbE8ymSX2IrjGebHOSJacU3U+XSKOchxZ7Tjc3ntWuDr69+Z/yuWY1smFZfULZ4
         GIcU2Of3uBsrKH1XrBz6L9FGTylUeRHQJLEUTthNUvAn/mpTp+zTT62zp8Z2DlV8RATM
         C9XOs9foF7tEhbSOGZ9BD2EDS6C2ayxdj55eAmfVHawWp90iKQN8tn5bDuI///N/ks1P
         uR3jyoDd+KbMmfoGX6xed6EmyavKNxvJ249ywfLfCWWeRy106cZjqJhjsJdggkWUc1JC
         EkHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723145304; x=1723750104;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sw6Pmt3QfBKQRU9ccrV2L9s4E/3XEH78F2jlIvWLGp4=;
        b=tC4bIWpOP9E55+Etq+8PO6PkupTYCu7NxqkF7CgBiiauxIOFMiv1hwXGAAphFBEOyf
         Dxjw0xBJL2wveqsDz6YH3CXE1+AzLzIDDBSzL+3pvFWKss7SKz8ct19px9k4rDnDKvMW
         tAu54yE8TsCsbaCbzujpl2aB/xCjCAhlZdO6bllxGKsAlQYH/udQaxbnaTGlFAmRYbbK
         YaFV46C4iKcHYbWNct7NniHfwk8K8vbLupLU8VeOubtEcmUIbkSKBlwbU6ttMWtkDOW3
         eVGgsybQuKhJTuXiPUQOWiKcoGYL1mp5UzRj01eu36DR7zgihmgPU5NAuFNqqJsso4cQ
         xVYw==
X-Forwarded-Encrypted: i=1; AJvYcCV2yyg0i0/ZTMF5Ug/F22J4rrDJQk9kkvaV/wNY8M6Evbj9kJJM7MCNN66lkFVeny6ghJGemEYlb8nxjXK5qLg3KRmEbQmEZflb
X-Gm-Message-State: AOJu0YwFNxTddbMwV386+pdWT0GEPCj7JN24mxqUfYuPGPttNP6KovhF
	CHIjiqzkVzNBRQJqW77p7LTOQff90kYJ3wBTXYcc6dw59z7A/ih9lJJLWbAPryY=
X-Google-Smtp-Source: AGHT+IFTIoze4bXD1QlmBwlkzkFqqrnl/wiGJPb337BvGqoyHHOZ144D1AqNG7b2IMKB7qka0a1Izw==
X-Received: by 2002:a05:6102:e0b:b0:493:e587:3251 with SMTP id ada2fe7eead31-495c5bd0636mr3571031137.20.1723145304111;
        Thu, 08 Aug 2024 12:28:24 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bb9c83cbf0sm69344576d6.83.2024.08.08.12.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 12:28:23 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v2 05/16] fanotify: introduce FAN_PRE_MODIFY permission event
Date: Thu,  8 Aug 2024 15:27:07 -0400
Message-ID: <fc0035bf78ca47e813f1fb603163af0225c491c7.1723144881.git.josef@toxicpanda.com>
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

Generate FAN_PRE_MODIFY permission event from fsnotify_file_perm()
pre-write hook to notify fanotify listeners on an intent to make
modification to a file.

Like FAN_PRE_ACCESS, it is only allowed with FAN_CLASS_PRE_CONTENT
and unlike FAN_MODIFY, it is only allowed on regular files.

Like FAN_PRE_ACCESS, it is generated without sb_start_write() held,
so it is safe to perform filesystem modifications in the context of
event handler.

This pre-content event is meant to be used by hierarchical storage
managers that want to fill the content of files on first write access.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/notify/fanotify/fanotify.c      | 3 ++-
 fs/notify/fanotify/fanotify_user.c | 2 ++
 include/linux/fanotify.h           | 3 ++-
 include/uapi/linux/fanotify.h      | 1 +
 4 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 7dac8e4486df..b163594843f5 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -911,8 +911,9 @@ static int fanotify_handle_event(struct fsnotify_group *group, u32 mask,
 	BUILD_BUG_ON(FAN_FS_ERROR != FS_ERROR);
 	BUILD_BUG_ON(FAN_RENAME != FS_RENAME);
 	BUILD_BUG_ON(FAN_PRE_ACCESS != FS_PRE_ACCESS);
+	BUILD_BUG_ON(FAN_PRE_MODIFY != FS_PRE_MODIFY);
 
-	BUILD_BUG_ON(HWEIGHT32(ALL_FANOTIFY_EVENT_BITS) != 22);
+	BUILD_BUG_ON(HWEIGHT32(ALL_FANOTIFY_EVENT_BITS) != 23);
 
 	mask = fanotify_group_event_mask(group, iter_info, &match_mask,
 					 mask, data, data_type, dir);
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index c294849e474f..3a7101544f30 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1673,6 +1673,8 @@ static int fanotify_events_supported(struct fsnotify_group *group,
 	if (mask & FANOTIFY_PRE_CONTENT_EVENTS) {
 		if (!is_dir && !d_is_reg(path->dentry))
 			return -EINVAL;
+		if (is_dir && mask & FAN_PRE_MODIFY)
+			return -EISDIR;
 	}
 
 	return 0;
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 5c811baf44d2..ae6cb2688d52 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -92,7 +92,8 @@
 #define FANOTIFY_CONTENT_PERM_EVENTS (FAN_OPEN_PERM | FAN_OPEN_EXEC_PERM | \
 				      FAN_ACCESS_PERM)
 /* Pre-content events can be used to fill file content */
-#define FANOTIFY_PRE_CONTENT_EVENTS  (FAN_PRE_ACCESS)
+#define FANOTIFY_PRE_CONTENT_EVENTS  (FAN_PRE_ACCESS | FAN_PRE_MODIFY)
+#define FANOTIFY_PRE_MODIFY_EVENTS   (FAN_PRE_MODIFY)
 
 /* Events that require a permission response from user */
 #define FANOTIFY_PERM_EVENTS	(FANOTIFY_CONTENT_PERM_EVENTS | \
diff --git a/include/uapi/linux/fanotify.h b/include/uapi/linux/fanotify.h
index bcada21a3a2e..ac00fad66416 100644
--- a/include/uapi/linux/fanotify.h
+++ b/include/uapi/linux/fanotify.h
@@ -27,6 +27,7 @@
 #define FAN_OPEN_EXEC_PERM	0x00040000	/* File open/exec in perm check */
 
 #define FAN_PRE_ACCESS		0x00080000	/* Pre-content access hook */
+#define FAN_PRE_MODIFY		0x00100000	/* Pre-content modify hook */
 
 #define FAN_EVENT_ON_CHILD	0x08000000	/* Interested in child events */
 
-- 
2.43.0

