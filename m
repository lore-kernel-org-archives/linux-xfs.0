Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3141C9DF3
	for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 20:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731356380; cv=none; b=UzRB0KjkUx4Ydo4KuRzJbXOtro8Wwdz5EI0qGGm3oalPMEJ8gpMK3T4fGtJQAeBZiQjJe+k1gpsBrMOXYtV3WKm4fmYW82oYpqZEqQW2uocyoHDtG7eC0O1sbYFyQXtkqEMFW59S+Pd3ATQqLGYk+iC4QUEIG/Gt7EOCAEl+NA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731356380; c=relaxed/simple;
	bh=g8f8HPGo6FF6bNhCenpptLnEwEhFsJS2XcfOHpq3gpw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AGSgWSHiropUB+CJeeE419WYJow4cIKH3pOEwBSBDVPrMekXrg0unnxEWVxyxJUV2H9p+pFXo/IYf/piVE9Vzv9omQxjrUFyPylq/bX4L/42s6e3N6pnrvJ2F4BabpxONEohF2rwB+H3yjrWuFjuGPtGOaHzPXn06ry2fHYVpfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=ul3sfdrd; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="ul3sfdrd"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-7b158542592so343955185a.2
        for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 12:19:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1731356377; x=1731961177; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qkyyLOcMapxd8eZps50M2cPjgtuAOvBDRyUA+1LsM90=;
        b=ul3sfdrdnV34wC5BOw9gEuQZTFZo6RWEaCK/AQr3weUiTVU/eJkPtu9fgqudOsJXnv
         mZQj0sOAbfHNRFTehmU174vQivZGCUYNwADSJ9qV7Wyw/j3oyq5/gRKmj06ki2wD6JNy
         75RkjRTrqTQ/lCnQa22zFxX7asmDSp3503jGvAIce+8FbpLPJ6UB6O/AJPUeLCiV+aCR
         7+PZ6R7vOGnkwyTkgTDuCySVK9RNBzQhe5LdYWDiV1Ej1FOBlVtMQwdGy495bC+y56mu
         6ZCDJEMlkyjuYiDc5dW7atL7J8aPlLG605AIYviz0sGSZc6jaB8FO3OYgiwfU0pytqqC
         apdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731356377; x=1731961177;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qkyyLOcMapxd8eZps50M2cPjgtuAOvBDRyUA+1LsM90=;
        b=DxI1IqovyM6ZJDSUxTVlLhNAyAtFBnm34OPCWk86ebS5WQwBTX0KvKdK8sOdrZ4gYq
         IKaKGEj+ZrODCLG6jtCNCSDm43i3tvfWudG32Q1jYpKRI/n5pKNbvrC3DXqlBGDxpthP
         5+MJj13T4srBr9IHQRsD2MNMglfVwU+t7wQVp+UaAzHzjnzJhkMIESxTo969k6lqAgfR
         3l1lgoffLQEsX5oOmgUiAFteMGSZwN/K1FJ5X4FkQ/X1NXH0JVbkX/eJ2z4i8/2uODRF
         RIEbOLzU87MrjcWiRJCoWanwJ5LRdBQJfU9sQCNndCMlsBVt05MyezY7ZXklCimuZ4yh
         NeQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYq6i6pSbzKsVVB9KOU9cnEhyYnV6Z27078xN74hSAiUF/V5m8632UlA4mNE0bS0MQtvTut6Yse4Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxQtpbpusz4dqzqdjTDP1hJpbtgdMTLAmi3RRN8wNdQaeazq6c
	p8ZKSNC2H3KeETSgXT+ziyEiYYSRf5hnYnfRr275q1JqJJqLwUR3UtjOb6j9rwo=
X-Google-Smtp-Source: AGHT+IGjGL9g3kFfcH+6V8KAtQzfg7b48XSPpKvHKYOiM22WInprVkhEgNc7K8iBcMmLd7E6fsLBYg==
X-Received: by 2002:a05:620a:19a7:b0:7b1:3e41:849f with SMTP id af79cd13be357-7b331eff745mr2211412185a.47.1731356377090;
        Mon, 11 Nov 2024 12:19:37 -0800 (PST)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b32acae57asm525455685a.81.2024.11.11.12.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2024 12:19:36 -0800 (PST)
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
Subject: [PATCH v6 16/17] btrfs: disable defrag on pre-content watched files
Date: Mon, 11 Nov 2024 15:18:05 -0500
Message-ID: <c46f21bd55082ccf7380d438d82d3ebbaea284f9.1731355931.git.josef@toxicpanda.com>
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

We queue up inodes to be defrag'ed asynchronously, which means we do not
have their original file for readahead.  This means that the code to
skip readahead on pre-content watched files will not run, and we could
potentially read in empty pages.

Handle this corner case by disabling defrag on files that are currently
being watched for pre-content events.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/ioctl.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 226c91fe31a7..9b13df1ea729 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2638,6 +2638,15 @@ static int btrfs_ioctl_defrag(struct file *file, void __user *argp)
 			goto out;
 		}
 
+		/*
+		 * Don't allow defrag on pre-content watched files, as it could
+		 * populate the page cache with 0's via readahead.
+		 */
+		if (fsnotify_file_has_pre_content_watches(file)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
 		if (argp) {
 			if (copy_from_user(&range, argp, sizeof(range))) {
 				ret = -EFAULT;
-- 
2.43.0

