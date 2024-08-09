Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A267815ECD2
	for <linux-xfs@vger.kernel.org>; Fri,  9 Aug 2024 18:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723229100; cv=none; b=ZdHIhj3IH11tjJs+XCm+jjDfjr3rm2rIQlJSnJrgv7QnwO3+hsaBZ2UpvesJK5reYEhpXAbvPh+/mbiHbyHre0uBpFAq8L3CZT5wYoRxhOBZ+CU+e3ImNE4oh8sOx9cUSXtNpwdgeQ/knkzSabKCXkWZh/g5daNljvhzWvS9Ez4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723229100; c=relaxed/simple;
	bh=KQKrHptqPFx5UnDyLAwlPOx0/0+4MigGJ4Sd0QKK9Tg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZhoySutBXUdp1ctK7U2+u3qNYzoB0DZEE0ZjafLcs8k10+lXh7TF51pr6YmQBX8pG4AG4/pih12wTReP49hoQv9G8d5l8CWvC1POs6SZY1onEasCaib7pBHsM5Q7Zmvu7BGFYVooN7tdlbWQHr9d/g6Nz0hOFdqdVpPZMBiPiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=0m2N/m2J; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="0m2N/m2J"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-7a1d0dc869bso142933985a.2
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2024 11:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723229097; x=1723833897; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jN13mVwJhuqjX4PmJ7GJ6BtR6lc23krv9oFHMk0R8ZY=;
        b=0m2N/m2J9AO0vbrptlGK6P1iy5pgychmhD1pUEzksIgbu1QWUkLGNe6qZetJCIAJV0
         Oxls5GWjDldwMQmDnHysOfncwLj6f9JPjUYATlelsteI0cg5cgF6Pe4vxyOdTFguwVn9
         uNt/yHMc5SxthkryGiuRcB2B/GA2Y37jO24Ztmx6mWPGElYmtW8rO2kvISTUETOqQZYY
         DuUQ2Y3H13w9HFF7MlQzUihmC7UMc186Q9R5fefSUMogPBluAv4HlpgW92dMshshoGvG
         XsfdZ0VjR4xIG9DwdZwKQElyadlGvo5R5JRfudBxTezqYXwceSwYBPJ6dsKFs4eJW3DB
         EW4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723229097; x=1723833897;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jN13mVwJhuqjX4PmJ7GJ6BtR6lc23krv9oFHMk0R8ZY=;
        b=PPvzusctFXCFf0kVq5LQqwQOYrhWupFqmkk5B/gno4icZjAiutyOBCIlilmrgzC6IR
         0eD2fUUQqudB/yLWqKkPWeWPAWqUE1FNIux36RKxD0NrejySgRGAH7Xl5x28c90RfHGy
         o8v/I1Cwi9JU07RrzSiuBb/lyr0U4CVYEQrzYiDXIrImtlEta50Ofl/nwfYZwK2K81ie
         aSlhb/NBcUTjBLGwnwMMW4A9u0+AC55YxgQDu9g6hHbfHAyeaHy2XTmgrCTSqg+2W9yz
         9IeXK7nh8yykZ15iNvV7zfSxQbBAikWbOMMAkta9Gy7AZZ8UVd2KRmfu9hVwG8oJVPkM
         OkeQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/AS4ql19DwTY2Fs4DUFLAYY4FAxD3Vj2hW0fnV4nfHJjpKMpxP+QWNRBBE8FVR44LtxZwZOW3DM3Fp4oS30B+M/YT1ZqXuYzg
X-Gm-Message-State: AOJu0YzcLH7I6yUTJU1z5FAKLcaS0VIzLXAeb/Z4fA4zko2jNabps/0+
	+PfejI0hDdxeZhVXrloCPV4vwjIM2qSZQDg4H2XBNtZkEg5GRYjBAcxUOEq2AkLUSw7Ahx6o/w4
	O
X-Google-Smtp-Source: AGHT+IHHl/EOLnBynA8lLjSkcy7OyB9isu0I/BOdIulGxQRUK1Ol8/y8N8Du8hRfZkA5IbZGtjvFiw==
X-Received: by 2002:a05:620a:2906:b0:79f:186e:40c0 with SMTP id af79cd13be357-7a4c182f605mr329964385a.53.1723229097560;
        Fri, 09 Aug 2024 11:44:57 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a4c7d6e49bsm4437685a.32.2024.08.09.11.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 11:44:57 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 03/16] fsnotify: generate pre-content permission event on open
Date: Fri,  9 Aug 2024 14:44:11 -0400
Message-ID: <4b235bf62c99f1f1196edc9da4258167314dc3c3.1723228772.git.josef@toxicpanda.com>
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

FS_PRE_ACCESS or FS_PRE_MODIFY will be generated on open depending on
file open mode.  The pre-content event will be generated in addition to
FS_OPEN_PERM, but without sb_writers held and after file was truncated
in case file was opened with O_CREAT and/or O_TRUNC.

The event will have a range info of (0..0) to provide an opportunity
to fill entire file content on open.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
---
 fs/namei.c               |  9 +++++++++
 include/linux/fsnotify.h | 10 +++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index 3a4c40e12f78..c16487e3742d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3735,6 +3735,15 @@ static int do_open(struct nameidata *nd,
 	}
 	if (do_truncate)
 		mnt_drop_write(nd->path.mnt);
+
+	/*
+	 * This permission hook is different than fsnotify_open_perm() hook.
+	 * This is a pre-content hook that is called without sb_writers held
+	 * and after the file was truncated.
+	 */
+	if (!error)
+		error = fsnotify_file_perm(file, MAY_OPEN);
+
 	return error;
 }
 
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 7600a0c045ba..fb3837b8de4c 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -168,6 +168,10 @@ static inline int fsnotify_file_area_perm(struct file *file, int perm_mask,
 		fsnotify_mask = FS_PRE_MODIFY;
 	else if (perm_mask & (MAY_READ | MAY_ACCESS))
 		fsnotify_mask = FS_PRE_ACCESS;
+	else if (perm_mask & MAY_OPEN && file->f_mode & FMODE_WRITER)
+		fsnotify_mask = FS_PRE_MODIFY;
+	else if (perm_mask & MAY_OPEN)
+		fsnotify_mask = FS_PRE_ACCESS;
 	else
 		return 0;
 
@@ -176,10 +180,14 @@ static inline int fsnotify_file_area_perm(struct file *file, int perm_mask,
 
 /*
  * fsnotify_file_perm - permission hook before file access
+ *
+ * Called from read()/write() with perm_mask MAY_READ/MAY_WRITE.
+ * Called from open() with MAY_OPEN without sb_writers held and after the file
+ * was truncated. Note that this is a different event from fsnotify_open_perm().
  */
 static inline int fsnotify_file_perm(struct file *file, int perm_mask)
 {
-	return fsnotify_file_area_perm(file, perm_mask, NULL, 0);
+	return fsnotify_file_area_perm(file, perm_mask, &file->f_pos, 0);
 }
 
 /*
-- 
2.43.0

