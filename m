Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2179939B959;
	Thu,  7 May 2026 22:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778192600; cv=none; b=AmvJdsPcnmCdyETasZzUNQ+OkljpvypR0+bq0R0OgYXc1sVsz8u1ZXj8sz66pPrkI6I+AoZFYp/Mdx6AHiTrWKq6mRBM9+/XPP0Qq7DGQOCvfRfaKTq9orOz8cUiMmkZ+MzWW8QFrYwTLjA5CP6andZK1AJYA0y4oDX+yaYteG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778192600; c=relaxed/simple;
	bh=HvdxeoCuPTNxuvwbdz8Glwyj+J0CQwq3jAmob9boRFg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BLzQlbCTBwg1rVJfTrxx234/VXp0/qt9kixky4hXQ9DqLCvqWV8AdheDOFiWcYhccGsu9fpobC6viK6+YvXZvQvsJBV/1INsWbSpKJ0I1XOLmLkaUt4DtzcX4VYFUk6AmIGe/qXIAsfUybBOxFdExTQjEox/EdW4Z+6DCaRC5Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T/nc9XZT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T/nc9XZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A78C2BCC9;
	Thu,  7 May 2026 22:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778192599;
	bh=HvdxeoCuPTNxuvwbdz8Glwyj+J0CQwq3jAmob9boRFg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=T/nc9XZTf20mbZkTnM8ilpEsWQEOh77Qj5eQQ0rIHL73H3YKGaHPJA/WgD2uGvHnd
	 uacj2mj3BPRDMLZm9SSbv0bs5STmYytOKTuwZKnqfcsCoXQ79IH0zXOqhZNqotsQY1
	 l5GZw0Y72vagrzFlbuc5XPx++EfndcusaFFCNA47yL7Sf3sEC8aXldGXCtNKoLe9Ts
	 1bk+1+Ip6tjkTfpR1wp89haWvj7JjlgSzMqVcWMZ7ww8i4aJ/dO8DREyTnnQWL290p
	 tMt52fFSRuKeWhzBKOTplaOo2E1a/XGsf2OjkAEP1iYx8MXXxItxElBPS8fJop9Mdl
	 7eUTxZxjroqrQ==
Date: Thu, 07 May 2026 15:23:19 -0700
Subject: [PATCH 1/2] generic/45[34]: add detection of confusable variation
 sequences
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <177819254775.3505531.17842420789857268686.stgit@frogsfrogsfrogs>
In-Reply-To: <177819254750.3505531.13966651630640194090.stgit@frogsfrogsfrogs>
References: <177819254750.3505531.13966651630640194090.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

ArsTechnica recently wrote about a GitHub supply chain attack wherein
non-rendering unicode sequences were embedded in javascript files to
hide payloads that could be decrypted trivially later.  While these are
unlikely to appear in file and attribute names, xfs_scrub will warn about
this sort of steganography, so let's make sure it works.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/453 |   35 +++++++++++++++++++++++++++++++++++
 tests/generic/454 |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+)


diff --git a/tests/generic/453 b/tests/generic/453
index bd5ce8b2bb11d9..0193b010306c48 100755
--- a/tests/generic/453
+++ b/tests/generic/453
@@ -233,6 +233,20 @@ setf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbc" "medium light"
 setf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbb" "light"
 setf "\xf0\x9f\xab\xb6" "neutral"
 
+# confusion with variation selectors
+setf "variations.txt" v0
+setf "varia\xef\xb8\x80tions.txt" v1
+setf "\xef\xb8\x80variations.txt" v2
+setf "vari\xef\xb8\x80\xef\xb8\x81ations.txt" v3
+setf "varia\xf3\xa0\x87\xa4tions.txt" v4
+
+# deprecated tags are considered control characters
+setf "tags_moocow.txt" u0
+setf "tags_m\xf3\xa0\x81\xadoocow.txt" u1
+
+# totally hidden name? "(Hi)" is the file name
+setf "\xf3\xa0\x80\xa8\xf3\xa0\x81\x88\xf3\xa0\x81\xa9\xf3\xa0\x80\xa9" "(Hi)"
+
 ls -laR $testdir >> $seqres.full
 
 echo "Test files"
@@ -331,6 +345,20 @@ testf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbc" "medium light"
 testf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbb" "light"
 testf "\xf0\x9f\xab\xb6" "neutral"
 
+# confusion with variation selectors
+testf "variations.txt" v0
+testf "varia\xef\xb8\x80tions.txt" v1
+testf "\xef\xb8\x80variations.txt" v2
+testf "vari\xef\xb8\x80\xef\xb8\x81ations.txt" v3
+testf "varia\xf3\xa0\x87\xa4tions.txt" v4
+
+# deprecated tags are considered control characters
+testf "tags_moocow.txt" u0
+testf "tags_m\xf3\xa0\x81\xadoocow.txt" u1
+
+# totally hidden name? "(Hi)" is the file name
+testf "\xf3\xa0\x80\xa8\xf3\xa0\x81\x88\xf3\xa0\x81\xa9\xf3\xa0\x80\xa9" "(Hi)"
+
 echo "Uniqueness of inodes?"
 stat -c '%i' "${testdir}/"* | sort | uniq -c | while read nr inum; do
 	if [ "${nr}" -gt 1 ]; then
@@ -368,6 +396,13 @@ if _check_xfs_scrub_does_unicode "$SCRATCH_MNT" "$SCRATCH_DEV"; then
 		grep -q "llamapirate" $tmp.scrub || echo "No complaints about hidden llm instructions in filenames?"
 	fi
 
+	if grep -q "variations" $tmp.scrub; then
+		grep -q 'varia.xef.xb8' $tmp.scrub || echo "No complaints about variation sequence confusion?"
+		grep -q 'varia.xf3.xa0' $tmp.scrub || echo "No complaints about extended variation sequence confusion?"
+		grep -q 'x80variations' $tmp.scrub || echo "No complaints about variations starting a name?"
+		grep -q 'tags_m.xf3.xa0.x81' $tmp.scrub || echo "No complaints about deprecated unicode tags in a name?"
+	fi
+
 	echo "Actual xfs_scrub output:" >> $seqres.full
 	cat $tmp.scrub >> $seqres.full
 fi
diff --git a/tests/generic/454 b/tests/generic/454
index 9f6ddb4a0e48b2..3454cae5d5ea6c 100755
--- a/tests/generic/454
+++ b/tests/generic/454
@@ -154,6 +154,20 @@ setf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbc" "medium light"
 setf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbb" "light"
 setf "\xf0\x9f\xab\xb6" "neutral"
 
+# confusion with variation selectors
+setf "variations.txt" v0
+setf "varia\xef\xb8\x80tions.txt" v1
+setf "\xef\xb8\x80variations.txt" v2
+setf "vari\xef\xb8\x80\xef\xb8\x81ations.txt" v3
+setf "varia\xf3\xa0\x87\xa4tions.txt" v4
+
+# deprecated tags are considered control characters
+setf "tags_moocow.txt" u0
+setf "tags_m\xf3\xa0\x81\xadoocow.txt" u1
+
+# totally hidden name? "(Hi)" is the file name
+setf "\xf3\xa0\x80\xa8\xf3\xa0\x81\x88\xf3\xa0\x81\xa9\xf3\xa0\x80\xa9" "(Hi)"
+
 _getfattr --absolute-names -d "${testfile}" >> $seqres.full
 
 echo "Test files"
@@ -229,6 +243,20 @@ testf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbc" "medium light"
 testf "\xf0\x9f\xab\xb6\xf0\x9f\x8f\xbb" "light"
 testf "\xf0\x9f\xab\xb6" "neutral"
 
+# confusion with variation selectors
+testf "variations.txt" v0
+testf "varia\xef\xb8\x80tions.txt" v1
+testf "\xef\xb8\x80variations.txt" v2
+testf "vari\xef\xb8\x80\xef\xb8\x81ations.txt" v3
+testf "varia\xf3\xa0\x87\xa4tions.txt" v4
+
+# deprecated tags are considered control characters
+testf "tags_moocow.txt" u0
+testf "tags_m\xf3\xa0\x81\xadoocow.txt" u1
+
+# totally hidden name? "(Hi)" is the file name
+testf "\xf3\xa0\x80\xa8\xf3\xa0\x81\x88\xf3\xa0\x81\xa9\xf3\xa0\x80\xa9" "(Hi)"
+
 echo "Uniqueness of keys?"
 crazy_keys="$(_getfattr --absolute-names -d "${testfile}" | grep -E -c '(french_|chinese_|greek_|arabic_|urk)')"
 expected_keys=11
@@ -249,6 +277,14 @@ if _check_xfs_scrub_does_unicode "$SCRATCH_MNT" "$SCRATCH_DEV"; then
 	grep -q "prohibition_" $tmp.scrub || echo "No complaints about prohibited sequence confusables?"
 	grep -q "zerojoin_" $tmp.scrub || echo "No complaints about zero-width join confusables?"
 	grep -q "llamapirate" $tmp.scrub || echo "No complaints about hidden llm instructions in filenames?"
+
+	if grep -q "variations" $tmp.scrub; then
+		grep -q 'varia.xef.xb8' $tmp.scrub || echo "No complaints about variation sequence confusion?"
+		grep -q 'varia.xf3.xa0' $tmp.scrub || echo "No complaints about extended variation sequence confusion?"
+		grep -q 'x80variations' $tmp.scrub || echo "No complaints about variations starting a name?"
+		grep -q 'tags_m.xf3.xa0.x81' $tmp.scrub || echo "No complaints about deprecated unicode tags in a name?"
+	fi
+
 	echo "Actual xfs_scrub output:" >> $seqres.full
 	echo "${output}" >> $seqres.full
 fi

