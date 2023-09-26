Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB7F3E7F14C
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Sep 2023 00:17:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbjI0ARD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 20:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231985AbjI0APC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 20:15:02 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E7B449A
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 16:34:16 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2D4C433C9;
        Tue, 26 Sep 2023 23:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695771255;
        bh=Dtk2ftJddGi3rTQIh77UOFY0KgCBtmzLdzSB9DxZ8cY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=qTZvuKLZSmmtI7lShhA8NDtV+y30giI5pYl39L1vSEHhOdn3zf5yMCz1ZQR9Y1Auz
         9jEptylrf5BDYncKZTHLbMRD2bRNeN9A2R4b0oMKedM8hvSXNvhN1x7AgxUXfsp/5Z
         YEWS9WAXzyIw+QChRPPhuzg5NvasKcHes+wZ+nxaqOExYOO6lYxvS6qxbK3gorOT6F
         FXwOIIoZFERMYz2JI9S/QyqRJAjEUhcY7AgQFQsUOcFRcnZ6d/8bGvgFkwAN4jpEDO
         ejdwn0sB6MIQZ927XpYU+hTZJRE1gqGHa78OBEq2SwSpUsZSCjqvZU0VpFZaqzHooO
         6vbULICuz7XCw==
Date:   Tue, 26 Sep 2023 16:34:15 -0700
Subject: [PATCH 1/4] xfs: roll the scrub transaction after completing a repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169577059984.3313285.18244425439253732044.stgit@frogsfrogsfrogs>
In-Reply-To: <169577059962.3313285.5801727504839472715.stgit@frogsfrogsfrogs>
References: <169577059962.3313285.5801727504839472715.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When we've finished repairing an AG header, roll the scrub transaction.
This ensure that any failures caused by defer ops failing are captured
by the xrep_done tracepoint and that any stacktraces that occur will
point to the repair code that caused it, instead of xchk_teardown.

Going forward, repair functions should commit the transaction if they're
going to return success.  Usually the space reaping functions that run
after a successful atomic commit of the new metadata will take care of
that for us.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/agheader_repair.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 36c511f96b004..156d548e64830 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -73,7 +73,7 @@ xrep_superblock(
 	/* Write this to disk. */
 	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_SB_BUF);
 	xfs_trans_log_buf(sc->tp, bp, 0, BBTOB(bp->b_length) - 1);
-	return error;
+	return 0;
 }
 
 /* AGF */
@@ -342,7 +342,7 @@ xrep_agf_commit_new(
 	pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
 	set_bit(XFS_AGSTATE_AGF_INIT, &pag->pag_opstate);
 
-	return 0;
+	return xrep_roll_ag_trans(sc);
 }
 
 /* Repair the AGF. v5 filesystems only. */
@@ -790,6 +790,9 @@ xrep_agfl(
 	/* Dump any AGFL overflow. */
 	error = xrep_reap_agblocks(sc, &agfl_extents, &XFS_RMAP_OINFO_AG,
 			XFS_AG_RESV_AGFL);
+	if (error)
+		goto err;
+
 err:
 	xagb_bitmap_destroy(&agfl_extents);
 	return error;
@@ -963,7 +966,7 @@ xrep_agi_commit_new(
 	pag->pagi_freecount = be32_to_cpu(agi->agi_freecount);
 	set_bit(XFS_AGSTATE_AGI_INIT, &pag->pag_opstate);
 
-	return 0;
+	return xrep_roll_ag_trans(sc);
 }
 
 /* Repair the AGI. */

