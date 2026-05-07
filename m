Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFAE3397699;
	Thu,  7 May 2026 22:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778192615; cv=none; b=eiczxxW9hJcEDJfc88v8PVmeLTobTDKbeco8PrWgjscbGC8if2tEewjAMz3QwDD3n9IVnz0jpsmm3cDudNMBUlTIWOmGW1vzo+CZrSkutbLL68R0VGAOAE3f3v7sgSLC4qNCSDnUVyNqC4OKYU5u9fwbnvYpSUFdvug78mcGZls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778192615; c=relaxed/simple;
	bh=kvHyRDLXlVkfASxa1ThHNiBW7VD6geVLPOom5EsxuEU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FLwiBekNys0zJEA47atJiw35LOk5/2qSm18oOzTj8eoEB713Kx32OYdxRW5kqpvvdZRyoUYP2bb/DSgXZzNKXlcQRJL9ZMt+j43VAkbuebmCffyxlGL/YxLpkfA3RVV2mPS3AciGnotdZZhbsA2mHEgmEVTu64+ktuNOyIMzOOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ayfyGMhr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ayfyGMhr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23BC3C2BCB2;
	Thu,  7 May 2026 22:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778192615;
	bh=kvHyRDLXlVkfASxa1ThHNiBW7VD6geVLPOom5EsxuEU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ayfyGMhrCWMdHiFkCpqOgDxMqbJjHHyKeJ8Uhxe58ZAOFuUPWrdgvVul/vvBsJXtO
	 niBJIEDYmzN1YS3sSUc4qfTnVA74VZY/SHN6jPsAeh8dPSZdWOaqEJaYEbwCEB/jQI
	 wj5pVr9S7K9tP+bqcMa8R2Z+zWlcQ0fIcPZalc6ucqaH6zAKB3sdGKXQbtxXESm1LY
	 dvnT6GWbE3+ceJ6yFnu3NRFmmcGp4nFRuUBRvvkNKaB71qVO8Ea48FB5Ezz6ecT+Xe
	 LyNMtxAn5RqomW0JqLvV2rtkb+3vI2kNdeb+zYP+OUGXyCwYQEae4zLNWQcwiB978r
	 t5nKhY/iBfqmA==
Date: Thu, 07 May 2026 15:23:34 -0700
Subject: [PATCH 2/2] generic/45[34]: don't warn on mixed bidirectional
 characters
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, zlang@kernel.org
Cc: gedalya@gedalya.net, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Message-ID: <177819254793.3505531.13029436500533639982.stgit@frogsfrogsfrogs>
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

We're dropping this warning from xfs_scrub because the warning is
incorrect, so let's make sure the QA system checks that it's gone.

Cc: gedalya@gedalya.net
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 tests/generic/453 |   10 ++++++++++
 tests/generic/454 |   10 ++++++++++
 2 files changed, 20 insertions(+)


diff --git a/tests/generic/453 b/tests/generic/453
index 0193b010306c48..9b121d995ad1ab 100755
--- a/tests/generic/453
+++ b/tests/generic/453
@@ -247,6 +247,10 @@ setf "tags_m\xf3\xa0\x81\xadoocow.txt" u1
 # totally hidden name? "(Hi)" is the file name
 setf "\xf3\xa0\x80\xa8\xf3\xa0\x81\x88\xf3\xa0\x81\xa9\xf3\xa0\x80\xa9" "(Hi)"
 
+# Gedalya complained about being flagged for mixing Hebrew (RTL) and Latin
+# (LTR) codepoints in the same name.  This is a common practice.
+setf "\xd7\xa2\xd7\x91\xd7\xa8\xd7\x99\xd7\xaa.pdf" "mixed rtl and ltr chars?"
+
 ls -laR $testdir >> $seqres.full
 
 echo "Test files"
@@ -359,6 +363,10 @@ testf "tags_m\xf3\xa0\x81\xadoocow.txt" u1
 # totally hidden name? "(Hi)" is the file name
 testf "\xf3\xa0\x80\xa8\xf3\xa0\x81\x88\xf3\xa0\x81\xa9\xf3\xa0\x80\xa9" "(Hi)"
 
+# Gedalya complained about being flagged for mixing Hebrew (RTL) and Latin
+# (LTR) codepoints in the same name.  This is a common practice.
+testf "\xd7\xa2\xd7\x91\xd7\xa8\xd7\x99\xd7\xaa.pdf" "mixed rtl and ltr chars?"
+
 echo "Uniqueness of inodes?"
 stat -c '%i' "${testdir}/"* | sort | uniq -c | while read nr inum; do
 	if [ "${nr}" -gt 1 ]; then
@@ -403,6 +411,8 @@ if _check_xfs_scrub_does_unicode "$SCRATCH_MNT" "$SCRATCH_DEV"; then
 		grep -q 'tags_m.xf3.xa0.x81' $tmp.scrub || echo "No complaints about deprecated unicode tags in a name?"
 	fi
 
+	grep -q 'mixes bidirectional characters' $tmp.scrub && echo "Unnecessary complaints about mixed bidi characters in a name?"
+
 	echo "Actual xfs_scrub output:" >> $seqres.full
 	cat $tmp.scrub >> $seqres.full
 fi
diff --git a/tests/generic/454 b/tests/generic/454
index 3454cae5d5ea6c..81c9a721561cf8 100755
--- a/tests/generic/454
+++ b/tests/generic/454
@@ -168,6 +168,10 @@ setf "tags_m\xf3\xa0\x81\xadoocow.txt" u1
 # totally hidden name? "(Hi)" is the file name
 setf "\xf3\xa0\x80\xa8\xf3\xa0\x81\x88\xf3\xa0\x81\xa9\xf3\xa0\x80\xa9" "(Hi)"
 
+# Gedalya complained about being flagged for mixing Hebrew (RTL) and Latin
+# (LTR) codepoints in the same name.  This is a common practice.
+setf "\xd7\xa2\xd7\x91\xd7\xa8\xd7\x99\xd7\xaa.pdf" "mixed rtl and ltr chars?"
+
 _getfattr --absolute-names -d "${testfile}" >> $seqres.full
 
 echo "Test files"
@@ -256,6 +260,10 @@ testf "tags_m\xf3\xa0\x81\xadoocow.txt" u1
 
 # totally hidden name? "(Hi)" is the file name
 testf "\xf3\xa0\x80\xa8\xf3\xa0\x81\x88\xf3\xa0\x81\xa9\xf3\xa0\x80\xa9" "(Hi)"
+#
+# Gedalya complained about being flagged for mixing Hebrew (RTL) and Latin
+# (LTR) codepoints in the same name.  This is a common practice.
+testf "\xd7\xa2\xd7\x91\xd7\xa8\xd7\x99\xd7\xaa.pdf" "mixed rtl and ltr chars?"
 
 echo "Uniqueness of keys?"
 crazy_keys="$(_getfattr --absolute-names -d "${testfile}" | grep -E -c '(french_|chinese_|greek_|arabic_|urk)')"
@@ -285,6 +293,8 @@ if _check_xfs_scrub_does_unicode "$SCRATCH_MNT" "$SCRATCH_DEV"; then
 		grep -q 'tags_m.xf3.xa0.x81' $tmp.scrub || echo "No complaints about deprecated unicode tags in a name?"
 	fi
 
+	grep -q 'mixes bidirectional characters' $tmp.scrub && echo "Unnecessary complaints about mixed bidi characters in a name?"
+
 	echo "Actual xfs_scrub output:" >> $seqres.full
 	echo "${output}" >> $seqres.full
 fi

