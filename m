Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:35773 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751018AbdBBH5U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Feb 2017 02:57:20 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 17/19] xfs: extsize hints are not unlikely in xfs_bmap_btalloc
Date: Thu,  2 Feb 2017 08:56:09 +0100
Message-Id: <1486022171-8076-18-git-send-email-hch@lst.de>
In-Reply-To: <1486022171-8076-1-git-send-email-hch@lst.de>
References: <1486022171-8076-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

commit 493611ebd62673f39e2f52c2561182c558a21cb6 upstream.

With COW files they are the hotpath, just like for files with the
extent size hint attribute.  We really shouldn't micro-manage anything
but failure cases with unlikely.

Additionally Arnd Bergmann recently reported that one of these two
unlikely annotations causes link failures together with an upcoming
kernel instrumentation patch, so let's get rid of it ASAP.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index fbb60d3..f52fd63 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3720,7 +3720,7 @@ xfs_bmap_btalloc(
 		align = xfs_get_cowextsz_hint(ap->ip);
 	else if (xfs_alloc_is_userdata(ap->datatype))
 		align = xfs_get_extsz_hint(ap->ip);
-	if (unlikely(align)) {
+	if (align) {
 		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
 						align, 0, ap->eof, 0, ap->conv,
 						&ap->offset, &ap->length);
@@ -3792,7 +3792,7 @@ xfs_bmap_btalloc(
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

