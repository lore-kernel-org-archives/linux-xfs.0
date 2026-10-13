Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842A9493D4D;
	Tue, 13 Oct 2026 06:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871577; cv=none; b=ZZdE2mo9aZ8fp2KAiCtyNmj6lyqOYf7WfsGsvkGoBQQAcpnDKEA4KJYiIgddwYh50bK+uLUpKrBsWqFFr/hxGbNIEtzRerJyuqPYe0JIauozCgES9VxJMn9fc7BrlhBRMQagYpk9n0pxW5RiEfngR0E7QG8TX5bP73DMQhJ0ZTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871577; c=relaxed/simple;
	bh=0NpvaRF5NweFEOlRHqljCFZE2dydTbyScLet4EW0xXg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UWrVYdREjy8GpspFjy6Nt0ZeMHgw8F171qx8bX56X5LHLVKDKmk4/xeds1riDgHbqHLr4rfpZX8WLfeWvtQWHt0wQYc242cOXRuYGT46RUye2s51gzwZ/2rW46enqqMCUJG8GbAekwwMiTBaPuqJCFs5Tvu/OiPkXJmmeFYficU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HU/ExF9U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HU/ExF9U"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5C4C81F000FF;
	Tue, 13 Oct 2026 06:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871575;
	bh=F14llXI3bV4o8KhZep3oZzAeuHtX7s1HZE8UNHWU0+c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=HU/ExF9U/K8qRFxCcjeeghLGiCu80zv8n2G6KyyjkxGo75UkZODayzg9QyUor9KMC
	 gSjtlc8qtRYrLrlOa3Rs5pNeE+IFFWVn2UM7x66tb4KV+S+rPP4h1IBplV+800Bbd5
	 MK/9axO0nZKpsgOEYOGyUOX5gi5zKUuDxQNRgxe8S0y+X6ICZhEqaN2bC40eCmy6Zi
	 7oBZFmAE+ih0WQcg3YbsSYK05w/uMQMKg+mpo1IaYFCpFyDEu80Z4dDQxDbqq6+/Fp
	 rPLIE1iDUCwAhO3PnFdT+XgRP9M9UdeF7hETZaKSG1GqcNadQSnT3LpGZxBNfYN48l
	 D2bjT4elP5dqg==
Date: Mon, 12 Oct 2026 23:06:14 -0700
Subject: [PATCH 04/12] xfs: reduce new btree slack factor if free space is
 negative
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179186107225.1898400.12841478564368550599.stgit@frogsfrogsfrogs>
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

LOLLM points out that if the incore fdblocks counter is negative, the
assignment to uint64_t will mask this possibly low space situation and
we don't pack the btree blocks as tightly as we probably ought to.  If
it's the case that there's some free space and fdblocks is too low due
to an error in the superblock field, then we can end up failing btree
rebuilds due to ENOSPC unnecessarily.  This is a corner case, but let's
fix it anyway.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: be408417630427 ("xfs: implement block reservation accounting for btrees we're staging")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/newbt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
index 1f28ca1647f8d3..9baf08bc54cd0f 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -71,7 +71,7 @@ xrep_newbt_estimate_slack(
 		free = sc->sa.pag->pagf_freeblks;
 		sz = xfs_ag_block_count(sc->mp, pag_agno(sc->sa.pag));
 	} else {
-		free = xfs_sum_freecounter_raw(sc->mp, XC_FREE_BLOCKS);
+		free = xfs_sum_freecounter(sc->mp, XC_FREE_BLOCKS);
 		sz = sc->mp->m_sb.sb_dblocks;
 	}
 

