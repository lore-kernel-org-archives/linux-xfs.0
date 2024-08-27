Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36BB6EB64;
	Tue, 27 Aug 2024 18:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724784352; cv=none; b=dBYc297Lms87YcshYmjdcrAa7ECGjd7in/Ms+smtlJij58PDSVY/PM+QFEaYyffXZ1EVxEYUk7reIPlqHaA0ijjgwXXcleKwd+FxF5B3drofyRENd4ISPv79mZhkud1rm8Cdnk9l8rj1KRGmVD4/CT/D7CmV2CoucPvF7UI4Gi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724784352; c=relaxed/simple;
	bh=dTPxFzOAwaGVqwgw/skuO7ZxdWLhwV5d3TuExIrQ6+0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u5VTDrNKh2yf+70qqU5pN8VWVKztV2MSgZv4DTAOsNtLX4fimAJlh/41qETg6dyYcNLz7SJvsDHQ2sSCxmt05NXniqVjpUq/wvffq07jL6vRFOn6V8Fi2FJScH0r1jEk2Rnuws0R00JRVmERUV5N1FULwmIkJBsmkvNonVDSZqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R8/2U1iA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R8/2U1iA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999ECC4FE98;
	Tue, 27 Aug 2024 18:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724784352;
	bh=dTPxFzOAwaGVqwgw/skuO7ZxdWLhwV5d3TuExIrQ6+0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=R8/2U1iA+pzVgVzDpdCKHFQXlw3DQt2V8PE91FaznYinPBcEJ4M5V3E6bhIrcaOjj
	 g8sAMeF1KQnl8yHsoTKfXjCB9FxakUPwZYtZjFXMqtAXeTd6UGDWMv7EzfmLiIJ3pE
	 A71ZfSo2RwrCFJ6IqyiIazP/mmmFxOCSZAEjJuXvbo8WjnA06+L/CgLMpjXJBeBzhB
	 LbJAu3hPVuHrgVqn0LN+wGfPrOJipNumhb1LohKKxaHqQvpwrltRqQ9mepJv8FsBfm
	 kPjRgQClNmUuuuhAYeKcPbwWdDKawVN+nBpreI767RTQh76spze49RZgu1ReDXS8tm
	 8lzwlOHYQenEA==
Date: Tue, 27 Aug 2024 11:45:52 -0700
Subject: [PATCH 1/2] generic/453: test confusable name detection with 32-bit
 unicode codepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: hch@lst.de, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <172478422302.2039346.11815162501675799772.stgit@frogsfrogsfrogs>
In-Reply-To: <172478422285.2039346.9658505409794335819.stgit@frogsfrogsfrogs>
References: <172478422285.2039346.9658505409794335819.stgit@frogsfrogsfrogs>
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

Test the confusable name detection when there are 32-bit unicode
sequences in use.  In other words, emoji.  Change the xfs_scrub test to
dump the output to a file instead of passing huge echo commands around.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/453 |   32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)


diff --git a/tests/generic/453 b/tests/generic/453
index a0fb802e9b..930e6408ff 100755
--- a/tests/generic/453
+++ b/tests/generic/453
@@ -148,6 +148,10 @@ setf "combmark_\xe1\x80\x9c\xe1\x80\xaf\xe1\x80\xad.txt" "combining marks"
 setd ".\xe2\x80\x8d" "zero width joiners in dot entry"
 setd "..\xe2\x80\x8d" "zero width joiners in dotdot entry"
 
+# utf8 sequence mapping to a u32 unicode codepoint that can be confused
+setf "toilet_bowl.\xf0\x9f\x9a\xbd" "toilet emoji"
+setf "toilet_bow\xe2\x80\x8dl.\xf0\x9f\x9a\xbd" "toilet emoji with zero width joiner"
+
 ls -la $testdir >> $seqres.full
 
 echo "Test files"
@@ -198,6 +202,9 @@ testf "combmark_\xe1\x80\x9c\xe1\x80\xaf\xe1\x80\xad.txt" "combining marks"
 testd ".\xe2\x80\x8d" "zero width joiners in dot entry"
 testd "..\xe2\x80\x8d" "zero width joiners in dotdot entry"
 
+testf "toilet_bowl.\xf0\x9f\x9a\xbd" "toilet emoji"
+testf "toilet_bow\xe2\x80\x8dl.\xf0\x9f\x9a\xbd" "toilet emoji with zero width joiner"
+
 echo "Uniqueness of inodes?"
 stat -c '%i' "${testdir}/"* | sort | uniq -c | while read nr inum; do
 	if [ "${nr}" -gt 1 ]; then
@@ -208,18 +215,21 @@ done
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
+	grep -q "toilet_" $tmp.scrub || echo "No complaints about zero-width join confusables with emoji?"
+
 	echo "Actual xfs_scrub output:" >> $seqres.full
-	echo "${output}" >> $seqres.full
+	cat $tmp.scrub >> $seqres.full
 fi
 
 # success, all done

