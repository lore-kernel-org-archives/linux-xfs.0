Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6BA13D638
	for <linux-xfs@vger.kernel.org>; Fri,  9 Aug 2024 18:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723229105; cv=none; b=uZVeXqD/0J1TSr4Z6dbe+CNzG2gpaT+mARnoXriuTP7Y3kTPIHqFxT6CWehKWP7lK6mXL2jPvaqHQeFCwRkdjbKPvzadgxybhvhSJS2dcrGO9ZK+faSlIHj8Exh2qHQyNxHFFAujkRiqPrG/QYviiwJ25ryopa54IvfJZXz6fdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723229105; c=relaxed/simple;
	bh=qausY9NaTn1Dmt/1fWvpjV6gSoo0TkpL7RjFx1j8ing=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zk+ysDuRqBaKpMwa/Fxv4QwCC+Hg2oAGOKxs2Nk37Z/JcvmyFtQ5DAcWJamiw45GLiM2M14Ytn7t+XL3glUOZTrAEduMC25YGN18TCgiK0wA2W2+D4swCbIg+Nh49/vUQXBmNCNsNV5k5arKL+p79tN2gGeZnMCbS/Q4ntcYZdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=aaaKE4WE; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="aaaKE4WE"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-7a1d3874c1eso135831485a.2
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2024 11:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723229102; x=1723833902; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JmFE9zypkxWwtjgDkL/vbyJWxHrdDWRoGs2W5KUFOnA=;
        b=aaaKE4WED7xO071vLAu6HxI+uzHP2qelp9+HDhwhWubshkNTfS/uL2er+MiRdA2kY0
         y/TLAzR1XhTZk8bDNXydCcHWBIYsAFgWP0d3tFoy0aEz2cKJDrM6ofJbzb4dOLIY/TMb
         q/itx8qCwGsVW8iKWFmmvVZwTAY80yiB2O2WnBCwPanGS5HrRujBbRBbvtYlDarthDu1
         X+UXleFniy5urnRGDFTgW++i1TpQ+8l8OMkm3ftPSCyrgedvbsjcq1k4PHIm5hybXSOs
         xuRnEjaqGJxoewRjAMTy8fCHgBV26lmH9U3YMXJAwKYfK21j9wxeFNphv5Tw/tR0hHh5
         ilww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723229102; x=1723833902;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JmFE9zypkxWwtjgDkL/vbyJWxHrdDWRoGs2W5KUFOnA=;
        b=p/lRoIf5hSv8nIKBq/6nG/hfGAwdLtQY0AZ7/Kq1HdODohjnfjN4S97VdIm+gUdMS1
         Ww7m3xvaxMXg55aUlouGz7TgDd58CFvL8esEuq8+V4FFFiSDg4Z6NiidQPQ4Yu6M4ogM
         +l16fk/VdyC+uZUvAW5guDyGxVXKS/zJamsJH8kAKBE6EK2MT7d73g3Yg0uUWLWpWVm9
         GiLH4FtyNmH9qw7e6zlkYyIIZW7jvS+judqyf/kvbKGh+wXHULv5lLjC6hncE0q3L7bS
         hHmD+rb7Dxi+JGaSgvjSaKmLTB6Dt5IMpnsk07ULSrXAA10jE3ZqUbxO2OutaXa4QmEZ
         h7bw==
X-Forwarded-Encrypted: i=1; AJvYcCWEg/USTYKVdEqIgVxkeA1VsnBkGqblWDIBK+C9fR0/f7LpVCiqoRIk5xzCPQUZF4q3WdmqAUu5BTUgdk2Cyyc2bwvgZbHLd8Xy
X-Gm-Message-State: AOJu0YxpOZ2NqJHGIik0lsu4Nd+vpffmzoDwsHGrDTR6W3/Rw0lsaHSW
	Y7tueMsGloF3zReqDAjRScrGvo+z5jvuHn7mKPw4JbZZkKoDxwI1sglAam9h3jU=
X-Google-Smtp-Source: AGHT+IEkhpIMThqLGfjbj+pLIWeCnA5xHzdhnlhYpQZelrB1iG6KHPgcncoqW+ZwWfT8YtGLgnfUUw==
X-Received: by 2002:a05:620a:718c:b0:7a3:785a:dc1c with SMTP id af79cd13be357-7a4c182c833mr251102085a.50.1723229101933;
        Fri, 09 Aug 2024 11:45:01 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a4c7d829d1sm4225385a.68.2024.08.09.11.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 11:45:01 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 07/16] fanotify: rename a misnamed constant
Date: Fri,  9 Aug 2024 14:44:15 -0400
Message-ID: <13c1df955c0e8af0aee2afce78b1ea1f2e3f8f66.1723228772.git.josef@toxicpanda.com>
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

