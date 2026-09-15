Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC3843C7BC;
	Tue, 15 Sep 2026 05:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789450613; cv=none; b=LKOD/bf0zr3uBxaz9w5M9XW7OfHxKzPlyo/SSYjbMsiwlEkshmTgmaT2j4ZPwuvkJnUDLL41XE6UKm32TYQKknSls+pvT29wLafWiyc9jKJiUp91O6nK3cOr0vi0PRa+swRsFAUUsu6SOIAaqHOEwuRS860B1EEMt6eHwFqtzmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789450613; c=relaxed/simple;
	bh=c5EzPkwKgCMrN220K8KahQtG/YdAAuSyva6cfEyg+DQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fTT8bZ0sRprOEXX/+2vL57OUPAEGLr1BVophoeBTht+KkmSiGrSKC6e86/703smvDPe7JEQMe4N+3qqcd6USzQrAo8DuemslQATxuyp5kFmI2gKEUxl39AdufFI1YDTtW2rbU9+2nfoBDE9Qj2NZE+9wYZuFW3I4pHvo3fJXm9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R/G9ZM0k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R/G9ZM0k"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id F00481F00893;
	Tue, 15 Sep 2026 05:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789450610;
	bh=R54TGuUsU/vHxK2wZglsrILKdRKLyaS+3Bh/pF9ICWc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=R/G9ZM0kvdBT8wTwktT3Eo62wOtiDoJ7TkMzMnyfv08YMEerYTf5H3PpehcKUKuve
	 axLnEQuBj58F7RSfFqM2/XrwBClnLakYXPqc+hoEgtM+tfEucUu8LcoZy+QgOq2kIS
	 0e1nWjwkBmQrjGtgrklQY9uhxrRJWeO9gzeU3mCn9tkDf+iHEfrPQjEFBXSjQDlNmP
	 TTUraDr22Ua1B0LQbqW2Ftjm0swgPJwsf0CO/3DLa5GTgYP1dxJc4v7wJ3AT9rD0el
	 KXozANvj6hEdJHjIy7WC43m/PIMNTBk1MFuiXftEaooj9TyzXHQvR0mncfKAhRxQut
	 rnK1B58nNqFaA==
Date: Mon, 14 Sep 2026 22:36:49 -0700
Subject: [PATCH 01/11] xfs: always call xfs_qm_adjust_dqlimits during
 quotacheck repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178945048522.3061055.5283654279910692050.stgit@frogsfrogsfrogs>
In-Reply-To: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
References: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM notices that everywhere else in the kernel, a call to
xfs_qm_adjust_dqlimits precedes every call to xfs_qm_adjust_dqtimers.
In particular, mount-time quotacheck does this.

Looking at xfs_qm_adjust_dqlimits, that function is in charge of
conveying default limits to a dquot if that dquot's limits have been
zeroed.  That's quite possible in a repair, so let's follow what
everyone else does and set it.  This requires us to add a new predicate
to decide if xfs_qm_adjust_dqlimits is likely to reset any of the
dquot's limits, and to set the dirty flag to true if so.

A different LOLLM noticed that we have no way to force xchk_commit_dquot
to call xfs_qm_adjust_dqtimers, so pack that in at the same time.

Cc: <stable@vger.kernel.org> # v6.9
Fixes: 96ed2ae4a9b06b ("xfs: repair dquots based on live quotacheck results")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/quotacheck_repair.c |   55 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 54 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/quotacheck_repair.c b/fs/xfs/scrub/quotacheck_repair.c
index dbb522e1513b0b..c35982ba2e1721 100644
--- a/fs/xfs/scrub/quotacheck_repair.c
+++ b/fs/xfs/scrub/quotacheck_repair.c
@@ -39,6 +39,54 @@
  * dquot is locked.
  */
 
+static bool
+xqcheck_dqres_force_dirty(
+	const struct xfs_dquot_res	*res,
+	const struct xfs_quota_limits	*qlim)
+{
+	/* zero limits mean that we should set the default limits */
+	if (res->softlimit == 0 && qlim->soft != 0)
+		return true;
+	if (res->hardlimit == 0 && qlim->hard != 0)
+		return true;
+
+	/* do we need to adjust the timer setting? */
+	if ((res->softlimit && res->count > res->softlimit) ||
+	    (res->hardlimit && res->count > res->hardlimit)) {
+		if (res->timer == 0 && qlim->time != 0)
+			return true;
+	} else {
+		if (res->timer)
+			return true;
+	}
+
+	return false;
+}
+
+/* Decide if we need to adjust the dquot limits or timers */
+static bool
+xqcheck_dquot_force_dirty(
+	const struct xfs_dquot	*dq)
+{
+	struct xfs_quotainfo	*qi = dq->q_mount->m_quotainfo;
+	struct xfs_def_quota	*defq;
+
+	/* root dquot does not enforce limits */
+	if (dq->q_id == 0)
+		return false;
+
+	defq = xfs_get_defquota(qi, xfs_dquot_type(dq));
+
+	if (xqcheck_dqres_force_dirty(&dq->q_blk, &defq->blk))
+		return true;
+	if (xqcheck_dqres_force_dirty(&dq->q_ino, &defq->ino))
+		return true;
+	if (xqcheck_dqres_force_dirty(&dq->q_rtb, &defq->rtb))
+		return true;
+
+	return false;
+}
+
 /* Commit new counters to a dquot. */
 static int
 xqcheck_commit_dquot(
@@ -91,6 +139,9 @@ xqcheck_commit_dquot(
 		dirty = true;
 	}
 
+	if (!dirty && xqcheck_dquot_force_dirty(dq))
+		dirty = true;
+
 	xcdq.flags |= (XQCHECK_DQUOT_REPAIR_SCANNED | XQCHECK_DQUOT_WRITTEN);
 	error = xfarray_store(counts, dq->q_id, &xcdq);
 	if (error == -EFBIG) {
@@ -110,8 +161,10 @@ xqcheck_commit_dquot(
 
 	/* Commit the dirty dquot to disk. */
 	dq->q_flags |= XFS_DQFLAG_DIRTY;
-	if (dq->q_id)
+	if (dq->q_id) {
+		xfs_qm_adjust_dqlimits(dq);
 		xfs_qm_adjust_dqtimers(dq);
+	}
 	xfs_trans_log_dquot(xqc->sc->tp, dq);
 	return xrep_trans_commit(xqc->sc);
 

