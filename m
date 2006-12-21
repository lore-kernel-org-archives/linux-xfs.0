Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Dec 2006 15:52:50 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBLNqgqw028887
	for <xfs@oss.sgi.com>; Thu, 21 Dec 2006 15:52:45 -0800
Date: Fri, 22 Dec 2006 10:51:46 +1100
From: David Chinner <dgc@sgi.com>
Subject: Review: xfs_start_page_writeback should use clear_page_dirty_for_io
Message-ID: <20061221235146.GM33919298@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev@sgi.com
Cc: xfs@oss.sgi.com

As has been discuss on LKML w.r.t to an ext3 corruption bug
(http://lkml.org/lkml/2006/12/16/164), we should not use clear_page_dirty()
as it can result in inconsistent state within the VM and is likely
to go away very soon. Instead, we should be using clear_page_dirty_for_io()
which does the right thing. Some references:

http://lkml.org/lkml/2006/12/20/204
http://lkml.org/lkml/2006/12/20/295
http://lkml.org/lkml/2006/12/20/310
http://lkml.org/lkml/2006/12/20/362

Linus's patch fixes the corruption seen on ARM, so is likely to be merged
(potentially as a stable 2.6.19.x fix).

That means we rely on set_page_writeback() to set the tag bits in the mapping
tree based on whether the page is dirty or not, so we have to call that
_after_ we call clear_page_dirty_for_io() instead of before.

Comments?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/linux-2.6/xfs_aops.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_aops.c	2006-12-19 12:22:47.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_aops.c	2006-12-21 10:15:04.545375877 +1100
@@ -340,9 +340,9 @@ xfs_start_page_writeback(
 {
 	ASSERT(PageLocked(page));
 	ASSERT(!PageWriteback(page));
-	set_page_writeback(page);
 	if (clear_dirty)
-		clear_page_dirty(page);
+		clear_page_dirty_for_io(page);
+	set_page_writeback(page);
 	unlock_page(page);
 	if (!buffers) {
 		end_page_writeback(page);
