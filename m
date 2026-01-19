Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603C031AAB8
	for <linux-xfs@vger.kernel.org>; Mon, 19 Jan 2026 16:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768840396; cv=none; b=nBevfi1WQPr0jesS4cIhwx4vjCy3ls7HbR8RBhlZHDuvEMXhWDdvOwBBPzQod/c47icIa7AJMSjJCGl+EXMB1MOIjjp9mv7yTxsunlJnZjw1pxBO9jzby74EWtG4b1lHxniirA+4WI1Z4e/XeYI5kJLFz6xmgnr+C/OJFFSMHyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768840396; c=relaxed/simple;
	bh=a8G59Npae+OCsscRUQyCG3vvV96FNv1OHN8iFXpDfbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c/2TsGEp1qMu/+Q5tjb5UAdemijpTfPg3z6Ll3wa9p8NuD3s9tOwVJ/IC3u7hQAs+5WChger+FVG6VQS8B6gpjEDQHiojs9XqpN2kIcF22HdysSBELqPLRlZ62zr528s9H/9WqmsD3KkMUuvJ6PZhIDh9p3VWg0iachN1qtcVq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Idz5xB2N; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=RyRv2l3C; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Idz5xB2N";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="RyRv2l3C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768840394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4AXhAM5Z9UnSo50aKFP96wUOeb6l6lxxAG1KAJAvejs=;
	b=Idz5xB2NTytmSfthAftul7r/VJRsrJgcJuU6NaDdc/SrQoDmmzmXjAy+r7ISp4Xt5kQJ+c
	NmoveZmoJyUar/mYEL7sBF2av+IMrdtKvP7qtB8nE1KTuJUoTp5ErQoKxFCAlPw3Gm/IpG
	KxHU7BuEASwsTCS4y2RlSMAL7hq+4kA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-281-BNrlqfK1ORiWZJ3sPxrvgw-1; Mon, 19 Jan 2026 11:33:13 -0500
X-MC-Unique: BNrlqfK1ORiWZJ3sPxrvgw-1
X-Mimecast-MFC-AGG-ID: BNrlqfK1ORiWZJ3sPxrvgw_1768840392
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-431054c09e3so4185393f8f.0
        for <linux-xfs@vger.kernel.org>; Mon, 19 Jan 2026 08:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768840392; x=1769445192; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4AXhAM5Z9UnSo50aKFP96wUOeb6l6lxxAG1KAJAvejs=;
        b=RyRv2l3CwDdL0V4/TSj1Bj269W3aLwt2L/E+bDyc078BnFEMB8z1ItxoOZmtix111M
         rlKAt1smTduc0hVxBdMlTOYMxVxfXMqRoapytKLFLQIY9Xvtjn7bqF2DTzFKEAZF25LL
         zlmlIxCyrMDFl/kWoo66l7+R4wiWXEsbpFFJHfDzrMEKT8OWUpUUNMDE2rwNmxOBkg7x
         pkHTgzM48fFGDPZ4s9GThThsPLRvcwMhPNx3S9mIeXgdo4oRPJPqQAojy5cME7g5NmBn
         O/HmMH53zgMvWsi1t2BrKxo/sXlks3o74esoIgviX+6AuVMyBAc6Q8bWj0OfydO2Vzkf
         t0Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768840392; x=1769445192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4AXhAM5Z9UnSo50aKFP96wUOeb6l6lxxAG1KAJAvejs=;
        b=H86wjuG28uly1sv46tXvszJnviIz8KoU6Ud7khW1S7f9uEBkz/SyaZMRPi3lstviL2
         b82h0oouDzZormkZEmjyy3u88p96dIlK6v8VWuhHCXdSuKam9XlDspjFNsBhMu+iIWIN
         Pwu7x5JO8yO1LrUeTx9pU/xx9S3FJLbH1BGhRQxcxq34EhMv3vxEUrqpTZnmJK4hV464
         XBNHnfcFGnbH3lHp1OCTjHCr4pregbdt5B89JlloodsOcpAyEcEkuf3rPSN9xg+P0VeJ
         apAfTj8cBg5xIygVqojzJgD1EBYCnxUAvXm+NLqp+OfQeSCH/6a8q1J2k9XVo1lcf8Bg
         PgEw==
X-Gm-Message-State: AOJu0YzOIRqIktWpoNFJpKrGm6m2IXvlhWNMNQlYE339oWMk7ImHAF8l
	ONciGy09IaZkIOEf5hmMaZRBFs5WxAlM7QXwgQA4NBRSJrdemQis7cMlIgAp3y3myJ7WZNuky1m
	4D2IFePJPGurw1Bt3tmYL6L+L1A9OljGF5NXnjgWTsq2Wvd3VRCg2gnPuKLiYLXhc/5nrEGluXZ
	baFfRvWFByzR504OLQIo7pbJubSBdnHmxh4y08pv7Mb4ZD
X-Gm-Gg: AZuq6aIdw0sDdkr/SFKnydN4DbWn8qpz2tvCDSbTcz/Llss44V5DXaSIXymTs8phWtV
	KwImoyMq6ctg8qeHQ/lvT3s/WYbK5n64J/2rxsB5C954DxH4PPsT4nOAUfgNnGifcuFGi62TOUA
	ski8zbQrH6rhYQiUTa8HRvgs8fe4uJjyVsP2qQ1oJr97lUaTDPv+SmswMlHrhZ0aVjBiAUZgNfK
	V6kbXOeb/zKj9C/xnQ4uhth/+4uCHthZteBsBgw2VNz8XoO9QoUrSHeqs2x50OCdoVmgAgotGJp
	vJHM19c6UcYkCaCUMHz5rC5BFi6AY9H5rY0UX+fxUpU7tAEDyofxu7SnoK5UWTnbxtJ5fo1+nSz
	Ky+EzAWHXMlhhfw==
X-Received: by 2002:a05:6000:1845:b0:431:266:d138 with SMTP id ffacd0b85a97d-4356998b5ffmr16743542f8f.25.1768840391595;
        Mon, 19 Jan 2026 08:33:11 -0800 (PST)
X-Received: by 2002:a05:6000:1845:b0:431:266:d138 with SMTP id ffacd0b85a97d-4356998b5ffmr16743475f8f.25.1768840390980;
        Mon, 19 Jan 2026 08:33:10 -0800 (PST)
Received: from thinky.redhat.com ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43569998240sm23524318f8f.43.2026.01.19.08.33.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 08:33:10 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	djwong@kernel.org
Subject: [PATCH v2 1/2] fs: add FS_XFLAG_VERITY for fs-verity files
Date: Mon, 19 Jan 2026 17:32:09 +0100
Message-ID: <20260119163222.2937003-3-aalbersh@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260119163222.2937003-2-aalbersh@kernel.org>
References: <20260119163222.2937003-2-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

fs-verity introduced inode flag for inodes with enabled fs-verity on
them. This patch adds FS_XFLAG_VERITY file attribute which can be
retrieved with FS_IOC_FSGETXATTR ioctl() and file_getattr() syscall.

This flag is read-only and can not be set with corresponding set ioctl()
and file_setattr(). The FS_IOC_SETFLAGS requires file to be opened for
writing which is not allowed for verity files. The FS_IOC_FSSETXATTR and
file_setattr() clears this flag from the user input.

As this is now common flag for both flag interfaces (flags/xflags) add
it to overlapping flags list to exclude it from overwrite.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 Documentation/filesystems/fsverity.rst | 16 ++++++++++++++++
 fs/file_attr.c                         |  4 ++++
 include/linux/fileattr.h               |  6 +++---
 include/uapi/linux/fs.h                |  1 +
 4 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
index 412cf11e3298..22b49b295d1f 100644
--- a/Documentation/filesystems/fsverity.rst
+++ b/Documentation/filesystems/fsverity.rst
@@ -341,6 +341,22 @@ the file has fs-verity enabled.  This can perform better than
 FS_IOC_GETFLAGS and FS_IOC_MEASURE_VERITY because it doesn't require
 opening the file, and opening verity files can be expensive.
 
+FS_IOC_FSGETXATTR
+-----------------
+
+Since Linux v7.0, the FS_IOC_FSGETXATTR ioctl sets FS_XFLAG_VERITY (0x00020000)
+in the returned flags when the file has verity enabled. Note that this attribute
+cannot be set with FS_IOC_FSSETXATTR as enabling verity requires input
+parameters. See FS_IOC_ENABLE_VERITY.
+
+file_getattr
+------------
+
+Since Linux v7.0, the file_getattr() syscall sets FS_XFLAG_VERITY (0x00020000)
+in the returned flags when the file has verity enabled. Note that this attribute
+cannot be set with file_setattr() as enabling verity requires input parameters.
+See FS_IOC_ENABLE_VERITY.
+
 .. _accessing_verity_files:
 
 Accessing verity files
diff --git a/fs/file_attr.c b/fs/file_attr.c
index 13cdb31a3e94..f44c873af92b 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -37,6 +37,8 @@ void fileattr_fill_xflags(struct file_kattr *fa, u32 xflags)
 		fa->flags |= FS_DAX_FL;
 	if (fa->fsx_xflags & FS_XFLAG_PROJINHERIT)
 		fa->flags |= FS_PROJINHERIT_FL;
+	if (fa->fsx_xflags & FS_XFLAG_VERITY)
+		fa->flags |= FS_VERITY_FL;
 }
 EXPORT_SYMBOL(fileattr_fill_xflags);
 
@@ -67,6 +69,8 @@ void fileattr_fill_flags(struct file_kattr *fa, u32 flags)
 		fa->fsx_xflags |= FS_XFLAG_DAX;
 	if (fa->flags & FS_PROJINHERIT_FL)
 		fa->fsx_xflags |= FS_XFLAG_PROJINHERIT;
+	if (fa->flags & FS_VERITY_FL)
+		fa->fsx_xflags |= FS_XFLAG_VERITY;
 }
 EXPORT_SYMBOL(fileattr_fill_flags);
 
diff --git a/include/linux/fileattr.h b/include/linux/fileattr.h
index f89dcfad3f8f..3780904a63a6 100644
--- a/include/linux/fileattr.h
+++ b/include/linux/fileattr.h
@@ -7,16 +7,16 @@
 #define FS_COMMON_FL \
 	(FS_SYNC_FL | FS_IMMUTABLE_FL | FS_APPEND_FL | \
 	 FS_NODUMP_FL |	FS_NOATIME_FL | FS_DAX_FL | \
-	 FS_PROJINHERIT_FL)
+	 FS_PROJINHERIT_FL | FS_VERITY_FL)
 
 #define FS_XFLAG_COMMON \
 	(FS_XFLAG_SYNC | FS_XFLAG_IMMUTABLE | FS_XFLAG_APPEND | \
 	 FS_XFLAG_NODUMP | FS_XFLAG_NOATIME | FS_XFLAG_DAX | \
-	 FS_XFLAG_PROJINHERIT)
+	 FS_XFLAG_PROJINHERIT | FS_XFLAG_VERITY)
 
 /* Read-only inode flags */
 #define FS_XFLAG_RDONLY_MASK \
-	(FS_XFLAG_PREALLOC | FS_XFLAG_HASATTR)
+	(FS_XFLAG_PREALLOC | FS_XFLAG_HASATTR | FS_XFLAG_VERITY)
 
 /* Flags to indicate valid value of fsx_ fields */
 #define FS_XFLAG_VALUES_MASK \
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 66ca526cf786..70b2b661f42c 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -253,6 +253,7 @@ struct file_attr {
 #define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
 #define FS_XFLAG_DAX		0x00008000	/* use DAX for IO */
 #define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
+#define FS_XFLAG_VERITY		0x00020000	/* fs-verity enabled */
 #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
 
 /* the read-only stuff doesn't really belong here, but any other place is
-- 
2.52.0

