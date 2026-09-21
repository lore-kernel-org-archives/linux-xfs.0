Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB50965192;
	Mon, 21 Sep 2026 06:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789971332; cv=none; b=j+/8O0h3o9SDicVe6AP1cajqM41jgSzrvb6uZucRnmPveT+r3TL0kPTuuUxpLSI/oW4IdIpXO66eEDd0dUsXd6R/w9aARAEaTBwtVFV84magpLKpCPKhhrk1nZGd8vBM6eDXIgq8p+M+sUIONoO+KSIaASpEEkghlw/EVkmTNg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789971332; c=relaxed/simple;
	bh=fFV5hHyIi8t+GpVWJIhcSBO8DUXRqalEr2luJtNpfqA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jO28jkwlSKhUlN+rBLU0i7lt0rOjHYlnpfwcLGH/6cgGbr13vh2uZX5GzKL1lLtNc9N6qm1n6ClugAoJCkGg6pcMiAP7a6oYJdM+CE8G4FGNDl81P4gz/yfuwbscg63KWX/N2nV+cGGQl0E7U+8I77mrZfbSasciXgVd3YO2Fvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HIND4U9O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HIND4U9O"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 860591F000FF;
	Mon, 21 Sep 2026 06:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789971330;
	bh=b0eYBsSwjaMIK8HerpKx3mEIr0rA8D7rZY5AXg7C8/M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=HIND4U9OBiQ2lmeLkVX5s9O8oJq+ImixrAOsZfu+P+ZrvrUEdPZX+0tlusqFD5U/I
	 TwunbnLFuNBNSBbXT+n2Ruf61SEaaA8G3oNP8eR3c241PiSffjRMEbA3lyDknxYtlz
	 FENcAVGdjeAhFem3wg9BRjWaLVjWAUXwIitcbHr/U54qgxn9nB0iiEKk+IB8zKFQEI
	 qdULBGhKLQyFQmiTqYr0M1hV/Irc/O33K9VcjJgWb5/2LikTbNBCX1D9oIcWTRg6dQ
	 XEeaIWCH6RZ02YPKJm/3ehh2Bk8pqSWDNgoXNwCb2H6t6eUVKRS9RnXfS5Kf25L3Y+
	 bt5Dn79LRu4Xg==
Date: Sun, 20 Sep 2026 23:15:30 -0700
Subject: [PATCH 02/14] xfs: online quotacheck must dirty dquot if enforcement
 adjustments needed
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178996120594.181988.17443723006471773386.stgit@frogsfrogsfrogs>
In-Reply-To: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that we have no way to force xchk_commit_dquot to call
xfs_qm_adjust_dqenforcement if nothing else is wrong with the dquot.
Therefore, add a new predicate to force the dirty flag if the dquot has
zero limits and there are default limits; or if the grace period timer
needs adjusting.

Cc: <stable@vger.kernel.org> # v6.9
Fixes: 96ed2ae4a9b06b ("xfs: repair dquots based on live quotacheck results")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/quotacheck_repair.c |   51 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)


diff --git a/fs/xfs/scrub/quotacheck_repair.c b/fs/xfs/scrub/quotacheck_repair.c
index 48ee08df302a42..e2208510939f08 100644
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

