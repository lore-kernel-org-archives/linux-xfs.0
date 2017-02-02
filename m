Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49472 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752367AbdBBSkZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Feb 2017 13:40:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 49/51] xfs: extsize hints are not unlikely in xfs_bmap_btalloc
Date: Thu,  2 Feb 2017 19:38:08 +0100
Message-Id: <20170202183347.736858223@linuxfoundation.org>
In-Reply-To: <20170202183345.067336143@linuxfoundation.org>
References: <20170202183345.067336143@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>

4.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_bmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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


