Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C03492518;
	Thu, 22 Jan 2026 16:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769097830; cv=none; b=cBQXk5hMI7FUhHJc5yIEjZWfKdEu2pwCDORXbrNYrOmDaf7B38j3D4eyWANyeagnHKB5NGXqq3oM3W+r+UnTAzHtTcU3gr3J/saA/oCMQv41m6BC2FVtKBOcGnvx071an1PVqtMs+4VLPj3gZiB5b+y4FRckg3Q2/QEQz2o2wvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769097830; c=relaxed/simple;
	bh=lI5RsrikT42DtmkwiTYGrVz82Xk/jcZVtoeRyes8GA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nCkzn6gqw6hUDS8N0o+f0HzTeN/9j+lT5wnY3dcgcJPvAbtrvRwj6NGgTChX01WneP5BB8djVA+DMD+8NtjM1Vi8XhDme9xpngjpikFhzlg0XRtHlqAWrt3HBSw+i777koP0GvAKcB1zHdnFvG9WhOz/LqEhjuvLFhqYzkM+pNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ca0ShbAM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ca0ShbAM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441CEC19422;
	Thu, 22 Jan 2026 16:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769097828;
	bh=lI5RsrikT42DtmkwiTYGrVz82Xk/jcZVtoeRyes8GA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ca0ShbAMUoa+mRpxxAB4N3TxVD558pFyoeIR0ur9Vt4cn+Sihgj1Quw1clKKGygEF
	 28NsTiqBNVmhpbqBjyCwy71PLfdQPaO41Xrl24o2wFc6Li1KVill2L05qwReWgd4nS
	 jj+ClBP/J5hMCY6ID3nbKqfPW4v46RPvhhdR4A99ujtPHwx1ModeZZxLn2aW0qdgCL
	 7b4eKgz6m5FWKwAsSOXChWse/cyKMcf/0oJ4BX2WACN1Qfe6EmMqL2S9ps20HXSUTj
	 Lgl8CU1/VVn1vtW01LYAuIQ4lDuxsqmPZJg3Pt3D9BwF5Zcv13Q+ZXh8YjjSMcdseQ
	 av/7jAVdyAc8Q==
From: Chuck Lever <cel@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>
Cc: <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	<linux-nfs@vger.kernel.org>,
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
Subject: [PATCH v7 13/16] isofs: Implement fileattr_get for case sensitivity
Date: Thu, 22 Jan 2026 11:03:08 -0500
Message-ID: <20260122160311.1117669-14-cel@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260122160311.1117669-1-cel@kernel.org>
References: <20260122160311.1117669-1-cel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chuck Lever <chuck.lever@oracle.com>

Upper layers such as NFSD need a way to query whether a
filesystem handles filenames in a case-sensitive manner so
they can provide correct semantics to remote clients. Without
this information, NFS exports of ISO 9660 filesystems cannot
properly advertise their filename case behavior.

Implement isofs_fileattr_get() to report ISO 9660 case handling
behavior via the FS_XFLAG_CASEFOLD flag. The 'check=r' (relaxed)
mount option enables case-insensitive lookups, and this setting
determines the value reported. By default, Joliet extensions
operate in relaxed mode while plain ISO 9660 uses strict
(case-sensitive) mode. All ISO 9660 variants are case-preserving,
meaning filenames are stored exactly as they appear on the disc.

The callback is registered only on isofs_dir_inode_operations
because isofs has no custom inode_operations for regular
files, and symlinks use the generic page_symlink_inode_operations.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/isofs/dir.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/isofs/dir.c b/fs/isofs/dir.c
index 09df40b612fb..e1a708f219f7 100644
--- a/fs/isofs/dir.c
+++ b/fs/isofs/dir.c
@@ -13,6 +13,7 @@
  */
 #include <linux/gfp.h>
 #include "isofs.h"
+#include <linux/fileattr.h>
 
 int isofs_name_translate(struct iso_directory_record *de, char *new, struct inode *inode)
 {
@@ -266,6 +267,19 @@ static int isofs_readdir(struct file *file, struct dir_context *ctx)
 	return result;
 }
 
+static int isofs_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
+{
+	struct isofs_sb_info *sbi = ISOFS_SB(dentry->d_sb);
+
+	/*
+	 * FS_XFLAG_CASEFOLD indicates case-insensitive lookups.
+	 * When check=r (relaxed) is set, lookups ignore case.
+	 */
+	if (sbi->s_check == 'r')
+		fa->fsx_xflags |= FS_XFLAG_CASEFOLD;
+	return 0;
+}
+
 const struct file_operations isofs_dir_operations =
 {
 	.llseek = generic_file_llseek,
@@ -279,6 +293,7 @@ const struct file_operations isofs_dir_operations =
 const struct inode_operations isofs_dir_inode_operations =
 {
 	.lookup = isofs_lookup,
+	.fileattr_get = isofs_fileattr_get,
 };
 
 
-- 
2.52.0

