Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B104BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M+5T9012"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C9BC433C7;
	Sun, 31 Dec 2023 20:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056320;
	bh=U+Im2sCPPHjfihruMxiNWQy+Y5fWU3ngHV97IGLHMI8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=M+5T9012464MV8Xhx7/RTrjo9tf9fU3bimlpPLvWrhGWd043IUszjiUImnVVl/HX8
	 6eH/7MdiFqsMQXMSvwR0oqwBuy4llSKAq8DE7APbD4wVbQGjRejNo/nAxZYOaIFihT
	 d9dwas03h0xYOhqOto+nGvdit6b9qJoJqt/YahvP8eZ38BUAXNAOlQ9vpAMFTWZSHG
	 Sr69Yt0oTaL05VHtoEgaZBI1ZguDlpt6/kNShYO5s9vro8P4TdRbrWRGxvtyjO5a26
	 RH9iy0Xodxpki0/E3Fx4GTh0r2Poh6pKJemHP2s4u+iWxlpHoH2V0X31jEdsUaNace
	 cCkQfAi8YFwJw==
Date: Sun, 31 Dec 2023 12:58:40 -0800
Subject: [PATCH 21/22] xfs: repair link count of nondirectories after
 rebuilding parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404842085.1757392.9649595192868451417.stgit@frogsfrogsfrogs>
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

Since the parent pointer scrubber does not exhaustively search the
filesystem for missing parent pointers, it doesn't have a good way to
determine that there are pointers missing from an otherwise uncorrupt
xattr structure.  Instead, for nondirectories it employs a heuristic of
comparing the file link count to the number of parent pointers found.

However, we don't want this heuristic flagging a false corruption after
a repair has actually scanned the entire filesystem to rebuild the
parent pointers.  Therefore, reset the file link count in this one case
because we actually know the correct link count.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/parent_repair.c |   97 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)


diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index 00e6735717a37..04ea0b05ed088 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -27,6 +27,7 @@
 #include "xfs_parent.h"
 #include "xfs_attr.h"
 #include "xfs_bmap.h"
+#include "xfs_ag.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -160,6 +161,9 @@ struct xrep_parent {
 	 * lost+found filename if we need to reparent the file.
 	 */
 	struct xfs_parent_name_irec pptr;
+
+	/* Number of parents we found after all other repairs */
+	unsigned long long	parents;
 };
 
 struct xrep_parent_xattr {
@@ -1381,6 +1385,92 @@ xrep_parent_rebuild_tree(
 	return 0;
 }
 
+/* Count the number of parent pointers. */
+STATIC int
+xrep_parent_count_pptr(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip,
+	const struct xfs_parent_name_irec *pptr,
+	void			*priv)
+{
+	struct xrep_parent	*rp = priv;
+
+	if (!xfs_parent_verify_irec(sc->mp, pptr))
+		return -EFSCORRUPTED;
+
+	rp->parents++;
+	return 0;
+}
+
+/*
+ * After all parent pointer rebuilding and adoption activity completes, reset
+ * the link count of this nondirectory, having scanned the fs to rebuild all
+ * parent pointers.
+ */
+STATIC int
+xrep_parent_set_nondir_nlink(
+	struct xrep_parent	*rp)
+{
+	struct xfs_scrub	*sc = rp->sc;
+	struct xfs_inode	*ip = sc->ip;
+	struct xfs_perag	*pag;
+	bool			joined = false;
+	int			error;
+
+	/* Count parent pointers so we can reset the file link count. */
+	rp->parents = 0;
+	error = xchk_pptr_walk(sc, ip, xrep_parent_count_pptr, &rp->pptr, rp);
+	if (error)
+		return error;
+
+	if (rp->parents > 0 && xfs_inode_on_unlinked_list(ip)) {
+		xfs_trans_ijoin(sc->tp, sc->ip, 0);
+		joined = true;
+
+		/*
+		 * The file is on the unlinked list but we found parents.
+		 * Remove the file from the unlinked list.
+		 */
+		pag = xfs_perag_get(sc->mp, XFS_INO_TO_AGNO(sc->mp, ip->i_ino));
+		if (!pag) {
+			ASSERT(0);
+			return -EFSCORRUPTED;
+		}
+
+		error = xfs_iunlink_remove(sc->tp, pag, ip);
+		xfs_perag_put(pag);
+		if (error)
+			return error;
+	} else if (rp->parents == 0 && !xfs_inode_on_unlinked_list(ip)) {
+		xfs_trans_ijoin(sc->tp, sc->ip, 0);
+		joined = true;
+
+		/*
+		 * The file is not on the unlinked list but we found no
+		 * parents.  Add the file to the unlinked list.
+		 */
+		error = xfs_iunlink(sc->tp, ip);
+		if (error)
+			return error;
+	}
+
+	/* Set the correct link count. */
+	if (VFS_I(ip)->i_nlink != rp->parents) {
+		if (!joined) {
+			xfs_trans_ijoin(sc->tp, sc->ip, 0);
+			joined = true;
+		}
+
+		set_nlink(VFS_I(ip), min_t(unsigned long long, rp->parents,
+					   XFS_NLINK_PINNED));
+	}
+
+	/* Log the inode to keep it moving forward if we dirtied anything. */
+	if (joined)
+		xfs_trans_log_inode(sc->tp, ip, XFS_ILOG_CORE);
+	return 0;
+}
+
 /* Set up the filesystem scan so we can look for parents. */
 STATIC int
 xrep_parent_setup_scan(
@@ -1505,6 +1595,13 @@ xrep_parent(
 	error = xrep_parent_rebuild_tree(rp);
 	if (error)
 		goto out_teardown;
+	if (xfs_has_parent(sc->mp) && !S_ISDIR(VFS_I(sc->ip)->i_mode)) {
+		error = xrep_parent_set_nondir_nlink(rp);
+		if (error)
+			goto out_teardown;
+	}
+
+	error = xrep_defer_finish(sc);
 
 out_teardown:
 	xrep_parent_teardown(rp);

