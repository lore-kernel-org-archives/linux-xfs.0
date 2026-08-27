Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFA43C2D
	for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2026 05:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787808734; cv=none; b=VK84cWGmAXoi+y8v1QIvSJx2Pu8RtRwGpLKm6KUDBZu0OcbehBZ+3+ewSMchRY8iRAFAGNzhXHtjdICoi1nY38pJRiFm2FlsuTJ+4VC0GY+ObByrSEaG8riKD7UfcsHKwctIq9yfjN69ewfH+4ZPHFRypvZGhG69LZTluhgPGcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787808734; c=relaxed/simple;
	bh=zmCjHXFx6/7NXRKqZxyJjknsRshrum5Z412Y3mNYRQg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D2iZqc+0IK75wZE/k2gpJ0+gZq4Z1PhlYkC9l1DF1YrF9nLKw/FdwAX+jaL9om4ftiY1pbKNGNyzGsLq+iwn+rQU/w+Lr8WibA16QmyTIlqKn2vD3PC+VwLq7c/G5Rd9shCuI865myTYSxS1WStDHutegw9JMppB3359Ur7PaEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VgcMtkE7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VgcMtkE7"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C1C341F000E9;
	Thu, 27 Aug 2026 05:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787808732;
	bh=s/j/Y9YK/unGajAxmyCx5QQ4xGsIAc/2O72ov4H1hRc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=VgcMtkE7+y3iPPUJ/e0UQXjBtPgdJJSz0s4bj0wU5s5LZeqwiwEIYfmshptDrUacf
	 9YFan6Oki1bbNy2PUTn2VcQSi3mm5moipo+FpfkTctJVtUQajzJDhe+n+u/9V2sYTK
	 BweOsIYYJcFg9TyvIDTGIaOBOEZqtOXGNM0egTJAUB6tJqEZGNKWMLVsc4IqmkSngW
	 F3WmQUKJASRYX8cHOoUXHxlbh88++9gCQFhQgtD7u9mP7/k1J/vJQN0QTcdRRSbCOF
	 4CNrUIOTufjikVsY/2k/dbStHpruGpwLAGPVQiKG/fKxUJH7vBys8Ec/QaFSonC/pq
	 KxhFSzmBzUgiw==
Date: Wed, 26 Aug 2026 22:32:12 -0700
Subject: [PATCH 5/6] xfs: handle reconnecting metadir subdirectories
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <178780640282.3528187.11511654116002480699.stgit@frogsfrogsfrogs>
In-Reply-To: <178780640140.3528187.6786220801490019229.stgit@frogsfrogsfrogs>
References: <178780640140.3528187.6786220801490019229.stgit@frogsfrogsfrogs>
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
reattach non-directories to the metadata directory tree.  Let's fix
that by allowing reconnection of subdirectories.

Note that with the initial users of metadir (rtgroups and quota),
there's no way to mount a filesystem with broken /rtgroups or /quota
subdirectories, so this code won't be all that useful until something
adds deeper directory trees.  But we shouldn't leave a logic bomb for
those futures users wherein we get the link count wrong for a subdir.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/metapath.c |   83 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 82 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
index 9f44c82910eaef..a760523f40e6ff 100644
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
@@ -366,7 +433,21 @@ xrep_metapath_link(
 
 	trace_xrep_metapath_link(sc, mpath->path, mpath->dp, I_INO(sc->ip));
 
-	return xfs_dir_add_child(sc->tp, mpath->link_resblks, &mpath->du);
+	if (S_ISDIR(VFS_I(sc->ip)->i_mode)) {
+		error = xchk_dir_lookup(sc, sc->ip, &xfs_name_dotdot,
+				&old_dotdot);
+		if (error && error != -ENOENT)
+			return error;
+
+		/*
+		 * subdir didn't give us a dotdot entry, so we just give up
+		 * and let the repair get marked as failed.
+		 */
+		if (old_dotdot == NULLFSINO)
+			return 0;
+	}
+
+	return xrep_metadir_add_child(mpath, old_dotdot);
 }
 
 /* Remove the dirent at the final component of the path. */

