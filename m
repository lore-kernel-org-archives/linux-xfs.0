Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF4F79CC
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831334; cv=none; b=pJyYYWg/dZrkPHw3GlN8U5lNl4MuOQ9bxKf4L1oAsJQ5S3OvtwzVtB3dEarFi5TOmEw7X4G8TBNOKAzI7QaTMfb5nCk2p5Kiv/tKkpKy0thDV40SHrmS0+VVbxqC1QfOIOYG3fIGBitnEinz+CHdHn3AUbP/EbEx9xPE5E+6X+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831334; c=relaxed/simple;
	bh=vnW1wSFDA8PzfOnNDraDzQWpgWLUNknlm8EMliPtW9s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZUDlMv3hTi00J5TrKukJKfA/OrfygxTYctBt1qc1yRReFOYiWsPiFt0G8Hhk0CGxh6j/XH9wMPq7jFs88f4ixsSOORX9BPNSlz1slnsSwhJnrxMTnUp8K3orcJO5nsTJxguymKTfd5pMgT8cLPd+iGHEsMSQOR+v+sWIKY34XuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eFnaDCUD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eFnaDCUD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC5EC4CEC6;
	Wed,  2 Oct 2024 01:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831333;
	bh=vnW1wSFDA8PzfOnNDraDzQWpgWLUNknlm8EMliPtW9s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eFnaDCUD/i2icFIxvWjiZXt150LihPLHHfxP6o/gNK4UZCTxR573rCk70ekPbHiFr
	 iYwz2e7kODh7Nwi4IBRwkxKygXtTp0+V/epn9dsSUHs1smGNrFRj4GgPRjld+90/3e
	 TMjQVKc0TG1vmOirKdp0K8z5vgBMXeZlv72GJ1eC484airzEvPC1/ryoIQG1UqQcCY
	 JT1GQtExfxw5zhgf2U6Zd7tEhiB9N33PoIIHbLC+bDRnsV9So7Fn2Kenws7mWmomlF
	 qZuRoKarDRRbQqrcS5pSujT5N2JMmo+JfSMbMzDdGrCaAzo+F3KaxMnDENO6HFDOGf
	 WWR0Mu+Zy9yvg==
Date: Tue, 01 Oct 2024 18:08:53 -0700
Subject: [PATCH 04/64] xfs: hoist extent size helpers to libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783101840.4036371.922155491418114369.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: acdddbe168040372a8b6b9b5876b92b715322910

Move the extent size helpers to xfs_bmap.c in libxfs since they're used
there already.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_inode.h  |    7 +++++++
 libxfs/libxfs_priv.h |    2 --
 libxfs/xfs_bmap.c    |   42 ++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_bmap.h    |    3 +++
 4 files changed, 52 insertions(+), 2 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 9bbf37225..ec4eada81 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -345,6 +345,11 @@ static inline bool xfs_inode_has_bigrtalloc(struct xfs_inode *ip)
 	return XFS_IS_REALTIME_INODE(ip) && ip->i_mount->m_sb.sb_rextsize > 1;
 }
 
+static inline bool xfs_is_always_cow_inode(struct xfs_inode *ip)
+{
+	return false;
+}
+
 /* Always set the child's GID to this value, even if the parent is setgid. */
 #define CRED_FORCE_GID	(1U << 0)
 struct cred {
@@ -370,4 +375,6 @@ extern int	libxfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
 				uint, struct xfs_inode **);
 extern void	libxfs_irele(struct xfs_inode *ip);
 
+#define XFS_DEFAULT_COWEXTSZ_HINT	32
+
 #endif /* __XFS_INODE_H__ */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 5d1aa23c7..0bf0c54ac 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -468,8 +468,6 @@ xfs_buf_readahead(
 
 #define xfs_rotorstep				1
 #define xfs_bmap_rtalloc(a)			(-ENOSYS)
-#define xfs_get_extsz_hint(ip)			(0)
-#define xfs_get_cowextsz_hint(ip)		(0)
 #define xfs_inode_is_filestream(ip)		(0)
 #define xfs_filestream_lookup_ag(ip)		(0)
 #define xfs_filestream_new_ag(ip,ag)		(0)
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index e60d11470..befbe0b07 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -6448,3 +6448,45 @@ xfs_bmap_query_all(
 
 	return xfs_btree_query_all(cur, xfs_bmap_query_range_helper, &query);
 }
+
+/* Helper function to extract extent size hint from inode */
+xfs_extlen_t
+xfs_get_extsz_hint(
+	struct xfs_inode	*ip)
+{
+	/*
+	 * No point in aligning allocations if we need to COW to actually
+	 * write to them.
+	 */
+	if (xfs_is_always_cow_inode(ip))
+		return 0;
+	if ((ip->i_diflags & XFS_DIFLAG_EXTSIZE) && ip->i_extsize)
+		return ip->i_extsize;
+	if (XFS_IS_REALTIME_INODE(ip) &&
+	    ip->i_mount->m_sb.sb_rextsize > 1)
+		return ip->i_mount->m_sb.sb_rextsize;
+	return 0;
+}
+
+/*
+ * Helper function to extract CoW extent size hint from inode.
+ * Between the extent size hint and the CoW extent size hint, we
+ * return the greater of the two.  If the value is zero (automatic),
+ * use the default size.
+ */
+xfs_extlen_t
+xfs_get_cowextsz_hint(
+	struct xfs_inode	*ip)
+{
+	xfs_extlen_t		a, b;
+
+	a = 0;
+	if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
+		a = ip->i_cowextsize;
+	b = xfs_get_extsz_hint(ip);
+
+	a = max(a, b);
+	if (a == 0)
+		return XFS_DEFAULT_COWEXTSZ_HINT;
+	return a;
+}
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index 667b0c2b3..7592d46e9 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -296,4 +296,7 @@ typedef int (*xfs_bmap_query_range_fn)(
 int xfs_bmap_query_all(struct xfs_btree_cur *cur, xfs_bmap_query_range_fn fn,
 		void *priv);
 
+xfs_extlen_t	xfs_get_extsz_hint(struct xfs_inode *ip);
+xfs_extlen_t	xfs_get_cowextsz_hint(struct xfs_inode *ip);
+
 #endif	/* __XFS_BMAP_H__ */

