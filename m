Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342042DBF40
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 14:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229547; cv=none; b=hJq4r+KbFL2DQ2y9afbN1bRxiUpFJqNsvTULFG+W+WDnbaQ+568DJw39C7+oj2cA95+s0gauwUnaUjs83vq3uiWzweGBAapsJN8FOa7deLi0MA/8LhJxplYgCfpMri+wjDV6yBQqcXEASCAwyNATnKp25ll30IQUDFMFGf0m95U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229547; c=relaxed/simple;
	bh=OQm+dEOLwCOaBZFuA5nZqimBMgAHXvnADpLM7rK/i+I=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BRoetULUK6wmbndXenzXGIR2m5vFwvXI8sNwyoJtAaVQB+N8Eace+hUNujZ1qkdmFU0bPXi8XCWdWT8fQDtkjmbTHFpgHojOYocHAh5mnT02sBZcbGDZrpzktqmFC1b6fq/Qpib36Hm4GcvNl03+1v/djhWLWwYnApTlvExiQ9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d6ydY7io; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=cUuTjDjD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d6ydY7io";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="cUuTjDjD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768229545;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TWmDG1ER0LR9GL8XgLI8QAK75PZeybk5fg0A4H3Djn4=;
	b=d6ydY7ioS7eFKErdyMQDbS0BOhwSCuFiFbjCt+MkRMkVKrVLNnz5llucB0xzb8iwIiuf/t
	AuQ6q0kk5BeEuIDhVdz5ITG23ZrHZC4xNNNhotT7SjCX6PdzAYYBMxjQEhUBsE+en55pTU
	6C1KUZVawGo/Pt93BAhpKirCfH4IqHc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-xHwOSGTrPdal9Xp0IIzIxw-1; Mon, 12 Jan 2026 09:52:23 -0500
X-MC-Unique: xHwOSGTrPdal9Xp0IIzIxw-1
X-Mimecast-MFC-AGG-ID: xHwOSGTrPdal9Xp0IIzIxw_1768229543
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-b8709d4ff20so151142966b.0
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 06:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768229542; x=1768834342; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TWmDG1ER0LR9GL8XgLI8QAK75PZeybk5fg0A4H3Djn4=;
        b=cUuTjDjDa2wYTssWvTwLwcV8QGbyuHqu6DzXRIPMz+vuvQ/w0GqFymxNmW58ZXVf3+
         HvD03z0L6Xwkgd5nHH3ScotKgyo9ofB3xu3kWBW5vxPnV3VEn/d4iOHQgnWBSQej1UqW
         RpEQtrUbF8BZtNHpAwid0ezlIWX0YkxjbiXSymX1GwhCNgnGToz/iD4M8e1KDwykoF2X
         kE9YpG7tD36hVwgJXtbk2TB7N8R51DcqhlM5aNtuj3YlRfRoQWnAISJAmOHby76HcVGx
         aKsp7CUh1bxmuorWLfW5bR27Gnh6Gjaj6IMiCez9WNlkVO2ud/+r041X72F9/s82CQMP
         gT9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768229542; x=1768834342;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TWmDG1ER0LR9GL8XgLI8QAK75PZeybk5fg0A4H3Djn4=;
        b=hyXnwaiIOPm42MyNniTDRLkYsQpJEu2XbsRT/vq2uuw7SXm3bSfIZIIaMPYDEs7e/7
         mYXa8WirTKr/KSQx3hyn3VRrg3jTWi83drznMOxE/awgg2zFo+wj83h5zuPJ0FsF0TtD
         mJdnYrcQzQNxVL81i55T1/W7kS6itEyh0LsJb/osuhAswRjn61eoN8ZgIWPgR6FPG2J5
         DYVkAUGZzHLxdrpLliBYqp+JA0NkZuxATn53yx5Qm2CkhmZ59Fg8mcFFxzKUkDwVZbOO
         bvlAQCDkOyXRauJlWKAmM2TYptHdt587UQs2JiERLQ1XSi6blL24GrkNFeI4TzP770yn
         /gQA==
X-Forwarded-Encrypted: i=1; AJvYcCU6z51K46PplzcVcrsmwJ7bDWaHgfZE89xKCpdqqwOTNJmRebE86FSrGg/AloRVhjYw4Op+VU7QqmQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXAWm2+R58gEU7u7tnnttVyk+C9sXBEf75DqLfSeUmSfprZ1Eq
	0xb+PcjLJd36/HLIEBR6phEcFaCn0hEN1yUWy41Z7yvqysWsVgG8z9LWTj1QWx2RgA6WpKqUb7Z
	BGXwj1Ru8Ck09zXRNDE3IWGXe0acITpm8SbprlGCGuv9MagLJ9lVr0siRdfbp
X-Gm-Gg: AY/fxX6cntC0Gwv1Wk6zf85FxZvNNDVPgJua/RDOBa2zcyMBWpQ0s1SPW0iYOm7SWmv
	mw0HNJ0cFHZkjgjF1wEQrAhNqHS5fAa+f0irGS1vunDe+GacoYF9qltYtPLAhVaOjFosTYTOJ+x
	ApONcf/ULkRF8QnhuYxJLTcZRcwi6f7e0gem6+jo3lVjZY9hSgjLOR02Q10TDc1YSCe9AMVXbyc
	J1sgQEQ/GunKhkwE/sHAQs81noQXV0WQx7fJ3rjroFneTZQIUH+pQZaBADta8/Iyrxb0x4qPA8Q
	DKYWZmacd70OjjFb1rV7pFOxYDy8NO+kUnIg6zGgdyylLxJ+GK7ODcPzJIMvHJfp8sVScjIJ8m8
	=
X-Received: by 2002:a17:906:d555:b0:b87:2b1a:3c55 with SMTP id a640c23a62f3a-b872b1a53a4mr156462366b.39.1768229542440;
        Mon, 12 Jan 2026 06:52:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE+oCOD/RpTBmpg2mx41ExTgddYDgK7ppumJ3iw+DJn3a4n5UKSc4vFU0Z75/VqHP7AW9QvSQ==
X-Received: by 2002:a17:906:d555:b0:b87:2b1a:3c55 with SMTP id a640c23a62f3a-b872b1a53a4mr156458566b.39.1768229541846;
        Mon, 12 Jan 2026 06:52:21 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b842a4d1c61sm1897888566b.35.2026.01.12.06.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 06:52:21 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 12 Jan 2026 15:52:20 +0100
To: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, 
	ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, aalbersh@kernel.org, 
	aalbersh@redhat.com, djwong@kernel.org
Cc: djwong@kernel.org, david@fromorbit.com, hch@lst.de
Subject: [PATCH v2 21/22] xfs: add fsverity traces
Message-ID: <xvaenghd6d7rd5gnfbfm7zmp5dd4uqa2wchdxcfpxpp2cevp7i@a27fi4opexrk>
References: <cover.1768229271.patch-series@thinky>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1768229271.patch-series@thinky>

Even though fsverity has traces, debugging issues with varying block
sizes could be a bit less transparent without read/write traces.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/xfs_fsverity.c |  8 ++++++++
 fs/xfs/xfs_trace.h    | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
index f53a404578..06eac2561b 100644
--- a/fs/xfs/xfs_fsverity.c
+++ b/fs/xfs/xfs_fsverity.c
@@ -102,6 +102,8 @@
 	uint32_t		blocksize = i_blocksize(VFS_I(ip));
 	xfs_fileoff_t		last_block;
 
+	trace_xfs_fsverity_get_descriptor(ip);
+
 	ASSERT(inode->i_flags & S_VERITY);
 	error = xfs_bmap_last_extent(NULL, ip, XFS_DATA_FORK, &rec, &is_empty);
 	if (error)
@@ -330,6 +332,8 @@
 	pgoff_t			offset =
 			index | (XFS_FSVERITY_REGION_START >> PAGE_SHIFT);
 
+	trace_xfs_fsverity_read_merkle(XFS_I(inode), offset, PAGE_SIZE);
+
 	folio = __filemap_get_folio(inode->i_mapping, offset, FGP_ACCESSED, 0);
 	if (IS_ERR(folio) || !folio_test_uptodate(folio)) {
 		DEFINE_READAHEAD(ractl, NULL, NULL, inode->i_mapping, offset);
@@ -358,6 +362,8 @@
 	struct xfs_inode	*ip = XFS_I(inode);
 	loff_t			position = pos | XFS_FSVERITY_REGION_START;
 
+	trace_xfs_fsverity_write_merkle(XFS_I(inode), pos, size);
+
 	if (position + size > inode->i_sb->s_maxbytes)
 		return -EFBIG;
 
@@ -370,6 +376,8 @@
 	loff_t			pos,
 	size_t			len)
 {
+	trace_xfs_fsverity_file_corrupt(XFS_I(inode), pos, len);
+
 	xfs_inode_mark_sick(XFS_I(inode), XFS_SICK_INO_DATA);
 }
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index f70afbf3cb..1ce4e10b6b 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -5906,6 +5906,52 @@
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
- Andrey

