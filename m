Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684B11C7B87
	for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 21:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723670769; cv=none; b=GUmuXT8vDBQYtN+aMMgLVq+CDfD99gc2m8fsUZiVAuE3YvYgSYJ5wG+bNJYcIZpaeXq5QZDidvqrKkIEatS00z3SEAVR+/CVyyl2QHF/jf/sEGL9UoYcMrs/LiIQEAP1I14ib2M5SFjVX24KIBZKc1IcKdRN/UvGjXZTk0kXre0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723670769; c=relaxed/simple;
	bh=2T/bTyebmmWzgd79hiDdf0J2vl5OhNotJm/x2K/voWI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R09XrT9fXBOmRro4xH7fByYWSqxKFhKwTEXh/jldz2KyIsQM6OuXnXXgOuFlF0l2HIOAF6qn0XG+mv0x/u2sPQIRxmf5VEVSWbWA/6egg0bI4URHXhUM7SmUPddl3WDIGQRVT4D8rNR9x1LoMx6w+xyB1BVzY9i/48h3g5m10tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=GFA9QIbu; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="GFA9QIbu"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-44ff398cefcso1840871cf.0
        for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 14:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723670765; x=1724275565; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rE3z53SxlgArsKnVp16449O9VmLlGGSseshi4KP5xk8=;
        b=GFA9QIbuFZu9qCRWztyBNw9BUbbzamMlRQWn2BHBujatWP2EdMryo9iv7xDIo9nOkX
         IMZ3acXfJtDRwBFtx0LpSlHGWW0RYylHhawiZLHG6QbtdLzFcSIxRhQ1nLmRglzFNlR9
         IRu/g6pJMx+2MHJBEf4DmobXu03h0MpmMdRza1m0ewKjdH9i8NV//h411MKMIGnvhLzU
         JUsSi5koXlP7xHEteq84R5vVdLoQnwYhZw+v7nSzZlvO8S9tnpSIDjY/uqzS0MLcLZhn
         S3EXoTbrC3aFyg+4FSNlvnVF9BAw2dSlML/Wew1otabc8WylfHJUcLHLLid7AsZUphV+
         ISfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723670765; x=1724275565;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rE3z53SxlgArsKnVp16449O9VmLlGGSseshi4KP5xk8=;
        b=hy91QfIuPowH8hh8sNK2mDpEhdYcWhqMxD5dhqBK3KAwBLmgPcQQpG8Z4QVA+3WB2i
         w6P9J1ly1FpEjIvg+KT9xbb1wS6jeZyqkdkuK0dGEb859e2mBu2iGz0WLwize4w1THHU
         am4HcgGl0jLdeWBZX82b90cZ/ZV0hjGRIqX4EodgWgOewK8p1fAYJ8ss081a9yXhLbpT
         dX1Dy5AnPqYdv+S//tziud4fFpUbHQh30BmNElM1oNNJ7IQTFzf3GfHSrzEZqxmSYoyU
         h9e/9tExY8CfQfuJy4vzCxo4mq3e7QHsiiOeoS5QyYL7sNo+F/uwPxmkE5iuuxQLb9eD
         p03Q==
X-Forwarded-Encrypted: i=1; AJvYcCUcrMgDzCgQYGvUwuLY0NHqVq6VRkc28Uh9tKJmoWyHf3yAgnrrHKYNGHAt9kRJu1oZbcl0mOnMcnkwMJ7Zx/4sf08ZyrTkYGlu
X-Gm-Message-State: AOJu0YwsEbcXxkc8KJLSOvJ6WWVkNlWoPN79pFnaQLaJe4K5COLAdj4u
	S/NVvgo42ZlxrrIqeOGQ3YKkcbe5zhznQhlpL0OgG4WKrsr55EE923MpZLWuxIvg+9PgbKNykpR
	P
X-Google-Smtp-Source: AGHT+IFOosLEfbUYy+rk3DgRd8S4qUKsWD9x8eVobALgVUhAo3EcRpZRN6epvvOoKaA1rXEtmh1uXA==
X-Received: by 2002:ac8:6f0b:0:b0:447:ea03:454b with SMTP id d75a77b69052e-4535bbc9e18mr41862931cf.51.1723670765231;
        Wed, 14 Aug 2024 14:26:05 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-45369ff3465sm558691cf.31.2024.08.14.14.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 14:26:04 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v4 01/16] fanotify: don't skip extra event info if no info_mode is set
Date: Wed, 14 Aug 2024 17:25:19 -0400
Message-ID: <6a659625a0d08fae894cc47352453a6be2579788.1723670362.git.josef@toxicpanda.com>
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

New pre-content events will be path events but they will also carry
additional range information. Remove the optimization to skip checking
whether info structures need to be generated for path events. This
results in no change in generated info structures for existing events.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/notify/fanotify/fanotify_user.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 9ec313e9f6e1..2e2fba8a9d20 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -160,9 +160,6 @@ static size_t fanotify_event_len(unsigned int info_mode,
 	int fh_len;
 	int dot_len = 0;
 
-	if (!info_mode)
-		return event_len;
-
 	if (fanotify_is_error_event(event->mask))
 		event_len += FANOTIFY_ERROR_INFO_LEN;
 
@@ -740,12 +737,10 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 	if (fanotify_is_perm_event(event->mask))
 		FANOTIFY_PERM(event)->fd = fd;
 
-	if (info_mode) {
-		ret = copy_info_records_to_user(event, info, info_mode, pidfd,
-						buf, count);
-		if (ret < 0)
-			goto out_close_fd;
-	}
+	ret = copy_info_records_to_user(event, info, info_mode, pidfd,
+					buf, count);
+	if (ret < 0)
+		goto out_close_fd;
 
 	if (f)
 		fd_install(fd, f);
-- 
2.43.0

