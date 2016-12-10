Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mailrelay119.isp.belgacom.be ([195.238.20.146]:9704 "EHLO
        mailrelay119.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751359AbcLJGwO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Dec 2016 01:52:14 -0500
From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1 linux-next] xfs: remove unnecessary return
Date: Sat, 10 Dec 2016 07:52:09 +0100
Message-Id: <1481352729-7020-1-git-send-email-fabf@skynet.be>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, fabf@skynet.be

Commit f7a136aee3c1
("xfs: several xattr functions can be void")

updated 2 end of function return 0 to return in void
functions. Remove it.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/xfs/xfs_attr_list.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 97c45b6..5aa46c3 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -433,7 +433,6 @@ xfs_attr3_leaf_list_int(
 		cursor->offset++;
 	}
 	trace_xfs_attr_list_leaf_end(context);
-	return;
 }
 
 /*
@@ -543,7 +542,6 @@ xfs_attr_put_listent(
 	alist->al_offset[context->count++] = context->firstu;
 	alist->al_count = context->count;
 	trace_xfs_attr_list_add(context);
-	return;
 }
 
 /*
-- 
2.7.4

