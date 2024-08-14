Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2FB1C8248
	for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 21:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723670771; cv=none; b=fZkrwnFiLf8UxdAzp0M4Mf9EK0r7g+G7BX0DgoJf4CQmmrsotneaqs4uNJb/GtTQ5e1nqthySCcj39JJgy+VwtnWaS++HeWB9ePEfoFspnm4c09bPAyot7/en8Ea57gptLh2W8dmmEb0l9C0uABk9xefaPFrp+fLzLF2w8KoyzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723670771; c=relaxed/simple;
	bh=KQKrHptqPFx5UnDyLAwlPOx0/0+4MigGJ4Sd0QKK9Tg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2/tF2ecH7xRwZ6yHvuPdW9i1ggZH9zrAYP4JEDivROweGHyh5tUWswFAI4gfaupBBpasnqqUZSyFXEenUY6lFcgdddwSysj5Rc/IIRAra5rvWpDV6/De1nSfkrTPBTCjWESFnfZfVCSuGobdBopcFit4I1NivvofHUT+5q+aPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=Z0HWOMMg; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="Z0HWOMMg"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7a1d024f775so19549185a.2
        for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 14:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723670767; x=1724275567; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jN13mVwJhuqjX4PmJ7GJ6BtR6lc23krv9oFHMk0R8ZY=;
        b=Z0HWOMMgOrSgPVSZOBi/9uBHz4Tfa36G4QNcdn+g7fc3uhcaQPXtqfAUMOFmQKI+hK
         SKdkrH4sln7u/TQnIHVz3/n8RNUk9wbfZvp6pU0O8jjTC0qvNPiYAR1Hm4ixpDLyPsPr
         v9RzOXNN31RxWtrAEWx0x1yZWXucvQV9bxQHhSjCdhBlkc3+ic+XC8xJBl1VMt67AHUX
         ZyP2ey0a0j/U6vhR971S9Y8/DgXoXiVbSN5DlOgxc+0v/Imu4o2xIxxhklU8Yh/pZ/bH
         d6+bvFko1cME3EFyr7CqLu7AIWttktPhY/UhWVjt5OwKQ8XE6HhDOgb41rUN+Hs3B7EW
         tLHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723670767; x=1724275567;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jN13mVwJhuqjX4PmJ7GJ6BtR6lc23krv9oFHMk0R8ZY=;
        b=MpcS7qsHNdTm2Oeqk1SFmPdyEgPoBWNvWMZeK7Eyr2zYonjGhmRxccyXxRt9uRMJ4i
         VkOtLJ33ZIS9Ny6ZvKiGe6wUu5j9UsMzoFUf8W9gqwTDXnG2lnNIAMOXNnmnfDDwhP3l
         wWbduQyTkrQTgrycfESFU70i2QgmvsokI+dAv3kBLvVOIVRu8YRBiDDWC62+l5O4/SYJ
         oYmRdqywbCiMNd3e/k1M86jqV2NX5V/MT90B+MigVme548tvPmGcYkBV7UYMVshgGuUh
         /MRwZ0p7+vEatO2Vz5Elf/Rtvtxz95K6XCUok85prE6QDI5nRAgvf7XQSlvtqlV/dRFp
         ka/g==
X-Forwarded-Encrypted: i=1; AJvYcCWLYKN1JKgueEH0TSLjGRcTGZx5WdCmF0ePiKFBHh1Z0Sn1PmBGM907kLb45tGXnzPmUE+CMUHygVBiIGhlMQnzNontthWN1Nc5
X-Gm-Message-State: AOJu0Yw1ttF+dvo/g6g3EJ8R/4y94ifhaStdEKGNWbhAcWIzLBWpcUs5
	WJLTUpk7D5XyJpHknwDU4sL7Mgg7/3+9tjdxlaAoUyFOIIA1wMJLDHQ7d2WAYp0=
X-Google-Smtp-Source: AGHT+IEOAxo/YLBU2zsyh9BoruPZGvcW7AnOYidoJyHePzbDbTVUapd9HA/DiVKweRuuQtAwKoLbLg==
X-Received: by 2002:a05:620a:4506:b0:7a3:4fb7:5c77 with SMTP id af79cd13be357-7a4ee3187dcmr432377385a.11.1723670767459;
        Wed, 14 Aug 2024 14:26:07 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a4ff04830fsm8695885a.30.2024.08.14.14.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 14:26:07 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v4 03/16] fsnotify: generate pre-content permission event on open
Date: Wed, 14 Aug 2024 17:25:21 -0400
Message-ID: <4b235bf62c99f1f1196edc9da4258167314dc3c3.1723670362.git.josef@toxicpanda.com>
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

