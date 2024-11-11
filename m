Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BE61BD9E4
	for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 20:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731356360; cv=none; b=czDLJIBSPkN2/rQmEeDM18qcw22qMzwtP3IMqVj9FEhExy1tVGnjpkoumbtTFT6dzj3s3DsjFFphkcYBpYLJiZMVPuv3F0Lm4x5p7Rkb7lsQ/BLEv5LYoqYbRIhbVth2YOkUU8zTbmIX2S3mwoSKWztsuSDBH3qNQ+mTDfxCirw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731356360; c=relaxed/simple;
	bh=TmnKu6gi+WKKtr7qPjxxquG53LAeVZdzHoqpUlbbS2k=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKOpnHeJVHNHO6uOD2ZK6M7qlX36+iq2FKF8g6miIHCvdnglXsKjjVY6+BFxvRojvZNNUsggABRi8DuP9HIWc87ds281Xj/2HwCj0vlNJflyMQsKQoOHfCQeoSTx2V6vMgW2AExFMMIMyBOhyiqHjQtnuEl4VgtjnK/n3GQObts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=EjWQBVgF; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="EjWQBVgF"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-460a415633fso34513581cf.2
        for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 12:19:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1731356358; x=1731961158; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gc+ksxaIwBOBmlko1WTmjrx90HfK/kHGON+QNx8apDo=;
        b=EjWQBVgF7zw+qFqexL/S7ovocSsG7/9psnTNs7bun9l1TWbRKUkg38WT4N1hegsn0P
         p7szfHJNSsndulSd8IC9d2LpgjA8yU5y77ziKwB7Du04A7ggNFtp5daWGC1O56JsJ0o6
         60x20h231kIJDinBm1Qq83pAkup2RvZyLqvuqVce7qBnLNjycdGxUl2EBBOtgIYI2R2r
         6MrS1ZLoJh3mdwqkkf7dhm2s1Pr8VN7Bkd71J4jG7q7EaoWbB3l6eJXGmvnDomXSKHku
         yEPCDc6+RpRYqc1OK/15dQvL/GK7ZYPcSb+QF2GwoQsBOo+u+kj5O3ctLyZmbB6SA/Ze
         B3VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731356358; x=1731961158;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gc+ksxaIwBOBmlko1WTmjrx90HfK/kHGON+QNx8apDo=;
        b=UlVsuy82pE611A++TFAL8ZHboL4snN4eKyfvN+dqRhSAR7x7oeF27mNXLIH0lCcAf1
         G0czTxkf8b+yVeqdVmU0xVQQqZDzYxpmRQWKut32lzeEVHEsKG6r39wkdw7D4Wv8TV0f
         3J4Glq1g3Gknz9e3F8Xa/YAqk5CqJM96nhTfPOpoC/2U+ORnGK17hKGaZFtYzKXjM54O
         cNYI3SiYw2nUAjxPiTER9qYg9OTLGRAjs1MMXAM181TOtjz4/jaH0rt+ldB2CgJ1gWaf
         Wyp66lZcxtT472bLK815N5SLOO0d9p44QC54cbBG/FSCfLLTezB3nQgEvqWGXhoMdz5n
         9GeQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvARe+VxtnP6TtcDyFElwJhJCyD5NQrBWnAQEx0XOCxFh0+3W/q46P52JkyHp8/QO7V6PJ8vTSzw4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxetkpFT7bQhng/Bhf4tp6oIWHhmHgrWO/RnXg7YaYvvoIJaSp3
	Lggh5x84YSkNeYesaMLSP7MTWg9z3Ios5Gamcnkuoc+HV5LXthEShPq/aXLFQD0=
X-Google-Smtp-Source: AGHT+IHqngnO/59yGfndmsDZIAVzuHVhRF3bKyXBU2iniiGLSmmnpck59CK/mpALqfBlBcxTed5EdA==
X-Received: by 2002:a05:622a:4d:b0:460:c5b2:58b7 with SMTP id d75a77b69052e-4630942cc70mr178650181cf.51.1731356358100;
        Mon, 11 Nov 2024 12:19:18 -0800 (PST)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-462ff5e2385sm66402261cf.88.2024.11.11.12.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2024 12:19:17 -0800 (PST)
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
Subject: [PATCH v6 06/17] fsnotify: generate pre-content permission event on open
Date: Mon, 11 Nov 2024 15:17:55 -0500
Message-ID: <b509ec78c045d67d4d7e31976eba4b708b238b66.1731355931.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1731355931.git.josef@toxicpanda.com>
References: <cover.1731355931.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Amir Goldstein <amir73il@gmail.com>

Generate pre-content event on open in addition to FS_OPEN_PERM,
but without sb_writers held and after file was truncated
in case file was opened with O_CREAT and/or O_TRUNC.

The event will have a range info of [0..0] to provide an opportunity
to fill entire file content on open.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/namei.c               | 10 +++++++++-
 include/linux/fsnotify.h |  4 +++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 4a4a22a08ac2..b49fb1f80c0c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3782,7 +3782,15 @@ static int do_open(struct nameidata *nd,
 	}
 	if (do_truncate)
 		mnt_drop_write(nd->path.mnt);
-	return error;
+	if (error)
+		return error;
+
+	/*
+	 * This permission hook is different than fsnotify_open_perm() hook.
+	 * This is a pre-content hook that is called without sb_writers held
+	 * and after the file was truncated.
+	 */
+	return fsnotify_file_area_perm(file, MAY_OPEN, &file->f_pos, 0);
 }
 
 /**
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 22150e5797c5..1e87a54b88b6 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -171,6 +171,8 @@ static inline int fsnotify_pre_content(const struct file *file,
 
 /*
  * fsnotify_file_area_perm - permission hook before access of file range
+ *
+ * Called post open with access range [0..0].
  */
 static inline int fsnotify_file_area_perm(struct file *file, int perm_mask,
 					  const loff_t *ppos, size_t count)
@@ -185,7 +187,7 @@ static inline int fsnotify_file_area_perm(struct file *file, int perm_mask,
 	/*
 	 * read()/write and other types of access generate pre-content events.
 	 */
-	if (perm_mask & (MAY_READ | MAY_WRITE | MAY_ACCESS)) {
+	if (perm_mask & (MAY_READ | MAY_WRITE | MAY_ACCESS | MAY_OPEN)) {
 		int ret = fsnotify_pre_content(file, ppos, count);
 
 		if (ret)
-- 
2.43.0

