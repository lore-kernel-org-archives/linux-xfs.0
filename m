Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5191936A033;
	Tue, 14 Jul 2026 06:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784009174; cv=none; b=EBYbIk9qrY0qHaYMXES62fkbjKwfl/X7p4O2tL/9vcr3U6QXi1Q9ugP4Eey+KITQd+hmKsmzDNerTwUofUR+xzFsq21LT3qElFr9h6hGlrhSaAejXUlPHP7yPdBnSVuAuyPNWPKeUgjTL9waiqJ/u9tQYnEc7cdss8OULJd5b/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784009174; c=relaxed/simple;
	bh=DNc9J53MvJbrPM4W8tI6+xCI7HPFJixVEEDPKyqzZJo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VnGhz1YxldRXV0JIaZTxZdRy6Ysm0zC1MC/WwnSU3jZL2a4yXITqRnL0wNtXS2D/pYtDS+hFjgLJ2ig4X74+OU3Qutp9o3LTZduCeob1G9z+soxKgwgC21H3BQK5ulqwz6VESxL2M9KHdhWmDXMXp/PL/RLJPy7KfxDgDb9r5sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DVbajSjR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DVbajSjR"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 2A3261F000E9;
	Tue, 14 Jul 2026 06:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784009173;
	bh=q5c666oVa4AjSGolyrY6lQWpvHdQzU5xCqtTnghY2O4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=DVbajSjRCHJk4yEeKT1PMwpqWt4Uuy6OeCviSceNAvIGStVF7w4Va2mk1JKNxuJj4
	 M4i1v+qIGxTJKwd0aqx1l4Rffw60G0pLj3OG92Qj/c7iWbRuZcNqL3w8w1bvYejYTZ
	 kWUMFOcbfDzRUyQHQiA2swmLAHRyHUTUOau5hdDgNd+/KeH3wTXJvk+dh6+oQXzPpS
	 wjFs7k00MA6bEUxkgoWUqkyFkbtkAscEZksTt3+IuOe8G9kvXWBj6cJMoI61FlpWXo
	 JIQ6URWDGXOMpGZEfxCYN5WORzZq2tDJ2u3MdCXvSMli1SyI+jkQHgtpV13e9US5Ag
	 mdc7c278+tiQw==
Date: Mon, 13 Jul 2026 23:06:12 -0700
Subject: [PATCH 1/6] xfs: set xfarray killable sort correctly
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178400716837.268162.4871292933498780753.stgit@frogsfrogsfrogs>
In-Reply-To: <178400716782.268162.4846177784022689546.stgit@frogsfrogsfrogs>
References: <178400716782.268162.4846177784022689546.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that we *disable* interruptible sorts when the KILLABLE
flag is set.  This is backwards.  Fix the incorrect logic, and rename
the variable to make the connection more obvious.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: 271557de7cbfde ("xfs: reduce the rate of cond_resched calls inside scrub")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/scrub.h   |    6 +++---
 fs/xfs/scrub/xfarray.c |    3 +--
 2 files changed, 4 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index a3f1abc9139035..6d7d3523b71f25 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -11,7 +11,7 @@ struct xfs_scrub;
 struct xchk_relax {
 	unsigned long	next_resched;
 	unsigned int	resched_nr;
-	bool		interruptible;
+	bool		killable;
 };
 
 /* Yield to the scheduler at most 10x per second. */
@@ -21,7 +21,7 @@ struct xchk_relax {
 	(struct xchk_relax){ \
 		.next_resched	= XCHK_RELAX_NEXT, \
 		.resched_nr	= 0, \
-		.interruptible	= true, \
+		.killable	= true, \
 	}
 
 /*
@@ -45,7 +45,7 @@ static inline int xchk_maybe_relax(struct xchk_relax *widget)
 		widget->next_resched = XCHK_RELAX_NEXT;
 	}
 
-	if (widget->interruptible && fatal_signal_pending(current))
+	if (widget->killable && fatal_signal_pending(current))
 		return -EINTR;
 
 	return 0;
diff --git a/fs/xfs/scrub/xfarray.c b/fs/xfs/scrub/xfarray.c
index c7c4a71b6fa7c6..2ce24bfe4c0fab 100644
--- a/fs/xfs/scrub/xfarray.c
+++ b/fs/xfs/scrub/xfarray.c
@@ -487,8 +487,7 @@ xfarray_sortinfo_alloc(
 	xfarray_sortinfo_lo(si)[0] = 0;
 	xfarray_sortinfo_hi(si)[0] = array->nr - 1;
 	si->relax = INIT_XCHK_RELAX;
-	if (flags & XFARRAY_SORT_KILLABLE)
-		si->relax.interruptible = false;
+	si->relax.killable = !!(flags & XFARRAY_SORT_KILLABLE);
 
 	trace_xfarray_sort(si, nr_bytes);
 	*infop = si;

