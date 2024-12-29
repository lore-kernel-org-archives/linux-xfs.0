Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C66158520
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479602; cv=none; b=V2qi5cqhcQKD+zCh18QhYp3BpFR6oArJYHKmSLOCcEE7kNlukQvKKrOnZtZTIndH9glijYU170rjF3pxE0vRK0Sgx3SiBISsCuIrxwXAez/+X+IzeahvRGHekmKRETIZEDrHgutfInO0QZlSum8AUMqbqtsSfvBtzt/SFCAe198=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479602; c=relaxed/simple;
	bh=0mNIQX8gch+qYA08sKOXBzWRU9EW8UlYCDoU1mhQ9lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PbVMSycH+enABbsywpunkSXKtwMN0qEBXvhpBvbHrKEdZTV6wKuk/eA79SBzDkLCv9UOWewwCvFTUGdOFYMUUM6UMbXrI4aQFf+i/yLAGZ/xVNNUNoMqObK2ql3xTge6zh5vXaZzZq9y8Gk8ROVU4shZceNrooyZAFB49LqxCSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MI0bSgQc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MI0bSgQc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NMvYZcQ/EIYbNsIgLOjJCZcJX1yFiaquR92t12jBkMo=;
	b=MI0bSgQcnuOYs45hCzlWFIWq1pgClhtluThf0C8CKnRa5LU6TAU8ezt9GvQr8P/7niPdc3
	HboH6SdYOo1DlRLOokV0MkDE5PSwRadOrdUeKDRugcbeMVKDaWvUdMrOs7vmOnzo8Mumiq
	64l8jjwsQpD1UIE6L+3F5OmE7+KAzSU=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-377-M9QLOi0hPF2wwzve6BbnMQ-1; Sun, 29 Dec 2024 08:39:58 -0500
X-MC-Unique: M9QLOi0hPF2wwzve6BbnMQ-1
X-Mimecast-MFC-AGG-ID: M9QLOi0hPF2wwzve6BbnMQ
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-aa67fcbb549so143090566b.0
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:39:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479597; x=1736084397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NMvYZcQ/EIYbNsIgLOjJCZcJX1yFiaquR92t12jBkMo=;
        b=oUjNYp4EvIuCrR7NiR/mR2j9U1feKtDDV5vub+GWBrE8lrumWnc/MpCX+d7F4CPW0+
         JnYUodz0XEC63QCiPfiVzmgtNCigKsKwIljSjSRIrFV7dEa4E/Ow76VgP2IFl5+w5vV3
         X/fcCfXl3CnyWBjem6Ez0MGHDLWLDDWyk8+wWYkB/dXKDYhN4mvvRRuCicMX88MsBTwr
         W5C923zaAQ3hA+vJlTO934O/q9EjH7Rvaraomy3WSvsNmgt/cAQf5JWyhGvwdvImOtab
         QlBVv8SHGNZBkamlC4AFldKL2EZC/Ectb2ublTSmdUPvQO5pI+U1forufUZnpdVEjV30
         Telg==
X-Gm-Message-State: AOJu0YwjzTQ7TCXTks7pRq2YKSfnS45ricWcVB0XmRSVPo9OrYXGAJg3
	HQGBgP4AghVoEdRBDfCpk5ejs0JG5jwzes+jw5d/3WgZetO2aSY7sqzLMZVOEMvmfzyQT6rvHRX
	TMZBMTKU/0MMtPD0cJAF7mfpYkvGAXo364efYBuYJZPIT11TANYI4GptedZecEbnIC7zZtbBqLK
	9pE8/yfyPknY/tPKO72SVFtGvARPM5AAeetUG4mVv+
X-Gm-Gg: ASbGncubtQDsIXBfuGb074At0xXZlQqS8//J6HF6W6gaSRmEx/lmg2Z4iWx+GUcItCj
	SB8tYzSXxXg6WCLOYGs7tis8ea89PXOkMEzWMDKdOLkbBnWbLci4pUv8JNVHSQ/tjptSS73mxXO
	oXnQUCwmop5P/cqHtYKC+AzGGWDIvTaT51Kvou1DqI25ANWwHZHxXVxoVcj6UhioLg9JfupxVjf
	+qjKve3EBRFZDnuiEosWpGjNGu0mWvIqRaTL+e4DigPkVVUNhqIA85Z69E4DyFIjljIr5zSJhKO
	EBZbOvWMTn42g5o=
X-Received: by 2002:a17:907:7fa9:b0:aab:d8de:217e with SMTP id a640c23a62f3a-aac2c005b7amr2682807866b.26.1735479596841;
        Sun, 29 Dec 2024 05:39:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHmz2YbaosdBF8itUyBBy05yAOn9Tmm0RoJJZOChFreWOe29O+s05Ttm1LbXoFO4H0vwN5nqQ==
X-Received: by 2002:a17:907:7fa9:b0:aab:d8de:217e with SMTP id a640c23a62f3a-aac2c005b7amr2682805866b.26.1735479596366;
        Sun, 29 Dec 2024 05:39:56 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f070a7bsm1355017766b.201.2024.12.29.05.39.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:39:55 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de
Subject: [PATCH 06/24] fsverity: report validation errors back to the filesystem
Date: Sun, 29 Dec 2024 14:39:09 +0100
Message-ID: <20241229133927.1194609-7-aalbersh@kernel.org>
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

From: "Darrick J. Wong" <djwong@kernel.org>

Provide a new function call so that validation errors can be reported
back to the filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/verity/verify.c              |  4 ++++
 include/linux/fsverity.h        | 14 ++++++++++++++
 include/trace/events/fsverity.h | 19 +++++++++++++++++++
 3 files changed, 37 insertions(+)

diff --git a/fs/verity/verify.c b/fs/verity/verify.c
index 25fb795655e9..587f3a4eb34e 100644
--- a/fs/verity/verify.c
+++ b/fs/verity/verify.c
@@ -242,6 +242,10 @@ verify_data_block(struct inode *inode, struct fsverity_info *vi,
 		     data_pos, level - 1,
 		     params->hash_alg->name, hsize, want_hash,
 		     params->hash_alg->name, hsize, real_hash);
+	trace_fsverity_file_corrupt(inode, data_pos, params->block_size);
+	if (inode->i_sb->s_vop->file_corrupt)
+		inode->i_sb->s_vop->file_corrupt(inode, data_pos,
+				params->block_size);
 error:
 	for (; level > 0; level--) {
 		kunmap_local(hblocks[level - 1].addr);
diff --git a/include/linux/fsverity.h b/include/linux/fsverity.h
index 8627b11082b0..9b79aaaa6626 100644
--- a/include/linux/fsverity.h
+++ b/include/linux/fsverity.h
@@ -125,6 +125,20 @@ struct fsverity_operations {
 	 */
 	int (*write_merkle_tree_block)(struct inode *inode, const void *buf,
 				       u64 pos, unsigned int size);
+
+	/**
+	 * Notify the filesystem that file data is corrupt.
+	 *
+	 * @inode: the inode being validated
+	 * @pos: the file position of the invalid data
+	 * @len: the length of the invalid data
+	 *
+	 * This function is called when fs-verity detects that a portion of a
+	 * file's data is inconsistent with the Merkle tree, or a Merkle tree
+	 * block needed to validate the data is inconsistent with the level
+	 * above it.
+	 */
+	void (*file_corrupt)(struct inode *inode, loff_t pos, size_t len);
 };
 
 #ifdef CONFIG_FS_VERITY
diff --git a/include/trace/events/fsverity.h b/include/trace/events/fsverity.h
index dab220884b89..375fdddac6a9 100644
--- a/include/trace/events/fsverity.h
+++ b/include/trace/events/fsverity.h
@@ -137,6 +137,25 @@ TRACE_EVENT(fsverity_verify_merkle_block,
 		__entry->hidx)
 );
 
+TRACE_EVENT(fsverity_file_corrupt,
+	TP_PROTO(const struct inode *inode, loff_t pos, size_t len),
+	TP_ARGS(inode, pos, len),
+	TP_STRUCT__entry(
+		__field(ino_t, ino)
+		__field(loff_t, pos)
+		__field(size_t, len)
+	),
+	TP_fast_assign(
+		__entry->ino = inode->i_ino;
+		__entry->pos = pos;
+		__entry->len = len;
+	),
+	TP_printk("ino %lu pos %llu len %zu",
+		(unsigned long) __entry->ino,
+		__entry->pos,
+		__entry->len)
+);
+
 #endif /* _TRACE_FSVERITY_H */
 
 /* This part must be outside protection */
-- 
2.47.0

