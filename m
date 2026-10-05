Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B96E30F7EA;
	Mon,  5 Oct 2026 05:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791179766; cv=none; b=po000tS1sVF4X0VoN21fq74UJHR278lsN42yOs0y6lTy6Uy92qP2ywQ1YOdbU8Gi1Tp3YLgNRXKYBENREvSK/bAk37koqnDfnYKF7P2FLekOhVUatsKXqk+73R6nF8saMwM5/JkBq7i7Z3hrH6TwjNUpJ2GuGTmOE77d01mKWXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791179766; c=relaxed/simple;
	bh=1iGfWDSDtzAAlEhQJTatGPg7K7SSU/ztKXrG1n3XClQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=de0Ua0ntq227XxG6+Uc8zU++CzQrwd3AXo8/LhnEz5Rofm0/FVWHDCwuOukqxwAKeMnrJON4Aako3ZoPZ+HnVgybM+BhyJJ/67oewWj6d4njnjRtuyw+2fFukJf1hSgrZmx74xBTjke3NtRmYTJfFLHb1b8GjpBgQG7CtRMm18Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LElpp5d3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LElpp5d3"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D49EC1F000FF;
	Mon,  5 Oct 2026 05:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791179765;
	bh=9NqO+b3jQQC2OJhmo0QVZR2frziOk6Vbex+8mWFSrVw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=LElpp5d3ivXASv2sbNbYKYPqhLqNLrUgmIMXnU/eTANOJoAJpI+UaaG/A5URgrMqz
	 11t27V6nZehEp37U/LLUmwvKG4Flkp29fZUjWnjv8pGym9ZeEqJWKP31ETmc5nFKRi
	 9dM0PcnKl+vXLyZjVoYg6UyI3pQom/hisNbYSIwAfZfnU7c3Ugs39WRDG0fWGaxlBR
	 sa+wswaGm/WWizd5uMVv592BLZyq6HhMQipoVbRloxFxOXXPNppcx/jz6knsLi40yx
	 CwH8GArXcM2EbGBiIkYQA8X7aGuwG9OnZ+AhGc+PZFXkV7zGhD6PNPK21MDdjj9rjn
	 1WRM9aDQrCufw==
Date: Sun, 04 Oct 2026 22:56:04 -0700
Subject: [PATCH 03/12] xfs: forcibly reset quota timers when upgrading to
 bigtime during repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179117965073.614350.15394600697823793893.stgit@frogsfrogsfrogs>
In-Reply-To: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
References: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If we decide to upgrade a dquot to BIGTIME as part of repairing it, we
should zero out the timer fields so that they are re-evaluated and reset
in bigtime format instead of letting through whatever was in there
before.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: a5b91555403e3a ("xfs: repair quotas")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/quota_repair.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index 0afce258d5d2e6..a37fcd3fb6629b 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -343,6 +343,8 @@ xrep_quota_block(
 	bp->b_ops = &xfs_dquot_buf_ops;
 	for (i = 0; i < qi->qi_dqperchunk; i++, dqblk++) {
 		struct xfs_disk_dquot	*ddq = &dqblk->dd_diskdq;
+		bool			was_bigtime =
+				!!(ddq->d_type & XFS_DQTYPE_BIGTIME);
 
 		trace_xrep_disk_dquot(sc->mp, dqtype, id + i);
 
@@ -351,8 +353,21 @@ xrep_quota_block(
 		ddq->d_type = dqtype;
 		ddq->d_id = cpu_to_be32(id + i);
 
-		if (xfs_has_bigtime(sc->mp) && ddq->d_id)
+		if (xfs_has_bigtime(sc->mp) && ddq->d_id) {
+			/*
+			 * If something was broken with this dquot and it was a
+			 * non-bigtime dquot, we'll grant everyone a fresh
+			 * grace period by zeroing the timer field rather than
+			 * try to interpret what might be garbage.
+			 */
+			if (!was_bigtime) {
+				ddq->d_btimer = 0;
+				ddq->d_itimer = 0;
+				ddq->d_rtbtimer = 0;
+			}
+
 			ddq->d_type |= XFS_DQTYPE_BIGTIME;
+		}
 
 		xrep_quota_fix_timer(sc->mp, ddq, ddq->d_blk_softlimit,
 				ddq->d_bcount, &ddq->d_btimer,

