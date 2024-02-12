Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C3B3F9DE
	for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 17:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707757214; cv=none; b=tMR67tr1BZVjTcobAlBwJsTzjieG+Nx+EGV3bLSSz/sfq9BgFbreNsZuGxs/zdNLloW8kTHkl7kJKR9a79OjfQJHOdisLXl21H2pjTknSSXDiSqPYuWcO8MjiV2gtNQKKoNXXflclNf4HgYX5BH1chAV8u18cLmWRfeNSVCHzBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707757214; c=relaxed/simple;
	bh=VFVpQAY1yHQkk5bXii9EmNF0UK6uzvEHbR0wcMktVt8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rSuRiQPAayTEYO5De/9507LtvsSEs2l3LCDl984ldn36n//F2X6tn5fAWJlVplDYkyLzEFnNHav1I54F/M390zVuWK6sGiA36QbHOmSRCIfr2Adrdl0kUYyxOcpmuI2AR9rWwHSW/rc/izfEbHtrdla9GtedZgRvaIefVZ8+NyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cN3VfuUL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cN3VfuUL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707757212;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tiuisFhZ01Xx+frHUN8loKfI2Y8CDrnkd+/7+0mxXSk=;
	b=cN3VfuUL4UEPxMFO+lDYjofCd+o2C+la+EmnlBLOEbDOAgLbBLI+iTl6hpWA7dggvTO6H1
	jqjZgqIlj1UaMBgRz8D2f0XFXVNptcvkXVepKIc/ijvAVeH7kqq5PXuPp6wR0IwTxCMYNJ
	t+NZmWunKEmSt8bS0Gtge8r8cVhwYGk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-30-DorpCgAcM8uxCflEmLsIWw-1; Mon, 12 Feb 2024 12:00:10 -0500
X-MC-Unique: DorpCgAcM8uxCflEmLsIWw-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-55ffcfed2ffso4899348a12.0
        for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 09:00:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707757209; x=1708362009;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tiuisFhZ01Xx+frHUN8loKfI2Y8CDrnkd+/7+0mxXSk=;
        b=sq80C7NEo0JVvBiOTlOWoBWEBq3daLXR3XT9D4Jranbn4UEmhnWhldC3TORq08odqi
         ekITyfF/fuWZIG+GEAupO4UlfSKlNOIiNnd/24EyzS9il0wldkHCYR9BaGJ7zyJOxOSp
         8mYT5Fjj5krsTdP8d78sI4yBl4st6uCCEvURFv0pYLtzihWv5+Ib3leciAmZDE10SdtO
         nwaV+cfIfAshRcG0fIyghsaRgalBp4WorC5bJy1C8l01FRXn/mXYWX0DZqSgTcIuCsf3
         TR6A48+pOry/IZIQrz3PkDCV46MkCb6rOvwIUXuBESMMQO3+k+N8MDy3tfrQKAw4uG87
         qHlg==
X-Forwarded-Encrypted: i=1; AJvYcCXwHBuxTzQ5+6HYhloxId4IMXFshMz8jTAfbl0AzdnhsXCYPja9EmMEp3DnshpkRRi56wDwj9NeWaqnXH+arZYIm0MR50MYaH1I
X-Gm-Message-State: AOJu0YySgu77ePS+yESfGwKIetv+acFK0gO7VsDDAg0XzZf7dN5NfBtS
	hVS414S0Gh12ruDF4p8CMqjhbqOw/NDYZJVBTs9l0rvQCJS/VittMnhfi0QudcbA8HCBpm0Pghe
	rxluunmftHgxrpSGnqiPCPHECa3ZtgMz+KhXU+7T1y+1ESCe0U5qYjVG8
X-Received: by 2002:a05:6402:4588:b0:561:3704:329c with SMTP id ig8-20020a056402458800b005613704329cmr56794edb.8.1707757209511;
        Mon, 12 Feb 2024 09:00:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEuxzAP71PoZ30mFTqexOTp5LBYKtJ1+ia4lDX9BR+UnguJoMAMEB3bfsNjY6wGbLunlbH8qA==
X-Received: by 2002:a05:6402:4588:b0:561:3704:329c with SMTP id ig8-20020a056402458800b005613704329cmr56785edb.8.1707757209289;
        Mon, 12 Feb 2024 09:00:09 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWJ95d5sD/ABfexBLVCukFXxEVdPLi2uxPrxq7h7b6O3r5tRvyWmiChUW+KM4oxHqBFYBWUnH72E7n0u80Zs611q5Fi612VDRRm7DoOPBaTIRABRrH4jviKk85ZoQQVlLdyUwnYHmTBJk81tLGwMWnm6xqpTXCO9x3/LCRXpxTZCFUeR8RtoofFPTwbSctB5lVaw/S7oQktEVdvGbcwHFXWj8nCQ9uGt64q
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id 14-20020a0564021f4e00b0056176e95a88sm2620261edz.32.2024.02.12.09.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Feb 2024 09:00:07 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v4 14/25] xfs: add attribute type for fs-verity
Date: Mon, 12 Feb 2024 17:58:11 +0100
Message-Id: <20240212165821.1901300-15-aalbersh@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240212165821.1901300-1-aalbersh@redhat.com>
References: <20240212165821.1901300-1-aalbersh@redhat.com>
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
index 1b79c4de90bc..05b82e5b64fa 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -704,14 +704,22 @@ struct xfs_attr3_leafblock {
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
index eb7406c6ea41..8bc83d9645fe 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -973,6 +973,7 @@ struct xfs_icreate_log {
 #define XFS_ATTRI_FILTER_MASK		(XFS_ATTR_ROOT | \
 					 XFS_ATTR_SECURE | \
 					 XFS_ATTR_PARENT | \
+					 XFS_ATTR_VERITY | \
 					 XFS_ATTR_INCOMPLETE)
 
 /*
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index f02b6e558af5..048d83acda0a 100644
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
index 07e8a69f8e56..0dd78a43c1f1 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -84,7 +84,8 @@ struct xfs_perag;
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

