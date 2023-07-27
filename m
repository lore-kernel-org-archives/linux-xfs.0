Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99C6BEB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjG0WaY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbjG0WaY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:30:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BEA30CA
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC28A61F50
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 543DEC433C7;
        Thu, 27 Jul 2023 22:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690497017;
        bh=lmgc5ffQamk5ZUXsxjvWEfnXGBKSpPA57MtYuDwQDUE=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=gwyLUeF+vriWuUdyzb0JfcXHt4syOQJKvOgNzuWaA5TwBoEmjFoUyc1Ymbh9yqr+s
         f4g26j//Ib4xlAvDNiRtWX+Qmi6oJ3IRcp70jkbenNX7sHTc0LHMBUZw2wOD4X3dPR
         Qhn8NA7hvtGqzzWLH3k+5Fdda6KeZszSOUY3NHDgNKal7g+CVBlbavmF8YvG9j9bWj
         CfEpIiQGSS4ijZhSqLJ6JJbUvDetBOC8JAtDYRqwr7CrDlvwbZHGbBpMC5dhkexp3O
         UdsMLfkLHvF/Om2o9T8fwcfVeMeE6LIt1E1ZiT6+2wNJ60Mc2W1+IPAlj4lo0hkE2D
         uv6C0c2ROigng==
Date:   Thu, 27 Jul 2023 15:30:16 -0700
Subject: [PATCH 2/2] xfs: fix agf_fllast when repairing an empty AGFL
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169049625382.922161.17865609533771232818.stgit@frogsfrogsfrogs>
In-Reply-To: <169049625352.922161.1455328433828521501.stgit@frogsfrogsfrogs>
References: <169049625352.922161.1455328433828521501.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

xfs/139 with parent pointers enabled occasionally pops up a corruption
message when online fsck force-rebuild repairs an AGFL:

 XFS (sde): Metadata corruption detected at xfs_agf_verify+0x11e/0x220 [xfs], xfs_agf block 0x9e0001
 XFS (sde): Unmount and run xfs_repair
 XFS (sde): First 128 bytes of corrupted metadata buffer:
 00000000: 58 41 47 46 00 00 00 01 00 00 00 4f 00 00 40 00  XAGF.......O..@.
 00000010: 00 00 00 01 00 00 00 02 00 00 00 05 00 00 00 01  ................
 00000020: 00 00 00 01 00 00 00 01 00 00 00 00 ff ff ff ff  ................
 00000030: 00 00 00 00 00 00 00 05 00 00 00 05 00 00 00 00  ................
 00000040: 91 2e 6f b1 ed 61 4b 4d 8c 9b 6e 87 08 bb f6 36  ..o..aKM..n....6
 00000050: 00 00 00 01 00 00 00 01 00 00 00 06 00 00 00 01  ................
 00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

The root cause of this failure is that prior to the repair, there were
zero blocks in the AGFL.  This scenario is set up by the test case, since
it formats with 64MB AGs and tries to ENOSPC the whole filesystem.  In
this case of flcount==0, we reset fllast to -1U, which then trips the
write verifier's check that fllast is less than xfs_agfl_size().

Correct this code to set fllast to the last possible slot in the AGFL
when flcount is zero, which mirrors the behavior of xfs_repair phase5
when it has to create a totally empty AGFL.

Fixes: 0e93d3f43ec7 ("xfs: repair the AGFL")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/agheader_repair.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 4e99e19b2490d..36c511f96b004 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -628,7 +628,10 @@ xrep_agfl_update_agf(
 	}
 	agf->agf_flfirst = cpu_to_be32(0);
 	agf->agf_flcount = cpu_to_be32(flcount);
-	agf->agf_fllast = cpu_to_be32(flcount - 1);
+	if (flcount)
+		agf->agf_fllast = cpu_to_be32(flcount - 1);
+	else
+		agf->agf_fllast = cpu_to_be32(xfs_agfl_size(sc->mp) - 1);
 
 	xfs_alloc_log_agf(sc->tp, agf_bp,
 			XFS_AGF_FLFIRST | XFS_AGF_FLLAST | XFS_AGF_FLCOUNT);

