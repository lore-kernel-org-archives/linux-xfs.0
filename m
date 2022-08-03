Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77248C3F6B0
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Aug 2022 04:21:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbiHCEV3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Aug 2022 00:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbiHCEV2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Aug 2022 00:21:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA743FA29;
        Tue,  2 Aug 2022 21:21:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1955D612BE;
        Wed,  3 Aug 2022 04:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B748C433B5;
        Wed,  3 Aug 2022 04:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659500486;
        bh=ZMRRftXBZYRdKNYNL9eP7mpuXRuvArnl5y1ivd03ZP4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Oxabw6WyT61sm81bdLQ8ydlca3GUlJ8s64DChAink44vpQ+FsLWnjUOCx7NCBt53n
         0LDki7bg7SUw+w5tw6wOFyuSYQr5uvgqp0powWaDE9OV9TBIaFyP6Zbm9LAEtaeRpJ
         WkW1yuaH2R1c4jro8BwlbhERuFhZlvr0+SrSAPJLbzONBAjbumilNZlrTUUA9sVAuL
         zJFq1Z19dH1+66+uM4Acf4taM3RQZ2cgZqgGhWe1RIQ6GP9Gj/c8zANRBqNloO/3oW
         z5GFT7C2h4ZwOBnXGKPs+dC7A0fRXXmdcuxjunkl3VEXrbFbcXV0lhVgl3N+qJrFvT
         JbfbMSVewsmTA==
Subject: [PATCH 1/3] xfs/432: fix this test when external devices are in use
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 02 Aug 2022 21:21:26 -0700
Message-ID: <165950048600.198815.10416873619760657341.stgit@magnolia>
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

