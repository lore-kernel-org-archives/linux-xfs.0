Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C955BC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbjBPVRR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:17:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjBPVRR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:17:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D13C48E22;
        Thu, 16 Feb 2023 13:17:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40AEFB8295B;
        Thu, 16 Feb 2023 21:17:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8270C433D2;
        Thu, 16 Feb 2023 21:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676582234;
        bh=UIZczfgKMoAbondSMQ3yRYrjcrJZ+bWoTggKD3FCZdc=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=p+2MPgYq7LkT/9uRFtDSVItR7ePGiHSZf9fyw2UMGM61v3ffch8Q4wbpBKQa2109G
         erelQakxVqa/I8CMbT5V9vRrX2uHJMb/C794cqtV+gDjP/Wjzr0y2VfUKo7bsDLUu7
         plwYnKPQSew9v1lg6KfMRvJiz2QOTdZ9HjJFyTt2bD3bAEFliCoYgYtgm9SpwByw4b
         AJd5dM0q/m1NdzGkuDS3WC6QudgHcnx/tafaw49fHtjegtai7bsbmc5dBw63D3MkBL
         Zz0SBfIslI9O110KV24mGcjfM68hO0Ngpe6Gtcb32HTvO4Vsl0ZmPtm7sRl6WYPq1l
         omFchqvqQ1ZXQ==
Date:   Thu, 16 Feb 2023 13:17:13 -0800
Subject: [PATCH 14/14] xfs/851: test xfs_io parent -p too
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167657884674.3481377.15890437959517236282.stgit@magnolia>
In-Reply-To: <167657884480.3481377.14824439551809919632.stgit@magnolia>
References: <167657884480.3481377.14824439551809919632.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Test the -p argument to the xfs_io parent command too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/851     |   15 +++++++++++++++
 tests/xfs/851.out |   10 ++++++++++
 2 files changed, 25 insertions(+)


diff --git a/tests/xfs/851 b/tests/xfs/851
index 27870ec05a..8233c1563c 100755
--- a/tests/xfs/851
+++ b/tests/xfs/851
@@ -12,6 +12,7 @@ _begin_fstest auto quick parent
 
 # get standard environment, filters and checks
 . ./common/parent
+. ./common/filter
 
 # Modify as appropriate
 _supported_fs xfs
@@ -96,6 +97,20 @@ ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder2/$file3)"
 mv -f $SCRATCH_MNT/$testfolder2/$file3 $SCRATCH_MNT/$testfolder1/$file2
 _verify_parent "$testfolder1" "$file2" "$testfolder1/$file2"
 
+# Make sure that parent -p filtering works
+mkdir -p $SCRATCH_MNT/dira/ $SCRATCH_MNT/dirb/
+dira_inum=$(stat -c '%i' $SCRATCH_MNT/dira)
+dirb_inum=$(stat -c '%i' $SCRATCH_MNT/dirb)
+touch $SCRATCH_MNT/gorn
+ln $SCRATCH_MNT/gorn $SCRATCH_MNT/dira/file1
+ln $SCRATCH_MNT/gorn $SCRATCH_MNT/dirb/file1
+echo look for both
+$XFS_IO_PROG -c 'parent -p' $SCRATCH_MNT/gorn | _filter_scratch
+echo look for dira
+$XFS_IO_PROG -c 'parent -p -n dira' -c "parent -p -i $dira_inum" $SCRATCH_MNT/gorn | _filter_scratch
+echo look for dirb
+$XFS_IO_PROG -c 'parent -p -n dirb' -c "parent -p -i $dirb_inum" $SCRATCH_MNT/gorn | _filter_scratch
+
 # success, all done
 status=0
 exit
diff --git a/tests/xfs/851.out b/tests/xfs/851.out
index c375ba5f00..f44d3e5d4f 100644
--- a/tests/xfs/851.out
+++ b/tests/xfs/851.out
@@ -57,3 +57,13 @@ QA output created by 851
 *** testfolder1/file2 OK
 *** Verified parent pointer: name:file2, namelen:5
 *** Parent pointer OK for child testfolder1/file2
+look for both
+SCRATCH_MNT/gorn
+SCRATCH_MNT/dira/file1
+SCRATCH_MNT/dirb/file1
+look for dira
+SCRATCH_MNT/dira/file1
+SCRATCH_MNT/dira/file1
+look for dirb
+SCRATCH_MNT/dirb/file1
+SCRATCH_MNT/dirb/file1

