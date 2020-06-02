Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B0FCC433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 18:02:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D40602074B
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 18:02:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b2j5RJ57"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbgFBSCO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 14:02:14 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:42514 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726139AbgFBSCO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 14:02:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591120932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bJwytKuYvj+8cF2BtsUHYAkJQET/oai7s+otyiI/Zbg=;
        b=b2j5RJ57pYqE5kEvXMtFUtbmpUu2SaEFPy+nXiCOvv9I8rN2fma0KJi6D0rpleOis76gU0
        9GZj8mYTeWNou5hUNezJ/MA4QvIn9zmUBQpU/ek5pQDZVOLEZ2nLqekIFGbnArQbmkZNDi
        8Rie+32e6ZiS3vJ8LS7ty/m2xDk6e48=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-akc4NCDfMQWMBYghGXQ9Ow-1; Tue, 02 Jun 2020 14:02:08 -0400
X-MC-Unique: akc4NCDfMQWMBYghGXQ9Ow-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7782E809881
        for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2020 18:02:07 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 334A61001901
        for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2020 18:02:07 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: preserve rmapbt swapext block reservation from freed blocks
Date:   Tue,  2 Jun 2020 14:02:06 -0400
Message-Id: <20200602180206.9334-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The rmapbt extent swap algorithm remaps individual extents between
the source inode and the target to trigger reverse mapping metadata
updates. If either inode straddles a format or other bmap allocation
boundary, the individual unmap and map cycles can trigger repeated
bmap block allocations and frees as the extent count bounces back
and forth across the boundary. While net block usage is bound across
the swap operation, this behavior can prematurely exhaust the
transaction block reservation because it continuously drains as the
transaction rolls. Each allocation accounts against the reservation
and each free returns to global free space on transaction roll.

The previous workaround to this problem attempted to detect this
boundary condition and provide surplus block reservation to
acommodate it. This is insufficient because more remaps can occur
than implied by the extent counts; if start offset boundaries are
not aligned between the two inodes, for example.

To address this problem more generically and dynamically, add a
transaction accounting mode that returns freed blocks to the
transaction reservation instead of the superblock counters on
transaction roll and use it when the rmapbt based algorithm is
active. This allows the chain of remap transactions to preserve the
block reservation based own its own frees and prevent premature
exhaustion regardless of the remap pattern. Note that this is only
safe for superblocks with lazy sb accounting, but the latter is
required for v5 supers and the rmap feature depends on v5.

Fixes: b3fed434822d0 ("xfs: account format bouncing into rmapbt swapext tx reservation")
Root-caused-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v1:
- Use a transaction flag to isolate behavior to rmapbt swapext.
rfc: https://lore.kernel.org/linux-xfs/20200522171828.53440-1-bfoster@redhat.com/

 fs/xfs/libxfs/xfs_shared.h |  1 +
 fs/xfs/xfs_bmap_util.c     | 18 +++++++++---------
 fs/xfs/xfs_trans.c         | 13 ++++++++++++-
 3 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index c45acbd3add9..708feb8eac76 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -65,6 +65,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define XFS_TRANS_DQ_DIRTY	0x10	/* at least one dquot in trx dirty */
 #define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
 #define XFS_TRANS_NO_WRITECOUNT 0x40	/* do not elevate SB writecount */
+#define XFS_TRANS_RES_FDBLKS	0x80	/* reserve newly freed blocks */
 /*
  * LOWMODE is used by the allocator to activate the lowspace algorithm - when
  * free space is running low the extent allocator may choose to allocate an
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index f37f5cc4b19f..afdc7f8e0e70 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1567,6 +1567,7 @@ xfs_swap_extents(
 	int			lock_flags;
 	uint64_t		f;
 	int			resblks = 0;
+	unsigned int		flags = 0;
 
 	/*
 	 * Lock the inodes against other IO, page faults and truncate to
@@ -1630,17 +1631,16 @@ xfs_swap_extents(
 		resblks +=  XFS_SWAP_RMAP_SPACE_RES(mp, tipnext, w);
 
 		/*
-		 * Handle the corner case where either inode might straddle the
-		 * btree format boundary. If so, the inode could bounce between
-		 * btree <-> extent format on unmap -> remap cycles, freeing and
-		 * allocating a bmapbt block each time.
+		 * If either inode straddles a bmapbt block allocation boundary,
+		 * the rmapbt algorithm triggers repeated allocs and frees as
+		 * extents are remapped. This can exhaust the block reservation
+		 * prematurely and cause shutdown. Return freed blocks to the
+		 * transaction reservation to counter this behavior.
 		 */
-		if (ipnext == (XFS_IFORK_MAXEXT(ip, w) + 1))
-			resblks += XFS_IFORK_MAXEXT(ip, w);
-		if (tipnext == (XFS_IFORK_MAXEXT(tip, w) + 1))
-			resblks += XFS_IFORK_MAXEXT(tip, w);
+		flags |= XFS_TRANS_RES_FDBLKS;
 	}
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, flags,
+				&tp);
 	if (error)
 		goto out_unlock;
 
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 3c94e5ff4316..2040f2df58b5 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -107,7 +107,8 @@ xfs_trans_dup(
 
 	ntp->t_flags = XFS_TRANS_PERM_LOG_RES |
 		       (tp->t_flags & XFS_TRANS_RESERVE) |
-		       (tp->t_flags & XFS_TRANS_NO_WRITECOUNT);
+		       (tp->t_flags & XFS_TRANS_NO_WRITECOUNT) |
+		       (tp->t_flags & XFS_TRANS_RES_FDBLKS);
 	/* We gave our writer reference to the new transaction */
 	tp->t_flags |= XFS_TRANS_NO_WRITECOUNT;
 	ntp->t_ticket = xfs_log_ticket_get(tp->t_ticket);
@@ -365,6 +366,16 @@ xfs_trans_mod_sb(
 			tp->t_blk_res_used += (uint)-delta;
 			if (tp->t_blk_res_used > tp->t_blk_res)
 				xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		} else if (delta > 0 && (tp->t_flags & XFS_TRANS_RES_FDBLKS)) {
+			/*
+			 * Return freed blocks directly to the reservation
+			 * instead of the global pool. This is used by chains of
+			 * transaction rolls that repeatedly free and allocate
+			 * blocks. Only safe with lazy sb accounting.
+			 */
+			ASSERT(xfs_sb_version_haslazysbcount(&mp->m_sb));
+			tp->t_blk_res += delta;
+			delta = 0;
 		}
 		tp->t_fdblocks_delta += delta;
 		if (xfs_sb_version_haslazysbcount(&mp->m_sb))
-- 
2.21.1

