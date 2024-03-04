Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7067AE50
	for <linux-xfs@vger.kernel.org>; Mon,  4 Mar 2024 19:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709579546; cv=none; b=gB+bPDPevqXs5H3yHEvXPri6UtFCjCXbrLcMFJtgf/CnZVHLb9OxpFxSVNT93hsOmbi7DVbLvxQhPIHpleYhGziXrvlEZjA9tG6McOu1W+a/nhTZQ5wSX51U2xmAgP/9eX027kZC7jXNe25YufEyrZwzfuoAdsX+oBfApZi5dFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709579546; c=relaxed/simple;
	bh=i1ofJYNBQYpDqkpf0knoA0oObWG+MRkgoeU7vYMM0x8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pAJglLVjcymEGnDiltPFHNZLEoLgLjH8xBkF/xl3H2zuihs75YnwBkj5eQNnTVbU5d4JfveIWbLreSCIxsplUGe5OGg29MQ1LiJSw+mFiAYmbz9tX7i39bwDQTQWFzUInyOhY/HeGtPHq6LYWNRWwg/yINjRGDYSAUrTeWVxr7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UnhPFYe/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UnhPFYe/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709579542;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rTI/symwuDCz2/BvbwsjBj7TSJADKxHjfQbz12pqk8c=;
	b=UnhPFYe/WGPbfrWRHfRXDLtu7OzpauBbWewys5Mmiq5aKdmlfbeNhoZQVlgmW4PQ3V5KcL
	fgKKqrvMnlns3JrWMDHDzb+CN7pncogYA/B7xp18XtG3oLvREIG6nkfKFPCtuYYDh6ZLfj
	uZQxYh7eJeb08LTC0QVf75QReQ0VR0U=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-rTlgf2u8PC6JLsprvib78A-1; Mon, 04 Mar 2024 14:12:21 -0500
X-MC-Unique: rTlgf2u8PC6JLsprvib78A-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a45851b0030so36218066b.3
        for <linux-xfs@vger.kernel.org>; Mon, 04 Mar 2024 11:12:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709579540; x=1710184340;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rTI/symwuDCz2/BvbwsjBj7TSJADKxHjfQbz12pqk8c=;
        b=GEmubF7M+nidLw058eG9ni6/WBFLSevyqaw3fy5Rb81OWDtV70YbBnT+v9g24Xc3Lw
         KUv8uFOdspdrn8XCSdV5v1mpPBrhfDU2cjBZzIcT13FB9UsGLSUxTvnFZS8DbjwMRqdM
         cbepoQeBaz/14a6VQ2OoIGWr3eJf6iO1CeKAvkRQafqYx9IpX7dCQ4LIZHe6wdt7O6r7
         Dd/xHBHRWH00tMB+7MLNL4/E+VakaZ/DQ4w+PcdwmM263n7ckNnPRQDHh5zli0/UhX81
         j/SPrwUU1S42+wuVhLip2EzrAVNRnPplWp8JmQZJUehiAaVLPk8QtZ8gEqEPtV9zbtVi
         DVpg==
X-Forwarded-Encrypted: i=1; AJvYcCXQ5GFhk9jNUI9VboaZXBTlJdlcjymnflBGc3xeeiR3RX7gGiLk639EgKru332sQ6lmlr0H8Qjea15ekycCZprYPDjcQQbAQxLM
X-Gm-Message-State: AOJu0Yy9sNqzZK6cw88Qhf82IX8M6SHmFW5ZpKGILl90SfvYzm54zJe+
	7FsUg8rBYBY539QCP0soFrt+3cVSPcej1HYlL3B2ir4hWEETwzVnufQgHEWWU45E2b285wNtPzL
	s+Vn+UTo5R3zAOnH4umn8erKXP/WMBNherieUSk72idO6KdL62PyutTEG
X-Received: by 2002:a17:906:4558:b0:a43:9857:8112 with SMTP id s24-20020a170906455800b00a4398578112mr7269260ejq.20.1709579539793;
        Mon, 04 Mar 2024 11:12:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHQpz2FH9WjfaOuXPTLwhSfJSvmfQpibE0LEmBwBUsLCZzxRvN9RYWQAdB3hv4zNVK4Zc7VPg==
X-Received: by 2002:a17:906:4558:b0:a43:9857:8112 with SMTP id s24-20020a170906455800b00a4398578112mr7269240ejq.20.1709579539331;
        Mon, 04 Mar 2024 11:12:19 -0800 (PST)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a11-20020a1709064a4b00b00a44a04aa3cfsm3783319ejv.225.2024.03.04.11.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Mar 2024 11:12:19 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v5 09/24] fsverity: add tracepoints
Date: Mon,  4 Mar 2024 20:10:32 +0100
Message-ID: <20240304191046.157464-11-aalbersh@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20240304191046.157464-2-aalbersh@redhat.com>
References: <20240304191046.157464-2-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fs-verity previously had debug printk but it was removed. This patch
adds trace points to the same places where printk were used (with a
few additional ones).

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 MAINTAINERS                     |   1 +
 fs/verity/enable.c              |   3 +
 fs/verity/fsverity_private.h    |   2 +
 fs/verity/init.c                |   1 +
 fs/verity/signature.c           |   2 +
 fs/verity/verify.c              |   7 ++
 include/trace/events/fsverity.h | 181 ++++++++++++++++++++++++++++++++
 7 files changed, 197 insertions(+)
 create mode 100644 include/trace/events/fsverity.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 2ecaaec6a6bf..49888dd5cbbd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8745,6 +8745,7 @@ T:	git https://git.kernel.org/pub/scm/fs/fsverity/linux.git
 F:	Documentation/filesystems/fsverity.rst
 F:	fs/verity/
 F:	include/linux/fsverity.h
+F:	include/trace/events/fsverity.h
 F:	include/uapi/linux/fsverity.h
 
 FT260 FTDI USB-HID TO I2C BRIDGE DRIVER
diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index 04e060880b79..945eba0092ab 100644
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -227,6 +227,8 @@ static int enable_verity(struct file *filp,
 	if (err)
 		goto out;
 
+	trace_fsverity_enable(inode, desc, &params);
+
 	/*
 	 * Start enabling verity on this file, serialized by the inode lock.
 	 * Fail if verity is already enabled or is already being enabled.
@@ -255,6 +257,7 @@ static int enable_verity(struct file *filp,
 		fsverity_err(inode, "Error %d building Merkle tree", err);
 		goto rollback;
 	}
+	trace_fsverity_tree_done(inode, desc, &params);
 
 	/*
 	 * Create the fsverity_info.  Don't bother trying to save work by
diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
index dad33e6ff0d6..fd8f5a8d1f6a 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -162,4 +162,6 @@ void __init fsverity_init_workqueue(void);
 void fsverity_drop_block(struct inode *inode,
 			 struct fsverity_blockbuf *block);
 
+#include <trace/events/fsverity.h>
+
 #endif /* _FSVERITY_PRIVATE_H */
diff --git a/fs/verity/init.c b/fs/verity/init.c
index cb2c9aac61ed..3769d2dc9e3b 100644
--- a/fs/verity/init.c
+++ b/fs/verity/init.c
@@ -5,6 +5,7 @@
  * Copyright 2019 Google LLC
  */
 
+#define CREATE_TRACE_POINTS
 #include "fsverity_private.h"
 
 #include <linux/ratelimit.h>
diff --git a/fs/verity/signature.c b/fs/verity/signature.c
index 90c07573dd77..c1f08bb32ed1 100644
--- a/fs/verity/signature.c
+++ b/fs/verity/signature.c
@@ -53,6 +53,8 @@ int fsverity_verify_signature(const struct fsverity_info *vi,
 	struct fsverity_formatted_digest *d;
 	int err;
 
+	trace_fsverity_verify_signature(inode, signature, sig_size);
+
 	if (sig_size == 0) {
 		if (fsverity_require_signatures) {
 			fsverity_err(inode,
diff --git a/fs/verity/verify.c b/fs/verity/verify.c
index de71911d400c..614776e7a2b6 100644
--- a/fs/verity/verify.c
+++ b/fs/verity/verify.c
@@ -118,6 +118,7 @@ verify_data_block(struct inode *inode, struct fsverity_info *vi,
 		/* Byte offset of the wanted hash relative to @addr */
 		unsigned int hoffset;
 	} hblocks[FS_VERITY_MAX_LEVELS];
+	trace_fsverity_verify_block(inode, data_pos);
 	/*
 	 * The index of the previous level's block within that level; also the
 	 * index of that block's hash within the current level.
@@ -215,6 +216,8 @@ verify_data_block(struct inode *inode, struct fsverity_info *vi,
 		if (is_hash_block_verified(inode, block, hblock_idx)) {
 			memcpy(_want_hash, block->kaddr + hoffset, hsize);
 			want_hash = _want_hash;
+			trace_fsverity_merkle_tree_block_verified(inode,
+					block, FSVERITY_TRACE_DIR_ASCEND);
 			fsverity_drop_block(inode, block);
 			goto descend;
 		}
@@ -248,6 +251,8 @@ verify_data_block(struct inode *inode, struct fsverity_info *vi,
 			SetPageChecked(hpage);
 		memcpy(_want_hash, haddr + hoffset, hsize);
 		want_hash = _want_hash;
+		trace_fsverity_merkle_tree_block_verified(inode, block,
+				FSVERITY_TRACE_DIR_DESCEND);
 		fsverity_drop_block(inode, block);
 	}
 
@@ -405,6 +410,8 @@ void fsverity_invalidate_block(struct inode *inode,
 	struct fsverity_info *vi = inode->i_verity_info;
 	const unsigned int log_blocksize = vi->tree_params.log_blocksize;
 
+	trace_fsverity_invalidate_block(inode, block);
+
 	if (block->offset > vi->tree_params.tree_size) {
 		fsverity_err(inode,
 "Trying to invalidate beyond Merkle tree (tree %lld, offset %lld)",
diff --git a/include/trace/events/fsverity.h b/include/trace/events/fsverity.h
new file mode 100644
index 000000000000..82966ecc5722
--- /dev/null
+++ b/include/trace/events/fsverity.h
@@ -0,0 +1,181 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM fsverity
+
+#if !defined(_TRACE_FSVERITY_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_FSVERITY_H
+
+#include <linux/tracepoint.h>
+
+struct fsverity_descriptor;
+struct merkle_tree_params;
+struct fsverity_info;
+
+#define FSVERITY_TRACE_DIR_ASCEND	(1ul << 0)
+#define FSVERITY_TRACE_DIR_DESCEND	(1ul << 1)
+#define FSVERITY_HASH_SHOWN_LEN		20
+
+TRACE_EVENT(fsverity_enable,
+	TP_PROTO(struct inode *inode, struct fsverity_descriptor *desc,
+		struct merkle_tree_params *params),
+	TP_ARGS(inode, desc, params),
+	TP_STRUCT__entry(
+		__field(ino_t, ino)
+		__field(u64, data_size)
+		__field(unsigned int, block_size)
+		__field(unsigned int, num_levels)
+		__field(u64, tree_size)
+	),
+	TP_fast_assign(
+		__entry->ino = inode->i_ino;
+		__entry->data_size = desc->data_size;
+		__entry->block_size = params->block_size;
+		__entry->num_levels = params->num_levels;
+		__entry->tree_size = params->tree_size;
+	),
+	TP_printk("ino %lu data size %llu tree size %llu block size %u levels %u",
+		(unsigned long) __entry->ino,
+		__entry->data_size,
+		__entry->tree_size,
+		__entry->block_size,
+		__entry->num_levels)
+);
+
+TRACE_EVENT(fsverity_tree_done,
+	TP_PROTO(struct inode *inode, struct fsverity_descriptor *desc,
+		struct merkle_tree_params *params),
+	TP_ARGS(inode, desc, params),
+	TP_STRUCT__entry(
+		__field(ino_t, ino)
+		__field(unsigned int, levels)
+		__field(unsigned int, tree_blocks)
+		__field(u64, tree_size)
+		__array(u8, tree_hash, 64)
+	),
+	TP_fast_assign(
+		__entry->ino = inode->i_ino;
+		__entry->levels = params->num_levels;
+		__entry->tree_blocks =
+			params->tree_size >> params->log_blocksize;
+		__entry->tree_size = params->tree_size;
+		memcpy(__entry->tree_hash, desc->root_hash, 64);
+	),
+	TP_printk("ino %lu levels %d tree_blocks %d tree_size %lld root_hash %s",
+		(unsigned long) __entry->ino,
+		__entry->levels,
+		__entry->tree_blocks,
+		__entry->tree_size,
+		__print_hex(__entry->tree_hash, 64))
+);
+
+TRACE_EVENT(fsverity_verify_block,
+	TP_PROTO(struct inode *inode, u64 offset),
+	TP_ARGS(inode, offset),
+	TP_STRUCT__entry(
+		__field(ino_t, ino)
+		__field(u64, offset)
+		__field(unsigned int, block_size)
+	),
+	TP_fast_assign(
+		__entry->ino = inode->i_ino;
+		__entry->offset = offset;
+		__entry->block_size =
+			inode->i_verity_info->tree_params.block_size;
+	),
+	TP_printk("ino %lu data offset %lld data block size %u",
+		(unsigned long) __entry->ino,
+		__entry->offset,
+		__entry->block_size)
+);
+
+TRACE_EVENT(fsverity_merkle_tree_block_verified,
+	TP_PROTO(struct inode *inode,
+		 struct fsverity_blockbuf *block,
+		 u8 direction),
+	TP_ARGS(inode, block, direction),
+	TP_STRUCT__entry(
+		__field(ino_t, ino)
+		__field(u64, offset)
+		__field(u8, direction)
+	),
+	TP_fast_assign(
+		__entry->ino = inode->i_ino;
+		__entry->offset = block->offset;
+		__entry->direction = direction;
+	),
+	TP_printk("ino %lu block offset %llu %s",
+		(unsigned long) __entry->ino,
+		__entry->offset,
+		__entry->direction == 0 ? "ascend" : "descend")
+);
+
+TRACE_EVENT(fsverity_invalidate_block,
+	TP_PROTO(struct inode *inode, struct fsverity_blockbuf *block),
+	TP_ARGS(inode, block),
+	TP_STRUCT__entry(
+		__field(ino_t, ino)
+		__field(u64, offset)
+		__field(unsigned int, block_size)
+	),
+	TP_fast_assign(
+		__entry->ino = inode->i_ino;
+		__entry->offset = block->offset;
+		__entry->block_size = block->size;
+	),
+	TP_printk("ino %lu block position %llu block size %u",
+		(unsigned long) __entry->ino,
+		__entry->offset,
+		__entry->block_size)
+);
+
+TRACE_EVENT(fsverity_read_merkle_tree_block,
+	TP_PROTO(struct inode *inode, u64 offset, unsigned int log_blocksize),
+	TP_ARGS(inode, offset, log_blocksize),
+	TP_STRUCT__entry(
+		__field(ino_t, ino)
+		__field(u64, offset)
+		__field(u64, index)
+		__field(unsigned int, block_size)
+	),
+	TP_fast_assign(
+		__entry->ino = inode->i_ino;
+		__entry->offset = offset;
+		__entry->index = offset >> log_blocksize;
+		__entry->block_size = 1 << log_blocksize;
+	),
+	TP_printk("ino %lu tree offset %llu block index %llu block hize %u",
+		(unsigned long) __entry->ino,
+		__entry->offset,
+		__entry->index,
+		__entry->block_size)
+);
+
+TRACE_EVENT(fsverity_verify_signature,
+	TP_PROTO(const struct inode *inode, const u8 *signature, size_t sig_size),
+	TP_ARGS(inode, signature, sig_size),
+	TP_STRUCT__entry(
+		__field(ino_t, ino)
+		__dynamic_array(u8, signature, sig_size)
+		__field(size_t, sig_size)
+		__field(size_t, sig_size_show)
+	),
+	TP_fast_assign(
+		__entry->ino = inode->i_ino;
+		memcpy(__get_dynamic_array(signature), signature, sig_size);
+		__entry->sig_size = sig_size;
+		__entry->sig_size_show = (sig_size > FSVERITY_HASH_SHOWN_LEN ?
+			FSVERITY_HASH_SHOWN_LEN : sig_size);
+	),
+	TP_printk("ino %lu sig_size %lu %s%s%s",
+		(unsigned long) __entry->ino,
+		__entry->sig_size,
+		(__entry->sig_size ? "sig " : ""),
+		__print_hex(__get_dynamic_array(signature),
+			__entry->sig_size_show),
+		(__entry->sig_size ? "..." : ""))
+);
+
+#endif /* _TRACE_FSVERITY_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
2.42.0

