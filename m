Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3909C3F6B0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Aug 2022 04:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiHCEVf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Aug 2022 00:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233759AbiHCEVe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Aug 2022 00:21:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD5747BBA;
        Tue,  2 Aug 2022 21:21:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEADA612F1;
        Wed,  3 Aug 2022 04:21:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197DCC433D6;
        Wed,  3 Aug 2022 04:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659500492;
        bh=4SM+xsPZ1++hpEVq3WRJzUiT4xpxCOrjhvSn7fUSoas=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eR+mmG4MtA0Z7KrjppeyeeH/UtyfKVeLEr28VuFsS211rw/k+es42m2YJeFe2i3K3
         KVSxj88WR/wkGN2UcadN05Ri9cFLE8bT+ibFstrh5malMeLUGewsyD/o81rh4pJqN0
         8APm/7qPFhRF+aoIiOk+FPi5A/WxTG/06GChxDpbjKoEsmMOBthA5g9kSIPqzkVmpF
         MUIb5RGK3SzI5NRfWWBPMTDbNrR4Kp2UnvYoRQ2ZwX7v1bz1w6D7UITO9nZuYJg1YN
         rhdSmUXLT58PxH3moKgliuwsUqD4MRnAVeqFK98RK8vulpGs8Cwe+GdLHBcnelzuNC
         OhYqZn0DmGu/g==
Subject: [PATCH 2/3] xfs/291: convert open-coded _scratch_xfs_repair usage
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 02 Aug 2022 21:21:31 -0700
Message-ID: <165950049164.198815.17444582280704119144.stgit@magnolia>
In-Reply-To: <165950048029.198815.11843926234080013062.stgit@magnolia>
References: <165950048029.198815.11843926234080013062.stgit@magnolia>
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

