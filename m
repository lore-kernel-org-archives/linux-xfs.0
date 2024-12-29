Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89A515820C
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479598; cv=none; b=lJTTsamSaB9xRbGrUvS1gSCcmpS6JQErpdauCVMPULEbnFG7W1aD2GWKsF0kYh+pvjdxZ6uopKiIFBu4wIbVdH8DfknrQj+epfPj8ytqxNRpjYE6uS+uL8q9cEG5oi4fRky9eVQKKR5+LcNYlloqH9+4fAwvsMdaW2c7Kje+yWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479598; c=relaxed/simple;
	bh=z3WWgutTJCzUozrBtuUrdSjR344jzF9uMNESBKX3gCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a3DQMVwbbx6Iv/Yi5Hw77mrZCczGem0g4s/zpGHWSfh6fF85+5d1evY64RCAKuReJJh5R9whVMiWMRGmZ2+OZsS5UsLvEMnZRpevsZTDHnMaln/gSACDNIsF2geMQ7IFWnz7yuN2YGNmy9zAmXbs6f3eB+TL65GuxwfqyxOxakM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ernwytzm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ernwytzm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479596;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m0MBuGNI6HR7jmCAEhKFjjSPTPJAQEO92w7mKWia3t0=;
	b=ernwytzmnyJ90vSDyzgsK4bXzKK3eOjnZ4Ath9/9L7M8I+yvroCb7zbCewufeZRnBMn/LY
	mufR5kmFGTTUlSu/CTbqpHVkj0AckNVahtm+As9IB9bWUiJGGeRFeL10VEQgQ3j7QSj8Y+
	5l6fuzfywHkTl7kaPPU2MG9bvEHY0vc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-46-rpol3eXmPayTd2TrhR7q4A-1; Sun, 29 Dec 2024 08:39:54 -0500
X-MC-Unique: rpol3eXmPayTd2TrhR7q4A-1
X-Mimecast-MFC-AGG-ID: rpol3eXmPayTd2TrhR7q4A
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5d3eea3b9aaso7093125a12.1
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:39:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479593; x=1736084393;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m0MBuGNI6HR7jmCAEhKFjjSPTPJAQEO92w7mKWia3t0=;
        b=KFnu+sbqhhxorAgrxoXSW1/3jLRpZdD5xiEFnfTI/ySEriU4tezFRenFrLGSgfoYo6
         L/iigRvIWAPh52wC/YD2YWZthcrYTXNPHBVU7plii2uxgdz0WG48m7q4RSOu3G3/Em8J
         fEDkSsMYjL7sKC2Rq7M/sYiOqUEKR2lSfm9yiyC2dBfHi0kimdCfI5oRUdQCyVOk3rrV
         zTNfETX42YMAnGkQlOSHxRF5bn19crHlE00hYncdrplb5FkL6P2aMCM+leG3io7W978K
         dMc3oGGkehH9C7KauATtzECbKT7I7I7UJzjCGgmoqzECak0Vwg8lNaY7K4MkA6ajFQlU
         YChQ==
X-Gm-Message-State: AOJu0YzMkBeDVqGQdY3bF7sgNWqrW0b785GdszL6Bcq+6WPFrDXzqcAP
	rvcjStSwfLLbLL4K7paTz7uvCdXp3z5VgRTYnnQcA6mzjgU7m7hYztnFidT6mrsZCctprxVR+E4
	JeNvUuokFh3rPI2YNFAIzQ6AkjO8+lyq0pdf+1XLFv8B1LThgyOdOWDt53ZQmoAazi59Wci4MB/
	O+gPB1ztYohUQcQsufBmRMRmQC4d67QOB9vS4ktm3B
X-Gm-Gg: ASbGnctdlxMgQLmUbckdQFjUbT1C101kchFspxE7bqh8rY1oJSUAmY0M6O8TJU7LglF
	YDgucJEfiSxS7Hjq3PHlkuMXCcdYKgu1PQsO7rGJwulxaS70b9mtg0FEDXNMq6D+cNEmwB7B8kg
	gloPinIm5dsaB15GnjgZQfUDZ8yb0PLsoZ5NOUCwIroF9nGqfRZ+jgviw1CCW4Sp5JsGtd59a0F
	5CPZi11l0EhzoXVUI+LLKlbRb4krpast32fpNfnFDwL2mxgZV8VyQoljS4r3rOYZgJJAhkgVQz4
	AKwg/ASMV+SEs/E=
X-Received: by 2002:a05:6402:4405:b0:5d2:7199:ac2 with SMTP id 4fb4d7f45d1cf-5d81dd83e12mr76534282a12.2.1735479592731;
        Sun, 29 Dec 2024 05:39:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGurAbU87sITgKNnfB7hWEP7sDCOuMcwDVDAwR6BNA6+XSHp4ZSvKgnItEZxApcRLKGWKNrvQ==
X-Received: by 2002:a05:6402:4405:b0:5d2:7199:ac2 with SMTP id 4fb4d7f45d1cf-5d81dd83e12mr76534210a12.2.1735479592250;
        Sun, 29 Dec 2024 05:39:52 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f070a7bsm1355017766b.201.2024.12.29.05.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:39:50 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 03/24] fsverity: add tracepoints
Date: Sun, 29 Dec 2024 14:39:06 +0100
Message-ID: <20241229133927.1194609-4-aalbersh@kernel.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241229133927.1194609-1-aalbersh@kernel.org>
References: <20241229133350.1192387-1-aalbersh@kernel.org>
 <20241229133927.1194609-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
 fs/verity/enable.c              |   4 +
 fs/verity/fsverity_private.h    |   2 +
 fs/verity/init.c                |   1 +
 fs/verity/verify.c              |   8 ++
 include/trace/events/fsverity.h | 143 ++++++++++++++++++++++++++++++++
 6 files changed, 159 insertions(+)
 create mode 100644 include/trace/events/fsverity.h

diff --git a/MAINTAINERS b/MAINTAINERS
index e6e71b05710b..62ec363f3b6b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9394,6 +9394,7 @@ T:	git https://git.kernel.org/pub/scm/fs/fsverity/linux.git
 F:	Documentation/filesystems/fsverity.rst
 F:	fs/verity/
 F:	include/linux/fsverity.h
+F:	include/trace/events/fsverity.h
 F:	include/uapi/linux/fsverity.h
 
 FT260 FTDI USB-HID TO I2C BRIDGE DRIVER
diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index 04e060880b79..9f743f916010 100644
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
index f440f0e61e3e..43f18914a6cd 100644
--- a/fs/verity/init.c
+++ b/fs/verity/init.c
@@ -5,6 +5,7 @@
  * Copyright 2019 Google LLC
  */
 
+#define CREATE_TRACE_POINTS
 #include "fsverity_private.h"
 
 #include <linux/ratelimit.h>
diff --git a/fs/verity/verify.c b/fs/verity/verify.c
index 4fcad0825a12..25fb795655e9 100644
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
@@ -219,6 +225,8 @@ verify_data_block(struct inode *inode, struct fsverity_info *vi,
 		want_hash = _want_hash;
 		kunmap_local(haddr);
 		put_page(hpage);
+		trace_fsverity_verify_merkle_block(inode, hblock_idx,
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
2.47.0

