Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DE8231839;
	Mon,  5 Oct 2026 05:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791179813; cv=none; b=lgeIaiOsxH+ksulkKIkBJfjmQX85Co7KRGR7Ec5DEN/hshBq4X7rSO7fVrcrfWR4w4r44lE4yJd5NhIw6vQyXriE0r0YLtPC3KB0oAAbzgIINtnC1CIDVOzZhM7m0K2yxeZEy3LimpC8JgdUQta8kLyIb+/og9tip18cGHW4Kc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791179813; c=relaxed/simple;
	bh=F1x2lrj5pkFC7A9FMtZNsu/PJ5zOItAnOejpRZjfYig=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fhnvuhnYRR981aLqGaGWcWtPkYcryeKuHY5A01Ql/jYWJR3/hj9u29XYC/HVT9T4UQlap8qMdjuUA1Jv1w6g6Vy58unwi+HoRLJ73iox5e1ccsG5iGHaWHo55HEtFLrIM0WqwVosa/vpD6fuxOBN1w7x7Up9FRf5OVuH9PjfmRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mR97mELk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mR97mELk"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B891E1F000FF;
	Mon,  5 Oct 2026 05:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791179811;
	bh=xGLYb2IjENAk2+1ZwrjzJtfNMUrxqjFNuUI9wqTnOGE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=mR97mELkjXGF/IOiYFtYx7g1a3jgkhvI+qiipwdPGWoY9dvPId+jAHf7H0fnnf4FO
	 b6zas6EqTRvNXXsViYTJ8kEqMRwbHaM5yn91Xn3hiqk0IsWuNVN9nmZeL4/4zLaAi/
	 wlIRM/VImLTYa0aQmdzmwzj2l0ImFGeIYcZ97G7cM1B/T+gr6bw3ClcEslzf82JZeR
	 zh06PtDNU+yq/vwJ4E63woFmNkNnO+DEJIcB3XPCmry41TSAM30vV0nr003UrympHb
	 Ho0e6/PgBWyn7XF1bSbEaXLZILLk+qQ506u2s7B8fFLO8irr3RhujV9LLyNNXK2css
	 fgdk4M86qyL3g==
Date: Sun, 04 Oct 2026 22:56:51 -0700
Subject: [PATCH 06/12] xfs: propagate errors while checking null siblings
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179117965138.614350.7315633319922629881.stgit@frogsfrogsfrogs>
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

LOLLM observes that if xfs_da3_path_shift returns an error here, scrub
doesn't handle it the way that it handles most runtime errors.  Instead,
it drops the error and keeps going, even though that's not how that's
supposed to work.  Fix that by calling xchk_da_process_error to set
corruption flags and then jump out of the flow of execution.

Cc: <stable@vger.kernel.org> # v4.15
Fixes: 7c4a07a424c18d ("xfs: scrub directory/attribute btrees")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/dabtree.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 639228601cc6bc..bbf6ece58828ca 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -253,9 +253,10 @@ xchk_da_btree_block_check_sibling(
 	if (sibling == 0) {
 		error = xfs_da3_path_shift(ds->state, altpath, direction,
 				false, &retval);
-		if (error == 0 && retval == 0)
+		if (!xchk_da_process_error(ds, level, &error))
+			goto out;
+		if (retval == 0)
 			xchk_da_set_corrupt(ds, level);
-		error = 0;
 		goto out;
 	}
 

