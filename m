Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56594 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751609AbdIRJQr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 05:16:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 50/78] iomap: fix integer truncation issues in the zeroing and dirtying helpers
Date: Mon, 18 Sep 2017 11:11:59 +0200
Message-Id: <20170918091133.874153937@linuxfoundation.org>
In-Reply-To: <20170918091126.077483037@linuxfoundation.org>
References: <20170918091126.077483037@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, Paul Menzel <pmenzel@molgen.mpg.de>, Christoph Hellwig <hch@lst.de>

4.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit e28ae8e428fefe2facd72cea9f29906ecb9c861d upstream.

Fix the min_t calls in the zeroing and dirtying helpers to perform the
comparisms on 64-bit types, which prevents them from incorrectly
being truncated, and larger zeroing operations being stuck in a never
ending loop.

Special thanks to Markus Stockhausen for spotting the bug.

Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/iomap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -281,7 +281,7 @@ iomap_dirty_actor(struct inode *inode, l
 		unsigned long bytes;	/* Bytes to write to page */
 
 		offset = (pos & (PAGE_SIZE - 1));
-		bytes = min_t(unsigned long, PAGE_SIZE - offset, length);
+		bytes = min_t(loff_t, PAGE_SIZE - offset, length);
 
 		rpage = __iomap_read_page(inode, pos);
 		if (IS_ERR(rpage))
@@ -376,7 +376,7 @@ iomap_zero_range_actor(struct inode *ino
 		unsigned offset, bytes;
 
 		offset = pos & (PAGE_SIZE - 1); /* Within page */
-		bytes = min_t(unsigned, PAGE_SIZE - offset, count);
+		bytes = min_t(loff_t, PAGE_SIZE - offset, count);
 
 		if (IS_DAX(inode))
 			status = iomap_dax_zero(pos, offset, bytes, iomap);


