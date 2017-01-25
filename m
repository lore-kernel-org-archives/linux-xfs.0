Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:59392 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751696AbdAYQ4q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jan 2017 11:56:46 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: extsize hints are not unlikely in xfs_bmap_btalloc
Date: Wed, 25 Jan 2017 17:56:41 +0100
Message-Id: <1485363401-21560-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: arnd@arndb.de, linux-xfs@vger.kernel.org

With COW files they are the hotpath, just like for files with the
extent size hint attribute.  We really shouldn't micro-manage anything
but failure cases with unlikely.

Additionally Arnd Bergmann recently reported that one of these two
unlikely annotations causes link failures together with an upcoming
kernel instrumentation patch, so let's get rid of it ASAP.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index ab82dd4..bfc00de 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3629,7 +3629,7 @@ xfs_bmap_btalloc(
 		align = xfs_get_cowextsz_hint(ap->ip);
 	else if (xfs_alloc_is_userdata(ap->datatype))
 		align = xfs_get_extsz_hint(ap->ip);
-	if (unlikely(align)) {
+	if (align) {
 		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
 						align, 0, ap->eof, 0, ap->conv,
 						&ap->offset, &ap->length);
@@ -3701,7 +3701,7 @@ xfs_bmap_btalloc(
 		args.minlen = ap->minlen;
 	}
 	/* apply extent size hints if obtained earlier */
-	if (unlikely(align)) {
+	if (align) {
 		args.prod = align;
 		if ((args.mod = (xfs_extlen_t)do_mod(ap->offset, args.prod)))
 			args.mod = (xfs_extlen_t)(args.prod - args.mod);
-- 
2.1.4

