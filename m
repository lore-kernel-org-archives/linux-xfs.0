Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 792A7C5479D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:15:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236314AbiLaDPP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:15:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236344AbiLaDO4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:14:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3FAE59;
        Fri, 30 Dec 2022 19:14:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A66C61D06;
        Sat, 31 Dec 2022 03:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E592AC433D2;
        Sat, 31 Dec 2022 03:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456495;
        bh=aatZZfEshMVICDl/LR2THfmIvimPMuKO3zsT1Z6FkzE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DiN6zNBqsbBPvfg5QS18PoC1/OdFRVw9Y1NryClF8lKOS2ltV+z6V0EZolS0ksYDT
         KP3zypsq9oRC5vPNamlOjc/TAp2JphJZDJaJE64B7smmdMJ6oFexIxbe7QBhlKrXps
         +MEz+eUJdGOhxhZIbgHxTBEB2CNCKAy8rEoIG9AlZITIgdu8c2VuicDa1X2kBCSRdT
         O1ufgtDHcBtpUwG/woNn+YtOwfbc5O8oPGELrfLHV80rMjziylNBma0aCs8YIAC4pz
         q3aMxQybalW9WhbLadnslS9WgkXFnmdv//m1EyYWzKjBP22TnH7dcB2BviStgUFH72
         oxVBrTBAGor8g==
Subject: [PATCH 09/13] xfs: skip tests if formatting small filesystem fails
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:45 -0800
Message-ID: <167243884511.739669.5884465847496705430.stgit@magnolia>
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

There are a few tests that try to exercise XFS functionality with an
unusually small (< 500MB) filesystem.  Formatting can fail if the test
configuration also specifies a very large realtime device because mkfs
hits ENOSPC when allocating the realtime metadata.  The test proceeds
anyway (which causes an immediate mount failure) so we might as well
skip these.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/104 |    1 +
 tests/xfs/291 |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/104 b/tests/xfs/104
index d16f46d8e4..c3d1d18a58 100755
--- a/tests/xfs/104
+++ b/tests/xfs/104
@@ -16,6 +16,7 @@ _create_scratch()
 {
 	echo "*** mkfs"
 	_scratch_mkfs_xfs $@ | tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
+	test "${PIPESTATUS[0]}" -eq 0 || _notrun "formatting small scratch fs failed"
 	. $tmp.mkfs
 
 	echo "*** mount"
diff --git a/tests/xfs/291 b/tests/xfs/291
index 600dcb2eba..70e5f51cee 100755
--- a/tests/xfs/291
+++ b/tests/xfs/291
@@ -18,7 +18,8 @@ _require_command "$XFS_MDRESTORE_PROG" "xfs_mdrestore"
 # real QA test starts here
 _require_scratch
 logblks=$(_scratch_find_xfs_min_logblocks -n size=16k -d size=133m)
-_scratch_mkfs_xfs -n size=16k -l size=${logblks}b -d size=133m >> $seqres.full 2>&1
+_scratch_mkfs_xfs -n size=16k -l size=${logblks}b -d size=133m >> $seqres.full 2>&1 || \
+	_notrun "formatting small scratch fs failed"
 _scratch_mount
 
 # First we cause very badly fragmented freespace, then

