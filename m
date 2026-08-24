Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8853E283FDC
	for <linux-xfs@vger.kernel.org>; Mon, 24 Aug 2026 11:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787571953; cv=none; b=d+3Jf5nMMF4w2gi2qr26MUtTT0nGF+GOSIMHH3+LvK8wMTMggafC1fHxWKAIJl28USuX6IuX2UazDess7SCfRub/W6Ce7vVqsWA1KMnpiyDWfNY61vuiMXu1DIYa4BTlZhjShja7xZpgJoCgnCDpvEjEBZzNMvYl+Jzpti8DrvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787571953; c=relaxed/simple;
	bh=VTDXAsZ/E9ps8tUbxzkKRkBIFCY4LNERt5zpRAdY0Y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbIBSBOYyya4ro3X1+wjaggDPs75Iz8279lkJvtE+T/X3WuD4kPsQ2utJA/M8YEYnFr6AQP97Jofhze+7/aTDTlYmqoo4Yakcb16ylPS8wMYCtJGTeYv7QvojzuBtZFc99rJvr6Ne0/vMM9/l/PSRMg0fn1d40wT6rLb2yBLnVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B/vFjYYl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B/vFjYYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87F01F00A3A;
	Mon, 24 Aug 2026 11:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787571952;
	bh=QkQtINdm402R83Hc/H/VQYagpAkhajSmCkgkbwEMvIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B/vFjYYlN830alivKoPj3iaSSaslPJONNmDYNMRj6W0BnNbXHnWR0x1+owKVFbTKV
	 imBgwYPUnXvvpWUHyRcr3ynvqK1pePoUV8K4J4jUZuCejN0SMFXex1gPfB2Q3gYhMB
	 nbOF6OoagOGDht/YXOUVgqdA2ls66HzOnHXma/Xai+S+AwQXDdGXt4LNqXb9RJFnsA
	 nn6B1i157Ez5e7dGH0Zs544UzekeJErPrKBdahJV5zP+M2GTm9DTfDwsOwm0x7xq2J
	 M+fSrgB7npn/Ci2m2rXU660FiXAcb2keA7q0FJ4XuAam97IyhouwABaEpEgUqijV2V
	 h+DLq3YZQVRNQ==
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
Subject: [PATCH 01/21] xfs: Report case sensitivity in fileattr_get
Date: Mon, 24 Aug 2026 12:39:59 +0200
Message-ID: <20260824104022.420566-2-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260824104022.420566-1-aalbersh@kernel.org>
References: <20260824104022.420566-1-aalbersh@kernel.org>
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
---
 include/linux.h         | 5 +++++
 libxfs/xfs_inode_util.c | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/include/linux.h b/include/linux.h
index 8972c9596c75..a6323a97f41d 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -268,6 +268,11 @@ struct file_attr {
 #define RWF_DONTCACHE	((__kernel_rwf_t)0x00000080)
 #endif
 
+#ifndef FS_XFLAG_CASEFOLD
+#define FS_XFLAG_CASEFOLD	0x00040000	/* case-insensitive lookups */
+#define FS_XFLAG_CASENONPRESERVING 0x00080000	/* case not preserved */
+#endif
+
 /*
  * Reminder: anything added to this file will be compiled into downstream
  * userspace projects!
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

