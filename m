Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:40446 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729403AbfGVJu5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jul 2019 05:50:57 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/12] xfs: set IOMAP_F_NEW more carefully
Date: Mon, 22 Jul 2019 11:50:23 +0200
Message-Id: <20190722095024.19075-12-hch@lst.de>
In-Reply-To: <20190722095024.19075-1-hch@lst.de>
References: <20190722095024.19075-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

Don't set IOMAP_F_NEW if we COW over and existing allocated range, as
these aren't strictly new allocations.  This is required to be able to
use IOMAP_F_NEW to zero newly allocated blocks, which is required for
the iomap code to fully support file systems that don't do delayed
allocations or use unwritten extents.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 951350ec025d..d340db666c06 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -707,9 +707,12 @@ xfs_file_iomap_begin_delay(
 	 * Flag newly allocated delalloc blocks with IOMAP_F_NEW so we punch
 	 * them out if the write happens to fail.
 	 */
-	iomap_flags |= IOMAP_F_NEW;
-	trace_xfs_iomap_alloc(ip, offset, count, whichfork,
-			whichfork == XFS_DATA_FORK ? &imap : &cmap);
+	if (whichfork == XFS_DATA_FORK) {
+		iomap_flags |= IOMAP_F_NEW;
+		trace_xfs_iomap_alloc(ip, offset, count, whichfork, &imap);
+	} else {
+		trace_xfs_iomap_alloc(ip, offset, count, whichfork, &cmap);
+	}
 done:
 	if (whichfork == XFS_COW_FORK) {
 		if (imap.br_startoff > offset_fsb) {
-- 
2.20.1
