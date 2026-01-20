Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81ABC44BC96;
	Tue, 20 Jan 2026 14:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768919122; cv=none; b=NJx/vqNgxIWkZMtdyg6o06pyargeX4eeIM1zp/WSSNbgehyPCZ1JgT0XFAJ/zaCBH7VMFakYCovWek/qeTaJbLLOE0/8VwLL/K0pVp7d8ZLFnh4TzU4i6ICVWVmB8ZbrEqgfo94m3/byNWdDGggGBhNYLe62wBAH0ZJzTvjYvEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768919122; c=relaxed/simple;
	bh=cWXqjiYSCBw218vhYxZFFr2kBXjHfrbsfjhWPCfq4hM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V1+onuDmUsi5OCNdyVmw1evJ6nUFe5HX+pHp+KU9qYYnWWhHxbf7qLxbJfXxzs/vxqSUDULgx4y/gVv0KQbZJUVGzyVTENjiHjUaenTgRL3cYAWrPHenuGz0OPJ9ZkKRcT8KY6TZp8yr/kD4PBVBXn4XK7wr4avL6BhGNY7qJa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iJ6Fblv2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iJ6Fblv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD91BC16AAE;
	Tue, 20 Jan 2026 14:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768919122;
	bh=cWXqjiYSCBw218vhYxZFFr2kBXjHfrbsfjhWPCfq4hM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iJ6Fblv2qO5UvJg1OEulK5ftXItW8uXaGc2NMLqyGH1Wl4uYXjDvIzxIyCIW34me7
	 roQstI1W1kQzW7f/voI3HkNp5c05XXFXyur1WMkblF2oh3xGAffuaMQ4PfJ03mmw6I
	 CanZVoQGsc6x6BFOz2JYbeUSIo/rXcSpghB+BeevOvHclZMR89pammzN7/rQfpJROY
	 /SkpwKqF+5NzyeSMMOL83xhvsVaezUhewsHQTjtEDC3KX+R84zoOKZZEjAE302tvMU
	 GQMdObB2scsDnVC8URrNofXM3cMi3DTl4stLNOiueoVuFKJmOTTonWRRkN8kgUS9vu
	 QFPTMmm8c5+rw==
From: Chuck Lever <cel@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>
Cc: <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	<linux-nfs@vger.kernel.org>,
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
Subject: [PATCH v6 16/16] ksmbd: Report filesystem case sensitivity via FS_ATTRIBUTE_INFORMATION
Date: Tue, 20 Jan 2026 09:24:39 -0500
Message-ID: <20260120142439.1821554-17-cel@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260120142439.1821554-1-cel@kernel.org>
References: <20260120142439.1821554-1-cel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chuck Lever <chuck.lever@oracle.com>

ksmbd hard-codes FILE_CASE_SENSITIVE_SEARCH and
FILE_CASE_PRESERVED_NAMES in FS_ATTRIBUTE_INFORMATION responses,
incorrectly indicating all exports are case-sensitive. This breaks
clients accessing case-insensitive filesystems like exFAT or
ext4/f2fs directories with casefold enabled.

Query actual case behavior via vfs_fileattr_get() and report accurate
attributes to SMB clients. Filesystems without ->fileattr_get continue
reporting default POSIX behavior (case-sensitive, case-preserving).

SMB's FS_ATTRIBUTE_INFORMATION reports per-share attributes from the
share root, not per-file. Shares mixing casefold and non-casefold
directories report the root directory's behavior.

Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/smb/server/smb2pdu.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 2fcd0d4d1fb0..257da9282bcf 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -13,6 +13,7 @@
 #include <linux/falloc.h>
 #include <linux/mount.h>
 #include <linux/filelock.h>
+#include <linux/fileattr.h>
 
 #include "glob.h"
 #include "smbfsctl.h"
@@ -5486,16 +5487,28 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 	case FS_ATTRIBUTE_INFORMATION:
 	{
 		FILE_SYSTEM_ATTRIBUTE_INFO *info;
+		struct file_kattr fa = {};
 		size_t sz;
+		u32 attrs;
+		int err;
 
 		info = (FILE_SYSTEM_ATTRIBUTE_INFO *)rsp->Buffer;
-		info->Attributes = cpu_to_le32(FILE_SUPPORTS_OBJECT_IDS |
-					       FILE_PERSISTENT_ACLS |
-					       FILE_UNICODE_ON_DISK |
-					       FILE_CASE_PRESERVED_NAMES |
-					       FILE_CASE_SENSITIVE_SEARCH |
-					       FILE_SUPPORTS_BLOCK_REFCOUNTING);
+		attrs = FILE_SUPPORTS_OBJECT_IDS |
+			FILE_PERSISTENT_ACLS |
+			FILE_UNICODE_ON_DISK |
+			FILE_SUPPORTS_BLOCK_REFCOUNTING;
 
+		err = vfs_fileattr_get(path.dentry, &fa);
+		if (err && err != -ENOIOCTLCMD) {
+			path_put(&path);
+			return err;
+		}
+		if (!(fa.fsx_xflags & FS_XFLAG_CASEFOLD))
+			attrs |= FILE_CASE_SENSITIVE_SEARCH;
+		if (!(fa.fsx_xflags & FS_XFLAG_CASENONPRESERVING))
+			attrs |= FILE_CASE_PRESERVED_NAMES;
+
+		info->Attributes = cpu_to_le32(attrs);
 		info->Attributes |= cpu_to_le32(server_conf.share_fake_fscaps);
 
 		if (test_share_config_flag(work->tcon->share_conf,
-- 
2.52.0

