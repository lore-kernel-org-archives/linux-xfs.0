Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D4615FCE5
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 19:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723145316; cv=none; b=mgmtvQcNn4NJiTu/CFO6OyiugtYRK1L6WQPzrfwTolA9tSxtSjT1L9q+LCJZcZszLQrqMzp9DG6/dI9BeU0RHuoFeU17EQ/RKajoshqZK1LO5njcktAp/mXeEvfi+31glSrkWhxtZhfX7LfiTIj3iQQUiE6XqyNkG6a3TZPLNFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723145316; c=relaxed/simple;
	bh=z/3MEM5R7oglWCH0X6//tWx2TfoPHx5BV2T8P5cTJQk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T02nN6kHh4Lo/B3Vk6a1ik4GHAusRsygy0J4JmwPyTm/Kzj4H35FWFoBkYDgAPe3KPBIdylvBea1sIFCJkSzy2nGi1wHtxB0AOqOernIfk+uB40Rfp3E+ccpMoICZunwlqI7reLUY3rZrWmsR0Et3QfzfgVNcjgEu9dolBoh5mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=VG7mshXD; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="VG7mshXD"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7a1d42da3baso90742085a.1
        for <linux-xfs@vger.kernel.org>; Thu, 08 Aug 2024 12:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1723145314; x=1723750114; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6YLadnK5fpBDv1t3bY/aSRwCYBZfpbYWzdBOoO1tjFE=;
        b=VG7mshXDEFU4+vK5516DIMQYe0XsvDKJD7MFTIxYGRv+tzYX6CQMXqs/r1bkr9vJq9
         2p543T/5Vaci1JV8vh5X7UTVUpVT9JhLOPgZ/UgcIasyMsjdExVmZQfEI6iFfbhHZ8F0
         FD+zY2NJL4zgTv1ors0OrtblaTOiTKq2g2TB9F/ibrDU2zhPnp2qAawJ3+wxy7GZ6bkA
         ijCF1b1Lp7G7aaZwhCRfwtSqBw0bjdC/n0EXAoJ4iyuDL4EcFVLp6fX8Kg9JqeVgc41e
         iwtpwpV/EvUb46JpID2RfSNRmtWPC4Xizz85abzZI8xxoJhBjMLZ0OJMezNA9noZcG0H
         dzHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723145314; x=1723750114;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6YLadnK5fpBDv1t3bY/aSRwCYBZfpbYWzdBOoO1tjFE=;
        b=VVeQHmIuzGmz+MSEzHxY0glZwrRq7i4Tj4FySeJ/EpxqAu7PjMYzArRdadFWY6KllZ
         ZMRACk9NtRBa4DR8C2kL8mFEVs+z6rlu4iG5Zs+67ecBT9yncb0Ob1Qh2q54s6qf/Flb
         3FWMtrJ0yJEhBkq59TBBqageNpbkw+QYu1J+c6HB/WUePnwYeTtLYxGkRstd9xebCd7C
         GFv0MJbZTZjVq1RxXEnmJ5CyStIi4cqX5G33g1ZhnNNWk80NXUqHZBo/+ezgDNU9HitN
         2swKgym32Ani/6JD0gVT1KEx8H+4hM7FzQElQRZCxrCATWMggDFzW6otvR/1vGNUkaXA
         g6Mw==
X-Forwarded-Encrypted: i=1; AJvYcCXzdszWuPU4XOGu1DhbIBZeg/vOPzXc6eo9lQmE3TYoMPl9wpur6Fy8Tj1aSMcH/8du7IOxrWxZDVdAN6bofYwkf6dV4sMBpTAt
X-Gm-Message-State: AOJu0YzYfpfHOEiDoO26YmSRSPam2eXF6PSf51n48jEkcx2BWbwf4Y21
	8OR4YK7FM0tq9UArbOviYHj9b+K8AL30b+Bltl35M/VyfKLBFcmhhgFkcyUX8Ns=
X-Google-Smtp-Source: AGHT+IGnhyiOZnALMvi26eVvjGx6xQxis4L0ZCZvKEWqHg1OHyJN3CwJxtYZ6LVYWXuIgBD+VdomqA==
X-Received: by 2002:a05:620a:17a1:b0:79f:8f3:6ad4 with SMTP id af79cd13be357-7a3817eeaf6mr419940585a.1.1723145314246;
        Thu, 08 Aug 2024 12:28:34 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a3786c1cc5sm187457885a.104.2024.08.08.12.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 12:28:33 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com,
	linux-fsdevel@vger.kernel.org,
	jack@suse.cz,
	amir73il@gmail.com,
	brauner@kernel.org,
	linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-bcachefs@vger.kernel.org
Subject: [PATCH v2 14/16] bcachefs: add pre-content fsnotify hook to fault
Date: Thu,  8 Aug 2024 15:27:16 -0400
Message-ID: <bce66af61dd98d4f81032b97c73dce09658ae02d.1723144881.git.josef@toxicpanda.com>
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

bcachefs has its own locking around filemap_fault, so we have to make
sure we do the fsnotify hook before the locking.  Add the check to emit
the event before the locking and return VM_FAULT_RETRY to retrigger the
fault once the event has been emitted.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/bcachefs/fs-io-pagecache.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/bcachefs/fs-io-pagecache.c b/fs/bcachefs/fs-io-pagecache.c
index a9cc5cad9cc9..359856df52d4 100644
--- a/fs/bcachefs/fs-io-pagecache.c
+++ b/fs/bcachefs/fs-io-pagecache.c
@@ -562,6 +562,7 @@ void bch2_set_folio_dirty(struct bch_fs *c,
 vm_fault_t bch2_page_fault(struct vm_fault *vmf)
 {
 	struct file *file = vmf->vma->vm_file;
+	struct file *fpin = NULL;
 	struct address_space *mapping = file->f_mapping;
 	struct address_space *fdm = faults_disabled_mapping();
 	struct bch_inode_info *inode = file_bch_inode(file);
@@ -570,6 +571,18 @@ vm_fault_t bch2_page_fault(struct vm_fault *vmf)
 	if (fdm == mapping)
 		return VM_FAULT_SIGBUS;
 
+	ret = filemap_maybe_emit_fsnotify_event(vmf, &fpin);
+	if (unlikely(ret)) {
+		if (fpin) {
+			fput(fpin);
+			ret |= VM_FAULT_RETRy;
+		}
+		return ret;
+	} else if (fpin) {
+		fput(fpin);
+		return VM_FAULT_RETRY;
+	}
+
 	/* Lock ordering: */
 	if (fdm > mapping) {
 		struct bch_inode_info *fdm_host = to_bch_ei(fdm->host);
-- 
2.43.0

