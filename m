Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA1C15F41D
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 19:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723145316; cv=none; b=M+Us9A4p+I5p3w3iocHfLM3qrIya46atlnVQzvMAnVz37IhFwQh/wTd/4XM2ee7LaxbbXbytoviBT8MIh/mTSQewiUeHXIVTQhqF3n8GAiVQncPmROu4woesCGFb+gon/wTLWKN++RwTyk9CvwJaZV0yO+LQoDr1s7zgKASYCxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723145316; c=relaxed/simple;
	bh=QxwPx/y8cQKYt0urtviHOcv6Dke8kHBSjkLFA9JU5oY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tXzyXdg3a080DXdWzfaklSsvaahOunmZElO2jetYZMx8bgIxGU+zemhNcPGg1DHWTyb8z1/LmW2YcvNYIzvWSZqCzwvHbbgNve0HVH/LYCfO+o1fT0ZDsesmaA1LnXqVdUDhEliv4GgKqrDWjLcRiqng+D0g4SAe5lHpIXDvYJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=xePCLMjo; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="xePCLMjo"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7a1dcba8142so175843985a.0
        for <linux-xfs@vger.kernel.org>; Thu, 08 Aug 2024 12:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723145313; x=1723750113; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bvi8Rvhrw8hau65mccNHsPcN1GGNLITREHvwNWenIGo=;
        b=xePCLMjo9bKQOYBS3zYObj/6DOZYMYgWGOXKI+QVjvzLFzt39OM/varGzge5Vwt2Oj
         Jo1YQmHyxAAeDuSocdjg8ZUyS7rCqV1AXIdy3CucTy0Ad5u6hIcouNNhX7u5T++DhRvG
         wATXu02Bp/zggHdaqOunW+/ssKhDneZhyESiQWr/tiq04k/XcycJG2jOMVUE8oa+dnNR
         yjDSlpgRXBEnjqcd4XWbXluVbv2gXAJ7YmqhvsPQz29eai64urb5pQlhfKQNGHiEmzCU
         rzOirmnPNdxvDZbv8LDYmxJQ+gDxlQljjsZjh4XMdkUo0k35ZT289vhLv6/DG3dkUcPa
         ybKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723145313; x=1723750113;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bvi8Rvhrw8hau65mccNHsPcN1GGNLITREHvwNWenIGo=;
        b=rstQQwvBK9OoNSxpontu2Au8Z/I5Zg7sTBSHjPkSNSLz8qBYhfstNuKw2Q+pHVzuhV
         pOpyfCG6bW3I12HLLgf7hNaMJLkt0Ae5EoNOhEh6xgnl5qPgtjmUQ9/jCY2I2t3C3uD+
         LNeiYJPc0yhMG+jy7doKrdFTKma3jtteByIVPqv0M8rzIDFpoVeX9ThR8D6Tj2V67VUY
         0SsQfJ1OKMNKRyLYKEYUly/HqIlJk/I3dIOyt/Ezjl4e2FYq87YsDKQoOZ+j2ZQ2uD3P
         oDUZ1yOB9uHjebYvKm7TMknvjTsDwizwvwCMXediJbo/fFvYOgD8GTpv56sSDlR5sZMi
         43/w==
X-Forwarded-Encrypted: i=1; AJvYcCXa1mD0OzzNA4jqgvvT4IeupMcxHARzh3Yg4+QhoGHcOlM3NOKDYWEELu8Iy7CTw/yq67ri3agx3ZsWrGhgbUBIrY7rDQPvPXIQ
X-Gm-Message-State: AOJu0YwBz4k/he2AgSovnuJVsvcx7NXcD/fD4jxXkNZ4QfLGG9gkhikq
	HjYnT4XDWETMMJP1+pIc/AlMaOiZP2zNsJXlUzAOetVQpr/HnSi4WvmnQxl9QLo=
X-Google-Smtp-Source: AGHT+IHg5LiBxHcCbfRpZx/vfgLSV1DWqamdnXjHqSd3YJqdZjtNT3V/jkh6Hvbl6Y9gLBaUnNrkIQ==
X-Received: by 2002:a05:620a:1917:b0:7a1:dc64:59db with SMTP id af79cd13be357-7a3824762c9mr447120385a.8.1723145312983;
        Thu, 08 Aug 2024 12:28:32 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a378693d23sm188152785a.87.2024.08.08.12.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 12:28:32 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v2 13/16] fsnotify: generate pre-content permission event on page fault
Date: Thu,  8 Aug 2024 15:27:15 -0400
Message-ID: <b8c3f0d9ed6d23f9a636919e28293cdbbe22e0db.1723144881.git.josef@toxicpanda.com>
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

FS_PRE_ACCESS or FS_PRE_MODIFY will be generated on page fault depending
on the faulting method.

This pre-content event is meant to be used by hierarchical storage
managers that want to fill in the file content on first read access.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 include/linux/mm.h |  2 +
 mm/filemap.c       | 97 ++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 92 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index ab3d78116043..c33f3b7f7261 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3503,6 +3503,8 @@ extern vm_fault_t filemap_fault(struct vm_fault *vmf);
 extern vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 		pgoff_t start_pgoff, pgoff_t end_pgoff);
 extern vm_fault_t filemap_page_mkwrite(struct vm_fault *vmf);
+extern vm_fault_t filemap_maybe_emit_fsnotify_event(struct vm_fault *vmf,
+						    struct file **fpin);
 
 extern unsigned long stack_guard_gap;
 /* Generic expand stack which grows the stack according to GROWS{UP,DOWN} */
diff --git a/mm/filemap.c b/mm/filemap.c
index 8b1684b62177..3d232166b051 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -46,6 +46,7 @@
 #include <linux/pipe_fs_i.h>
 #include <linux/splice.h>
 #include <linux/rcupdate_wait.h>
+#include <linux/fsnotify.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include "internal.h"
@@ -3112,13 +3113,13 @@ static int lock_folio_maybe_drop_mmap(struct vm_fault *vmf, struct folio *folio,
  * that.  If we didn't pin a file then we return NULL.  The file that is
  * returned needs to be fput()'ed when we're done with it.
  */
-static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
+static struct file *do_sync_mmap_readahead(struct vm_fault *vmf,
+					   struct file *fpin)
 {
 	struct file *file = vmf->vma->vm_file;
 	struct file_ra_state *ra = &file->f_ra;
 	struct address_space *mapping = file->f_mapping;
 	DEFINE_READAHEAD(ractl, file, ra, mapping, vmf->pgoff);
-	struct file *fpin = NULL;
 	unsigned long vm_flags = vmf->vma->vm_flags;
 	unsigned int mmap_miss;
 
@@ -3190,12 +3191,12 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
  * was pinned if we have to drop the mmap_lock in order to do IO.
  */
 static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
-					    struct folio *folio)
+					    struct folio *folio,
+					    struct file *fpin)
 {
 	struct file *file = vmf->vma->vm_file;
 	struct file_ra_state *ra = &file->f_ra;
 	DEFINE_READAHEAD(ractl, file, ra, file->f_mapping, vmf->pgoff);
-	struct file *fpin = NULL;
 	unsigned int mmap_miss;
 
 	/* See comment in do_sync_mmap_readahead. */
@@ -3260,6 +3261,72 @@ static vm_fault_t filemap_fault_recheck_pte_none(struct vm_fault *vmf)
 	return ret;
 }
 
+/**
+ * filemap_maybe_emit_fsnotify_event - maybe emit a pre-content event.
+ * @vmf:	struct vm_fault containing details of the fault.
+ * @fpin:	pointer to the struct file pointer that may be pinned.
+ *
+ * If we have pre-content watches on this file we will need to emit an event for
+ * this range.  We will handle dropping the lock and emitting the event.
+ *
+ * If FAULT_FLAG_RETRY_NOWAIT is set then we'll return VM_FAULT_RETRY.
+ *
+ * If no event was emitted then *fpin will be NULL and we will return 0.
+ *
+ * If any error occurred we will return VM_FAULT_SIGBUS, *fpin could still be
+ * set and will need to have fput() called on it.
+ *
+ * If we emitted the event then we will return 0 and *fpin will be set, this
+ * must have fput() called on it, and the caller must call VM_FAULT_RETRY after
+ * any other operations it does in order to re-fault the page and make sure the
+ * appropriate locking is maintained.
+ *
+ * Return: the appropriate vm_fault_t return code, 0 on success.
+ */
+vm_fault_t filemap_maybe_emit_fsnotify_event(struct vm_fault *vmf,
+					     struct file **fpin)
+{
+	struct file *file = vmf->vma->vm_file;
+	loff_t pos = vmf->pgoff << PAGE_SHIFT;
+	int mask = (vmf->flags & FAULT_FLAG_WRITE) ? MAY_WRITE : MAY_READ;
+	int ret;
+
+	/*
+	 * We already did this and now we're retrying with everything locked,
+	 * don't emit the event and continue.
+	 */
+	if (vmf->flags & FAULT_FLAG_TRIED)
+		return 0;
+
+	/* No watches, return NULL. */
+	if (!fsnotify_file_has_pre_content_watches(file))
+		return 0;
+
+	/* We are NOWAIT, we can't wait, just return EAGAIN. */
+	if (vmf->flags & FAULT_FLAG_RETRY_NOWAIT)
+		return VM_FAULT_RETRY;
+
+	/*
+	 * If this fails then we're not allowed to drop the fault lock, return a
+	 * SIGBUS so we don't errantly populate pagecache with bogus data for
+	 * this file.
+	 */
+	*fpin = maybe_unlock_mmap_for_io(vmf, *fpin);
+	if (*fpin == NULL)
+		return VM_FAULT_SIGBUS | VM_FAULT_RETRY;
+
+	/*
+	 * We can't fput(*fpin) at this point because we could have been passed
+	 * in fpin from a previous call.
+	 */
+	ret = fsnotify_file_area_perm(*fpin, mask, &pos, PAGE_SIZE);
+	if (ret)
+		return VM_FAULT_SIGBUS;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(filemap_maybe_emit_fsnotify_event);
+
 /**
  * filemap_fault - read in file data for page fault handling
  * @vmf:	struct vm_fault containing details of the fault
@@ -3299,6 +3366,19 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 	if (unlikely(index >= max_idx))
 		return VM_FAULT_SIGBUS;
 
+	/*
+	 * If we have pre-content watchers then we need to generate events on
+	 * page fault so that we can populate any data before the fault.
+	 */
+	ret = filemap_maybe_emit_fsnotify_event(vmf, &fpin);
+	if (unlikely(ret)) {
+		if (fpin) {
+			fput(fpin);
+			ret |= VM_FAULT_RETRY;
+		}
+		return ret;
+	}
+
 	/*
 	 * Do we have something in the page cache already?
 	 */
@@ -3309,21 +3389,24 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 		 * the lock.
 		 */
 		if (!(vmf->flags & FAULT_FLAG_TRIED))
-			fpin = do_async_mmap_readahead(vmf, folio);
+			fpin = do_async_mmap_readahead(vmf, folio, fpin);
 		if (unlikely(!folio_test_uptodate(folio))) {
 			filemap_invalidate_lock_shared(mapping);
 			mapping_locked = true;
 		}
 	} else {
 		ret = filemap_fault_recheck_pte_none(vmf);
-		if (unlikely(ret))
+		if (unlikely(ret)) {
+			if (fpin)
+				goto out_retry;
 			return ret;
+		}
 
 		/* No page in the page cache at all */
 		count_vm_event(PGMAJFAULT);
 		count_memcg_event_mm(vmf->vma->vm_mm, PGMAJFAULT);
 		ret = VM_FAULT_MAJOR;
-		fpin = do_sync_mmap_readahead(vmf);
+		fpin = do_sync_mmap_readahead(vmf, fpin);
 retry_find:
 		/*
 		 * See comment in filemap_create_folio() why we need
-- 
2.43.0

