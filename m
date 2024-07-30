Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147C58BF0
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 01:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722301642; cv=none; b=LM8wey076asjmdnDETNsqI6TBHpdBd9b3iFT25MgjkK4kKY+tsEIzDgCr+5DcHGBqGoej22SkqIrtBVN9GQUoCKC9kf+ehftcXQrUQmv+bptsGaHE/a9fRGzsNf1TW6QmrBeis+LjyrzUSCYU/dSGpVMYmh3poB9zyYIrUDN2pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722301642; c=relaxed/simple;
	bh=8m8UtefwAmoeq70hmZKMNubb1EQJy079huBxObUcYUY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WO2XzbwUWEmBW4DSLt+ybGAzYSQupkY3r5W0yWtQTfXvCubk2OWsLIsxpIeRNqSzA+oBGXgwGgLABjqyd+5A8eG3+DA89KfiCx59iiOXYiUnBAC+fzlCZ+lRCfYnNMlXlupIATZVoQnFBn67i8a3FF8IG063irFZxfwNh4RjshM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MQSpBGob; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MQSpBGob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B8FC32786;
	Tue, 30 Jul 2024 01:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722301641;
	bh=8m8UtefwAmoeq70hmZKMNubb1EQJy079huBxObUcYUY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MQSpBGob3VETbiovm6+i7H9aiXftDznIXQA82HGhMZFPu6vxAMQXLJPzHR6WyjWWF
	 xIJCc5Z5CWUB2i2/5V7WgzFVbEm4sfngrHCFdaVibfvNoYTwbV12i8OPqEo6MwP9RT
	 Zga0zxoFiUMCWq+2Yfnk8+K/kzji9P0cVaGT7/9oQqiU6b86r6VTvhmn8LVMqIOm42
	 cSwiEEq7i4eWLW0HKZl2V1VWzBPg/xxLv1X6OGFovQDeDMcufDQLb3obALfajV6Kpf
	 zi6LvKcgBS6TtF/lxQKouWmRYbOeW1/KPlJblPWfdHPmyoM18ASXGSOPrXWnnqWr3B
	 /n+3II9j8Bjsw==
Date: Mon, 29 Jul 2024 18:07:21 -0700
Subject: [PATCH 06/13] xfs_scrub: hoist non-rendering character predicate
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229847622.1348850.4728182139864049922.stgit@frogsfrogsfrogs>
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

Hoist this predicate code into its own function; we're going to use it
elsewhere later on.  While we're at it, document how we generated this
list in the first place.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/unicrash.c |   49 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 32 insertions(+), 17 deletions(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 456caec27..1a86b5f8c 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -170,6 +170,36 @@ remove_ignorable(
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
+	case 0x2028:	/* line separator */
+	case 0x2029:	/* paragraph separator */
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
@@ -349,24 +379,9 @@ name_entry_examine(
 
 	uiter_setString(&uiter, entry->normstr, entry->normstrlen);
 	while ((uchr = uiter_next32(&uiter)) != U_SENTINEL) {
-		/* zero width character sequences */
-		switch (uchr) {
-		case 0x034F:	/* combining grapheme joiner */
-		case 0x200B:	/* zero width space */
-		case 0x200C:	/* zero width non-joiner */
-		case 0x200D:	/* zero width joiner */
-		case 0x2028:	/* line separator */
-		case 0x2029:	/* paragraph separator */
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

