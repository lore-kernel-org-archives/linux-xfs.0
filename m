Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948FD490BEE;
	Tue, 13 Oct 2026 06:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871623; cv=none; b=DheExljXtbAvN36ubqcuv+LKmJ75WwM4y2qfPI4hofmMY1o1jj/aZGc8YBtW0o3jyMnMLVW1Nc7QFMfq/4hmNvEnUj8VWJQwae3JLjcRr2C5EcG40hC1W9TaVHykwZJW1TAXgHkIM4i0r2hjPP68GOppQhfOGOpLOwprsYNm5+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871623; c=relaxed/simple;
	bh=ejkPUGdhqPErs7qXeylKD0SJTQc+ZEhEOeCf9LYwUrw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aeaqdoNVDq/mBbvNr/xpCeCahcQBDptysbIKvJKKmYLNg8ryj3bD+qF9b7XzLprJuWbFx+leCXsF5TQZdXpst66wQNPwz8yqm7ybR1yQ9JTU0EX9RcJX2xOGvbqMja79b9wHei0WxOZrMPVaOq+oaz298EMi4iubzr6Wh5z6mtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ku8nQ/4Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ku8nQ/4Y"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6B9231F000FF;
	Tue, 13 Oct 2026 06:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871622;
	bh=OzpOb7fgZVVph6swzq6MXEHAPf6h+f/y1hyTdwVp7uI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Ku8nQ/4YMR34dNod6KDkmH/pWz4/mH/HYgfmU7wHLNrzz1bnHInr9UPngyp16183F
	 KDG+aZKtqvn7UPt8wWww3F6w4IRrsQnBP37hZqQmLkEb/Ha2tywnpr/dut44Da31XP
	 LicFj6qmXheUOcPt6REWe1cGGUlqFDNLvBHCtfRUmVN3bDlBhA89FxwO0LSsDhd2bL
	 E1b9epCBeZEK6G9/QqNCtH64LZ+fDqcEMRk5ZVsPCmT5QX4h9x+uqDp1hUOekESeo6
	 18sVMe75jU4gMeE5/b0Z9fYzTjkzjAvxn8xe3NPqZI8SmFldwmFGQN8I28rTula++b
	 I9TbPgt5sYoKA==
Date: Mon, 12 Oct 2026 23:07:01 -0700
Subject: [PATCH 07/12] xfs: check for fragments when full-extent sharing
 matches
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179186107290.1898400.11595388650663319200.stgit@frogsfrogsfrogs>
In-Reply-To: <179186107061.1898400.3978552773417541744.stgit@frogsfrogsfrogs>
References: <179186107061.1898400.3978552773417541744.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that xchk_refcountbt_process_rmap_fragments returns early
if there are enough rmap records that overlap the space referenced by a
refcountbt record to match the refcount in that refcountbt record.
Unfortunately, it never checks the fragment list in this case, so it
won't find the discrepancy between the rmap and refcount btrees.

Cc: <stable@vger.kernel.org> # v4.16
Fixes: dbde19da963706 ("xfs: cross-reference the rmapbt data with the refcountbt")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/refcount.c   |    5 ++++-
 fs/xfs/scrub/rtrefcount.c |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index a900d13c9e27c0..883c273cb9883f 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -185,8 +185,11 @@ xchk_refcountbt_process_rmap_fragments(
 	xfs_nlink_t			target_nr;
 
 	target_nr = refchk->refcount - refchk->seen;
-	if (target_nr == 0)
+	if (target_nr == 0) {
+		if (!list_empty(&refchk->fragments))
+			refchk->seen = 0;
 		return;
+	}
 
 	/*
 	 * There are (refchk->rc.rc_refcount - refchk->nr refcount)
diff --git a/fs/xfs/scrub/rtrefcount.c b/fs/xfs/scrub/rtrefcount.c
index 00da8e98506d63..c312096e410561 100644
--- a/fs/xfs/scrub/rtrefcount.c
+++ b/fs/xfs/scrub/rtrefcount.c
@@ -200,8 +200,11 @@ xchk_rtrefcountbt_process_rmap_fragments(
 	xfs_nlink_t			target_nr;
 
 	target_nr = refchk->refcount - refchk->seen;
-	if (target_nr == 0)
+	if (target_nr == 0) {
+		if (!list_empty(&refchk->fragments))
+			refchk->seen = 0;
 		return;
+	}
 
 	/*
 	 * There are (refchk->rc.rc_refcount - refchk->nr refcount)

