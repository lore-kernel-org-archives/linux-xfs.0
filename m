Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71670250BEC
	for <linux-xfs@vger.kernel.org>; Wed,  8 Oct 2025 12:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759927469; cv=none; b=qvRVBAneymEUXPaylUaAsWeds5V/bgaG6Tl+C1pu4TuZMnRqO/bmdCBQ8IgshOL9tsq5LV6PjdXZ3x62PCadak7x8ys9hewmR6EggVgbDU21A7OWi+Ur7vP5KrDAdsHvNaE43ONJPwSH8cmdwT1DGz6gH3Z4Oge3AkNbn7i4Vns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759927469; c=relaxed/simple;
	bh=Rm08DYj+mslMBXfYK22sr3gFPY8mTjkKzp5uV40xej8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ldrzagkFNcSASIiCBqSXgdEwsrW7Oik7KE5PXKsFG9OArcBkJzjUIp18Uo/O9h2hMkgH9O28RAE0B6HKmwAXcHNWgpEsx5s6JlXVYjtPwxMusj1taA94UhdiqB2oS6p1GJuYJpYCHu7rDPoNaALsjbfi8UPayd2PwvIA9RFcDrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PdS8WVKN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PdS8WVKN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759927466;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KJHcjC4e0kTTUJxfi1ENkUBMalkao76BFoBvjc28PQw=;
	b=PdS8WVKNEbzecBxogj1o9TqDnuGSj/OQJhMq35ljLTXzgRe0wM5/WKIucnDfii7qN6azVQ
	8RkMIR0ED1S6OpTkl7tRBTRhqAI3lqyf59ffG6gsG3DTokyXmAzY8nEZWnkG7F4QCwHkjS
	rsmLJ2M7TGhjOILGK/9B64z5AK4aZ1Y=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-gefcHi1QPv2YPHj4LU0ocg-1; Wed, 08 Oct 2025 08:44:25 -0400
X-MC-Unique: gefcHi1QPv2YPHj4LU0ocg-1
X-Mimecast-MFC-AGG-ID: gefcHi1QPv2YPHj4LU0ocg_1759927464
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e32eb4798so41380515e9.2
        for <linux-xfs@vger.kernel.org>; Wed, 08 Oct 2025 05:44:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759927464; x=1760532264;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KJHcjC4e0kTTUJxfi1ENkUBMalkao76BFoBvjc28PQw=;
        b=JgHEw4sKp/h5QI36Du/J7FeJfLfdWGPz5KEmFqAKsfshgsvHKKI+WNEWiw4p7GNtOQ
         rJJ5BJAknoXuf6MmBlDwQG6ma46YD50n05fiVg4P+f2EHhE1TBCk9c3unsy8dHvMK20n
         kttRwIzRTV5hjvOf5a54Fa4yT/zf6mwG4gJ/TEqc1aR8og8S8/9FPRR8S4wiu9HiuCAR
         qIWDXPrKQO5fBsDff8VNjyoky1lL32Vg1prXXwwbbQZouT26gRtTRZmXKodxB7jXk+ra
         kbOkwl1Y71tOu9MPFMWuprV8LY67slfdBmCBCOfR/u+RLjZn7q2vs/lcDWs5R2d9bCDz
         YcpQ==
X-Forwarded-Encrypted: i=1; AJvYcCWnctJHk+ubEISeqlWdu/5Y8NqY3wPeY3rKeJYdMPM7Znp7ayW0NonDXCwu99Nx+5zMkt0/3hnockY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8+0te+9t6c4rTRX/eYQ+mSlu3Uqt2jHkyKYCYrkoMzAA2mhtC
	FICaOmwSbE9bPG4cFvQ724cBiYyZrqOWjl9S2kIC2VHnbC28h4KOk6v7oiGEYZ5lHajnGlFRRsN
	PW1ot7XDLLEtLRUvZ8jELWpx1lZ/nzijsSQrg1aEwyvi3yaUP7alZX/kz7O0h
X-Gm-Gg: ASbGncsLf6I59RTAK90wRkm/lHx3ipkubNx5H+iqnSICNN3iDcKiIxC2p2xdT0p7c4P
	R0StEt55pXX1GeHhPgvkG9AHfb6iRrxr7h4V9jzYgNQLnhhsJN5q7Z86CD2lwVtOlmHk0xUlE9P
	j6VNakqkIe3zctJx2C7EFlrskr+YIuDJRV+LyrlaM1+G4vVM/N1cRCXGK1dpQk2U51FFTa6m/Lm
	vUkEXjJF1dLrZ1fu17/XLhxhT49KSt1xcAepRzYq55La7YtA8t0Lw++mdssj4rYdkgPxdMOl6S7
	1Rwn2KUEvgQGeIEE0scatsacuc8JfMM2Vvc4GqeQNzH/A/L7ePm4a5qY4ZvuVO5dyHZA3ivc
X-Received: by 2002:a05:600c:c162:b0:46e:5a5b:db60 with SMTP id 5b1f17b1804b1-46fa9affbe0mr27133165e9.31.1759927463748;
        Wed, 08 Oct 2025 05:44:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEIehDZZgMkQNeYi+w3tuRSVQUqwra7bvm5DmMYJ0xx+K2Mzbu8NI1V3CwLhhi423n/xgnFLQ==
X-Received: by 2002:a05:600c:c162:b0:46e:5a5b:db60 with SMTP id 5b1f17b1804b1-46fa9affbe0mr27132925e9.31.1759927463345;
        Wed, 08 Oct 2025 05:44:23 -0700 (PDT)
Received: from [127.0.0.2] (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fab3d438fsm13918765e9.2.2025.10.08.05.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 05:44:22 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Wed, 08 Oct 2025 14:44:17 +0200
Subject: [PATCH 1/2] Revert "fs: make vfs_fileattr_[get|set] return
 -EOPNOTSUPP"
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251008-eopnosupp-fix-v1-1-5990de009c9f@kernel.org>
References: <20251008-eopnosupp-fix-v1-0-5990de009c9f@kernel.org>
In-Reply-To: <20251008-eopnosupp-fix-v1-0-5990de009c9f@kernel.org>
To: linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Jiri Slaby <jirislaby@kernel.org>, 
 Christian Brauner <brauner@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Andrey Albershteyn <aalbersh@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4039; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=Rm08DYj+mslMBXfYK22sr3gFPY8mTjkKzp5uV40xej8=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMp7FLJXoUW//v2RJxbqtIkttvx86eT2kqCbxbsts1
 eS7B36nN57oKGVhEONikBVTZFknrTU1qUgq/4hBjTzMHFYmkCEMXJwCMJEeM4b/CZav9j8/+Nyw
 Zt4FL8PI6T9dvf+o7j8uYxEattZIyXmbJcMvplKDfcHbUj3839zbJp/l4hL6qP+CiMYZ9prJj+5
 oBbZwAAAe2UsJ
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

This reverts commit 474b155adf3927d2c944423045757b54aa1ca4de.

This patch caused regression in ioctl_setflags(). Underlying filesystems
use EOPNOTSUPP to indicate that flag is not supported. This error is
also gets converted in ioctl_setflags(). Therefore, for unsupported
flags error changed from EOPNOSUPP to ENOIOCTLCMD.

Link: https://lore.kernel.org/linux-xfs/a622643f-1585-40b0-9441-cf7ece176e83@kernel.org/
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 fs/file_attr.c         | 12 ++----------
 fs/fuse/ioctl.c        |  4 ----
 fs/overlayfs/copy_up.c |  2 +-
 fs/overlayfs/inode.c   |  5 ++++-
 4 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/fs/file_attr.c b/fs/file_attr.c
index 12424d4945d0..460b2dd21a85 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -84,7 +84,7 @@ int vfs_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
 	int error;
 
 	if (!inode->i_op->fileattr_get)
-		return -EOPNOTSUPP;
+		return -ENOIOCTLCMD;
 
 	error = security_inode_file_getattr(dentry, fa);
 	if (error)
@@ -270,7 +270,7 @@ int vfs_fileattr_set(struct mnt_idmap *idmap, struct dentry *dentry,
 	int err;
 
 	if (!inode->i_op->fileattr_set)
-		return -EOPNOTSUPP;
+		return -ENOIOCTLCMD;
 
 	if (!inode_owner_or_capable(idmap, inode))
 		return -EPERM;
@@ -312,8 +312,6 @@ int ioctl_getflags(struct file *file, unsigned int __user *argp)
 	int err;
 
 	err = vfs_fileattr_get(file->f_path.dentry, &fa);
-	if (err == -EOPNOTSUPP)
-		err = -ENOIOCTLCMD;
 	if (!err)
 		err = put_user(fa.flags, argp);
 	return err;
@@ -335,8 +333,6 @@ int ioctl_setflags(struct file *file, unsigned int __user *argp)
 			fileattr_fill_flags(&fa, flags);
 			err = vfs_fileattr_set(idmap, dentry, &fa);
 			mnt_drop_write_file(file);
-			if (err == -EOPNOTSUPP)
-				err = -ENOIOCTLCMD;
 		}
 	}
 	return err;
@@ -349,8 +345,6 @@ int ioctl_fsgetxattr(struct file *file, void __user *argp)
 	int err;
 
 	err = vfs_fileattr_get(file->f_path.dentry, &fa);
-	if (err == -EOPNOTSUPP)
-		err = -ENOIOCTLCMD;
 	if (!err)
 		err = copy_fsxattr_to_user(&fa, argp);
 
@@ -371,8 +365,6 @@ int ioctl_fssetxattr(struct file *file, void __user *argp)
 		if (!err) {
 			err = vfs_fileattr_set(idmap, dentry, &fa);
 			mnt_drop_write_file(file);
-			if (err == -EOPNOTSUPP)
-				err = -ENOIOCTLCMD;
 		}
 	}
 	return err;
diff --git a/fs/fuse/ioctl.c b/fs/fuse/ioctl.c
index 57032eadca6c..fdc175e93f74 100644
--- a/fs/fuse/ioctl.c
+++ b/fs/fuse/ioctl.c
@@ -536,8 +536,6 @@ int fuse_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
 cleanup:
 	fuse_priv_ioctl_cleanup(inode, ff);
 
-	if (err == -ENOTTY)
-		err = -EOPNOTSUPP;
 	return err;
 }
 
@@ -574,7 +572,5 @@ int fuse_fileattr_set(struct mnt_idmap *idmap,
 cleanup:
 	fuse_priv_ioctl_cleanup(inode, ff);
 
-	if (err == -ENOTTY)
-		err = -EOPNOTSUPP;
 	return err;
 }
diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 27396fe63f6d..20c92ea58093 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -178,7 +178,7 @@ static int ovl_copy_fileattr(struct inode *inode, const struct path *old,
 	err = ovl_real_fileattr_get(old, &oldfa);
 	if (err) {
 		/* Ntfs-3g returns -EINVAL for "no fileattr support" */
-		if (err == -EOPNOTSUPP || err == -EINVAL)
+		if (err == -ENOTTY || err == -EINVAL)
 			return 0;
 		pr_warn("failed to retrieve lower fileattr (%pd2, err=%i)\n",
 			old->dentry, err);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index ecb9f2019395..d4722e1b83bc 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -720,7 +720,10 @@ int ovl_real_fileattr_get(const struct path *realpath, struct file_kattr *fa)
 	if (err)
 		return err;
 
-	return vfs_fileattr_get(realpath->dentry, fa);
+	err = vfs_fileattr_get(realpath->dentry, fa);
+	if (err == -ENOIOCTLCMD)
+		err = -ENOTTY;
+	return err;
 }
 
 int ovl_fileattr_get(struct dentry *dentry, struct file_kattr *fa)

-- 
2.51.0

