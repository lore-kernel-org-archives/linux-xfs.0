Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B6D3C09F8
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871346; cv=none; b=YHL+xRApfgtQHKcBceft2kefSqEd+xtzMCtsqdAx0S8kA0fWplaSz7svOzAzMP4MVs20ttqpX6C2wlXNKoB61gFCS+dQgqFJUGhYuZYh0g1qL5lYexQqmLukzxpUoG5jGBxnKECILBseYluFoVwM3nS6t1lB5WNFo7PQy+AbY/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871346; c=relaxed/simple;
	bh=fJhFY8Sar/pd97xgpAzpogFAr7horFCllam9+T/Q69M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+gxxE/jc9mrF6ojw8OaDXHn6dEYaRSHrsMLNO8jpokWN6lO+RJT8dwGrj7NkqXPSz/LudHyDMLyVAYvdDAdcbvSD2QY1B/OhWgvhXpInmALl+JBRr9Qjk9/Ki6xNrtt/rmuNQe6JMt1k+DBLg1QkuT+c0SL7oBrE5onjq2e+Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PMdniaAo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PMdniaAo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A641F00893;
	Tue, 13 Oct 2026 06:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871345;
	bh=sR9b6C/ZUiEd542+nfKwfNdFlmUr6sHmUrfB5B0q5rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PMdniaAoNPwblSk+8KPohgQ4lLz4XrocbO2MVm7T2xIdECSBSLrolwFJSVzw5ONx8
	 nCV5l5UPqaAcbucX892MwpPMGhq7weuQ7NlkFTI8jFd1WrjqIVWKX+IwAiAgZjIeWc
	 X6iZa3TzHQ+S5HKUoDk9n5VPCoHveAY1OlpKfFifdbR7kL6CYCnOuR2WE1Sv6dpof4
	 xDrIHkegfV5Rn/cXtlm26T4Ybs0uzsQ24AOE6irIHYDEJOH8l9KmblVOXkhMovQ5KF
	 hd/IOReWy11vRNuODNHKlKLjqbiYZmKVIhRZdnRP3DNe/yrh0DlaRHYA0JVzeTE8yj
	 NBtDNm4NePv9w==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 13/48] xfs: enforce zero length control records during recovery
Date: Tue, 13 Oct 2026 17:01:03 +1100
Message-ID: <20261013060204.3138690-14-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013060204.3138690-1-dgc@kernel.org>
References: <20261013060204.3138690-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Start and commit records only bracket a transaction and carry no data of
their own, but recovery only asserted this for start records and did not check
it for commit records, so a corrupt non-zero length on either was accepted on
production builds.

Enforce the zero length for both in the operation header flag validation and
drop the now redundant assert.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
---
 fs/xfs/xfs_log_recover.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index fd53b365a8a0..0ba3f4409d28 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2618,8 +2618,6 @@ xlog_recover_ophdr_to_trans(
 	if (!(ohead->oh_flags & XLOG_START_TRANS))
 		return NULL;
 
-	ASSERT(be32_to_cpu(ohead->oh_len) == 0);
-
 	/*
 	 * This is a new transaction so allocate a new recovery container to
 	 * hold the recovery ops that will follow.
@@ -2726,9 +2724,19 @@ xlog_recover_validate_ophdr(
 	 * stand alone.
 	 */
 	switch (ohead->oh_flags) {
-	case 0:
 	case XLOG_START_TRANS:
 	case XLOG_COMMIT_TRANS:
+		/*
+		 * Start and commit records only bracket a transaction and carry
+		 * no data of their own.
+		 */
+		if (len != 0) {
+			xfs_warn(log->l_mp, "%s: bad control record length 0x%x",
+				__func__, len);
+			return ERR_PTR(-EFSCORRUPTED);
+		}
+		break;
+	case 0:
 	case XLOG_CONTINUE_TRANS:
 	case XLOG_WAS_CONT_TRANS | XLOG_CONTINUE_TRANS:
 	case XLOG_WAS_CONT_TRANS | XLOG_END_TRANS:
-- 
2.55.0

