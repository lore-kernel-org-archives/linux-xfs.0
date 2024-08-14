Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A3C1C9DDE
	for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 21:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723670773; cv=none; b=mq+Hcyklh941+LDWGN2Ml10Z7nOzCBAZPA1S90xPeqhs3qvJPmaOO+IhFXUKPLcovf3VVIGOFK8KuLLaH29o96MfnaIupKlm+O3Lbf2Q1GzLmufZSLQs91muQRtmLsn4HVuQnR82iAyS+b6Wr7aXFYG3eWk0Jqxv5V+fmgEHqX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723670773; c=relaxed/simple;
	bh=EUC6xHSolCsXCfEGgJe/uC9iBPwO+UdprLu222bnv+E=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uLfVlVNquRyo44puqVPWPJz8+6njdDi3PKZimxDqiD3HbNG59Q1b7G6Gk/wkIMUNllLYzWaWKKgGRNQAJ8Ah+/4HPfVsSyYKae1TiLfatOjbe/g97p0A1W9VAFB1AHu3eaJiyslPNTL2fAIEEM9O1E3OdwtxJJygc5LImnCMxb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=zYyn6SrU; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="zYyn6SrU"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-7a1dea79e1aso18241585a.1
        for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 14:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723670771; x=1724275571; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WSgX58UYc0emFHK3lK4cO5xgsT7V4KpoEDCer0WZNY4=;
        b=zYyn6SrUtko3MgjsBGZwDxVw95Pl/g7WW4OMaLO3HMwt53ipuH4DWP8HytLiEyQ/W/
         ob2DfYilrz+AU3v1dTR43VluuYyg3nogXd8qMBakzQl9JuZIFSlDQidAZJlhaKdhuUtf
         V9qHSHZDYs6a8jP96wHWxMclO015InqaK5CkfgnLeQS/y1lA08DULcEdgDOK5OimDRXw
         PDitTJo+MM02pYfn86XMMQCMYQB95Q8drLkWiUP4wkVSRXsZD82N11AOsqPpG1kibfgO
         dVLkeoygI8WM7EBjVOWuUPOKBttuSNBz3KISoo0Vk3uf/SCTsnVfTXKpaaeWkNtBgTfw
         +L7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723670771; x=1724275571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WSgX58UYc0emFHK3lK4cO5xgsT7V4KpoEDCer0WZNY4=;
        b=HcHW6eSBJGUzdnsnomrPyYIuvn5MZIdMIT33Qvny7LiSXpGPDEZjMP62e0SX2R9C8J
         LBGZH8Pr3Gcu/OFK62ado9DWztVdGoIt9c9qtDmvozGWzu9MO8N/MXLod9VlKMhU4C7L
         +jydJaiSujEDHzcgSJsWEAkmeC7FhzWMhGr0WpNs30qz/+e3JIvA/5lmRedcI5MSxj5D
         1ZXtr6+gBTwNwAYFhdX5j7ayys5xZuYWgFAwhmVADpBj1BE0l6Vs+kRetleGi5O7Jyqy
         q8SagynfBflACmHpoc2+ZKM9WMGqQUxUwdyr6ZE1FAbfX7oTrViKWFhZ6UU6UTvl4N0Q
         bGmQ==
X-Forwarded-Encrypted: i=1; AJvYcCXqOANS1DrhSj+IBbuf4uDqC2EbZQloZBNiybxAm4r13UHOHiHFQmTzW//VBhs1himXC42tmL3D4CyPy1WeUE6VX0Bmhg95krW6
X-Gm-Message-State: AOJu0YyEBuyNKEq0/6sRFhXOfOi9cDy7dZ3FNI5T3MDYMthG8D6ogoFz
	tQSoFBdEtW7dDIpc3+KAjiac4YdZT4F7/S7/aCjsGDkQSl2SefxjJV5A0o3MpSJKgmgGNvz3rKj
	m
X-Google-Smtp-Source: AGHT+IHzVqdx5PPzNWH057t0P/FT/P3ME1f3o5KEdS47TJSPsPt6bym6sXk9f4FG53pkQP7Q2xC5YA==
X-Received: by 2002:a05:620a:294d:b0:7a1:d6e4:d83a with SMTP id af79cd13be357-7a4ee3e82d9mr507957885a.69.1723670770577;
        Wed, 14 Aug 2024 14:26:10 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a4ff02f89bsm8812485a.23.2024.08.14.14.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 14:26:10 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v4 06/16] fanotify: pass optional file access range in pre-content event
Date: Wed, 14 Aug 2024 17:25:24 -0400
Message-ID: <87325af81514d7bd0b2236e14c613b7160651bda.1723670362.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1723670362.git.josef@toxicpanda.com>
References: <cover.1723670362.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Amir Goldstein <amir73il@gmail.com>

We would like to add file range information to pre-content events.

Pass a struct file_range with optional offset and length to event handler
along with pre-content permission event.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/notify/fanotify/fanotify.c    | 10 ++++++++--
 fs/notify/fanotify/fanotify.h    |  2 ++
 include/linux/fsnotify.h         | 17 ++++++++++++++++-
 include/linux/fsnotify_backend.h | 32 ++++++++++++++++++++++++++++++++
 4 files changed, 58 insertions(+), 3 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index b163594843f5..4e8dce39fa8f 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -549,9 +549,13 @@ static struct fanotify_event *fanotify_alloc_path_event(const struct path *path,
 	return &pevent->fae;
 }
 
-static struct fanotify_event *fanotify_alloc_perm_event(const struct path *path,
+static struct fanotify_event *fanotify_alloc_perm_event(const void *data,
+							int data_type,
 							gfp_t gfp)
 {
+	const struct path *path = fsnotify_data_path(data, data_type);
+	const struct file_range *range =
+			    fsnotify_data_file_range(data, data_type);
 	struct fanotify_perm_event *pevent;
 
 	pevent = kmem_cache_alloc(fanotify_perm_event_cachep, gfp);
@@ -565,6 +569,8 @@ static struct fanotify_event *fanotify_alloc_perm_event(const struct path *path,
 	pevent->hdr.len = 0;
 	pevent->state = FAN_EVENT_INIT;
 	pevent->path = *path;
+	pevent->ppos = range ? range->ppos : NULL;
+	pevent->count = range ? range->count : 0;
 	path_get(path);
 
 	return &pevent->fae;
@@ -802,7 +808,7 @@ static struct fanotify_event *fanotify_alloc_event(
 	old_memcg = set_active_memcg(group->memcg);
 
 	if (fanotify_is_perm_event(mask)) {
-		event = fanotify_alloc_perm_event(path, gfp);
+		event = fanotify_alloc_perm_event(data, data_type, gfp);
 	} else if (fanotify_is_error_event(mask)) {
 		event = fanotify_alloc_error_event(group, fsid, data,
 						   data_type, &hash);
diff --git a/fs/notify/fanotify/fanotify.h b/fs/notify/fanotify/fanotify.h
index e5ab33cae6a7..93598b7d5952 100644
--- a/fs/notify/fanotify/fanotify.h
+++ b/fs/notify/fanotify/fanotify.h
@@ -425,6 +425,8 @@ FANOTIFY_PE(struct fanotify_event *event)
 struct fanotify_perm_event {
 	struct fanotify_event fae;
 	struct path path;
+	const loff_t *ppos;		/* optional file range info */
+	size_t count;
 	u32 response;			/* userspace answer to the event */
 	unsigned short state;		/* state of the event */
 	int fd;		/* fd we passed to userspace for this event */
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index fb3837b8de4c..9d001d328619 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -132,6 +132,21 @@ static inline int fsnotify_file(struct file *file, __u32 mask)
 }
 
 #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
+static inline int fsnotify_file_range(struct file *file, __u32 mask,
+				      const loff_t *ppos, size_t count)
+{
+	struct file_range range;
+
+	if (file->f_mode & FMODE_NONOTIFY)
+		return 0;
+
+	range.path = &file->f_path;
+	range.ppos = ppos;
+	range.count = count;
+	return fsnotify_parent(range.path->dentry, mask, &range,
+			       FSNOTIFY_EVENT_FILE_RANGE);
+}
+
 /*
  * fsnotify_file_area_perm - permission hook before access/modify of file range
  */
@@ -175,7 +190,7 @@ static inline int fsnotify_file_area_perm(struct file *file, int perm_mask,
 	else
 		return 0;
 
-	return fsnotify_file(file, fsnotify_mask);
+	return fsnotify_file_range(file, fsnotify_mask, ppos, count);
 }
 
 /*
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 200a5e3b1cd4..276320846bfd 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -298,6 +298,7 @@ static inline void fsnotify_group_assert_locked(struct fsnotify_group *group)
 /* When calling fsnotify tell it if the data is a path or inode */
 enum fsnotify_data_type {
 	FSNOTIFY_EVENT_NONE,
+	FSNOTIFY_EVENT_FILE_RANGE,
 	FSNOTIFY_EVENT_PATH,
 	FSNOTIFY_EVENT_INODE,
 	FSNOTIFY_EVENT_DENTRY,
@@ -310,6 +311,17 @@ struct fs_error_report {
 	struct super_block *sb;
 };
 
+struct file_range {
+	const struct path *path;
+	const loff_t *ppos;
+	size_t count;
+};
+
+static inline const struct path *file_range_path(const struct file_range *range)
+{
+	return range->path;
+}
+
 static inline struct inode *fsnotify_data_inode(const void *data, int data_type)
 {
 	switch (data_type) {
@@ -319,6 +331,8 @@ static inline struct inode *fsnotify_data_inode(const void *data, int data_type)
 		return d_inode(data);
 	case FSNOTIFY_EVENT_PATH:
 		return d_inode(((const struct path *)data)->dentry);
+	case FSNOTIFY_EVENT_FILE_RANGE:
+		return d_inode(file_range_path(data)->dentry);
 	case FSNOTIFY_EVENT_ERROR:
 		return ((struct fs_error_report *)data)->inode;
 	default:
@@ -334,6 +348,8 @@ static inline struct dentry *fsnotify_data_dentry(const void *data, int data_typ
 		return (struct dentry *)data;
 	case FSNOTIFY_EVENT_PATH:
 		return ((const struct path *)data)->dentry;
+	case FSNOTIFY_EVENT_FILE_RANGE:
+		return file_range_path(data)->dentry;
 	default:
 		return NULL;
 	}
@@ -345,6 +361,8 @@ static inline const struct path *fsnotify_data_path(const void *data,
 	switch (data_type) {
 	case FSNOTIFY_EVENT_PATH:
 		return data;
+	case FSNOTIFY_EVENT_FILE_RANGE:
+		return file_range_path(data);
 	default:
 		return NULL;
 	}
@@ -360,6 +378,8 @@ static inline struct super_block *fsnotify_data_sb(const void *data,
 		return ((struct dentry *)data)->d_sb;
 	case FSNOTIFY_EVENT_PATH:
 		return ((const struct path *)data)->dentry->d_sb;
+	case FSNOTIFY_EVENT_FILE_RANGE:
+		return file_range_path(data)->dentry->d_sb;
 	case FSNOTIFY_EVENT_ERROR:
 		return ((struct fs_error_report *) data)->sb;
 	default:
@@ -379,6 +399,18 @@ static inline struct fs_error_report *fsnotify_data_error_report(
 	}
 }
 
+static inline const struct file_range *fsnotify_data_file_range(
+							const void *data,
+							int data_type)
+{
+	switch (data_type) {
+	case FSNOTIFY_EVENT_FILE_RANGE:
+		return (struct file_range *)data;
+	default:
+		return NULL;
+	}
+}
+
 /*
  * Index to merged marks iterator array that correlates to a type of watch.
  * The type of watched object can be deduced from the iterator type, but not
-- 
2.43.0

