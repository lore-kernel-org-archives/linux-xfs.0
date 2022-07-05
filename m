Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72B7FCCA481
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jul 2022 22:02:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbiGEWCj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jul 2022 18:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232880AbiGEWCg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jul 2022 18:02:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9EE519286;
        Tue,  5 Jul 2022 15:02:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 641B36189F;
        Tue,  5 Jul 2022 22:02:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C445EC341C7;
        Tue,  5 Jul 2022 22:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657058554;
        bh=hj7SsFQ2BVwEvR/3eg/C5ncWvz0E286mfFtVaNz4xWo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=b8ibMU/CXdzEIeaL81gEUk5rLe9tPHgxL75dp0umRKcdz+KcDC/46dwbYQzfjxWJ+
         25R3+N8puUnqO8zNOBKG30d8FMDoIu2cqE3hMiEKk0bXCnsxhPBfyl7PvEveu3gcqB
         AsHRcd0Pvp2KGKzAFkDl03ewOxauUBFIus7krzs5/UlBxf5qMqu3KKq3s+MXqnh0Rl
         MQ4YoPJCCjlQC8IPeiA0YlwJeRRvfY9XLHU3ahkVhH89yuJd8XuSyEiu5KkpSNWRfD
         hTMO3c8PMCAg+OedYLZPZjEqPF6olKh9QSxYNEzg+QTLGgCUZvzVMN052qTcJ4Z70d
         kDBafDDOVJ78Q==
Subject: [PATCH 2/2] xfs/288: skip repair -n when checking empty root leaf
 block behavior
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 05 Jul 2022 15:02:34 -0700
Message-ID: <165705855433.2821854.6003804324518144422.stgit@magnolia>
In-Reply-To: <165705854325.2821854.10317059026052442189.stgit@magnolia>
References: <165705854325.2821854.10317059026052442189.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Update this test to reflect the (once again) corrected behavior of the
xattr leaf block verifiers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/288 |   32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)


diff --git a/tests/xfs/288 b/tests/xfs/288
index e3d230e9..aa664a26 100755
--- a/tests/xfs/288
+++ b/tests/xfs/288
@@ -8,7 +8,7 @@
 # that leaf directly (as xfsprogs commit f714016).
 #
 . ./common/preamble
-_begin_fstest auto quick repair fuzzers
+_begin_fstest auto quick repair fuzzers attr
 
 # Import common functions.
 . ./common/filter
@@ -50,25 +50,19 @@ if [ "$count" != "0" ]; then
 	_notrun "xfs_db can't set attr hdr.count to 0"
 fi
 
-# make sure xfs_repair can find above corruption. If it can't, that
-# means we need to fix this bug on current xfs_repair
-_scratch_xfs_repair -n >> $seqres.full 2>&1
-if [ $? -eq 0 ];then
-	_fail "xfs_repair can't find the corruption"
-else
-	# If xfs_repair can find this corruption, then this repair
-	# should junk above leaf attribute and fix this XFS.
-	_scratch_xfs_repair >> $seqres.full 2>&1
+# Check that xfs_repair discards the attr fork if block 0 is an empty leaf
+# block.  Empty leaf blocks at the start of the xattr data can be a byproduct
+# of a shutdown race, and hence are not a corruption.
+_scratch_xfs_repair >> $seqres.full 2>&1
 
-	# Old xfs_repair maybe find and fix this corruption by
-	# reset the first used heap value and the usedbytes cnt
-	# in ablock 0. That's not what we want. So check if
-	# xfs_repair has junked the whole ablock 0 by xfs_db.
-	_scratch_xfs_db -x -c "inode $inum" -c "ablock 0" | \
-		grep -q "no attribute data"
-	if [ $? -ne 0 ]; then
-		_fail "xfs_repair didn't junk the empty attr leaf"
-	fi
+# Old xfs_repair maybe find and fix this corruption by
+# reset the first used heap value and the usedbytes cnt
+# in ablock 0. That's not what we want. So check if
+# xfs_repair has junked the whole ablock 0 by xfs_db.
+_scratch_xfs_db -x -c "inode $inum" -c "ablock 0" | \
+	grep -q "no attribute data"
+if [ $? -ne 0 ]; then
+	_fail "xfs_repair didn't junk the empty attr leaf"
 fi
 
 echo "Silence is golden"

