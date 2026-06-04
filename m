Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5B83B993F
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 06:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780553280; cv=none; b=EayVEUEF9zhmSpxceGIIAPOxV1Kud/mlnGeHo7nfmhpJTHD/kcInLfJZOdkVfHrEWlKff6aswNHlX/iQN6d+jfh7J5KiAtJIjOGcwqm3QkBsMb45yqF4eX5ejZHX++hdqM7Q3TW3rgySAgHhOdAkCDOWDWgtKwtEup7ijuLRLak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780553280; c=relaxed/simple;
	bh=xixzck6Mo5qJxg5AIOzTHaBdcv8P8Dvi4am3T7UEcQ4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YQfU/5h98Y3FEdX8bhjqssTcxfpUOQvry928xZxUT87PGUw/b4ghwbinuHyx1uRRYTUIhzK0yd2qxmH6O0ZV36yRVJSqaPTR7bUwSe5AyaVI0OD+gDyh6Q38E1bCTP9lztzToldZaJRUCa1b1jZEDgtjHxGhJra08T9Sv/Qvwqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yia03SzL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yia03SzL"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CE95F1F00893;
	Thu,  4 Jun 2026 06:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780553278;
	bh=TzbX6raO7H/kI1MQDbVkWzeq4aY1q7wHRdduXEP0Fjg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Yia03SzLQAdiaOUoEStV3l5TmY3FJN886k71jOVgR/2TEEkrjaQA0ygi7NRageH95
	 uH1lkj/czS+NYnO9SwHQvQsyR5wcODqvIT3AWlW5xlrXXiEvlG1/bMt6as4Rpe0HHp
	 r1Nzix2GO053uRoUDKO+S1SzWdU+7+mApNGv3TqnE4nrlW+ur29IfGMeZDNxrb+v2a
	 5H3CzeVIVCw23jAulrjW/e/zb+sUhV77lA3tHmM3cMCsW6HlNA8zDwzrCiYCqXB6SK
	 C4AIoBpZcKAqGkiOpo80+cyEYogY05KeC0krcCMWFaQVgj8jH2v9wPKqps1sJDV3Lc
	 QktvwDAnqMe5Q==
Date: Wed, 03 Jun 2026 23:07:58 -0700
Subject: [PATCH 14/21] xfs_scrub: reset bulkstat pointer on retry
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178055303365.2608728.13882189590028658191.stgit@frogsfrogsfrogs>
In-Reply-To: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Codex points out that we don't reset the struct bulkstat array pointer
if we decide to re-issue the inumbers and bulkstat calls.  Fix that, and
fix the @error variable being returned uninitialized if hdr.ocount is
zero.

Cc: <linux-xfs@vger.kernel.org> # v5.18.0
Fixes: 9f4d6358e28ba1 ("xfs_scrub: don't revisit scanned inodes when reprocessing a stale inode")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/inodes.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)


diff --git a/scrub/inodes.c b/scrub/inodes.c
index 4ed7cd99635bda..bfd4abc44b56de 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -471,11 +471,11 @@ scan_ag_bulkstat(
 	struct xfs_inumbers_req	*ireq = ichunk_to_inumbers(ichunk);
 	struct xfs_bulkstat_req	*breq = ichunk_to_bulkstat(ichunk);
 	struct scan_inodes	*si = ichunk->si;
-	struct xfs_bulkstat	*bs = &breq->bulkstat[0];
+	struct xfs_bulkstat	*bs;
 	struct xfs_inumbers	*inumbers = &ireq->inumbers[0];
 	uint64_t		last_ino = 0;
 	int			i;
-	int			error;
+	int			error = 0;
 	int			stale_count = 0;
 	DEFINE_DESCR(dsc_bulkstat, ctx, render_ino_from_bulkstat);
 	DEFINE_DESCR(dsc_inumbers, ctx, render_inumbers_from_agno);
@@ -486,7 +486,9 @@ scan_ag_bulkstat(
 	bulkstat_for_inumbers(ctx, inumbers, breq);
 
 	/* Iterate all the inodes. */
-	for (i = 0; !si->aborted && i < breq->hdr.ocount; i++, bs++) {
+	for (i = 0, bs = &breq->bulkstat[0];
+	     i < breq->hdr.ocount && !si->aborted;
+	     i++, bs++) {
 		uint64_t	scan_ino = bs->bs_ino;
 
 		/* ensure forward progress if we retried */

