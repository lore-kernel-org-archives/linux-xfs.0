Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E9B1FFC59;
	Tue, 14 Jul 2026 06:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784009158; cv=none; b=nW4TmubfE2k9ZHi58/RQjTSZsYXoL2b08a2CNNKqUMgihAiVx7Pi5vWLfHn6lPyblSLMndQLAyhxxJC+bPZh58qZN6/K0CyDd163TmQMHj3krLa6Q8APwVcpjn/LIrEh1mMovmPJ8ckgBp+uv0/PfsNIxRRPBaQSbFv/zqK3bJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784009158; c=relaxed/simple;
	bh=ZUGNeCaIhOp2aiTrGjF76e0THENxkuunq/ieBoMewT4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h53tM+3BFmel9W/0mgAfVwVyhi2mx6FvZaahZeNeRM4yLvH1T27e1RuDm9SfrypRS7Ihdgeeks3tmbQdg6NpNZpcTgAaDGvtBdrjaZ+795fb27HuTe4um/y1SXyOgiJGEUBd1OIwMs0HFP5/7vEXIXUv+TaNf+/Ju3Xh6iNCp7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RTE4NdF+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RTE4NdF+"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9CE771F000E9;
	Tue, 14 Jul 2026 06:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784009157;
	bh=0a4r/CuVwtLPtdixj4JsF9xvRTAfAF5gZa8oqdwXv48=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=RTE4NdF+qutaWw6cbz9cYYvOSRh6hWd+xSEsyvBMQds9fd8M+2yF/R9Z0B1os2gbZ
	 KHUw/0gbsqfsXqX0ay68k3ksMJVA02XDNEOFou/CukoEAhb7PTnh4ZILO3h4zQylUK
	 oFs1LwDb88LUfRG+MfJrjE9u0p1f0DBvPdPk+5sRo+d2HlIlyi41q2xZYzWwZGfe1e
	 W/U4a8htD/CIBzxDyZLrX+HaPNlC7LiiXYWHu4ndHUozTzWsWeYOJlVGP9CkCaGKPp
	 MGodW47CybcDxv93VgvRuBnAY2KRZF9RVxSaCPUD3113GofG3IPspo+ZeLaDobWhgn
	 gb3XcCyFRhYvA==
Date: Mon, 13 Jul 2026 23:05:57 -0700
Subject: [PATCH 8/8] xfs: grab rtrmap btree when checking rgsuper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178400716542.267810.5807049128183463210.stgit@frogsfrogsfrogs>
In-Reply-To: <178400716321.267810.14342805775513660564.stgit@frogsfrogsfrogs>
References: <178400716321.267810.14342805775513660564.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that we aren't grabbing the rtrmap btree when we check the
realtime group superblock.  As a result, none of the cross-referencing
checks have ever run.  Fix this.

Cc: <stable@vger.kernel.org> # v6.14
Fixes: 428e4884656db9 ("xfs: allow queued realtime intents to drain before scrubbing")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/rgsuper.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/rgsuper.c b/fs/xfs/scrub/rgsuper.c
index 3dad6e5da74e55..2bd2c0351b35f7 100644
--- a/fs/xfs/scrub/rgsuper.c
+++ b/fs/xfs/scrub/rgsuper.c
@@ -23,6 +23,8 @@ int
 xchk_setup_rgsuperblock(
 	struct xfs_scrub	*sc)
 {
+	if (xchk_need_intent_drain(sc))
+		xchk_fsgates_enable(sc, XCHK_FSGATES_DRAIN);
 	return xchk_trans_alloc(sc, 0);
 }
 
@@ -43,6 +45,7 @@ xchk_rgsuperblock(
 	struct xfs_scrub	*sc)
 {
 	xfs_rgnumber_t		rgno = sc->sm->sm_agno;
+	unsigned int		flags;
 	int			error;
 
 	/*
@@ -63,7 +66,12 @@ xchk_rgsuperblock(
 	if (!xchk_xref_process_error(sc, 0, 0, &error))
 		return error;
 
-	error = xchk_rtgroup_lock(sc, &sc->sr, XFS_RTGLOCK_BITMAP_SHARED);
+	if (xfs_has_rtrmapbt(sc->mp))
+		flags = XFS_RTGLOCK_BITMAP | XFS_RTGLOCK_RMAP;
+	else
+		flags = XFS_RTGLOCK_BITMAP_SHARED;
+
+	error = xchk_rtgroup_lock(sc, &sc->sr, flags);
 	if (error)
 		return error;
 

