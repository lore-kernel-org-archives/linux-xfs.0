Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871096;
	b=m6cSbgcAHcaK6dQXuWi0t6pXkflCUBKbUCtnzhXQEkDKxWHWrG7898p+0XDs0I7cQHdp
	 tPFv51vhgIz9vpblfx7v3IjcMpKy4LeKNSXAsItA/67dJG7wTDiWmiLNLCUfbLbcvyQ0t
	 aCTNxC10mEIpwHDMgCCZGsH1l2sCNegjpdHQX3hyvN53/oHxT34AcGBJQ7qwJi91tHmbJ
	 zL9q5QbgtD+V95S/pxlYw9FyPbhrWM/XoNWFPb2dJgf2pWH1s1Hxsk0iQygpvPnN3MNeJ
	 DKwLK8imK+PQ2abaVIMGsnnkMO4PBHR4hZgbuHfo3OvZ3CFd9ZjrB+oK8czFkYDLxTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871096;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=3o6w6cTgQbKbEe+Pv+SpFYeozeaFRdnSDhtRFY2hyho=;
	b=pr8sNDhdYtzmCIEZQSO21PzPcAh9gzkPKAOj50YGd8DZj2MlF00jaIiL2OiRemH9u3hn
	 WltfxbuUTVubYt1MPWpfbkVGyYDKXcYZhkiABhM0xCZg/5MxDC+pfTNOgkfm+F/Sy/aqu
	 JjxOxx1HQbo9IAJPSEydVxvKMLjkBvZD0xK1GfOtlWvCLeVUTGpmHB/GubVk83nCYGAIC
	 vV+3ea0nW76BdlNIttuTFbzFA//vgK9eq4ipYjMHwb0TLWiMTAuvkZGx40mj8Ynn6P+jN
	 ouBmBt1TfAxhYtuFkFvPbJrM1aU9P3qsOoq2GNtj64HjB0MYTSTjd4K+kPeR+QpgA/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LnQVqHCQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3841C606A323
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LnQVqHCQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294151F000C9;
	Mon, 16 Nov 2026 23:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871095;
	bh=3o6w6cTgQbKbEe+Pv+SpFYeozeaFRdnSDhtRFY2hyho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LnQVqHCQgXWx32q+shtnpp5shS98ruako6410zt4i++yO0zC76N7raWdXt1LaE4bQ
	 G0WXvNl4MWu79LV4z4bk88qVCzewiX/FSKAS37o/1//kiB2ZMI54iR8/D7x5k2inDi
	 Rus8cjfn/N4I5VOZWT2XG7JoKqBeCk3XFK12vNARIEBFnd9FUrtDXtR6DhS01U0K3p
	 QF9c0woVPjmoTYrO+cQBTPZI/W0OrKgxu11Lms1UOx+V0JoaYP3kT7X2XWB+44U6XB
	 w1za1LhYqZf6vvn5RcFwa6uhH+Ub3Jse44u4qgrHaP+nYfQHVpfrZgEj+r38WrZvzx
	 6VxqvcsrhlZOg==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 48/59] xfs: validate logged local fork contents during recovery
Date: Tue, 17 Nov 2026 10:15:05 +1100
Message-ID: <20261116231707.3625263-49-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261116231707.3625263-1-dgc@kernel.org>
References: <20261116231707.3625263-1-dgc@kernel.org>
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

A local format fork carries a shortform directory, an extended attribute
structure or a symlink target directly in the inode. Recovery copied these into
the inode without inspecting them, so a corrupt shortform structure was replayed
as it stood.

Validate the contents of a logged local fork once the fork has been verified
against the core. The shortform directory and attribute verifiers are reused
directly as they already operate on the on-disk form. The logged symlink target
is validated by a recovery local helper because the shared verifier expects the
null terminated in-core form, which the logged target does not have.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_inode_item_recover.c | 53 +++++++++++++++++++++++++++++----
 1 file changed, 48 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 566b03d1fe03..a2001716eeca 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -24,6 +24,8 @@
 #include "xfs_ialloc.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
+#include "xfs_dir2_priv.h"
+#include "xfs_attr_leaf.h"
 #include "xfs_metafile.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_rtrmap_btree.h"
@@ -441,6 +443,45 @@ xlog_dinode_verify(
 	return NULL;
 }
 
+/*
+ * Verify a logged shortform symlink target. The logged target is the on-disk
+ * form, which is not null terminated, so this cannot use
+ * xfs_symlink_shortform_verify().
+ */
+static xfs_failaddr_t
+xlog_dinode_verify_symlink(
+	void			*sfp,
+	unsigned int		size)
+{
+	if (size == 0 || size > XFS_SYMLINK_MAXLEN)
+		return __this_address;
+
+	/* The target must not contain a null. */
+	if (memchr(sfp, 0, size))
+		return __this_address;
+
+	return NULL;
+}
+
+/*
+ * Verify the contents of a logged local format data fork. A directory holds a
+ * shortform directory, and a symlink holds its target. A regular file has no
+ * local format data fork.
+ */
+static xfs_failaddr_t
+xlog_dinode_verify_local_dfork(
+	struct xfs_mount		*mp,
+	struct xfs_log_dinode		*ldip,
+	void				*src,
+	unsigned int			size)
+{
+	if (S_ISDIR(ldip->di_mode))
+		return xfs_dir2_sf_verify(mp, src, size);
+	if (S_ISLNK(ldip->di_mode))
+		return xlog_dinode_verify_symlink(src, size);
+	return __this_address;
+}
+
 /*
  * Verify the logged data fork against the core and the fork region that carries
  * it. The core has already been verified, so the mode and fork offset can be
@@ -449,9 +490,9 @@ xlog_dinode_verify(
  * the fork was logged, the field logged for it must match that format, and the
  * region holding it must be the size the format header records. A local or
  * extents fork is copied verbatim into the inode fork, so it must also fit
- * within the space the fork offset leaves for it. A btree fork is logged in the
- * larger expanded form and compressed into the fork on replay, so it does not
- * get the fit check. The contents of the region are not inspected.
+ * within the space the fork offset leaves for it, and a local fork must hold
+ * valid contents. A btree fork is logged in the larger expanded form and
+ * compressed into the fork on replay, so it does not get the fit check.
  */
 static xfs_failaddr_t
 xlog_dinode_verify_dfork(
@@ -490,7 +531,8 @@ xlog_dinode_verify_dfork(
 			return __this_address;
 		if (ilfp->ilf_dsize > fork_size)
 			return __this_address;
-		break;
+		return xlog_dinode_verify_local_dfork(mp, ldip,
+				item->ri_buf[2].iov_base, ilfp->ilf_dsize);
 	case XFS_DINODE_FMT_EXTENTS:
 		if (field != XFS_ILOG_DEXT)
 			return __this_address;
@@ -547,7 +589,8 @@ xlog_dinode_verify_afork(
 			return __this_address;
 		if (ilfp->ilf_asize > fork_size)
 			return __this_address;
-		break;
+		return xfs_attr_shortform_verify(item->ri_buf[region].iov_base,
+				ilfp->ilf_asize);
 	case XFS_DINODE_FMT_EXTENTS:
 		if (field != XFS_ILOG_AEXT)
 			return __this_address;
-- 
2.55.0

