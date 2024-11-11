Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E18E1A9B3E
	for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 20:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731356350; cv=none; b=OKgY5YHp9tK/SazckbmwU7HWO3BZiU2WccNCUNSIEBZvAtzaeV4MxbfA3WPbbyrnKXj3bcV7VjM6Q92xujMSsrJrIIMXyQqN9waZ3PKPIu2ngdvlvZ0K+7bEuQvAyvDoAPhwGz73zZy+DiasgGNxETtNwynAsZD8k8ypIebMrR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731356350; c=relaxed/simple;
	bh=vjD4OwpRem9TPu2ocewh7lTIgYYZ3zDQs0yfGPZF/n0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WSoypRC5XuCdxozH5j4GTIzcSu8qXk7S9y5/eobshv8v8/YnMKMNGjt2KLwXvZxbvWQ+3b5l3mQzxwo8xRe0OsqVckwnWHta48c5swKtXdELKwvyolLRBzaLzuxqLa/uTpsk1FW3NccJn/YxFtabbNPcq+7SRV8uxdCDFrFOGis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=FF61wmJC; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="FF61wmJC"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-46098928354so37673191cf.1
        for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 12:19:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1731356348; x=1731961148; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E7uBdkMZBWHBDqGd5Y6AU6Zp9KPmNzsckryemzg27pk=;
        b=FF61wmJCAs5sW+Ltc6hHnxfHNfLuSS7EMPDwSNYovAe+4O30IGEFLbvgSQ/1+G/bgT
         2CUt9Jkw09SkKvfwSpHaOBCFYUqdV3/wPQwVSya9LUhSFMhlnaEI5rgB0IU2n/5HBZm9
         7Mq22KkcPAUM+hV2NtsjGK/6LBNe4SvVco9EbJ/DBG8z3CF6HXmP2GRtUSeUmBH5qduJ
         67VrcBL2bmAPVgsy1gneIE0pjP7rB86Whn5T5NlV+y56u5IZziA9h6y3tufOAtyd7RQr
         Q7/Cvq/WTHVjlXcFPbSYPqELsIv6MMN63gqUPJunZVa9NLa0lj9i3y+M96JZy5jDn3Ir
         HzAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731356348; x=1731961148;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E7uBdkMZBWHBDqGd5Y6AU6Zp9KPmNzsckryemzg27pk=;
        b=MxgrFJMRwN8XIJHab8QItbFgN/JBbGukzHXTTCMneyr8nV9BVWWqzeArwl9JmelV6i
         QrpnlKHBGEfwzOA8TSQfHYi4ftz9HG+aRZvr/lHCDLrX421RFAMOXIOsJsvimDitOMz7
         fXZaKY15h5wMJT6KvShpKRq5ajr7Etq7ex6n04teK8NW4+jZ8cwV4EgRoVWiOhr/SR6f
         9wMUeZdrCEGdBpLrq6FhNW9kCGZOnSWnA9ij15xBzGNg34fgGai+MXYiITk8KrHfa6EF
         iTGxmOljokLezsxyeH7DIVJ7uQBwF7Z0jjy810bX0xDdyB+xtiSS18qv1R/MN/CM1VyD
         JitQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCeuvE4HJ9oT8RieS4RnMfjcY7x77eWdQ+/pOYQftYhC7kcgN9RhWngGDwQF6NXqCgiGnBVFq9bp0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFNHfFJuugBUcVGW4h+bXQs1IJUwg4csZ/ozZxJ2bCztumOl+b
	ZCDDFJDBrglWt5Bqmldnh5fcaP6XKXI6rf+Mg7MVSjQfWIebSvNJFySXymTbY/w=
X-Google-Smtp-Source: AGHT+IEBguTWGGBpfMXX3i8vnE5t3UsJSDJvfVnQMRYjxbDOQbaxUPSmwC+HZSzOw+awlnAlKaw9jA==
X-Received: by 2002:ac8:7390:0:b0:463:eef:baaf with SMTP id d75a77b69052e-4630eefbc12mr132991331cf.29.1731356348402;
        Mon, 11 Nov 2024 12:19:08 -0800 (PST)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-462ff3df534sm66530971cf.10.2024.11.11.12.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2024 12:19:07 -0800 (PST)
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
Subject: [PATCH v6 01/17] fanotify: don't skip extra event info if no info_mode is set
Date: Mon, 11 Nov 2024 15:17:50 -0500
Message-ID: <a1be4ec39d230eda892191e972aa5e077d50186e.1731355931.git.josef@toxicpanda.com>
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

New pre-content events will be path events but they will also carry
additional range information. Remove the optimization to skip checking
whether info structures need to be generated for path events. This
results in no change in generated info structures for existing events.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/notify/fanotify/fanotify_user.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 8e2d43fc6f7c..d4dd34690fc6 100644
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
 
@@ -757,12 +754,10 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 	buf += FAN_EVENT_METADATA_LEN;
 	count -= FAN_EVENT_METADATA_LEN;
 
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

