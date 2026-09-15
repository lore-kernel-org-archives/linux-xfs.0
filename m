Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9A7378D9A;
	Tue, 15 Sep 2026 05:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789450627; cv=none; b=M8Hy/KyaUz6rTvU+WsQoQ4cQYZ6ZKDORzu680+ag6zewbaTaTFYRXlzCaKLoBvM7rfB1Qb3PruAb8a8A7w2RTX+ku7FknwC5YG8bRSaB3Tk7FI14KrS+OPsFeFU/2A65psjBSt6Gizg9tGtjnJVSVX88UOYFS0t0TELFwq+0Mvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789450627; c=relaxed/simple;
	bh=/vQ7sVJ3sFo6qDQkpKfoTTsNcZB+YGKNcHhCMJCr+2A=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PCVg1fZhWIC+Twnb7+zX/sHiW5sp3s/YR70rRylylJSlfIRhxT9kblygsZetaI5OdDvU/zV8cxXJtwjSW9B3mRA72JaRZl0ywuH+38chyjKe7e7+UIcg4i8dnGSLFsWEpox4aqg1Iyuux4IKFokmvwwhrA/x/6fuqBY1DmFyEqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NDcUZ33t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NDcUZ33t"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 848BB1F000FF;
	Tue, 15 Sep 2026 05:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789450625;
	bh=OkBJhRn3CdkayIFSQ7PuegyBZ5FFSbq8U3HcZceG82o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=NDcUZ33teAKNp19kEopj0sw4ASKiBmYM+AoS1wiC/mk2KgknlvULbiSBPwn+Sd8z5
	 3ctl+shULKp0ta8hbn/stTCWtVlxnQZqRMHxIbIWUu+rRw9X+ebL76CoVS5V3j4Ddl
	 eVOrx19UNb1EoiyyclcWMCKvzBdg3gZKsci3ViiHNOrtQNNDpEzem0DCClF830Iwel
	 EOLDq4ysLjl3kP3FTzqOaLMzg8vOAHX00evGbec9G+U3AwbFkAFeRWwsqI2+C/uxCW
	 uBe57pfrrYWzGKk8F10wMLAUnFusNQLZd9bSxTR/W63lCc9zHrqXhOHdu3gz8ja+62
	 NlCnCdnQX5rbw==
Date: Mon, 14 Sep 2026 22:37:05 -0700
Subject: [PATCH 02/11] xfs: call xfs_dquot_set_prealloc_limits if we installed
 default rtb limits
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178945048543.3061055.4920055292209877451.stgit@frogsfrogsfrogs>
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

Now that we have quotas for the realtime volume, we also have
precomputed watermark limits for the realtime block counts.  These
precomputations should be done any time we change the rtb limits, which
means that xfs_qm_adjust_dqlimits needs to ensure that if we installed
a default rtb limit.

Cc: <stable@vger.kernel.org> # v6.13
Fixes: 5dd70852b03901 ("xfs: create quota preallocation watermarks for realtime quota")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_dquot.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index b4f6c594808ce9..e696ee36c2e8d2 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -139,10 +139,14 @@ xfs_qm_adjust_dqlimits(
 		dq->q_ino.softlimit = defq->ino.soft;
 	if (!dq->q_ino.hardlimit)
 		dq->q_ino.hardlimit = defq->ino.hard;
-	if (!dq->q_rtb.softlimit)
+	if (!dq->q_rtb.softlimit) {
 		dq->q_rtb.softlimit = defq->rtb.soft;
-	if (!dq->q_rtb.hardlimit)
+		prealloc = 1;
+	}
+	if (!dq->q_rtb.hardlimit) {
 		dq->q_rtb.hardlimit = defq->rtb.hard;
+		prealloc = 1;
+	}
 
 	if (prealloc)
 		xfs_dquot_set_prealloc_limits(dq);

