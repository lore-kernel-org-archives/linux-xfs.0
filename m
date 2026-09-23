Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43033BB13A;
	Wed, 23 Sep 2026 05:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790143074; cv=none; b=u8FIrP88mbxNtFh4fUmd3nAakF1tCEftY8nL4M/ok1R4Ab0wua7QiiqyQsWl1eubLsvbgJmGpk3CoEoXSmsV1WL6ykaMO3AKoVQHhkMQ+wNCTCrxBI+DIrPXWMtbivSu2parFh0rFj6Jk6E0d6NEvSA21W0fCP6RiWNSI2WJjjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790143074; c=relaxed/simple;
	bh=TEm+BrbfN3kZGzki0wJ5BYJ2ZlWOGyANYHFdjcT6JDs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WrY9kSQi09oUaSE2/nl3v7bXzP7KBWFwN1e/9PYukJoJrwNfnZwExfWZscEVuWo3LYuYbzHlnANZH+9UA5otedfv5hMK9QlJCxKuURimsNkCVdqhNdziW/dLuAlVQVtDg3zLQN3iMlf64InSpMh89v5lSYJki8DU2cJJr8wMfBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KhCJyAvB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KhCJyAvB"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7C96E1F000FF;
	Wed, 23 Sep 2026 05:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790143073;
	bh=1ZyRvdpRTGSkXLn2ypCsJm2RLkWsXI/F8nJhw+Vv+WI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=KhCJyAvBdYv3YWCXfa2Wn1vTvpYbiyps9jLhsxjLTkYYCM3hiZZ21wYQC8ve2EotE
	 iD8rS/1yVNaWos9TAloI/VKRNYnPu77AlTsrsTrYBfg1GKKaIWQQhpHMqJ5wdb9Hin
	 70IyAKQUY18MiydeN7pWV6oXlF3w8HGSVzPsj9ZzJ6g10wfaQWjCEDSRb9LnUDocNE
	 Bucc0uM9xOyDMp4AqtUx30ttFy45O7cbDvPbw+cw1popIUgeEJJHPBiIde0lNu7Nqa
	 WpXAW4jr5+E+RvOwd2FVcNvXYdzzuSVQAM+a0i+MHnw0NsihXzV9n5vby/aDXUymZB
	 srfIgObhL2A+A==
Date: Tue, 22 Sep 2026 22:57:53 -0700
Subject: [PATCH 02/13] xfs: online quotacheck must dirty dquot if enforcement
 adjustments needed
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179014158972.1874904.13898834358517388792.stgit@frogsfrogsfrogs>
In-Reply-To: <179014158847.1874904.13591868745136552281.stgit@frogsfrogsfrogs>
References: <179014158847.1874904.13591868745136552281.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/quotacheck_repair.c |   51 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)


diff --git a/fs/xfs/scrub/quotacheck_repair.c b/fs/xfs/scrub/quotacheck_repair.c
index 48ee08df302a42..b8334edf380c7f 100644
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
+		if (!res->timer)
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

