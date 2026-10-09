Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6146B45C719;
	Fri,  9 Oct 2026 06:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791526508; cv=none; b=kchqL1kALixxPyek7JG25b80aEmNnkZ/bEM75IF9zXsVyCXE9A+Fy5C2pd0KHNaCMj9qJftlOu9WgLhmAe358UoE+ei/5malIXRYgR9Sc12UULj6qAVA8ApU1Bxhx7R6xnP5YFHYP0t/WJmI6+mZRDlxaT5P/tblWF/8ZaouPEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791526508; c=relaxed/simple;
	bh=gLpX2D/iF+IKhkqBF7BrxsfdLcm82jnspRaj+M2c2SQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zh/QsN7IiJ1oUcakDqN5QawyCOMhklUdqsSvcOrtEboh1amLIlFF130vznCvuJzNlDYSxfUki37ba8Oxy+dab5rcCgjNgamgytQ3ZqpwhETf0NwFfMG3rfADmedTMiQUleBPxfYHL01c8TljUy028NjYm2IHU3txOIHeHlmCAAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NM3sutAz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NM3sutAz"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C9D221F000FF;
	Fri,  9 Oct 2026 06:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791526505;
	bh=oz0FZNknJNLnRVKxtqMWkztsnRqtEVJOuVrJWI5jirM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=NM3sutAzpG7G6tnBliwxaPb3BXnuAVJdJ4riFcXM3k9Z/5zZSnll1MmSY3cjJju9s
	 Jgn7PIYWWVNB5YN2AOlvxMja8tywI4ECqvE4LnxlS9ZOZdqpC3ObqQIGeyMt3cD/ba
	 AN/kOQgUra5KCBhEy1SZdwl4p7hL4moCs8ihqwuxBdqMnaq/LsXSYMQyvVP3QX6/YE
	 l/KZygZx9om+IuZ1+3LnOtxajk9n2+v5CFOEqe/ZXWw5FFOH+/R0U3JhlRE6FXuPsL
	 vIivBKfaEyTvuz3C1ETcarzf3gmifvtoyxwEC8kOjvgVbkp5QRllJwyBqpxhI7bMKF
	 ujZ5WgAXhYjBw==
Date: Thu, 08 Oct 2026 23:15:05 -0700
Subject: [PATCH 01/13] xfs: check for termination during rmap btree walk
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179151614642.3163896.3491635646313710683.stgit@frogsfrogsfrogs>
In-Reply-To: <179151614535.3163896.2744921556354655977.stgit@frogsfrogsfrogs>
References: <179151614535.3163896.2744921556354655977.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM complains that we should check for a fatal signal *every* time we
walk a record in the rmap btree as part of rebuilding the free space
btrees.  Fix that, and improve responsiveness to ^C of xfs_scrub.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: 4bdfd7d15747b1 ("xfs: repair free space btrees")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/alloc_repair.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index 6e835240536181..9a09a9ea9c3089 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -224,7 +224,10 @@ xrep_abt_walk_rmap(
 	void				*priv)
 {
 	struct xrep_abt			*ra = priv;
-	int				error;
+	int				error = 0;
+
+	if (xchk_should_terminate(ra->sc, &error))
+		return error;
 
 	/* Record all the OWN_AG blocks... */
 	if (rec->rm_owner == XFS_RMAP_OWN_AG) {

