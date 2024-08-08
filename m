Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691BD15ECFD
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 19:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723145312; cv=none; b=MA56b0d93jf/EG2UQGvbtMHFsqecGydX+C9sgS1vRvlmsoc+2rPlO0O2zbJPhq0JX30Al+/dvj/WZVemwekqd2usqO9Ga7P14ivOD9ratwa6tYlS+z1pFobSR24Zk4iBZyznKlouB1r94N89oMb8pOd6zOOf6Bnb7t2KrvZl85g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723145312; c=relaxed/simple;
	bh=GuL24mTj9mXM70tRp2J+zNN/WSRlPMuaehdquMxMOMM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E1kcX3wtkbvfFqCL0qc0mE7zMPYBRYynIsSHynE4P3mtHbRf6dObpKXee67MLqgcEsMPncxY5a+SnHzjKfkkLPI/zmMsHUAS5S6ZJP6TM+iPvdPjlKvUlKPBSfo3KGsaNlgxIeKx0TmJhsBeVrv1oTLPB5PEj/YoQ4lW0RjFdC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=YuIjDizw; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="YuIjDizw"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-44fe11dedb3so7566841cf.1
        for <linux-xfs@vger.kernel.org>; Thu, 08 Aug 2024 12:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723145309; x=1723750109; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c2MplehQscA1+uvrWS0C9V1o5GwHxjl+BfkNu3cTe0I=;
        b=YuIjDizwBSBPP6YTB4We5JJP1CXSwKk6cmjWPtWgUS+SqPJl5OEigR8GifxH3HYjhu
         qCFp+vzbu7LlIRp+y6BZPhUJVyM/IEJnvke1iXb3nPXL/EuPVyIbsn4eBepUiIAMMl/g
         mEnNVdGANOSxCTRL6Deiq3DoHDieAaH9igHfZ12bUp/N8HMF5SUOjHxsqExHsNjs3DIz
         Boux0Ad41RNNSknEfzuVwlEy/We9lQg7VfTRWrgXmbHXyPoPtIqo4/HhyOq/5f5eDTR+
         ZzpyEVQLxPM49a6wWMm/mGaHP2i8HCiUoEYmlvO0cuiULtxHFq9ixHJLV6qzsQY2Z+NJ
         FdxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723145309; x=1723750109;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c2MplehQscA1+uvrWS0C9V1o5GwHxjl+BfkNu3cTe0I=;
        b=l3pDwGDS6PCUViDBCPqofgJ1x99HR4grJx/HTfqx0xPmE68IauOfQk7duMY+dlCM46
         7NUTOa+KNzaASqM/M4w5KJg43d7uDNSxyXfq5vnFSxNG3+7P25NVZ7nCsPkY95xS9Ksk
         otO1pDOVQ8yJxo5p6P7XqMX2TnZnZT9acR3B7SfFOh+NRMFZnAWIlVI6SWVSphzzM0PQ
         FhBYQHaAjQX1KFoRhaxAWLBNVR+CmyeoXlYoOIaHVX/9rn2TEAS7S91hGLtfL7dQFyUI
         HsvhfIRqep0eloTKW7Tl5u2HaThy3e8S2t9HFCZtJK+KatYHaTJkwvsosSbl9ZU+iIrZ
         SNoA==
X-Forwarded-Encrypted: i=1; AJvYcCUkPTr4tTrO8giF6676W/Jc3gTwXy3FR9xTQguqlizJMKW1UOw60hwqAiSKVuNUTwcR0vYCo3L0Pv0OLEHjh3la3UMcswqlpzzt
X-Gm-Message-State: AOJu0YzuY3eiRE2x0ozwfO3xsN3xDw7ntss7bYI2QsEik0CoukwEbZES
	Tr3wPrV0fHgsT9/6WrgYFPfygEPPGtdLmLUTZGUGv0pWtyBDCxslbTzVBwaSEdtl+WMCZ9hXoxh
	2
X-Google-Smtp-Source: AGHT+IFDsbaV/n8kDCGttZbX/69iKd/pkdvlPw0dlBa5DAGrReE31B6U9TrZPgrw5N0QpefXodV8nA==
X-Received: by 2002:ac8:6f0a:0:b0:440:6345:257f with SMTP id d75a77b69052e-451d42ff7c2mr40818221cf.60.1723145309461;
        Thu, 08 Aug 2024 12:28:29 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-451c87db202sm15626721cf.72.2024.08.08.12.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 12:28:29 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v2 10/16] fanotify: add a helper to check for pre content events
Date: Thu,  8 Aug 2024 15:27:12 -0400
Message-ID: <531d057087b9430839ddd6082022e29a9066ef1f.1723144881.git.josef@toxicpanda.com>
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

We want to emit events during page fault, and calling into fanotify
could be expensive, so add a helper to allow us to skip calling into
fanotify from page fault.  This will also be used to disable readahead
for content watched files which will be handled in a subsequent patch.

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

