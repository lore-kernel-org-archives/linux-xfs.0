Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC09EC77B73
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Apr 2023 22:49:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjD0WtJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 18:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344332AbjD0WtI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2023 18:49:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1141A2129
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 15:49:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A141D6403A
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 22:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0904FC433D2;
        Thu, 27 Apr 2023 22:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682635746;
        bh=bE1NJGf1f2PqmJG76T4fKD7T6rspJe728NI/h8hT4Rw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GjLR49eEGzazt3BtHeBzU4p4TQg1WWXUigUj3QL4hq0ipmZbyOK03Y7+FQpMPb0za
         fyDiAXSU3vQ02SItOK0lPWq9FP+ExpUJl7+79jIaRgLci2nJSMKJMuK2XSNskVB8UW
         92fpxPJ2yGmDGwBDci3J8AMFF3NshN1k6iO+HYu79tULbP9Oai3P0cBFzR0hyZI/RG
         gJPJ+LSQIQ1lytMT0yfLopFbDMRQ6Q+2xHudpmPWTqjmh0QZYLxQMeHcZ1E3NmMn48
         I5Zr0IkVQt0wuzQo5pAK/Pqp0vTux/9IOsIY9YYKUiAiaVGjCnu+6EcnLX11lHbD5i
         XK/LRSZGm5fVA==
Subject: [PATCH 2/4] xfs: set bnobt/cntbt numrecs correctly when formatting
 new AGs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 27 Apr 2023 15:49:05 -0700
Message-ID: <168263574554.1717721.6730628291355995988.stgit@frogsfrogsfrogs>
In-Reply-To: <168263573426.1717721.15565213947185049577.stgit@frogsfrogsfrogs>
References: <168263573426.1717721.15565213947185049577.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Through generic/300, I discovered that mkfs.xfs creates corrupt
filesystems when given these parameters:

# mkfs.xfs -d size=512M /dev/sda -f -d su=128k,sw=4 --unsupported
Filesystems formatted with --unsupported are not supported!!
meta-data=/dev/sda               isize=512    agcount=8, agsize=16352 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
data     =                       bsize=4096   blocks=130816, imaxpct=25
         =                       sunit=32     swidth=128 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=8192, version=2
         =                       sectsz=512   sunit=32 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
         =                       rgcount=0    rgsize=0 blks
Discarding blocks...Done.
# xfs_repair -n /dev/sda
Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
Phase 2 - using internal log
        - zero log...
        - 16:30:50: zeroing log - 16320 of 16320 blocks done
        - scan filesystem freespace and inode maps...
agf_freeblks 25, counted 0 in ag 4
sb_fdblocks 8823, counted 8798

The root cause of this problem is the numrecs handling in
xfs_freesp_init_recs, which is used to initialize a new AG.  Prior to
calling the function, we set up the new bnobt block with numrecs == 1
and rely on _freesp_init_recs to format that new record.  If the last
record created has a blockcount of zero, then it sets numrecs = 0.

That last bit isn't correct if the AG contains the log, the start of the
log is not immediately after the initial blocks due to stripe alignment,
and the end of the log is perfectly aligned with the end of the AG.  For
this case, we actually formatted a single bnobt record to handle the
free space before the start of the (stripe aligned) log, and incremented
arec to try to format a second record.  That second record turned out to
be unnecessary, so what we really want is to leave numrecs at 1.

The numrecs handling itself is overly complicated because a different
function sets numrecs == 1.  Change the bnobt creation code to start
with numrecs set to zero and only increment it after successfully
formatting a free space extent into the btree block.

Fixes: f327a00745ff ("xfs: account for log space when formatting new AGs")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 1b078bbbf225..4481ce8ead9d 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -499,6 +499,7 @@ xfs_freesp_init_recs(
 			 */
 			arec->ar_blockcount = cpu_to_be32(start -
 						mp->m_ag_prealloc_blocks);
+			be16_add_cpu(&block->bb_numrecs, 1);
 			nrec = arec + 1;
 
 			/*
@@ -509,7 +510,6 @@ xfs_freesp_init_recs(
 					be32_to_cpu(arec->ar_startblock) +
 					be32_to_cpu(arec->ar_blockcount));
 			arec = nrec;
-			be16_add_cpu(&block->bb_numrecs, 1);
 		}
 		/*
 		 * Change record start to after the internal log
@@ -525,8 +525,8 @@ xfs_freesp_init_recs(
 	 */
 	arec->ar_blockcount = cpu_to_be32(id->agsize -
 					  be32_to_cpu(arec->ar_startblock));
-	if (!arec->ar_blockcount)
-		block->bb_numrecs = 0;
+	if (arec->ar_blockcount)
+		be16_add_cpu(&block->bb_numrecs, 1);
 }
 
 /*
@@ -538,7 +538,7 @@ xfs_bnoroot_init(
 	struct xfs_buf		*bp,
 	struct aghdr_init_data	*id)
 {
-	xfs_btree_init_block(mp, bp, XFS_BTNUM_BNO, 0, 1, id->agno);
+	xfs_btree_init_block(mp, bp, XFS_BTNUM_BNO, 0, 0, id->agno);
 	xfs_freesp_init_recs(mp, bp, id);
 }
 
@@ -548,7 +548,7 @@ xfs_cntroot_init(
 	struct xfs_buf		*bp,
 	struct aghdr_init_data	*id)
 {
-	xfs_btree_init_block(mp, bp, XFS_BTNUM_CNT, 0, 1, id->agno);
+	xfs_btree_init_block(mp, bp, XFS_BTNUM_CNT, 0, 0, id->agno);
 	xfs_freesp_init_recs(mp, bp, id);
 }
 

