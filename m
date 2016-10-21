Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47832 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932739AbcJURWP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 21 Oct 2016 13:22:15 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 593868124B
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2016 17:22:15 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u9LHMFnv020290
        for <linux-xfs@vger.kernel.org>; Fri, 21 Oct 2016 13:22:15 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/3] xfs: clear cowblocks tag when cow fork is emptied
Date: Fri, 21 Oct 2016 13:22:12 -0400
Message-Id: <1477070533-59327-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1477070533-59327-1-git-send-email-bfoster@redhat.com>
References: <1477070533-59327-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The background cowblocks scan job takes care of scanning for inodes with
potentially lingering blocks in the cow fork and clearing them out. If
the background scanner reclaims the cow fork blocks, however, it doesn't
immediately clear the cowblocks tag from the inode. Instead, the inode
remains tagged until the background scanner comes around again,
discovers the inode cow fork has no blocks, clears the tag and fires the
trace_xfs_inode_free_cowblocks_invalid() tracepoint to indicate that the
inode may have been incorrectly tagged.

This is not a major functional problem as the tag is ultimately cleared.
Nonetheless, clear the tag when an inode cow fork is explicitly emptied
to avoid the extra round trip through the background scanner and
spurious "invalid" tracepoint.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_reflink.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index cd308f1..a279b4e 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -567,10 +567,14 @@ xfs_reflink_cancel_cow_blocks(
 		}
 
 		if (++idx >= ifp->if_bytes / sizeof(struct xfs_bmbt_rec))
-			return 0;
+			break;
 		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, idx), &got);
 	}
 
+	/* clear tag if cow fork is emptied */
+	if (!ifp->if_bytes)
+		xfs_inode_clear_cowblocks_tag(ip);
+
 	return error;
 }
 
-- 
2.7.4

