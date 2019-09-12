Return-Path: <SRS0=88Vy=XH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05089C4CEC7
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Sep 2019 14:32:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA7122081B
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Sep 2019 14:32:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732444AbfILOc2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Sep 2019 10:32:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34592 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732651AbfILOc2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Sep 2019 10:32:28 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E0B132A09CB
        for <linux-xfs@vger.kernel.org>; Thu, 12 Sep 2019 14:32:27 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 88B9C5D712;
        Thu, 12 Sep 2019 14:32:27 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH REPOST 2/2] xfs: don't set bmapi total block req where minleft is sufficient
Date:   Thu, 12 Sep 2019 10:32:23 -0400
Message-Id: <20190912143223.24194-3-bfoster@redhat.com>
In-Reply-To: <20190912143223.24194-1-bfoster@redhat.com>
References: <20190912143223.24194-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 12 Sep 2019 14:32:27 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_bmapi_write() takes a total block requirement parameter that is
passed down to the block allocation code and is used to specify the
total block requirement of the associated transaction. This is used
to try and select an AG that can not only satisfy the requested
extent allocation, but can also accommodate subsequent allocations
that might be required to complete the transaction. For example,
additional bmbt block allocations may be required on insertion of
the resulting extent to an inode data fork.

While it's important for callers to calculate and reserve such extra
blocks in the transaction, it is not necessary to pass the total
value to xfs_bmapi_write() in all cases. The latter automatically
sets minleft to ensure that sufficient free blocks remain after the
allocation attempt to expand the format of the associated inode
(i.e., such as extent to btree conversion, btree splits, etc).
Therefore, any callers that pass a total block requirement of the
bmap mapping length plus worst case bmbt expansion essentially
specify the additional reservation requirement twice. These callers
can pass a total of zero to rely on the bmapi minleft policy.

Beyond being superfluous, the primary motivation for this change is
that the total reservation logic in the bmbt code is dubious in
scenarios where minlen < maxlen and a maxlen extent cannot be
allocated (which is more common for data extent allocations where
contiguity is not required). The total value is based on maxlen in
the xfs_bmapi_write() caller. If the bmbt code falls back to an
allocation between minlen and maxlen, that allocation will not
succeed until total is reset to minlen, which essentially throws
away any additional reservation included in total by the caller. In
addition, the total value is not reset until after alignment is
dropped, which means that such callers drop alignment far too
aggressively than necessary.

Update all callers of xfs_bmapi_write() that pass a total block
value of the mapping length plus bmbt reservation to instead pass
zero and rely on xfs_bmapi_minleft() to enforce the bmbt reservation
requirement. This trades off slightly less conservative AG selection
for the ability to preserve alignment in more scenarios.
xfs_bmapi_write() callers that incorporate unrelated or additional
reservations in total beyond what is already included in minleft
must continue to use the former.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 1 -
 fs/xfs/xfs_bmap_util.c   | 4 ++--
 fs/xfs/xfs_dquot.c       | 4 ++--
 fs/xfs/xfs_iomap.c       | 4 ++--
 fs/xfs/xfs_reflink.c     | 4 ++--
 fs/xfs/xfs_rtalloc.c     | 3 +--
 6 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index eaa965920a03..c2f0afdf2f65 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4505,7 +4505,6 @@ xfs_bmapi_convert_delalloc(
 	bma.wasdel = true;
 	bma.offset = bma.got.br_startoff;
 	bma.length = max_t(xfs_filblks_t, bma.got.br_blockcount, MAXEXTLEN);
-	bma.total = XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK);
 	bma.minleft = xfs_bmapi_minleft(tp, ip, whichfork);
 	if (whichfork == XFS_COW_FORK)
 		bma.flags = XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC;
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 0910cb75b65d..079aedade656 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -962,8 +962,8 @@ xfs_alloc_file_space(
 		xfs_trans_ijoin(tp, ip, 0);
 
 		error = xfs_bmapi_write(tp, ip, startoffset_fsb,
-					allocatesize_fsb, alloc_type, resblks,
-					imapp, &nimaps);
+					allocatesize_fsb, alloc_type, 0, imapp,
+					&nimaps);
 		if (error)
 			goto error0;
 
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index aeb95e7391c1..b924dbd63a7d 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -305,8 +305,8 @@ xfs_dquot_disk_alloc(
 	/* Create the block mapping. */
 	xfs_trans_ijoin(tp, quotip, XFS_ILOCK_EXCL);
 	error = xfs_bmapi_write(tp, quotip, dqp->q_fileoffset,
-			XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA,
-			XFS_QM_DQALLOC_SPACE_RES(mp), &map, &nmaps);
+			XFS_DQUOT_CLUSTER_SIZE_FSB, XFS_BMAPI_METADATA, 0, &map,
+			&nmaps);
 	if (error)
 		return error;
 	ASSERT(map.br_blockcount == XFS_DQUOT_CLUSTER_SIZE_FSB);
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index f780e223b118..27f2030690e2 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -277,8 +277,8 @@ xfs_iomap_write_direct(
 	 * caller gave to us.
 	 */
 	nimaps = 1;
-	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb,
-				bmapi_flags, resblks, imap, &nimaps);
+	error = xfs_bmapi_write(tp, ip, offset_fsb, count_fsb, bmapi_flags, 0,
+				imap, &nimaps);
 	if (error)
 		goto out_res_cancel;
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 0f08153b4994..3aa56cac1a47 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -410,8 +410,8 @@ xfs_reflink_allocate_cow(
 	/* Allocate the entire reservation as unwritten blocks. */
 	nimaps = 1;
 	error = xfs_bmapi_write(tp, ip, imap->br_startoff, imap->br_blockcount,
-			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC,
-			resblks, imap, &nimaps);
+			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC, 0, imap,
+			&nimaps);
 	if (error)
 		goto out_unreserve;
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 4a48a8c75b4f..d42b5a2047e0 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -792,8 +792,7 @@ xfs_growfs_rt_alloc(
 		 */
 		nmap = 1;
 		error = xfs_bmapi_write(tp, ip, oblocks, nblocks - oblocks,
-					XFS_BMAPI_METADATA, resblks, &map,
-					&nmap);
+					XFS_BMAPI_METADATA, 0, &map, &nmap);
 		if (!error && nmap < 1)
 			error = -ENOSPC;
 		if (error)
-- 
2.20.1

