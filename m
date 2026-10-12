Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F8A49B5C2;
	Mon, 12 Oct 2026 15:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791818484; cv=none; b=KETqQvn7Ut2r+6NmJQN575oRrAW7KXHrObECjRTQABWrujyjFRMFkiBLDQ/y+g41KucJfTSnRVlSNDJkPNdHNaoEzIfIwFJ77hBJf3N42/TRWJow9HnSO/L0hBGEL4sTMaVhKyTTmUn2Ro5BUrSzCKhxvGIoAS8EYn9qSnPxanc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791818484; c=relaxed/simple;
	bh=rS3tGaGeVrkDQDZ5oKdrVd3+z9uUQmw0zWkImlu2Mu4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lmhfu8T6GBbwDd3G1TOpac/slnbygg3K+CVHcnjiSnB/0mLAON8SUm4E2r//SUOqTne3FyDzA0RGeMzYA8Sl3o7WnZ4SXTteoBSd7DryMpQEvoOusx4SN4Te6hxcl9jR5DFmuZT0iyY9j/MTZiQ/dnJ6iu2vdGSilnwXjH7C5DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DHxF91Ig; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DHxF91Ig"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 14AE11F0089B;
	Mon, 12 Oct 2026 15:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791818483;
	bh=yoRU35ofAlISQ8366KBLDrljIPdstdkY5b8BUQoIKkI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=DHxF91Ig0FeUyeUbtVR+uzJH2mfiFdudnpL5edujs1AVsE1LfWjENrBCjvDxiFMJb
	 QrVZnyG2C1ZN9sZjlj2ZmnCTQDNebDhmR7nhM0dR1C03Z1fOCgeSZiZRE2qxOfNlSl
	 d6v5ms9l7siNDW5ZFwrFZu6N0Tq5M301IvgH16C1ZQsAgteIN9vrrI5SJuE8N1wzja
	 wczJtQmT+AZMKJwtWQFYsihRbVX93b6aMzyCZs2p4jHJ80j3LwdnHooLzsXZsgQ2jh
	 9UkGkSygIXHX5RKN3rJm8qZsIyTfzPP4yW0YoQ5Fw2Ibi+67jEAGGWJ7DzkksulYZV
	 hhWcVkv52RnHw==
Date: Mon, 12 Oct 2026 08:21:22 -0700
Subject: [PATCH 04/13] xfs: reattach dquots after changing inode ids
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179181839333.1417179.6117893372435753458.stgit@frogsfrogsfrogs>
In-Reply-To: <179181839163.1417179.9019753534701755931.stgit@frogsfrogsfrogs>
References: <179181839163.1417179.9019753534701755931.stgit@frogsfrogsfrogs>
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
 fs/xfs/scrub/inode_repair.c |  133 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 132 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 5ecccc75af2500..5b5116adcbf5e4 100644
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
@@ -1757,6 +1759,20 @@ xrep_inode_ids(
 
 	trace_xrep_inode_ids(sc);
 
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
+
 	if (!uid_valid(VFS_I(sc->ip)->i_uid)) {
 		i_uid_write(VFS_I(sc->ip), 0);
 		dirty = true;
@@ -2066,6 +2082,113 @@ xrep_inode_unlinked(
 	return 0;
 }
 
+#ifdef CONFIG_XFS_QUOTA
+static inline bool
+xrep_inode_need_reset_dquots(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_inode	*ip = sc->ip;
+
+	if (!XFS_IS_QUOTA_ON(mp))
+		return false;
+	if (xfs_is_quota_inode(&mp->m_sb, I_INO(ip)))
+		return false;
+	if (xfs_is_metadir_inode(ip))
+		return false;
+
+	if (XFS_IS_UQUOTA_ON(sc->mp) &&
+	    (!ip->i_udquot || ip->i_udquot->q_id != i_uid_read(VFS_I(ip))))
+		return true;
+	if (XFS_IS_GQUOTA_ON(sc->mp) &&
+	    (!ip->i_gdquot || ip->i_gdquot->q_id != i_gid_read(VFS_I(ip))))
+		return true;
+	if (XFS_IS_PQUOTA_ON(sc->mp) &&
+	    (!ip->i_pdquot || ip->i_pdquot->q_id != ip->i_projid))
+		return true;
+
+	return false;
+}
+
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
+# define xrep_inode_need_reset_dquots(sc)	(false)
+# define xrep_inode_reset_dquots(sc)		(0)
+#endif
+
 /* Repair an inode's fields. */
 int
 xrep_inode(
@@ -2120,5 +2243,13 @@ xrep_inode(
 	if (error)
 		return error;
 
-	return xrep_defer_finish(sc);
+	error = xrep_defer_finish(sc);
+	if (error)
+		return error;
+
+	/* Must come last */
+	if (xrep_inode_need_reset_dquots(sc))
+		return xrep_inode_reset_dquots(sc);
+
+	return 0;
 }

