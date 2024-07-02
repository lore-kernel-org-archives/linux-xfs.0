Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182F58BFA
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881860; cv=none; b=ChkJj0lsokll9MuUhySiVBIRMA7/ddygmeNh17ioevgBeXzY6R22hw6JjdLjEdddRB4b7ZfynudkrJ8Xg1RMQj2EFmsA/zU+riR3wuUtmiIbVBeA2okUfEhXLvTjYH99M87np6LEKPCvTilEi13oxtNASXPCXAcXsxw2os4phfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881860; c=relaxed/simple;
	bh=iCcFMo6fWukrZ6J4PQcFMGrS+nBMFsKBll3FoLG6mfg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RArAQaDMqPTw0nLhjyHBJQEWoxrVAQFUVueOzxEio94zOlCih7YLuZZ5zoYQRi1NUd91NgARC+NxjQoD/DNJwdS/Q0VatoD9AKNhW86Lmg7GYXrHC1UHDKkDcJsWgZ4QFsHcDbD+xtymKONiv7iE7fOxZv0PWCpKX/fiYoHbzOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GS3lDxYz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GS3lDxYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D8CC116B1;
	Tue,  2 Jul 2024 00:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881859;
	bh=iCcFMo6fWukrZ6J4PQcFMGrS+nBMFsKBll3FoLG6mfg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GS3lDxYzHsB8PyrzSgrMWTZUTdjlH4TfdBa/mnfRMQLZxZZErSysYIg2kOjdDW7IM
	 xKRwp+zU5Z6ayRnMUYdbJPopFW++tq9AG6H8aBKD5eskjxJaZTfi6MhBJj8WtQRpMo
	 43ll79/x37OHzfZO5WV4Oeg/Uk1l9za0vJJfPuEyGFhAQFKC3bjPspzgRhFkiFVILe
	 ISZnEYfV55fv8MeZtDs7y18VMYye47UO++G/6I4maiM0tY3pAeEhiZHfXtylVk5O97
	 iXYTjSzEtnQw0jv+OM1ZBVOVDz0Rct92bbCaB5ysGv39+EW285jUfxYoT+YHy01DaF
	 iYwqtI/K3lsDQ==
Date: Mon, 01 Jul 2024 17:57:39 -0700
Subject: [PATCH 01/13] xfs_scrub: use proper UChar string iterators
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988117626.2007123.198416706338315744.stgit@frogsfrogsfrogs>
In-Reply-To: <171988117591.2007123.4966781934074641923.stgit@frogsfrogsfrogs>
References: <171988117591.2007123.4966781934074641923.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

For code that wants to examine a UChar string, use libicu's string
iterators to walk UChar strings, instead of the open-coded U16_NEXT*
macros that perform no typechecking.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/unicrash.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index dd30164354e3..02a1b94efb4d 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -330,13 +330,12 @@ name_entry_examine(
 	struct name_entry	*entry,
 	unsigned int		*badflags)
 {
+	UCharIterator		uiter;
 	UChar32			uchr;
-	int32_t			i;
 	uint8_t			mask = 0;
 
-	for (i = 0; i < entry->normstrlen;) {
-		U16_NEXT_UNSAFE(entry->normstr, i, uchr);
-
+	uiter_setString(&uiter, entry->normstr, entry->normstrlen);
+	while ((uchr = uiter_next32(&uiter)) != U_SENTINEL) {
 		/* zero width character sequences */
 		switch (uchr) {
 		case 0x200B:	/* zero width space */

