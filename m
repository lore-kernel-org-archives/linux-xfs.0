Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 059A2C3F6B0
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jul 2022 18:17:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbiG1SRU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jul 2022 14:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbiG1SRS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jul 2022 14:17:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA93558D7;
        Thu, 28 Jul 2022 11:17:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD172B824D5;
        Thu, 28 Jul 2022 18:17:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A310C433D7;
        Thu, 28 Jul 2022 18:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659032235;
        bh=ZMRRftXBZYRdKNYNL9eP7mpuXRuvArnl5y1ivd03ZP4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZN7AE32tF0vQed8lZJsa7w7JPULYdRo+V6wNZx3snQmWkAepDNY2hflJdvlb0Rxih
         qClEt4/Njuf+L6ZDL/PklAwPpB3XiZDvMIce1Ke3IUQ3Ge1x1T5gt6ga1iXOm+YML0
         h2niG5jSDRPDdMZPcya5LqyTkYH5QYJzQN7zLjNBPU/QlPNJw92V/rRA8sd65T4udp
         gdS5Fddze2WAT65s8z2qeJeQRJWfiZyDmw+FxkIfVV+ycmLVCv6LcsLpdIjX37MWfl
         p4fjF61G9o5R9oVz5Dzt09D5C4/kCAExJ4+J6prZVI9Tr4jSHuleOQwZq2ieEQuUXL
         dD9WGPHN9YYVQ==
Subject: [PATCH 1/3] xfs/432: fix this test when external devices are in use
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Thu, 28 Jul 2022 11:17:15 -0700
Message-ID: <165903223512.2338516.9583051314883581667.stgit@magnolia>
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

This program exercises metadump and mdrestore being run against the
scratch device.  Therefore, the test must pass external log / rt device
arguments to xfs_repair -n to check the "restored" filesystem.  Fix the
incorrect usage, and report repair failures, since this test has been
silently failing for a while now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/432 |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/432 b/tests/xfs/432
index 86012f0b..e1e610d0 100755
--- a/tests/xfs/432
+++ b/tests/xfs/432
@@ -89,7 +89,8 @@ _scratch_xfs_metadump $metadump_file -w
 xfs_mdrestore $metadump_file $metadump_img
 
 echo "Check restored metadump image"
-$XFS_REPAIR_PROG -n $metadump_img >> $seqres.full 2>&1
+SCRATCH_DEV=$metadump_img _scratch_xfs_repair -n &>> $seqres.full || \
+	echo "xfs_repair on restored fs returned $?"
 
 # success, all done
 status=0

