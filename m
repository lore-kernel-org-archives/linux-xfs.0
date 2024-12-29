Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0FA1531C8
	for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 13:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735479595; cv=none; b=iKB9LnuDBBqRv169UTFgnSJvRvEQ+8qws+vt6EhbR8zaEOVz9VptUjn7cn95TQFUHZLFjmp64tB9BMllpI5CeGDk5fR/4m4sJYCQi2oSdCEV+LpU5ezzdQJzbfaiIQVbuh3itPLs7Bn1EIXPjweDvhJIL1Zl9UxWyF1ziByP+84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735479595; c=relaxed/simple;
	bh=ury2ZCpj2oRDcCXM3o8wbv9LWfBQM6b+c55TqhEj7Uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sV0pSxCUREB/+1A8Q5XG4kv1UbrevTI9jvIspFezc7RJnpwKaXbxTjmHvAygE1fCTETv3wzUEQj3PUVZ4PaDAIRiM7Y4F69wiknOJKIIMrHuNOpwP8zFPCUYCmk8syd7/NsvDJNSu8RACnQIbINjFDiogF1UDTmOA1+EqM2f00Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ifhf5aZm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ifhf5aZm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735479593;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CLPzSOF171L8Iu/G0j9B+HGWnH9fS6NCxkJyAqZgWlA=;
	b=ifhf5aZm0jRKzRtPoTjDhLNsvo2oYEPj+9PFTvdT/iN1Y+H2tdTcxKTLGGMkmHCnhCTLMW
	ljHFdp/HuI+pNXHq5FggjktdkYuKdgPHs1JrWgfTQ+FBN0oOUJlrtRonbjiZqPlo+w4WAZ
	0zcWRpxTPQFyL3ShoiavTlAe0NXO30M=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-cLkAsdb7OT6X-9zdatwkvQ-1; Sun, 29 Dec 2024 08:39:52 -0500
X-MC-Unique: cLkAsdb7OT6X-9zdatwkvQ-1
X-Mimecast-MFC-AGG-ID: cLkAsdb7OT6X-9zdatwkvQ
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-aaf5cb29e46so12505866b.0
        for <linux-xfs@vger.kernel.org>; Sun, 29 Dec 2024 05:39:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735479590; x=1736084390;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CLPzSOF171L8Iu/G0j9B+HGWnH9fS6NCxkJyAqZgWlA=;
        b=dMhanHgwrXMfJtxXHmCdfN69LYLLp8ap+U5iIaMSWk09mnXn05xJWb5uZ5Fj+Bu5jV
         culE8tTBsvlmU9LD7CrYx7BKCQbWi1pQtkbGQz5HlK/1pbfhOamVXKqLF2B8pffkaeGn
         vlGwMyS0EinKVXlxtmampa5vlAqSGOxafRYohLfT107hwKGeQ+auY6lEooMpU9otHiKu
         RCfMKCIogFJVAHCYftoSUL5FILnjpYA6aG/1SKeghD2hfYVKUvVrsKoxTsOouf/45ujO
         1yjecGTZv/d+/9gNiHroi/PWOyJGd8iV7ub9m+Tu0ygp4mnRWctKpsrjrDh1MqA4BpqI
         +F4Q==
X-Gm-Message-State: AOJu0YzmfIPLS0wLHCR2VJQaen0a3Ix0XGzsz6ZIz0fJg1miBpu3Ybxv
	k3bGLYg/2ZpDhfE0Q4e2fAmopmr5MsciA23Jz5RYFZ5A4J22jZlmcRGb+/KJpLvssPlbAcZzpn5
	1J1tUGif5dhfWAMkmQv2x+Gl0N04bxCJOKhYf9sfNr9UzfuqVBS+ybo3Z2tAtscHg4n2EBT5nQE
	mQgvFDz1WhY2AdY6bstV3vZrcj+pjAztJhIrzSNi5s
X-Gm-Gg: ASbGncvbz/GQN/a9tvJD9K8ZHJcMDW8MIGFSOMeHw4puvKJNSGZXAdBBhrem5SOJQw9
	WgqFflmpNAbiWQ8jCwYW980wAWbPfTbEKUAcm+v1LOe3DIRRoen4/zLmm2/tsY1OY4mI8AaV9El
	+JDc8ppxWH92qutulamrwsZ36alOCO2F8B8THuDqfsPa8S+ptmgwvLIhFVwyKJHTEDEZ3SU33QF
	zh2epBJG8IZpj6AUv2q//WDDeJ4NibgGC1NesMhWN+bqlz+IWehOMc16MwU9idAkXBNrztGKoJV
	qFFwFZw1vz3LsF8=
X-Received: by 2002:a17:907:d1c:b0:aa6:aa8a:9088 with SMTP id a640c23a62f3a-aac3444a76emr2228122866b.41.1735479590063;
        Sun, 29 Dec 2024 05:39:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEzY+7C/XPhmsKHPWy/qsSLuAQm5PP5QPsjKDP5vlNKue3XkJEI6ixgNc7tD0rkZsGSODcgmw==
X-Received: by 2002:a17:907:d1c:b0:aa6:aa8a:9088 with SMTP id a640c23a62f3a-aac3444a76emr2228120266b.41.1735479589536;
        Sun, 29 Dec 2024 05:39:49 -0800 (PST)
Received: from thinky.redhat.com (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0f070a7bsm1355017766b.201.2024.12.29.05.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2024 05:39:49 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	david@fromorbit.com,
	hch@lst.de,
	Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH 01/24] fs: add FS_XFLAG_VERITY for verity files
Date: Sun, 29 Dec 2024 14:39:04 +0100
Message-ID: <20241229133927.1194609-2-aalbersh@kernel.org>
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

Add extended attribute FS_XFLAG_VERITY for inodes with fs-verity
enabled.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
[djwong: fix broken verity flag checks]
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 Documentation/filesystems/fsverity.rst |  8 ++++++++
 fs/ioctl.c                             | 11 +++++++++++
 include/uapi/linux/fs.h                |  1 +
 3 files changed, 20 insertions(+)

diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
index 76e538217868..ea4ab52b6598 100644
--- a/Documentation/filesystems/fsverity.rst
+++ b/Documentation/filesystems/fsverity.rst
@@ -336,6 +336,14 @@ the file has fs-verity enabled.  This can perform better than
 FS_IOC_GETFLAGS and FS_IOC_MEASURE_VERITY because it doesn't require
 opening the file, and opening verity files can be expensive.
 
+FS_IOC_FSGETXATTR
+-----------------
+
+Since Linux v6.9, the FS_IOC_FSGETXATTR ioctl sets FS_XFLAG_VERITY (0x00020000)
+in the returned flags when the file has verity enabled. Note that this attribute
+cannot be set with FS_IOC_FSSETXATTR as enabling verity requires input
+parameters. See FS_IOC_ENABLE_VERITY.
+
 .. _accessing_verity_files:
 
 Accessing verity files
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 638a36be31c1..3484941ec30d 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -480,6 +480,8 @@ void fileattr_fill_xflags(struct fileattr *fa, u32 xflags)
 		fa->flags |= FS_DAX_FL;
 	if (fa->fsx_xflags & FS_XFLAG_PROJINHERIT)
 		fa->flags |= FS_PROJINHERIT_FL;
+	if (fa->fsx_xflags & FS_XFLAG_VERITY)
+		fa->flags |= FS_VERITY_FL;
 }
 EXPORT_SYMBOL(fileattr_fill_xflags);
 
@@ -510,6 +512,8 @@ void fileattr_fill_flags(struct fileattr *fa, u32 flags)
 		fa->fsx_xflags |= FS_XFLAG_DAX;
 	if (fa->flags & FS_PROJINHERIT_FL)
 		fa->fsx_xflags |= FS_XFLAG_PROJINHERIT;
+	if (fa->flags & FS_VERITY_FL)
+		fa->fsx_xflags |= FS_XFLAG_VERITY;
 }
 EXPORT_SYMBOL(fileattr_fill_flags);
 
@@ -640,6 +644,13 @@ static int fileattr_set_prepare(struct inode *inode,
 	    !(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
 		return -EINVAL;
 
+	/*
+	 * Verity cannot be changed through FS_IOC_FSSETXATTR/FS_IOC_SETFLAGS.
+	 * See FS_IOC_ENABLE_VERITY.
+	 */
+	if ((fa->fsx_xflags ^ old_ma->fsx_xflags) & FS_XFLAG_VERITY)
+		return -EINVAL;
+
 	/* Extent size hints of zero turn off the flags. */
 	if (fa->fsx_extsize == 0)
 		fa->fsx_xflags &= ~(FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT);
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 753971770733..803f1c47f187 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -158,6 +158,7 @@ struct fsxattr {
 #define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
 #define FS_XFLAG_DAX		0x00008000	/* use DAX for IO */
 #define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
+#define FS_XFLAG_VERITY		0x00020000	/* fs-verity enabled */
 #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
 
 /* the read-only stuff doesn't really belong here, but any other place is
-- 
2.47.0

