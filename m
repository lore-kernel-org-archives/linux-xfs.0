Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69BC15ADB3
	for <linux-xfs@vger.kernel.org>; Fri,  9 Aug 2024 18:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723229109; cv=none; b=LmlmLkgURNJmHh4cFlJ0fUEXEECAWRVcM/e8DCXBAmd/FDbHJUw1e+XtpLSImH++7IXbjpMK/Kk+vg9T9v5SinA6ZGrCrISlHe5SFA3+Gnqe/rohnrFVVRWLBrCTeKDm6DM4bCvxoL5Q6nYTkLJSti2423VtBdnJ5q/xTLElZ4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723229109; c=relaxed/simple;
	bh=RuLIdPYLf2U7vdfwd0GY223a6ukGYtQumd4qAvMMF1s=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p56QfwEo7bra1nzdzqy0/WEvGJ7CYRMdyDO6l3GUQ8+U3k8umpny4nhTqAfco55o+3ctSttKMm2KSJENYaug9mybZRm1boV2VgboJMPyNbDOb7LXG9YCudF77KMhWxlMu6z4VOc8yq+uQXEkYgarf8NjOMThlMgNubwwTdkV36c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=1Z68r27p; arc=none smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="1Z68r27p"
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-4f8b5e4c631so959178e0c.1
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2024 11:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723229107; x=1723833907; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NQ0y3/dQBSJxG2OyPRkhEh3Vj0wjByustgiYia+MZqs=;
        b=1Z68r27pkT1+us4f0kum+/ryDNAeQyI7UCxuMsF6pSBvR36UFPuhoMjqYBxGm+JiP9
         QuA5OhdsTJAKbhnGl3nY6E4WXZ+exI2wtkGoG4mPi6tdPmWsuSPTwGdTvi4cLsHCNUQ6
         EeyE2l+viEzzo3dG14jfba8gyqFOgaseF+ENE8daD5MzI2avaEhshNI4rB0ZrsfUqEjP
         +c75i41RHZKtb9imBJ15j4gMwagM3IxhLgNbD9mmjJWGCAl2G+HaOaALrV4AuNHdZsxf
         ef5OwS4xeU+eAvr141hd2bqvsNb9njaIZUPNe1/X9YJXgUw0BthB2juL/ddRqEPkUfGl
         0wYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723229107; x=1723833907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NQ0y3/dQBSJxG2OyPRkhEh3Vj0wjByustgiYia+MZqs=;
        b=t57pnRpzn7t9cvsuFszCZFyEB5ZKRcav/mgj89IH3uUAoa8eTBvodvrMdkiZFTxJep
         7SQ5STzVij5L8Bw0F+/um7/f6Mw9/9yqcr+otIXdxcAgL+MAG64rSwMY7Ipvp5ucvGYU
         tPFQrl42AOu6G6VHilQfHHVXz4GU+a+u1o0gS5GKlkMSrI89T700LQgFDgSLFZvKtrAm
         ysP2XKb0QfNM+LAYQzb39s3kkK1hFL++3y7GZLW0B2oy3BNNu2K3iIASAx9os1OSUVpV
         NAuNP6UPYAQNGsYmtNKghtHroFc656hZhhQgXSlibZERkcvKlLz7trDl/YI47N14ewg2
         G89A==
X-Forwarded-Encrypted: i=1; AJvYcCXwk6tR+UwQcNSYrGXpQdDRNGbU6vsp2sc7M2AdT2P/jznnxucUhN5SYfOqbT6YQvs8A3eAoNh8j7pTXOV0GmR3Xf1E49z0HhsA
X-Gm-Message-State: AOJu0Yx6GZof/Q3gUdoZTv4d6Qf2rnySY8rN4mRoyxQrB8CiFiFxM2O0
	LDPrAS/MgGKuWVDplATpjqyl38RaU1m/SlT3gvsZN6EH50XFk77RHTkWxTU7Y/U=
X-Google-Smtp-Source: AGHT+IGUWdpCO0sBCfPtcyZHbJHTY/osXSdQ3Pyi+lrF8mR+tISGnHR7UyJz8usggEUqavTayntxAQ==
X-Received: by 2002:a05:6122:7d4:b0:4f6:a5ed:eb11 with SMTP id 71dfb90a1353d-4f912dfd583mr3098244e0c.8.1723229106822;
        Fri, 09 Aug 2024 11:45:06 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a4c7d71cf9sm4378885a.44.2024.08.09.11.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 11:45:06 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v3 11/16] fanotify: disable readahead if we have pre-content watches
Date: Fri,  9 Aug 2024 14:44:19 -0400
Message-ID: <9a458c9c553c6a8d5416c91650a9b152458459d0.1723228772.git.josef@toxicpanda.com>
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

With page faults we can trigger readahead on the file, and then
subsequent faults can find these pages and insert them into the file
without emitting an fanotify event.  To avoid this case, disable
readahead if we have pre-content watches on the file.  This way we are
guaranteed to get an event for every range we attempt to access on a
pre-content watched file.

Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 mm/filemap.c   | 12 ++++++++++++
 mm/readahead.c | 13 +++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index ca8c8d889eef..8b1684b62177 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3122,6 +3122,14 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 	unsigned long vm_flags = vmf->vma->vm_flags;
 	unsigned int mmap_miss;
 
+	/*
+	 * If we have pre-content watches we need to disable readahead to make
+	 * sure that we don't populate our mapping with 0 filled pages that we
+	 * never emitted an event for.
+	 */
+	if (fsnotify_file_has_pre_content_watches(file))
+		return fpin;
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	/* Use the readahead code, even if readahead is disabled */
 	if ((vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER) {
@@ -3190,6 +3198,10 @@ static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
 	struct file *fpin = NULL;
 	unsigned int mmap_miss;
 
+	/* See comment in do_sync_mmap_readahead. */
+	if (fsnotify_file_has_pre_content_watches(file))
+		return fpin;
+
 	/* If we don't want any read-ahead, don't bother */
 	if (vmf->vma->vm_flags & VM_RAND_READ || !ra->ra_pages)
 		return fpin;
diff --git a/mm/readahead.c b/mm/readahead.c
index 817b2a352d78..bc068d9218e3 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -128,6 +128,7 @@
 #include <linux/blk-cgroup.h>
 #include <linux/fadvise.h>
 #include <linux/sched/mm.h>
+#include <linux/fsnotify.h>
 
 #include "internal.h"
 
@@ -674,6 +675,14 @@ void page_cache_sync_ra(struct readahead_control *ractl,
 {
 	bool do_forced_ra = ractl->file && (ractl->file->f_mode & FMODE_RANDOM);
 
+	/*
+	 * If we have pre-content watches we need to disable readahead to make
+	 * sure that we don't find 0 filled pages in cache that we never emitted
+	 * events for.
+	 */
+	if (ractl->file && fsnotify_file_has_pre_content_watches(ractl->file))
+		return;
+
 	/*
 	 * Even if readahead is disabled, issue this request as readahead
 	 * as we'll need it to satisfy the requested range. The forced
@@ -704,6 +713,10 @@ void page_cache_async_ra(struct readahead_control *ractl,
 	if (!ractl->ra->ra_pages)
 		return;
 
+	/* See the comment in page_cache_sync_ra. */
+	if (ractl->file && fsnotify_file_has_pre_content_watches(ractl->file))
+		return;
+
 	/*
 	 * Same bit is used for PG_readahead and PG_reclaim.
 	 */
-- 
2.43.0

