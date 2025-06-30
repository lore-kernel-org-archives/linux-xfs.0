Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1589F2949F6
	for <linux-xfs@vger.kernel.org>; Mon, 30 Jun 2025 16:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751300444; cv=none; b=jEF0x8I2XXQfWxsDAgqhkHxp56oJbp1Vu0XXipNBMXveUGSSAJjdzlUCOKZFIuNDJBNIh6hbzTL+Txllfg8R2VKP1eKVvMuiu7GHzlgby20spVHzjKBQOH/qIdhxAOj8j45FS9WmfHWBr64CPAB4yE8JaOrHOyz+17LcYRinx6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751300444; c=relaxed/simple;
	bh=foooJvFPpaD5U1NIc0z1whyvvGUcJuzLkZ/bh7+WhsI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=a72T5NEKow5AjJ6VcCvuKDEN9tZrmm1gFqzbAsg2pis6VEly02ujwobNJ9M0FN6GAnQXi5sBttYI3p7h5IzA0ZlcFmRMrKrg7Qh08TpdahCo4PRS/2OMjS/icIzsDE+n6wvgtDq85Ka7TAn7XUmHCX8uF9C8uxNl9y9cbVbB1s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xwrm/hLm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xwrm/hLm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751300441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DdCDc+5wwhrTWZmiggiHt07OVS9wseyBUBrB0c0lZSY=;
	b=Xwrm/hLm6PpxeiT8B6R8pVhO/31EFO7DGj8Q00OkXTrxHstcbffR/mxBh53tEqnopkQXYR
	YF8f4OGR/pJeR/PKIdG7IuiG5mLrvaR5RogdQb7LnZmTxiAcII6SoNr8Ob8qCt3nl8dwm4
	DJ0Qd7E70lHEQfGW//QcDy+soc1TCuY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-Fb2ImdgJPQa3oDfbpFh4dg-1; Mon, 30 Jun 2025 12:20:37 -0400
X-MC-Unique: Fb2ImdgJPQa3oDfbpFh4dg-1
X-Mimecast-MFC-AGG-ID: Fb2ImdgJPQa3oDfbpFh4dg_1751300437
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-450eaae2934so16813555e9.2
        for <linux-xfs@vger.kernel.org>; Mon, 30 Jun 2025 09:20:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751300436; x=1751905236;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DdCDc+5wwhrTWZmiggiHt07OVS9wseyBUBrB0c0lZSY=;
        b=Foq3u2sr0O20Ktt5Lny8cj+/o6dS6tWh3aFJf38T6Lw8BJKji7x7ukZa33N+R0cYhU
         rkVPF4xvGtkbO/FsicvYlS5exzoKvSgIpZoukheEXj1vY5HgHM8l1iJfQmidKwZqrgbh
         MPGLxBHzVpelrbGl2IBDyOF9f93OCyjZ123Kf9SO9BZFpKDPwFiXG+t3pT0Y5M9nVJ2R
         qvz8kgRJUsJxyexyzQnBVPLyWqjUQ6d+xGr94aywO4cgH5KL8JAEYJ/XwrTUbF+gAvB7
         vE23+jq/hniREbbYg2bKKFSTEcSw5PBaSmg0KTmAPW56c1/lWTqtBTy0zoU3QWa4LkbC
         1D0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWYfnXVWJpG4TOYbYN6i0ZBqA7EIMQtXEaPw2PQnsTjJuaykJ8/jZ+LnHswFdt3tce9PkwcKFvTa0k=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkgvO2n6jkTgJ3Yd55bY8Am/LO2a4KNB1sJir/gSjRSOQ71SpM
	jfFWnw10Zk3uAtzrPYgWDqYTvqOLYr8fnPjwsUScIsaal/8PnKXWNCOcpVJMhT4BiIEPdgWYN3f
	YdDdsC5XzMAZw3AKxerhRsO9tCEGg62FwSq82ZlCWye/boJtIJ0zZhb4njB4e
X-Gm-Gg: ASbGncvHOZ4yHoCPHWtnRu1uBeIGEuP4pl3/4+lXvYmlVziezwNjmSwSQyjcLu9pbzY
	HQBIw73eXpUE+Uc5UbNYzogiWDqhaiXmVgSJKZq6HN2M9T5+dWbZeYHxKU9FAfuQ0/piMPEw/bA
	j+iUXpx5rQLQ/p5A+nLFAk9TJ/wS/8EUz5IUZpYm/JGDdIWJH24rirzxuUBN8VeJg01KAU3Rgwz
	mGHs6fjIaqa8AXnckjBFZZTLNkedAgfspqhGEvTaktT/UYL+dGHnrn5d6iw/4tpNU3gBIsN73GJ
	t28aCl38eWK9tPHUCiV4gRUoL0bY
X-Received: by 2002:a05:600c:83c6:b0:453:aca:4d05 with SMTP id 5b1f17b1804b1-453a7264638mr5226375e9.31.1751300436478;
        Mon, 30 Jun 2025 09:20:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFBcIwNOVZbbeCVmBSm0GSwp6bviZIHyE1JnfXVzq6+huhRLCuA9yHQd2Lb4OcWzcyg0+4Wrw==
X-Received: by 2002:a05:600c:83c6:b0:453:aca:4d05 with SMTP id 5b1f17b1804b1-453a7264638mr5226125e9.31.1751300436014;
        Mon, 30 Jun 2025 09:20:36 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4538233c1easm168769245e9.3.2025.06.30.09.20.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 09:20:34 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Mon, 30 Jun 2025 18:20:15 +0200
Subject: [PATCH v6 5/6] fs: prepare for extending file_get/setattr()
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250630-xattrat-syscall-v6-5-c4e3bc35227b@kernel.org>
References: <20250630-xattrat-syscall-v6-0-c4e3bc35227b@kernel.org>
In-Reply-To: <20250630-xattrat-syscall-v6-0-c4e3bc35227b@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
 Casey Schaufler <casey@schaufler-ca.com>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
 Paul Moore <paul@paul-moore.com>
Cc: linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, 
 selinux@vger.kernel.org, Andrey Albershteyn <aalbersh@redhat.com>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3056; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=IIV2cRquSoQDpyjj3fxxhkDYmgsYRlcj84QBPmOyXno=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMpJ2epvKL1KqqgkNvm3IsfeBdK/GQ7Vj5kGz+g/JP
 HzuvPaEY2JHKQuDGBeDrJgiyzppralJRVL5Rwxq5GHmsDKBDGHg4hSAiTw8zvCHM/bZTbHepcd0
 TPsaqyd8c9JX2aGyiV17oUCzhl/651W7GRlu3/i+kvuc0IKOb351FTMWH2dpPJxivOQ0xzIFl6o
 LPLncAL7sRno=
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

From: Amir Goldstein <amir73il@gmail.com>

We intend to add support for more xflags to selective filesystems and
We cannot rely on copy_struct_from_user() to detect this extension.

In preparation of extending the API, do not allow setting xflags unknown
by this kernel version.

Also do not pass the read-only flags and read-only field fsx_nextents to
filesystem.

These changes should not affect existing chattr programs that use the
ioctl to get fsxattr before setting the new values.

Link: https://lore.kernel.org/linux-fsdevel/20250216164029.20673-4-pali@kernel.org/
Cc: Pali Rohár <pali@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/file_attr.c           |  8 +++++++-
 include/linux/fileattr.h | 20 ++++++++++++++++++++
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/fs/file_attr.c b/fs/file_attr.c
index 4e85fa00c092..62f08872d4ad 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -99,9 +99,10 @@ EXPORT_SYMBOL(vfs_fileattr_get);
 int copy_fsxattr_to_user(const struct fileattr *fa, struct fsxattr __user *ufa)
 {
 	struct fsxattr xfa;
+	__u32 mask = FS_XFLAGS_MASK;
 
 	memset(&xfa, 0, sizeof(xfa));
-	xfa.fsx_xflags = fa->fsx_xflags;
+	xfa.fsx_xflags = fa->fsx_xflags & mask;
 	xfa.fsx_extsize = fa->fsx_extsize;
 	xfa.fsx_nextents = fa->fsx_nextents;
 	xfa.fsx_projid = fa->fsx_projid;
@@ -118,11 +119,16 @@ static int copy_fsxattr_from_user(struct fileattr *fa,
 				  struct fsxattr __user *ufa)
 {
 	struct fsxattr xfa;
+	__u32 mask = FS_XFLAGS_MASK;
 
 	if (copy_from_user(&xfa, ufa, sizeof(xfa)))
 		return -EFAULT;
 
+	if (xfa.fsx_xflags & ~mask)
+		return -EINVAL;
+
 	fileattr_fill_xflags(fa, xfa.fsx_xflags);
+	fa->fsx_xflags &= ~FS_XFLAG_RDONLY_MASK;
 	fa->fsx_extsize = xfa.fsx_extsize;
 	fa->fsx_nextents = xfa.fsx_nextents;
 	fa->fsx_projid = xfa.fsx_projid;
diff --git a/include/linux/fileattr.h b/include/linux/fileattr.h
index 6030d0bf7ad3..e2a2f4ae242d 100644
--- a/include/linux/fileattr.h
+++ b/include/linux/fileattr.h
@@ -14,6 +14,26 @@
 	 FS_XFLAG_NODUMP | FS_XFLAG_NOATIME | FS_XFLAG_DAX | \
 	 FS_XFLAG_PROJINHERIT)
 
+/* Read-only inode flags */
+#define FS_XFLAG_RDONLY_MASK \
+	(FS_XFLAG_PREALLOC | FS_XFLAG_HASATTR)
+
+/* Flags to indicate valid value of fsx_ fields */
+#define FS_XFLAG_VALUES_MASK \
+	(FS_XFLAG_EXTSIZE | FS_XFLAG_COWEXTSIZE)
+
+/* Flags for directories */
+#define FS_XFLAG_DIRONLY_MASK \
+	(FS_XFLAG_RTINHERIT | FS_XFLAG_NOSYMLINKS | FS_XFLAG_EXTSZINHERIT)
+
+/* Misc settable flags */
+#define FS_XFLAG_MISC_MASK \
+	(FS_XFLAG_REALTIME | FS_XFLAG_NODEFRAG | FS_XFLAG_FILESTREAM)
+
+#define FS_XFLAGS_MASK \
+	(FS_XFLAG_COMMON | FS_XFLAG_RDONLY_MASK | FS_XFLAG_VALUES_MASK | \
+	 FS_XFLAG_DIRONLY_MASK | FS_XFLAG_MISC_MASK)
+
 /*
  * Merged interface for miscellaneous file attributes.  'flags' originates from
  * ext* and 'fsx_flags' from xfs.  There's some overlap between the two, which

-- 
2.47.2

