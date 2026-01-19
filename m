Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DA8238C0A;
	Mon, 19 Jan 2026 16:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768841820; cv=none; b=Z4pT4WZGzc7eS0FTokOFNiJOW6QwBsdKiN5b1IsPbyW/wI8yMpzm89hMriJbuK6CaXmop/WumhKOeDWV+WLaBJdMX9pR/4UstMjk4H+4Lfm6BSqVupapuLO5Zk6SzPD+MPsH8UMLPkpNoAXxkYugDN7XJ5pzZSoraF9OOzuINCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768841820; c=relaxed/simple;
	bh=a8G59Npae+OCsscRUQyCG3vvV96FNv1OHN8iFXpDfbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HY6o56PWyMz3GtSs0UE1yCxS3hK/QTG5JZ9wmQ6NY1FT9HFn8vjbGnpTyQZ7URiPgqgiyCQeAtAXTRohFwjtIRP/7gNQbHd7OyG0XDcJV/Kf9cFkeqsjE1BePhpzAZYNeP4b2dktdWnvGw6XioGbtApMPvbgfn4EAW+HRjMa+2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E+SDMOgp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E+SDMOgp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1920C19424;
	Mon, 19 Jan 2026 16:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768841820;
	bh=a8G59Npae+OCsscRUQyCG3vvV96FNv1OHN8iFXpDfbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E+SDMOgpEelAGHfT9m1O9t/KWjbgdLP/IoEkIBAVW9ZFaAtOKoBuqyAO0yMmtY+Lc
	 EyF0mnqaXyI3URkBQTQKTc5/f2pF5wO0Qh6+x6fnHHCTTVPgyfRJTfhSlbujUsRjBd
	 WXe0BoNbM1XMAtgPJIEbfMdGiB2aIKfZvOtQLwUutcA7vHPRUgGUJnZ5YsUYvudMKK
	 hbGQN/aBT7yj6BPiGF9aHbg929KuGTTvARTHYGkgSyD2S1kDdfql90UNPTY+FHeSBs
	 /yKLcESvVtCEnMgwtYj8WDW3zd1KBbnxi7f2vlLB0cbFJ7cNj/tmKEdPAdOzXPNimP
	 /N0i+aaoISMag==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	djwong@kernel.org
Subject: [PATCH v2 1/2] fs: add FS_XFLAG_VERITY for fs-verity files
Date: Mon, 19 Jan 2026 17:56:42 +0100
Message-ID: <20260119165644.2945008-2-aalbersh@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260119165644.2945008-1-aalbersh@kernel.org>
References: <20260119165644.2945008-1-aalbersh@kernel.org>
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

