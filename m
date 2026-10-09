Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140E542AFBB;
	Fri,  9 Oct 2026 06:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791526554; cv=none; b=HxpQvl9o/9aogyfL6gFnwk82w+GKM7H3Hsj2iPPW9mjkB3JRMoPz2vkqjcgftbADkNyWMqpXkd9N6lXvNPWfqsL8qzEXA6DPoJl/9H5U3dvee24ara7+AnlppBbwTSb0IEb3G9WVksUN42OtO8xySE9vAi9qYK76OA0zEalOf8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791526554; c=relaxed/simple;
	bh=dbYhrW3s5XFQ3vexEiGgV1SsRSzqPU0SitoyNnJ/7K8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MN/HHby1eWo9/Vic3wK+hwBcQTtLc93maAo/SzGk4+GWWDnXt3aY46R9d8UUsbY1pnjnkZPX1+GF0X3O+JtO0JH1PwCXiljajdffbWyPado9VDi/lZC6EQwsGNQ0cZgVA7+jLp6d9I9KgFrEEdyG5yeuTQJYalWmXilJjZfl5fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WbJioD51; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WbJioD51"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AC39D1F000FF;
	Fri,  9 Oct 2026 06:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791526552;
	bh=+IeabfiFznrHk6tAwGPymB7HH+UrOHU+B7AiqP1jPao=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=WbJioD51kxFtsk/GaT29ZksjKAjdJbw435HWX9feURR+B+I8ZFVUrIpBrgFYBS7ED
	 PxqYEfx04HlUANMdnMerAwJ23ahOvIAL1TCRWD05ZeLwntmqSC7gQ7CKezUihQbHXh
	 ssYUrSoA0G3TszIrgq53xkEfVxKvchzB/1vaPK/VwcuBByLcALbYvcZoe0oPu5hrEg
	 jQVhGSB2RF5aexrlT34sMAYpyxEOk5BtUe2S+wetCpQ4WsuyGEvgxIQnjZ2xO5YATV
	 yYa16yGDOnuIiH14mYIDIA2CIkt/MshC1qoKOHVqel8GCSGWc+U7hg8QDWESitAId2
	 8lIuJIfTXyvyQ==
Date: Thu, 08 Oct 2026 23:15:52 -0700
Subject: [PATCH 04/13] xfs: reattach dquots after changing inode ids
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179151614707.3163896.4351468047280563575.stgit@frogsfrogsfrogs>
In-Reply-To: <179151614535.3163896.2744921556354655977.stgit@frogsfrogsfrogs>
References: <179151614535.3163896.2744921556354655977.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that xrep_inode_ids can change the user, group, or project
id of any given file.  When this happens, we need to detach any existing
incore dquot and attach the correct ones.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: 2d295fe65776d1 ("xfs: repair inode records")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/inode_repair.c |  136 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 128 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 5ecccc75af2500..26b31f8b90d6ff 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -41,6 +41,8 @@
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
 #include "xfs_rtrefcount_btree.h"
+#include "xfs_dquot_item.h"
+#include "xfs_dquot.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -134,6 +136,9 @@ struct xrep_inode {
 	/* Must we remove all access from this file? */
 	bool			zap_acls;
 
+	/* Do we need to reattach the dquots? */
+	bool			reset_dquots;
+
 	/* Inode scanner to see if we can find the ftype from dirents */
 	struct xchk_iscan	ftype_iscan;
 	uint8_t			alleged_ftype;
@@ -1748,6 +1753,32 @@ xrep_inode_blockcounts(
 	return 0;
 }
 
+static void
+xrep_inode_zap_dquot(
+	struct xfs_scrub	*sc,
+	xfs_dqtype_t		type)
+{
+#ifdef CONFIG_XFS_QUOTA
+	struct xrep_inode	*ri = sc->buf;
+
+	/*
+	 * We changed one of the file IDs, so we must detach the dquots to
+	 * prevent further changes from being accounted to them, and try to
+	 * attach the dquot for the new id to absorb any other block usage
+	 * changes.  We can't do that right now because the existing dquots
+	 * might be attached to the scrub transaction and we're in the middle
+	 * of fixing the inode, so we'll switch the incore dquot pointers
+	 * later.
+	 *
+	 * Schedule a quotacheck so the accounting discrepancies will get fixed
+	 * eventually.  We'll have to repeat this later when we do the actual
+	 * switch.
+	 */
+	xrep_force_quotacheck(sc, type);
+	ri->reset_dquots = true;
+#endif
+}
+
 /* Check for invalid uid/gid/prid. */
 STATIC void
 xrep_inode_ids(
@@ -1761,21 +1792,21 @@ xrep_inode_ids(
 		i_uid_write(VFS_I(sc->ip), 0);
 		dirty = true;
 		if (XFS_IS_UQUOTA_ON(sc->mp))
-			xrep_force_quotacheck(sc, XFS_DQTYPE_USER);
+			xrep_inode_zap_dquot(sc, XFS_DQTYPE_USER);
 	}
 
 	if (!gid_valid(VFS_I(sc->ip)->i_gid)) {
 		i_gid_write(VFS_I(sc->ip), 0);
 		dirty = true;
 		if (XFS_IS_GQUOTA_ON(sc->mp))
-			xrep_force_quotacheck(sc, XFS_DQTYPE_GROUP);
+			xrep_inode_zap_dquot(sc, XFS_DQTYPE_GROUP);
 	}
 
 	if (sc->ip->i_projid == -1U) {
 		sc->ip->i_projid = 0;
 		dirty = true;
 		if (XFS_IS_PQUOTA_ON(sc->mp))
-			xrep_force_quotacheck(sc, XFS_DQTYPE_PROJ);
+			xrep_inode_zap_dquot(sc, XFS_DQTYPE_PROJ);
 	}
 
 	/* strip setuid/setgid if we touched any of the ids */
@@ -2066,22 +2097,100 @@ xrep_inode_unlinked(
 	return 0;
 }
 
+#if CONFIG_XFS_QUOTA
+/* Switch dquot, return dqtype if we need quotacheck */
+static xfs_dqtype_t
+xrep_inode_switch_dquot(
+	struct xfs_scrub	*sc,
+	xfs_dqtype_t		type,
+	struct xfs_dquot	**dqp)
+{
+	xfs_dqtype_t		ret = 0;
+	xfs_dqid_t		id = xfs_qm_id_for_quotatype(sc->ip, type);
+
+	if (*dqp != NULL && (*dqp)->q_id != id) {
+		xfs_qm_dqrele(*dqp);
+		*dqp = NULL;
+	}
+
+	if (!*dqp) {
+		xfs_qm_dqget_inode(sc->ip, type, true, dqp);
+		ret = type;
+	}
+	return ret;
+}
+
+static int
+xrep_inode_reset_dquots(
+	struct xfs_scrub	*sc)
+{
+	xfs_dqtype_t		need = 0;
+	int			error;
+
+	/*
+	 * If we changed the file IDs, then we need to drop the transaction so
+	 * that we can detach the dquots and attach new ones.
+	 *
+	 * Commit the scrub transaction so that there are no dangling
+	 * references to any dquots that might get detached, and retain the
+	 * ILOCK, as required by the dqattach code.
+	 *
+	 * Note that dqattach can cycle the ILOCK when creating a new dquot, so
+	 * this must be the very last thing that the repair function does.
+	 */
+	error = xrep_trans_commit(sc);
+	if (error)
+		return error;
+
+	if (XFS_IS_UQUOTA_ON(sc->mp))
+		need |= xrep_inode_switch_dquot(sc, XFS_DQTYPE_USER,
+				&sc->ip->i_udquot);
+	if (XFS_IS_GQUOTA_ON(sc->mp))
+		need |= xrep_inode_switch_dquot(sc, XFS_DQTYPE_GROUP,
+				&sc->ip->i_gdquot);
+	if (XFS_IS_PQUOTA_ON(sc->mp))
+		need |= xrep_inode_switch_dquot(sc, XFS_DQTYPE_PROJ,
+				&sc->ip->i_pdquot);
+
+	xchk_iunlock(sc, XFS_ILOCK_EXCL);
+
+	/*
+	 * Now that we've updated the dquots, force quotacheck once again.
+	 * In theory we could be racing against a concurrent quotacheck.
+	 * Note that we can't hold the ILOCK when allocating a transaction.
+	 */
+	error = xchk_trans_alloc(sc, 0);
+	if (error)
+		return error;
+
+	if (need & XFS_DQTYPE_USER)
+		xrep_force_quotacheck(sc, XFS_DQTYPE_USER);
+	if (need & XFS_DQTYPE_GROUP)
+		xrep_force_quotacheck(sc, XFS_DQTYPE_GROUP);
+	if (need & XFS_DQTYPE_PROJ)
+		xrep_force_quotacheck(sc, XFS_DQTYPE_PROJ);
+
+	return 0;
+}
+#else
+# define xrep_inode_reset_dquots(sc)	(0)
+#endif
+
 /* Repair an inode's fields. */
 int
 xrep_inode(
 	struct xfs_scrub	*sc)
 {
+	struct xrep_inode	*ri = sc->buf;
 	int			error = 0;
 
+	ASSERT(ri != NULL);
+
 	/*
 	 * No inode?  That means we failed the _iget verifiers.  Repair all
 	 * the things that the inode verifiers care about, then retry _iget.
 	 */
 	if (!sc->ip) {
-		struct xrep_inode	*ri = sc->buf;
-
-		ASSERT(ri != NULL);
-
 		error = xrep_dinode_problems(ri);
 		if (error == -EBUSY) {
 			/*
@@ -2120,5 +2229,16 @@ xrep_inode(
 	if (error)
 		return error;
 
-	return xrep_defer_finish(sc);
+	error = xrep_defer_finish(sc);
+	if (error)
+		return error;
+
+	/* Must come last */
+	if (ri->reset_dquots) {
+		error = xrep_inode_reset_dquots(sc);
+		if (error)
+			return error;
+	}
+
+	return 0;
 }

