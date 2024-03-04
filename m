Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD317BAFB
	for <linux-xfs@vger.kernel.org>; Mon,  4 Mar 2024 19:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709579548; cv=none; b=XZLVuSPWJkg/vt23aS99qV+/Ql7uhAGuThyyAXGJqcNfu+ZGwdDFXcXu1jCs6F1689SWwVSBcyNSxHbB6Ke+aC91gAv4FeaXFDxYKyQnayrFI4vOCPu1AKp50UruaK6UMYh6CvJrb5yHR/ekMwRJbPdaXTw/UvqsZeweatGkHBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709579548; c=relaxed/simple;
	bh=XHcQPQykxWC7s2kFvNi66STYRWcCMuM23D2106/ZIcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HgVvukZvaK8yw/zwN+zr0/U8VHyYh2TUh2doUKQ1TVxIbWmiyd+9N3ry94OzwHbGQ7vO77Nm+wBQBUzIDiKueqVKCkf590f75hQhrGglizr9BWszgivGsHm7G6LcAO8O1cCP0BZQ4bcVB0bj81lsNXXDI0xFCD5KXn/Z8wTyNCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FZ8ZX89C; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FZ8ZX89C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709579545;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VZR5eTtljpGatStmm+GdRj3kRnj54o9FoI5mU15Gslw=;
	b=FZ8ZX89CLgYHHFx/IEu17EOTnM6LFZqGyOGaRU5c5m4sm9TVszzxJ7DtHS9fc48DNK37bI
	27jNSbn4jXZZOnlBh8MJZjGPgRd4mHy6B51FL/5ueIhWFVYu+mmFJK/GXI/cbiMPlqAIyU
	OWiQDgd/9R/Y1aTzp7xLLrpdM4SYShE=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-225-uw4OvRqNME2ehPVim1FgTA-1; Mon, 04 Mar 2024 14:12:24 -0500
X-MC-Unique: uw4OvRqNME2ehPVim1FgTA-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a451f44519fso147440966b.1
        for <linux-xfs@vger.kernel.org>; Mon, 04 Mar 2024 11:12:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709579543; x=1710184343;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VZR5eTtljpGatStmm+GdRj3kRnj54o9FoI5mU15Gslw=;
        b=Q90x6aSjudtijelU8q/+VWCN7/Fz/ip38b3h2lLOcuC+72gUHuhDgayfEyMte5nRUD
         42tS6nlXmtyRgLkA+lAivjVt0qHnHNTMhmKvcV5aYffAXplJk1M9Ugg5YB9sVA1UcLf6
         HM+0S947fnX2vw1/Y9WZRGHLWX6QgBCjC4WzITb3/OkuWZVMmjhB0HjXsiW0j7Vuxged
         Ec+drFHe6MLOb0wjPXwAq3xa5wUqf0VqqpGFCAvFVd49dQQo5ouVCHWDlPrKySdN6ikQ
         hnRVg9CASO7Ke+XNxwWywZ5VC7pEqGjmJ3bRlsh18lnS2+1J8tTq1Duje698fx6t05gd
         RhZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXbx3dbNdme6a0BHflBQSqtJ5ZRWiAXWfl3/QoPAjdxqQemYTUS5U2W7xiZXpWmx/mkyN4fMWj/LHYfhPD9SbzPohGhvjncgFhU
X-Gm-Message-State: AOJu0YwpOdtgtpK0J+z8rrxSYd6YETN7mnUm7mgHsjdDDbHEzj6KXYJO
	RlH2vPSW7Crk0KcGEXuX5QlqTzjWVBCBstaMysObvHXTSTCPKSdufMwYZ9APMc/yYgHqwUy7Y+U
	XiNLFWyrQkH8rXreK2yOAtzen5TxHgkX874/+GC5WmZnFPiFhyqkPUlZO
X-Received: by 2002:a17:906:b00b:b0:a45:84e7:b25a with SMTP id v11-20020a170906b00b00b00a4584e7b25amr398485ejy.12.1709579543312;
        Mon, 04 Mar 2024 11:12:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHaiOmDDptgsHTrDI8+xi/tHowlOhstTJgfFsYNplwiDI8lks5bXwfuu81Boid8d7CYPav+Ow==
X-Received: by 2002:a17:906:b00b:b0:a45:84e7:b25a with SMTP id v11-20020a170906b00b00b00a4584e7b25amr398444ejy.12.1709579542728;
        Mon, 04 Mar 2024 11:12:22 -0800 (PST)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a11-20020a1709064a4b00b00a44a04aa3cfsm3783319ejv.225.2024.03.04.11.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Mar 2024 11:12:22 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v5 13/24] xfs: add attribute type for fs-verity
Date: Mon,  4 Mar 2024 20:10:36 +0100
Message-ID: <20240304191046.157464-15-aalbersh@redhat.com>
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

The Merkle tree blocks and descriptor are stored in the extended
attributes of the inode. Add new attribute type for fs-verity
metadata. Add XFS_ATTR_INTERNAL_MASK to skip parent pointer and
fs-verity attributes as those are only for internal use. While we're
at it add a few comments in relevant places that internally visible
attributes are not suppose to be handled via interface defined in
xfs_xattr.c.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_da_format.h  | 10 +++++++++-
 fs/xfs/libxfs/xfs_log_format.h |  1 +
 fs/xfs/xfs_ioctl.c             |  5 +++++
 fs/xfs/xfs_trace.h             |  3 ++-
 fs/xfs/xfs_xattr.c             | 10 ++++++++++
 5 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 839df0e5401b..28d4ac6fa156 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -715,14 +715,22 @@ struct xfs_attr3_leafblock {
 #define	XFS_ATTR_ROOT_BIT	1	/* limit access to trusted attrs */
 #define	XFS_ATTR_SECURE_BIT	2	/* limit access to secure attrs */
 #define	XFS_ATTR_PARENT_BIT	3	/* parent pointer attrs */
+#define	XFS_ATTR_VERITY_BIT	4	/* verity merkle tree and descriptor */
 #define	XFS_ATTR_INCOMPLETE_BIT	7	/* attr in middle of create/delete */
 #define XFS_ATTR_LOCAL		(1u << XFS_ATTR_LOCAL_BIT)
 #define XFS_ATTR_ROOT		(1u << XFS_ATTR_ROOT_BIT)
 #define XFS_ATTR_SECURE		(1u << XFS_ATTR_SECURE_BIT)
 #define XFS_ATTR_PARENT		(1u << XFS_ATTR_PARENT_BIT)
+#define XFS_ATTR_VERITY		(1u << XFS_ATTR_VERITY_BIT)
 #define XFS_ATTR_INCOMPLETE	(1u << XFS_ATTR_INCOMPLETE_BIT)
 #define XFS_ATTR_NSP_ONDISK_MASK \
-			(XFS_ATTR_ROOT | XFS_ATTR_SECURE | XFS_ATTR_PARENT)
+			(XFS_ATTR_ROOT | XFS_ATTR_SECURE | XFS_ATTR_PARENT | \
+			 XFS_ATTR_VERITY)
+
+/*
+ * Internal attributes not exposed to the user
+ */
+#define XFS_ATTR_INTERNAL_MASK (XFS_ATTR_PARENT | XFS_ATTR_VERITY)
 
 /*
  * Alignment for namelist and valuelist entries (since they are mixed
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 9cbcba4bd363..407fadfb5c06 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -975,6 +975,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_FILTER_MASK		(XFS_ATTR_ROOT | \
 					 XFS_ATTR_SECURE | \
 					 XFS_ATTR_PARENT | \
+					 XFS_ATTR_VERITY | \
 					 XFS_ATTR_INCOMPLETE)
 
 /*
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d0e2cec6210d..ab61d7d552fb 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -352,6 +352,11 @@ static unsigned int
 xfs_attr_filter(
 	u32			ioc_flags)
 {
+	/*
+	 * Only externally visible attributes should be specified here.
+	 * Internally used attributes (such as parent pointers or fs-verity)
+	 * should not be exposed to userspace.
+	 */
 	if (ioc_flags & XFS_IOC_ATTR_ROOT)
 		return XFS_ATTR_ROOT;
 	if (ioc_flags & XFS_IOC_ATTR_SECURE)
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d4f1b2da21e7..9d4ae05abfc8 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -87,7 +87,8 @@ struct xfs_bmap_intent;
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
 	{ XFS_ATTR_SECURE,	"SECURE" }, \
 	{ XFS_ATTR_INCOMPLETE,	"INCOMPLETE" }, \
-	{ XFS_ATTR_PARENT,	"PARENT" }
+	{ XFS_ATTR_PARENT,	"PARENT" }, \
+	{ XFS_ATTR_VERITY,	"VERITY" }
 
 DECLARE_EVENT_CLASS(xfs_attr_list_class,
 	TP_PROTO(struct xfs_attr_list_context *ctx),
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 364104e1b38a..e4c88dde4e44 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -20,6 +20,13 @@
 
 #include <linux/posix_acl_xattr.h>
 
+/*
+ * This file defines interface to work with externally visible extended
+ * attributes, such as those in user, system or security namespaces. This
+ * interface should not be used for internally used attributes (consider
+ * xfs_attr.c).
+ */
+
 /*
  * Get permission to use log-assisted atomic exchange of file extents.
  *
@@ -244,6 +251,9 @@ xfs_xattr_put_listent(
 
 	ASSERT(context->count >= 0);
 
+	if (flags & XFS_ATTR_INTERNAL_MASK)
+		return;
+
 	if (flags & XFS_ATTR_ROOT) {
 #ifdef CONFIG_XFS_POSIX_ACL
 		if (namelen == SGI_ACL_FILE_SIZE &&
-- 
2.42.0

