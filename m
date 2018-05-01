Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:46466 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750787AbeEAPjz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 May 2018 11:39:55 -0400
Subject: [PATCH 5/9] generic/45[34]: test unicode confusables
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 01 May 2018 08:39:51 -0700
Message-ID: <152518919147.23023.4713276242990600575.stgit@magnolia>
In-Reply-To: <152518916007.23023.4793255395982876953.stgit@magnolia>
References: <152518916007.23023.4793255395982876953.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Test if a filesystem will allow us to create names with easily
confusable unicode sequences (character spoofing) and, if on XFS,
whether or not xfs_scrub will notice.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/453 |   54 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/454 |   54 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 108 insertions(+)


diff --git a/tests/generic/453 b/tests/generic/453
index 6cb2a296..91d163ca 100755
--- a/tests/generic/453
+++ b/tests/generic/453
@@ -116,6 +116,33 @@ setf "\x6c\x69\x6e\x65\x64\x72\x61\x77\x5f\x0a\xe2\x95\x94\xe2\x95\x90\xe2\x95\x
 setf "moo\xe2\x80\xaegnp.txt" "Well say hello,"
 setf "mootxt.png" "Harvey"
 
+# mixed-script confusables
+setf "mixed_t\xce\xbfp.txt" "greek omicron instead of o"
+setf "mixed_top.txt" "greek omicron instead of o"
+
+# single-script spoofing
+setf "hyphens_a\xe2\x80\x90b.txt" "hyphens"
+setf "hyphens_a-b.txt" "hyphens"
+
+setf "dz_digraph_dze.txt" "d-z digraph"
+setf "dz_digraph_\xca\xa3e.txt" "d-z digraph"
+
+# inadequate rendering
+setf "inadequate_al.txt" "is it l or is it 1"
+setf "inadequate_a1.txt" "is it l or is it 1"
+
+# symbols
+setf "prohibition_Rs.txt" "rupee symbol"
+setf "prohibition_\xe2\x82\xa8.txt" "rupee symbol"
+
+# zero width joiners
+setf "zerojoin_moocow.txt" "zero width joiners"
+setf "zerojoin_moo\xe2\x80\x8dcow.txt" "zero width joiners"
+
+# combining marks
+setf "combmark_\xe1\x80\x9c\xe1\x80\xad\xe1\x80\xaf.txt" "combining marks"
+setf "combmark_\xe1\x80\x9c\xe1\x80\xaf\xe1\x80\xad.txt" "combining marks"
+
 ls -la $testdir >> $seqres.full
 
 echo "Test files"
@@ -142,6 +169,27 @@ testf "\x6c\x69\x6e\x65\x64\x72\x61\x77\x5f\x0a\xe2\x95\x94\xe2\x95\x90\xe2\x95\
 testf "moo\xe2\x80\xaegnp.txt" "Well say hello,"
 testf "mootxt.png" "Harvey"
 
+testf "mixed_t\xce\xbfp.txt" "greek omicron instead of o"
+testf "mixed_top.txt" "greek omicron instead of o"
+
+testf "hyphens_a\xe2\x80\x90b.txt" "hyphens"
+testf "hyphens_a-b.txt" "hyphens"
+
+testf "dz_digraph_dze.txt" "d-z digraph"
+testf "dz_digraph_\xca\xa3e.txt" "d-z digraph"
+
+testf "inadequate_al.txt" "is it l or is it 1"
+testf "inadequate_a1.txt" "is it l or is it 1"
+
+testf "prohibition_Rs.txt" "rupee symbol"
+testf "prohibition_\xe2\x82\xa8.txt" "rupee symbol"
+
+testf "zerojoin_moocow.txt" "zero width joiners"
+testf "zerojoin_moo\xe2\x80\x8dcow.txt" "zero width joiners"
+
+testf "combmark_\xe1\x80\x9c\xe1\x80\xad\xe1\x80\xaf.txt" "combining marks"
+testf "combmark_\xe1\x80\x9c\xe1\x80\xaf\xe1\x80\xad.txt" "combining marks"
+
 echo "Uniqueness of inodes?"
 stat -c '%i' "${testdir}/"* | sort | uniq -c | while read nr inum; do
 	if [ "${nr}" -gt 1 ]; then
@@ -170,6 +218,12 @@ if check_xfs_scrub; then
 	echo "${output}" | grep -q "french_" || echo "No complaints about french e accent?"
 	echo "${output}" | grep -q "greek_" || echo "No complaints about greek letter mess?"
 	echo "${output}" | grep -q "arabic_" || echo "No complaints about arabic expanded string?"
+	echo "${output}" | grep -q "mixed_" || echo "No complaints about mixed script confusables?"
+	echo "${output}" | grep -q "hyphens_" || echo "No complaints about hyphenation confusables?"
+	echo "${output}" | grep -q "dz_digraph_" || echo "No complaints about single script confusables?"
+	echo "${output}" | grep -q "inadequate_" || echo "No complaints about inadequate rendering confusables?"
+	echo "${output}" | grep -q "prohibition_" || echo "No complaints about prohibited sequence confusables?"
+	echo "${output}" | grep -q "zerojoin_" || echo "No complaints about zero-width join confusables?"
 	echo "Actual xfs_scrub output:" >> $seqres.full
 	echo "${output}" >> $seqres.full
 fi
diff --git a/tests/generic/454 b/tests/generic/454
index ec4fb997..fdb5ef87 100755
--- a/tests/generic/454
+++ b/tests/generic/454
@@ -114,6 +114,33 @@ setf "\x6c\x69\x6e\x65\x64\x72\x61\x77\x5f\x0a\xe2\x95\x94\xe2\x95\x90\xe2\x95\x
 setf "moo\xe2\x80\xaegnp.txt" "Well say hello,"
 setf "mootxt.png" "Harvey"
 
+# mixed-script confusables
+setf "mixed_t\xce\xbfp.txt" "greek omicron instead of o"
+setf "mixed_top.txt" "greek omicron instead of o"
+
+# single-script spoofing
+setf "hyphens_a\xe2\x80\x90b.txt" "hyphens"
+setf "hyphens_a-b.txt" "hyphens"
+
+setf "dz_digraph_dze.txt" "d-z digraph"
+setf "dz_digraph_\xca\xa3e.txt" "d-z digraph"
+
+# inadequate rendering
+setf "inadequate_al.txt" "is it l or is it 1"
+setf "inadequate_a1.txt" "is it l or is it 1"
+
+# symbols
+setf "prohibition_Rs.txt" "rupee symbol"
+setf "prohibition_\xe2\x82\xa8.txt" "rupee symbol"
+
+# zero width joiners
+setf "zerojoin_moocow.txt" "zero width joiners"
+setf "zerojoin_moo\xe2\x80\x8ccow.txt" "zero width joiners"
+
+# combining marks
+setf "combmark_\xe1\x80\x9c\xe1\x80\xad\xe1\x80\xaf.txt" "combining marks"
+setf "combmark_\xe1\x80\x9c\xe1\x80\xaf\xe1\x80\xad.txt" "combining marks"
+
 $GETFATTR_PROG --absolute-names -d "${testfile}" >> $seqres.full
 
 echo "Test files"
@@ -140,6 +167,27 @@ testf "\x6c\x69\x6e\x65\x64\x72\x61\x77\x5f\x0a\xe2\x95\x94\xe2\x95\x90\xe2\x95\
 testf "moo\xe2\x80\xaegnp.txt" "Well say hello,"
 testf "mootxt.png" "Harvey"
 
+testf "mixed_t\xce\xbfp.txt" "greek omicron instead of o"
+testf "mixed_top.txt" "greek omicron instead of o"
+
+testf "hyphens_a\xe2\x80\x90b.txt" "hyphens"
+testf "hyphens_a-b.txt" "hyphens"
+
+testf "dz_digraph_dze.txt" "d-z digraph"
+testf "dz_digraph_\xca\xa3e.txt" "d-z digraph"
+
+testf "inadequate_al.txt" "is it l or is it 1"
+testf "inadequate_a1.txt" "is it l or is it 1"
+
+testf "prohibition_Rs.txt" "rupee symbol"
+testf "prohibition_\xe2\x82\xa8.txt" "rupee symbol"
+
+testf "zerojoin_moocow.txt" "zero width joiners"
+testf "zerojoin_moo\xe2\x80\x8ccow.txt" "zero width joiners"
+
+testf "combmark_\xe1\x80\x9c\xe1\x80\xad\xe1\x80\xaf.txt" "combining marks"
+testf "combmark_\xe1\x80\x9c\xe1\x80\xaf\xe1\x80\xad.txt" "combining marks"
+
 echo "Uniqueness of keys?"
 crazy_keys="$($GETFATTR_PROG --absolute-names -d "${testfile}" | egrep -c '(french_|chinese_|greek_|arabic_|urk)')"
 expected_keys=11
@@ -166,6 +214,12 @@ if check_xfs_scrub; then
 	echo "${output}" | grep -q "french_" || echo "No complaints about french e accent?"
 	echo "${output}" | grep -q "greek_" || echo "No complaints about greek letter mess?"
 	echo "${output}" | grep -q "arabic_" || echo "No complaints about arabic expanded string?"
+	echo "${output}" | grep -q "mixed_" || echo "No complaints about mixed script confusables?"
+	echo "${output}" | grep -q "hyphens_" || echo "No complaints about hyphenation confusables?"
+	echo "${output}" | grep -q "dz_digraph_" || echo "No complaints about single script confusables?"
+	echo "${output}" | grep -q "inadequate_" || echo "No complaints about inadequate rendering confusables?"
+	echo "${output}" | grep -q "prohibition_" || echo "No complaints about prohibited sequence confusables?"
+	echo "${output}" | grep -q "zerojoin_" || echo "No complaints about zero-width join confusables?"
 	echo "Actual xfs_scrub output:" >> $seqres.full
 	echo "${output}" >> $seqres.full
 fi

