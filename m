Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A17170A3E;
	Wed, 16 Oct 2024 23:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729120548; cv=none; b=oannaDxXrEK6CQj0q/IkSAjPLpR9GccawdVDg3srVSGNxKnjV4NyZeU5uNvEa3rc5jM5GqY7E1turJY0TweRWnmigKq34TlxwKizV3qvr/OFSmIvjcpgR+e8eLUnEm6kriF8iuJnp0Isrgt7DajiSRz6V7XZrn1LCR8z/+EklS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729120548; c=relaxed/simple;
	bh=w4KBjhXZLW/PU4izi8hvR3UnDb5r9l8+EJc9Z55cz24=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=th2QuyQmo7Sku5hWYY1qi+5STqxNcvRRpVdvmX6HYUK89IR655+hNtyFbjzoCGOo0dIVVdWuNu5x0gZNzY3qe+pQHzhldJK+42Lxt2fPX3cF5hFnJZB2b5CTK6QZzn77LwJcnnV6CIrF3tID6Wk7EVJzHDiNduJ9KWmO24O82Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BLQGNcs2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BLQGNcs2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92BA8C4CEC5;
	Wed, 16 Oct 2024 23:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729120548;
	bh=w4KBjhXZLW/PU4izi8hvR3UnDb5r9l8+EJc9Z55cz24=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BLQGNcs2MUofKPS03r2PaLGyzrdd3dIuFw2a8D7oIfbkczZboiek6D3cLmxUuEtCC
	 84cymshwwk9bE4djylq4HrmC0W9r0+Dgr+w409yrtuJC3TjH12D+EkOc3w+zmFT1Xf
	 addv0nMW+4MbtjUIQ14pPozIcAel6U8jsO/PZcVFJ1qN5TDyX9RunclRLaBKRousdU
	 QLCQzBmXjWJAeHA6hSP2WjHmD1WtxPzhVqcMaQFIyGR8I03vUAchiGzMJAtLGkwZTq
	 LSD0qsB8sGn0sEoUFMTbVljLX7BNHkAzvxtoZRZn9AsigGiATqBPVKlM8bBybihjiL
	 xXG+BJnhHs/qQ==
Date: Wed, 16 Oct 2024 16:15:48 -0700
Subject: [PATCH 1/1] misc: amend unicode confusing name tests to check for
 hidden tag characters
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <172912045911.2584109.3860719636262870391.stgit@frogsfrogsfrogs>
In-Reply-To: <172912045895.2584109.2643798036760972085.stgit@frogsfrogsfrogs>
References: <172912045895.2584109.2643798036760972085.stgit@frogsfrogsfrogs>
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

The Unicode consortium has twice defined (and later deprecated) special
"tag" codepoints.  These tag codepoints are not supposed to be rendered
(i.e. they're invisible) but you can certainly encode them in
directories and labels to try to confuse users.

xfs_scrub already knows how complain about these tag characters because
libicu can detect both their presence and their use in confusing name
attacks, so add this as an explicit regression test.

Link: https://embracethered.com/blog/posts/2024/hiding-and-finding-text-with-unicode-tags/
Link: https://arstechnica.com/security/2024/10/ai-chatbots-can-read-and-write-invisible-text-creating-an-ideal-covert-channel/
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/453 |    8 ++++++++
 tests/generic/454 |   29 +++++++++++++++++++----------
 tests/xfs/504     |    3 +++
 3 files changed, 30 insertions(+), 10 deletions(-)


diff --git a/tests/generic/453 b/tests/generic/453
index 855243a860b9ba..b7e686f37100da 100755
--- a/tests/generic/453
+++ b/tests/generic/453
@@ -199,6 +199,10 @@ setf "job offer\xdc\x82pdf" "syriac sublinear full stop"
 setf "job offer\xea\x93\xb8pdf" "lisu letter tone mya ti"
 setf "job offer.pdf" "actual period"
 
+# encoding hidden tag characters in filenames to create confusing names
+setf "llamapirate\xf3\xa0\x80\x81\xf3\xa0\x81\x94\xf3\xa0\x81\xa8\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\xb3\xf3\xa0\x81\xa1\xf3\xa0\x81\xac\xf3\xa0\x81\xa5\xf3\xa0\x81\xb3\xf3\xa0\x80\xa0\xf3\xa0\x81\xa6\xf3\xa0\x81\xaf\xf3\xa0\x81\xb2\xf3\xa0\x80\xa0\xf3\xa0\x81\x93\xf3\xa0\x81\xa5\xf3\xa0\x81\xa1\xf3\xa0\x81\xb4\xf3\xa0\x81\xb4\xf3\xa0\x81\xac\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\xb7\xf3\xa0\x81\xa5\xf3\xa0\x81\xb2\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\x95\xf3\xa0\x81\x93\xf3\xa0\x81\x84\xf3\xa0\x80\xa0\xf3\xa0\x80\xb1\xf3\xa0\x80\xb2\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x81\xbf"
+setf "llamapirate"
+
 ls -laR $testdir >> $seqres.full
 
 echo "Test files"
@@ -269,6 +273,9 @@ testf "job offer\xdc\x82pdf" "syriac sublinear full stop"
 testf "job offer\xea\x93\xb8pdf" "lisu letter tone mya ti"
 testf "job offer.pdf" "actual period"
 
+testf "llamapirate\xf3\xa0\x80\x81\xf3\xa0\x81\x94\xf3\xa0\x81\xa8\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\xb3\xf3\xa0\x81\xa1\xf3\xa0\x81\xac\xf3\xa0\x81\xa5\xf3\xa0\x81\xb3\xf3\xa0\x80\xa0\xf3\xa0\x81\xa6\xf3\xa0\x81\xaf\xf3\xa0\x81\xb2\xf3\xa0\x80\xa0\xf3\xa0\x81\x93\xf3\xa0\x81\xa5\xf3\xa0\x81\xa1\xf3\xa0\x81\xb4\xf3\xa0\x81\xb4\xf3\xa0\x81\xac\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\xb7\xf3\xa0\x81\xa5\xf3\xa0\x81\xb2\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\x95\xf3\xa0\x81\x93\xf3\xa0\x81\x84\xf3\xa0\x80\xa0\xf3\xa0\x80\xb1\xf3\xa0\x80\xb2\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x81\xbf"
+testf "llamapirate"
+
 echo "Uniqueness of inodes?"
 stat -c '%i' "${testdir}/"* | sort | uniq -c | while read nr inum; do
 	if [ "${nr}" -gt 1 ]; then
@@ -303,6 +310,7 @@ if _check_xfs_scrub_does_unicode "$SCRATCH_MNT" "$SCRATCH_DEV"; then
 		grep -q "job offer.xea.x93.xb8pdf" $tmp.scrub || echo "No complaints about lisu letter tone mya ti?"
 		grep -q "job offer.*could be confused with" $tmp.scrub || echo "No complaints about confusing job offers?"
 		grep -q "job offer.xe2.x80.xa4.xe2.x80.x8dpdf" $tmp.scrub || echo "No complaints about one dot leader with invisible space?"
+		grep -q "llamapirate" $tmp.scrub || echo "No complaints about hidden llm instructions in filenames?"
 	fi
 
 	echo "Actual xfs_scrub output:" >> $seqres.full
diff --git a/tests/generic/454 b/tests/generic/454
index 3c9b39d059532d..2cc2d81ce4cc77 100755
--- a/tests/generic/454
+++ b/tests/generic/454
@@ -120,6 +120,10 @@ setf "zerojoin_moo\xe2\x80\x8ccow.txt" "zero width joiners"
 setf "combmark_\xe1\x80\x9c\xe1\x80\xad\xe1\x80\xaf.txt" "combining marks"
 setf "combmark_\xe1\x80\x9c\xe1\x80\xaf\xe1\x80\xad.txt" "combining marks"
 
+# encoding hidden tag characters in attrnames to create confusing xattrs
+setf "llamapirate\xf3\xa0\x80\x81\xf3\xa0\x81\x94\xf3\xa0\x81\xa8\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\xb3\xf3\xa0\x81\xa1\xf3\xa0\x81\xac\xf3\xa0\x81\xa5\xf3\xa0\x81\xb3\xf3\xa0\x80\xa0\xf3\xa0\x81\xa6\xf3\xa0\x81\xaf\xf3\xa0\x81\xb2\xf3\xa0\x80\xa0\xf3\xa0\x81\x93\xf3\xa0\x81\xa5\xf3\xa0\x81\xa1\xf3\xa0\x81\xb4\xf3\xa0\x81\xb4\xf3\xa0\x81\xac\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\xb7\xf3\xa0\x81\xa5\xf3\xa0\x81\xb2\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\x95\xf3\xa0\x81\x93\xf3\xa0\x81\x84\xf3\xa0\x80\xa0\xf3\xa0\x80\xb1\xf3\xa0\x80\xb2\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x81\xbf"
+setf "llamapirate"
+
 _getfattr --absolute-names -d "${testfile}" >> $seqres.full
 
 echo "Test files"
@@ -167,6 +171,9 @@ testf "zerojoin_moo\xe2\x80\x8ccow.txt" "zero width joiners"
 testf "combmark_\xe1\x80\x9c\xe1\x80\xad\xe1\x80\xaf.txt" "combining marks"
 testf "combmark_\xe1\x80\x9c\xe1\x80\xaf\xe1\x80\xad.txt" "combining marks"
 
+testf "llamapirate\xf3\xa0\x80\x81\xf3\xa0\x81\x94\xf3\xa0\x81\xa8\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\xb3\xf3\xa0\x81\xa1\xf3\xa0\x81\xac\xf3\xa0\x81\xa5\xf3\xa0\x81\xb3\xf3\xa0\x80\xa0\xf3\xa0\x81\xa6\xf3\xa0\x81\xaf\xf3\xa0\x81\xb2\xf3\xa0\x80\xa0\xf3\xa0\x81\x93\xf3\xa0\x81\xa5\xf3\xa0\x81\xa1\xf3\xa0\x81\xb4\xf3\xa0\x81\xb4\xf3\xa0\x81\xac\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\xb7\xf3\xa0\x81\xa5\xf3\xa0\x81\xb2\xf3\xa0\x81\xa5\xf3\xa0\x80\xa0\xf3\xa0\x81\x95\xf3\xa0\x81\x93\xf3\xa0\x81\x84\xf3\xa0\x80\xa0\xf3\xa0\x80\xb1\xf3\xa0\x80\xb2\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x80\xb0\xf3\xa0\x81\xbf"
+testf "llamapirate"
+
 echo "Uniqueness of keys?"
 crazy_keys="$(_getfattr --absolute-names -d "${testfile}" | grep -E -c '(french_|chinese_|greek_|arabic_|urk)')"
 expected_keys=11
@@ -175,16 +182,18 @@ test "${crazy_keys}" -ne "${expected_keys}" && echo "Expected ${expected_keys} k
 echo "Test XFS online scrub, if applicable"
 
 if _check_xfs_scrub_does_unicode "$SCRATCH_MNT" "$SCRATCH_DEV"; then
-	output="$(LC_ALL="C.UTF-8" ${XFS_SCRUB_PROG} -v -n "${SCRATCH_MNT}" 2>&1 | filter_scrub)"
-	echo "${output}" | grep -q "french_" || echo "No complaints about french e accent?"
-	echo "${output}" | grep -q "greek_" || echo "No complaints about greek letter mess?"
-	echo "${output}" | grep -q "arabic_" || echo "No complaints about arabic expanded string?"
-	echo "${output}" | grep -q "mixed_" || echo "No complaints about mixed script confusables?"
-	echo "${output}" | grep -q "hyphens_" || echo "No complaints about hyphenation confusables?"
-	echo "${output}" | grep -q "dz_digraph_" || echo "No complaints about single script confusables?"
-	echo "${output}" | grep -q "inadequate_" || echo "No complaints about inadequate rendering confusables?"
-	echo "${output}" | grep -q "prohibition_" || echo "No complaints about prohibited sequence confusables?"
-	echo "${output}" | grep -q "zerojoin_" || echo "No complaints about zero-width join confusables?"
+	LC_ALL="C.UTF-8" ${XFS_SCRUB_PROG} -v -n "${SCRATCH_MNT}" 2>&1 | filter_scrub > $tmp.scrub
+
+	grep -q "french_" $tmp.scrub || echo "No complaints about french e accent?"
+	grep -q "greek_" $tmp.scrub || echo "No complaints about greek letter mess?"
+	grep -q "arabic_" $tmp.scrub || echo "No complaints about arabic expanded string?"
+	grep -q "mixed_" $tmp.scrub || echo "No complaints about mixed script confusables?"
+	grep -q "hyphens_" $tmp.scrub || echo "No complaints about hyphenation confusables?"
+	grep -q "dz_digraph_" $tmp.scrub || echo "No complaints about single script confusables?"
+	grep -q "inadequate_" $tmp.scrub || echo "No complaints about inadequate rendering confusables?"
+	grep -q "prohibition_" $tmp.scrub || echo "No complaints about prohibited sequence confusables?"
+	grep -q "zerojoin_" $tmp.scrub || echo "No complaints about zero-width join confusables?"
+	grep -q "llamapirate" $tmp.scrub || echo "No complaints about hidden llm instructions in filenames?"
 	echo "Actual xfs_scrub output:" >> $seqres.full
 	echo "${output}" >> $seqres.full
 fi
diff --git a/tests/xfs/504 b/tests/xfs/504
index 6000923bf7bb87..a9d99cd1217203 100755
--- a/tests/xfs/504
+++ b/tests/xfs/504
@@ -128,6 +128,9 @@ testlabel "\xe1\x80\x9c\xe1\x80\xaf\xe1\x80\xad.fs"
 testlabel ".\xe2\x80\x8d"
 testlabel "..\xe2\x80\x8d"
 
+# encoding hidden tag characters in fslabels to create confusing names
+testlabel "llmpir8\xf3\xa0\x81\x94"
+
 # Did scrub choke on anything?
 if [ "$want_scrub" = "yes" ]; then
 	grep -q "^Warning.*gnp.txt.*suspicious text direction" $tmp.scrub || \

