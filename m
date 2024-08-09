Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77991607B7
	for <linux-xfs@vger.kernel.org>; Fri,  9 Aug 2024 18:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723229103; cv=none; b=ZHPEQzg7OlryS4b6s8PIKiU0EGNLKFi6n3s6lkfbRTFd+96DFMW/pYaP/vCDtqrrLGZlzVFFyuGU/kj+v/De46FqU4XJwkU1v5GLre3AOiHwam1wgyEDIGIUbK47AnuhhzSEHO/Ec+ubhAo5siylBdyBGIYW1P/FnxpXGz7VkjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723229103; c=relaxed/simple;
	bh=EUC6xHSolCsXCfEGgJe/uC9iBPwO+UdprLu222bnv+E=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUiZXYj+zwwZIqbLzKj7BVbGMtbuz06beXBXWq7plsAsvUxlJjoK6qUYVpCjZJtGdCOjGLu53en6OlVDsmEeGMXxCd5TgerNW4TrhrpRNcexnRSvQns0E/rcoAUhQTNf8Woprg+QByutF14d6fFFogT55n5Hg3aecRpIyUOkNGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=2IcPDTQf; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="2IcPDTQf"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7a3574acafeso114119585a.1
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2024 11:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723229101; x=1723833901; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WSgX58UYc0emFHK3lK4cO5xgsT7V4KpoEDCer0WZNY4=;
        b=2IcPDTQfMW/6kDO8WAbUyNtXMnjDtl+WbhfTmUSqYZMNA/EHB/y6ezh9NvuU/wHimS
         W5g8LVwcC1Yknr7OQlut2djav+OojM5ct2N6NYqm+ylV6tlHtgCExOcwemcPliXJrEB7
         Y8u1uKWXxky2a2StZu98hRqgiMoG7u9MwFSEtJJS9aouGM6BTjHlcistoOarsXnYnD+1
         j9f3cr9XBDiss0+eN2EhJLPEqk/9utwx42GmWhgpeQx1vzhi3bWb6/2JjJ/ltVZC6wcR
         rIt8WhXPX+VjHkazKQOi6F39EWNacdoN/DU6iwpcWJb2lMW9nF8pdBeshmq7VzIbuVEE
         BA5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723229101; x=1723833901;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WSgX58UYc0emFHK3lK4cO5xgsT7V4KpoEDCer0WZNY4=;
        b=oNuLUbFi8jehaU2jk2JQoYXsDdpO1Izrh0Cp2J5d6n0qWOd3ePhYthiQ86m8ECFbp/
         bHTTrZ7RfHeINqY8EEtDd3gUPZ2d/sDyp0urkbv1seCqKvpeJaPsbC9NqWh5i35iKFU4
         x1d+CajBs04bpsxbNWv3gWdAVb9Eyk62ZDKlAXJUE0w2+YnisnktKovi7hx1SFX7ayQp
         0iJOeWBEGlIa11l0Ofhx5LQvA8k39DjkNjpv3WcihZgvfEc9mmlX5PRWGq/zN7HI3WQP
         hoG4eXwk/NScvo9+dhnuXZEaBgWshAick+qfcE01wJnzBk0043LhQKf1r0FEBQISaCUW
         N+Vw==
X-Forwarded-Encrypted: i=1; AJvYcCUe4+W3DJzr8yt/IM+bIpI9ab0fXl1s3eq7YU5FjPQ33nF5yXvuGcsInTb5cirB7PnljQU5muZmEO2/saEFkxw8xXRxPT8Fr0a9
X-Gm-Message-State: AOJu0YxX98KIMnHlXulL4j8WA/VXeuarG0EQtUVVxvy+rysEiRz/t04I
	GMQLZ+EtsMlHZ/ncCHWDjRxq4dB3PaE/hlgnnnx6O0/YEyulybHwvPeEKs6/rLA=
X-Google-Smtp-Source: AGHT+IH7lRoKjAG+HLOOXf6PwJsnvPNyjM77xPccEnjRjqQVyKu7/q8ahCFc48KaUc0HTJnJWJQYHQ==
X-Received: by 2002:a05:620a:4154:b0:79f:17af:e348 with SMTP id af79cd13be357-7a4c182f757mr296016085a.43.1723229100802;
        Fri, 09 Aug 2024 11:45:00 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a4c7e11130sm3622685a.125.2024.08.09.11.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 11:45:00 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 06/16] fanotify: pass optional file access range in pre-content event
Date: Fri,  9 Aug 2024 14:44:14 -0400
Message-ID: <87325af81514d7bd0b2236e14c613b7160651bda.1723228772.git.josef@toxicpanda.com>
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

