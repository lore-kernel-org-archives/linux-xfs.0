Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A664AC4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Oct 2022 22:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiJEWaz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Oct 2022 18:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiJEWay (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Oct 2022 18:30:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77A44684F;
        Wed,  5 Oct 2022 15:30:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AE5DB81F77;
        Wed,  5 Oct 2022 22:30:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0ACC433C1;
        Wed,  5 Oct 2022 22:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665009050;
        bh=dlCzwYSZL2S46PhtKd3S9gifQBXljx74ZQCC7k/4cgE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TTOzgwJWH6YaCYaSwQVdAKBX0A2exj/K1QTRat85cKLjPTe/B2o2Iwt965KNYJaWz
         Qg/CB+wOhGTztqb0lXS0XlKI84FgFCcktVccP4PgE0loff/csmgAeMJcm/rqLK+udl
         kVrwuFaTg7zUmxYajBtJfwzRjF/hopV2zSdXqdngc9ppeC36W9DeWThdJAPkB3kNye
         2VeluK9BICBlhhsDVym+Fj8rpR1fxoPiDpNC4r2AEtOHD5Ny638r+bo3cnpjn0Oyl3
         aUOLE/W+MsyeXO9CSsj/Q5bgZBWR5YJBW8RxOkgo1Oq/nZ1khhCAJcOizgvixtZjNK
         62WWdN6rSb+JQ==
Subject: [PATCH 3/6] xfs/229: do not _xfs_force_bdev on TEST_DIR
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 05 Oct 2022 15:30:49 -0700
Message-ID: <166500904980.886939.602653090532563176.stgit@magnolia>
In-Reply-To: <166500903290.886939.12532028548655386973.stgit@magnolia>
References: <166500903290.886939.12532028548655386973.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In commit ea15099b71, I observed that this test tries to test the
behavior of the extent size hint on the data device.  If the test runner
set up MKFS_OPTIONS such that the filesystem gets created with a
realtime section and rtinherit set on the root directory, then the
preconditions of this test (creating files on the data section) is not
satisfied and the results of this test are incorrect.  The solution was
to force all files created by this test to be assigned to the data
section.

Unfortunately, the correction that I made has side effects beyond this
test -- by clearing rtinherit on $TEST_DIR, all tests that run after
this one will create files on the data section, because the test
filesystem persists for the duration of the entire test run.  This leads
to the wrong things being tested.

Fix this new problem by clearing the rtinherit flag on $TDIR, which
contains the files created by this test and is removed during cleanup,
and leave a few comments celebrating our new discoveries.

Fixes: ea15099b71 ("xfs: force file creation to the data device for certain layout tests")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Zorro Lang <zlang@redhat.com>
---
 common/xfs    |    3 +++
 tests/xfs/229 |    7 ++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)


diff --git a/common/xfs b/common/xfs
index 170dd621a1..e1c15d3d04 100644
--- a/common/xfs
+++ b/common/xfs
@@ -201,6 +201,9 @@ _xfs_get_file_block_size()
 # For each directory, each file subsequently created will target the given
 # device for file data allocations.  For each empty regular file, each
 # subsequent file data allocation will be on the given device.
+#
+# NOTE: If you call this on $TEST_DIR, you must reset the rtinherit flag state
+# before the end of the test to avoid polluting subsequent tests.
 _xfs_force_bdev()
 {
 	local device="$1"
diff --git a/tests/xfs/229 b/tests/xfs/229
index 2221b9c49c..a58fd16bba 100755
--- a/tests/xfs/229
+++ b/tests/xfs/229
@@ -31,11 +31,16 @@ _require_fs_space $TEST_DIR 3200000
 TDIR="${TEST_DIR}/t_holes"
 NFILES="10"
 EXTSIZE="256k"
-_xfs_force_bdev data $TEST_DIR
 
 # Create the test directory
 mkdir ${TDIR}
 
+# Per-directory extent size hints aren't particularly useful for files that
+# are created on the realtime section.  Force the test file to be created on
+# the data directory.  Do not change the rtinherit flag on $TEST_DIR because
+# that will affect other tests.
+_xfs_force_bdev data $TDIR
+
 # Set the test directory extsize
 $XFS_IO_PROG -c "extsize ${EXTSIZE}" ${TDIR}
 

