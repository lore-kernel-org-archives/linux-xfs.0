Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 14 Jul 2007 09:08:29 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6EG8Pbm017065
	for <xfs@oss.sgi.com>; Sat, 14 Jul 2007 09:08:27 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l6EG8RNK008567
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 14 Jul 2007 18:08:27 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l6EG8QVd008562
	for xfs@oss.sgi.com; Sat, 14 Jul 2007 18:08:26 +0200
Date: Sat, 14 Jul 2007 18:08:26 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix sparse shadowed variable warnings
Message-ID: <20070714160825.GD7768@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

 - in xfs_probe_cluster rename the inner len to pg_len.  There's no harm
   here because the utter len isn't used after the inner len comes into
   existance but it keeps the code clean.
 - in xfs_da_do_buf remove the inner i because both useage don't overlap
   and they are the same type.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2007-07-14 16:02:19.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c	2007-07-14 16:03:09.000000000 +0200
@@ -652,7 +652,7 @@ xfs_probe_cluster(
 
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
-			size_t pg_offset, len = 0;
+			size_t pg_offset, pg_len = 0;
 
 			if (tindex == tlast) {
 				pg_offset =
@@ -665,16 +665,16 @@ xfs_probe_cluster(
 				pg_offset = PAGE_CACHE_SIZE;
 
 			if (page->index == tindex && !TestSetPageLocked(page)) {
-				len = xfs_probe_page(page, pg_offset, mapped);
+				pg_len = xfs_probe_page(page, pg_offset, mapped);
 				unlock_page(page);
 			}
 
-			if (!len) {
+			if (!pg_len) {
 				done = 1;
 				break;
 			}
 
-			total += len;
+			total += pg_len;
 			tindex++;
 		}
 
Index: linux-2.6-xfs/fs/xfs/xfs_da_btree.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_da_btree.c	2007-07-14 16:01:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_da_btree.c	2007-07-14 16:02:01.000000000 +0200
@@ -1975,7 +1975,6 @@ xfs_da_do_buf(
 		error = mappedbno == -2 ? 0 : XFS_ERROR(EFSCORRUPTED);
 		if (unlikely(error == EFSCORRUPTED)) {
 			if (xfs_error_level >= XFS_ERRLEVEL_LOW) {
-				int	i;
 				cmn_err(CE_ALERT, "xfs_da_do_buf: bno %lld\n",
 					(long long)bno);
 				cmn_err(CE_ALERT, "dir: inode %lld\n",
