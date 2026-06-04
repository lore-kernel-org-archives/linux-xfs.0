Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4147E3B993F
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 06:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780553249; cv=none; b=hutWLJFSKtufUPGyNpSSMLldS7PkYlp2MI3gVp8pXStdIGDHrzHX4KWU6ZCHwtcW593fkZ6Yp7uBDX1dzvIzKGEsJjvIdJ2qAlgBJlpiY+z7xYmAEHullBMsE+xKE37S1X4jQfgfWuCVSpj7TqMqt5bD4hjmmbiqHk+Im3QwuzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780553249; c=relaxed/simple;
	bh=1eJ7cUz6PiqKZarv43HYDjJzrO7gUtFzyDIio2OW4GU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y8ciM0FjIONE95srHd7+dwvTdXfe63H4FB8b30Bd8t3pR1y2NK6GWQkSKOh8DEqnYVargCvXNogvMlPcyCP+H9R8xTvbO2AYiyQY5vNN9kp0K0aOVHrM+vvSnntXd8ev6hUDYXufCmSWF8VAUIPNGtu5yU6+utImsOMKe+HX/RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R9npld39; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R9npld39"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C5BC91F00893;
	Thu,  4 Jun 2026 06:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780553247;
	bh=1oqonxAdxjWpXssVIAVhDr+krRK3+v2736ccycQii5s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=R9npld39idxAVwJeVB4Y0ccE6azr3Rn39bzlFI3f1YhNFFDbEvbLWWd7t9Geh+KPZ
	 P/KhmDBLXUak3mAvAV8HC1fGO6E2QGwtUfkn8jZx+W4QzfTntrvpTngtTOMswWFK8s
	 0x4Mj/L9nuFEi3kJtI8UU+arOcE6wGA+1bqOXoVhKn8uTabRobfI1L0kBYuQYFK90O
	 ygpG5ezaK6HibRm4f2ZEzjxGuOzTRkF4iP/EhFKsOO5A5UqEK6QR41P2AoPWErvHrm
	 F3fcGSkLz9X+7ZLiMom8LttCZak3bCSFJUvI7kvjH5PeDlFMbUtuy9NXOiO/+xuSX3
	 347Y9j6vXFztQ==
Date: Wed, 03 Jun 2026 23:07:27 -0700
Subject: [PATCH 12/21] xfs_scrub: fix nonsense advice after a scrub finds
 errors
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178055303328.2608728.18278071862274653584.stgit@frogsfrogsfrogs>
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

If a user ran xfs_scrub -p (aka optimization-only mode) and it found
errors, we advise the user to run without -n.  That's silly, because
they didn't run with -n, they ran with -p.  Fix the messaging here.

Cc: <linux-xfs@vger.kernel.org> # v6.10.0
Fixes: 84e248f3e83f36 ("xfs_scrub: add an optimization-only mode")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/xfs_scrub.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)


diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 80b56f8baef611..383aa8752b2ce7 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -610,12 +610,20 @@ report_outcome(
 	 * are not corruptions.
 	 */
 	if (ctx->scrub_setup_succeeded && actionable_errors > 0) {
-		char		*msg;
+		char		*msg = NULL;
 
-		if (ctx->mode != SCRUB_MODE_REPAIR)
+		switch (ctx->mode) {
+		case SCRUB_MODE_DRY_RUN:
 			msg = _("%s: Re-run xfs_scrub without -n.\n");
-		else
+			break;
+		case SCRUB_MODE_PREEN:
+			msg = _("%s: Re-run xfs_scrub without -p.\n");
+			break;
+		case SCRUB_MODE_NONE:
+		case SCRUB_MODE_REPAIR:
 			msg = _("%s: Unmount and run xfs_repair.\n");
+			break;
+		}
 
 		fprintf(stderr, msg, ctx->mntpoint);
 	}

