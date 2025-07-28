Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52BF5279DA1
	for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 20:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753734693; cv=none; b=hqhRi5dhULVTu9lWtziny9eMtffNgKRGdYYvLvBEwttq1EwB9NtOoQBqYVonksWjaudB1bB39QSvkB41OsQWw+ZrUA0GZWHMW1/RSYu+ScAPP9H03jQNJIM74ikwM8H+ut39mWNYAjOWZDQAWggjXogw/GnNh2YEGVjM0zU5vHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753734693; c=relaxed/simple;
	bh=vtEh005EKDpDotFFI+1Wg203jjL9iXcRk9HDHR9yBro=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Qorn7jwUrwQDIwZI+3qaFcGnPYqjlkVz3J9x2ia8MfpiwxCJQpv5gQrh9zm41nHCSvtRPcGgUC3LoawkK4K5sS/WYYyBlbjvtEYrmc/d0ulTmLDMQx5xZiY/oWtFqtj7ai94WRqDfnI3YOcyP3V6DK7DWLn1LXEzhWnW0W2bJIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V6DCRIWz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V6DCRIWz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753734690;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=udEXP1NTqrVTD7aP+UIpVa47Z7hx6S3k4WMP0sChdIY=;
	b=V6DCRIWzosCXDbs1Nn96t5O2JIvmNoQUGfnsHEmzWcjU03/4Zet6NtkKDiRf+I3sCBb8tx
	QggoY9E63+D+wPeZ7hsDVDcv+ovRCTynPANVbspstWTMTUy4SQqx4CSIYs11HTuWXwm34v
	nPgzzlBKdmtl+QUt9Kp3a1Wdux3XvAk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-4HcOwMM8O72fPVvunfMbNQ-1; Mon, 28 Jul 2025 16:31:28 -0400
X-MC-Unique: 4HcOwMM8O72fPVvunfMbNQ-1
X-Mimecast-MFC-AGG-ID: 4HcOwMM8O72fPVvunfMbNQ_1753734687
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-60724177a1fso5769921a12.3
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 13:31:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753734687; x=1754339487;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=udEXP1NTqrVTD7aP+UIpVa47Z7hx6S3k4WMP0sChdIY=;
        b=bY2qh4v9HsK7p4d/ZL1C3OebvAQBqtZ0dU4+LuGYEfojYi4CLPBeYlJU07UYqFhAj3
         Xn9V8KV97llDr0rSXCNT+wiO6UPVS+UK1sSQRNobGlCyQKnh04ME5tG+E/O+wfFZNCRb
         Iy9i7sNrv1qBZND8Oy4EsSoS1B2N5HCo3PBaFynZ0pvqneIH/0bt3+gTc7YPszp6aNZc
         XxnflVulblHuBzI/XDqFruKh9xdoIB+cOwrieVcw/eoN0CCg22YrmPNA0FuzGLkWANAp
         lf5UTzdGpRDh98IhKRt1u/skGpL71bunVWmBLvSYW6V+E3PDR6OCX0X72iWQd2s61I4B
         gTKg==
X-Forwarded-Encrypted: i=1; AJvYcCWo0oz/cASeeUqrLjQEQnvjsIo3n9bZvoWG7cRs+usTQnofDg70VjPfVwykpH9stv7UHrIskbcc7Wg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzvUdlJGmYjzPFCbE4VfVkEmp9HO9uCVRiSvU/vo3BonQUosRnW
	gtXB0INOxQtFdm8m+DlqiPYcyIUEGW6FnDfVfRBhxh0Nzx1EBIZrGGtIWDigxXpiqvwPq/z0bnf
	INAKqmSWZZ+juZ7xOSzAVO9mJQYMj5IVYMyvvVj9LrLpfcfcxnBjJrNM+6hyBcv//6FXB
X-Gm-Gg: ASbGncvHzGEmOAkaMr6vQBGemyoXml83HAW/P+DZtBpqAoaMKqOT2bGutipZR3P+ATs
	+/iOb3ZQIaBwxcZg4pDtAuHkFZdUp2VSOQgICWrpkX44BtCBWP0/dbDOpFeOd7wKgFPY8lJ9LJu
	RsVerQBiHoHGsMy3ru4Hmo7BravoS1wD5HUtQfID8MEAajInGdVifN+PDgjnDho6Vv16A9MR9kp
	ByIjUnSDMndPGBALSF9gRIYYqLWO5zEgea+ZS4G/eNn6JoE5bdze2f/PkBJlRC5E9BVADYKTg6N
	ExR4MuJcDKLBiF+lpszIuJxIO44zTkkjkxic8OUHqK7uwg==
X-Received: by 2002:a05:6402:358b:b0:614:a23b:4959 with SMTP id 4fb4d7f45d1cf-614f1d1fe53mr12425632a12.10.1753734686865;
        Mon, 28 Jul 2025 13:31:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHaaFKErrXH/4nNMLMgIEdNT/+wVU80xv876D9pn+I+rfx81s2qpSqObxivOn7N4osROcUwzA==
X-Received: by 2002:a05:6402:358b:b0:614:a23b:4959 with SMTP id 4fb4d7f45d1cf-614f1d1fe53mr12425599a12.10.1753734686262;
        Mon, 28 Jul 2025 13:31:26 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615226558d3sm2730656a12.45.2025.07.28.13.31.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 13:31:25 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 28 Jul 2025 22:30:09 +0200
Subject: [PATCH RFC 05/29] fsverity: add tracepoints
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250728-fsverity-v1-5-9e5443af0e34@kernel.org>
References: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
In-Reply-To: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
To: fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, david@fromorbit.com, djwong@kernel.org, 
 ebiggers@kernel.org, hch@lst.de
Cc: Andrey Albershteyn <aalbersh@redhat.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=8381; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=zHxrqV5/JFTflwqY826/uVnZlU2AiK108yoYvS/c40o=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMtrvic9ZZraiRjnraN3rTWnf85gupKocMTN0fZc5P
 5qRWWS+772OUhYGMS4GWTFFlnXSWlOTiqTyjxjUyMPMYWUCGcLAxSkAE5l/hJHh+tqJIR/X61Y7
 3mv/+FRu41mxoqcTgm/fzNF/2KT1cOvr7Qz/IzKiJNkfbOZb1hKusTFxs+5KiblvfW+q2jx4fNZ
 iod0RfgCBNko9
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

From: Andrey Albershteyn <aalbersh@redhat.com>

fs-verity previously had debug printk but it was removed. This patch
adds trace points to the same places where printk were used (with a
few additional ones).

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: fix formatting]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 MAINTAINERS                     |   1 +
 fs/verity/enable.c              |   4 ++
 fs/verity/fsverity_private.h    |   2 +
 fs/verity/init.c                |   1 +
 fs/verity/verify.c              |   9 +++
 include/trace/events/fsverity.h | 143 ++++++++++++++++++++++++++++++++++++++++
 6 files changed, 160 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 60bba48f5479..64575d2007f2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9851,6 +9851,7 @@ T:	git https://git.kernel.org/pub/scm/fs/fsverity/linux.git
 F:	Documentation/filesystems/fsverity.rst
 F:	fs/verity/
 F:	include/linux/fsverity.h
+F:	include/trace/events/fsverity.h
 F:	include/uapi/linux/fsverity.h
 
 FT260 FTDI USB-HID TO I2C BRIDGE DRIVER
diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index c284f46d1b53..7cf902051b2d 100644
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -227,6 +227,8 @@ static int enable_verity(struct file *filp,
 	if (err)
 		goto out;
 
+	trace_fsverity_enable(inode, &params);
+
 	/*
 	 * Start enabling verity on this file, serialized by the inode lock.
 	 * Fail if verity is already enabled or is already being enabled.
@@ -269,6 +271,8 @@ static int enable_verity(struct file *filp,
 		goto rollback;
 	}
 
+	trace_fsverity_tree_done(inode, vi, &params);
+
 	/*
 	 * Tell the filesystem to finish enabling verity on the file.
 	 * Serialized with ->begin_enable_verity() by the inode lock.
diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
index b3506f56e180..04dd471d791c 100644
--- a/fs/verity/fsverity_private.h
+++ b/fs/verity/fsverity_private.h
@@ -154,4 +154,6 @@ static inline void fsverity_init_signature(void)
 
 void __init fsverity_init_workqueue(void);
 
+#include <trace/events/fsverity.h>
+
 #endif /* _FSVERITY_PRIVATE_H */
diff --git a/fs/verity/init.c b/fs/verity/init.c
index 6e8d33b50240..d65206608583 100644
--- a/fs/verity/init.c
+++ b/fs/verity/init.c
@@ -5,6 +5,7 @@
  * Copyright 2019 Google LLC
  */
 
+#define CREATE_TRACE_POINTS
 #include "fsverity_private.h"
 
 #include <linux/ratelimit.h>
diff --git a/fs/verity/verify.c b/fs/verity/verify.c
index 30a3f6ada2ad..580486168467 100644
--- a/fs/verity/verify.c
+++ b/fs/verity/verify.c
@@ -109,6 +109,9 @@ verify_data_block(struct inode *inode, struct fsverity_info *vi,
 		/* Byte offset of the wanted hash relative to @addr */
 		unsigned int hoffset;
 	} hblocks[FS_VERITY_MAX_LEVELS];
+
+	trace_fsverity_verify_data_block(inode, params, data_pos);
+
 	/*
 	 * The index of the previous level's block within that level; also the
 	 * index of that block's hash within the current level.
@@ -184,6 +187,9 @@ verify_data_block(struct inode *inode, struct fsverity_info *vi,
 			want_hash = _want_hash;
 			kunmap_local(haddr);
 			put_page(hpage);
+			trace_fsverity_merkle_hit(inode, data_pos, hblock_idx,
+					level,
+					hoffset >> params->log_digestsize);
 			goto descend;
 		}
 		hblocks[level].page = hpage;
@@ -219,6 +225,9 @@ verify_data_block(struct inode *inode, struct fsverity_info *vi,
 		want_hash = _want_hash;
 		kunmap_local(haddr);
 		put_page(hpage);
+		trace_fsverity_verify_merkle_block(inode,
+				hblock_idx << params->log_blocksize,
+				level, hoffset >> params->log_digestsize);
 	}
 
 	/* Finally, verify the data block. */
diff --git a/include/trace/events/fsverity.h b/include/trace/events/fsverity.h
new file mode 100644
index 000000000000..dab220884b89
--- /dev/null
+++ b/include/trace/events/fsverity.h
@@ -0,0 +1,143 @@
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
+TRACE_EVENT(fsverity_enable,
+	TP_PROTO(const struct inode *inode,
+		 const struct merkle_tree_params *params),
+	TP_ARGS(inode, params),
+	TP_STRUCT__entry(
+		__field(ino_t, ino)
+		__field(u64, data_size)
+		__field(unsigned int, block_size)
+		__field(unsigned int, num_levels)
+		__field(u64, tree_size)
+	),
+	TP_fast_assign(
+		__entry->ino = inode->i_ino;
+		__entry->data_size = i_size_read(inode);
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
+	TP_PROTO(const struct inode *inode, const struct fsverity_info *vi,
+		 const struct merkle_tree_params *params),
+	TP_ARGS(inode, vi, params),
+	TP_STRUCT__entry(
+		__field(ino_t, ino)
+		__field(unsigned int, levels)
+		__field(unsigned int, block_size)
+		__field(u64, tree_size)
+		__dynamic_array(u8, root_hash, params->digest_size)
+		__dynamic_array(u8, file_digest, params->digest_size)
+	),
+	TP_fast_assign(
+		__entry->ino = inode->i_ino;
+		__entry->levels = params->num_levels;
+		__entry->block_size = params->block_size;
+		__entry->tree_size = params->tree_size;
+		memcpy(__get_dynamic_array(root_hash), vi->root_hash, __get_dynamic_array_len(root_hash));
+		memcpy(__get_dynamic_array(file_digest), vi->file_digest, __get_dynamic_array_len(file_digest));
+	),
+	TP_printk("ino %lu levels %d block_size %d tree_size %lld root_hash %s digest %s",
+		(unsigned long) __entry->ino,
+		__entry->levels,
+		__entry->block_size,
+		__entry->tree_size,
+		__print_hex_str(__get_dynamic_array(root_hash), __get_dynamic_array_len(root_hash)),
+		__print_hex_str(__get_dynamic_array(file_digest), __get_dynamic_array_len(file_digest)))
+);
+
+TRACE_EVENT(fsverity_verify_data_block,
+	TP_PROTO(const struct inode *inode,
+		 const struct merkle_tree_params *params,
+		 u64 data_pos),
+	TP_ARGS(inode, params, data_pos),
+	TP_STRUCT__entry(
+		__field(ino_t, ino)
+		__field(u64, data_pos)
+		__field(unsigned int, block_size)
+	),
+	TP_fast_assign(
+		__entry->ino = inode->i_ino;
+		__entry->data_pos = data_pos;
+		__entry->block_size = params->block_size;
+	),
+	TP_printk("ino %lu pos %lld merkle_blocksize %u",
+		(unsigned long) __entry->ino,
+		__entry->data_pos,
+		__entry->block_size)
+);
+
+TRACE_EVENT(fsverity_merkle_hit,
+	TP_PROTO(const struct inode *inode, u64 data_pos,
+		 unsigned long hblock_idx, unsigned int level,
+		 unsigned int hidx),
+	TP_ARGS(inode, data_pos, hblock_idx, level, hidx),
+	TP_STRUCT__entry(
+		__field(ino_t, ino)
+		__field(u64, data_pos)
+		__field(unsigned long, hblock_idx)
+		__field(unsigned int, level)
+		__field(unsigned int, hidx)
+	),
+	TP_fast_assign(
+		__entry->ino = inode->i_ino;
+		__entry->data_pos = data_pos;
+		__entry->hblock_idx = hblock_idx;
+		__entry->level = level;
+		__entry->hidx = hidx;
+	),
+	TP_printk("ino %lu data_pos %llu hblock_idx %lu level %u hidx %u",
+		(unsigned long) __entry->ino,
+		__entry->data_pos,
+		__entry->hblock_idx,
+		__entry->level,
+		__entry->hidx)
+);
+
+TRACE_EVENT(fsverity_verify_merkle_block,
+	TP_PROTO(const struct inode *inode, unsigned long index,
+		 unsigned int level, unsigned int hidx),
+	TP_ARGS(inode, index, level, hidx),
+	TP_STRUCT__entry(
+		__field(ino_t, ino)
+		__field(unsigned long, index)
+		__field(unsigned int, level)
+		__field(unsigned int, hidx)
+	),
+	TP_fast_assign(
+		__entry->ino = inode->i_ino;
+		__entry->index = index;
+		__entry->level = level;
+		__entry->hidx = hidx;
+	),
+	TP_printk("ino %lu index %lu level %u hidx %u",
+		(unsigned long) __entry->ino,
+		__entry->index,
+		__entry->level,
+		__entry->hidx)
+);
+
+#endif /* _TRACE_FSVERITY_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>

-- 
2.50.0

