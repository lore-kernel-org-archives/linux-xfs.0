Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCB6C13B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hemBGUef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0058C433C8;
	Sun, 31 Dec 2023 22:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062796;
	bh=x7o2pgvaAKMbZt+suSV+9uQO1cWeBGl+XLlC1EvBiVo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=hemBGUefGUEqLBukF2AqdfuxJT0dfq+vrRIFaZF9J4N0fHe7ERYPVVYBEV5ZrmRX5
	 BVxt/3UVwddS3sTJWtUWMvW+Eodqavwbdp+J7WHvsruYQxqahkefpqNDiL2cUar24V
	 YkWg3WFGGzMyUtUz+DnSi9OGkStKVZMRV7UqYT5Qse3lSNY6y4VzenGtqkg+tRbzdq
	 ALu2BESBcdBfRfTERtrEoKR1E+PAKVEyxYOmBkxQ/7KPuyZLp+84UysqM0h05A2CGZ
	 5W16q2/hqirC0xnW1ORe5EjCNFac1jT5lYOcucZ4nwj6J3pCdImek5g8MJFQUhUCWq
	 m3u4nYUWDivoA==
Date: Sun, 31 Dec 2023 14:46:36 -0800
Subject: [PATCH 06/13] xfs_scrub: hoist non-rendering character predicate
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405000662.1798385.8987337588466137685.stgit@frogsfrogsfrogs>
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

Hoist this predicate code into its own function; we're going to use it
elsewhere later on.  While we're at it, document how we generated this
list in the first place.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/unicrash.c |   45 ++++++++++++++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 15 deletions(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 1c0597e52f7..385e42c6acc 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -170,6 +170,34 @@ remove_ignorable(
 	return dest;
 }
 
+/*
+ * Certain unicode codepoints are formatting hints that are not themselves
+ * supposed to be rendered by a display system.  These codepoints can be
+ * encoded in file names to try to confuse users.
+ *
+ * Download https://www.unicode.org/Public/UCD/latest/ucd/UnicodeData.txt and
+ * $ grep -E '(zero width|invisible|joiner|application)' -i UnicodeData.txt
+ */
+static inline bool is_nonrendering(UChar32 uchr)
+{
+	switch (uchr) {
+	case 0x034F:	/* combining grapheme joiner */
+	case 0x200B:	/* zero width space */
+	case 0x200C:	/* zero width non-joiner */
+	case 0x200D:	/* zero width joiner */
+	case 0x2060:	/* word joiner */
+	case 0x2061:	/* function application */
+	case 0x2062:	/* invisible times (multiply) */
+	case 0x2063:	/* invisible separator (comma) */
+	case 0x2064:	/* invisible plus (addition) */
+	case 0x2D7F:	/* tifinagh consonant joiner */
+	case 0xFEFF:	/* zero width non breaking space */
+		return true;
+	}
+
+	return false;
+}
+
 /*
  * Generate normalized form and skeleton of the name.  If this fails, just
  * forget everything and return false; this is an advisory checker.
@@ -349,22 +377,9 @@ name_entry_examine(
 
 	uiter_setString(&uiter, entry->normstr, entry->normstrlen);
 	while ((uchr = uiter_next32(&uiter)) != U_SENTINEL) {
-		/* zero width character sequences */
-		switch (uchr) {
-		case 0x034F:	/* combining grapheme joiner */
-		case 0x200B:	/* zero width space */
-		case 0x200C:	/* zero width non-joiner */
-		case 0x200D:	/* zero width joiner */
-		case 0x2060:	/* word joiner */
-		case 0x2061:	/* function application */
-		case 0x2062:	/* invisible times (multiply) */
-		case 0x2063:	/* invisible separator (comma) */
-		case 0x2064:	/* invisible plus (addition) */
-		case 0x2D7F:	/* tifinagh consonant joiner */
-		case 0xFEFF:	/* zero width non breaking space */
+		/* characters are invisible */
+		if (is_nonrendering(uchr))
 			*badflags |= UNICRASH_ZERO_WIDTH;
-			break;
-		}
 
 		/* control characters */
 		if (u_iscntrl(uchr))

