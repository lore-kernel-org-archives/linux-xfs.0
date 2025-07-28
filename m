Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1216C284B42
	for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 20:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753734716; cv=none; b=K30U5bb69uK6xPdAhpi1MEK6fWrFv9CETej8e0EAyjy+gn0n25RHcm6EgUwodFI9ez7eoQLzSawr9LemRf4LjmM9AzKwqgtS67Ha1UK6VMXxHGhRtMCw0Yx5QFVcWR3U9XAOHign2O2wQbS2Ai9ilpgSxE+CS880B1hmLSPG52k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753734716; c=relaxed/simple;
	bh=zC5E6t95NKV87LeykIKXUMiD57k/Zr4doqPRYj1WOUY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=eypnVWCSCkzI//8P+xm5i5xfgDEb4GNdqEoWAYT8a/si+7Zpc20V8GRJC2ltHywcGM1WmD4lhUXeq8Q999YX36EQFJXc7GZBSuUW0gFAHr4loxesjuR6pNI+S9DbQnpW5p3Jh1KmTtUL8KS/t4BW8+UVcJ93o2K1ek2ammhjVYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P0fVCTH4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P0fVCTH4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753734713;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ay9CP0eRiEH4X8+UtxY4a/Tvb9542kVaQrAsuecmxfU=;
	b=P0fVCTH4VDZevqADytFa8GAvrsL5T/1WV0Eg0edcLwlyhwZa0VfV7lw2k+B+/brk8/I7xv
	TpA6Re6tncpYtHn/4RyActNkG3Zm5p2qYXf4hmJ4uHV4sbTpKyoX+WVVwW9Xv7CVTZ4qwh
	3WOTRzbMpUcV5S7zfywDWp8MlO8iOOM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-D597Hs9SMx2lmaMImParAg-1; Mon, 28 Jul 2025 16:31:51 -0400
X-MC-Unique: D597Hs9SMx2lmaMImParAg-1
X-Mimecast-MFC-AGG-ID: D597Hs9SMx2lmaMImParAg_1753734710
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-61543f038dbso853140a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 13:31:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753734710; x=1754339510;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ay9CP0eRiEH4X8+UtxY4a/Tvb9542kVaQrAsuecmxfU=;
        b=m1WlSKiPmcm85WdRtZO7JUK3H4xSGE2SCRk/voSovI6PbSxsXw/3r+AVh94j0l0XEY
         GgQRetyRbOM1XC/OBOKnwdsUe8kuTzJTFHa41begPUV/bqLq0fw3xK9LDmGhldZqIFmw
         kcGX7OYGh+eJMlsxtd7TZE7hRPSsF0u1HIi4/4oh++wNm8onHmtr7wLbVzbK7xlAhnhh
         5FPdIwntuhSkBnELgegmsb9510iq8g4MXqtYVDKNg/f5e1bmLG7kCuzlz+A9fjgiYTP2
         3JB0uSvIULMi8Qbkh240awdHwUzieF/bTjpmIBEYnNxLgN29gAfsQofK4X9Hd1Pvgy0H
         SQ4A==
X-Forwarded-Encrypted: i=1; AJvYcCWxqXRwKpOsWo2qM2tZDzyWxbt+KZoHhe1ahORxcUltx3cQgOxnaIx5E/ZH8pRH/MdsoeKcNG+Lcik=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLcRd74X2J8oaLkBXrPRSUn2aU+ijNZGJYZXRK4aWecF4lm2zM
	ZqEQmKvB8doIFxbWiCMeG+vcRdFuv0poUc9/z4n9z1u0PQ2LS5K9A+2hCJ4dz8/AhU+gEkOqTr/
	LPWoBVKG1n1ZowhP4bPVx+DB2kU9u206DeV1ooCX5tuyiv/QkbKFlkLNMlTQm
X-Gm-Gg: ASbGncv1lw7PtAg7Acq4+KL8zRnXf/deqF9Wbl2USsgE71Ws5Wk7byDGlA8bdu1zsqw
	lq7HKB9Hd5XpKV0KocvozwrBicqUWWpTVGj3UH95oSbZivB1HR32yTmAgeI3k97GTxia8sZftF3
	Dah1joWfgr+ZrFm8fIKKHxtlff3m1Q2tFNRkYq7dfK7iFd5Ehl4Kwqfw+hhKnngnPz7QI745TL9
	pUDlglqVc1O+VKT92tFbhI5y5Y4aqVEWmyTb6yJ2SgCePgI6YnzycJyimdvUxcJ+fBXjdxE/NUC
	csB+VZkrHAgFoSLEbY1qvqhUJjYDFzfJR8O8NqeTdnpUXA==
X-Received: by 2002:a05:6402:42cf:b0:612:cdb2:d4d7 with SMTP id 4fb4d7f45d1cf-614f1d3568emr11519141a12.15.1753734709862;
        Mon, 28 Jul 2025 13:31:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGWVuXfhSdv4DcTIieq2CDA0gSu5AdlwV/ayJ9zVp7zCRLwOwcFOnGZNpS+aNUh2oAGLJrmSg==
X-Received: by 2002:a05:6402:42cf:b0:612:cdb2:d4d7 with SMTP id 4fb4d7f45d1cf-614f1d3568emr11519113a12.15.1753734709413;
        Mon, 28 Jul 2025 13:31:49 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615226558d3sm2730656a12.45.2025.07.28.13.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 13:31:49 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 28 Jul 2025 22:30:32 +0200
Subject: [PATCH RFC 28/29] xfs: add fsverity traces
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250728-fsverity-v1-28-9e5443af0e34@kernel.org>
References: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
In-Reply-To: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
To: fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, david@fromorbit.com, djwong@kernel.org, 
 ebiggers@kernel.org, hch@lst.de
Cc: Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3248; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=zC5E6t95NKV87LeykIKXUMiD57k/Zr4doqPRYj1WOUY=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMtrvSX7Ttr43pVubVcn7UNkRz++GEfckXyldvqHz4
 YPm+4ZPmlkdpSwMYlwMsmKKLOuktaYmFUnlHzGokYeZw8oEMoSBi1MAJtI1m5FhrWemVnxkIl+R
 eH5Ru7LXMqFfa/8t0bz/kHXefiX2jTuLGBn6NLbW8a7m5rHnEs+708a5aUXPJx7+R0bNi61f9fx
 hb+cCAAbtRJg=
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

Even though fsverity has traces, debugging issues with varying block
sizes could a bit less transparent without read/write traces.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_fsverity.c |  8 ++++++++
 fs/xfs/xfs_trace.h    | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
index dfe7b0bcd97e..4d3fd00237b1 100644
--- a/fs/xfs/xfs_fsverity.c
+++ b/fs/xfs/xfs_fsverity.c
@@ -70,6 +70,8 @@ xfs_fsverity_get_descriptor(
 	};
 	int			error = 0;
 
+	trace_xfs_fsverity_get_descriptor(ip);
+
 	/*
 	 * The fact that (returned attribute size) == (provided buf_size) is
 	 * checked by xfs_attr_copy_value() (returns -ERANGE).  No descriptor
@@ -267,6 +269,8 @@ xfs_fsverity_read_merkle(
 	 */
 	xfs_fsverity_adjust_read(&region);
 
+	trace_xfs_fsverity_read_merkle(XFS_I(inode), region.pos, region.length);
+
 	folio = iomap_read_region(&region);
 	if (IS_ERR(folio))
 		return ERR_PTR(-EIO);
@@ -297,6 +301,8 @@ xfs_fsverity_write_merkle(
 		.ops				= &xfs_buffered_write_iomap_ops,
 	};
 
+	trace_xfs_fsverity_write_merkle(XFS_I(inode), region.pos, region.length);
+
 	if (region.pos + region.length > inode->i_sb->s_maxbytes)
 		return -EFBIG;
 
@@ -309,6 +315,8 @@ xfs_fsverity_file_corrupt(
 	loff_t			pos,
 	size_t			len)
 {
+	trace_xfs_fsverity_file_corrupt(XFS_I(inode), pos, len);
+
 	xfs_inode_mark_sick(XFS_I(inode), XFS_SICK_INO_DATA);
 }
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 50034c059e8c..4477d5412e53 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -5979,6 +5979,52 @@ DEFINE_EVENT(xfs_freeblocks_resv_class, name, \
 DEFINE_FREEBLOCKS_RESV_EVENT(xfs_freecounter_reserved);
 DEFINE_FREEBLOCKS_RESV_EVENT(xfs_freecounter_enospc);
 
+TRACE_EVENT(xfs_fsverity_get_descriptor,
+	TP_PROTO(struct xfs_inode *ip),
+	TP_ARGS(ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+	),
+	TP_printk("dev %d:%d ino 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino)
+);
+
+DECLARE_EVENT_CLASS(xfs_fsverity_class,
+	TP_PROTO(struct xfs_inode *ip, u64 pos, unsigned int length),
+	TP_ARGS(ip, pos, length),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(u64, pos)
+		__field(unsigned int, length)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(ip)->i_sb->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->pos = pos;
+		__entry->length = length;
+	),
+	TP_printk("dev %d:%d ino 0x%llx pos %llx length %x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->pos,
+		  __entry->length)
+)
+
+#define DEFINE_FSVERITY_EVENT(name) \
+DEFINE_EVENT(xfs_fsverity_class, name, \
+	TP_PROTO(struct xfs_inode *ip, u64 pos, unsigned int length), \
+	TP_ARGS(ip, pos, length))
+DEFINE_FSVERITY_EVENT(xfs_fsverity_read_merkle);
+DEFINE_FSVERITY_EVENT(xfs_fsverity_write_merkle);
+DEFINE_FSVERITY_EVENT(xfs_fsverity_file_corrupt);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

-- 
2.50.0

