Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD525B64A
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881875; cv=none; b=twPZF8CVigBiPDdwgiayscKGT6zr1mJYMemtx+/xu/hCVJYYHcIt4I/GqVW6T/X2ecHJKB6PZJzZBIuA2RnUFftpqw2yG8v/A9SMTmm78/R4+JT6mNMOrxtLcONRKPBaBhBnNDXvSLXnbNcKwiBRxhNwZA2w0koZ6KXaxZqqqK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881875; c=relaxed/simple;
	bh=zpTiJcFsD+BEDekhMsOMexU6hmx0q6T3DJEJVUI1HFs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t7LaIrEjfMXaL4vJEbkzURyx6rvDIw4QnJgqwPsc6SX/3eFPfosL0IuXz005R826Fo7ewZjtIPcTIdaVyrr4epw5TFbHho/h0nEaigPMY1Ja7CcHtlr95Fuf46kyazJ6C/lGo8VlI420Jh9SppQ8CpjSbU991NMtL/S2JEaydis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ew3K95vH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ew3K95vH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E03C116B1;
	Tue,  2 Jul 2024 00:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881875;
	bh=zpTiJcFsD+BEDekhMsOMexU6hmx0q6T3DJEJVUI1HFs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ew3K95vHxMbdLV5KPyvl3VPF4f63NjUNhgs5fsnob5wNYBBrJtkGXGVpky84u5AXU
	 Ytg41l0PKPzzR8ByGFdwr/ywZg4nrLSO1TeAHPGgjYGEM0O1NJa1otyUV95sSOWcMc
	 iLjJJ5eweEzBICNP+fCJIYEe7tGcxgA6Vy4i1ibrcA7apqGwGVg/BvjylleDoLxUcn
	 aJtSa4dwgXlXB19l1lkrBlEwcfxZDTjfdnec3tPiItLKTQm3IdIhv7ItRM4yE49PGH
	 8hWjc7TYcjUuPYcN+sHoG/YUwFvDXEDVH1YO1gjsFopGyRNlQJgg+WYWFKR6d2XUxF
	 Xrmd1XG4W3wcA==
Date: Mon, 01 Jul 2024 17:57:54 -0700
Subject: [PATCH 02/13] xfs_scrub: hoist code that removes ignorable characters
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988117642.2007123.7226044391521696300.stgit@frogsfrogsfrogs>
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

Hoist the loop that removes "ignorable" code points from the skeleton
string into a separate function and give the UChar cursors names that
are easier to understand.  Convert the code to use the safe versions of
the U16_ accessor functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/unicrash.c |   39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 02a1b94efb4d..96e20114c484 100644
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

