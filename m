Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DD6C140
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dLcrGLal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44E0C433C8;
	Sun, 31 Dec 2023 22:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704062890;
	bh=IMZ4CyX95tOT/8d7ulcP2kQBT9ZrBIIEihFrSW4m418=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dLcrGLal+D2Gnr/B23o5K3D2Pxk3iQIQZYVr26bzKjxvePzUOWzi6m6VTgm8dVIwi
	 O6EniN5zkaQECAkbVLArIiwnsVQjeE7s/tOx103jMRG6SbJXnobJv3LYiQbN8IyHQo
	 mb1zgtN8gjEyWsfCjXa+yUgefiKTg3ezmkZA2yjHNJM27W7Es+DT7dHXGbJiyOVIXT
	 68ld8AnbvzVyHkGxsKZ3xaJOdywQ3HHispuB0IpIDBjc+8ZcKSMAZ5QJfwzBv7nJ0Q
	 4/05HZEhp4GEV6fOY448GTwVn56wW93QOuNg53Tr3eGwY3gD3PhvGk+AeUnb2pBu3G
	 kLEWAt0MVYOyg==
Date: Sun, 31 Dec 2023 14:48:10 -0800
Subject: [PATCH 12/13] xfs_scrub: report deceptive file extensions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405000742.1798385.9588853650527020615.stgit@frogsfrogsfrogs>
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
Content-Transfer-Encoding: 8bit

From: Darrick J. Wong <djwong@kernel.org>

Earlier this year, ESET revealed that Linux users had been tricked into
opening executables containing malware payloads.  The trickery came in
the form of a malicious zip file containing a filename with the string
"job offer․pdf".  Note that the filename does *not* denote a real pdf
file, since the last four codepoints in the file name are "ONE DOT
LEADER", p, d, and f.  Not period (ok, FULL STOP), p, d, f like you'd
normally expect.

Teach xfs_scrub to look for codepoints that could be confused with a
period followed by alphanumerics.

Link: https://www.welivesecurity.com/2023/04/20/linux-malware-strengthens-links-lazarus-3cx-supply-chain-attack/
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/unicrash.c |  215 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 214 insertions(+), 1 deletion(-)


diff --git a/scrub/unicrash.c b/scrub/unicrash.c
index f6b53276c05..e895afe32aa 100644
--- a/scrub/unicrash.c
+++ b/scrub/unicrash.c
@@ -88,6 +88,7 @@ struct unicrash {
 	struct scrub_ctx	*ctx;
 	USpoofChecker		*spoof;
 	const UNormalizer2	*nfkc;
+	const UNormalizer2	*nfc;
 	bool			compare_ino;
 	bool			is_only_root_writeable;
 	size_t			nr_buckets;
@@ -122,6 +123,12 @@ struct unicrash {
 /* Multiple names resolve to the same skeleton string. */
 #define UNICRASH_CONFUSABLE	((__force badname_t)(1U << 5))
 
+/* Possible phony file extension. */
+#define UNICRASH_PHONY_EXTENSION ((__force badname_t)(1U << 6))
+
+/* FULL STOP (aka period), 0x2E */
+#define UCHAR_PERIOD		((UChar32)'.')
+
 /*
  * We only care about validating utf8 collisions if the underlying
  * system configuration says we're using utf8.  If the language
@@ -209,6 +216,193 @@ static inline bool is_nonrendering(UChar32 uchr)
 	return false;
 }
 
+/*
+ * Decide if this unicode codepoint looks similar enough to a period (".")
+ * to fool users into thinking that any subsequent alphanumeric sequence is
+ * the file extension.  Most of the fullstop characters do not do this.
+ *
+ * $ grep -i 'full stop' UnicodeData.txt
+ */
+static inline bool is_fullstop_lookalike(UChar32 uchr)
+{
+	switch (uchr) {
+	case 0x0701:	/* syriac supralinear full stop */
+	case 0x0702:	/* syriac sublinear full stop */
+	case 0x2024:	/* one dot leader */
+	case 0xA4F8:	/* lisu letter tone mya ti */
+	case 0xFE52:	/* small full stop */
+	case 0xFF61:	/* haflwidth ideographic full stop */
+	case 0xFF0E:	/* fullwidth full stop */
+		return true;
+	}
+
+	return false;
+}
+
+/* How many UChar do we need to fit a full UChar32 codepoint? */
+#define UCHAR_PER_UCHAR32	2
+
+/* Format this UChar32 into a UChar buffer. */
+static inline int32_t
+uchar32_to_uchar(
+	UChar32		uchr,
+	UChar		*buf)
+{
+	int32_t		i = 0;
+	bool		err = false;
+
+	U16_APPEND(buf, i, UCHAR_PER_UCHAR32, uchr, err);
+	if (err)
+		return 0;
+	return i;
+}
+
+/* Extract a single UChar32 code point from this UChar string. */
+static inline UChar32
+uchar_to_uchar32(
+	UChar		*buf,
+	int32_t		buflen)
+{
+	UChar32		ret;
+	int32_t		i = 0;
+
+	U16_NEXT(buf, i, buflen, ret);
+	return ret;
+}
+
+/*
+ * For characters that are not themselves a full stop (0x2E), let's see if the
+ * compatibility normalization (NFKC) will turn it into a full stop.  If so,
+ * then this could be the start of a phony file extension.
+ */
+static bool
+is_period_lookalike(
+	struct unicrash	*uc,
+	UChar32		uchr)
+{
+	UChar		uchrstr[UCHAR_PER_UCHAR32];
+	UChar		nfkcstr[UCHAR_PER_UCHAR32];
+	int32_t		uchrstrlen, nfkcstrlen;
+	UChar32		nfkc_uchr;
+	UErrorCode	uerr = U_ZERO_ERROR;
+
+	if (uchr == UCHAR_PERIOD)
+		return false;
+
+	uchrstrlen = uchar32_to_uchar(uchr, uchrstr);
+	if (!uchrstrlen)
+		return false;
+
+	/*
+	 * Normalize the UChar string to NFKC form, which does all the
+	 * compatibility transformations.
+	 */
+	nfkcstrlen = unorm2_normalize(uc->nfkc, uchrstr, uchrstrlen, NULL,
+			0, &uerr);
+	if (uerr == U_BUFFER_OVERFLOW_ERROR)
+		return false;
+
+	uerr = U_ZERO_ERROR;
+	unorm2_normalize(uc->nfkc, uchrstr, uchrstrlen, nfkcstr, nfkcstrlen,
+			&uerr);
+	if (U_FAILURE(uerr))
+		return false;
+
+	nfkc_uchr = uchar_to_uchar32(nfkcstr, nfkcstrlen);
+	return nfkc_uchr == UCHAR_PERIOD;
+}
+
+/*
+ * Detect directory entry names that contain deceptive sequences that look like
+ * file extensions but are not.  This we define as a sequence that begins with
+ * a code point that renders like a period ("full stop" in unicode parlance)
+ * but is not actually a period, followed by any number of alphanumeric code
+ * points or a period, all the way to the end.
+ *
+ * The 3cx attack used a zip file containing an executable file named "job
+ * offer․pdf".  Note that the dot mark in the extension is /not/ a period but
+ * the Unicode codepoint "leader dot".  The file was also marked executable
+ * inside the zip file, which meant that naïve file explorers could inflate
+ * the file and restore the execute bit.  If a user double-clicked on the file,
+ * the binary would open a decoy pdf while infecting the system.
+ *
+ * For this check, we need to normalize with canonical (and not compatibility)
+ * decomposition, because compatibility mode will turn certain code points
+ * (e.g. one dot leader, 0x2024) into actual periods (0x2e).  The NFC
+ * composition is not needed after this, so we save some memory by keeping this
+ * a separate function from name_entry_examine.
+ */
+static badname_t
+name_entry_phony_extension(
+	struct unicrash	*uc,
+	const UChar	*unistr,
+	int32_t		unistrlen)
+{
+	UCharIterator	uiter;
+	UChar		*nfcstr;
+	int32_t		nfcstrlen;
+	UChar32		uchr;
+	bool		maybe_phony_extension = false;
+	badname_t	ret = UNICRASH_OK;
+	UErrorCode	uerr = U_ZERO_ERROR;
+
+	/* Normalize with NFC. */
+	nfcstrlen = unorm2_normalize(uc->nfc, unistr, unistrlen, NULL,
+			0, &uerr);
+	if (uerr != U_BUFFER_OVERFLOW_ERROR || nfcstrlen < 0)
+		return ret;
+	uerr = U_ZERO_ERROR;
+	nfcstr = calloc(nfcstrlen + 1, sizeof(UChar));
+	if (!nfcstr)
+		return ret;
+	unorm2_normalize(uc->nfc, unistr, unistrlen, nfcstr, nfcstrlen,
+			&uerr);
+	if (U_FAILURE(uerr))
+		goto out_nfcstr;
+
+	/* Examine the NFC normalized string... */
+	uiter_setString(&uiter, nfcstr, nfcstrlen);
+	while ((uchr = uiter_next32(&uiter)) != U_SENTINEL) {
+		/*
+		 * If this *looks* like, but is not, a full stop (0x2E), this
+		 * could be the start of a phony file extension.
+		 */
+		if (is_period_lookalike(uc, uchr)) {
+			maybe_phony_extension = true;
+			continue;
+		}
+
+		if (is_fullstop_lookalike(uchr)) {
+			/*
+			 * The normalizer above should catch most of these
+			 * codepoints that look like periods, but record the
+			 * ones known to have been used in attacks.
+			 */
+			maybe_phony_extension = true;
+		} else if (uchr == UCHAR_PERIOD) {
+			/*
+			 * Due to the propensity of file explores to obscure
+			 * file extensions in the name of "user friendliness",
+			 * this classifier ignores periods.
+			 */
+		} else {
+			/*
+			 * File extensions (as far as the author knows) tend
+			 * only to use ascii alphanumerics.
+			 */
+			if (maybe_phony_extension &&
+			    !u_isalnum(uchr) && !is_nonrendering(uchr))
+				maybe_phony_extension = false;
+		}
+	}
+	if (maybe_phony_extension)
+		ret |= UNICRASH_PHONY_EXTENSION;
+
+out_nfcstr:
+	free(nfcstr);
+	return ret;
+}
+
 /*
  * Generate normalized form and skeleton of the name.  If this fails, just
  * forget everything and return false; this is an advisory checker.
@@ -269,6 +463,11 @@ name_entry_compute_checknames(
 
 	skelstrlen = remove_ignorable(skelstr, skelstrlen);
 
+	/* Check for deceptive file extensions in directory entry names. */
+	if (entry->ino)
+		entry->badflags |= name_entry_phony_extension(uc, unistr,
+						unistrlen);
+
 	entry->skelstr = skelstr;
 	entry->skelstrlen = skelstrlen;
 	entry->normstr = normstr;
@@ -365,7 +564,7 @@ name_entry_create(
 	if (!name_entry_compute_checknames(uc, new_entry))
 		goto out;
 
-	new_entry->badflags = name_entry_examine(new_entry);
+	new_entry->badflags |= name_entry_examine(new_entry);
 	*entry = new_entry;
 	return true;
 
@@ -456,6 +655,9 @@ unicrash_init(
 	p->nr_buckets = nr_buckets;
 	p->compare_ino = compare_ino;
 	p->nfkc = unorm2_getNFKCInstance(&uerr);
+	if (U_FAILURE(uerr))
+		goto out_free;
+	p->nfc = unorm2_getNFCInstance(&uerr);
 	if (U_FAILURE(uerr))
 		goto out_free;
 	p->spoof = uspoof_open(&uerr);
@@ -602,6 +804,17 @@ _("Unicode name \"%s\" in %s could be confused with '%s' due to invisible charac
 		goto out;
 	}
 
+	/*
+	 * Fake looking file extensions have tricked Linux users into thinking
+	 * that an executable is actually a pdf.  See Lazarus 3cx attack.
+	 */
+	if (badflags & UNICRASH_PHONY_EXTENSION) {
+		str_warn(uc->ctx, descr_render(dsc),
+_("Unicode name \"%s\" in %s contains a possibly deceptive file extension."),
+				bad1, what);
+		goto out;
+	}
+
 	/*
 	 * Unfiltered control characters can mess up your terminal and render
 	 * invisibly in filechooser UIs.

