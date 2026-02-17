Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B492FCC01;
	Tue, 17 Feb 2026 21:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771364876; cv=none; b=un/rh9s/NMRd6h2Q7/txTW6wX3DQRZigeUC0iKpD9zi1rN3C53SYdE7lxQZvdQFFqGdx+TvYRmSQElbLCIMtjd41Mw6hNM1NWHjdhtz3ksPNhhw98oM+qtw0tWXJpyjeYelVyjPvjpRLgEEGZLqMRSMSYW0l54MOLi9pxRdOwXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771364876; c=relaxed/simple;
	bh=jqBG6MkL4KZPFA3a1GqxBqdJRUrkvA5i1/WFsqQI3ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/YySyirgtQiPRbCgPvWA3kIviTOlr50/JlvFO4+fMEYkkIMzphaHe4zMOV+NUwvcnZWNTy3CMx6r8krpU6uFM4eAaoJM7r1XoEj4PWNf/757wN3OZmiO1qHMhLvpX1H82ZXrHbfvLZtdVqfMLTfk5iXaWKWunWQwDbtyMMgKx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HkQWUGwN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HkQWUGwN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1752BC4CEF7;
	Tue, 17 Feb 2026 21:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771364876;
	bh=jqBG6MkL4KZPFA3a1GqxBqdJRUrkvA5i1/WFsqQI3ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HkQWUGwNMSyYjRDCN2P6QXiho+aAJFeccbLO30JKCT1m10rCY5iuTj7fjshNfwLj2
	 pvCgCBc9jzTr4s8cAS+yvkKwS1aCArc/fEYVSfR0fooTq5s+fj2CKgWX2vXKsXkOMF
	 sWd77ftG+yDh/sf5dxpXusxsuChTzybBmxDtTDgjQIpF0wFZrg9Syd1zu+EO8M7heZ
	 wtyUHp7o905rf/fWjtHHy2svpllm4ee6bBTrycVGkYKrBoLec4/PkvtHESZzLeMGdk
	 t2KOuzpbk+k4OGOdxcjwoTonZCWUYX+aFxxhdLWilABp8JnPZsIMNhX50BpKgzlTxW
	 KCIAVCkg/pi6Q==
From: Chuck Lever <cel@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	hirofumi@mail.parknet.co.jp,
	linkinjeon@kernel.org,
	sj1557.seo@samsung.com,
	yuezhang.mo@sony.com,
	almaz.alexandrovich@paragon-software.com,
	slava@dubeyko.com,
	glaubitz@physik.fu-berlin.de,
	frank.li@vivo.com,
	tytso@mit.edu,
	adilger.kernel@dilger.ca,
	cem@kernel.org,
	sfrench@samba.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	trondmy@kernel.org,
	anna@kernel.org,
	jaegeuk@kernel.org,
	chao@kernel.org,
	hansg@kernel.org,
	senozhatsky@chromium.org,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH v8 04/17] exfat: Implement fileattr_get for case sensitivity
Date: Tue, 17 Feb 2026 16:47:28 -0500
Message-ID: <20260217214741.1928576-5-cel@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217214741.1928576-1-cel@kernel.org>
References: <20260217214741.1928576-1-cel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chuck Lever <chuck.lever@oracle.com>

Report exFAT's case sensitivity behavior via the FS_XFLAG_CASEFOLD
flag. exFAT is always case-insensitive (using an upcase table for
comparison) and always preserves case at rest.

Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/exfat/exfat_fs.h |  2 ++
 fs/exfat/file.c     | 16 ++++++++++++++--
 fs/exfat/namei.c    |  1 +
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/exfat/exfat_fs.h b/fs/exfat/exfat_fs.h
index 2dbed5f8ec26..686d4cd49546 100644
--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -468,6 +468,8 @@ int exfat_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 int exfat_getattr(struct mnt_idmap *idmap, const struct path *path,
 		  struct kstat *stat, unsigned int request_mask,
 		  unsigned int query_flags);
+struct file_kattr;
+int exfat_fileattr_get(struct dentry *dentry, struct file_kattr *fa);
 int exfat_file_fsync(struct file *file, loff_t start, loff_t end, int datasync);
 long exfat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
 long exfat_compat_ioctl(struct file *filp, unsigned int cmd,
diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index 90cd540afeaa..15629b0a6f6d 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -13,6 +13,7 @@
 #include <linux/msdos_fs.h>
 #include <linux/writeback.h>
 #include <linux/filelock.h>
+#include <linux/fileattr.h>
 
 #include "exfat_raw.h"
 #include "exfat_fs.h"
@@ -282,6 +283,16 @@ int exfat_getattr(struct mnt_idmap *idmap, const struct path *path,
 	return 0;
 }
 
+int exfat_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
+{
+	/*
+	 * exFAT is always case-insensitive (using upcase table).
+	 * Case is preserved at rest (the default).
+	 */
+	fa->fsx_xflags |= FS_XFLAG_CASEFOLD;
+	return 0;
+}
+
 int exfat_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 		  struct iattr *attr)
 {
@@ -775,6 +786,7 @@ const struct file_operations exfat_file_operations = {
 };
 
 const struct inode_operations exfat_file_inode_operations = {
-	.setattr     = exfat_setattr,
-	.getattr     = exfat_getattr,
+	.setattr	= exfat_setattr,
+	.getattr	= exfat_getattr,
+	.fileattr_get	= exfat_fileattr_get,
 };
diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index 670116ae9ec8..7895dda5cdb4 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -1323,4 +1323,5 @@ const struct inode_operations exfat_dir_inode_operations = {
 	.rename		= exfat_rename,
 	.setattr	= exfat_setattr,
 	.getattr	= exfat_getattr,
+	.fileattr_get	= exfat_fileattr_get,
 };
-- 
2.53.0

