Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D01167DB9
	for <linux-xfs@vger.kernel.org>; Fri,  9 Aug 2024 18:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723229109; cv=none; b=EHjCWydfWdmb/4LeLKqBf3Iq+vWOXFsUT9xAJ2Wo4L27mhy+9cB9zkWv8zPu6yCepIYj5phYBs+8773UsSzLHzbTRuaqjCLadpkv9V7uZKmfoYw/ayL8zV+iBBebE50XM+GTAUXHmBYhepnzoSPMP86TrqS+dpLFnFTi/rfRbc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723229109; c=relaxed/simple;
	bh=fHAWL+liJK7RUemLt/Svh2h8UMEWyBWVNZVgU9u6a6A=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KeO04o549O6Nk9GUOocFi1A8L/M/QO3GafMnve+QG0BnWJj6ndzyGOlcCaob78llj/e7A4Jjx3I6tsH3lQniixuQsCHuaKI1eK8hqfEKKLPWjoGau9KpKvb9/LtdsN7Jcys4gJgWtLSL8gCWUgtAqweEIjpVpyIgTsW6CEIdBek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=Hopvm27Z; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="Hopvm27Z"
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-3d9e13ef8edso1702596b6e.2
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2024 11:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723229104; x=1723833904; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t2FDeRCcp9Y/rKgVhAuLqn/dDFHjuK0P8k/Tvh5Gfr4=;
        b=Hopvm27Znwt9KcmE5xzWTcizuRmlvSE/V71s6MQwrcJOzPBYAuX12AaEa865QfzdAx
         g2vqM4YItzWBs1YsOMMACOyNvgjXJGdB/rZkN3v8ijY5JKTjCyNElgydLXYzwuE24knp
         J2ttDezjS8HvwHAfPdxOI3Unovu4U4TWx7hjjw7ux9kGNk8+Er6ZWNQITX9Wzms2Vyc1
         qI2BQ5pq3FtetJFCPjoT79byGjAL/TvANDHrbufqE/tnsWpzDakwmb+pLpstJApWIYV4
         ySaTbrLJkuiSZVj/urxar4ie/kKYGzmy/RBHsf0D8UD1JveW9MdJWzbDIM6XpzJVkRzC
         OUpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723229104; x=1723833904;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t2FDeRCcp9Y/rKgVhAuLqn/dDFHjuK0P8k/Tvh5Gfr4=;
        b=uwCia80L1IXGXvWu/YnpMi68tnjXLNwZ9ChYPi095jWgRexY5Q/T7dU6GXem5QuZzM
         G9NjnjF4CJKf2LZBpsrMClkT+XuP6JpbGQYmg/vcADE/iTv4+x4+MUA2RZ7QXCJaH8xt
         QJS7AaRvcc9pcwWYZaOsFaq7Lk5Aw0G2uOcmb5vS9YjEmxRRLAmgH6sCke2guZI45mr5
         CU7KwyF1vaGRM7vsRryPfT0C4/7X3DjYyBRlU5wkqFsX1ewU64U4eV2G/Y1Jbf1wusM0
         uaqsxtAT5Ukhv2I5zncs2/jpCvmPr9IcputVyeIdi9fjMPbuMn07/cejDzuFcv+B7nAp
         oNQQ==
X-Forwarded-Encrypted: i=1; AJvYcCU2EuZguMPN0jUA9/oJeSj/MMTfhhZ3FJnOyimTv+N7PcyhZWPyzY+WdNnvC+3bvnd9HhTm0uylUznm00RgDs9GtRgmGHcB2cKs
X-Gm-Message-State: AOJu0YwVwM7pgpy18BEtTECDKyFqIeLIpSftoP/FqhsGazK4DHnYltFe
	T2t2NsvvDo0MfqnPSi1C+dEq3Ig1xjxoCcquBzOr1qowwuBVPiK2uwwfcAfMtMU=
X-Google-Smtp-Source: AGHT+IFJSfLBdAcQ8zCmPIT0ViO/k/ms1JOvkH9AyPyG9fuJoNWPXZHsX6olwKWSfBmyK+3f2osXZw==
X-Received: by 2002:a05:6358:5288:b0:1aa:d71f:6921 with SMTP id e5c5f4694b2df-1b176edf133mr287241555d.5.1723229104145;
        Fri, 09 Aug 2024 11:45:04 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bd82ca3c0bsm647386d6.60.2024.08.09.11.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 11:45:03 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 09/16] fanotify: allow to set errno in FAN_DENY permission response
Date: Fri,  9 Aug 2024 14:44:17 -0400
Message-ID: <728fb849cd446e6b9a5b9fb9e9985c7d3bd9896a.1723228772.git.josef@toxicpanda.com>
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

With FAN_DENY response, user trying to perform the filesystem operation
gets an error with errno set to EPERM.

It is useful for hierarchical storage management (HSM) service to be able
to deny access for reasons more diverse than EPERM, for example EAGAIN,
if HSM could retry the operation later.

Allow fanotify groups with priority FAN_CLASSS_PRE_CONTENT to responsd
to permission events with the response value FAN_DENY_ERRNO(errno),
instead of FAN_DENY to return a custom error.

Limit custom error values to errors expected on read(2)/write(2) and
open(2) of regular files. This list could be extended in the future.
Userspace can test for legitimate values of FAN_DENY_ERRNO(errno) by
writing a response to an fanotify group fd with a value of FAN_NOFD in
the fd field of the response.

The change in fanotify_response is backward compatible, because errno is
written in the high 8 bits of the 32bit response field and old kernels
reject respose value with high bits set.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/notify/fanotify/fanotify.c      | 18 ++++++++++-----
 fs/notify/fanotify/fanotify.h      | 10 +++++++++
 fs/notify/fanotify/fanotify_user.c | 36 +++++++++++++++++++++++++-----
 include/linux/fanotify.h           |  5 ++++-
 include/uapi/linux/fanotify.h      |  7 ++++++
 5 files changed, 65 insertions(+), 11 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 4e8dce39fa8f..1cbf41b34080 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -224,7 +224,8 @@ static int fanotify_get_response(struct fsnotify_group *group,
 				 struct fanotify_perm_event *event,
 				 struct fsnotify_iter_info *iter_info)
 {
-	int ret;
+	int ret, errno;
+	u32 decision;
 
 	pr_debug("%s: group=%p event=%p\n", __func__, group, event);
 
@@ -257,20 +258,27 @@ static int fanotify_get_response(struct fsnotify_group *group,
 		goto out;
 	}
 
+	decision = fanotify_get_response_decision(event->response);
 	/* userspace responded, convert to something usable */
-	switch (event->response & FANOTIFY_RESPONSE_ACCESS) {
+	switch (decision & FANOTIFY_RESPONSE_ACCESS) {
 	case FAN_ALLOW:
 		ret = 0;
 		break;
 	case FAN_DENY:
+		/* Check custom errno from pre-content events */
+		errno = fanotify_get_response_errno(event->response);
+		if (errno) {
+			ret = -errno;
+			break;
+		}
+		fallthrough;
 	default:
 		ret = -EPERM;
 	}
 
 	/* Check if the response should be audited */
-	if (event->response & FAN_AUDIT)
-		audit_fanotify(event->response & ~FAN_AUDIT,
-			       &event->audit_rule);
+	if (decision & FAN_AUDIT)
+		audit_fanotify(decision & ~FAN_AUDIT, &event->audit_rule);
 
 	pr_debug("%s: group=%p event=%p about to return ret=%d\n", __func__,
 		 group, event, ret);
diff --git a/fs/notify/fanotify/fanotify.h b/fs/notify/fanotify/fanotify.h
index 7f06355afa1f..d0722ef13138 100644
--- a/fs/notify/fanotify/fanotify.h
+++ b/fs/notify/fanotify/fanotify.h
@@ -528,3 +528,13 @@ static inline unsigned int fanotify_mark_user_flags(struct fsnotify_mark *mark)
 
 	return mflags;
 }
+
+static inline u32 fanotify_get_response_decision(u32 res)
+{
+	return res & (FANOTIFY_RESPONSE_ACCESS | FANOTIFY_RESPONSE_FLAGS);
+}
+
+static inline int fanotify_get_response_errno(int res)
+{
+	return res >> FAN_ERRNO_SHIFT;
+}
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index ed56fe6f5ec7..0a37f1c761aa 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -337,11 +337,13 @@ static int process_access_response(struct fsnotify_group *group,
 	struct fanotify_perm_event *event;
 	int fd = response_struct->fd;
 	u32 response = response_struct->response;
+	u32 decision = fanotify_get_response_decision(response);
+	int errno = fanotify_get_response_errno(response);
 	int ret = info_len;
 	struct fanotify_response_info_audit_rule friar;
 
-	pr_debug("%s: group=%p fd=%d response=%u buf=%p size=%zu\n", __func__,
-		 group, fd, response, info, info_len);
+	pr_debug("%s: group=%p fd=%d response=%x errno=%d buf=%p size=%zu\n",
+		 __func__, group, fd, response, errno, info, info_len);
 	/*
 	 * make sure the response is valid, if invalid we do nothing and either
 	 * userspace can send a valid response or we will clean it up after the
@@ -350,18 +352,42 @@ static int process_access_response(struct fsnotify_group *group,
 	if (response & ~FANOTIFY_RESPONSE_VALID_MASK)
 		return -EINVAL;
 
-	switch (response & FANOTIFY_RESPONSE_ACCESS) {
+	switch (decision & FANOTIFY_RESPONSE_ACCESS) {
 	case FAN_ALLOW:
+		if (errno)
+			return -EINVAL;
+		break;
 	case FAN_DENY:
+		/* Custom errno is supported only for pre-content groups */
+		if (errno && group->priority != FSNOTIFY_PRIO_PRE_CONTENT)
+			return -EINVAL;
+
+		/*
+		 * Limit errno to values expected on open(2)/read(2)/write(2)
+		 * of regular files.
+		 */
+		switch (errno) {
+		case 0:
+		case EIO:
+		case EPERM:
+		case EBUSY:
+		case ETXTBSY:
+		case EAGAIN:
+		case ENOSPC:
+		case EDQUOT:
+			break;
+		default:
+			return -EINVAL;
+		}
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	if ((response & FAN_AUDIT) && !FAN_GROUP_FLAG(group, FAN_ENABLE_AUDIT))
+	if ((decision & FAN_AUDIT) && !FAN_GROUP_FLAG(group, FAN_ENABLE_AUDIT))
 		return -EINVAL;
 
-	if (response & FAN_INFO) {
+	if (decision & FAN_INFO) {
 		ret = process_access_response_info(info, info_len, &friar);
 		if (ret < 0)
 			return ret;
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index ae6cb2688d52..547514542669 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -132,7 +132,10 @@
 /* These masks check for invalid bits in permission responses. */
 #define FANOTIFY_RESPONSE_ACCESS (FAN_ALLOW | FAN_DENY)
 #define FANOTIFY_RESPONSE_FLAGS (FAN_AUDIT | FAN_INFO)
-#define FANOTIFY_RESPONSE_VALID_MASK (FANOTIFY_RESPONSE_ACCESS | FANOTIFY_RESPONSE_FLAGS)
+#define FANOTIFY_RESPONSE_ERRNO	(FAN_ERRNO_MASK << FAN_ERRNO_SHIFT)
+#define FANOTIFY_RESPONSE_VALID_MASK \
+	(FANOTIFY_RESPONSE_ACCESS | FANOTIFY_RESPONSE_FLAGS | \
+	 FANOTIFY_RESPONSE_ERRNO)
 
 /* Do not use these old uapi constants internally */
 #undef FAN_ALL_CLASS_BITS
diff --git a/include/uapi/linux/fanotify.h b/include/uapi/linux/fanotify.h
index cc28dce5f744..7b746c5fcbd8 100644
--- a/include/uapi/linux/fanotify.h
+++ b/include/uapi/linux/fanotify.h
@@ -233,6 +233,13 @@ struct fanotify_response_info_audit_rule {
 /* Legit userspace responses to a _PERM event */
 #define FAN_ALLOW	0x01
 #define FAN_DENY	0x02
+/* errno other than EPERM can specified in upper byte of deny response */
+#define FAN_ERRNO_BITS	8
+#define FAN_ERRNO_SHIFT (32 - FAN_ERRNO_BITS)
+#define FAN_ERRNO_MASK	((1 << FAN_ERRNO_BITS) - 1)
+#define FAN_DENY_ERRNO(err) \
+	(FAN_DENY | ((((__u32)(err)) & FAN_ERRNO_MASK) << FAN_ERRNO_SHIFT))
+
 #define FAN_AUDIT	0x10	/* Bitmask to create audit record for result */
 #define FAN_INFO	0x20	/* Bitmask to indicate additional information */
 
-- 
2.43.0

