Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F12A1684B0
	for <linux-xfs@vger.kernel.org>; Fri,  9 Aug 2024 18:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723229113; cv=none; b=pmtbBsgWLOLa5Xmff1j514yP5PIhBnGtwmXh0mZ1L9ebOlPfGXa7ezsNtZvJWTRX8y+MH8K5jnq8K/6uqqFAUDsFVq8ez+lSJ6HSLHethyKEH1Ju7NOAux5jcWouH8wJE4JUJa+r/Jhnels9BjTD9MUTfXQeHFuT43FVd6J33/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723229113; c=relaxed/simple;
	bh=tscezQI1ZJCg3YAyrWCq2E/Rnm9shAFZx+qPWD9XbK0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JT9/Gs+k9nIrB7lYJDiqFKlmujYO/8j9Oh/SG/r0nzFWdk7cEqRoLes1/3TNPXMapSpvqahFzqfxpNcF+COUfQ8n6dyHN3yhbsapRXbZHXTN5HpBDEnkI45IAg+d9JTaN2DX4qG3eo2f/gVeLMZUJYDL2NhDOiiMDPTXwJPDc0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=scJeIcgm; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="scJeIcgm"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-70968db52d0so2478707a34.3
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2024 11:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723229109; x=1723833909; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tq/dxfAZjwPPjg1PG5V4muEOfHeX/hkEvWtSX3LI1so=;
        b=scJeIcgmAACKa+YUqKUr1x0PbeC4dJBq6CoG6CyxJI1rdF+RZO067gLerkLBYmfDEl
         FZ6G/dsKiUZG6hwmZb+nO5C48Xb288Z0qKulK1a4UwjZMUf3DUXCM76BQAvcy64faVH8
         0RHLuFCBjv26YIMbPK9jYBgOGwmZXuK5h/Z5ZCAuSwxTbpYdWeqmM7BwwS9FUmbUTMfW
         L5FKVUEFWQKfXtuCBoUaxTQ91EsHoR3422JKLNKTbrUl+IeYmpuIO7fcm6xxGs7MYBZp
         QqNzZ21ky2FZyFCbJx/chvWAjqyxqX9LVO+bJZvDtPTwVpPgZrT3FWlHOLIuGWcHlIcf
         NeAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723229109; x=1723833909;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tq/dxfAZjwPPjg1PG5V4muEOfHeX/hkEvWtSX3LI1so=;
        b=hTB4Ms3pnR52BOw7coIyWM3TojV8wk3YLhQ4rhIGXGj5/LTFJ9zjBXU1HshZy69LkN
         MaLoKMKeo9iF+j8N4r16A3HSNk3AGwKqw1R5HdONu0qHbY3CgpE59ysjE1/3Coji7f9c
         PNLbDNf683bkZlm4plilYiUJZqNaU5sRwTmtKrYHKO4lvbinDxnHyoCBnG6Wd3xEKn3W
         +z6mfH9lB/AZ3ru3i4k1XAcRzh4J8NXy1IW0f5fcp8lx0g3BIeuSKwYHlqVuzL3ZbnUn
         glVkooOvnDgn1eKifOv5rKmzbnvYoArPwPuQt0ds1A04M53RQBWBPejr+P4OWZN6Hco1
         9Miw==
X-Forwarded-Encrypted: i=1; AJvYcCVwQ/W5fz93CFsrGDg1ynsTf+T1sw/nuu21G/bd6USfHK0h64Bus61X/D/NQP3xqgbqc/C1MZt8OssyhwycLhph50IpTi65Rmmw
X-Gm-Message-State: AOJu0Yxaw4WICTx1PSVq+WKfeXTTI1FmuiMEhfU3ap+0yyrbN1TJFMSt
	UMQzgoCwawBuJRXXQrIng1FzDyr1UuXA0u6rHIq6vHewIfjqhhB/2YzMWqpvTub0aEt5jt9hwFC
	T
X-Google-Smtp-Source: AGHT+IG4F1TTOLqKZBLjNqn30DvFz+DenH6TfxlvQpGn5Qaps2ATLz43MqJvTKMM+vFDGDh7wVA2WQ==
X-Received: by 2002:a05:6358:528d:b0:1a8:b066:e266 with SMTP id e5c5f4694b2df-1b176f7d27bmr316265755d.13.1723229109039;
        Fri, 09 Aug 2024 11:45:09 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bd82c80132sm663116d6.42.2024.08.09.11.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 11:45:08 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 13/16] fsnotify: generate pre-content permission event on page fault
Date: Fri,  9 Aug 2024 14:44:21 -0400
Message-ID: <192b90df727e968ca3a17b6b128c10f3575bf6a3.1723228772.git.josef@toxicpanda.com>
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

FS_PRE_ACCESS or FS_PRE_MODIFY will be generated on page fault depending
on the faulting method.

This pre-content event is meant to be used by hierarchical storage
managers that want to fill in the file content on first read access.

Export a simple helper that file systems that have their own ->fault()
will use, and have a more complicated helper to be do fancy things with
in filemap_fault.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 include/linux/mm.h |   1 +
 mm/filemap.c       | 122 ++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 116 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index ab3d78116043..3e190f0a0997 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3503,6 +3503,7 @@ extern vm_fault_t filemap_fault(struct vm_fault *vmf);
 extern vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 		pgoff_t start_pgoff, pgoff_t end_pgoff);
 extern vm_fault_t filemap_page_mkwrite(struct vm_fault *vmf);
+extern vm_fault_t filemap_maybe_emit_fsnotify_event(struct vm_fault *vmf);
 
 extern unsigned long stack_guard_gap;
 /* Generic expand stack which grows the stack according to GROWS{UP,DOWN} */
diff --git a/mm/filemap.c b/mm/filemap.c
index 8b1684b62177..842e5138f98b 100644
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
@@ -3260,6 +3261,97 @@ static vm_fault_t filemap_fault_recheck_pte_none(struct vm_fault *vmf)
 	return ret;
 }
 
+/*
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
+static vm_fault_t __filemap_maybe_emit_fsnotify_event(struct vm_fault *vmf,
+						      struct file **fpin)
+{
+	struct file *file = vmf->vma->vm_file;
+	loff_t pos = vmf->pgoff << PAGE_SHIFT;
+	int mask = (vmf->flags & FAULT_FLAG_WRITE) ? MAY_WRITE : MAY_ACCESS;
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
+
+/**
+ * filemap_maybe_emit_fsnotify_event - maybe emit a pre-content event.
+ * @vmf:	struct vm_fault containing details of the fault.
+ *
+ * If we have a pre-content watch on this file we will emit an event for this
+ * range.  If we return anything the fault caller should return immediately, we
+ * will return VM_FAULT_RETRY if we had to emit an event, which will trigger the
+ * fault again and then the fault handler will run the second time through.
+ *
+ * Return: a bitwise-OR of %VM_FAULT_ codes, 0 if nothing happened.
+ */
+vm_fault_t filemap_maybe_emit_fsnotify_event(struct vm_fault *vmf)
+{
+	struct file *fpin = NULL;
+	vm_fault_t ret;
+
+	ret = __filemap_maybe_emit_fsnotify_event(vmf, &fpin);
+	if (ret) {
+		if (fpin)
+			fput(fpin);
+		return ret;
+	} else if (fpin) {
+		fput(fpin);
+		return VM_FAULT_RETRY;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(filemap_maybe_emit_fsnotify_event);
+
 /**
  * filemap_fault - read in file data for page fault handling
  * @vmf:	struct vm_fault containing details of the fault
@@ -3299,6 +3391,19 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 	if (unlikely(index >= max_idx))
 		return VM_FAULT_SIGBUS;
 
+	/*
+	 * If we have pre-content watchers then we need to generate events on
+	 * page fault so that we can populate any data before the fault.
+	 */
+	ret = __filemap_maybe_emit_fsnotify_event(vmf, &fpin);
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
@@ -3309,21 +3414,24 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
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

