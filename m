Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38220224AF2
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 04:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790309526; cv=none; b=uaQX0U9+7uivWDZr0lcvpbCjDyceNCCyLplfblR3sBJMnm1IzfgiDwJ3nhwIOMaY6chbvecI/DjukN+KAf9UtcbB2RXk3vQd7lvPuDmryXxJyrjFIvdvup5M+T6zLQwW69cQlKpBVEQmkOBgM/86MmFxeoTsLFq/qcf2FL8OYWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790309526; c=relaxed/simple;
	bh=GuRJiGZfF06ud0kfB8L9vZsCztYygstcgVIXYr8O2Cw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HDZ8OO1Feu9k8DFEvU7YfjYvjfZn+qkyW109cwwYBHeiuG/b04f1NS1h085vPzlnTHTJ+tgFWjJM6PiqafLAWD1gKrtBUEc4HZNW4TblxymavLJRI24k3A6OKK5rhBPKGqK8tZEk9MQPHGyOkS6+bNYydvSc9boixto1vnvPuD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SCXhmtqF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SCXhmtqF"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B900B1F000FF;
	Fri, 25 Sep 2026 04:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790309524;
	bh=HrMKU+YuDqGnwlsjktliXSMc5O/g7aUiZJVuTwB1nVk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=SCXhmtqF2eDt1ExfzFxDSz2TuLByBKFf2MwFRzPL2bnVs5KMNFcOBjZsZg1SDlt2C
	 zl2t98j1r8Zr/Q9ZPOGSJ/Ug9gxXbb93HkWSKSRnljlfZdqECp/lHK/RaxgXdOiVdc
	 RxNTYP/zxypS1Tk/e2W7fbWp5wyeob742X7tfMQ3yvjMHFoltD5fj3vHe7N3bwBiCz
	 SW7nXIHuwzgZgrXS4ucFeYOVpCLSTNbyA1D+/YJP5ohfJjw9peUFM+rJaeiGXGWBZo
	 c2u+rPlUCHc8EqKLX2D0JkOZT7xU3iEqhnS/Ag66nJkVxDCvZChZ4y2tUHBjjyHV1A
	 BFgg5g9163YZg==
Date: Thu, 24 Sep 2026 21:12:04 -0700
Subject: [PATCH 06/12] xfs: read rt superblock from disk during scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <179030932176.3344850.5822434207780341943.stgit@frogsfrogsfrogs>
In-Reply-To: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
References: <179030931976.3344850.17488605741516845262.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

The rtgroup superblock scrubber isn't that useful right now because the
disk contents could have been corrupted after mount time.  Perform an
uncached re-read of the rtsuper buffer to perform a fresh verification,
and schedule a repair if it doesn't pass muster.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/rgsuper.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/rgsuper.c b/fs/xfs/scrub/rgsuper.c
index 2db92cb89cc614..102bd92e9003db 100644
--- a/fs/xfs/scrub/rgsuper.c
+++ b/fs/xfs/scrub/rgsuper.c
@@ -46,6 +46,7 @@ int
 xchk_rgsuperblock(
 	struct xfs_scrub	*sc)
 {
+	struct xfs_buf		*bp = NULL;
 	xfs_rgnumber_t		rgno = sc->sm->sm_agno;
 	unsigned int		flags;
 	int			error;
@@ -78,9 +79,17 @@ xchk_rgsuperblock(
 		return error;
 
 	/*
-	 * Since we already validated the rt superblock at mount time, we don't
-	 * need to check its contents again.  All we need is to cross-reference.
+	 * Read the rt super from disk in case it's been corrupted since mount
+	 * time.  Crashing with a bad rt super may prevent remount, so we want
+	 * to fix these things ASAP.
 	 */
+	error = xfs_buf_read_uncached(sc->mp->m_rtdev_targp, XFS_RTSB_DADDR,
+			sc->mp->m_sb.sb_blocksize >> BBSHIFT, &bp,
+			&xfs_rtsb_buf_ops);
+	if (!xchk_process_rt_error(sc, 0, 0, &error))
+		return error;
+	xfs_buf_relse(bp);
+
 	xchk_rgsuperblock_xref(sc);
 	return 0;
 }

