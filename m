Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB302378D9A;
	Tue, 15 Sep 2026 05:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789450673; cv=none; b=Sybnm19/D/s8acz19GmY0jkA0rSBEy63TrEWlY2n+zqrBSpjyT1dPYcTYekFXp/my9PRaU1TNrcmYkVd6zuevrj/+rN7oqNUqnctknIpVbEk2gx1R9Y7ode96WB48ZOOA1xVOYzV5fqR8Pix/4j1aQYy/UGQ/j1TLX5wJGet+uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789450673; c=relaxed/simple;
	bh=qrS7Y3rFyE3q7IuWqOENiHke224Lvyu0419XUQxrhxg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RvuOnxoxy4xdq5TjxZuL1jq3DPyFlm+hKeHWtfkI6yfqKJh3QVjawSekawHxltjeJRN48pHZ5ZB1tTNIG4/beQU9UDMGohMq/PhwMJWoJeIYOMfZ+JUW+3uZrsAmp+TBtUTXUbRsmfUiNsOFO/5S4vRTN71nuAS7LBUS8cnR8xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kJx0Fjfp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kJx0Fjfp"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 827AE1F000FF;
	Tue, 15 Sep 2026 05:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789450672;
	bh=rF3YlF8gIzwjhlycyp1E/3Uz03qEgwwPBX49na7vSBM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=kJx0Fjfpjm4kjyOKG/pRz7+5pa0ElGKRuTqTIfy6a3igYYRh3292grwW1C00uepy0
	 O9W7gd0OnN63xchx2QOobNUQepD+i7RoiiwgxXeMrJt1X1pzJoXeNVKTssAaiFdtD8
	 JD1HgAnIBweEB3CTjPAFZMT7QfoCzNahvZ6vYc0O8k1RaoLlhIN4DEXaUszVUe1p9g
	 eWjT1dKjYPLyIIXff9dMru9iI4d4VSFD8/P5Wn0eO3O6SAoSqrhcQDbn24JomGlP9L
	 /h/9Q9MKgVINQmqeYvOLpwgKhot6QVenzSs0/sqtHyAnybFzFn9ETqX7nxlgVAvK+o
	 roJ5AFj58H4BQ==
Date: Mon, 14 Sep 2026 22:37:52 -0700
Subject: [PATCH 05/11] xfs: don't let memory failures leak blocks and kill
 repairs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <178945048606.3061055.5801413647504627346.stgit@frogsfrogsfrogs>
In-Reply-To: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
References: <178945048435.3061055.16384804993810925544.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM complains that a memory allocation failure in
xrep_newbt_add_blocks results in online repair leaking blocks that were
previously allocated to write a new btree, but the problem is worse than
that -- a limitation of the codebase is that the callers cannot undo the
transaction /and/ return the error -- either you undo all changes and
commit the transaction, or you error out and the filesystem goes down.

However, the new btree space reservation object isn't that big (~48
bytes).  Let's just do a NOFAIL allocation and the problem goes away.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: be408417630427 ("xfs: implement block reservation accounting for btrees we're staging")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
---
 fs/xfs/scrub/newbt.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
index c82f4631fd9c27..584076b2a6eed9 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -193,9 +193,11 @@ xrep_newbt_add_blocks(
 	struct xrep_newbt_resv		*resv;
 	int				error;
 
-	resv = kmalloc_obj(struct xrep_newbt_resv, XCHK_GFP_FLAGS);
-	if (!resv)
-		return -ENOMEM;
+	/*
+	 * We have no way to clean up the allocated space *and* return an
+	 * ENOMEM if we fail to allocate this control structure.
+	 */
+	resv = kmalloc_obj(struct xrep_newbt_resv, GFP_KERNEL | __GFP_NOFAIL);
 
 	INIT_LIST_HEAD(&resv->list);
 	resv->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);

