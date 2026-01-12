Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FEE2D5C6C
	for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 14:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768229542; cv=none; b=WulRiU3QEFCjO36QJ0lmbjqdaUgF5hVZqezic8y/4S7elehHx7IB34EQ5o2BlU87zArHjEdsPdXvfVS/VpcReex/lLrLu5e+23c3TSW3VhhUWVTVFVtzotNa2XER+5+lTTwtWdJdK87SGqBdtzBtCgJKj1DnsHoNRr3GGoKP0jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768229542; c=relaxed/simple;
	bh=DqGbPHihgvouI+HlmdtnScxnStrH4+HE2WznQSyP4j4=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MFUXWsCJBcEKScY3IkCh/noguXP7WAyS3ptaOEbg666G607OqT52Vdm35ZZ3uCiy/M2I8xfr96RBPPaTZ/nLeSrwXC8kyquSh6bY8n84y8G1iqvglQcNJI3A5bnksqIqXRtABqLRdH7aZ1526AZrxxDzVdwPLSmbgwWdJC6YDZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K8ExZSbI; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=b4v30Tzm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K8ExZSbI";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="b4v30Tzm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768229540;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xPYPAB6be13BNA+rNTQIlJZgdC6UYp82gudM/SKVgcg=;
	b=K8ExZSbIwk4ICjnjy3BLJYRO0xIA+XLCOsv9MEnDdIXEAbWzvVOK6Ckck6z0Fb8Egp6KEa
	sjzHh6rs7g+N9YlnDbZwnBTko7x5r+rvfAzp9VTSUT9dhl5az9HW3gWutMbuBGxUt7fVO4
	ZZ2GhbZrPdgVE/3LRv+RQ+e1+Qcv6rk=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-21-BBItgpJxOVe5QD9TmlnhcA-1; Mon, 12 Jan 2026 09:52:17 -0500
X-MC-Unique: BBItgpJxOVe5QD9TmlnhcA-1
X-Mimecast-MFC-AGG-ID: BBItgpJxOVe5QD9TmlnhcA_1768229536
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-b7a29e6f9a0so646377466b.1
        for <linux-xfs@vger.kernel.org>; Mon, 12 Jan 2026 06:52:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768229536; x=1768834336; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xPYPAB6be13BNA+rNTQIlJZgdC6UYp82gudM/SKVgcg=;
        b=b4v30TzmZAiJn9WiNu5L73uSDOfZ8yG/XQDvq4YGLnx58I2mO9hW4/h0lyYlpAa6WV
         PtEtHKpmF9nKzCOGvUjunvMp0dsTUhOppjIwAqf6GwyTbg5MhKpeYrLjT/XyeuWNKOSg
         ybexhQQ3A3V1xsDi6QR0LaS3gZpE9qMwBNfj1tBHYg1CSQYbf60oYW5HPw6XmsygnFU1
         sgpXaait7Xy+s+b52HCSX8NOq8GHYoUEBQsj1KsDbdeqHqL0AdkJGIPenH3/gQX1rtLR
         lxlaw6/Bc86cihJPxWwzDTlBrGHpD0ujVejNiU7GQb8ZV5U0Uqm2UIqxOBe54FAW0N5a
         7N2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768229536; x=1768834336;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xPYPAB6be13BNA+rNTQIlJZgdC6UYp82gudM/SKVgcg=;
        b=kIPDo9X4BAvtjUi7AuvKquP1onzNM8ZAuzSa039Mjf6qxzhty495mMMkfoYC3RSFT9
         cg5NLLIPHgG8HG0hnzXPEAQ7Oyoq/Zsr0JGQxkFwftjbSfQMzGiqGyLIKa5mZPjg+NJh
         tKLH06Z3W/97nv7CE4ckGdotd4yiQLdgC0zYyy7wEnz3Ile9udCO3xbT+YcEkFS+4ppt
         b3aBQA5p+fKDu+9nElpMXzWX5n4QaBWjX0jOjBb1S8oSiNQlmsfUgURirFV6C/p3VZZO
         ZI5qXXs+AAD6RjMUJ7HlLAr5rbIllz4TBeofgl4IJ9cPXubcb32XEQFOEk0JolA2KtCX
         ykYw==
X-Forwarded-Encrypted: i=1; AJvYcCW8aAUaRu7BLVlflD2/e/upHPDPiOQIGHG/TRtGVr45IaeS1fqUWPQvppMfqsgw1evHMyb48pI7PVw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwL3vU584AxoFSJRnxRWV3h4e9s1wxepdNBnWgqcwi4P8PkL+I0
	u7a4Db4RW5K6QWwZAfzFk3dAjN/MoO5tXaR1aIhkJBXZW8v1NQ9AhJ8Tg9KVECgGeG2ScquBUvb
	FjVPn8G/5gf4aUfoh4qC1+UoxLzLf7LOszda8Q7+GyAPhbJydQAg7UntpMN7U
X-Gm-Gg: AY/fxX5xOgUh6cGHWsXQEEoN5a4sNVMxtNvOPHDGuGflO6SRVMrQ22ftnBYlgDG0r50
	CCQTYqho3Mj+OASP94tyBcKLqIwuPiQgVFeifnIiklf8LFCa5FsVo1ujxNXZIY1tPjGBSpFgv0K
	lZSXv/zYB+inukXu67v7IP5Ri3+5QNchI5YFyY6AJbyOTB6E81TuQOB4u9j3HzuCLI5tvaRMYLl
	fX7HYdan6G7TAAQTXO9NHwrPjThSSMF+cJFSYcgrY4WXIBZtzEUrJ1Aoph4lefawE9z5rgxWpSF
	wWwUk469HUCndC3eHTWz5cEGBskEsENF+HrsOayOYXv6y5iDeoAJcNaXUlJW8UCCA+KH5BzY
X-Received: by 2002:a17:907:841:b0:b83:9767:c8ba with SMTP id a640c23a62f3a-b84451b5d1dmr1635823466b.17.1768229535751;
        Mon, 12 Jan 2026 06:52:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH+AXG1fXAqNi7crMM7QiDNAwZR8bNUqqDvj5BznuxA4nKTk8GLk6KKY85CmsHuZWbeWD797w==
X-Received: by 2002:a17:907:841:b0:b83:9767:c8ba with SMTP id a640c23a62f3a-b84451b5d1dmr1635820866b.17.1768229535247;
        Mon, 12 Jan 2026 06:52:15 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8429fdf4e7sm1985599466b.0.2026.01.12.06.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 06:52:14 -0800 (PST)
From: "Darrick J. Wong" <aalbersh@redhat.com>
X-Google-Original-From: "Darrick J. Wong" <djwong@kernel.org>
Date: Mon, 12 Jan 2026 15:52:13 +0100
To: fsverity@lists.linux.dev, linux-xfs@vger.kernel.org, 
	ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, aalbersh@kernel.org, 
	aalbersh@redhat.com, djwong@kernel.org
Cc: djwong@kernel.org, david@fromorbit.com, hch@lst.de
Subject: [PATCH v2 20/22] xfs: report verity failures through the health
 system
Message-ID: <i4tsa4dqqhjfutocdlk6mqm6ovvzea7ki2w32j6mcew66aegay@tsllwgeogm3f>
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

Record verity failures and report them through the health system.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h     |  1 +
 fs/xfs/libxfs/xfs_health.h |  4 +++-
 fs/xfs/xfs_fsverity.c      | 11 +++++++++++
 fs/xfs/xfs_health.c        |  1 +
 4 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 3db9beb579..b82fef9a1f 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -422,6 +422,7 @@
 #define XFS_BS_SICK_SYMLINK	(1 << 6)  /* symbolic link remote target */
 #define XFS_BS_SICK_PARENT	(1 << 7)  /* parent pointers */
 #define XFS_BS_SICK_DIRTREE	(1 << 8)  /* directory tree structure */
+#define XFS_BS_SICK_DATA	(1 << 9)  /* file data */
 
 /*
  * Project quota id helpers (previously projid was 16bit only
diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index b31000f719..fa91916ad0 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -104,6 +104,7 @@
 /* Don't propagate sick status to ag health summary during inactivation */
 #define XFS_SICK_INO_FORGET	(1 << 12)
 #define XFS_SICK_INO_DIRTREE	(1 << 13)  /* directory tree structure */
+#define XFS_SICK_INO_DATA	(1 << 14)  /* file data */
 
 /* Primary evidence of health problems in a given group. */
 #define XFS_SICK_FS_PRIMARY	(XFS_SICK_FS_COUNTERS | \
@@ -140,7 +141,8 @@
 				 XFS_SICK_INO_XATTR | \
 				 XFS_SICK_INO_SYMLINK | \
 				 XFS_SICK_INO_PARENT | \
-				 XFS_SICK_INO_DIRTREE)
+				 XFS_SICK_INO_DIRTREE | \
+				 XFS_SICK_INO_DATA)
 
 #define XFS_SICK_INO_ZAPPED	(XFS_SICK_INO_BMBTD_ZAPPED | \
 				 XFS_SICK_INO_BMBTA_ZAPPED | \
diff --git a/fs/xfs/xfs_fsverity.c b/fs/xfs/xfs_fsverity.c
index 691dc60778..f53a404578 100644
--- a/fs/xfs/xfs_fsverity.c
+++ b/fs/xfs/xfs_fsverity.c
@@ -18,6 +18,7 @@
 #include "xfs_quota.h"
 #include "xfs_fsverity.h"
 #include "xfs_iomap.h"
+#include "xfs_health.h"
 #include <linux/fsverity.h>
 #include <linux/pagemap.h>
 
@@ -363,6 +364,15 @@
 	return xfs_fsverity_write(ip, position, size, buf);
 }
 
+static void
+xfs_fsverity_file_corrupt(
+	struct inode		*inode,
+	loff_t			pos,
+	size_t			len)
+{
+	xfs_inode_mark_sick(XFS_I(inode), XFS_SICK_INO_DATA);
+}
+
 const ptrdiff_t info_offs = (int)offsetof(struct xfs_inode, i_verity_info) -
 			    (int)offsetof(struct xfs_inode, i_vnode);
 
@@ -373,4 +383,5 @@
 	.get_verity_descriptor		= xfs_fsverity_get_descriptor,
 	.read_merkle_tree_page		= xfs_fsverity_read_merkle,
 	.write_merkle_tree_block	= xfs_fsverity_write_merkle,
+	.file_corrupt			= xfs_fsverity_file_corrupt,
 };
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 3c1557fb1c..b851651c02 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -487,6 +487,7 @@
 	{ XFS_SICK_INO_DIR_ZAPPED,	XFS_BS_SICK_DIR },
 	{ XFS_SICK_INO_SYMLINK_ZAPPED,	XFS_BS_SICK_SYMLINK },
 	{ XFS_SICK_INO_DIRTREE,	XFS_BS_SICK_DIRTREE },
+	{ XFS_SICK_INO_DATA,	XFS_BS_SICK_DATA },
 };
 
 /* Fill out bulkstat health info. */

-- 
- Andrey

