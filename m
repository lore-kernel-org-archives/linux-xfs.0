Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56658 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932463AbdIRJRA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 05:17:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 45/78] xfs: fix multi-AG deadlock in xfs_bunmapi
Date: Mon, 18 Sep 2017 11:11:54 +0200
Message-Id: <20170918091133.088816511@linuxfoundation.org>
In-Reply-To: <20170918091126.077483037@linuxfoundation.org>
References: <20170918091126.077483037@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Nikolay Borisov <n.borisov.lkml@gmail.com>

4.9-stable review patch.  If anyone has any objections, please let me know.

------------------


commit 5b094d6dac0451ad89b1dc088395c7b399b7e9e8 upstream.

Just like in the allocator we must avoid touching multiple AGs out of
order when freeing blocks, as freeing still locks the AGF and can cause
the same AB-BA deadlocks as in the allocation path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Nikolay Borisov <n.borisov.lkml@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_bmap.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5556,6 +5556,7 @@ __xfs_bunmapi(
 	xfs_fsblock_t		sum;
 	xfs_filblks_t		len = *rlen;	/* length to unmap in file */
 	xfs_fileoff_t		max_len;
+	xfs_agnumber_t		prev_agno = NULLAGNUMBER, agno;
 
 	trace_xfs_bunmap(ip, bno, len, flags, _RET_IP_);
 
@@ -5658,6 +5659,17 @@ __xfs_bunmapi(
 		ASSERT(ep != NULL);
 		del = got;
 		wasdel = isnullstartblock(del.br_startblock);
+
+		/*
+		 * Make sure we don't touch multiple AGF headers out of order
+		 * in a single transaction, as that could cause AB-BA deadlocks.
+		 */
+		if (!wasdel) {
+			agno = XFS_FSB_TO_AGNO(mp, del.br_startblock);
+			if (prev_agno != NULLAGNUMBER && prev_agno > agno)
+				break;
+			prev_agno = agno;
+		}
 		if (got.br_startoff < start) {
 			del.br_startoff = start;
 			del.br_blockcount -= start - got.br_startoff;


