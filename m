Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BF71CB328
	for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 21:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723670782; cv=none; b=d/Bpa82zVJAksV56qDAV+p1tTaWAcqhHAlFhn2PBpAhPViESfdlaEOG06xYHIJK5F9qT9SyaosK/GU3OwoeykUU3KgSFLLZT4NngXboNJt4Ns+tAbzkCiRr84lcSbsPGPDm0eoJ9KTScgxr6GNb29Jpiy+KzhF0TW/nVsiqfa20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723670782; c=relaxed/simple;
	bh=Q3VYbwM4CKv9HZE1IBds6JfYLVoY9EDuZvS5XcFcfQs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=McaEtXb58PVoItMEgqN6dAgKWB4SlnJgGrVeND79s+SXiptZHVI+N5KN/EBgH/SAZXtED19uF9x8++7plgykarhGRcSzeLq2zr607KJfBR2NjAzb8OdQTbvglWfFpictgWtjLrAHMskNhznJEdOyaCGqaRwGpQFUNKdvX/5BzRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=mcy8xQ02; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="mcy8xQ02"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6b796667348so2710336d6.0
        for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 14:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723670777; x=1724275577; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IDO1PsR4jqBoDIDFjuXXy+JZDMdVbZ460dPfM2iRCeI=;
        b=mcy8xQ02p/JaqYsO93gXjfPGPL74527c3uuV4cPmWoCO/cYJQdbTJRv1csIjjNBKyf
         OysPrIfSYD24PRfBHdVcf9ZAMTUt2NqnBosilpsx2pbGyTOBE/hvIILeFuTR4Aw/2I61
         d/VdJEa7oeNhOT27Rjk7K+kGBLEO4PX8j5xL2Sb3NZJpNyS3cpTg5/hiR5O1rEvZEqcJ
         5HmOTyvEAsb7prXKqXe+3kY10hG62OELDCAufYtkHBiQUEYtsv3Bzz2jSq4/C3Jw3Cp6
         10f4D82SVs+LWw1nr44omqwjQu16HxkSE28pIDDSZPfNz/hlHNTS+afxmo+r21et0IeD
         8Ymg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723670777; x=1724275577;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IDO1PsR4jqBoDIDFjuXXy+JZDMdVbZ460dPfM2iRCeI=;
        b=KcGCgNszLY/NSbcFzQVft1WsCT2gjkOvLwO4pZe+EjSSLmk+pARawuKBxfzC6LrZop
         MrCxtDRYLcvNqUt0ggxN4nRXslV3wzdGeu5+qBT0FgOf/jr/WLxx4oDZ25N2RHDzBDVH
         4HAWoFwYq04M4vTKGx2mWWicAMzB5IzjUmzJ3afwF7/cSJyjYPNFMoh/2bwoVgqNza3w
         kRJh7l16wSgs+Bgjtl7A7wPz6NuMGeVJkG+HXzJMZ3JI5ZzTWQoJHXTF75Us4sTkMpyW
         eQqPC+okmd/yl1CboV5pcXeklehR9AQLfclwuve9Dllz+sWLXcaQ4eq+HMtdGJk3CLFs
         8E2Q==
X-Forwarded-Encrypted: i=1; AJvYcCW206f3s3WqRepO8dtGujeS4x3Ow5JpZaguB+6yNdjsuChY3EWO6JIL0IIYVYORduw21RlZ0VI8VCg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4iI1IyS1wQl87ovKQ09j9wBcxjlSXEq6xCvHUGNe3tHsyC86L
	j0TU/yqV/TSSFxHd8/2Oz1zP2tfD3o1FmNLh177fyZ8HKEHKOoUG/D/V1qftfNE=
X-Google-Smtp-Source: AGHT+IGeO0B2k6JtijtGgt8cNjSSZOq15LBjH6uKw7eaOrAdoCnw1rPT9UcRCivz4wM3Sne6FWLZ5g==
X-Received: by 2002:a05:6214:cc6:b0:6b7:9a0a:33db with SMTP id 6a1803df08f44-6bf6de4eadfmr15035046d6.23.1723670777161;
        Wed, 14 Aug 2024 14:26:17 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-45369fd7943sm572041cf.20.2024.08.14.14.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 14:26:16 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v4 12/16] mm: don't allow huge faults for files with pre content watches
Date: Wed, 14 Aug 2024 17:25:30 -0400
Message-ID: <d6d0c9d4ccaeb559f4f51fdb1fb96880f890a665.1723670362.git.josef@toxicpanda.com>
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

