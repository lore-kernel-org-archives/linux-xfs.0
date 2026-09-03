Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D02249482D
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 11:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435660; cv=none; b=tp7gC2zRdn73TwrcIrbu/vFaKxrwGIzN5hez5dQeSfh4GODAQhmQWpqiYPJMEH2cC89WLsc9HyUFRPpBZwMxsQc6gqOFrvILglNAZP+VucmweEr8X83Y42b5TmejI+pWZBWZRLNHm9uZTuPbHulpmzpT70rm0gKyyjpCrvmqXpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435660; c=relaxed/simple;
	bh=0mDLMypsDCEE60mzwfQrULBeAMJL5Vjyi53+STp/Yqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MeKat8YaVPmaC/KYhx/cu4pEQQ3Ac6Rp7DGb5TedM7LQPIHd5kAo1y1DDAfkDrrXZ6RNojqd8ULssnSfdu9Dxkjwo0jXCfZOXbR3bqmtOVy5QfirA1jjzu8iOhGu47F5+d/n4RTBSWq9ctePSLmgvs6FfEV/GGnjSPGeD3fQHP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U+nShay5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U+nShay5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91BB21F00A3D;
	Thu,  3 Sep 2026 11:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788435652;
	bh=Rld1pOJe3pD4nr4JopVXmNEU6Ca1ocJqgLI178YIQ8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U+nShay5i7bKwYUg/dxLUDSviOZqpu84BypG3xyH2NgBoxusp5szG6cis//at8d6E
	 9FLgdXt5ZRMIhGRWHh9wSf/o/i31m/4mJ9ggpy9/P8xstUNB6iLJ6k2i8MH9SNegV7
	 FgA/BgelHG2DMsf7OYO5svFVVZqpemOuDhDLy6ZpPlCbybHzaUIvIZxaE1cCOkj99H
	 Ez6nZ2g/yjZxesNGOPAHBFbG/SpgowHJ0ZrOo8bzUQaX+jnXWJ3isqkikLzaF1UI76
	 kMgL9h5lrXADbfApIRjhN/J+ASTlX+qrT5/8YZqbJSlX+xHBuXIRKwC1I7bNkGBViL
	 kN7UVCXfWCVKg==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	aalbersh@kernel.org
Cc: bestswngs@gmail.com,
	brauner@kernel.org,
	cem@kernel.org,
	chuck.lever@oracle.com,
	cmaiolino@redhat.com,
	dawei.feng@seu.edu.cn,
	djwong@kernel.org,
	gaoyingjie@uniontech.com,
	hch@lst.de,
	jiapenglin@tencent.com,
	roland.mainz@nrubsig.org,
	xmei5@asu.edu,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH v2 02/23] xfs: Report case sensitivity in fileattr_get
Date: Thu,  3 Sep 2026 13:39:44 +0200
Message-ID: <20260903114022.570210-3-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903114022.570210-1-aalbersh@kernel.org>
References: <20260903114022.570210-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chuck Lever <cel@kernel.org>

Source kernel commit: c9da43e4e5c32c2cb318e616ffa48c7148a70d49

Upper layers such as NFSD need to query whether a filesystem
is case-sensitive. Add FS_XFLAG_CASEFOLD to xfs_ip2xflags()
when the filesystem is formatted with the ASCIICI feature
flag. This serves both FS_IOC_FSGETXATTR (via xfs_fill_fsxattr()
in xfs_fileattr_get()) and XFS_IOC_BULKSTAT (which populates
bs_xflags directly from xfs_ip2xflags()), so bulkstat consumers
and per-inode queries see a consistent view of the filesystem's
case-folding behavior.

FS_XFLAG_CASEFOLD is read-only: FS_XFLAG_RDONLY_MASK ensures
FS_IOC_FSSETXATTR strips it, and xfs_flags2diflags() has no
clause for CASEFOLD so the on-disk diflags are unaffected.
The legacy FS_IOC_SETFLAGS path in xfs_fileattr_set() also
allows FS_CASEFOLD_FL through its allowlist on ASCIICI
filesystems so that a chattr read-modify-write cycle does
not fail with EOPNOTSUPP.

XFS always preserves case. XFS is case-sensitive by default,
but supports ASCII case-insensitive lookups when formatted
with the ASCIICI feature flag.

Reviewed-by: Roland Mainz <roland.mainz@nrubsig.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://patch.msgid.link/20260507-case-sensitivity-v14-8-e62cc8200435@oracle.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
[djwong: add some missing FS_XFLAG_ private definitions]
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/linux.h         | 17 +++++++++++++++++
 libxfs/xfs_inode_util.c |  2 ++
 2 files changed, 19 insertions(+)

diff --git a/include/linux.h b/include/linux.h
index 8972c9596c75..a10d531cffdb 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -258,6 +258,23 @@ struct file_attr {
 #define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
 #endif
 
+#ifndef FS_XFLAG_VERITY
+#define FS_XFLAG_VERITY		0x00020000	/* fs-verity enabled */
+#endif
+
+/*
+ * Case handling flags (read-only, cannot be set via ioctl).
+ * Default (neither set) indicates POSIX semantics: case-sensitive
+ * lookups and case-preserving storage.
+ */
+#ifndef FS_XFLAG_CASEFOLD
+#define FS_XFLAG_CASEFOLD	0x00040000	/* case-insensitive lookups */
+#endif
+
+#ifndef FS_XFLAG_CASENONPRESERVING
+#define FS_XFLAG_CASENONPRESERVING 0x00080000	/* case not preserved */
+#endif
+
 /* Atomic Write */
 #ifndef RWF_ATOMIC
 #define RWF_ATOMIC	((__kernel_rwf_t)0x00000040)
diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index ccd38f18c3ed..fd8441bf9b83 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -127,6 +127,8 @@ xfs_ip2xflags(
 
 	if (xfs_inode_has_attr_fork(ip))
 		flags |= FS_XFLAG_HASATTR;
+	if (xfs_has_asciici(ip->i_mount))
+		flags |= FS_XFLAG_CASEFOLD;
 	return flags;
 }
 
-- 
2.55.0

