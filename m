Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:50778 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728846AbeHMQ22 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Aug 2018 12:28:28 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 14D7187A50
        for <linux-xfs@vger.kernel.org>; Mon, 13 Aug 2018 13:46:07 +0000 (UTC)
Received: from odin.usersys.redhat.com (ovpn-204-88.brq.redhat.com [10.40.204.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6DF542026D66
        for <linux-xfs@vger.kernel.org>; Mon, 13 Aug 2018 13:46:06 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] xfs_buf: Remove unneeded variable from xfs_buf_ioapply_map
Date: Mon, 13 Aug 2018 15:46:01 +0200
Message-Id: <20180813134601.29390-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

bio_add_page only returns 0 or the same value passed as length, there is
no need to compare its return value against the passed length.

Just check if the return value is 0 or not.


Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---

P.S. Patch survived xfstests using different block sizes

 fs/xfs/xfs_buf.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index e839907e8492..a353b39b00e2 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1306,14 +1306,14 @@ xfs_buf_ioapply_map(
 	bio_set_op_attrs(bio, op, op_flags);
 
 	for (; size && nr_pages; nr_pages--, page_index++) {
-		int	rbytes, nbytes = PAGE_SIZE - offset;
+		int	nbytes = PAGE_SIZE - offset;
 
 		if (nbytes > size)
 			nbytes = size;
 
-		rbytes = bio_add_page(bio, bp->b_pages[page_index], nbytes,
-				      offset);
-		if (rbytes < nbytes)
+		/* Stop if bio is full */
+		if (!(bio_add_page(bio, bp->b_pages[page_index], nbytes,
+				   offset)))
 			break;
 
 		offset = 0;
-- 
2.14.3
