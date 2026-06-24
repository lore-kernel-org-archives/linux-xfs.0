Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D583DD856
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2026 18:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782324903; cv=none; b=KdroYG8OWbLHPIBR/jtd+2PgDb9VYCaB5Lpuh+4qfL70peKZ8dNpwA8R9aCgscVT3aPbeOuDX96ruVLitVxlrqA2HOBqZDfF0F9nCJ3h/L/gtKGkJsM9DfqBdqgntVLQbMUvKAPUxckMpIhPovUu6pAAILS1qF0ZQacabY0pzao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782324903; c=relaxed/simple;
	bh=GhSynYfgXy6FOkG+OQPW4CSknuy7DXHzzTyO3GxTnBk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UGTRMjClW1tUXAGIBpqD92G4yZAzckbbzy0n8flROaDQ6AyEkiJPYhwfLtQ0rNYo4vZY2FbwMC4SbA57kqP8M6cg088sXIICnFKPnmQsPa7w6rYlRB+ky/rlU0f/GTHGLTIqOY8bCRz4/msyF8s3tk4SKxYnIiGg2KjFQ1t/4KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bJvJSBCH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bJvJSBCH"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A2FFB1F000E9;
	Wed, 24 Jun 2026 18:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782324902;
	bh=ijwH98WiFX8LT9GuJsbqb777AkOFm2X2dO4v+VkktOc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=bJvJSBCHonNYyWCA+yf8Jq0OmDLoTBNVOUURh2vT+sVOE/NtrXNLdSQvSDol8DDbK
	 CprUL3Gpo+HJZj7XeoRx3yu8ZIdUp72jCNTp8+QoDAPQ3Wtztx9hJWzL49Hr80ZA33
	 cykyX9PtnFrOt9kdFdKg14zXSlaVmzdqrEf8nMLLGbEA6Ls9C4gVrklaEtRypr7WyF
	 U01ySbcnW2lUpCsoLR4UYNRYfILcaYxiYDaKlc1eYRPmwYrTbYEKmJd8n699h2wgb4
	 7hAoOJvkHMzRgEZXcNs+sHfg7gZX2lOP1AWd8/d86g8E+KPjsEUJCS2jMgvvHs8cQn
	 BNTlw6XaRhvrw==
Date: Wed, 24 Jun 2026 11:15:02 -0700
Subject: [PATCH 02/11] xfs_scrub: report bad file ranges correctly
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <178232484475.915780.7341195187302132752.stgit@frogsfrogsfrogs>
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

Codex complains that the "media error at data offset..." message prints
the wrong information -- err_off is the offset into @map, not the file
offset; and the length should be constrained by the end of @map.  Fix
both of these issues.

Cc: <linux-xfs@vger.kernel.org> # v4.15.0
Fixes: b364a9c008fc04 ("xfs_scrub: scrub file data blocks")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/phase6.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index cd9bb26bf88628..2278ae5ad3dfd7 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -408,6 +408,7 @@ report_ioerr_fsmap(
 	char			buf[DESCR_BUFSZ];
 	struct ioerr_filerange	*fr = arg;
 	uint64_t		err_off;
+	uint64_t		err_len;
 	int			ret;
 
 	/* Don't care about unwritten extents. */
@@ -476,9 +477,12 @@ report_ioerr_fsmap(
 		return 0;
 	}
 
+	err_len = min(fr->physical + fr->length,
+		      map->fmr_physical + map->fmr_length) -
+		  max(fr->physical, map->fmr_physical);
 	str_unfixable_error(ctx, buf,
  _("media error at data offset %llu length %llu."),
-			err_off, fr->length);
+			map->fmr_offset + err_off, err_len);
 	return 0;
 }
 

