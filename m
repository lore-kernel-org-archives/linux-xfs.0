Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9851E885E
	for <linux-xfs@vger.kernel.org>; Fri, 15 Nov 2024 15:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731684705; cv=none; b=lwKI2o0ahQgyvnh89Xk/YbYX0JK86quzvGqM9ZWDX2J5tCALoulICqqFykqyfr5sPp2x9WG+0onv7+lRq+s/dSsRk9cE43dSaFxEgx1Nep0vGnOWO9hQ2OYNRDDuTfn+24EOEFXn68Cn2zcCzNsV/6wYeaS9CloJnWDOedY/Avc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731684705; c=relaxed/simple;
	bh=S8KtXYKv5KBhFWGf/VgvN+plHsknP1dZU8l0VOqJqrs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V34X2/4rM2+3BZ+zFkneBbYNfPms0PVOkH6jcUb4TP5yOoUy97ZKo+O1bJ0u23yAZumnmpn62HY8GqEQfbwW35W/F/GwVNT4oTn1DIzMO58NJ+MPDEPObRZujcIvKNqCkXHP+K6vPbXOAZRARby5WAQyI1ctyZpu8eUWyxisAKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=cjESmci0; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="cjESmci0"
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e382e549918so588657276.2
        for <linux-xfs@vger.kernel.org>; Fri, 15 Nov 2024 07:31:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1731684703; x=1732289503; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rLlpuiMn0030yB3+s74DQOOZuZXxBi++zrJRvWIMp3o=;
        b=cjESmci0eXPgddC80zNMv3Udj7cRoLwt04JjPWZFgXE4tKyGTzGiIXhCUbbHYZ/69n
         qn0lkya+Xq+oZD3R8S8/rNjn5yQRNFm/czvtmqDhXcWfUkd79+KiJfkkphomJ3lAZZYu
         Km5G3flx5Xr/fzAiuLt7WRo/QpUlfd20+JLLfDmXL7wFdciCvHVIMgKoyJPgVpu/J5O6
         OV3oGaUHK15lyJoJN1eQDK/MWqmxEUPDFxiRFtpL28Sfi/76yjooWM3hqemO22YEwMz6
         6hDZdzNz2zC2UWbYuUwBxl7aNfehFbAPBl88uD4mRStfZWWH8MrmHitXlVNApIQFc1ge
         TBjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731684703; x=1732289503;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rLlpuiMn0030yB3+s74DQOOZuZXxBi++zrJRvWIMp3o=;
        b=hwSRreH+saqxftLvDvrPcxlv1SjHzrrW6wWRl4yvZwyjFnjWTBmqh7sASsh24jIE8y
         qeEc2jvnw5qEn8T7vWBiDjx8Q7jx+6+yjFRnqKOeDjJI52fduJ9BPCPNxs3YmWaAOBR4
         x8e9xdSCX56d6weqjrvdxoJUpPECK1IirjumgNbxVJSNn7Xa+V0Y5qZx6GweNkaPu6SX
         uFgeTVL7cHoymgtc/lhIS3vzYXzhicdaxGtBsDWk8q23hYLSlrm/RQXMtn1q4Cp5OUnF
         /1apxouGTt0czr6d6y5xpGp9VyHtevtfKXOZmTDjxTadoMTftSHSNumq155BHI8Fue8X
         xIOw==
X-Forwarded-Encrypted: i=1; AJvYcCW0y0sHk6pYMmQK4La3pVOmL6pptOqkUOxAccCx7zQzbDMA7wCzoeiRPQo9kAcaOdri3seaoXdSe+c=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzWW+1VQb34GyFXoVdc+2ywTD8iQ/zSx10zB2uwX51MhuvgB8e
	37BovKh0bvuAx6W1+tSWq87lXY9IhMldoIY+r4kb9OORwqicZPMdzqEzPdWTXtQ=
X-Google-Smtp-Source: AGHT+IHLmXNsFgoxeQH2zoAuWGXM6iZ0/bFoZDUBvajKhRUeKgJ2+BFXj02LrLEKz+I9Qy3GGhxCnw==
X-Received: by 2002:a05:690c:6806:b0:6dc:7877:1ea3 with SMTP id 00721157ae682-6ee55a6c9ebmr38646357b3.17.1731684703143;
        Fri, 15 Nov 2024 07:31:43 -0800 (PST)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6ee4400c7dasm7862627b3.24.2024.11.15.07.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 07:31:42 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	torvalds@linux-foundation.org,
	viro@zeniv.linux.org.uk,
	linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org,
	linux-ext4@vger.kernel.org
Subject: [PATCH v8 13/19] fanotify: add a helper to check for pre content events
Date: Fri, 15 Nov 2024 10:30:26 -0500
Message-ID: <657f50e37d6d8f908c13f652129bcdd34ed7f4a9.1731684329.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1731684329.git.josef@toxicpanda.com>
References: <cover.1731684329.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Amir Goldstein <amir73il@gmail.com>

We want to emit events during page fault, and calling into fanotify
could be expensive, so add a helper to allow us to skip calling into
fanotify from page fault.  This will also be used to disable readahead
for content watched files which will be handled in a subsequent patch.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 include/linux/fsnotify.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 08893429a818..d5a0d8648000 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -178,6 +178,11 @@ static inline void file_set_fsnotify_mode(struct file *file)
 	}
 }
 
+static inline bool fsnotify_file_has_pre_content_watches(struct file *file)
+{
+	return file && unlikely(FMODE_FSNOTIFY_HSM(file->f_mode));
+}
+
 /*
  * fsnotify_file_area_perm - permission hook before access to file range
  */
@@ -264,6 +269,11 @@ static inline void file_set_fsnotify_mode(struct file *file)
 {
 }
 
+static inline bool fsnotify_file_has_pre_content_watches(struct file *file)
+{
+	return false;
+}
+
 static inline int fsnotify_file_area_perm(struct file *file, int perm_mask,
 					  const loff_t *ppos, size_t count)
 {
-- 
2.43.0

