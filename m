Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D931FC127
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D9j3coJd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638E2C433C7;
	Sun, 31 Dec 2023 22:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062734;
	bh=nKffu+9T1bqcOKa9FAe46Z41lEhxCGRwdhuEzd1AdgI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=D9j3coJdBvdDVZ/VvRGQSU+Ted7FHsVboSkxtFLr1JKN7tCnpPammd/hPcHbgqoCh
	 RhI/BOSFGH9Kj2GdMFnLL7FnDhN84PzRo/tvFYjaaunC/K1bN4FWssrE3/yeS0uyYD
	 +THBFbvPfboW0empoAyur5d/yZRicvOd2gzVexRg577oMt+KXRMmJe9lokv/l5I6qV
	 xSxEoGA9YkgA5me34CFU55PQX2P/2Y51lVJ66DE0MacZLp2OIiOzgIn5DOk1JbKzS5
	 eQUmn3Uyb+GJze0JMxpZoGl+kpIPgnjQ9fMwo4S1CtBnWNKzK3WzZAjWAXMjN6djKd
	 xaUgeB5uBAGZA==
Date: Sun, 31 Dec 2023 14:45:33 -0800
Subject: [PATCH 02/13] xfs_scrub: hoist code that removes ignorable characters
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405000610.1798385.14005696099961374125.stgit@frogsfrogsfrogs>
In-Reply-To: <170405000576.1798385.17716144085137758324.stgit@frogsfrogsfrogs>
References: <170405000576.1798385.17716144085137758324.stgit@frogsfrogsfrogs>
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

Hoist the loop that removes "ignorable" code points from the skeleton
string into a separate function and give the UChar cursors names that
are easier to understand.  Convert the code to use the safe versions of
the U16_ accessor functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/unicrash.c |   39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 02a1b94efb4..96e20114c48 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -145,6 +145,31 @@ is_utf8_locale(void)
 	return answer;
 }
 
+/*
+ * Remove control/formatting characters from this string and return its new
+ * length.  UChar32 is required for U16_NEXT, despite the name.
+ */
+static int32_t
+remove_ignorable(
+	UChar		*ustr,
+	int32_t		ustrlen)
+{
+	UChar32		uchr;
+	int32_t		src, dest;
+
+	for (src = 0, dest = 0; src < ustrlen; dest = src) {
+		U16_NEXT(ustr, src, ustrlen, uchr);
+		if (!u_isIDIgnorable(uchr))
+			continue;
+		memmove(&ustr[dest], &ustr[src],
+				(ustrlen - src + 1) * sizeof(UChar));
+		ustrlen -= (src - dest);
+		src = dest;
+	}
+
+	return dest;
+}
+
 /*
  * Generate normalized form and skeleton of the name.  If this fails, just
  * forget everything and return false; this is an advisory checker.
@@ -160,9 +185,6 @@ name_entry_compute_checknames(
 	int32_t			normstrlen;
 	int32_t			unistrlen;
 	int32_t			skelstrlen;
-	UChar32			uchr;
-	int32_t			i, j;
-
 	UErrorCode		uerr = U_ZERO_ERROR;
 
 	/* Convert bytestr to unistr for normalization */
@@ -206,16 +228,7 @@ name_entry_compute_checknames(
 	if (U_FAILURE(uerr))
 		goto out_skelstr;
 
-	/* Remove control/formatting characters from skeleton. */
-	for (i = 0, j = 0; i < skelstrlen; j = i) {
-		U16_NEXT_UNSAFE(skelstr, i, uchr);
-		if (!u_isIDIgnorable(uchr))
-			continue;
-		memmove(&skelstr[j], &skelstr[i],
-				(skelstrlen - i + 1) * sizeof(UChar));
-		skelstrlen -= (i - j);
-		i = j;
-	}
+	skelstrlen = remove_ignorable(skelstr, skelstrlen);
 
 	entry->skelstr = skelstr;
 	entry->skelstrlen = skelstrlen;

