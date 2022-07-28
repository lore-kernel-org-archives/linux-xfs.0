Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7E11C19F2B
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jul 2022 18:17:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbiG1SRZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jul 2022 14:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbiG1SRY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jul 2022 14:17:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E128B5F9AB;
        Thu, 28 Jul 2022 11:17:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D6FCB824D7;
        Thu, 28 Jul 2022 18:17:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45376C433D6;
        Thu, 28 Jul 2022 18:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659032241;
        bh=4SM+xsPZ1++hpEVq3WRJzUiT4xpxCOrjhvSn7fUSoas=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pAz3ZLqc+uzXkcOkgdNxhIkbnolZzg3kq5XVtYBvULnOjERXCylt0Cl2nCkkBa/w/
         AnbOa0f1XrY8cCSIsZxhJglvUN3hhYlYfiFnC10g/nRxmegPAgga6cVvbi4IKtonC6
         HFDy0y/Kiinb8xD6+TqN1HUOtbnYKHnzyCnDLTfbNJAoEgUr4yTztVgpRisbweQxdB
         DpVbv/KuXVYar9uqwY+nGClhttbbKV1fdZOAybeZBXwceufxjA9oOza7wYbFGu+MPD
         Fjv5aU2oG9yYEvOaqNWK3nx5PzfCxX6ILRaSApW55JRE5m74LPWUuSFYlwISW77F7z
         +8XiPS8rOScBw==
Subject: [PATCH 2/3] xfs/291: convert open-coded _scratch_xfs_repair usage
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Thu, 28 Jul 2022 11:17:20 -0700
Message-ID: <165903224078.2338516.14554764802610406233.stgit@magnolia>
In-Reply-To: <165903222941.2338516.818684834175743726.stgit@magnolia>
References: <165903222941.2338516.818684834175743726.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Convert this test to use _scratch_xfs_repair, since the only variance
from the standard usage is that it's called against a sparse file into
which the scratch filesystem has been metadumped and mdrestored.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/291 |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)


diff --git a/tests/xfs/291 b/tests/xfs/291
index 6d5e247e..a2425e47 100755
--- a/tests/xfs/291
+++ b/tests/xfs/291
@@ -93,11 +93,7 @@ _scratch_xfs_check >> $seqres.full 2>&1 || _fail "xfs_check failed"
 # Can xfs_metadump cope with this monster?
 _scratch_xfs_metadump $tmp.metadump || _fail "xfs_metadump failed"
 xfs_mdrestore $tmp.metadump $tmp.img || _fail "xfs_mdrestore failed"
-[ "$USE_EXTERNAL" = yes ] && [ -n "$SCRATCH_RTDEV" ] && \
-	rt_repair_opts="-r $SCRATCH_RTDEV"
-[ "$USE_EXTERNAL" = yes ] && [ -n "$SCRATCH_LOGDEV" ] && \
-	log_repair_opts="-l $SCRATCH_LOGDEV"
-$XFS_REPAIR_PROG $rt_repair_opts $log_repair_opts -f $tmp.img >> $seqres.full 2>&1 || \
+SCRATCH_DEV=$tmp.img _scratch_xfs_repair -f &>> $seqres.full || \
 	_fail "xfs_repair of metadump failed"
 
 # Yes it can; success, all done

