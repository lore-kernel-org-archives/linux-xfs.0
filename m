Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33993D571
	for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 16:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707757200; cv=none; b=nFqQmn4TF4Mu00Q8yxmdcjv+rTH28jlc/IbGglphAAFcgjwSSiWzILsv2zBGykhjXBKfWnGtoAJeBofy/zaEvjh5K2pk1oW1o7iXDRhSJcN3w8QwRpISmknP26oMzdhfb7YOsK5uMiwQCGbIc8uNJDe8NhkTEcpTEBn3jvmAld8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707757200; c=relaxed/simple;
	bh=cvhOJNMgYbCTZs0crMMOB5Pl60dq3zxJ6bSAHeiofko=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ho8vcIFZi2BFXR9hpvcpA2chuGPNdyhaCZqvHHIE8SRT93XttK3JGUl3Zr0X5coAn/jUNCY/5Q01WY1nkw+xqLxyRHdkbi8uYvu1Mhp1NxiX9q3isJ9MBQxpUq+66SLgDnu62XPh+9QGaY3zn/l8v+vA6qms9xIeMkV3dOlwLPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QgkvNQzR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QgkvNQzR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707757197;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2eZDjHaP7Kupt8d6Iu2ty2GFMw3W0f+xpOseohnHwTk=;
	b=QgkvNQzRABClfyHN7EUeiR8M2W4rUFw3Gwl3+n9KRatC0j4m+ZfppebrNRH9mSJxN0lvQr
	v4tq1BO+UyrgKJk3npvNw3TVm9iHOoDHoCtXiHCq2BrEEpDIyJwhtXJHuVUCEYY/cv6MNx
	UZiynRqKqpiLokcYf3vWRf8tz88sDjM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-307-iL-5HdG7O6WgTW8KG55LMg-1; Mon, 12 Feb 2024 11:59:56 -0500
X-MC-Unique: iL-5HdG7O6WgTW8KG55LMg-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5597da35ebbso2420661a12.2
        for <linux-xfs@vger.kernel.org>; Mon, 12 Feb 2024 08:59:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707757195; x=1708361995;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2eZDjHaP7Kupt8d6Iu2ty2GFMw3W0f+xpOseohnHwTk=;
        b=tT31Kk7rO/dAMtz8ewgSw7QPs/oPTQRPLZHdgshWrtOKqvN0KglGBruQVj7+HlszyX
         Y6masmVuTFR6um8hy8ffTNi44pQs9LAHN13iJrQ3NxxsO7Ij7jW5TzfoZHSIMkzoMFrk
         5LSgxebOV0H77WGVwLem+3Lz9EgHIuFFCEmZIwEFN/lC/S3e89RikPYOvMA2KhNtuCQ8
         a+lRP2kRdaQtKbrmBYHYWwKjLuCJDgtfGSejuoULGh9GWHCA+x4YHbn0Xrp/XHpksJOp
         BDsSOoi7A2k65g4O9E6hmrmZdWIN6nSfWToqOjZpcs582Lj8kwxAeOkAk//l/kDP4Fy2
         ZcxA==
X-Gm-Message-State: AOJu0YxobdL4Fv+CjRhaeaWRhWkM0X3IYOXFPquBJvm1YOF+hJd8sCBt
	eQZ9M+koNXyk7Qm5IQ1vRrvOCgLOo62iOyZ3w5m+xXv4QTcgXkffTRjpNvlcQrxs+8RPGMv7SAa
	yMJv55ahKajIN9ZVOaMCtAPp9O7QPE9aZKyxmaprBx3xp05JTEuNi3dV0
X-Received: by 2002:a05:6402:544:b0:55f:c3c1:34e with SMTP id i4-20020a056402054400b0055fc3c1034emr1476950edx.15.1707757195350;
        Mon, 12 Feb 2024 08:59:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGyQP1vpD0d7s1DLfQrdN0VArL3Z7/S/UGhBKfUY5OPPaBlXP9kgpE6F85URgM94E6HCoBQBw==
X-Received: by 2002:a05:6402:544:b0:55f:c3c1:34e with SMTP id i4-20020a056402054400b0055fc3c1034emr1476936edx.15.1707757195175;
        Mon, 12 Feb 2024 08:59:55 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVMULeE9s3nH+f2UMQCVjIYAATNr91A4Ha5f9VSJraW6oqpiPL3tmAHAY6PdEz054BS664a2YaRiaMUr/8qUiCssI9wfT114LLRO4KVxI9+V0jszODBczr1+t3NlI/Rz45VtOoo6Ui5gEPxUDyPQKU3N9O2/8/ta9Zk1gx9LBEHd/xz9LtHu9mXtCI9WUv9KptxyN5Fs3L6rp+W5VAUwLQh/y9gvRq8YnP/
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id 14-20020a0564021f4e00b0056176e95a88sm2620261edz.32.2024.02.12.08.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Feb 2024 08:59:54 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v4 05/25] fs: add FS_XFLAG_VERITY for verity files
Date: Mon, 12 Feb 2024 17:58:02 +0100
Message-Id: <20240212165821.1901300-6-aalbersh@redhat.com>
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

Add extended attribute FS_XFLAG_VERITY for inodes with fs-verity
enabled.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 Documentation/filesystems/fsverity.rst | 12 ++++++++++++
 fs/ioctl.c                             | 11 +++++++++++
 include/uapi/linux/fs.h                |  1 +
 3 files changed, 24 insertions(+)

diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
index 13e4b18e5dbb..19e59e87999e 100644
--- a/Documentation/filesystems/fsverity.rst
+++ b/Documentation/filesystems/fsverity.rst
@@ -326,6 +326,18 @@ the file has fs-verity enabled.  This can perform better than
 FS_IOC_GETFLAGS and FS_IOC_MEASURE_VERITY because it doesn't require
 opening the file, and opening verity files can be expensive.
 
+FS_IOC_FSGETXATTR
+-----------------
+
+Since Linux v6.9, FS_XFLAG_VERITY (0x00020000) file attribute is set for verity
+files. The attribute can be observed via lsattr.
+
+    [root@vm:~]# lsattr /mnt/test/foo
+    --------------------V- /mnt/test/foo
+
+Note that this attribute cannot be set with FS_IOC_FSSETXATTR as enabling verity
+requires input parameters. See FS_IOC_ENABLE_VERITY.
+
 .. _accessing_verity_files:
 
 Accessing verity files
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 76cf22ac97d7..38c00e47c069 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -481,6 +481,8 @@ void fileattr_fill_xflags(struct fileattr *fa, u32 xflags)
 		fa->flags |= FS_DAX_FL;
 	if (fa->fsx_xflags & FS_XFLAG_PROJINHERIT)
 		fa->flags |= FS_PROJINHERIT_FL;
+	if (fa->fsx_xflags & FS_XFLAG_VERITY)
+		fa->flags |= FS_VERITY_FL;
 }
 EXPORT_SYMBOL(fileattr_fill_xflags);
 
@@ -511,6 +513,8 @@ void fileattr_fill_flags(struct fileattr *fa, u32 flags)
 		fa->fsx_xflags |= FS_XFLAG_DAX;
 	if (fa->flags & FS_PROJINHERIT_FL)
 		fa->fsx_xflags |= FS_XFLAG_PROJINHERIT;
+	if (fa->flags & FS_VERITY_FL)
+		fa->fsx_xflags |= FS_XFLAG_VERITY;
 }
 EXPORT_SYMBOL(fileattr_fill_flags);
 
@@ -641,6 +645,13 @@ static int fileattr_set_prepare(struct inode *inode,
 	    !(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
 		return -EINVAL;
 
+	/*
+	 * Verity cannot be set through FS_IOC_FSSETXATTR/FS_IOC_SETFLAGS.
+	 * See FS_IOC_ENABLE_VERITY
+	 */
+	if (fa->fsx_xflags & FS_XFLAG_VERITY)
+		return -EINVAL;
+
 	/* Extent size hints of zero turn off the flags. */
 	if (fa->fsx_extsize == 0)
 		fa->fsx_xflags &= ~(FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT);
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 48ad69f7722e..6e63ea832d4f 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -140,6 +140,7 @@ struct fsxattr {
 #define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
 #define FS_XFLAG_DAX		0x00008000	/* use DAX for IO */
 #define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
+#define FS_XFLAG_VERITY		0x00020000	/* fs-verity sealed inode */
 #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
 
 /* the read-only stuff doesn't really belong here, but any other place is
-- 
2.42.0

