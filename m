Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com [209.85.219.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49BC52144CB
	for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 17:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731434191; cv=none; b=r7kQ18mCop1lTuD9vf3q8IoprsQDFrK1kxtucV7/bz06C3VZAe6ARWXVGJE7fIeLMY0MsioHCdQ5rnwASpnzwoz5J7eb4WNh1pfixTVLvHifCgszxdfvApfdO41uPWP6e5wECTtd+xIVZLhzNXn1n/kI1Qq6UNLb0XC7Q/wTXKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731434191; c=relaxed/simple;
	bh=11jl092YZCvDsEQM8MRFPHX46vWa6jZIxtF/Iwx+Z+c=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=egau841Me8D2jf7YwI7EXRRjtCo+DgE9GszHJpHTBzmSDV8d1ykI1xptEpw/njmY5rz2TneoUAOJgyotR5U8IZFHdPg/56P19Ri6SD6Fyk9PfHFShLATnbpABeMnVZX7guWP0OO1kIvZAC+uHY2rqlyf2d6xZF54jzesWKkHSrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=Xb5Qr1Tp; arc=none smtp.client-ip=209.85.219.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="Xb5Qr1Tp"
Received: by mail-yb1-f171.google.com with SMTP id 3f1490d57ef6-e28fea0f5b8so5400603276.1
        for <linux-xfs@vger.kernel.org>; Tue, 12 Nov 2024 09:56:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1731434189; x=1732038989; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mq4eCWj3WcSxvhXcUvd/jAH4xfodB1FzV8Pinzx/1+k=;
        b=Xb5Qr1TpiDBV5E6f3yL5WwLQIwq0P+/iLW5KG4mnBXiKioBwu9YZQP16tQ6uuM0hcU
         0ZSXfVirRmEWQnLiBFTyzxRWXgaGhYCk19q9y0vuWtBmN2w4F4ebr+1uw5/byDD1mqLu
         O7Mj7pPdziahwjjCUlDzpayEx0VMdirM/4AH+eSlDkAdBK7qiCo1x1uPr7LKgp4MFFJX
         uryD5tuT6wpxXe1KcbS3MLE4Fn5QP0quf4s2vqWrCskTjVzrMWunI3BJthOhZHkFVncB
         D5ZWe36n63uiEE5sLAVoAB0TcvTvTN2Sjy52QcxVtYBBXHOozwna8oIejmL6TLY6qPEV
         Ktyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731434189; x=1732038989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mq4eCWj3WcSxvhXcUvd/jAH4xfodB1FzV8Pinzx/1+k=;
        b=ZsEh06GQyduuPiTJKOvWbibSVmnsAvOJO/ejshctLviFQpsOHG6JPk8YIoOEr9JSVu
         pQhXtmJHINzAJn3+t4xFFHgxY9tXg8msZk/sKIhP1NGf0D7zLortkkiVj9WWw6ZcbxT2
         Ce76a/3bqgGz1rEJrijwVK3KHpVN4pxszkUZmHvOG0bbYjKDenqTz1f0K2BIVQ1U0hv5
         mN1VF4UzyC5g4iB4A2NFIl9Pqhbi2YF3rIwcM8RscD9VzEJBG/KI+fYiJMUdf32u55bu
         D63qArwuQLAUMd6ugsotNYEyXjLN8Cu1MmbwnZ4WvM21SKDRDOkH5bKtQTzdzXWZHjfN
         BlrA==
X-Forwarded-Encrypted: i=1; AJvYcCVW2LKYQTj3nKyhHNC8wqi2g4uLbv4Ona7rsVHEzNl6RL+JBpBd6avIUQNIauUoOY3gXmgrG/sCMzw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzydCh+IzoLNAIjLusgAykkseBxc43e61Rb0xgWL09XOAmaMycP
	KyRe5pChWWXUXC4zsM34zQe7plXXUzbTDU725o6Oy+3eUlKAR6N/hTQjHBodlYE=
X-Google-Smtp-Source: AGHT+IFBKT6JokrQIp6S+zAuePqtp2Pbd6mVXpN9BpEETDu72cZLQs4+EA2DJXpbqyUYUXFat/YoBg==
X-Received: by 2002:a05:6902:2890:b0:e30:bbf9:993 with SMTP id 3f1490d57ef6-e337f861472mr15084106276.20.1731434189089;
        Tue, 12 Nov 2024 09:56:29 -0800 (PST)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e336ef20671sm2885707276.20.2024.11.12.09.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 09:56:28 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	torvalds@linux-foundation.org,
	linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org,
	linux-ext4@vger.kernel.org
Subject: [PATCH v7 01/18] fsnotify: opt-in for permission events at file_open_perm() time
Date: Tue, 12 Nov 2024 12:55:16 -0500
Message-ID: <8c8e9452d153a1918470cbe52a8eb6505c675911.1731433903.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1731433903.git.josef@toxicpanda.com>
References: <cover.1731433903.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Amir Goldstein <amir73il@gmail.com>

Legacy inotify/fanotify listeners can add watches for events on inode,
parent or mount and expect to get events (e.g. FS_MODIFY) on files that
were already open at the time of setting up the watches.

fanotify permission events are typically used by Anti-malware sofware,
that is watching the entire mount and it is not common to have more that
one Anti-malware engine installed on a system.

To reduce the overhead of the fsnotify_file_perm() hooks on every file
access, relax the semantics of the legacy FAN_OPEN_PERM event to generate
events only if there were *any* permission event listeners on the
filesystem at the time that the file was open.

The new semantics, implemented with the opt-in FMODE_NOTIFY_PERM flag
are also going to apply to the new fanotify pre-content event in order
to reduce the cost of the pre-content event vfs hooks.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/linux-fsdevel/CAHk-=wj8L=mtcRTi=NECHMGfZQgXOp_uix1YVh04fEmrKaMnXA@mail.gmail.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 include/linux/fs.h       |  3 ++-
 include/linux/fsnotify.h | 47 ++++++++++++++++++++++++++++------------
 2 files changed, 35 insertions(+), 15 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9c13222362f5..9b58e9887e4b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -173,7 +173,8 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 
 #define	FMODE_NOREUSE		((__force fmode_t)(1 << 23))
 
-/* FMODE_* bit 24 */
+/* File may generate fanotify access permission events */
+#define FMODE_NOTIFY_PERM	((__force fmode_t)(1 << 24))
 
 /* File is embedded in backing_file object */
 #define FMODE_BACKING		((__force fmode_t)(1 << 25))
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 278620e063ab..f0fd3dcae654 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -108,10 +108,9 @@ static inline void fsnotify_dentry(struct dentry *dentry, __u32 mask)
 	fsnotify_parent(dentry, mask, dentry, FSNOTIFY_EVENT_DENTRY);
 }
 
-static inline int fsnotify_file(struct file *file, __u32 mask)
+/* Should events be generated on this open file regardless of watches? */
+static inline bool fsnotify_file_watchable(struct file *file, __u32 mask)
 {
-	const struct path *path;
-
 	/*
 	 * FMODE_NONOTIFY are fds generated by fanotify itself which should not
 	 * generate new events. We also don't want to generate events for
@@ -119,14 +118,37 @@ static inline int fsnotify_file(struct file *file, __u32 mask)
 	 * handle creation / destruction events and not "real" file events.
 	 */
 	if (file->f_mode & (FMODE_NONOTIFY | FMODE_PATH))
+		return false;
+
+	/* Permission events require that watches are set before FS_OPEN_PERM */
+	if (mask & ALL_FSNOTIFY_PERM_EVENTS & ~FS_OPEN_PERM &&
+	    !(file->f_mode & FMODE_NOTIFY_PERM))
+		return false;
+
+	return true;
+}
+
+static inline int fsnotify_file(struct file *file, __u32 mask)
+{
+	const struct path *path;
+
+	if (!fsnotify_file_watchable(file, mask))
 		return 0;
 
 	path = &file->f_path;
-	/* Permission events require group prio >= FSNOTIFY_PRIO_CONTENT */
-	if (mask & ALL_FSNOTIFY_PERM_EVENTS &&
-	    !fsnotify_sb_has_priority_watchers(path->dentry->d_sb,
-					       FSNOTIFY_PRIO_CONTENT))
-		return 0;
+	/*
+	 * Permission events require group prio >= FSNOTIFY_PRIO_CONTENT.
+	 * Unless permission event watchers exist at FS_OPEN_PERM time,
+	 * operations on file will not be generating any permission events.
+	 */
+	if (mask & ALL_FSNOTIFY_PERM_EVENTS) {
+		if (!fsnotify_sb_has_priority_watchers(path->dentry->d_sb,
+						       FSNOTIFY_PRIO_CONTENT))
+			return 0;
+
+		if (mask & FS_OPEN_PERM)
+			file->f_mode |= FMODE_NOTIFY_PERM;
+	}
 
 	return fsnotify_parent(path->dentry, mask, path, FSNOTIFY_EVENT_PATH);
 }
@@ -166,15 +188,12 @@ static inline int fsnotify_file_perm(struct file *file, int perm_mask)
  */
 static inline int fsnotify_open_perm(struct file *file)
 {
-	int ret;
+	int ret = fsnotify_file(file, FS_OPEN_PERM);
 
-	if (file->f_flags & __FMODE_EXEC) {
+	if (!ret && file->f_flags & __FMODE_EXEC)
 		ret = fsnotify_file(file, FS_OPEN_EXEC_PERM);
-		if (ret)
-			return ret;
-	}
 
-	return fsnotify_file(file, FS_OPEN_PERM);
+	return ret;
 }
 
 #else
-- 
2.43.0

