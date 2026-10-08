Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4477138F932;
	Thu,  8 Oct 2026 05:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791438923; cv=none; b=WCs7QhXIq3RHB7xwXsFr2fbBIH101j+isvf+tVJVDMl5TprEXPGLbyvwDie/J04k6tMMJmdKuGvOHzudBVGZwmUYpuApSiljrdZNSqfFvg/Pi10Ikle7vZUcHY46OdBWiMTap+yMEsGCyPPsHog2/UasiBl7ta327Fw3Br0k/MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791438923; c=relaxed/simple;
	bh=IYQ98PRxpzsgKBbwOzoR9vQxgTUjAHZCggHcxMCp13o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hikhhzrZeRecse1CqyrkC1T6E4RBLvJ9uUJM1WNGygreSamUf+yCASpbC3cfMHKciegsKA1vCZRHBRpGARdcQfvkO+QXQ2JLxrVFSKZthTn0jswoG+oV44b7YD5eX+oUUQU/Gzx0f/42OfaIXmpJXB51YcDTJvkdT19OgrqbN1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LeH/B/a1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LeH/B/a1"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E59361F000FF;
	Thu,  8 Oct 2026 05:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791438922;
	bh=xKXaAYUxIN+v9gbMHOwK9mK4iA+A8qos5flnCIOVN1U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=LeH/B/a1BCn8D+AvqYU97xc4Y9pUMpHANgC+mK5uVt70AqYqA7vd1v9yPk5Jst2v5
	 W9FKdYZ3D+n3hCYHLh3sJBDWCasnQ6XrRadrCk9nr9YNy1vTQR9mmVr/yna4OWGhgV
	 AmPcgdjZwgMVk2VMHtQMTKencqojEwU9hoqWcQooMklp8/YsEV/pcGpaJUucMD/HpU
	 7fO9pm/VA41npylROZbZEl05RrveRRM2bRXj2Up95JKeVK6CuVYlPvdCjIMuVn2Jrw
	 MarqJBBwxsF5MZ1TRskj+BcaX3R5PX0XD7LNjxQPYgmj8eUJ55aOOnurl2wj81lHZu
	 ONJwNHsj79zjA==
Date: Wed, 07 Oct 2026 22:55:21 -0700
Subject: [PATCH 02/12] xfs: don't subtract excess usage twice when computing
 agf_btreeblks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179141521299.2728617.2877901149807191718.stgit@frogsfrogsfrogs>
In-Reply-To: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
References: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that the free space btree repair code calculates
agf_btreeblks from the number of blocks we wrote to rebuild the free
space btrees (minus the roots).  That's correct.  However, it observes
that we subtract the "excess" reservation, which is not correct.  Fix
this accounting problem.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: 4bdfd7d15747b1 ("xfs: repair free space btrees")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/alloc_repair.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)


diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index 9a09a9ea9c3089..05f27c927adfb9 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -660,15 +660,11 @@ xrep_abt_reset_counters(
 
 	/*
 	 * Compute the contribution to agf_btreeblks for the new free space
-	 * btrees.  This is the computed btree size minus anything we didn't
-	 * use.
+	 * btrees.  This is the computed btree size minus the root block.
 	 */
 	freesp_btreeblks += ra->new_bnobt.bload.nr_blocks - 1;
 	freesp_btreeblks += ra->new_cntbt.bload.nr_blocks - 1;
 
-	freesp_btreeblks -= xrep_newbt_unused_blocks(&ra->new_bnobt);
-	freesp_btreeblks -= xrep_newbt_unused_blocks(&ra->new_cntbt);
-
 	/*
 	 * The AGF header contains extra information related to the free space
 	 * btrees, so we must update those fields here.

