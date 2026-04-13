Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A043AF661
	for <linux-xfs@vger.kernel.org>; Mon, 13 Apr 2026 14:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776092221; cv=none; b=nbMlmYWYVQtReX6dFa69JHEoSF3shpLQYz0tZVzIzlnb0MRoiZB6SMeabJbxR4RXVRNfNhBytBHSYzhMl5OXClx2+i03MvCGp6C8+GAvzzK4xo1jNmWM9hGkDVM7VAX45fEQa9Yo/QqR2BrBHeSUKDq1UGUaDZw0aISnGZfSrAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776092221; c=relaxed/simple;
	bh=vcKQ0ISEvHJgR1NCtnSFwqY8+7BFpjtjU2mtzpEVRfI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=c1s1XS2MvTItLc+63mE44JreqUk/QFwWwe2ETRw+XCJnr/pqUUOhE2UXR1hHoLD/8XRWOeUJdeZVbNd6Gz2vQmsD1z1xIh8rfpkd6ElPP2AnN7KrPv4kYBfOhwaTq5aOMtux0Pkxpijokc9vy8e4KyIsTAA+rlVDVOSLXnh30Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z4LHqi9v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z4LHqi9v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9938C2BCAF;
	Mon, 13 Apr 2026 14:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776092221;
	bh=vcKQ0ISEvHJgR1NCtnSFwqY8+7BFpjtjU2mtzpEVRfI=;
	h=Date:From:To:Cc:Subject:From;
	b=Z4LHqi9vI1lYyVYKFWdjSpK0da4DOMF0GNnBxCtwhi3bQukYphs5zrVfJubbUhN7v
	 R/dAolxFfTNoSMbi3woc3WTOUrlYtEIEDhoLAFsV8AVwBJBJ71pFeNQnAKA9pQTYIg
	 i7rv3SV6YZI+PpJvOUFmwBO4CJFPnC0KPXF18IYpyxK+wA/Y0dVil6TDBdlyzAmbuG
	 b5pKeVE5oA5CXid955nNltkugmdFVAwqVGnEzmcyLkkilhgmifYrfrAIBNt/ND6Znk
	 7+1PRpn9k7AL9GJnn9rt78mrn1I94nLZ78yEKbLu7tbaURpXK/f5corhuXyoIlGJVk
	 53TMKKSqtY4+w==
Date: Mon, 13 Apr 2026 07:57:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs_scrub: warn about unicode variation selectors in names
Message-ID: <20260413145700.GJ1048989@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

ArsTechnica recently wrote about a GitHub supply chain attack wherein
non-rendering unicode sequences were embedded in javascript files to
hide payloads that could be decrypted trivially later.  While these are
unlikely to appear in file and attribute names, we should warn about
this sort of steganography.

Link: https://arstechnica.com/security/2026/03/supply-chain-attack-using-invisible-code-hits-github-and-other-repositories/
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/unicrash.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index a461e875871f4e..1503f761c612dc 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -130,6 +130,9 @@ struct unicrash {
 /* Multiple names resolve to the same case-insensitive string. */
 #define UNICRASH_SAMECASE	((__force badname_t)(1U << 7))
 
+/* More than one variation selector in a row. */
+#define UNICRASH_VARIATION_RUN	((__force badname_t)(1U << 8))
+
 /* FULL STOP (aka period), 0x2E */
 #define UCHAR_PERIOD		((UChar32)'.')
 
@@ -504,9 +507,14 @@ name_entry_examine(
 	UChar32			uchr;
 	uint8_t			mask = 0;
 	unsigned int		ret = 0;
+	/* Don't allow the first codepoint to be a variation */
+	UBool			was_variation = true;
 
 	uiter_setString(&uiter, entry->normstr, entry->normstrlen);
 	while ((uchr = uiter_next32(&uiter)) != U_SENTINEL) {
+		UBool		is_variation =
+			u_hasBinaryProperty(uchr, UCHAR_VARIATION_SELECTOR);
+
 		/* characters are invisible */
 		if (is_nonrendering(uchr))
 			ret |= UNICRASH_INVISIBLE;
@@ -537,6 +545,11 @@ name_entry_examine(
 		default:
 			break;
 		}
+
+		if (is_variation && was_variation)
+			ret |= UNICRASH_VARIATION_RUN;
+
+		was_variation = is_variation;
 	}
 
 	/* mixing left-to-right and right-to-left chars */
@@ -841,6 +854,18 @@ _("Unicode name \"%s\" in %s contains control characters."),
 		goto out;
 	}
 
+	/*
+	 * Variation codepoints only apply to the previous non-variation
+	 * codepoint.  Seeing multiple in a row or at the start of a name is
+	 * weird.
+	 */
+	if (badflags & UNICRASH_VARIATION_RUN) {
+		str_warn(uc->ctx, descr_render(dsc),
+_("Unicode name \"%s\" in %s contains a weird sequence of variation selectors."),
+				bad1, what);
+		goto out;
+	}
+
 	/*
 	 * Skip the informational messages if the inode owning the name is
 	 * only writeable by root, because those files were put there by the
