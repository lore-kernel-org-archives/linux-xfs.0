Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4587BE5A
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 00:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719881937; cv=none; b=CZkDsXQw9cgbSLHn6MUt6mv5usJRDzcW15tgtI7sFvMPVZMQzp9BnWg84bs55t06hn+3cPITmP3puzQjvrZjgpPmvcxwF0Z95t0lutG05tyURbdhpFy567EdF3w6B7PiL9UVwGwPAhO/B6CyJfE/c80oBbvmtFJkOuBs+Jy0TJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719881937; c=relaxed/simple;
	bh=3h3Uwwu33ZxJiTqvJdLSfk6QE4PSNTuBz1LcGHbtOGA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GK11wXmTMiZjE3ClRthzemVx7mjEas4JjLSVVp4+J5/rTWuHK5thAWXqbm1/NfRX9Yv8P0gndZtG4VSTyGCw0kdkHTd4KDbNA5zQX62V4o1ezRpF1mbyciWvUKk8S1jsbun7xptekHnlAhVm4073937FfMczGfnIwTPia0O7ETM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N2tK68nC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N2tK68nC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95F5C116B1;
	Tue,  2 Jul 2024 00:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719881937;
	bh=3h3Uwwu33ZxJiTqvJdLSfk6QE4PSNTuBz1LcGHbtOGA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=N2tK68nCNC3XrROy7Dd/upY8BjVWL9LufJH05za9NSmn9nyaMcE5sGSmb2l3mVGOC
	 aOrHFxAHR8Oh+Efv5f/ZVUm27R1xlp2Jar1A5BctDWY3VE4AFXCiU+PrkuJIWKQV4c
	 rDbj9SKx0bWJSQMH6pi94IumnIgknbNUPbjGcHqO1wMMnz28sx+HG9rmcBxiLscont
	 oTsMlyt3J2zlZ16Kqz9u9eUo2PzSqSvl/mQoZT8oDnv9czIwn1J8ERoRAyfRtDEcs4
	 SoCOWr6y+zwYzBGDuj9WCBvscMHSP2t+0O+FawHPbmRUKiL2OLMkOKSLOq24rLuqem
	 Yv6d699ImOrDQ==
Date: Mon, 01 Jul 2024 17:58:57 -0700
Subject: [PATCH 06/13] xfs_scrub: hoist non-rendering character predicate
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988117701.2007123.7758480825890362373.stgit@frogsfrogsfrogs>
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

Hoist this predicate code into its own function; we're going to use it
elsewhere later on.  While we're at it, document how we generated this
list in the first place.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/unicrash.c |   45 ++++++++++++++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 15 deletions(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index 1c0597e52f76..385e42c6acc9 100644
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

