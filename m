Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AAB3955CF
	for <linux-xfs@vger.kernel.org>; Wed, 23 Sep 2026 06:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790143309; cv=none; b=LANvc2PBMZ0ODBmm4mutMcHUG2Uq5qCcGhiaiEyL7v0vFMiTuWjTt7sEMDM/a4KRUw7QPAT9CWfnIzelJHGOJ0CcnTRksxgJg2V8JLqhZCNaUpnYsV4TSyQKsX9VClNMg7L2uZF6lgCdWi+8oC+tkVOL7/L+lCSY9ijhxUpvHKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790143309; c=relaxed/simple;
	bh=/5CDBlM+iMcgJkyogjU3AYVwIJgGx9l0S10qXI40CZw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DH6HqJvpmvwJBhcox2iDb6XFK11KHbfYG9GKBwQNTCl/zj5L81yQIgX7JR2lhWlnPYsLNQdB1vajpWhFaoibrL7/QCQwN7w/2Tl7m63sCZHMQshwWGAC96YfBm7jcoPQ4ppVBZjWQyjhyW2Ts8qBSio45VND31A9Tjkrchn9CL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X+jJkcqg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X+jJkcqg"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BA8221F000FF;
	Wed, 23 Sep 2026 06:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790143307;
	bh=1li4J6CXZTRgOPA0N3Z3HKnm1JWffdg5sb6n5Ij2DRw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=X+jJkcqgVN/vmTiTMGB8Ox2a4TBNQWzk98HCILy8Fx3alhY8AvMLHOI9UObpOLJPv
	 rZfKLBcJvPL9evntnINrTmFhMnvW37iGOpIziSXBCaw/5oSO4uB2lQ2B+OOMu3En2r
	 nJ2kr5mVPukg/Jnup7wLFGeP6AcrN+yDa1ECT1RJv0BoLuxx3PVMpXjqEWuAXVkKSz
	 /E8gntr5C0pLMFkFiYRq77jSrBvFUrTSwquel2ZqbOU1WO9jldHrccMk6exZrIPBQ9
	 Xmvqb294pb0AVqql7F2joqfCZR+0OtDUeaKl916Js1RspexL27wSLv2kPEPSL0hsh8
	 t9k993u+npYGg==
Date: Tue, 22 Sep 2026 23:01:47 -0700
Subject: [PATCH 04/12] xfs: reinitialize dquot block if non-first dquot can't
 load
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <179014159628.1875436.12664781946205413707.stgit@frogsfrogsfrogs>
In-Reply-To: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
References: <179014159469.1875436.5857342164999236687.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that the early exit logic in xrep_quota_block is defective
because it only looks in the first ondisk dquot for corruption that
would prevent dquots from loading.  We need to scan all the dquots in
the block, not just the first one.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/quota_repair.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index 89f7ea4f92ef4a..dbbeb858c13c4c 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -294,7 +294,6 @@ xrep_quota_block(
 	xfs_dqid_t		id)
 {
 	struct xfs_dqblk	*dqblk;
-	struct xfs_disk_dquot	*ddq;
 	struct xfs_quotainfo	*qi = sc->mp->m_quotainfo;
 	struct xfs_def_quota	*defq = xfs_get_defquota(qi, dqtype);
 	struct xfs_buf		*bp = NULL;
@@ -316,14 +315,21 @@ xrep_quota_block(
 		break;
 	case 0:
 		dqblk = bp->b_addr;
-		ddq = &dqblk[0].dd_diskdq;
+		error = 0;
 
 		/*
 		 * If there's nothing that would impede a dqiterate, we're
 		 * done.
 		 */
-		if ((ddq->d_type & XFS_DQTYPE_REC_MASK) == dqtype &&
-		    id == be32_to_cpu(ddq->d_id)) {
+		for (i = 0; i < qi->qi_dqperchunk; i++, dqblk++) {
+			struct xfs_disk_dquot	*ddq = &dqblk->dd_diskdq;
+
+			if ((ddq->d_type & XFS_DQTYPE_REC_MASK) != dqtype ||
+			    id + i != be32_to_cpu(ddq->d_id))
+				error++;
+		}
+
+		if (!error) {
 			xfs_trans_brelse(sc->tp, bp);
 			return 0;
 		}
@@ -336,7 +342,7 @@ xrep_quota_block(
 	dqblk = bp->b_addr;
 	bp->b_ops = &xfs_dquot_buf_ops;
 	for (i = 0; i < qi->qi_dqperchunk; i++, dqblk++) {
-		ddq = &dqblk->dd_diskdq;
+		struct xfs_disk_dquot	*ddq = &dqblk->dd_diskdq;
 
 		trace_xrep_disk_dquot(sc->mp, dqtype, id + i);
 

