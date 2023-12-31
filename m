Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281CBBE47
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ifqNxaQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFBB0C433C7;
	Sun, 31 Dec 2023 20:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056039;
	bh=4BtqwoN7TfcXn/JRXkfHWnYOf9sFmHW4mTBuGRYR288=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ifqNxaQDAQQo5HzCTwRklwTFvXpiU0/IUW5xQedtK3q/i+eyEo2sTV0ToEWAYI1fi
	 NN8nfKW/dNi3IOk+KuIXd/oxc+d2xXWzFp4N4zQAu9iY1PZDNT8fg9ekBLbmHwxfA8
	 CQY3LFFYYBStyq6dx+3znJZb/JzWbs5U+x8NenslqjQv0brM754jvwF8Pste1rky8H
	 2vaFS0tcBn+KclIl1Qltl6jCX7wd9rQ2k92a+pP/Mzlm8Ga3K6Xlfjlgb344hbsSXC
	 I9bUmc9nNu77c6lLEY6RN1IMAIs7ZR4Iq8ognhGEt5VAEEViZ8rgBRFSJrXcvDxjmH
	 B3t7dAkoZ8/fQ==
Date: Sun, 31 Dec 2023 12:53:58 -0800
Subject: [PATCH 03/22] xfs: create a parent pointer walk function for
 scrubbers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404841796.1757392.12691168335602590612.stgit@frogsfrogsfrogs>
In-Reply-To: <170404841699.1757392.2057683072581072853.stgit@frogsfrogsfrogs>
References: <170404841699.1757392.2057683072581072853.stgit@frogsfrogsfrogs>
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

Build a parent pointer iteration function off of the existing xattr
walking code.  This will be used by subsequent patches.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/listxattr.c |   84 +++++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/scrub/listxattr.h |    9 +++++
 2 files changed, 88 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/scrub/listxattr.c b/fs/xfs/scrub/listxattr.c
index c8d7d7d723177..dc893f2cdc1c3 100644
--- a/fs/xfs/scrub/listxattr.c
+++ b/fs/xfs/scrub/listxattr.c
@@ -17,11 +17,46 @@
 #include "xfs_attr_leaf.h"
 #include "xfs_attr_sf.h"
 #include "xfs_trans.h"
+#include "xfs_parent.h"
 #include "scrub/scrub.h"
 #include "scrub/bitmap.h"
 #include "scrub/dab_bitmap.h"
 #include "scrub/listxattr.h"
 
+struct xchk_pptr_walk {
+	struct xfs_parent_name_irec	*pptr_buf;
+	xchk_pptr_fn			fn;
+	void				*priv;
+};
+
+/* Call the parent pointer callback if this xattr is a valid parent pointer. */
+STATIC int
+xchk_pptr_walk_attr(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip,
+	unsigned int		attr_flags,
+	const unsigned char	*name,
+	unsigned int		namelen,
+	const void		*value,
+	unsigned int		valuelen,
+	void			*priv)
+{
+	struct xchk_pptr_walk	*pw = priv;
+	const struct xfs_parent_name_rec *rec = (const void *)name;
+
+	/* Ignore anything that isn't a parent pointer. */
+	if (!(attr_flags & XFS_ATTR_PARENT))
+		return 0;
+
+	if (!xfs_parent_namecheck(sc->mp, rec, namelen, attr_flags))
+		return -EFSCORRUPTED;
+	if (!xfs_parent_valuecheck(sc->mp, value, valuelen))
+		return -EFSCORRUPTED;
+
+	xfs_parent_irec_from_disk(pw->pptr_buf, rec, value, valuelen);
+	return pw->fn(sc, ip, pw->pptr_buf, pw->priv);
+}
+
 /* Call a function for every entry in a shortform xattr structure. */
 STATIC int
 xchk_xattr_walk_sf(
@@ -37,9 +72,16 @@ xchk_xattr_walk_sf(
 
 	sf = (struct xfs_attr_shortform *)ip->i_af.if_u1.if_data;
 	for (i = 0, sfe = &sf->list[0]; i < sf->hdr.count; i++) {
-		error = attr_fn(sc, ip, sfe->flags, sfe->nameval, sfe->namelen,
-				&sfe->nameval[sfe->namelen], sfe->valuelen,
-				priv);
+		if (attr_fn == xchk_pptr_walk_attr)
+			error = xchk_pptr_walk_attr(sc, ip, sfe->flags,
+					sfe->nameval, sfe->namelen,
+					&sfe->nameval[sfe->namelen],
+					sfe->valuelen, priv);
+		else
+			error = attr_fn(sc, ip, sfe->flags,
+					sfe->nameval, sfe->namelen,
+					&sfe->nameval[sfe->namelen],
+					sfe->valuelen, priv);
 		if (error)
 			return error;
 
@@ -91,8 +133,12 @@ xchk_xattr_walk_leaf_entries(
 			valuelen = be32_to_cpu(name_rmt->valuelen);
 		}
 
-		error = attr_fn(sc, ip, entry->flags, name, namelen, value,
-				valuelen, priv);
+		if (attr_fn == xchk_pptr_walk_attr)
+			error = xchk_pptr_walk_attr(sc, ip, entry->flags, name,
+					namelen, value, valuelen, priv);
+		else
+			error = attr_fn(sc, ip, entry->flags, name, namelen,
+					value, valuelen, priv);
 		if (error)
 			return error;
 
@@ -308,3 +354,31 @@ xchk_xattr_walk(
 
 	return xchk_xattr_walk_node(sc, ip, attr_fn, priv);
 }
+
+/*
+ * Walk every parent pointer of this file.  The parent pointer will be
+ * formatted into the provided @pptr_buf, which is then passed to the callback
+ * function.
+ *
+ * The callback function must decide if an invalid parent_ino or invalid name
+ * should halt the parent pointer walk; the only validation done here is the
+ * structure of the xattrs themselves.
+ */
+int
+xchk_pptr_walk(
+	struct xfs_scrub		*sc,
+	struct xfs_inode		*ip,
+	xchk_pptr_fn			pptr_fn,
+	struct xfs_parent_name_irec	*pptr_buf,
+	void				*priv)
+{
+	struct xchk_pptr_walk		pw = {
+		.fn			= pptr_fn,
+		.pptr_buf		= pptr_buf,
+		.priv			= priv,
+	};
+
+	ASSERT(xfs_has_parent(sc->mp));
+
+	return xchk_xattr_walk(sc, ip, xchk_pptr_walk_attr, &pw);
+}
diff --git a/fs/xfs/scrub/listxattr.h b/fs/xfs/scrub/listxattr.h
index 48fe89d05946b..7e4bd3ae75e15 100644
--- a/fs/xfs/scrub/listxattr.h
+++ b/fs/xfs/scrub/listxattr.h
@@ -14,4 +14,13 @@ typedef int (*xchk_xattr_fn)(struct xfs_scrub *sc, struct xfs_inode *ip,
 int xchk_xattr_walk(struct xfs_scrub *sc, struct xfs_inode *ip,
 		xchk_xattr_fn attr_fn, void *priv);
 
+struct xfs_parent_name_irec;
+
+typedef int (*xchk_pptr_fn)(struct xfs_scrub *sc, struct xfs_inode *ip,
+		const struct xfs_parent_name_irec *pptr, void *priv);
+
+int xchk_pptr_walk(struct xfs_scrub *sc, struct xfs_inode *ip,
+		xchk_pptr_fn pptr_fn, struct xfs_parent_name_irec *pptr_buf,
+		void *priv);
+
 #endif /* __XFS_SCRUB_LISTXATTR_H__ */

