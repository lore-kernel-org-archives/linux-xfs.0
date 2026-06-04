Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09452253A1
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 06:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780553264; cv=none; b=D1y9hEyEI49n9fNnzEy88UVNq32bsFlxwTh4j9C01r++kSnieMdlC5zgaiHWWyvquuX66d0s0y6AvzAI68EjMVfUPaGWlORQW3Sk8VW5oe4jSgYNU/VxguSd06MJ21Ig+J1ddc4GeojSRdwUFTEg+J1XwwOKHOLNO8AHb51o09w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780553264; c=relaxed/simple;
	bh=tIJd4WO4/z6SowVndmXtnva5Vnxc9EWOUm/8rJFInnM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GO0oD5phkiFAEdV+dETlAd+wBzFi8s+uAMBSdYYR3koHzISLwIltLxmSaxqcg0YKL4lM6nYBIhwEkwzp5ZccIDvRNPvyiDALCEM4qmakMP9j56WSar/7eqGgzoEE+irmo9vdgfNheHXk7mIn7ARizfS6a7GV4BN+AaV5fzGlgTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gZ06DaIt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gZ06DaIt"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 527491F00893;
	Thu,  4 Jun 2026 06:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780553263;
	bh=osy76UY+WQ1Omi+Qn74kdkqX/ulIDy68VpZzgvOzJbk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=gZ06DaItgyGz0DfNbD5n7qex5NyRIvDeObzcqERiQfKMGSB2dZfnBM2hvqp+dRKxK
	 5VUgad0Zm6odBJ06QdkmXr7rLOzHWnr/J/W4dA7d7dSuxtUWA7YJ+WU0APoKnpsE/R
	 VxzJxeSKan3oVh1CrnHjH92xrcZIv/EiE1luxIKcLOgkRE6NURkaS9ZAr2Rg9wGOrZ
	 sjaesy8iGXqOBe8Cs1X8I/U1hfG27DJh7DCXpICifzosC2hktRyQcL0KzWi5tZq5d9
	 aAFQSRc3HreiHnsm2VlXwhAVvssdjyOvnyb1L1lBd4Wab+BFwtk4PzXs7dQfiUhToj
	 9sAmBM5vciL/A==
Date: Wed, 03 Jun 2026 23:07:43 -0700
Subject: [PATCH 13/21] xfs_scrub: don't allow NAN as fstrim percentage
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <178055303346.2608728.5900831081865002391.stgit@frogsfrogsfrogs>
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

Don't let users pass us -o fstrim_pct=NaN, because strtod will happily
return what looks like success but isn't actually a number.  Codex found
this fun little nit.

Cc: <linux-xfs@vger.kernel.org> # v6.10.0
Fixes: 34bed605490f93 ("xfs_scrub: tune fstrim minlen parameter based on free space histograms")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/xfs_scrub.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 383aa8752b2ce7..9e73dac92e0502 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -7,6 +7,7 @@
 #include <pthread.h>
 #include <stdlib.h>
 #include <paths.h>
+#include <math.h>
 #include <sys/time.h>
 #include <sys/resource.h>
 #include <sys/statvfs.h>
@@ -683,7 +684,7 @@ parse_o_opts(
 			errno = 0;
 			dval = strtod(val, &endp);
 
-			if (*endp) {
+			if (*endp || isnan(dval)) {
 				fprintf(stderr,
  _("-o fstrim_pct must be a floating point number\n"));
 				usage();

