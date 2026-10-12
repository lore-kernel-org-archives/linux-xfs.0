Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948EB3AE1AF;
	Mon, 12 Oct 2026 05:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791784608; cv=none; b=dnjySZkxQYsgZLA5VY1/eK2qOg/sRrzixpd3u8c9LCvTwQmwvxsbadFekltK1jyj7u5v+xowrCcRwKMiq+jDg6rvfeA7DIHdf3KUv89krnig2vYQUV2WK7wYSiT2KV+PlnVb50D8Hc/sM6LBW5zf0Of+Ld/LHpyJ8eajdTEcatg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791784608; c=relaxed/simple;
	bh=3FNZNM/4CQoLGkQENXtVApXwymLC7717ezOTaQRBENw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H3WZE7h9t3W3gk4RJxDXvSadX1P4uC/0Z3qRckozNE+yi7DzuA6ciUw9lPVrbB99tNsLsFZmyQxX7tClF55dqW+bk5KGb6zIOrix7jQ0BzNxnvPdhiEYZn4ThXpv07MBLlhSpv/DustHLfXo71KOLLKgtraBtIdwRKt5KNUrKrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YKr2kfjL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YKr2kfjL"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 232291F0089C;
	Mon, 12 Oct 2026 05:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791784607;
	bh=eEISoCRlCB2HYLQsMcRKXY1XNxcr6vMHF7FB16lvtE0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=YKr2kfjLDHvnlC8XddyEGU3iTPcAl89+kqQarX9XXjJqROPWwmWMNutUY9tEu5/qY
	 cqd6rpENR/QoB81rwdrlEeOq0nkskur8XILX9DLn4/6818eCj610vXNlnOYA4fj/5w
	 NLu9sE321rrQ+HroVW6tjBWYoutaI17YpP8S6QlhSepFONO/ormfhazXO4Et6n1wVP
	 J/FgACh7iZaDEM9YGtX7YmTcaMdkj2lVw6+uvozye5bEdzlFohzgUvN1diJfJA6yg7
	 Dc5U+LaKSZf5CN1s43EEj0+tVm4n9Vq/cuMpkxIQbsAFDk2bqH5ZOqZQzSzxGone2I
	 tnzCXk/+LI89Q==
Date: Sun, 11 Oct 2026 22:56:46 -0700
Subject: [PATCH 04/12] xfs: reduce new btree slack factor if free space is
 negative
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179178065281.1058326.11344648618549479599.stgit@frogsfrogsfrogs>
In-Reply-To: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
References: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
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
 fs/xfs/scrub/newbt.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
index 1f28ca1647f8d3..2336fe97415120 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -56,7 +56,7 @@ xrep_newbt_estimate_slack(
 {
 	struct xfs_scrub	*sc = xnr->sc;
 	struct xfs_btree_bload	*bload = &xnr->bload;
-	uint64_t		free;
+	int64_t			free;
 	uint64_t		sz;
 
 	/*
@@ -72,6 +72,8 @@ xrep_newbt_estimate_slack(
 		sz = xfs_ag_block_count(sc->mp, pag_agno(sc->sa.pag));
 	} else {
 		free = xfs_sum_freecounter_raw(sc->mp, XC_FREE_BLOCKS);
+		if (free < 0)
+			free = 0;
 		sz = sc->mp->m_sb.sb_dblocks;
 	}
 

