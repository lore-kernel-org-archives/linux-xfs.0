Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3CC17E0
	for <linux-xfs@vger.kernel.org>; Thu, 18 Sep 2025 19:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758224918; cv=none; b=FEsNFWHpG6pVGH6PEZ1F2rgn9yuYt4XRytxyd+Le3mQnDPNDfQWqc3nucAQJxMV/4mWcUan2e6oLc8j+Y+xBG6bIPjBkzv2TSVIB6fHg+j7cHvV5loDRT9P/3zG+hiRQ0ZuoYsElIoi7WOAd5yMeRjGlJ4BAN+SXTMpBSBDb8D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758224918; c=relaxed/simple;
	bh=Q8y8EcpCbScouZu5NKPwN9Qle0DM0TWqg2OpymrTukw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=hEXouSSB/HDcuTCe28z4fnnbwLmUDc6SVRp1tl/pAB39h028LwWkcszlq1AYSlKPfAUf0N0IvrAuj6vx+NMr1gCS4JtrMnW95KbqjIl6pNfTJW7W1nLSKD/XguHNV5MoGOgpiV5qdyY2/YneGe67iqLmflFcYS5vKV+X+a+C2Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LT1rMoM+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LT1rMoM+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C62C4CEE7;
	Thu, 18 Sep 2025 19:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758224917;
	bh=Q8y8EcpCbScouZu5NKPwN9Qle0DM0TWqg2OpymrTukw=;
	h=Date:From:To:Cc:Subject:From;
	b=LT1rMoM+gQ6PvImY9zORsrNW111Oyh0c4aAkuBbdN5i9RoFB1/Jxj6/q7Gg4XOGLe
	 3J13GlmUjngXSREYHLEulZJ9McdwlFgM2eRhk9DoOUita01R5I5OfKtNYp5qaQikfn
	 7NgUjNN87XKOM5bpiNKjUZGXEaT1G9cZz5CIqdFUqjz45DC2wOWsk+ImWFDBgQqHnS
	 /n65o/mgxbxFdIZz/JhUqRfNTdRdlMjm9ZH8KK5Ccj3rRn69Wy/Q5JlvFeml5GukjG
	 h4D13T1cJI0G89BA6hbjVZQuArkNCdQhGWXSkCP73tGFucJWCFJyVHt0WZ6XbkwVXt
	 spCRxI9kOQBlw==
Date: Thu, 18 Sep 2025 12:48:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: "A. Wilcox" <AWilcox@wilcox-tech.com>,
	Andrey Albershteyn <aalbersh@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: [PATCH] xfs_scrub: fix strerror_r usage yet again
Message-ID: <20250918194836.GK8096@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

In commit 75faf2bc907584, someone tried to fix scrub to use the POSIX
version of strerror_r so that the build would work with musl.
Unfortunately, neither the author nor myself remembered that GNU libc
imposes its own version any time _GNU_SOURCE is defined, which
builddefs.in always does.  Regrettably, the POSIX and GNU versions have
different return types and the glibc version can return any random
pointer and ignore the buffer, so now this code is broken on glibc.

"Fix" this standards body own goal by casting the return value to
intptr_t and employing some gross heuristics to guess at the location of
the actual error string.

Fixes: 75faf2bc907584 ("xfs_scrub: Use POSIX-conformant strerror_r")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/common.c |   27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/scrub/common.c b/scrub/common.c
index 0a5970f9c066f7..030beadb1767fb 100644
--- a/scrub/common.c
+++ b/scrub/common.c
@@ -126,8 +126,31 @@ __str_out(
 	fprintf(stream, "%s%s: %s: ", stream_start(stream),
 			_(err_levels[level].string), descr);
 	if (error) {
-		strerror_r(error, buf, DESCR_BUFSZ);
-		fprintf(stream, _("%s."), buf);
+		intptr_t res;
+
+		/*
+		 * GNU strerror_r returns a pointer to a string on success, but
+		 * the returned pointer might point to a static buffer and not
+		 * buf.  XSI strerror_r returns 0 on success, -1 on error.
+		 * Magic #defines influence which variant you might get.
+		 *
+		 * The build system #defines _GNU_SOURCE unconditionally, so
+		 * when compiling against glibc we get the GNU version.
+		 * However, when compiling against musl, the _GNU_SOURCE
+		 * definition does nothing and we get the XSI version anyway.
+		 *
+		 * To handle all this, we set buf to an empty string, and if
+		 * the function returns zero but buf now contains a non-empty
+		 * string, we assume the XSI version and print buf.  If the
+		 * function returns a positive value, we assume that's a
+		 * pointer to a string and print whatever the return value is.
+		 */
+		buf[0] = 0;
+		res = (intptr_t)strerror_r(error, buf, DESCR_BUFSZ);
+		if (res == 0 && strlen(buf) > 0)
+			fprintf(stream, _("%s."), buf);
+		else if (res > 0)
+			fprintf(stream, _("%s."), (char *)res);
 	} else {
 		va_start(args, format);
 		vfprintf(stream, format, args);
