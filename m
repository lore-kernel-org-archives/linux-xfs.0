Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795710714;
	b=1SzMXkTtsXdAzdtHqnguJ7CIuMwVkOnTDtB+hB+v97Qp21ZqRqmKIQu8tJY6sGjTupPd
	 bfWWAxSmS5SPgXoRGhYA00b473O0ZlFlOMcnNILtlTmKI2pt/5rLoTGxz0xtK3pilHLF/
	 eAZk1s67ubO18K/6HeKMaEpPvWM933iETzUKMiCDgRvP9OldrkjmcN+4epRCDOrER1SOE
	 bem2RZL7QR8wryWv9eMxPIezhG9PtkoyuW+hXfnp7HSk0WIxcSxYPzEavTOQNww5rtH6x
	 J993TAhlLiToZ7QbS4P1GZpi/kdmtjqt/X/xo4k9uzqjT7gwZzJHnnyfJNVU0HY4ZIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795710714;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JaTAxRtKeYbk84RLM3i2yEqwJv/D2pe6Nve7rFnRBXM=;
	b=X/gQ1ZdTfJ4feuIscxaL1NciyoptbpBvh6LBLDmGfOFYRsmmTkS1fWYuztsFPt+RHTO+
	 aVJYN9j5M1ldkfUE/Slh/nD8HTDP2cRjmnnxnNIHtQKCw10lIe3MTt3HtSw2/upfPYITX
	 I5nvm56zE+1Unipz8OXC2yZuzijMA+ZpysWUtNc3NL95C7sPrLIh4RprpgP5aqyHVyU5H
	 v6+1ka2L/TOnSQwXxJe1WMgi/gcjBKeMlJ/oNhvcQWLe6eLUUbEvq+J+yCYl7GFhOe3/F
	 qTxbFPdrf0fIQo0VfREf4Gbby6slniGKcOch1bcp9WBjdcqFkxGhiiJ7WHg2PULfp3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oWgqtZPJ;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802A560A2620
	for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 16:31:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 802A560A2620
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oWgqtZPJ
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4bb6886d30aso68965485e9.3
        for <linux-xfs@vger.kernel.org>; Thu, 26 Nov 2026 08:31:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795710712; x=1796315512; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JaTAxRtKeYbk84RLM3i2yEqwJv/D2pe6Nve7rFnRBXM=;
        b=oWgqtZPJ+QTfEFZ5N9eQvoTBWfIeBxFyGemMJWQgY+87l+MIRZRTkXIxAtrUT6b9OX
         lT2HhMQ6C4JwF1MVSaAdVK71Ty/ZBm5ROUsJ+uXnsteA6mBaBY2BimSwk8fGh1c+cdpC
         ZNaJxtEMzp0Ca1dT4WWYXeNRtaSMn+HAyyvTTo16OFk+LTiV3CzkZulp2AUJR0Vx2MN5
         NOSdZ3PNLKDcOBGL3j2FfEk2hPWjgRK6SwtQ5bvYSz3OAddq6jZ+wZk3tDft2ZPjyQQm
         fpWnjnFFEclwrR+7KfqwNBjGOOsYdzfpFiXJGWvJ8Lb3XSuMI4Cw1dd2/ry2v+TMORkb
         Ql1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795710712; x=1796315512;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JaTAxRtKeYbk84RLM3i2yEqwJv/D2pe6Nve7rFnRBXM=;
        b=NQYxZO7kThFlV6O2LPfK5ONTEoOoynwPMRCAgDge8tm6Z+Znu/hsiPhXoc+er+aJjG
         rD+MkDnQzDfXxdIyncRpgi8+Xf+GfDapXAE6eSmG/Bhp5MlsuO8LkESbR1doBVDgtSAh
         CCQsnqoXTYrBK9Q8bh9PH9SzCj7rqGlCaG9sYPab0d4z4J6etJZmEbyub3tjM9XFI/sq
         LUMtIqJyPFfWgOzPZz326PA/zEC9b7LJIv+f038+CEhPwg0N4e3L4FXMGK8OVqvREVuE
         M5QZBFV3fnDOW6UX0T3Dx0DEAnJaScM+o2iD0q6Dv2o5WJDltxr8XawXBTZ4zx3GPeKu
         N2cQ==
X-Forwarded-Encrypted: i=1; AL+hErFywudt+5tXoRZuCokGdxAr6ahXPceIs03LAinKWclkF7XqanmLuC5fNixDgS1t72z8F08VU3o2KLA=@vger.kernel.org
X-Gm-Message-State: APuU4Z/9C7EMGsYa3SHfXFvk3iMIG8M/lmNPSAZn+ghpIAQGBog+dJv+
	Da+VaBOQOKxi9xqtv7R9Ny1GwuGPg4GIy/LEH3fC7Ynb9fIFV6l29OUh
X-Gm-Gg: AZFdTZcRaN4gyAxqbGJJYS5lThffZlpabRsh0QxI+3CLcQMeWkWcvFDNcIQw2J9vIkW
	Hk7oGW4abCl0NvTnXf7faeA0ZG1h1N3rRIM4GKl3OHXDC2CUZ0e3BYh+RshkH3dG8XSDU31W9eS
	Ji+A1eP3eijNoxJ6RTH8oJpZn1cmpAVNDIUUlOJ5kcikLtk0rHMlVPKVZIcH4UVo2si8Fr9omsF
	QfJndrNKu8oAGKKpfTE4dyAhZMulQDHx+UJFkBCHmZMlZgKzcvuLN3Lqzmoe52Uh4BsvMApyvZS
	qN8lseDBJJ2gk9AtgnSyylsS8y7OLJY1iYhGGybUp0cdK/70b/nAJHVFKFLg5vd1biY3DxrZ1k9
	S/5dFSWF/fyir7GmWRdzM+aJc7dwaokfGOcLEis36D5HaiOjf2IusgtBaIRG5daD9rDBj2YzfOX
	tk4kbaoqSKySnjP+Lf/EGPZrHmZ0fsvjLNz1VYO7fEtib/h9rpUhAPzAvTP21B3HgGsNQw2k3eR
	3QcgtAAPTR6e7Qamc8ycv/pv+LKur2u7CK9kSekgwP7hKgnmZNAScY6tvJ9fBTme/YGn8eiunNb
	zGyWInzgQZ61JCTbMwV9BQkx
X-Received: by 2002:a05:600c:4f84:b0:4bb:8701:a2df with SMTP id 5b1f17b1804b1-4bb88809950mr444061975e9.17.1795710711689;
        Thu, 26 Nov 2026 08:31:51 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853a9846sm721964995e9.11.2026.11.26.08.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 08:31:51 -0800 (PST)
From: koraynilay <koray.fra@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y . Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Aring <alex.aring@gmail.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Lauri Gates <lauri.gates@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <dgc@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	ntfs@lists.linux.dev,
	linux-nfs@vger.kernel.org,
	linux-api@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>
Subject: [PATCH v2 4/4] ntfs: switch to the new xflags fileattr API
Date: Thu, 26 Nov 2026 17:31:14 +0100
Message-ID: <20261126163114.403846-5-koray.fra@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261126163114.403846-1-koray.fra@gmail.com>
References: <20261126163114.403846-1-koray.fra@gmail.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Switch ntfs_fileattr_[gs]et() from the legacy FS_*_FL flags to the
modern xflags (FS_XFLAG_*) fileattr API with masks.

Introduce FS_XFLAG_COMPR and FS_XFLAG_ENCRYPT to be used in this API
upgrade.

Following the FS_XFLAG_VERITY example, put FS_XFLAG_ENCRYPT in
FS_XFLAG_RDONLY_MASK and in FS_XFLAG_COMMON, since it's read-only for
all filesystems.

Following the FS_XFLAG_CASEFOLD example, put FS_XFLAG_COMPR in
FS_XFLAG_RDONLY_MASK but not in FS_XFLAG_COMMON, since it's read-write
for some filesystems and read-only for others, to avoid breaking
existing filesystems.

Also update vfs fileattr_fill_* helpers to include these two flags as
well.

Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.11
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
 fs/file_attr.c           |   8 +++
 fs/ntfs/file.c           | 109 +++++++++++++++++++++------------------
 include/linux/fileattr.h |   7 +--
 include/uapi/linux/fs.h  |   2 +
 4 files changed, 72 insertions(+), 54 deletions(-)

diff --git a/fs/file_attr.c b/fs/file_attr.c
index 35bc2ded2ff8..3631353ec9c7 100644
--- a/fs/file_attr.c
+++ b/fs/file_attr.c
@@ -39,6 +39,10 @@ void fileattr_fill_xflags(struct file_kattr *fa, u32 xflags)
 		fa->flags |= FS_VERITY_FL;
 	if (fa->fsx_xflags & FS_XFLAG_CASEFOLD)
 		fa->flags |= FS_CASEFOLD_FL;
+	if (fa->fsx_xflags & FS_XFLAG_COMPR)
+		fa->flags |= FS_COMPR_FL;
+	if (fa->fsx_xflags & FS_XFLAG_ENCRYPT)
+		fa->flags |= FS_ENCRYPT_FL;
 }
 EXPORT_SYMBOL(fileattr_fill_xflags);
 
@@ -71,6 +75,10 @@ void fileattr_fill_flags(struct file_kattr *fa, u32 flags)
 		fa->fsx_xflags |= FS_XFLAG_VERITY;
 	if (fa->flags & FS_CASEFOLD_FL)
 		fa->fsx_xflags |= FS_XFLAG_CASEFOLD;
+	if (fa->flags & FS_COMPR_FL)
+		fa->fsx_xflags |= FS_XFLAG_COMPR;
+	if (fa->flags & FS_ENCRYPT_FL)
+		fa->fsx_xflags |= FS_XFLAG_ENCRYPT;
 }
 EXPORT_SYMBOL(fileattr_fill_flags);
 
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index 50be49f4c913..34acf9333c41 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -155,31 +155,38 @@ int ntfs_file_release(struct inode *vi, struct file *filp)
  * @dentry: dentry to report the flags of
  * @fa: filled in with the flags of @dentry
  */
+#define NTFS_RO_XFLAGS (FS_XFLAG_COMPR | FS_XFLAG_ENCRYPT | \
+			FS_XFLAG_CASEFOLD)
+#define NTFS_RW_XFLAGS (FS_XFLAG_IMMUTABLE | FS_XFLAG_APPEND | \
+			FS_XFLAG_NOATIME | FS_XFLAG_NODUMP)
 int ntfs_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
 {
 	struct inode *vi = d_inode(dentry);
 	struct ntfs_inode *ni = NTFS_I(vi);
-	u32 flags = 0;
+	u32 xflags = 0;
 
 	if (NVolShutdown(ni->vol))
 		return -EIO;
 
 	if (NInoCompressed(ni) || NInoWofCompressed(ni))
-		flags |= FS_COMPR_FL;
+		xflags |= FS_XFLAG_COMPR;
 	if (NInoEncrypted(ni))
-		flags |= FS_ENCRYPT_FL;
+		xflags |= FS_XFLAG_ENCRYPT;
 	if (vi->i_flags & S_IMMUTABLE)
-		flags |= FS_IMMUTABLE_FL;
+		xflags |= FS_XFLAG_IMMUTABLE;
 	if (vi->i_flags & S_APPEND)
-		flags |= FS_APPEND_FL;
+		xflags |= FS_XFLAG_APPEND;
 	if (vi->i_flags & S_NOATIME)
-		flags |= FS_NOATIME_FL;
+		xflags |= FS_XFLAG_NOATIME;
 	if (ni->linuxflags & NTFS_LINUXFLAGS_NODUMP)
-		flags |= FS_NODUMP_FL;
+		xflags |= FS_XFLAG_NODUMP;
 	if (!NVolCaseSensitive(ni->vol))
-		flags |= FS_CASEFOLD_FL;
+		xflags |= FS_XFLAG_CASEFOLD;
 
-	fileattr_fill_flags(fa, flags);
+	fileattr_fill_xflags(fa, xflags);
+	fa->fsx_xflags_ro_mask = NTFS_RO_XFLAGS;
+	fa->fsx_xflags_rw_mask = NTFS_RW_XFLAGS;
+	fa->has_masks = true;
 	return 0;
 }
 
@@ -207,11 +214,9 @@ int ntfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
 {
 	struct inode *vi = d_inode(dentry);
 	struct ntfs_inode *ni = NTFS_I(vi);
-	u32 allowed = FS_IMMUTABLE_FL | FS_APPEND_FL | FS_NODUMP_FL |
-		      FS_NOATIME_FL;
-	u32 readonly = 0;
-	u32 linuxflags = ni->linuxflags & ~NTFS_LINUXFLAGS_MASK;
-	unsigned int new_fl = 0;
+	u32 linuxflags = ni->linuxflags;
+	u32 rw_user_mask = fa->fsx_xflags_rw_mask;
+	unsigned int new_fl = 0, mask_fl = 0;
 	bool forced_immutable;
 	int err;
 
@@ -219,44 +224,46 @@ int ntfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
 	if (err)
 		return err;
 
-	if (fileattr_has_fsx(fa))
-		return -EOPNOTSUPP;
-
-	/* chattr passes the unchanged read-only flags back to us too. */
-	if (NInoCompressed(ni) || NInoWofCompressed(ni))
-		readonly |= FS_COMPR_FL;
-	if (NInoEncrypted(ni))
-		readonly |= FS_ENCRYPT_FL;
-	if ((fa->flags ^ readonly) & (FS_COMPR_FL | FS_ENCRYPT_FL))
-		return -EOPNOTSUPP;
-	allowed |= readonly;
-
-	/* Case folding is a read-only, mount-wide property. */
-	if (!NVolCaseSensitive(ni->vol))
-		allowed |= FS_CASEFOLD_FL;
-	if (fa->flags & ~allowed)
-		return -EOPNOTSUPP;
-
-	forced_immutable = ntfs_is_forced_immutable(vi);
-	if (!(fa->flags & FS_IMMUTABLE_FL) && forced_immutable)
-		return -EPERM;
-
-	if (fa->flags & FS_IMMUTABLE_FL) {
-		new_fl |= S_IMMUTABLE;
-		/* Do not persist an immutable bit derived from the mount. */
-		if (!forced_immutable ||
-		    (ni->linuxflags & NTFS_LINUXFLAGS_IMMUTABLE))
-			linuxflags |= NTFS_LINUXFLAGS_IMMUTABLE;
+	if (rw_user_mask & FS_XFLAG_IMMUTABLE) {
+		forced_immutable = ntfs_is_forced_immutable(vi);
+		if (!(fa->fsx_xflags & FS_XFLAG_IMMUTABLE) && forced_immutable)
+			return -EPERM;
+
+		mask_fl |= S_IMMUTABLE;
+		if (fa->fsx_xflags & FS_XFLAG_IMMUTABLE) {
+			new_fl |= S_IMMUTABLE;
+			/* Do not persist an immutable bit derived from the mount. */
+			if (!forced_immutable ||
+			    (ni->linuxflags & NTFS_LINUXFLAGS_IMMUTABLE))
+				linuxflags |= NTFS_LINUXFLAGS_IMMUTABLE;
+		} else {
+			if (ni->linuxflags & NTFS_LINUXFLAGS_IMMUTABLE)
+				linuxflags &= ~NTFS_LINUXFLAGS_IMMUTABLE;
+		}
 	}
-	if (fa->flags & FS_APPEND_FL) {
-		new_fl |= S_APPEND;
-		linuxflags |= NTFS_LINUXFLAGS_APPEND;
+	if (rw_user_mask & FS_XFLAG_APPEND) {
+		mask_fl |= S_APPEND;
+		if (fa->fsx_xflags & FS_XFLAG_APPEND) {
+			new_fl |= S_APPEND;
+			linuxflags |= NTFS_LINUXFLAGS_APPEND;
+		} else {
+			linuxflags &= ~NTFS_LINUXFLAGS_APPEND;
+		}
+	}
+	if (rw_user_mask & FS_XFLAG_NODUMP) {
+		if (fa->fsx_xflags & FS_XFLAG_NODUMP)
+			linuxflags |= NTFS_LINUXFLAGS_NODUMP;
+		else
+			linuxflags &= ~NTFS_LINUXFLAGS_NODUMP;
 	}
-	if (fa->flags & FS_NODUMP_FL)
-		linuxflags |= NTFS_LINUXFLAGS_NODUMP;
-	if (fa->flags & FS_NOATIME_FL) {
-		new_fl |= S_NOATIME;
-		linuxflags |= NTFS_LINUXFLAGS_NOATIME;
+	if (rw_user_mask & FS_XFLAG_NOATIME) {
+		mask_fl |= S_NOATIME;
+		if (fa->fsx_xflags & FS_XFLAG_NOATIME) {
+			new_fl |= S_NOATIME;
+			linuxflags |= NTFS_LINUXFLAGS_NOATIME;
+		} else {
+			linuxflags &= ~NTFS_LINUXFLAGS_NOATIME;
+		}
 	}
 
 	mutex_lock(&ni->mrec_lock);
@@ -265,7 +272,7 @@ int ntfs_fileattr_set(const struct mnt_idmap *idmap, struct dentry *dentry,
 	if (err)
 		return err;
 
-	inode_set_flags(vi, new_fl, S_IMMUTABLE | S_APPEND | S_NOATIME);
+	inode_set_flags(vi, new_fl, mask_fl);
 	inode_set_ctime_current(vi);
 	mark_inode_dirty(vi);
 	return 0;
diff --git a/include/linux/fileattr.h b/include/linux/fileattr.h
index 725efac15e76..b201333443ca 100644
--- a/include/linux/fileattr.h
+++ b/include/linux/fileattr.h
@@ -7,17 +7,18 @@
 #define FS_COMMON_FL \
 	(FS_SYNC_FL | FS_IMMUTABLE_FL | FS_APPEND_FL | \
 	 FS_NODUMP_FL |	FS_NOATIME_FL | FS_DAX_FL | \
-	 FS_PROJINHERIT_FL | FS_VERITY_FL)
+	 FS_PROJINHERIT_FL | FS_VERITY_FL | FS_ENCRYPT_FL)
 
 #define FS_XFLAG_COMMON \
 	(FS_XFLAG_SYNC | FS_XFLAG_IMMUTABLE | FS_XFLAG_APPEND | \
 	 FS_XFLAG_NODUMP | FS_XFLAG_NOATIME | FS_XFLAG_DAX | \
-	 FS_XFLAG_PROJINHERIT | FS_XFLAG_VERITY)
+	 FS_XFLAG_PROJINHERIT | FS_XFLAG_VERITY | FS_XFLAG_ENCRYPT)
 
 /* Read-only inode flags */
 #define FS_XFLAG_RDONLY_MASK \
 	(FS_XFLAG_PREALLOC | FS_XFLAG_HASATTR | FS_XFLAG_VERITY | \
-	 FS_XFLAG_CASEFOLD | FS_XFLAG_CASENONPRESERVING)
+	 FS_XFLAG_CASEFOLD | FS_XFLAG_CASENONPRESERVING | FS_XFLAG_ENCRYPT | \
+	 FS_XFLAG_COMPR)
 
 /* Flags to indicate valid value of fsx_ fields */
 #define FS_XFLAG_VALUES_MASK \
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 63d88ebe3420..8d78990eb95c 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -274,6 +274,8 @@ struct file_attr {
 #define FS_XFLAG_CASEFOLD	0x00040000	/* case-insensitive lookups */
 #define FS_XFLAG_CASENONPRESERVING 0x00080000	/* case not preserved */
 #define FS_XFLAG_PROJID		0x00100000	/* project ID */
+#define FS_XFLAG_COMPR		0x00200000	/* Compress file */
+#define FS_XFLAG_ENCRYPT	0x00400000	/* Encrypted file */
 
 #define FS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
 
-- 
2.56.0

