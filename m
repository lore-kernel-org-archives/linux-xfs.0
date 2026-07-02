Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA9732572F
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 20:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783022456; cv=none; b=GdZjnZhSZJYsmt0z2jL1E4rNB7Rh53oM+UYuc/CUXC9cUqTbxXKXYHCgr1VUJ5BB9SgAaBDz7l46CtP6Vf7bBn92nq5iRymQavW6FZ1FYOKlcdxY2KDy654NArDaZZEV1ZSrjbPIuSf8cJKJLFzxUfgUF6lbjZOzInt/9ByIcv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783022456; c=relaxed/simple;
	bh=VPHDB+Qsh+l4mfGwRCThcaKWXM9fxi6kwcy3t+U9sco=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K9ZTv3aZsm7I9neeVh8enC1Io/ryM8M2SWIkTJ5cE8AprKe96+ASyETez7ttTJyBknIttjZPuaFe2YY9kl/M0sc1u4hHU/VG1sPFRWDXPcnWqT2/8hxlM6SndNWLaH16bf+QZR7sapWDS+cFObOGJEX5cLm6L43UR6rUSA4kgQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jIYE0F4N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jIYE0F4N"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EBCF71F000E9;
	Thu,  2 Jul 2026 20:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783022453;
	bh=6zChvvO19w8m8KagOpfgwTxbNby6tzj4KX+zcSshtcw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=jIYE0F4NCT7FUL93nuxoTZIH3lAWbMnSdogoByTF5FAlA86DKS1F8BBLU1POu6zge
	 LVUG9Y1kYF6CQoBJlTw3MP0x4qVtee27KoV+/F5uJ24QoA0aftVpam35TjTb/0XZsb
	 VuPhAgysTW4QqEOEb7T8MBq2/LNGs5NUeFPoxskvUREkvd7ijsAmAnjPoTJ6///KwU
	 fdL5UYxPCezfvPfXEwcvNi4C1nsjesPLDcV1L3movHU7HaIanzKMats5sQl3wsTrl9
	 iPvzngLiXC+GrNikskErMIuAR063fzg0GuxP6YBkUFthcjR+qcZA+h4WlHFCrCapc1
	 L9YeTz64EgvRg==
Date: Thu, 02 Jul 2026 13:00:52 -0700
Subject: [PATCH 02/18] xfs: Report case sensitivity in fileattr_get
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: brauner@kernel.org, chuck.lever@oracle.com, roland.mainz@nrubsig.org,
 linux-xfs@vger.kernel.org
Message-ID: <178302226340.845537.8747268712174851426.stgit@frogsfrogsfrogs>
In-Reply-To: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
References: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
---
 include/linux.h         |   17 +++++++++++++++++
 libxfs/xfs_inode_util.c |    2 ++
 2 files changed, 19 insertions(+)


diff --git a/include/linux.h b/include/linux.h
index 8972c9596c75f5..a10d531cffdb04 100644
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
index ccd38f18c3ed55..fd8441bf9b83dd 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -127,6 +127,8 @@ xfs_ip2xflags(
 
 	if (xfs_inode_has_attr_fork(ip))
 		flags |= FS_XFLAG_HASATTR;
+	if (xfs_has_asciici(ip->i_mount))
+		flags |= FS_XFLAG_CASEFOLD;
 	return flags;
 }
 

