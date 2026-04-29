Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2D64218B6;
	Wed, 29 Apr 2026 18:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777486066; cv=none; b=fowhkK3QN9jo7+ERYsgH9ChS3vXMnb5EhPjSXo0qMtSCMnfmF6R8CwvY7PkFGIvq0l2yNSNppGY8/Q/yDrdP+YmeV9lb3AnPMYRkrVf5GBS0Xc2TfqZVxIXiGNmBz4uchvXufoNE0RLdw846PPchl8Taq8JBEoz7VBpWKD/JDog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777486066; c=relaxed/simple;
	bh=MCKLEZC7Qx1FnQ0cZy8w8gaJqor/Oy2yvhPP57H1cWo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rUbhS2np6zHBhcg6XzKcKr15eV0JqYOSjUtseNEjDMHPTIiD7WAViz8pJfVd7AREf1G/mgMbvkcfsm7Ho3qjQgztSQCYM0K04RUflAnoE9FmG05Ky9TTxPUdB5OhmWC9gFHlEOxwzMPHk00sNhsftirhjGzoOI3cKKOF2/XUOow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c2vqU1+D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c2vqU1+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80CF2C2BCF6;
	Wed, 29 Apr 2026 18:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777486065;
	bh=MCKLEZC7Qx1FnQ0cZy8w8gaJqor/Oy2yvhPP57H1cWo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=c2vqU1+DIgO1ouuDvKAm9SaitSoOX/+UnmaoqiRd2TpFdxO43KFDX+GyhO0QQB+p9
	 I1DO7IuT5fkPmJRz0mqf/qAX0FXwEFkYFPlpGQzvZICgK/9lp0JirZYrKzXi65qzU+
	 tJXK5qmPsBqJyvoI95WxV2PWF1AGmOqdsyhU90sh2zsOQ6SUuiAOsbRmYTz7aEKURg
	 9pYuFXOJle8/Ln8V+hJKEpnIe5PBhKdQYfKo5jAYPfv/qsPd0TBns7AQyouVSycHMu
	 2Mvj+mK0HAGWGYd+4iRmb1EimiKagrBVCZJiXz43qFu7w8M8H7uIkKcIuW68etct2t
	 f7NHQ9ynk1vfQ==
From: Chuck Lever <cel@kernel.org>
Date: Wed, 29 Apr 2026 14:07:18 -0400
Subject: [PATCH v12 07/15] hfsplus: Report case sensitivity in fileattr_get
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260429-case-sensitivity-v12-7-8057123bebe0@oracle.com>
References: <20260429-case-sensitivity-v12-0-8057123bebe0@oracle.com>
In-Reply-To: <20260429-case-sensitivity-v12-0-8057123bebe0@oracle.com>
To: Al Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, 
 linux-xfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
 linux-nfs@vger.kernel.org, linux-api@vger.kernel.org, 
 linux-f2fs-devel@lists.sourceforge.net, hirofumi@mail.parknet.co.jp, 
 linkinjeon@kernel.org, sj1557.seo@samsung.com, yuezhang.mo@sony.com, 
 almaz.alexandrovich@paragon-software.com, slava@dubeyko.com, 
 glaubitz@physik.fu-berlin.de, frank.li@vivo.com, tytso@mit.edu, 
 adilger.kernel@dilger.ca, cem@kernel.org, sfrench@samba.org, 
 pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
 trondmy@kernel.org, anna@kernel.org, jaegeuk@kernel.org, chao@kernel.org, 
 hansg@kernel.org, senozhatsky@chromium.org, 
 Chuck Lever <chuck.lever@oracle.com>, 
 Roland Mainz <roland.mainz@nrubsig.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2621;
 i=chuck.lever@oracle.com; h=from:subject:message-id;
 bh=yr1QdNRA2c3h2NX2KtSKVIgsso0huI4pF/+aMWQ1VYs=;
 b=owEBbQKS/ZANAwAKATNqszNvZn+XAcsmYgBp8kjd//ugpCe7RL1EFdZg6sAR5attDISWJ2/Tn
 /1es/HNDSKJAjMEAAEKAB0WIQQosuWwEobfJDzyPv4zarMzb2Z/lwUCafJI3QAKCRAzarMzb2Z/
 l154D/9sRJhZpYvAf/Om/gyeeuNnLwAQO4y4xNSbS+uEm4PDRZFhge2kGJ+SMta5gU0M03jOjnO
 3ZcxFkqNMtVwAy/r53i4MW8p2Onx16VAHPmElEk1k/g9nlfux7Yl6rWG1kPGaDIx0aBlqxnFQs2
 cvYj9veBZOCDu0wsRSNg8WddAJyvQqj/ZJE+eh1/k/b7kbrURHTRHN6PzuYAmZmExXiMQWdlIXe
 NKBwHjr+hLLT/1UBwzh858oV4uFb6+Qk4Fb1xTNKJG2LDc4bi7R6Z5P2VBoOnbj6wuSWZ2cjgnF
 H/TJOgzycFT4QJ9in+k2NxRdcSMJmNljc/Ut+JL25EFKxMSxOEOvvFsiBtAilV5EfJZTyA0EL0/
 9SvMmy9vQ/I69CPIjf3HmoDgB3kvq/L68iMy4iSDqxFgedBXmo4dtAPEBzTI2SbVDeDuWcqkdnE
 BYRE3z4ZzO6sBozJX2bTBM9rmpzZcpR0Hbw33t4cPGwxOL7WFogGOGHjSYR949N1SGi/TcBz6hv
 Nm9f9fngHfqrBgyoTp6O9qSlWM7boe7iTy13sBBMxhZ6RJ6l21/Mv6a5PmOuOP7sHg/pbBhfbb0
 BwAbhYVp4MgRdNYar+AUg7hDroNpOGETgdAYbXqHhAN2YuoX2DZl+XxTHlVOqTXfUb3y2rf399N
 ZU8mxwunytdSlnQ==
X-Developer-Key: i=chuck.lever@oracle.com; a=openpgp;
 fpr=28B2E5B01286DF243CF23EFE336AB3336F667F97

From: Chuck Lever <chuck.lever@oracle.com>

Add case sensitivity reporting to the existing hfsplus_fileattr_get()
function via the FS_XFLAG_CASEFOLD flag. HFS+ always preserves case
at rest.

Case sensitivity depends on how the volume was formatted: HFSX
volumes may be either case-sensitive or case-insensitive, indicated
by the HFSPLUS_SB_CASEFOLD superblock flag.

FS_XFLAG_CASEFOLD is read-only: FS_XFLAG_RDONLY_MASK ensures
FS_IOC_FSSETXATTR strips it. The legacy FS_IOC_SETFLAGS path in
hfsplus_fileattr_set() also allows FS_CASEFOLD_FL through its
allowlist on case-insensitive volumes so that a chattr
read-modify-write cycle does not fail with EOPNOTSUPP.

Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Reviewed-by: Roland Mainz <roland.mainz@nrubsig.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/hfsplus/inode.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index d05891ec492e..5565c14b4bf6 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -740,6 +740,7 @@ int hfsplus_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
 {
 	struct inode *inode = d_inode(dentry);
 	struct hfsplus_inode_info *hip = HFSPLUS_I(inode);
+	struct hfsplus_sb_info *sbi = HFSPLUS_SB(inode->i_sb);
 	unsigned int flags = 0;
 
 	if (inode->i_flags & S_IMMUTABLE)
@@ -748,6 +749,8 @@ int hfsplus_fileattr_get(struct dentry *dentry, struct file_kattr *fa)
 		flags |= FS_APPEND_FL;
 	if (hip->userflags & HFSPLUS_FLG_NODUMP)
 		flags |= FS_NODUMP_FL;
+	if (test_bit(HFSPLUS_SB_CASEFOLD, &sbi->flags))
+		flags |= FS_CASEFOLD_FL;
 
 	fileattr_fill_flags(fa, flags);
 
@@ -759,13 +762,24 @@ int hfsplus_fileattr_set(struct mnt_idmap *idmap,
 {
 	struct inode *inode = d_inode(dentry);
 	struct hfsplus_inode_info *hip = HFSPLUS_I(inode);
+	struct hfsplus_sb_info *sbi = HFSPLUS_SB(inode->i_sb);
+	unsigned int allowed = FS_IMMUTABLE_FL | FS_APPEND_FL | FS_NODUMP_FL;
 	unsigned int new_fl = 0;
 
 	if (fileattr_has_fsx(fa))
 		return -EOPNOTSUPP;
 
+	/*
+	 * FS_CASEFOLD_FL reflects HFSPLUS_SB_CASEFOLD, a mount-time
+	 * property. Accept it as a no-op so chattr's RMW round-trip
+	 * succeeds; reject any attempt to enable it on a volume that
+	 * was not formatted case-insensitive.
+	 */
+	if (test_bit(HFSPLUS_SB_CASEFOLD, &sbi->flags))
+		allowed |= FS_CASEFOLD_FL;
+
 	/* don't silently ignore unsupported ext2 flags */
-	if (fa->flags & ~(FS_IMMUTABLE_FL|FS_APPEND_FL|FS_NODUMP_FL))
+	if (fa->flags & ~allowed)
 		return -EOPNOTSUPP;
 
 	if (fa->flags & FS_IMMUTABLE_FL)

-- 
2.53.0

