Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631113D1ABE
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 06:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780553342; cv=none; b=IC3wkNhmT9DomvfOSwQ1sxf1bNMd9AUDSY0FzBUKbJFPmRxB3NncM1RzBQL/DoriBkMf3F9NxIOOW4iewU1Xok/Ayv0TDXLeyNjqurQE+fA0/VyBjb4qYfC722UfSQpDAepY29GAenIngqrOWvGOvnK6TIO123C6xv1Dek+uYVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780553342; c=relaxed/simple;
	bh=AqVZrqssLL/vg6FSsZm+0VHwvSQ2FpSjTlqf2QAfeVM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c4isaF7KnKb7vdlMdBTYIfdu86veq58cHUBxUgUAJBWDm/paDGDSel4Zsvc/ToMhX+iiYduIcDzKpJl5U9hcy2zpDr8giTaa+/d0MUKgwZvHN3ohDoub05dWHuZ3lQ9iFCKiPtfItFsK0Jjra5eiBgRYDCr4WnD7OgYiU+hry5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S3YgN5j6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S3YgN5j6"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id F00E71F00893;
	Thu,  4 Jun 2026 06:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780553341;
	bh=sDYr3KN0Lb+DA3IjiznBp5HbliaPnRhh50B0QDr99dU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=S3YgN5j6KbpyB0YKABYef8cURIlFvsJb5eY5tkD7qCZh/EWrNs/3ttrWS3SRBVydM
	 0eTtF6mI0eztygYjwypsRfpwnawM/CZcZJSHPOXAJG48Ll4L5buOizOmlkcvTHVqvc
	 xOaggphIdhAd8MLoFjlRkRa9qzgp2k2wxVAqXX6vT3ZXn/8VyGRc8XACRpGApkbcE1
	 JaexuHS1COg65yOY+6Arlv1vhU90fPq2RF2Mv5foYpwOC8zali5BwOp2r+8js4f+Px
	 BDdvSys15dHGl5OK5rw7FMn5VnWpdol5AReP1aWDo9SkxPr1lSshIT09WLrC0roqfn
	 dsjDxz5U6MqOA==
Date: Wed, 03 Jun 2026 23:09:00 -0700
Subject: [PATCH 18/21] xfs_scrub: fix inverted return value from ptvar_get
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178055303439.2608728.1431031580963210398.stgit@frogsfrogsfrogs>
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

Codex noticed that this callsite to ptvar_get got the sign of the error
code backwards, unlike all the other callers.  Fix that.

Cc: <linux-xfs@vger.kernel.org> # v6.10.0
Fixes: 4f4d99615d2377 ("xfs_scrub: improve thread scheduling repair items during phase 4")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/phase3.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/scrub/phase3.c b/scrub/phase3.c
index 046a42c1da8beb..93900fb813e489 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -68,9 +68,9 @@ defer_inode_repair(
 
 	alist = ptvar_get(ictx->repair_ptlists, &ret);
 	if (ret) {
-		str_liberror(ictx->ctx, ret,
+		str_liberror(ictx->ctx, -ret,
  _("getting per-thread inode repair list"));
-		return ret;
+		return -ret;
 	}
 
 	action_list_add(alist, aitem);

