Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42D52F87B
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2026 18:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782324965; cv=none; b=an3B2OX3EK2ZlrosxRXHur70wwXKv0UghZJdJt+ZMEikkSktNtmOqOmcijbgOSAvjAD6Cg9Qo1aioAJnTRyHLAbVBENa8oXnJkjiWgbUI32TIfy8++57NoiPSfmbKkBfvISvJKOuyt159ylwKQgRV4xdGmG/wbyr83NX+QE8Rc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782324965; c=relaxed/simple;
	bh=eqUqn56hJI/d+oxUbPhrcgaQTWn4k7gDRD82nya/FK8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jRD1aBuEtuFlqMacdcObQlwoWWG6v9uYspPEi29jw4gxB7eK3GsLuP+HzJxBNjRScksTs7fTvhJfqQEJqYNzsqV/jp1ybc2F6C46Z2Lw4IwQ067aJI5AjOnIzkTEPLTEXzsQWmfcFuqDw9mBvlrhcdDHaRLPj8oO8yYJ0yyMQjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S/IsDSe8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S/IsDSe8"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BC1AC1F000E9;
	Wed, 24 Jun 2026 18:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782324964;
	bh=BE6pAYEuQlRlNoM0kgVX/gCNl+R+pJgRorKGFCFY3U4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=S/IsDSe8WEoeulKX5vvqORUr80EGLAT8qnCwqZCgInQjEizWz3Vr+CXElk/IniiNz
	 qz4hk5QuT6wSgZWw9PXpuutClnlVlBRM+Hw+BQAK57kmI1WJFNvC6Q9Sus3zndYGUj
	 pQY8mZOwXtpk9glgnuf1D1J8ZizzqbpBfJ1CgXOeC0FU2aJExlwKMfpp5iOOlUKj4e
	 EC0jN/hjrscQOvXKZgAPSuqw9LToikxaU6/QMEt+aziFT746EDF5W6bHthOW1sB4gf
	 pKxLXUkB2WWwKSL+eUMpoJGO+DYeM3cvx0YjA+gGFtK5r6iXRDvGfZobPsQ06I7A6R
	 kh0Qyv/h79Yig==
Date: Wed, 24 Jun 2026 11:16:04 -0700
Subject: [PATCH 06/11] xfs_scrub: warn about incomplete repairs if we never
 get to them
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <178232484549.915780.14963277252337117139.stgit@frogsfrogsfrogs>
In-Reply-To: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs>
References: <178232484383.915780.8675173410074139317.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If the final pass at repairs fails because the kernel says the
filesystem is busy, we should emit this error to the caller instead of
dropping it silently.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/repair.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/scrub/repair.c b/scrub/repair.c
index 5d821655877b80..fdefc2131aa453 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -110,7 +110,10 @@ repair_epilogue(
 	case EDEADLOCK:
 	case EBUSY:
 		/* Filesystem is busy, try again later. */
-		if (debug || verbose)
+		if (repair_flags & XRM_FINAL_WARNING)
+			str_error(ctx, descr_render(dsc),
+_("Filesystem is busy, repair incomplete."));
+		else if (debug || verbose)
 			str_info(ctx, descr_render(dsc),
 _("Filesystem is busy, deferring repair."));
 		return 0;

