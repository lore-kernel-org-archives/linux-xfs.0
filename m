Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ED19C4167B
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236311AbiLaDOk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236274AbiLaDOL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:14:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FCAE59;
        Fri, 30 Dec 2022 19:14:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BF4EB81DF4;
        Sat, 31 Dec 2022 03:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48335C433D2;
        Sat, 31 Dec 2022 03:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456448;
        bh=eKweqmmK1IHTPih4dDKHKrkHOW6OO0+H6TWr1S8/ZWc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kOnWtW+q4kYKiRlqRy347DKFMDh+03mtFTP8eyDtnhblOndUROWETkbzuoYg3Coka
         OkJ3KPpWRVnvE73TOJQn4UzFp6cSFz54lBHjHLLpibZJPmaZmnRfxAbauRC+pbTMc8
         5NZfhpp4M/078HBAkIjC1gwBUead3PCaZN53+myUQ+lT8SAAgAF7wX0HtCpL/EcTd0
         uBOLaylD8X2NRcRXrDX5pktSDiQTO74vNyoVFoQKNZNWWniu5oGEkcc3VDchcSa2Av
         ocuOkKW7pQB6IVHZqSntO8VqgYSLhly+/nNizEK32tVxHvpPlqj0rbnKs7M8rZd755
         onKgpvv+sY7lw==
Subject: [PATCH 06/13] xfs: fix various problems with fsmap detecting the data
 device
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:44 -0800
Message-ID: <167243884472.739669.5281387878552818216.stgit@magnolia>
In-Reply-To: <167243884390.739669.13524725872131241203.stgit@magnolia>
References: <167243884390.739669.13524725872131241203.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Various tests of realtime rmap functionality assumed that the data
device could be picked out from the GETFSMAP output by looking for
static fs metadata.  This is no longer true, since rtgroups have a
static superblock header at the start, so update these tests.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/272 |    2 +-
 tests/xfs/276 |    2 +-
 tests/xfs/277 |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/tests/xfs/272 b/tests/xfs/272
index 7ed8b95122..42b4a2edb5 100755
--- a/tests/xfs/272
+++ b/tests/xfs/272
@@ -57,7 +57,7 @@ cat $TEST_DIR/bmap | while read ext offrange colon blockrange ag agrange total c
 done
 
 echo "Check device field of FS metadata and regular file"
-data_dev=$(grep 'static fs metadata' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
+data_dev=$(grep 'inode btree' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
 rt_dev=$(grep "${ino}[[:space:]]*[0-9]*\.\.[0-9]*" $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
 test "${data_dev}" = "${rt_dev}" || echo "data ${data_dev} realtime ${rt_dev}?"
 
diff --git a/tests/xfs/276 b/tests/xfs/276
index 8cc486752a..a05ca1961d 100755
--- a/tests/xfs/276
+++ b/tests/xfs/276
@@ -61,7 +61,7 @@ cat $TEST_DIR/bmap | while read ext offrange colon blockrange ag agrange total c
 done
 
 echo "Check device field of FS metadata and realtime file"
-data_dev=$(grep 'static fs metadata' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
+data_dev=$(grep 'inode btree' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
 rt_dev=$(grep "${ino}[[:space:]]*[0-9]*\.\.[0-9]*[[:space:]]*[0-9]*$" $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
 test "${data_dev}" != "${rt_dev}" || echo "data ${data_dev} realtime ${rt_dev}?"
 
diff --git a/tests/xfs/277 b/tests/xfs/277
index 03208ef233..eff54a2a50 100755
--- a/tests/xfs/277
+++ b/tests/xfs/277
@@ -38,7 +38,7 @@ $XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT >> $seqres.full
 $XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT | tr '[]()' '    ' > $TEST_DIR/fsmap
 
 echo "Check device field of FS metadata and journalling log"
-data_dev=$(grep 'static fs metadata' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
+data_dev=$(grep 'inode btree' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
 journal_dev=$(grep 'journalling log' $TEST_DIR/fsmap | head -n 1 | awk '{print $2}')
 test "${data_dev}" = "${journal_dev}" || echo "data ${data_dev} journal ${journal_dev}?"
 

