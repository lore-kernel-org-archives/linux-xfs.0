Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 463D0C00140
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jul 2022 19:51:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbiGZTvf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jul 2022 15:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiGZTvf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jul 2022 15:51:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6992A2D1E9;
        Tue, 26 Jul 2022 12:51:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 255F4B80919;
        Tue, 26 Jul 2022 19:51:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4927C433C1;
        Tue, 26 Jul 2022 19:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658865091;
        bh=sfhzxWbPCt2kFdrPGCy2pcQ3fa5/KcT55syC5Ah0gvk=;
        h=Date:From:To:Cc:Subject:From;
        b=Ssa2TCfYkVdfie1EgciAEUgJyJDJZ2fjALrGZijeLMuPI28MSrKc2NEXfzblkayEZ
         X1jmRcbs7S+0JbRUGD8CuwmjRsanHsDaocPDdhZ4kUf4cBgA6PlCPtWoHi7HtDqtjv
         dwV4D81gJwFwSrwtN4FoKwRPFck/V2aBFzKO9Y3ukgr0pcNqpVzyMiqLMYId4gnCOt
         m1b96aA7jerjPXRg0HO7NjGydITcx3x/wqum6q0XREWkvJs0pzsb9uCt4jJWug1lr2
         u1IBeYTvm2LlSUmIlSIKEmR0hOYtpLis/EKtzohsNQvdFRn77auEymux4FDmTd7RcC
         eh7yrAlF6NMpg==
Date:   Tue, 26 Jul 2022 12:51:31 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: [PATCH] xfs/432: fix this test when external devices are in use
Message-ID: <YuBFw4dheeSRHVQd@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This program exercises metadump and mdrestore being run against the
scratch device.  Therefore, the test must pass external log / rt device
arguments to xfs_repair -n to check the "restored" filesystem.  Fix the
incorrect usage, and report repair failures, since this test has been
silently failing for a while now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/432 |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tests/xfs/432 b/tests/xfs/432
index 86012f0b..5c6744ce 100755
--- a/tests/xfs/432
+++ b/tests/xfs/432
@@ -89,7 +89,16 @@ _scratch_xfs_metadump $metadump_file -w
 xfs_mdrestore $metadump_file $metadump_img
 
 echo "Check restored metadump image"
-$XFS_REPAIR_PROG -n $metadump_img >> $seqres.full 2>&1
+repair_args=('-n')
+[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
+	repair_args+=('-l' "$SCRATCH_LOGDEV")
+
+[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
+	repair_args+=('-r' "$SCRATCH_RTDEV")
+
+$XFS_REPAIR_PROG "${repair_args[@]}" $metadump_img >> $seqres.full 2>&1
+res=$?
+test $res -ne 0 && echo "xfs_repair on restored fs returned $res?"
 
 # success, all done
 status=0
