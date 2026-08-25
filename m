Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6AD355F49
	for <linux-xfs@vger.kernel.org>; Tue, 25 Aug 2026 05:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787636143; cv=none; b=kgXFU0XoGUc1w6ZWxsHn4shO9v7vgtTZGCQHPDF+b6bluDzITc1T4j6ptsfIUuzyYSpBLH38FNFlYjIRFcAaXs9UfLF99rWbhGlncqHDYaXZJhRr4blG3Wz6qwkWNOdcXERU54Wij9uTL23PrwMwbY5zIM/zGKZqt5yyLO5AoQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787636143; c=relaxed/simple;
	bh=Ohs4IQ93Y3J3Cg8qc3EgpJH/BybP+I3ZwzqKvw6A2HI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QeReJ06WE34dxFL/Ef3+KoecJVH8t+hrn0clSFkZo5JDI5LZr8+IhoT7gWuM1hkBvBYLAaofU+pihoxvXNArCwks6MII08vhhhqCU//8pTWmM/jxITATvUbm8Kab6auzoeaC2GFKpcDklowuCoHE6q5Kh4ffOxeVpndioI1MlIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IFf0uhoM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IFf0uhoM"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 064B81F000E9;
	Tue, 25 Aug 2026 05:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787636142;
	bh=P4j9wgdl4ucvhc6UlZXo6aSuHpnw6pfkAfKCGvLM1sk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=IFf0uhoMirk0cV6jMlHyGftnwvQ6mo1IqTXl+feyCmhtKbfNbBMwxiIqexipwwhli
	 1hnXBh4zYtifp6FDeRdNjJg7A0RzzZPtrsUHgqzarFtf+wHqNNjoXV9+RSAp53/qIW
	 /CCSqBLvDrnTZq7X6jjuP/aRjZNo9mRs1vzlOug6R0KhxCr5YV4L4Ckyakd0ixw7k6
	 XT0CSwx7t86McGc0Leq9B2pp3OTUQ7001ef/j2Ih7SQQYadL4cAMbkUc89tP1YT4pt
	 1MNvsS2QqvcPZ98a3+nPTImcRnSThhhMt6Hlcz7Vl2Y9E4ngXoz2iSl9i8oRzxWHrK
	 1tk1DOrh67ibw==
Date: Mon, 24 Aug 2026 22:35:41 -0700
Subject: [PATCH 5/6] xfs: handle reconnecting metadir subdirectories
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <178760940784.944084.16150563988327141422.stgit@frogsfrogsfrogs>
In-Reply-To: <178760940641.944084.17475223769703836830.stgit@frogsfrogsfrogs>
References: <178760940641.944084.17475223769703836830.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

A longstanding weakness of the metapath repair code is that it can only
reattach non-directories to the metadata directory tree.  Let's fix that


Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/metapath.c |   76 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 75 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
index 9f44c82910eaef..3e59ebbe1bcf32 100644
--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -23,6 +23,7 @@
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_rtrefcount_btree.h"
+#include "xfs_ag.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -348,12 +349,78 @@ xchk_metapath(
 }
 
 #ifdef CONFIG_XFS_ONLINE_REPAIR
+/*
+ * Given a directory @dp, an existing inode @ip, and a @name, link @ip into @dp
+ * under the given @name.
+ */
+static int
+xrep_metadir_add_child(
+	struct xchk_metapath	*mpath,
+	xfs_ino_t		old_dotdot)
+{
+	struct xfs_trans	*tp = mpath->sc->tp;
+	struct xfs_dir_update	*du = &mpath->du;
+	struct xfs_inode	*dp = du->dp;
+	const struct xfs_name	*name = du->name;
+	struct xfs_inode	*ip = du->ip;
+	struct xfs_mount	*mp = tp->t_mountp;
+	const unsigned int	resblks = mpath->link_resblks;
+	int			error;
+
+	/*
+	 * The metadata file shouldn't be on the unlinked list, but we'll fix
+	 * it if that is the case.
+	 */
+	if (VFS_I(ip)->i_nlink == 0) {
+		struct xfs_perag	*pag;
+
+		pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, I_INO(ip)));
+		error = xfs_iunlink_remove(tp, pag, ip);
+		xfs_perag_put(pag);
+		if (error)
+			return error;
+	}
+
+	error = xfs_dir_createname(tp, dp, name, I_INO(ip), resblks);
+	if (error)
+		return error;
+
+	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
+
+	xfs_bumplink(tp, ip);
+
+	/* update dotdot entry in child */
+	if (S_ISDIR(VFS_I(ip)->i_mode)) {
+		xfs_bumplink(tp, dp);
+
+		/* Replace the dotdot entry in the child */
+		if (old_dotdot != I_INO(dp)) {
+			error = xfs_dir_replace(tp, ip, &xfs_name_dotdot,
+					I_INO(dp), resblks);
+			if (error)
+				return error;
+		}
+	}
+
+	/* Update the child's parent pointer */
+	if (du->ppargs) {
+		error = xfs_parent_addname(tp, du->ppargs, dp, name, ip);
+		if (error)
+			return error;
+	}
+
+	xfs_dir_update_hook(dp, ip, 1, name);
+	return 0;
+}
+
 /* Create the dirent represented by the final component of the path. */
 STATIC int
 xrep_metapath_link(
 	struct xchk_metapath	*mpath)
 {
 	struct xfs_scrub	*sc = mpath->sc;
+	xfs_ino_t		old_dotdot = NULLFSINO;
+	int			error;
 
 	mpath->du.dp = mpath->dp;
 	mpath->du.name = &mpath->xname;
@@ -366,7 +433,14 @@ xrep_metapath_link(
 
 	trace_xrep_metapath_link(sc, mpath->path, mpath->dp, I_INO(sc->ip));
 
-	return xfs_dir_add_child(sc->tp, mpath->link_resblks, &mpath->du);
+	if (S_ISDIR(VFS_I(sc->ip)->i_mode)) {
+		error = xchk_dir_lookup(sc, sc->ip, &xfs_name_dotdot,
+				&old_dotdot);
+		if (error && error != -ENOENT)
+			return error;
+	}
+
+	return xrep_metadir_add_child(mpath, old_dotdot);
 }
 
 /* Remove the dirent at the final component of the path. */

