Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4E57E10F
	for <linux-xfs@vger.kernel.org>; Mon,  4 Mar 2024 19:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709579560; cv=none; b=DEJGrbEdK4bQTDc7XEYcTU8KSRpit36c1u3yZWIg8gyyzLFRRXhbfrb/TA1A2Ei35mD6dBqw9MHgCMj/zjDRUD9iP9hBPjhGpRNjrqtKlZXGmfUYhI2vOaLbSwGaZhnAATwRIRkgaYFo4Eqak7tV22DnBR/vzUlXcE+QXzoA9z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709579560; c=relaxed/simple;
	bh=RsSA5HXP4XdTMyeDSklbX2t9chAOtXyvct70Wpdi/s8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKeF4nt2lJtBE1JEKW+5r8hFUvAunJhXu8tiT6OQvqhLz3qNKo2/8SVoSlYNxMs/1wR7PPFvdvc5ryzeaymwtVrJ+4U3T7rnQJZN1+4eWc8H1hDpOvEukV3qtfTzffxe6KL8QJsIHcG85qVpPcOLNvyad7sAhiQLHfyhHAJGKp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V/2iwAnS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V/2iwAnS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709579557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GLiAPlULZquK5Brfr95QLdeh/hZ5v9ntg4e4aq6YwHM=;
	b=V/2iwAnSz7Pf79a1Uc21I6mBG+C5C5ZHYU8wBWSqzTCsmqpGd0wayBZD05+AMCNVRQxONx
	NFX/6rbI25tlDLeuo1X0aLqIHDlN43eTCVZrooR2i+DHC0idFUokiZ6x5z3wsxcwV5uX/9
	iib983KMqGaiL3UMJvLFANhbOY5MH/M=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-412--NiqwBDBPayUPZMQjUDm3Q-1; Mon, 04 Mar 2024 14:12:36 -0500
X-MC-Unique: -NiqwBDBPayUPZMQjUDm3Q-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a357c92f241so345822266b.0
        for <linux-xfs@vger.kernel.org>; Mon, 04 Mar 2024 11:12:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709579535; x=1710184335;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GLiAPlULZquK5Brfr95QLdeh/hZ5v9ntg4e4aq6YwHM=;
        b=d5EElKJBLZJ1Ug2rGm5dkE7582MGCJaKpnTm/HnGCmwyK2f26nkWg3Pz0Az52nkotG
         gWL7xRO28lHqOgbDPgD5C4o8sj29j6tAd8SsMXM/3qgtZq38D9lJExNTyPOaselJDr4i
         ozQCcexTJk0j0G/YLbwrzCCAnyNzPUlWV4xp7vExDdixuGLdSf4FWPoQpJXXEmTacj5W
         +5sss/CBzfXKXPpRUPTG4FMkqVjvKZYZ4xFX7/N8MHoOBuzjb3D+yH5BbuStsR09HcQN
         uEzup7C1rMwhHJ/JwXP/k/PqdE4lrDlpZJuInuW5wZTo61NuNLjj3fTSC+PF5pO/TQ/T
         +g5A==
X-Forwarded-Encrypted: i=1; AJvYcCV4AP3XW7jyuJnRfaba4CLJUYl6ev2bk+iVfvgKl/24r9RP59iCk8LE1+5bb1fNicqQDId8KqzrHCqZMOGueX7MxJctLIdoqhY2
X-Gm-Message-State: AOJu0YxjbN+t9QTYoa9adIKvTeX2FONwQJySISRr/E51DCxpVyhqkaY8
	zei7EycQszb8yknqApz6RT+1GgxlsvtqgCQAgpCY22FBijqXXmz4uk67ZUfDGiAbzRsEMy5Qznm
	++/Lt9x3+3LxbIr7i0eAwh/zqRjNRTdQb7GA2RBoNPlJagcrpMMkZiwdv
X-Received: by 2002:a17:906:13d5:b0:a45:95f5:f314 with SMTP id g21-20020a17090613d500b00a4595f5f314mr344241ejc.42.1709579535550;
        Mon, 04 Mar 2024 11:12:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFx8vfrZMAjuMwszwGXOM9gKTiOkhdQUg8Hw3nl4YJ4PBoUGUn4W527I5Al2Nj2TIVW4ljXsA==
X-Received: by 2002:a17:906:13d5:b0:a45:95f5:f314 with SMTP id g21-20020a17090613d500b00a4595f5f314mr344237ejc.42.1709579535279;
        Mon, 04 Mar 2024 11:12:15 -0800 (PST)
Received: from thinky.redhat.com ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id a11-20020a1709064a4b00b00a44a04aa3cfsm3783319ejv.225.2024.03.04.11.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Mar 2024 11:12:14 -0800 (PST)
From: Andrey Albershteyn <aalbersh@redhat.com>
To: fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com,
	djwong@kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Subject: [PATCH v5 05/24] fs: add FS_XFLAG_VERITY for verity files
Date: Mon,  4 Mar 2024 20:10:28 +0100
Message-ID: <20240304191046.157464-7-aalbersh@redhat.com>
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

Add extended attribute FS_XFLAG_VERITY for inodes with fs-verity
enabled.

Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
---
 Documentation/filesystems/fsverity.rst |  8 ++++++++
 fs/ioctl.c                             | 11 +++++++++++
 include/uapi/linux/fs.h                |  1 +
 3 files changed, 20 insertions(+)

diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
index 13e4b18e5dbb..887cdaf162a9 100644
--- a/Documentation/filesystems/fsverity.rst
+++ b/Documentation/filesystems/fsverity.rst
@@ -326,6 +326,14 @@ the file has fs-verity enabled.  This can perform better than
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
index 48ad69f7722e..b1d0e1169bc3 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -140,6 +140,7 @@ struct fsxattr {
 #define FS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
 #define FS_XFLAG_DAX		0x00008000	/* use DAX for IO */
 #define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
+#define FS_XFLAG_VERITY		0x00020000	/* fs-verity enabled */
 #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
 
 /* the read-only stuff doesn't really belong here, but any other place is
-- 
2.42.0

