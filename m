Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Feb 2007 21:41:53 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l125fkqw008631
	for <xfs@oss.sgi.com>; Thu, 1 Feb 2007 21:41:49 -0800
Date: Fri, 2 Feb 2007 16:40:44 +1100
From: David Chinner <dgc@sgi.com>
Subject: Review: Don't use kmap() in xfs_iozero().
Message-ID: <20070202054044.GO33919298@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev@sgi.com
Cc: xfs@oss.sgi.com

kmap is inefficient and does scale well. kmap_atomic() is a better
choice. Use the generic wrapper function instead of open coding the
kmap-memset-dcache flush-kumap stuff.  Suggested by Andrew Morton.

Comments?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/linux-2.6/xfs_lrw.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_lrw.c	2007-01-31 13:56:12.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_lrw.c	2007-01-31 14:19:50.379179841 +1100
@@ -138,7 +138,6 @@ xfs_iozero(
 	unsigned		bytes;
 	struct page		*page;
 	struct address_space	*mapping;
-	char			*kaddr;
 	int			status;
 
 	mapping = ip->i_mapping;
@@ -156,15 +155,13 @@ xfs_iozero(
 		if (!page)
 			break;
 
-		kaddr = kmap(page);
 		status = mapping->a_ops->prepare_write(NULL, page, offset,
 							offset + bytes);
-		if (status) {
+		if (status)
 			goto unlock;
-		}
 
-		memset((void *) (kaddr + offset), 0, bytes);
-		flush_dcache_page(page);
+		memclear_highpage_flush(page, (unsigned int)offset, bytes);
+
 		status = mapping->a_ops->commit_write(NULL, page, offset,
 							offset + bytes);
 		if (!status) {
@@ -175,7 +172,6 @@ xfs_iozero(
 		}
 
 unlock:
-		kunmap(page);
 		unlock_page(page);
 		page_cache_release(page);
 		if (status)
