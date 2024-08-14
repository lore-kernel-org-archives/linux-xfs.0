Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259361CB303
	for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 21:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723670777; cv=none; b=LTjuUZX5YjDJ+sGJMf9mSale0LDSpHAR/Bk4Ek5pdmDE3lQ0vpIxIZDMLs90UcEnKQLl0mlea6UbNMum7V4QJc1SrjfvQF4R6ep7MOvtMks1RQs/f/1KWQ5ZvgtlWu4SaWgB0sPb0msgvjdPU37vNi1iRL1xeHzzBER/jABhTkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723670777; c=relaxed/simple;
	bh=fHAWL+liJK7RUemLt/Svh2h8UMEWyBWVNZVgU9u6a6A=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGOvQ07F61nUwzzkfm4MuwLp23ef53Nsm2qtNTp17xAGzcPuvLNOguRAd7zO4dgYNEerBg5vssiEFAG7KhM2HqRikn9k+DEzshyGqvrpIG/PWuKA4qj50jH1ve2oJBBdy3I6vjHSzUxIcB9Oo05qZ5AZCPbGwE2BofbxcxN+qCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=ZwvCc7zy; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="ZwvCc7zy"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-44fdde0c8dcso1813401cf.0
        for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 14:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723670774; x=1724275574; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t2FDeRCcp9Y/rKgVhAuLqn/dDFHjuK0P8k/Tvh5Gfr4=;
        b=ZwvCc7zyys0wzJc1Jc5AaQTTv0d8t8T0o0Yg9PugsQvUYX2lsqesWY8QBjLerlZWbG
         5/3ohG/m77zwr4SfK9migL7H+eQrGvw0IR+pvzOnSWI3cNuVPLvmpWylG2O3eDLU/Z6C
         1khvks0JF6/6l5LPNxgJ6Z2YzVy/fhngbM+mkH7eANeK9gRQzVwYnKhbsOuuUxTcIArR
         HJEu2sbq47lXuXjmq6mp/Rt+nKX6OLWZr75YQUf2+y46bGTeCiZHx0FXg83ctAAA2E04
         lB7ZRwOqzRriQ9KRJe+/oX10K0giOvsQgES2/QOklfvZvzxL/jzAMQL7vhUjPcnsbYmF
         pKKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723670774; x=1724275574;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t2FDeRCcp9Y/rKgVhAuLqn/dDFHjuK0P8k/Tvh5Gfr4=;
        b=obMKCh0l6+zuhFzC5iUL8UcF37K2/7UVsH1Klip7mnB/mLa52qTrT6tMDOuOI0ByKL
         IXjKHpMPyWkOrXuzrKa/5jchLxmpkfsQhP0Fa8gxAXjxWJRo9GxH+EpoL7tPp8sC9tWO
         ksAqzPaBShP0GxMbUOmRsdMuZ99hoTdK4rHWJmpc5OhbvHoMdDNPPdgdtTtv9lntfOsT
         s6ilQwM3eu6W1SXnWNifraf5Qc8w2kLNLW6unvHJWls6yLcXx5FMfvYhOEz0Oz+Iikwl
         pmARKZ63jexIHtTcX8ANolR5RcvITbQgoJ0YqHNrJquHtFhiRVL7qi/1Za4/fwB0zuca
         DPtQ==
X-Forwarded-Encrypted: i=1; AJvYcCXnEh8SLuXmYAuUCv1ix5i3QoCyY+vKN2jtG03+2TVnCcyZHCZNtX3eMdniJm6o4vlJ81LvWOHV/zRjeZgzbN/WVJigKiOTdR/J
X-Gm-Message-State: AOJu0Ywm/qr7miBjDKtlUnEAcLtKITHs1iz7HlUc721h+MeHW0/4VSsN
	E3mq+cIqXXC5FbwwLbwdEXiyaJ45R5VZaFgryY0ELLf4vHfuKotuMWdrh53CcRE=
X-Google-Smtp-Source: AGHT+IHliWHGRhze4pqf7VFGr7kBEPTv8Mb7Qz/sSgPlWWftPx1SWm1Y7AbPN4Kb5nWC//rHu2tx8A==
X-Received: by 2002:ac8:70c:0:b0:453:5c20:90b7 with SMTP id d75a77b69052e-4535c2091eemr36300121cf.0.1723670774001;
        Wed, 14 Aug 2024 14:26:14 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4536a07837esm477701cf.91.2024.08.14.14.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 14:26:13 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v4 09/16] fanotify: allow to set errno in FAN_DENY permission response
Date: Wed, 14 Aug 2024 17:25:27 -0400
Message-ID: <728fb849cd446e6b9a5b9fb9e9985c7d3bd9896a.1723670362.git.josef@toxicpanda.com>
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

