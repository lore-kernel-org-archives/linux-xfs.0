Return-Path: <SRS0=SLm5=XN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 778C3C4CEC9
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 14:55:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5547F21920
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Sep 2019 14:55:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731255AbfIROzj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Sep 2019 10:55:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41476 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731139AbfIROzj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Sep 2019 10:55:39 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5D66B91767
        for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2019 14:55:39 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1BBAF60619
        for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2019 14:55:39 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: convert inode to extent format after extent merge due to shift
Date:   Wed, 18 Sep 2019 10:55:38 -0400
Message-Id: <20190918145538.30376-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Wed, 18 Sep 2019 14:55:39 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The collapse range operation can merge extents if two newly adjacent
extents are physically contiguous. If the extent count is reduced on
a btree format inode, a change to extent format might be necessary.
This format change currently occurs as a side effect of the file
size update after extents have been shifted for the collapse. This
codepath ultimately calls xfs_bunmapi(), which happens to check for
and execute the format conversion even if there were no blocks
removed from the mapping.

While this ultimately puts the inode into the correct state, the
fact the format conversion occurs in a separate transaction from the
change that called for it is a problem. If an extent shift
transaction commits and the filesystem happens to crash before the
format conversion, the inode fork is left in a corrupted state after
log recovery. The inode fork verifier fails and xfs_repair
ultimately nukes the inode. This problem was originally reproduced
by generic/388.

Similar to how the insert range extent split code handles extent to
btree conversion, update the collapse range extent merge code to
handle btree to extent format conversion in the same transaction
that merges the extents. This ensures that the inode fork format
remains consistent if the filesystem happens to crash in the middle
of a collapse range operation that changes the inode fork format.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 054b4ce30033..eaf2d4250a26 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5621,6 +5621,11 @@ xfs_bmse_merge(
 	if (error)
 		return error;
 
+	/* change to extent format if required after extent removal */
+	error = xfs_bmap_btree_to_extents(tp, ip, cur, logflags, whichfork);
+	if (error)
+		return error;
+
 done:
 	xfs_iext_remove(ip, icur, 0);
 	xfs_iext_prev(XFS_IFORK_PTR(ip, whichfork), icur);
-- 
2.20.1

