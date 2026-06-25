Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D040E28504F
	for <linux-xfs@vger.kernel.org>; Thu, 25 Jun 2026 22:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782428085; cv=none; b=lE8B0fk2/3x2iqnBmXV8du/RxcR71SNq6CWuouXOOWO55WFi6wA/yefucsWPVUlGv6GSCryZK51QkQO0ykmJCY/5a4WYMmP2oNhp2IQBeWem9aI2f5zM/QDBwOJsniMyfd9arbXP6FhIw14fNVVWpQ1VCeoQGWn/lBAHVZBtfVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782428085; c=relaxed/simple;
	bh=pSuYPuZNmGnQp1KUF0CKb3DbPZ8Kp9rJXi1BFQax10U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cWYsMxDUeXvAn2yK9egfpel1CloWIAC5kkPFKK6657ZNhpy07HFv8R9thTxxX616nBppwIxDwzDfzd8wSpTtiKySszp7cD+GvuqZ5E1k+mkrr9yiQYuPwcJiARHf3Rz6oOF0PLl0h+hGYX2k2gDnSl6Th5EzRDn3edWNOiRvvUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aENZz/WO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aENZz/WO"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A562E1F000E9;
	Thu, 25 Jun 2026 22:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782428084;
	bh=erOnIJTikOFbAQtrXywxOBrGd2gqDPPhsfzfesbN7w0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=aENZz/WOUId4JFmRxvzwyxJFJtcNTh28AXuNjO/9VHpFsbSu+r9TDZwAZZvOskYgy
	 BA9AiQMag+s1OAFXmYuklMvkcN6JHMXMJiM6DVvpvx0VqdBujw6s8FUfF/paB9DcRU
	 mGcn16ULliLjXgbvZ0zxSFM7VDKcQPr5pA5U30+J7mFcbdbz37zkQZptJrX9i/ErJr
	 KnYm/QJk7yjQYdeAlphxdd82ML8EIkpyuwSqEf+zhSuIaPXWTrETHhFkG5HF3RjkTp
	 ePHR/MLSplUUlU8qHvraT96wtha+xB+Tr4eeS9DxVCDblEH6HjPRIDl537QzrnrWzn
	 cJotbU3fapMag==
Date: Thu, 25 Jun 2026 15:54:44 -0700
Subject: [PATCH 2/8] xfs_scrub: don't flatten error numbers in
 read_verify_schedule_now
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178242801341.1981574.8647123518966483952.stgit@frogsfrogsfrogs>
In-Reply-To: <178242801268.1981574.8079691316092703702.stgit@frogsfrogsfrogs>
References: <178242801268.1981574.8079691316092703702.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Codex complains about using a bool variable to convey the results of
workqueue_add (which returns int) to rvp->runtime_error (which is
declared int).  As originally written in commit 2000470d5376e4, this
type inconsistency was a benign thinko because code branching decisions
were made based on whether or not workqueue_add returned nonzero but the
error itself was not preserved.  However, commit 5c657f1e5a9329 started
preserving the errors but didn't change the @ret declaration, so that's
where the bug was introduced.

Cc: <linux-xfs@vger.kernel.org> # v5.3.0
Fixes: 5c657f1e5a9329 ("xfs_scrub: fix handling of read-verify pool runtime errors")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/read_verify.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index efdf6d544858b8..311ea1c29008f7 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -471,7 +471,7 @@ read_verify_schedule_now(
 {
 	struct read_verify_pool		*rvp = rs->rvp;
 	struct read_verify		*tmp;
-	bool				ret;
+	int				ret;
 
 	if (!rvp)
 		return 0;

