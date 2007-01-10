Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 09 Jan 2007 16:39:24 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0A0dGqw016419
	for <xfs@oss.sgi.com>; Tue, 9 Jan 2007 16:39:18 -0800
Date: Wed, 10 Jan 2007 11:38:19 +1100
From: David Chinner <dgc@sgi.com>
Subject: [PATCH 2 of 2]: Make XFS use BH_Unwritten and BH_Delay correctly
Message-ID: <20070110003819.GO44411608@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com


Don't hide buffer_unwritten behind buffer_delay() and
remove the hack that clears unexpected buffer_unwritten()
states now that it can't happen.

Signed-Off-By: Dave Chinner <dgc@sgi.com>

---
 fs/xfs/linux-2.6/xfs_aops.c |   3 ---
 1 file changed, 29 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_aops.c	2007-01-08 12:21:40.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_aops.c	2007-01-09 11:05:09.763127643 +1100
@@ -58,8 +58,6 @@ xfs_count_page_state(
 	do {
 		if (buffer_uptodate(bh) && !buffer_mapped(bh))
 			(*unmapped) = 1;
-		else if (buffer_unwritten(bh) && !buffer_delay(bh))
-			clear_buffer_unwritten(bh);
 		else if (buffer_unwritten(bh))
 			(*unwritten) = 1;
 		else if (buffer_delay(bh))
@@ -1271,7 +1269,6 @@ __xfs_get_blocks(
 			if (direct)
 				bh_result->b_private = inode;
 			set_buffer_unwritten(bh_result);
-			set_buffer_delay(bh_result);
 		}
 	}
 
