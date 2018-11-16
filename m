Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49414 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728175AbeKQCpS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Nov 2018 21:45:18 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2A2ED30013B5
        for <linux-xfs@vger.kernel.org>; Fri, 16 Nov 2018 16:32:15 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D576A19C7B
        for <linux-xfs@vger.kernel.org>; Fri, 16 Nov 2018 16:32:14 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC] xfs: check shared extent state on writeback in debug mode
Date: Fri, 16 Nov 2018 11:32:14 -0500
Message-Id: <20181116163214.33267-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Here's a quick patch to try and do some explicit shared extent writeback
checking. What's interesting so far is that this seems to allow
reproducing the original shared/010 problem reliably with generic/127.
That goes away with the previously posted patch to call
xfs_trim_extent(), but if I reset my hardcoded shared/010 seed and start
running that test in a loop I can eventually reproduce another instance
of this assert failure that isn't detected by the checksum checks (i.e.,
shared/010 would pass if not for this particular assert firing).

It's not immediately clear to me if this is another problem or a flaw in
this patch. I'll have to dig into it further, so I'm just throwing this
over the wall for the time being in case anybody has thoughts or finds
it useful..

Brian

 fs/xfs/xfs_aops.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 338b9d9984e0..7a0a467fddb5 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -6,6 +6,7 @@
  */
 #include "xfs.h"
 #include "xfs_shared.h"
+#include "xfs_bit.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
@@ -301,6 +302,46 @@ xfs_end_bio(
 		xfs_destroy_ioend(ioend, blk_status_to_errno(bio->bi_status));
 }
 
+#if defined(DEBUG) || defined(XFS_WARN)
+/*
+ * DEBUG mode checks to ensure we never perform writeback to shared blocks. This
+ * is useful because writeback uses the presence of blocks in the COW fork to
+ * determine when COW is necessary. We always expect to have COW blocks covering
+ * shared blocks at writeback time, but if we ever get this wrong we're left
+ * with data corruptions that are difficult to detect. Check the extent state
+ * explicitly in DEBUG mode.
+ */
+static int
+xfs_assert_nonshared(
+	struct xfs_inode	*ip,
+	uint64_t		offset,
+	struct xfs_bmbt_irec	*imap)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_bmbt_irec	tmap;
+	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
+	xfs_agblock_t		fbno;
+	xfs_extlen_t		flen;
+	int			error;
+
+	if (!xfs_is_reflink_inode(ip))
+		return 0;
+
+	tmap = *imap;	/* struct copy */
+	xfs_trim_extent(&tmap, offset_fsb, 1);
+	error = xfs_reflink_find_shared(mp, NULL,
+			XFS_FSB_TO_AGNO(mp, tmap.br_startblock),
+			XFS_FSB_TO_AGBNO(mp, tmap.br_startblock),
+			1, &fbno, &flen, false);
+	if (error)
+		return error;
+	ASSERT(fbno == NULLAGBLOCK && flen == 0);
+	return 0;
+}
+#else
+#define xfs_assert_nonshared(ip, offset, imap) do { } while (0);
+#endif
+
 STATIC int
 xfs_map_blocks(
 	struct xfs_writepage_ctx *wpc,
@@ -723,6 +764,7 @@ xfs_writepage_map(
 			break;
 		if (wpc->io_type == XFS_IO_HOLE)
 			continue;
+		xfs_assert_nonshared(XFS_I(inode), file_offset, &wpc->imap);
 		xfs_add_to_ioend(inode, file_offset, page, iop, wpc, wbc,
 				 &submit_list);
 		count++;
-- 
2.17.2
