Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C9ABA37;
	Mon,  1 Jan 2024 00:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uo1bwkma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D17C433C7;
	Mon,  1 Jan 2024 00:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069912;
	bh=dTPxFzOAwaGVqwgw/skuO7ZxdWLhwV5d3TuExIrQ6+0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Uo1bwkmal4kpueA8vTstOjVUj1G/T7QCnKA/Tug5riptEvNL3qsTDgtWhvJt9Q59b
	 h2Nu5CwiDzQY5a8Bs5UmR5+Y4dnzYciGDd10s5G1d9qZ/LmYOsZEWht946PPrBVKi/
	 8yd/wDZbMY1mB4GNM1xJ/I+KzjrWeyBxJ9BGbxRwu5S3uLGPkNDgT55qqPcHgqM6x5
	 ExIjmp95wJW4kC04Rt6ak1rrqpJBOlAdSZ6os114HYkPO3aHFRntrNPqewyXZAfy6u
	 T9H+HWwRm+d1ht8gZ1sDqSPbMYrNXfJ7hX7rOkM0B4xCyMHy7UJZYZx0QZKSzApJAx
	 JsasyIuFp1wXg==
Date: Sun, 31 Dec 2023 16:45:12 +9900
Subject: [PATCH 1/2] generic/453: test confusable name detection with 32-bit
 unicode codepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@redhat.com
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Message-ID: <170405026914.1823868.15889436477271297160.stgit@frogsfrogsfrogs>
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

