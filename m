Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 635E6CCA486
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:25:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbiF1UZC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbiF1UYa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:24:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7415DE65;
        Tue, 28 Jun 2022 13:21:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9A0C6172C;
        Tue, 28 Jun 2022 20:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531E0C3411D;
        Tue, 28 Jun 2022 20:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656447717;
        bh=ySxfF9fscDH6cZg0RsDEP20WDx0C5u0nTxp0IEZHLQw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fhDDmOK8oFIujHoSSqlR+jBwD3MzA3s9xU6ZUApY3x7ibyzMvUO0p1kXhkKwiCfiY
         mCgyaC1SiAe7fYj1FZiMTio4VqHdgQX8IhGFbihrf0iyNAL6jNCSvyAsUBZCm90dn7
         LVkfmxUXeXTZYSdQqqsN55gWgRQlu6OnPd3hk77eSrpSehbVcKZUcm8kC2eaafEkMJ
         Pqz39i+mHqDBK93x4B3O3JKORGVceyy/wTsBW6ryf7Pp49Or227RQ3MwIiVWwxh/pq
         wF8BXqjNDTQoOE4pJPitiyvjYXP2kZqVQov36J87Jb4qm02RzNx/XFeoqeCggtOEr9
         GLDGS3pb2+j6A==
Subject: [PATCH 7/9] xfs/018: fix LARP testing for small block sizes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 28 Jun 2022 13:21:56 -0700
Message-ID: <165644771693.1045534.10562748026669892236.stgit@magnolia>
In-Reply-To: <165644767753.1045534.18231838177395571946.stgit@magnolia>
References: <165644767753.1045534.18231838177395571946.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix this test to work properly when the filesystem block size is less
than 4k.  Tripping the error injection points on shape changes in the
xattr structure must be done dynamically.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/018     |   52 +++++++++++++++++++++++++++++++++++++++++++++++-----
 tests/xfs/018.out |   16 ++++------------
 2 files changed, 51 insertions(+), 17 deletions(-)


diff --git a/tests/xfs/018 b/tests/xfs/018
index 041a3b24..14a6f716 100755
--- a/tests/xfs/018
+++ b/tests/xfs/018
@@ -54,6 +54,45 @@ test_attr_replay()
 	echo ""
 }
 
+test_attr_replay_loop()
+{
+	testfile=$testdir/$1
+	attr_name=$2
+	attr_value=$3
+	flag=$4
+	error_tag=$5
+
+	# Inject error
+	_scratch_inject_error $error_tag
+
+	# Set attribute; hopefully 1000 of them is enough to cause whatever
+	# attr structure shape change that the caller wants to test.
+	for ((i = 0; i < 1024; i++)); do
+		echo "$attr_value" | \
+			${ATTR_PROG} -$flag "$attr_name$i" $testfile > $tmp.out 2> $tmp.err
+		cat $tmp.out $tmp.err >> $seqres.full
+		cat $tmp.err | _filter_scratch | sed -e 's/attr_name[0-9]*/attr_nameXXXX/g'
+		touch $testfile &>/dev/null || break
+	done
+
+	# FS should be shut down, touch will fail
+	touch $testfile 2>&1 | _filter_scratch
+
+	# Remount to replay log
+	_scratch_remount_dump_log >> $seqres.full
+
+	# FS should be online, touch should succeed
+	touch $testfile
+
+	# Verify attr recovery
+	$ATTR_PROG -l $testfile >> $seqres.full
+	echo "Checking contents of $attr_name$i" >> $seqres.full
+	echo -n "${attr_name}XXXX: "
+	$ATTR_PROG -q -g $attr_name$i $testfile 2> /dev/null | md5sum;
+
+	echo ""
+}
+
 create_test_file()
 {
 	filename=$testdir/$1
@@ -88,6 +127,7 @@ echo 1 > /sys/fs/xfs/debug/larp
 attr16="0123456789ABCDEF"
 attr64="$attr16$attr16$attr16$attr16"
 attr256="$attr64$attr64$attr64$attr64"
+attr512="$attr256$attr256"
 attr1k="$attr256$attr256$attr256$attr256"
 attr4k="$attr1k$attr1k$attr1k$attr1k"
 attr8k="$attr4k$attr4k"
@@ -140,12 +180,14 @@ test_attr_replay extent_file1 "attr_name2" $attr1k "s" "larp"
 test_attr_replay extent_file1 "attr_name2" $attr1k "r" "larp"
 
 # extent, inject error on split
-create_test_file extent_file2 3 $attr1k
-test_attr_replay extent_file2 "attr_name4" $attr1k "s" "da_leaf_split"
+create_test_file extent_file2 0 $attr1k
+test_attr_replay_loop extent_file2 "attr_name" $attr1k "s" "da_leaf_split"
 
-# extent, inject error on fork transition
-create_test_file extent_file3 3 $attr1k
-test_attr_replay extent_file3 "attr_name4" $attr1k "s" "attr_leaf_to_node"
+# extent, inject error on fork transition.  The attr value must be less than
+# a full filesystem block so that the attrs don't use remote xattr values,
+# which means we miss the leaf to node transition.
+create_test_file extent_file3 0 $attr1k
+test_attr_replay_loop extent_file3 "attr_name" $attr512 "s" "attr_leaf_to_node"
 
 # extent, remote
 create_test_file extent_file4 1 $attr1k
diff --git a/tests/xfs/018.out b/tests/xfs/018.out
index 022b0ca3..c3021ee3 100644
--- a/tests/xfs/018.out
+++ b/tests/xfs/018.out
@@ -87,22 +87,14 @@ Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file
 attr_name2: d41d8cd98f00b204e9800998ecf8427e  -
 
 attr_set: Input/output error
-Could not set "attr_name4" for SCRATCH_MNT/testdir/extent_file2
+Could not set "attr_nameXXXX" for SCRATCH_MNT/testdir/extent_file2
 touch: cannot touch 'SCRATCH_MNT/testdir/extent_file2': Input/output error
-Attribute "attr_name4" has a 1025 byte value for SCRATCH_MNT/testdir/extent_file2
-Attribute "attr_name2" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file2
-Attribute "attr_name3" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file2
-Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file2
-attr_name4: 9fd415c49d67afc4b78fad4055a3a376  -
+attr_nameXXXX: 9fd415c49d67afc4b78fad4055a3a376  -
 
 attr_set: Input/output error
-Could not set "attr_name4" for SCRATCH_MNT/testdir/extent_file3
+Could not set "attr_nameXXXX" for SCRATCH_MNT/testdir/extent_file3
 touch: cannot touch 'SCRATCH_MNT/testdir/extent_file3': Input/output error
-Attribute "attr_name4" has a 1025 byte value for SCRATCH_MNT/testdir/extent_file3
-Attribute "attr_name2" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file3
-Attribute "attr_name3" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file3
-Attribute "attr_name1" has a 1024 byte value for SCRATCH_MNT/testdir/extent_file3
-attr_name4: 9fd415c49d67afc4b78fad4055a3a376  -
+attr_nameXXXX: a597dc41e4574873516420a7e4e5a3e0  -
 
 attr_set: Input/output error
 Could not set "attr_name2" for SCRATCH_MNT/testdir/extent_file4

