Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B603B19A5
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 06:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780553389; cv=none; b=asfOgtzSp4mFQeiomHZf2mRValVnhV/Ioe1r56wtNYc+EgrKPLcTBskMyNQU9N9Kuuas2iIUEizpw6KU2slIWj/3ZSJyKH151hDkCs7kLl5QeSqI9eXxafCW8uJKdM+74CWjiCJHzyYmrfPowsi0n9hpg2TyBB9HRV+aVczoV1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780553389; c=relaxed/simple;
	bh=RRcP7QuDfIwPLddj0Tr80jO2J09mjQfJlwUXtEypv0g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LdK7p4GrFHkhokoIxIleCJINC2UVAoCX+vnS4c2E11wuUXNgPnNGXrx/trM8lPNYo9F+CoT9ZZKCHJzAPb1+Y1tWtH1ePsYzhnZoN/crOwLnlbSQWKNQM2Pp8aRd4gHX70k5f+QWMEziTUj3UMXLyMh0udczZy83CNc5AgFVXjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ao0EZdd8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ao0EZdd8"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BFDC11F0089C;
	Thu,  4 Jun 2026 06:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780553387;
	bh=zfE+7Y5psGYRNgHcaFlMLzB61v9GXRXG7ZFOCz6TzhM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Ao0EZdd8TaSqZg5AWLLEKf6DKxlY0NbR8gGFxgdjQd8kuN5KWH4p4Jsi10lTbB9D1
	 g5aSAoOf9mxCYQYYg0PyhJfza06NYZ+R9fw32ktm/D+HKaF7O6IUlZ3Uk4yoaEnY6x
	 lyVHq3jJhM7b+GT1r2zPjJPJKfqSZo4f8pfRcWg+S6C9jVC6kDiw4gHg+AlwYi1DTF
	 PK1hua9099YBrdAvagE51BgIzdzDUZcSh5nHwv7pgdR/k5uUbMCEEbSsI4mgmn04lE
	 K0C3CHMdPPw0KD0IacH9WF1GR0xqe8ET2Uh1A1yD2+vllqCi7lHY0C5hpIisWbRaiv
	 MDh8UHWMex+dw==
Date: Wed, 03 Jun 2026 23:09:47 -0700
Subject: [PATCH 21/21] xfs_scrub: read verification isn't ok if it hit runtime
 errors
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178055303495.2608728.18446230939962684059.stgit@frogsfrogsfrogs>
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

Codex complains that a read-verify pool couldn't possibly be ok if
someone set the runtime_error field to a nonzero value.  That's true, so
fix the predicate.

Cc: <linux-xfs@vger.kernel.org> # v7.0.0
Fixes: 58fca77c2d2ae8 ("xfs_scrub: move failmap and other outputs into read_verify_pool")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/read_verify.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/scrub/read_verify.c b/scrub/read_verify.c
index 7dd588c1482af5..01e96f5bef40f6 100644
--- a/scrub/read_verify.c
+++ b/scrub/read_verify.c
@@ -557,7 +557,7 @@ bool
 read_verify_ok(
 	const struct read_verify_pool	*rvp)
 {
-	return rvp->failmap == NULL && !rvp->truncated;
+	return rvp->failmap == NULL && !rvp->truncated && !rvp->runtime_error;
 }
 
 /* Did the verification unexpectedly stop early due to short reads? */

