Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F30C233723;
	Mon, 27 Jul 2026 05:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785129828; cv=none; b=Tuxp6YMImFo8Z4VFQ+2hPfc1aO7jg+QaUymfC3ZoY6VuwFVigfnVZzyiZ/f6+qddqXiue3iqF/qxPQl2sz3wJmGAdgD2VUl6qDp3Mz0u3k3Yo0M1tQgIjE7QXgvHzKkaP2VB5fW66wU2TqVADFoOjY3i/76w4hKL1cdj9GoZq0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785129828; c=relaxed/simple;
	bh=l6TWdrOjmBIXZHwS144J0iKmQD5oo7AzMcV5qukf2UY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JiuoSH2YZf2WBL7UmPsKsBURUYywb6UuwExBT6PZfDxu7oL6Tb4PIhBCUr/wQyr7KS+19RtuwVGelJA+0FEH7/spWFvYemL3TYpuVnrJYV7n9SM9AvCdFBhvJmmicGYso989Kc/vxbLMokXgP+t6BCQbmQnq4BB/gWUt3VYGPMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IjRkikt3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IjRkikt3"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EC4B71F000E9;
	Mon, 27 Jul 2026 05:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785129827;
	bh=aQHKGNNTjHFAEUmqaWNrJ03FTrs0w7lo896GjcdVZNc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=IjRkikt3dNixwhZFHNU5wX6L8CQbrcFJ7O3hl+1TxM0vm8D+oojyZ8Zf8WPqVpeWr
	 L+Oo3ep9Uw4H5H2fNW0yRcv9D3uni/AVkYGj4LzQcu/aTXA82AIValXn81RKir/DCs
	 EocBsLm6x+wwyyDVh/ub52R4TBbiWG9fx0bqr5HZtcTwvaGYVlckap8ruAvqybPtWO
	 FHsPKfecRPrVrNDulQ5bzLN9HokE6ADfEUeULRkAgoF/HztNhQR9VmqYPhbyj/w4Z7
	 bfY/pkfpMNOb0zW/lo1k8n4Jj1qPG6gh19e6Q4rv9H+sfEcET/qu2i8i51B91dtVHv
	 57VIivK81/YKA==
Date: Sun, 26 Jul 2026 22:23:46 -0700
Subject: [PATCH 4/6] xfs: don't zap the attr fork on repair when there are
 queued pptr updates
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178512389251.1494795.11990651998732898567.stgit@frogsfrogsfrogs>
In-Reply-To: <178512389129.1494795.16117444961252720216.stgit@frogsfrogsfrogs>
References: <178512389129.1494795.16117444961252720216.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that xrep_xattr_rebuild_tree doesn't check for queued
parent pointer updates when it decides that it's going to zap the attr
fork.  This is obviously incorrect, so fix that.  We hold the IOLOCK and
the ILOCK of sc->ip at that point in time, so we can't race with any
/new/ operations.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: e5d7ce0364d8ee ("xfs: replay unlocked parent pointer updates that accrue during xattr repair")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/attr_repair.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index be627ab655ad16..6e6af142f1fb8e 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -1427,7 +1427,8 @@ xrep_xattr_rebuild_tree(
 	 * If we didn't find any attributes to salvage, repair the file by
 	 * zapping its attr fork.
 	 */
-	if (rx->attrs_found == 0) {
+	if (rx->attrs_found == 0 &&
+	    (!xfs_has_parent(sc->mp) || xfarray_length(rx->pptr_recs) == 0)) {
 		xfs_trans_ijoin(sc->tp, sc->ip, 0);
 		error = xrep_xattr_reset_fork(sc);
 		if (error)

