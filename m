Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC462BA32;
	Mon,  1 Jan 2024 00:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uJAe5MZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987EAC433C8;
	Mon,  1 Jan 2024 00:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069928;
	bh=RB8Xkek+RyEu8VSTsz0/nh6DtSFR9GD7KhisCBOFUy4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uJAe5MZ+5CGVKDuIvP1ZrccuAzFEkIueJLEo7cIxaWLLQ21hQ9OaiHmCmgfrSkBFq
	 7h1xBq6Krjo2/J17P4yqgFQ/qU8rQm3cs5s06paHe41GIh1e3GU9c8gUxFbn9pNhJ+
	 wCGaosy74gEtPQNyqcXKJXblwE0z5vZS41/ubMRR3G72OfUIO5UvDbRNKX1AANClSU
	 QIDUjlC1JX4L2bbr5NSQ2XPxJFhORlX4S29Zj0Rro4I0IX1Bb6n40bGU2cCcyAOQeO
	 Re1yJCePRAb4nyQ25dTOZXjTS2amS0GM51dTQtRk3RKX++KKYlbmnQnZJ8JWDA51j5
	 vM39VOuRXTMXQ==
Date: Sun, 31 Dec 2023 16:45:28 +9900
Subject: [PATCH 2/2] generic/453: check xfs_scrub detection of confusing job
 offers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Message-ID: <170405026927.1823868.3811718447077214987.stgit@frogsfrogsfrogs>
In-Reply-To: <170405026901.1823868.13486465510706218027.stgit@frogsfrogsfrogs>
References: <170405026901.1823868.13486465510706218027.stgit@frogsfrogsfrogs>
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

Now that xfs_scrub can look for codepoints that could be confused with a
period followed by alphanumerics, let's make sure it actually works.

Link: https://www.welivesecurity.com/2023/04/20/linux-malware-strengthens-links-lazarus-3cx-supply-chain-attack/
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/453 |   79 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 78 insertions(+), 1 deletion(-)


diff --git a/tests/generic/453 b/tests/generic/453
index 930e6408ff..855243a860 100755
--- a/tests/generic/453
+++ b/tests/generic/453
@@ -36,6 +36,15 @@ setf() {
 	echo "Storing ${key} ($(hexbytes "${key}")) -> ${value}" >> $seqres.full
 }
 
+setchild() {
+	subdir="$1"
+	key="$(echo -e "$2")"
+
+	mkdir -p "${testdir}/${subdir}"
+	echo "$subdir" > "${testdir}/${subdir}/${key}"
+	echo "Storing ${subdir}/${key} ($(hexbytes "${key}")) -> ${subdir}" >> $seqres.full
+}
+
 setd() {
 	key="$(echo -e "$1")"
 	value="$2"
@@ -63,6 +72,24 @@ testf() {
 	fi
 }
 
+testchild() {
+	subdir="$1"
+	key="$(echo -e "$2")"
+	fname="${testdir}/${subdir}/${key}"
+
+	echo "Testing ${subdir}/${key} ($(hexbytes "${key}")) -> ${subdir}" >> $seqres.full
+
+	if [ ! -e "${fname}" ]; then
+		echo "Key ${key} does not exist for ${subdir} test??"
+		return
+	fi
+
+	actual_value="$(cat "${fname}")"
+	if [ "${actual_value}" != "${subdir}" ]; then
+		echo "Key ${key} has value ${subdir}, expected ${actual_value}."
+	fi
+}
+
 testd() {
 	key="$(echo -e "$1")"
 	value="$2"
@@ -152,7 +179,27 @@ setd "..\xe2\x80\x8d" "zero width joiners in dotdot entry"
 setf "toilet_bowl.\xf0\x9f\x9a\xbd" "toilet emoji"
 setf "toilet_bow\xe2\x80\x8dl.\xf0\x9f\x9a\xbd" "toilet emoji with zero width joiner"
 
-ls -la $testdir >> $seqres.full
+# decoy file extensions used in 3cx malware attack, and similar ones
+setchild "one_dot_leader" "job offer\xe2\x80\xa4pdf"
+setchild "small_full_stop" "job offer\xef\xb9\x92pdf"
+setchild "fullwidth_full_stop" "job offer\xef\xbc\x8epdf"
+setchild "syriac_supralinear" "job offer\xdc\x81pdf"
+setchild "syriac_sublinear" "job offer\xdc\x82pdf"
+setchild "lisu_letter_tone" "job offer\xea\x93\xb8pdf"
+setchild "actual_period" "job offer.pdf"
+setchild "one_dot_leader_zero_width_space" "job offer\xe2\x80\xa4\xe2\x80\x8dpdf"
+
+# again, but this time all in the same directory to trip the confusable
+# detector
+setf "job offer\xe2\x80\xa4pdf" "one dot leader"
+setf "job offer\xef\xb9\x92pdf" "small full stop"
+setf "job offer\xef\xbc\x8epdf" "fullwidth full stop"
+setf "job offer\xdc\x81pdf" "syriac supralinear full stop"
+setf "job offer\xdc\x82pdf" "syriac sublinear full stop"
+setf "job offer\xea\x93\xb8pdf" "lisu letter tone mya ti"
+setf "job offer.pdf" "actual period"
+
+ls -laR $testdir >> $seqres.full
 
 echo "Test files"
 testf "french_caf\xc3\xa9.txt" "NFC"
@@ -205,6 +252,23 @@ testd "..\xe2\x80\x8d" "zero width joiners in dotdot entry"
 testf "toilet_bowl.\xf0\x9f\x9a\xbd" "toilet emoji"
 testf "toilet_bow\xe2\x80\x8dl.\xf0\x9f\x9a\xbd" "toilet emoji with zero width joiner"
 
+testchild "one_dot_leader" "job offer\xe2\x80\xa4pdf"
+testchild "small_full_stop" "job offer\xef\xb9\x92pdf"
+testchild "fullwidth_full_stop" "job offer\xef\xbc\x8epdf"
+testchild "syriac_supralinear" "job offer\xdc\x81pdf"
+testchild "syriac_sublinear" "job offer\xdc\x82pdf"
+testchild "lisu_letter_tone" "job offer\xea\x93\xb8pdf"
+testchild "actual_period" "job offer.pdf"
+testchild "one_dot_leader_zero_width_space" "job offer\xe2\x80\xa4\xe2\x80\x8dpdf"
+
+testf "job offer\xe2\x80\xa4pdf" "one dot leader"
+testf "job offer\xef\xb9\x92pdf" "small full stop"
+testf "job offer\xef\xbc\x8epdf" "fullwidth full stop"
+testf "job offer\xdc\x81pdf" "syriac supralinear full stop"
+testf "job offer\xdc\x82pdf" "syriac sublinear full stop"
+testf "job offer\xea\x93\xb8pdf" "lisu letter tone mya ti"
+testf "job offer.pdf" "actual period"
+
 echo "Uniqueness of inodes?"
 stat -c '%i' "${testdir}/"* | sort | uniq -c | while read nr inum; do
 	if [ "${nr}" -gt 1 ]; then
@@ -228,6 +292,19 @@ if _check_xfs_scrub_does_unicode "$SCRATCH_MNT" "$SCRATCH_DEV"; then
 	grep -q "zerojoin_" $tmp.scrub || echo "No complaints about zero-width join confusables?"
 	grep -q "toilet_" $tmp.scrub || echo "No complaints about zero-width join confusables with emoji?"
 
+	# Does xfs_scrub complain at all about the job offer files?  Pre-2023
+	# versions did not know to screen for that.
+	if grep -q "job offer" $tmp.scrub; then
+		grep -q 'job offer.xe2.x80.xa4pdf' $tmp.scrub || echo "No complaints about one dot leader?"
+		grep -q "job offer.xef.xb9.x92pdf" $tmp.scrub || echo "No complaints about small full stop?"
+		grep -q "job offer.xef.xbc.x8epdf" $tmp.scrub || echo "No complaints about fullwidth full stop?"
+		grep -q "job offer.xdc.x81pdf" $tmp.scrub || echo "No complaints about syriac supralinear full stop?"
+		grep -q "job offer.xdc.x82pdf" $tmp.scrub || echo "No complaints about syriac sublinear full stop?"
+		grep -q "job offer.xea.x93.xb8pdf" $tmp.scrub || echo "No complaints about lisu letter tone mya ti?"
+		grep -q "job offer.*could be confused with" $tmp.scrub || echo "No complaints about confusing job offers?"
+		grep -q "job offer.xe2.x80.xa4.xe2.x80.x8dpdf" $tmp.scrub || echo "No complaints about one dot leader with invisible space?"
+	fi
+
 	echo "Actual xfs_scrub output:" >> $seqres.full
 	cat $tmp.scrub >> $seqres.full
 fi

