Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CCF1CD611E
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Oct 2023 18:18:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377527AbjJISSs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Oct 2023 14:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377414AbjJISSr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2023 14:18:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC129C;
        Mon,  9 Oct 2023 11:18:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF9C6C433C8;
        Mon,  9 Oct 2023 18:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696875525;
        bh=K/c+McSS3nf2yAEe8IPp5EbzoFv3mm15ig0GRn7RYbU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EQtR4O01Q8llKNCloz1Ngbh+Qu8FCCpMf+zbwi+lL8TLB9KXysm3BFan1uctTpXJy
         EbKVNH0d6hdGRxZnM0kcJDugHaRI1chcB6/w/Tk4fepqY+E+F6p9vrqUdwfHGuGtO2
         05tHQRbagm/s03XegAEAGV39UCtoRiUaYXd2qNc8ED43EFkCKirEf5Ms3TmJzYembe
         USirJvYiAgEAZsn8J2OIVE8bQJ/Wl8UEQt9Mw5BHAw305atDVL/PpPnvWEQqPiud4y
         kDawO1YEJjp+JlspJo2pYTvtLL1y4QadNEjJM7JmVbNi1aW9QAWIMVM/3tr2Yxl/Nf
         Q/CJA29YSEFvg==
Subject: [PATCH 3/3] generic/269,xfs/051: don't drop fsstress failures to
 stdout
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 09 Oct 2023 11:18:45 -0700
Message-ID: <169687552545.3948976.16961989033707045098.stgit@frogsfrogsfrogs>
In-Reply-To: <169687550821.3948976.6892161616008393594.stgit@frogsfrogsfrogs>
References: <169687550821.3948976.6892161616008393594.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Prior to commit f55e46d629, these two tests would run fsstress until it
hit a failure -- ENOSPC in the case of generic/269, and EIO in the case
of xfs/051.  These errors are expected, which was why stderr was also
redirected to /dev/null.  Commit f55e46d629 removed the stderr
redirection, which has resulted in a 100% failure rate.

Fix this regression by pushing stderr stream to $seqres.full.

Fixes: f55e46d629 ("fstests: redirect fsstress' stdout to $seqres.full instead of /dev/null")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/generic/269 |    2 +-
 tests/xfs/051     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/tests/generic/269 b/tests/generic/269
index b852f6bf7e..b7cdecd94f 100755
--- a/tests/generic/269
+++ b/tests/generic/269
@@ -23,7 +23,7 @@ _workout()
 	out=$SCRATCH_MNT/fsstress.$$
 	args=`_scale_fsstress_args -p128 -n999999999 -f setattr=1 $FSSTRESS_AVOID -d $out`
 	echo "fsstress $args" >> $seqres.full
-	$FSSTRESS_PROG $args >> $seqres.full &
+	$FSSTRESS_PROG $args &>> $seqres.full &
 	pid=$!
 	echo "Run dd writers in parallel"
 	for ((i=0; i < num_iterations; i++))
diff --git a/tests/xfs/051 b/tests/xfs/051
index 1c6709648d..aca867c940 100755
--- a/tests/xfs/051
+++ b/tests/xfs/051
@@ -38,7 +38,7 @@ _scratch_mount
 
 # Start a workload and shutdown the fs. The subsequent mount will require log
 # recovery.
-$FSSTRESS_PROG -n 9999 -p 2 -w -d $SCRATCH_MNT >> $seqres.full &
+$FSSTRESS_PROG -n 9999 -p 2 -w -d $SCRATCH_MNT &>> $seqres.full &
 sleep 5
 _scratch_shutdown -f
 $KILLALL_PROG -q $FSSTRESS_PROG

