Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E48A2D9EDB
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 14:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229448; cv=none; b=R8hOcyyKpl434IwZ2MDx921aAP1b8pwv5599OrmOrbEf06EPI856ia6lhnTJOCjenlZNDQeFWvIizWs9zoBdRo/+O0XGWMGQv/ZZr+lekR/o4Tiqx++THKfPaSKHqxvfY7V3Qq4Xu1uBSlE5lV4M1jQ3j3Nz8CFFWSC2oHl+psI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229448; c=relaxed/simple;
	bh=+9KMgGt3/7caMsee+Z5WvgdzDLlVEyt0+rlirmS1zuc=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sSwgmUCy/n3QmdCrMalDqQSbDCTEZMxwP2eaudhga1/d3qNeq42zQdCfnIdpgP8k2MwTA1tVuhfLjpqfrz32UepWoDdccsD5pF1tVICmtZMYhuyMSv81R50EK1RVNg1b/5JdY1dEiQUV1qEZHmxFwdqsr3CNQVxEqn/rtMpFY28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TF6Mzhmg; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=htjNlzb5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TF6Mzhmg";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="htjNlzb5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768229446;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wg9iw92qCFC8ETA0UphY+p99eAf356mavdt9eRroIQw=;
	b=TF6MzhmgTPYEy6ZcNDKXnzI5BXRKW679CZyZ51Drh+DtDEjRl5sEqRHDn0tp25EEuEecLR
	BM6sZ0boXKm1OzlvrQkO8SDY4jagXLajZawNmcNWOhY++Rx7rcwyP38YTxk07qzQCHrWNI
	/XBieqkg7YfwhOTlbjB/BQ9c7Go2j/4=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-351-eJKLv74FP3i344UXx3kvnw-1; Mon, 12 Jan 2026 09:50:42 -0500
X-MC-Unique: eJKLv74FP3i344UXx3kvnw-1
X-Mimecast-MFC-AGG-ID: eJKLv74FP3i344UXx3kvnw_1768229441
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-b8704795d25so179265466b.2
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 06:50:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768229441; x=1768834241; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wg9iw92qCFC8ETA0UphY+p99eAf356mavdt9eRroIQw=;
        b=htjNlzb5OVygVjE0lQh7sUH7nnx/M+MQFbMB7An7SV+rKQDic95OClPPgjiaPCWIvA
         sSjPF0ddEZvqxGXvDZ1TAIyeu7wxQzjQmvVVhdWHDbFUzfL+XHXI4B3ly7kknadEGTK6
         JXWjePw+3H4Rg5XA9MK+S0ioy2Qs4FJYjBi4py3oHH5KfhxHQA6XH1N23rtd9DS7Na62
         h9q9MWDKeF02ys2HvzK1Shu/650YAoLxqoWHR82CjGRINYXXiyyhaLuR1lBiFXjC0+gm
         T14aBvbgqN/NRJxJaoaPrGEJHj8rrBKUiq9x2FUu2HuRR9PyI/lWWTQ6+YK6bNA3wVrZ
         sNLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768229441; x=1768834241;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wg9iw92qCFC8ETA0UphY+p99eAf356mavdt9eRroIQw=;
        b=gn2GSVm8jGYO5GfhWc8la7bNxt/iz7ydeZJEmZpgCHrQc+upiQqmzSh+fQldLPQjQU
         zlaI5rLXYh4h1edRVLieOctEwQenrdGSc2aiP116ZUbVLK0CbKQNed1FKIwITsKn9irZ
         E0L/lm7FXWvZaf6MUFzI1uU6Wwn7b/kbl0fDL5G23fHiTgFy9LhE/wJ8DGQm5hBKpE81
         QdHnKR8lwY0F/2ufvhqqDxo6gPHrYRtOP6Er5Ra2nQ4XD5kMYJHC4zrFnLDsT8b5sssR
         pvVVJsKwGsWogHaE2rgernwRVwVghGkyL5RXjNWqzkxDlXgWeJ412lEiH8fKf+kcOAwN
         UiSw==
X-Forwarded-Encrypted: i=1; AJvYcCU6AwcxcgNT8eRzt3sgDcGAoGdVxXlwgp298aIk5Ykq1eY6vbnQBg7gOHBoy0dKhIJ1uZP15aOXWeI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhW4+jVtwYpqA9pqoDsfB0IE2qpzzWvZZqesXs8hPjCOB1X38U
	JVntDDK6BrFQJc1HpNJ4EPJNLvgUberP5TUZGQWwyWL3/0ums+MHxfMZLFlSqpkTHLLaTcGzEa9
	pEhyuhvQTQNslEQ7owjFzESEz6Xe22jVWOFu7WTmbf79GVAi+SLKz5vx0RaVi
X-Gm-Gg: AY/fxX53L5t1ZYg/7dwrubie9/ybcZm87TT1dstjXbu86Lr1d80ZpvRKoxlyzW0qQEv
	XLfIwb7kHBYw57XsJJEmes4kqHIfU5R+eHP7W57qxkzIxHzf1jdvAaIvByKC6Qsmt4Mqoc9cbmr
	vriypLzlIien13V6z6RET+E6bt6hGlvS0bzsVqeCM+l2sm/sHdSKEdre8yLJv2ZEWfX9PNsAGPL
	T2lbJ0bHs2k4yWknddTbJOgo2ZR4QJ6O4MejNBNtLmTcAA4oCZrXoheQBByE/FsytE0VBCOBmw7
	+Wf39FWPfAKIHFwHoZKE1vudDkeg+Q5q3F9p4IzX9phy0XM3XZIXGi75pzO8YZS1Skce4dAd3X0
	=
X-Received: by 2002:a17:907:98d:b0:b77:1a42:d5c0 with SMTP id a640c23a62f3a-b844538b3e4mr1950906566b.43.1768229440647;
        Mon, 12 Jan 2026 06:50:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGH2I2rt33a1ynUI4l9WFzFWdhTqQCngUGOXshJjWZ4QNCMhR7ys+oc7vCzG5OqUt6Hb6NJoQ==
X-Received: by 2002:a17:907:98d:b0:b77:1a42:d5c0 with SMTP id a640c23a62f3a-b844538b3e4mr1950903866b.43.1768229440164;
        Mon, 12 Jan 2026 06:50:40 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b86fc303d7esm712764766b.2.2026.01.12.06.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 06:50:39 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 12 Jan 2026 15:50:39 +0100
To: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, 
	ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, aalbersh@kernel.org, 
	aalbersh@redhat.com, djwong@kernel.org
Cc: djwong@kernel.org, david@fromorbit.com, hch@lst.de
Subject: [PATCH v2 7/22] xfs: add inode on-disk VERITY flag
Message-ID: <2hvx4mnwgcdhzcaoyvi37cn4b5wct6zvsz3cswkjrkrrdh3ngl@udq26gd3dd4h>
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

Add flag to mark inodes which have fs-verity enabled on them (i.e.
descriptor exist and tree is built).

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h     | 7 ++++++-
 fs/xfs/libxfs/xfs_inode_buf.c  | 8 ++++++++
 fs/xfs/libxfs/xfs_inode_util.c | 2 ++
 fs/xfs/xfs_iops.c              | 2 ++
 4 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 64c2acd1cf..d67b404964 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1231,16 +1231,21 @@
  */
 #define XFS_DIFLAG2_METADATA_BIT	5
 
+/* inodes sealed with fs-verity */
+#define XFS_DIFLAG2_VERITY_BIT		6
+
 #define XFS_DIFLAG2_DAX		(1ULL << XFS_DIFLAG2_DAX_BIT)
 #define XFS_DIFLAG2_REFLINK	(1ULL << XFS_DIFLAG2_REFLINK_BIT)
 #define XFS_DIFLAG2_COWEXTSIZE	(1ULL << XFS_DIFLAG2_COWEXTSIZE_BIT)
 #define XFS_DIFLAG2_BIGTIME	(1ULL << XFS_DIFLAG2_BIGTIME_BIT)
 #define XFS_DIFLAG2_NREXT64	(1ULL << XFS_DIFLAG2_NREXT64_BIT)
 #define XFS_DIFLAG2_METADATA	(1ULL << XFS_DIFLAG2_METADATA_BIT)
+#define XFS_DIFLAG2_VERITY	(1ULL << XFS_DIFLAG2_VERITY_BIT)
 
 #define XFS_DIFLAG2_ANY \
 	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
-	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64 | XFS_DIFLAG2_METADATA)
+	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64 | XFS_DIFLAG2_METADATA | \
+	 XFS_DIFLAG2_VERITY)
 
 static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
 {
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index b1812b2c3c..c4fff7a34c 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -756,6 +756,14 @@
 	    !xfs_has_rtreflink(mp))
 		return __this_address;
 
+	/* only regular files can have fsverity */
+	if (flags2 & XFS_DIFLAG2_VERITY) {
+		if (!xfs_has_verity(mp))
+			return __this_address;
+		if ((mode & S_IFMT) != S_IFREG)
+			return __this_address;
+	}
+
 	if (xfs_has_zoned(mp) &&
 	    dip->di_metatype == cpu_to_be16(XFS_METAFILE_RTRMAP)) {
 		if (be32_to_cpu(dip->di_used_blocks) > mp->m_sb.sb_rgextents)
diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 309ce6dd55..aaf51207b2 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -126,6 +126,8 @@
 			flags |= FS_XFLAG_DAX;
 		if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
 			flags |= FS_XFLAG_COWEXTSIZE;
+		if (ip->i_diflags2 & XFS_DIFLAG2_VERITY)
+			flags |= FS_XFLAG_VERITY;
 	}
 
 	if (xfs_inode_has_attr_fork(ip))
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index ad94fbf550..6b8e4e87ab 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1394,6 +1394,8 @@
 		flags |= S_NOATIME;
 	if (init && xfs_inode_should_enable_dax(ip))
 		flags |= S_DAX;
+	if (xflags & FS_XFLAG_VERITY)
+		flags |= S_VERITY;
 
 	/*
 	 * S_DAX can only be set during inode initialization and is never set by

-- 
- Andrey

