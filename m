Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4FB9C10F1B
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Dec 2022 19:45:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236310AbiLMTpM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Dec 2022 14:45:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235584AbiLMTpI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Dec 2022 14:45:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3EB4DFF6;
        Tue, 13 Dec 2022 11:45:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C675616F0;
        Tue, 13 Dec 2022 19:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC4E8C433D2;
        Tue, 13 Dec 2022 19:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670960706;
        bh=b+Ql+nwl1rhpfdKKAtN5ki3pVQ76+eJ9qWrPXUZf9R0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cLYSAOQoKIHkABPOHAXPG11RZbDzAQbQ5RjWCI6njHANB6A4MWPrlCJs9cYtYEqbh
         WlMkLqKXc0oZSzRYeuCUZqrc7g3D/afxY3aMAPgqiTUj7WXsac+5U9CECY7wNDD1Wd
         o+Re4li7FZgiFUy17cVUuEe9v30zD4fqjKfoAvZvGVTkqA+Uj0LYmkt+nlAfLdbaN6
         p1D/xQlsoIHWmBT6tCOUuByz3QNcRTet6coXOcVA5OuQIeEFjotoUiCDf0B/AvWafW
         6PyEznL2F8HGyUSqDIXWNmVIu/0ba3rW9coMU/x6kRruEN84DundxniFuZbywVRKLf
         l+DViS7AYejfw==
Subject: [PATCH 1/1] xfs/018: fix attr value setting in this test
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 13 Dec 2022 11:45:06 -0800
Message-ID: <167096070641.1750295.6163778912389454686.stgit@magnolia>
In-Reply-To: <167096070077.1750295.8747848396576357881.stgit@magnolia>
References: <167096070077.1750295.8747848396576357881.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

I was testing a patch to strengthen the buffer length validation of attr
log intent items during log recovery, when I noticed that the lengths of
the logged values were (mostly) a single byte larger than the alleged
attribute value.  Upon further investigation, I noticed this code in the
test:

echo "$attr_value" | attr -s <attrname> <testfile>

The 'echo' command generally emits a newline before exiting, which
means that the 16-byte "attr16" value was actually storing 17 bytes.
This affects all the test cases except for the attr64k tests, since the
attr(1) command helpfully/silently truncates the value buffer at 65536
bytes.

Fix the test to store values of exactly the length we want, and add a
couple more test cases to check that everything still works when the
value length is not an exact multiple of sizeof(u32).

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/018     |   17 +++++++++++++++--
 tests/xfs/018.out |   42 +++++++++++++++++++++++++++++++-----------
 2 files changed, 46 insertions(+), 13 deletions(-)


diff --git a/tests/xfs/018 b/tests/xfs/018
index 1b45edf492..1ef51a2e61 100755
--- a/tests/xfs/018
+++ b/tests/xfs/018
@@ -33,8 +33,9 @@ test_attr_replay()
 	# Inject error
 	_scratch_inject_error $error_tag
 
-	# Set attribute
-	echo "$attr_value" | ${ATTR_PROG} -$flag "$attr_name" $testfile 2>&1 | \
+	# Set attribute, being careful not to include the trailing newline
+	# in the attr value.
+	echo -n "$attr_value" | ${ATTR_PROG} -$flag "$attr_name" $testfile 2>&1 | \
 			    _filter_scratch
 
 	# FS should be shut down, touch will fail
@@ -87,6 +88,7 @@ ORIG_XFS_LARP=`cat /sys/fs/xfs/debug/larp`
 echo 1 > /sys/fs/xfs/debug/larp
 
 attr16="0123456789ABCDEF"
+attr17="X$attr16"
 attr64="$attr16$attr16$attr16$attr16"
 attr256="$attr64$attr64$attr64$attr64"
 attr1k="$attr256$attr256$attr256$attr256"
@@ -94,6 +96,7 @@ attr4k="$attr1k$attr1k$attr1k$attr1k"
 attr8k="$attr4k$attr4k"
 attr16k="$attr8k$attr8k"
 attr32k="$attr16k$attr16k"
+attr32l="X$attr32k"
 attr64k="$attr32k$attr32k"
 
 echo "*** mkfs"
@@ -114,6 +117,11 @@ create_test_file empty_file1 0
 test_attr_replay empty_file1 "attr_name" $attr64 "s" "larp"
 test_attr_replay empty_file1 "attr_name" $attr64 "r" "larp"
 
+# empty, inline with an unaligned value
+create_test_file empty_fileX 0
+test_attr_replay empty_fileX "attr_nameX" $attr17 "s" "larp"
+test_attr_replay empty_fileX "attr_nameX" $attr17 "r" "larp"
+
 # empty, internal
 create_test_file empty_file2 0
 test_attr_replay empty_file2 "attr_name" $attr1k "s" "larp"
@@ -124,6 +132,11 @@ create_test_file empty_file3 0
 test_attr_replay empty_file3 "attr_name" $attr64k "s" "larp"
 test_attr_replay empty_file3 "attr_name" $attr64k "r" "larp"
 
+# empty, remote with an unaligned value
+create_test_file empty_fileY 0
+test_attr_replay empty_fileY "attr_name" $attr32l "s" "larp"
+test_attr_replay empty_fileY "attr_name" $attr32l "r" "larp"
+
 # inline, inline
 create_test_file inline_file1 1 $attr16
 test_attr_replay inline_file1 "attr_name2" $attr64 "s" "larp"
diff --git a/tests/xfs/018.out b/tests/xfs/018.out
index 415ecd7a0c..ad8fd5266f 100644
--- a/tests/xfs/018.out
+++ b/tests/xfs/018.out
@@ -4,17 +4,27 @@ QA output created by 018
 attr_set: Input/output error
 Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file1
 touch: cannot touch 'SCRATCH_MNT/testdir/empty_file1': Input/output error
-attr_name: cfbe2a33be4601d2b655d099a18378fc  -
+attr_name: e889d82dd111d6315d7b1edce2b1b30f  -
 
 attr_remove: Input/output error
 Could not remove "attr_name" for SCRATCH_MNT/testdir/empty_file1
 touch: cannot touch 'SCRATCH_MNT/testdir/empty_file1': Input/output error
 attr_name: d41d8cd98f00b204e9800998ecf8427e  -
 
+attr_set: Input/output error
+Could not set "attr_nameX" for SCRATCH_MNT/testdir/empty_fileX
+touch: cannot touch 'SCRATCH_MNT/testdir/empty_fileX': Input/output error
+attr_nameX: cb72c43fb97dd3cb4ac6ad2d9bd365e1  -
+
+attr_remove: Input/output error
+Could not remove "attr_nameX" for SCRATCH_MNT/testdir/empty_fileX
+touch: cannot touch 'SCRATCH_MNT/testdir/empty_fileX': Input/output error
+attr_nameX: d41d8cd98f00b204e9800998ecf8427e  -
+
 attr_set: Input/output error
 Could not set "attr_name" for SCRATCH_MNT/testdir/empty_file2
 touch: cannot touch 'SCRATCH_MNT/testdir/empty_file2': Input/output error
-attr_name: 9fd415c49d67afc4b78fad4055a3a376  -
+attr_name: 4198214ee02e6ad7ac39559cd3e70070  -
 
 attr_remove: Input/output error
 Could not remove "attr_name" for SCRATCH_MNT/testdir/empty_file2
@@ -31,10 +41,20 @@ Could not remove "attr_name" for SCRATCH_MNT/testdir/empty_file3
 touch: cannot touch 'SCRATCH_MNT/testdir/empty_file3': Input/output error
 attr_name: d41d8cd98f00b204e9800998ecf8427e  -
 
+attr_set: Input/output error
+Could not set "attr_name" for SCRATCH_MNT/testdir/empty_fileY
+touch: cannot touch 'SCRATCH_MNT/testdir/empty_fileY': Input/output error
+attr_name: 3ad10faae9dcfa4083f8dfa641688733  -
+
+attr_remove: Input/output error
+Could not remove "attr_name" for SCRATCH_MNT/testdir/empty_fileY
+touch: cannot touch 'SCRATCH_MNT/testdir/empty_fileY': Input/output error
+attr_name: d41d8cd98f00b204e9800998ecf8427e  -
+
 attr_set: Input/output error
 Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file1
 touch: cannot touch 'SCRATCH_MNT/testdir/inline_file1': Input/output error
-attr_name2: cfbe2a33be4601d2b655d099a18378fc  -
+attr_name2: e889d82dd111d6315d7b1edce2b1b30f  -
 
 attr_remove: Input/output error
 Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file1
@@ -44,7 +64,7 @@ attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
 attr_set: Input/output error
 Could not set "attr_name2" for SCRATCH_MNT/testdir/inline_file2
 touch: cannot touch 'SCRATCH_MNT/testdir/inline_file2': Input/output error
-attr_name2: 9fd415c49d67afc4b78fad4055a3a376  -
+attr_name2: 4198214ee02e6ad7ac39559cd3e70070  -
 
 attr_remove: Input/output error
 Could not remove "attr_name2" for SCRATCH_MNT/testdir/inline_file2
@@ -64,7 +84,7 @@ attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
 attr_set: Input/output error
 Could not set "attr_name2" for SCRATCH_MNT/testdir/extent_file1
 touch: cannot touch 'SCRATCH_MNT/testdir/extent_file1': Input/output error
-attr_name2: 9fd415c49d67afc4b78fad4055a3a376  -
+attr_name2: 4198214ee02e6ad7ac39559cd3e70070  -
 
 attr_remove: Input/output error
 Could not remove "attr_name2" for SCRATCH_MNT/testdir/extent_file1
@@ -74,12 +94,12 @@ attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
 attr_set: Input/output error
 Could not set "attr_name4" for SCRATCH_MNT/testdir/extent_file2
 touch: cannot touch 'SCRATCH_MNT/testdir/extent_file2': Input/output error
-attr_name4: f4ea5799d72a0a9bf2d56a685c9cba7a  -
+attr_name4: 5bbe95fdc1361656e833390aefafceb6  -
 
 attr_set: Input/output error
 Could not set "attr_name4" for SCRATCH_MNT/testdir/extent_file3
 touch: cannot touch 'SCRATCH_MNT/testdir/extent_file3': Input/output error
-attr_name4: f4ea5799d72a0a9bf2d56a685c9cba7a  -
+attr_name4: 5bbe95fdc1361656e833390aefafceb6  -
 
 attr_set: Input/output error
 Could not set "attr_name2" for SCRATCH_MNT/testdir/extent_file4
@@ -94,7 +114,7 @@ attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
 attr_set: Input/output error
 Could not set "attr_name2" for SCRATCH_MNT/testdir/remote_file1
 touch: cannot touch 'SCRATCH_MNT/testdir/remote_file1': Input/output error
-attr_name2: 9fd415c49d67afc4b78fad4055a3a376  -
+attr_name2: 4198214ee02e6ad7ac39559cd3e70070  -
 
 attr_remove: Input/output error
 Could not remove "attr_name2" for SCRATCH_MNT/testdir/remote_file1
@@ -114,16 +134,16 @@ attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
 attr_set: Input/output error
 Could not set "attr_name2" for SCRATCH_MNT/testdir/sf_file
 touch: cannot touch 'SCRATCH_MNT/testdir/sf_file': Input/output error
-attr_name2: 9a6eb1bc9da3c66a9b495dfe2fe8a756  -
+attr_name2: e43df9b5a46b755ea8f1b4dd08265544  -
 
 attr_set: Input/output error
 Could not set "attr_name2" for SCRATCH_MNT/testdir/leaf_file
 touch: cannot touch 'SCRATCH_MNT/testdir/leaf_file': Input/output error
-attr_name2: f4ea5799d72a0a9bf2d56a685c9cba7a  -
+attr_name2: 5bbe95fdc1361656e833390aefafceb6  -
 
 attr_set: Input/output error
 Could not set "attr_name2" for SCRATCH_MNT/testdir/node_file
 touch: cannot touch 'SCRATCH_MNT/testdir/node_file': Input/output error
-attr_name2: f4ea5799d72a0a9bf2d56a685c9cba7a  -
+attr_name2: 5bbe95fdc1361656e833390aefafceb6  -
 
 *** done

