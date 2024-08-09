Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB60D15DBA3
	for <linux-xfs@vger.kernel.org>; Fri,  9 Aug 2024 18:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723229108; cv=none; b=hCq/00ycd6Pd/MBU/dUWxjjXYoYEzHqb7Lp/UoTTR9i+GCU81HL7Q//1T8kuipwEpiXskBSklph1yo4VS2lpl8OlbrqJtTP54J3Ta1iYuwSv6lmSV/Bh/P1xVk5vzmHrJJRJBdJwVvpB74qnus3X1FcDFhDDDYEcWLmAOEOSKAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723229108; c=relaxed/simple;
	bh=oIFEloV+HJRwW7KKzTETqcSZwuMF6cvmESmc2+RUi2s=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d+dpcAR1+yqHHHL5ALGWamdpd7jljKsRp4Il5RFW0bHN0he7yvxAvE7A60gM3S4Fkv/ZnicnpfJjXETxiBJBjVXtnkwwJW/2wIMa79he7etI3WTlL3ZRoyjxEu3wbIBFAEqvwvibQ/ONB6fNj83l/NPD5S7TVnFdVRWSU97WFuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=xm/6tQQB; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="xm/6tQQB"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-44ff132ff9cso13123631cf.2
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2024 11:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723229106; x=1723833906; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iqckBRUWRZ8lY2PUqxw8YY3RQIFbRSWL2L9gDiXv76o=;
        b=xm/6tQQBIT7RBpUWaHrfqoHM/7bRessu3XhKS4Gs9vCa8bGxsi2B3vis17/JVdcVsR
         bwEBN+VQc3Yy1tQzawKNVf6zDBz9rQNA0U3xAjpeonY3HITtMWW1biBD1+VKtjnv4cX/
         v3MN4E0K+jE/gb9w4ql4+5MkA3KCggVMlsXDskPpneHCLNoHvk3qU4SKDIr69hOOmx6B
         lsQhJL7olhRQkld8kpq5vW875CIAvEYynX/C1wc0xNYchTQpDzJ/uVZZ4Ch7V9oYlVmx
         9JTmvtFgeUTxkOWg6Xj3UN2Nz10XxPSVqjh1gXeDT+bZzxm5Jj4hVwwh76hBoNyyJ7/m
         7upw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723229106; x=1723833906;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iqckBRUWRZ8lY2PUqxw8YY3RQIFbRSWL2L9gDiXv76o=;
        b=W02iQu4zTu2dFjyED3Lbmisa3qcl3yOthNlkPQxPjNN6E/vS4ihiM9tYLdW6Q7P2bX
         E7hWDb4IM+zcNg/RUofS2sjIua+tTMRM9I/xjk5tbTHb7f3EqCG9oNqx3mO9ln1O8Jbn
         HCa7mvSNqkuU6qpcfdBCp7DVgBq33I+9Cym1G1JvqRqplW9PwuQ216q6tCs0JabBWtOn
         bFyP9jgGc5LKyJNNcA9Oau6Koa6g1TRg7+8tVycQE1WmsgKoBuw4YGWqunInYiVeVCf8
         jsTsMms2xmfm9KU1o8epMBxM9K94rBJdmy5Bj6af3aAHal+u1WBw6QZbxPAa3nfyOVUC
         ohqA==
X-Forwarded-Encrypted: i=1; AJvYcCXst4vD4K1ACj+p/qk6F2erH/keBLsbfvBn/jAFyzy4lOYJj7dcK+IoxPhlYWLFZLr3AnybxWMvmgz3uWdIqMi7GgIlGAZnKQZK
X-Gm-Message-State: AOJu0YxenMdm82MoETzM7B33VgvpMlsDZaOjtw4hU8U4DegNusCSEAsn
	BL+gxOn1jKbzoaBEUGfL4UxzvM364RVLMudpJmt1VW7TLp2IqXcAbayoa2/xrio=
X-Google-Smtp-Source: AGHT+IG5zQtNW/XpS3+QxRnw3j+AIzLNhodsoGZgh92MwyUW6bcO/0L9pxWR7KNpZnt4tIKD1u7yZg==
X-Received: by 2002:a05:622a:4084:b0:447:f7cf:7022 with SMTP id d75a77b69052e-453126ae6c5mr26804151cf.40.1723229105766;
        Fri, 09 Aug 2024 11:45:05 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4531c1c3da4sm410271cf.29.2024.08.09.11.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 11:45:05 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 10/16] fanotify: add a helper to check for pre content events
Date: Fri,  9 Aug 2024 14:44:18 -0400
Message-ID: <b02993d0e384326194023c76e437c0ea838a5c06.1723228772.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1723228772.git.josef@toxicpanda.com>
References: <cover.1723228772.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We want to emit events during page fault, and calling into fanotify
could be expensive, so add a helper to allow us to skip calling into
fanotify from page fault.  This will also be used to disable readahead
for content watched files which will be handled in a subsequent patch.

Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/notify/fsnotify.c             | 12 ++++++++++++
 include/linux/fsnotify_backend.h | 14 ++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 1ca4a8da7f29..cbfaa000f815 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -201,6 +201,18 @@ static inline bool fsnotify_object_watched(struct inode *inode, __u32 mnt_mask,
 	return mask & marks_mask & ALL_FSNOTIFY_EVENTS;
 }
 
+#ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
+bool fsnotify_file_has_pre_content_watches(struct file *file)
+{
+	struct inode *inode = file_inode(file);
+	__u32 mnt_mask = real_mount(file->f_path.mnt)->mnt_fsnotify_mask;
+
+	return fsnotify_object_watched(inode, mnt_mask,
+				       FSNOTIFY_PRE_CONTENT_EVENTS);
+}
+#endif
+
+
 /*
  * Notify this dentry's parent about a child's events with child name info
  * if parent is watching or if inode/sb/mount are interested in events with
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 276320846bfd..b495a0676dd3 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -900,6 +900,15 @@ static inline void fsnotify_init_event(struct fsnotify_event *event)
 	INIT_LIST_HEAD(&event->list);
 }
 
+#ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
+bool fsnotify_file_has_pre_content_watches(struct file *file);
+#else
+static inline bool fsnotify_file_has_pre_content_watches(struct file *file)
+{
+	return false;
+}
+#endif /* CONFIG_FANOTIFY_ACCESS_PERMISSIONS */
+
 #else
 
 static inline int fsnotify(__u32 mask, const void *data, int data_type,
@@ -938,6 +947,11 @@ static inline u32 fsnotify_get_cookie(void)
 static inline void fsnotify_unmount_inodes(struct super_block *sb)
 {}
 
+static inline bool fsnotify_file_has_pre_content_watches(struct file *file)
+{
+	return false;
+}
+
 #endif	/* CONFIG_FSNOTIFY */
 
 #endif	/* __KERNEL __ */
-- 
2.43.0

