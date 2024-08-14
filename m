Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3B51C9EA5
	for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 21:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723670775; cv=none; b=cM3r3SHLcn8dlh84OUOp8Bu6mbUKN1AQb6n+pDf2zT5YiMIWFwfB+234cZwTMkzMCB4yHaACkeVHJNZicOS8GpdZD5x+Ar2oXablAoR89KtXknFe3DyuEeg6SzgsF8CgHXgX3EQUC7qXDn6+Vdb81wMt5J5wK4+7gHdT4LbeOuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723670775; c=relaxed/simple;
	bh=qausY9NaTn1Dmt/1fWvpjV6gSoo0TkpL7RjFx1j8ing=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a1mxHHii3yhm5GJTr8bdWphLw/58tjgNuXayAtDd/G/aFt9fUCLxPRBpjQq3+xqOWlys17JJn7WV1tnaGV4nT9+nor2EzmeebeHqXMzhsL9O93GRgJxPZoW0O5Vn+3Ep5y57ZkWzLH97QksIZ0yVqXlQ/XVwQvl6Tqza3eycdKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=YiS9UnPP; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="YiS9UnPP"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-7a1e4c75488so17569385a.0
        for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 14:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723670772; x=1724275572; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JmFE9zypkxWwtjgDkL/vbyJWxHrdDWRoGs2W5KUFOnA=;
        b=YiS9UnPPKE8jnWGziqmRqSMD8JR+3F8Cfq1puGYTeOHW8vtnGMZh7+LpNVqkT3O3HA
         AsMFdntx5HcquC0awu+cRKOKeaKigl7HyiaKvkwYzaGRoxzY+jtkWmbW1Ge0URFCnc/o
         QaePfa6pgG3N+L+ebChrbGBQiKkris0BoJbzp69EGmiZAlUZSptaCTDn9jxktBcQmhVM
         27ze9fSNZlIGxN6YSLeSmiwQvNKDQ3gER5yzTDgVXbHXtuPoyEPFtQzwEbWhJj7Ponuc
         qqYJvjOEVMX5z7y3hy4Trhc5ViI78cDAi2zv5wRguWCvy/qJXekxs/YG9Xc9ZraTZp0r
         TCPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723670772; x=1724275572;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JmFE9zypkxWwtjgDkL/vbyJWxHrdDWRoGs2W5KUFOnA=;
        b=XYalZ2JYBUumxjffeByuq5VUGuhw3e7BxBlvmsAprgGhlobvynd8fBYe6x0tkcNec5
         q2gt3IYS3BcDfgzlx2HwE6YWnUl39DiMF/OkLyghtDVWgq/0jP5LfAGGKTBTrUxbPz4a
         CGJyH0d9YDAT2d1kelIylFxk2l1Hho95sGQDizxKh/ro8+x3N9caPoYq+jCIpkXtu33r
         31gxSpNincvbSFylVG3PoPU4IOpgdm4a/5Q+5kOS/oWOPRZneZE5jivDIq70mjw6zmlp
         jYnOG/FMggHjWPwqAJGHjh1Gt8uVEeNM0TJdafXIjOymBhWAhab0wslZCbTrFVhLdZYZ
         OUWw==
X-Forwarded-Encrypted: i=1; AJvYcCWVOpz67MaO5kMslp3pshC1e5YO0n4BHHsosT93F0aXm7de2EXdm5wPKNHTHShrFOZ8mDjY0TM0BRl9fvqO6NI7R4aNZyzS2GB9
X-Gm-Message-State: AOJu0YxBJikSO5FmVyB8gAFroTDrNjo+e6DTGwTKn5fIZgisoZ72ielo
	fonRQktrZhzJQMdBRMN9agoS+Yv2O/gP2zQO8HhtK1tLbjdEQB/7CgmiX5ySLwQ=
X-Google-Smtp-Source: AGHT+IHIPCQoJFD/t0/lClNrUMrlZFIcM/ZiNaxk2Ar4OdyVmABqqGlEDSnusGifSdOunrg99gpoDQ==
X-Received: by 2002:a05:620a:1907:b0:79d:76c3:5309 with SMTP id af79cd13be357-7a4ee323d52mr531446985a.4.1723670771708;
        Wed, 14 Aug 2024 14:26:11 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a4ff1073e5sm7925585a.121.2024.08.14.14.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 14:26:11 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v4 07/16] fanotify: rename a misnamed constant
Date: Wed, 14 Aug 2024 17:25:25 -0400
Message-ID: <13c1df955c0e8af0aee2afce78b1ea1f2e3f8f66.1723670362.git.josef@toxicpanda.com>
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

FANOTIFY_PIDFD_INFO_HDR_LEN is not the length of the header.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
---
 fs/notify/fanotify/fanotify_user.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 3a7101544f30..5ece186d5c50 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -119,7 +119,7 @@ struct kmem_cache *fanotify_perm_event_cachep __ro_after_init;
 #define FANOTIFY_EVENT_ALIGN 4
 #define FANOTIFY_FID_INFO_HDR_LEN \
 	(sizeof(struct fanotify_event_info_fid) + sizeof(struct file_handle))
-#define FANOTIFY_PIDFD_INFO_HDR_LEN \
+#define FANOTIFY_PIDFD_INFO_LEN \
 	sizeof(struct fanotify_event_info_pidfd)
 #define FANOTIFY_ERROR_INFO_LEN \
 	(sizeof(struct fanotify_event_info_error))
@@ -174,14 +174,14 @@ static size_t fanotify_event_len(unsigned int info_mode,
 		dot_len = 1;
 	}
 
-	if (info_mode & FAN_REPORT_PIDFD)
-		event_len += FANOTIFY_PIDFD_INFO_HDR_LEN;
-
 	if (fanotify_event_has_object_fh(event)) {
 		fh_len = fanotify_event_object_fh_len(event);
 		event_len += fanotify_fid_info_len(fh_len, dot_len);
 	}
 
+	if (info_mode & FAN_REPORT_PIDFD)
+		event_len += FANOTIFY_PIDFD_INFO_LEN;
+
 	return event_len;
 }
 
@@ -511,7 +511,7 @@ static int copy_pidfd_info_to_user(int pidfd,
 				   size_t count)
 {
 	struct fanotify_event_info_pidfd info = { };
-	size_t info_len = FANOTIFY_PIDFD_INFO_HDR_LEN;
+	size_t info_len = FANOTIFY_PIDFD_INFO_LEN;
 
 	if (WARN_ON_ONCE(info_len > count))
 		return -EFAULT;
-- 
2.43.0

