Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D9F2798F8
	for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 20:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753734691; cv=none; b=lMCGAYn1bdiejVqbvtqgWPMWLV2bjlNYBl4RoEFZ6QvKPVaBVZ1Q3Lsvqb/q5TMIZs03aJEAJEO/4qpfC5VEzVWkIcj5XGKfnbdU39I3DKgzT1gvColDEqvT0APruLq6JevY4g6VRwXjKZtElmcMeTPrsXWfJZlW6ICN1Ep0kqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753734691; c=relaxed/simple;
	bh=+pGveg9Pmu4dBeryZ8MiYHvi2cSBv7Y8gXPCSBYMPfU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kVE9p2h8jDF5wlKJ5sS3D+/DAhavbmyZ8mflt4gSGr0sCSOBizkrhTNSVZdjMHxeWB1Eal1QiZImqVB8WpAibDD+mTjDsXguVdwcNxs0kuhSW8ahlUlxQXmwOc7qzuxd6cCJsdQOM0X6OEMdZapWZXwSJzQx6VGD0SSNUhX1j+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AjlmtB9v; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AjlmtB9v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753734688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RDMqTI/Zvt9HERx3g97oQ03NOzI7QbUfzHalgzx5/KM=;
	b=AjlmtB9vTHMyv+BWjk7JaFHEFIGbB4ID5OXtUwfYvlEWKtkCFG9C94UlluYdHO8+dyOyY/
	qELubE7fWeT/Py0yKxSb8QubIfXQmyN1d9FVZAWOFzZ5sC3RvovPb8k54KiWPdzqb0mw9Z
	gukHPEGs5HXwGjHbvQ7YowOETsw//RA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-36-y4CDzOKFNByUlJQgC_2Ktw-1; Mon, 28 Jul 2025 16:31:26 -0400
X-MC-Unique: y4CDzOKFNByUlJQgC_2Ktw-1
X-Mimecast-MFC-AGG-ID: y4CDzOKFNByUlJQgC_2Ktw_1753734685
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-615427e06e7so1372350a12.2
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jul 2025 13:31:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753734685; x=1754339485;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RDMqTI/Zvt9HERx3g97oQ03NOzI7QbUfzHalgzx5/KM=;
        b=Gbg5GKfQ0aKmg8olVqoK8XGMribwpECIGRUfwoP2sWj0JkMinC9ixtftwMwU74IMwQ
         lAHxPHWz7rvOo/R80hTUthvIj7e9Yu/a4ZWikEZGzxgoDP4gd5oHSlP0avU1Lfl+oJLW
         PBf3Ss3HQnhqAz5U/vwJgzLULtQWfopticvtYGMw8E9AWNj6mN1O+Jzip9xLhzFVMeNm
         1nrIBiwPbsGZgcBTbh93q+IxZZyAl78FyKJOReakTKd6bjul/i+HRgx6AUe3rX4tlNXo
         xLQWxP2xn/E90H6L9aYlZAkHVJqTC7wtlzeOMnrNUqescK4AtTQtIJrIsLK87//1CPs+
         2RQA==
X-Forwarded-Encrypted: i=1; AJvYcCXsJNe6E8rIqACPmumh4fAGjkj4crtrNKfI3HGuDoS/P625HmcxIvTepdStTC9bRyL4zpLoAvWSWDs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw06YMRsnp/bSVlzxXQWupA+7evF6dAbSGmU+jjmkfGHJRkLeJg
	AqHakdrOUkk5TYyWci887jWKFinp8pzRobA1ulW+xWFMLwxotQWBpCF6c36lrqCEr5HgRbuZ6ak
	4M/rgMj47DB2OV4AHpUCMThR7v/+fcJNwV2t7v2amlhP9hQ9i0nU5sc+6kAbakqqqj/zr
X-Gm-Gg: ASbGncvr3HU99ugqn5zwDXSvSE/Vun9zOVPprZiDnNamzGEJTRkusPYJEofC94tTm5w
	loMCqs/uvyok6w/HiEnzVSnu3GnaBDN1hf6CAguVxWF2fLSJEnwF4aC3UtM9N/R1ihaau3R8eIP
	3iRNSt5ttdCGZ+3gMcRwF6NLHXRq0mWmSlBMaWkKbYn7CW7NV7459cwFXcXvWrl/nAj1/8Gx189
	3mMPjtsM6V2DB9OSV7SkbEBAItATp5mpEK/gauxCX385D5skx9llnK8TXIpig1YLlkzhw+cZiOB
	vugfsoDzOjbQ4E7Ur163TSY6PCX9B8LIsrFSDODJcUeCmA==
X-Received: by 2002:aa7:c70a:0:b0:615:4561:d0e5 with SMTP id 4fb4d7f45d1cf-6154561d6afmr3190516a12.5.1753734685047;
        Mon, 28 Jul 2025 13:31:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF1fyJkbKuAT2ah8QgVJbapLevOG3cAlkIl1omiQUSN5tmYBbdQNXq0Zz6XUfvL1Dj5muKpTg==
X-Received: by 2002:aa7:c70a:0:b0:615:4561:d0e5 with SMTP id 4fb4d7f45d1cf-6154561d6afmr3190495a12.5.1753734684598;
        Mon, 28 Jul 2025 13:31:24 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615226558d3sm2730656a12.45.2025.07.28.13.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 13:31:24 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 28 Jul 2025 22:30:07 +0200
Subject: [PATCH RFC 03/29] fs: add FS_XFLAG_VERITY for verity files
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250728-fsverity-v1-3-9e5443af0e34@kernel.org>
References: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
In-Reply-To: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
To: fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org, david@fromorbit.com, djwong@kernel.org, 
 ebiggers@kernel.org, hch@lst.de
Cc: Andrey Albershteyn <aalbersh@redhat.com>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3251; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=S13Ndh+iSo1VZJOCCnDmQa/t5QBLgmB2TOrR92CS+q4=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMtrviUdbre+KvXDk4Lp/zta/5WZMSkt4vTKhlivjY
 I3wpNxu/9kdpSwMYlwMsmKKLOuktaYmFUnlHzGokYeZw8oEMoSBi1MAJrK6j+EPzx+/a/0r/ja5
 SgVuXbCtgkXh5pcbkb6b11hzb7V7fWV2LMP/yD1C206fPak3a/r2mXUNCqe2H9n3pfeuQtut+0k
 1KnmuLABbA0z+
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

From: Andrey Albershteyn <aalbersh@redhat.com>

Add extended attribute FS_XFLAG_VERITY for inodes with fs-verity
enabled.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
[djwong: fix broken verity flag checks]
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 Documentation/filesystems/fsverity.rst |  8 ++++++++
 fs/ioctl.c                             | 11 +++++++++++
 include/uapi/linux/fs.h                |  1 +
 3 files changed, 20 insertions(+)

diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
index dacdbc1149e6..33b588c32ed1 100644
--- a/Documentation/filesystems/fsverity.rst
+++ b/Documentation/filesystems/fsverity.rst
@@ -342,6 +342,14 @@ the file has fs-verity enabled.  This can perform better than
 FS_IOC_GETFLAGS and FS_IOC_MEASURE_VERITY because it doesn't require
 opening the file, and opening verity files can be expensive.
 
+FS_IOC_FSGETXATTR
+-----------------
+
+Since Linux v6.17, the FS_IOC_FSGETXATTR ioctl sets FS_XFLAG_VERITY (0x00020000)
+in the returned flags when the file has verity enabled. Note that this attribute
+cannot be set with FS_IOC_FSSETXATTR as enabling verity requires input
+parameters. See FS_IOC_ENABLE_VERITY.
+
 .. _accessing_verity_files:
 
 Accessing verity files
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 69107a245b4c..6b94da2b93f5 100644
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
index 0098b0ce8ccb..20777ec55f7b 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -167,6 +167,7 @@ struct fsxattr {
 #define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
 #define FS_XFLAG_DAX		0x00008000	/* use DAX for IO */
 #define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
+#define FS_XFLAG_VERITY		0x00020000	/* fs-verity enabled */
 #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
 
 /* the read-only stuff doesn't really belong here, but any other place is

-- 
2.50.0

