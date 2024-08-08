Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBA015F3E2
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 19:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723145314; cv=none; b=DZGteOHqMX4nOFPplQYToo4gdt9homnYmu/bagEdYOrNH+CmhApa/U4eJoUAIE5/jijdRNngVJBWu9gV4DB6T+5ZFjCc2uZ0UXIjPxcMLOQBcEYrsZJ6CefIjaKe0A+BbKkOSRDwe3iqUL2CqfreF/hFobJw0m6AZooi0nml1y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723145314; c=relaxed/simple;
	bh=SRLbOqJ8zAl5qD12oNCtm7iiNr2HczkPZnZesiep1gI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ESzuapz/g0JKpJZJgxUKadfXw+mN2R/TuXRCUu/+dTH7+llYfg1gxxug9dVw/u5L/x2IqCzXBbQ64UDZY6b04UXpT0eEVXPZnJgX2ZafdoM4L3xVasZz4hA9c07Uapo7574L8ZfGHmto0AMJZDHTWQrVekPXUyK7qoc2Nd+z4D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=f8azxr/1; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="f8azxr/1"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6b7a8cada97so8040716d6.3
        for <linux-xfs@vger.kernel.org>; Thu, 08 Aug 2024 12:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723145312; x=1723750112; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CZ0oLpoVqilzi+VChanZFK4WtdGvxjCPwQLhvVUYV3Q=;
        b=f8azxr/13vGJspiin4z3X62CCrN8u+PfWvvu8j5ETd/tbAHMcZxzgqMAsS+jkqYCHD
         Hds6Lj6IIQHPfBlW09CPtfF+PknQeNQSSp4U+NaVe8hn3yZPOVcqcwXyK9o1PUaiXShs
         s20nZOeRBLvUD3OQD6CYyEH5v6EdtTk2wJRMx28BWGtr395/zSxP5pcfQOizfO3uPK84
         UocQJvifAaWTCvvtUiBLT9owoGR3ThKc0mf9zPe9imKse9KIyfXqnyu75a1Gvqi7Ft4l
         rGy8iAH+6yjXFWitwKLeWkQvvxI0BIHrO0xXVMHRzmoKz3uMS/xKadbIyvge25Opmg4B
         KKaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723145312; x=1723750112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CZ0oLpoVqilzi+VChanZFK4WtdGvxjCPwQLhvVUYV3Q=;
        b=p9LRzY7DJJLYOdE+U3SsKyA7Qdl7FtoJWmUCcUER1yfSvMDXtzXvahwdUbfxuUt999
         XxzqD7bTAn37+Df8EM4d9T6tahMdCE2XTb35h7YZjk6pFRgiyIUFXLQfNbOcfOhqMqVC
         g2RGUmcEiI8jsfhNPW+RX9TLeWqtCCk4aBblwHnJjBtGG1hJtbQmxwF6Y4y8rZ8nxzjj
         tFf6Te+urEivJd4Y7hM76+wNFrFsUCgsqDI35oZKpaQittQuCTbbu/ffHYmNTEcS5iUR
         /Hh32SsRKVGQruc9Q19povMqqiq1R36cCrpu+eYtr7kN+pNTpDJUJZ3/iTesvu9JNLnn
         8gyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZfjz8Y2qL9lLPiO89QrB7hcRccB5GkmqltBFDWhW7k5uah4AOVi7fvFvIKOaARUB/lVhBCRqqqfLiN0FEcxcGy604eRFAu6EC
X-Gm-Message-State: AOJu0YxfV+KTqwKQ9RcVs3sAYOm4MPq3ruCBcVUbbsuMyEFY0DowvwOB
	WiiryD+MtwdFsqhEMO/s8MRclro1Uizi0nmZBNV17t98cD054TB0RHLnxrkN2YY=
X-Google-Smtp-Source: AGHT+IFCnvBLMQYwV4xdiQDtXkQ4ye2f9PGHfgns1lK+Hj5Gxr/FET7hfoWmkMYm+Nx3ymsaFXyQDA==
X-Received: by 2002:a05:6214:5687:b0:6bb:b1b7:a690 with SMTP id 6a1803df08f44-6bd6bce1ea6mr31418406d6.22.1723145311777;
        Thu, 08 Aug 2024 12:28:31 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bb9c839ee1sm69475856d6.89.2024.08.08.12.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 12:28:31 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v2 12/16] mm: don't allow huge faults for files with pre content watches
Date: Thu,  8 Aug 2024 15:27:14 -0400
Message-ID: <8b4c1abeff52322da354a4df2881ec13b7493fdd.1723144881.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1723144881.git.josef@toxicpanda.com>
References: <cover.1723144881.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There's nothing stopping us from supporting this, we could simply pass
the order into the helper and emit the proper length.  However currently
there's no tests to validate this works properly, so disable it until
there's a desire to support this along with the appropriate tests.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 mm/memory.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index d10e616d7389..3010bcc5e4f9 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -78,6 +78,7 @@
 #include <linux/ptrace.h>
 #include <linux/vmalloc.h>
 #include <linux/sched/sysctl.h>
+#include <linux/fsnotify.h>
 
 #include <trace/events/kmem.h>
 
@@ -5252,8 +5253,17 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
 static inline vm_fault_t create_huge_pmd(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
+	struct file *file = vma->vm_file;
 	if (vma_is_anonymous(vma))
 		return do_huge_pmd_anonymous_page(vmf);
+	/*
+	 * Currently we just emit PAGE_SIZE for our fault events, so don't allow
+	 * a huge fault if we have a pre content watch on this file.  This would
+	 * be trivial to support, but there would need to be tests to ensure
+	 * this works properly and those don't exist currently.
+	 */
+	if (file && fsnotify_file_has_pre_content_watches(file))
+		return VM_FAULT_FALLBACK;
 	if (vma->vm_ops->huge_fault)
 		return vma->vm_ops->huge_fault(vmf, PMD_ORDER);
 	return VM_FAULT_FALLBACK;
@@ -5263,6 +5273,7 @@ static inline vm_fault_t create_huge_pmd(struct vm_fault *vmf)
 static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
+	struct file *file = vma->vm_file;
 	const bool unshare = vmf->flags & FAULT_FLAG_UNSHARE;
 	vm_fault_t ret;
 
@@ -5277,6 +5288,9 @@ static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
 	}
 
 	if (vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) {
+		/* See comment in create_huge_pmd. */
+		if (file && fsnotify_file_has_pre_content_watches(file))
+			goto split;
 		if (vma->vm_ops->huge_fault) {
 			ret = vma->vm_ops->huge_fault(vmf, PMD_ORDER);
 			if (!(ret & VM_FAULT_FALLBACK))
@@ -5296,9 +5310,13 @@ static vm_fault_t create_huge_pud(struct vm_fault *vmf)
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) &&			\
 	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
 	struct vm_area_struct *vma = vmf->vma;
+	struct file *file = vma->vm_file;
 	/* No support for anonymous transparent PUD pages yet */
 	if (vma_is_anonymous(vma))
 		return VM_FAULT_FALLBACK;
+	/* See comment in create_huge_pmd. */
+	if (file && fsnotify_file_has_pre_content_watches(file))
+		return VM_FAULT_FALLBACK;
 	if (vma->vm_ops->huge_fault)
 		return vma->vm_ops->huge_fault(vmf, PUD_ORDER);
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
@@ -5310,12 +5328,16 @@ static vm_fault_t wp_huge_pud(struct vm_fault *vmf, pud_t orig_pud)
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) &&			\
 	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
 	struct vm_area_struct *vma = vmf->vma;
+	struct file *file = vma->vm_file;
 	vm_fault_t ret;
 
 	/* No support for anonymous transparent PUD pages yet */
 	if (vma_is_anonymous(vma))
 		goto split;
 	if (vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) {
+		/* See comment in create_huge_pmd. */
+		if (file && fsnotify_file_has_pre_content_watches(file))
+			goto split;
 		if (vma->vm_ops->huge_fault) {
 			ret = vma->vm_ops->huge_fault(vmf, PUD_ORDER);
 			if (!(ret & VM_FAULT_FALLBACK))
-- 
2.43.0

