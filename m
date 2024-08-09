Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03EF16938C
	for <linux-xfs@vger.kernel.org>; Fri,  9 Aug 2024 18:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723229111; cv=none; b=DvOURomy9bwciZKxrx1dt7xRxarJycwdTZFeELo/jV3UYtC96RbgSDjOsHQoX+lUQR/vLnEO3lH2jVmGP6s1S4f30uy7k5MXqOobd7bEiS1dFfvKC0nSJvuCs+dyEvSV2aNHZOfI2Wc8AaOVuX5EzJhKtfdwNapREUnZZpIBuDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723229111; c=relaxed/simple;
	bh=Q3VYbwM4CKv9HZE1IBds6JfYLVoY9EDuZvS5XcFcfQs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2Y9pjsYszBa/Tb5fYec5mZVlSq+cluvR5MzFArmKzNWGvhlGuqfltHPZ2//zGWeHVGUw3/cztqznc7BBZ+qMUt3dMJxIxwHv8Vb22VFaeMdxP+c7GhX81/YS0O29pcJhOoRYNNysKkW2YljXBnJVXNjB/2kB0U93ljvMIcmJDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=V8N8AXrc; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="V8N8AXrc"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-6b7a4668f1fso15761956d6.3
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2024 11:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723229108; x=1723833908; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IDO1PsR4jqBoDIDFjuXXy+JZDMdVbZ460dPfM2iRCeI=;
        b=V8N8AXrc8Tophwmdihr2jPqxq4jJHG9VIu4uh5zy64A/qCovGrFm6cVCbIdWMXGMet
         UBiiu48dAs/K24Z+jsdH1VglOykWrwFg52aw0FkboIDdWpw1kMja1ENTqmRum8/Rhpzl
         qrJKvtHDHoCNXFAkORf5JPGavFFttRqhodvfw4+7v5OsWH5uXq7FmTY8ViAFjqdVJYTm
         ptV4/016K9BeQXSl/m+WI+hV8qWlFt/NNCJFIaSkSvbtmZnOFzTBFtWWB3uGLO/F8FgK
         BBDbmYh2arQkm/HaeWsP8hYyTzbrIceOdpFWLIgd9bhWJcoKoINRwEqkyeqhj0mvLaU2
         fTNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723229108; x=1723833908;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IDO1PsR4jqBoDIDFjuXXy+JZDMdVbZ460dPfM2iRCeI=;
        b=TsVPq+KmfW094PF5Nmjb+DUp9Bjvbgcwu1ExXxcOFDnx2zZQKTx6zg+5Lwbjvgf2YP
         7VffS95SXOZVGuxUpj+UTxepyKgLGCsZ2hchLAKySO8tiWOF6KO0UxZ2+Badke9/tHH/
         LAD6ISd5km++ASUx7aYKR0tV90GwAnTfhPrvOR5SEyrZXqYJP4lcyDoM6i+BWdooGLyd
         TEf4FzaqB6/9JuYk8AkKwhQp601tpMZHSooOdin18qTrOB4F2mWAlmoodPiZqvqAXigb
         U5hsCUw7+OuXCUPbkrOf8QTK0Gtm4nA8LPk/RzPaqer4sfsmbjr4oJmqrY69Juqewzml
         VmNw==
X-Forwarded-Encrypted: i=1; AJvYcCUtfVnLvoTQMtt8/lZhNxwqXR7qvLd7FIUDe7ge9CJTlNOU08w664M9kp6yZmF4EhdDqhYbHS6W8GyJC1KW0Le9rDMZA8hKQNhA
X-Gm-Message-State: AOJu0YyRSve6TdOeCdAYS9x77CsYydWR1bUV8LID5A4YttVhGt4qX0Cg
	PsgBuGkFSKzhH/uCYiA3r9cmTb29PsiJi95h1f1Kw9NX9Yvvi+SBTHEnpoXnH88=
X-Google-Smtp-Source: AGHT+IH+QOHr1Jw95dRUxKTYJIvCuDQNdqmK16DNPDUQfuN+sirN+dzZW6uvQosVJ13qJ4kSzRWcFA==
X-Received: by 2002:a05:6214:2d4a:b0:6b5:a945:ec51 with SMTP id 6a1803df08f44-6bd78f29787mr25895386d6.51.1723229107924;
        Fri, 09 Aug 2024 11:45:07 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bd82e33ec9sm606886d6.77.2024.08.09.11.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 11:45:07 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 12/16] mm: don't allow huge faults for files with pre content watches
Date: Fri,  9 Aug 2024 14:44:20 -0400
Message-ID: <d6d0c9d4ccaeb559f4f51fdb1fb96880f890a665.1723228772.git.josef@toxicpanda.com>
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

There's nothing stopping us from supporting this, we could simply pass
the order into the helper and emit the proper length.  However currently
there's no tests to validate this works properly, so disable it until
there's a desire to support this along with the appropriate tests.

Reviewed-by: Christian Brauner <brauner@kernel.org>
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

