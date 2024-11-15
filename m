Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5651E6310
	for <linux-xfs@vger.kernel.org>; Fri, 15 Nov 2024 15:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731684704; cv=none; b=DHeaHx2R+FyV1Z/g5RCfeaakVVXc8iJfi+RdmnoyhQFlK0+ciPx1CyYukNXf12aXn+Ht25v24iJCp53IEAv1mlSLW8dyrkk4xh3NlWZwpY4ZRxthN9IJPJ38PlEOFSaJeH5O9EFE3qRXlmDpLb63mtve7newu5eyM7KiDzxo2zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731684704; c=relaxed/simple;
	bh=wJBpuZKjarBs8HwRCSHfMpMBiZ+HVYWNz5ARDhZnhyo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGFT7obEaAzlAZDuyajHIgjDkmQ32XMh1lrdcCXr1X80fJdk+qwYgT03N3+JRoSVwsUwmKT7btvEFd4UNb4AzRVmSgVzbhIMLu1w2bxs/Zv52DFJKGbI3RpeQMKl7mbI/bQJnOUmYSTJ/7beOUycW7fnGLuWtHiZUPlp2RnKpmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=Sq+4zBoF; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="Sq+4zBoF"
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e38234cd4e0so919070276.2
        for <linux-xfs@vger.kernel.org>; Fri, 15 Nov 2024 07:31:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1731684701; x=1732289501; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QSuoTi14zhdgmEJ2e8nj/BNpHIFoytvzNxhl/LStwJg=;
        b=Sq+4zBoFR0URvFIUh05vyK1u/Sos3Fl7p0V25nCVbtRGaI1ZZ7MPG0l8yIpnHG2xku
         hLsR7o/CU2RIeJ1No5o1TdseUV+3KMkg1Nc7Ql7jrN008rcQUxmyWxjU3cTuiIoidMAp
         x1eOLg94bBNx+Zlzh+cfuYLHv1tQs20aWLioiHWnLzVRZCEMpTSQgXK1Gp+ew+hQsE4n
         rQz+uKar0RBr6XWNqwX8wUg4pHOXvBq4RM6oxBY0l9ocs1RFxLSWsgKZ+Iq3FvGw4Pxv
         tn6DKnzq3wDApu9o08yxEmIgKLVA28TLcfr2Qd3mqOLXriFVUs79/tKIf0sqPh5lReY+
         PUNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731684701; x=1732289501;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QSuoTi14zhdgmEJ2e8nj/BNpHIFoytvzNxhl/LStwJg=;
        b=U6EWLDxhzNhPNVFL2GeeFEuoEuYdKJuYmW/iWLNv5mh5jddzX+uF1r5APyb9Tgyj+W
         Y1lUI3+J4Wcfn22haZxuXUHpTN+fiDuemq5H991HcPg9RljFqUzibl1idu5D5kEiInrZ
         1Es2QZ0wSyY5lraYH3W+FOV/Fpf/J9cjPf3vyDrgNrwfb51ojT+EHgHnkbo3I2DlqjjN
         Z/LC/RHO9r75w68WnON5u2/4n9NyrZVFIPLn54jHh/oP5AE2kX8NHeGBTL0qFP2tEZ1q
         15+GBfLGkjbNhRsW8M70FTGOxnOCcC9MgyOnOPRgwG11JeXLYBRzj/hWPsqLHeHARZiK
         KRsg==
X-Forwarded-Encrypted: i=1; AJvYcCW7k5VjZgfogFQE6pZHH62Hxk5Vl27m2eq4VxjuJn+QpZYgn7C7YfqM892IqX4r4I9IQObPLxPXJgA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2Lnz0GZ0sQZdcnuYZBehs6oqv27g/WXftP5WH+CU7WuvPp1Ib
	kUzcrzAXUVBNi/OEy4TZB+Vw8EkKlANEPBmfDNLuOm9cBO/HKiEEyca/pIc2IotIAcfU21NIsle
	w
X-Google-Smtp-Source: AGHT+IHJEyVOG62NvWa9d1qggTtMCjzt+EKNCXFckK971VFGqKmUTAI/9H3Oo1mgh59gFKizdUDdeA==
X-Received: by 2002:a05:6902:1242:b0:e35:e173:3341 with SMTP id 3f1490d57ef6-e3825bdd813mr3265588276.0.1731684690002;
        Fri, 15 Nov 2024 07:31:30 -0800 (PST)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e38152c61d4sm989132276.5.2024.11.15.07.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 07:31:29 -0800 (PST)
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
Subject: [PATCH v8 05/19] fanotify: rename a misnamed constant
Date: Fri, 15 Nov 2024 10:30:18 -0500
Message-ID: <8776ab90fe538225aeb561c560296bafd16b97c4.1731684329.git.josef@toxicpanda.com>
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

FANOTIFY_PIDFD_INFO_HDR_LEN is not the length of the header.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/notify/fanotify/fanotify_user.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 8fca5ec442e4..456cc3e92c88 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -117,7 +117,7 @@ struct kmem_cache *fanotify_perm_event_cachep __ro_after_init;
 #define FANOTIFY_EVENT_ALIGN 4
 #define FANOTIFY_FID_INFO_HDR_LEN \
 	(sizeof(struct fanotify_event_info_fid) + sizeof(struct file_handle))
-#define FANOTIFY_PIDFD_INFO_HDR_LEN \
+#define FANOTIFY_PIDFD_INFO_LEN \
 	sizeof(struct fanotify_event_info_pidfd)
 #define FANOTIFY_ERROR_INFO_LEN \
 	(sizeof(struct fanotify_event_info_error))
@@ -172,14 +172,14 @@ static size_t fanotify_event_len(unsigned int info_mode,
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
 
@@ -501,7 +501,7 @@ static int copy_pidfd_info_to_user(int pidfd,
 				   size_t count)
 {
 	struct fanotify_event_info_pidfd info = { };
-	size_t info_len = FANOTIFY_PIDFD_INFO_HDR_LEN;
+	size_t info_len = FANOTIFY_PIDFD_INFO_LEN;
 
 	if (WARN_ON_ONCE(info_len > count))
 		return -EFAULT;
-- 
2.43.0

