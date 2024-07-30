Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D28110E3
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301579; cv=none; b=RCZMoTQecvJQHkaHnzFh1m0VoZbSvJyhch9Kl4SwGb1S7SRPKYsfWN+2HsAZhGIEM8jgmw5u82XfPHEE7nm265fMR4o+tK5F1m6FErX+MVmjV7Fr/890iIqYxOZ3mc6oetjZptcDQ21B8Uh9gyZDeNHfPNJeaXYbqIh09RRG+fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301579; c=relaxed/simple;
	bh=MkoONVRwz64FQqQTIhCGD7I7WiyVqX90RiC4rWsyR6c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DhMNHNB66588Am5MP7dhh90948h+SDEjjsY8qcqA+2+UIRkFGFArrm3RlHpxU6nFCBCPmgV86dqXZROqKRk5AFsblrlhGP4xRrCdCT34TuUtYC2UhdjewTebwJGoUK7JWbKaNBSZ50gt26lNvJBh98sGDS28hACPOVNLKUQ63TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HUi+31jf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HUi+31jf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512CDC32786;
	Tue, 30 Jul 2024 01:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301579;
	bh=MkoONVRwz64FQqQTIhCGD7I7WiyVqX90RiC4rWsyR6c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HUi+31jfS5JK0pHLg2pHzd/fUeNum7lh4hwFGxbKrJ+ibEaGxMiGIPq3Uo9gaEoCg
	 WxAmKy3j/Loyi9uG7fKsE7yHsZh9A9pk52aMWo8W1I79Exz1gZiRrgHSlgh0QcitbH
	 Dmx0ocPZG5dlBZraJifHYaUodrRYCtYBcmqFzdCuY61N0780bKnD1ED+YScCeeqULx
	 I4lxZL9oEvVGFH/A97u16NEJF2pthaR/+AP1tVZd/1/iyCD6vxQAPjs4wsY8KInLSF
	 e2ixXOgrXisf+a4fNRzLuF4NdYcblHiJMVQ5tI17vqQYFgMevMYq+UEjrncYJBUXra
	 WC0MjXRv2OYjQ==
Date: Mon, 29 Jul 2024 18:06:18 -0700
Subject: [PATCH 02/13] xfs_scrub: hoist code that removes ignorable characters
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229847561.1348850.2823932170105684878.stgit@frogsfrogsfrogs>
In-Reply-To: <172229847517.1348850.11238185324580578408.stgit@frogsfrogsfrogs>
References: <172229847517.1348850.11238185324580578408.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/unicrash.c |   39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 02a1b94ef..96e20114c 100644
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

