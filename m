Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBL7S1Et244569 for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 01:28:01 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3AEAD1CE33C4
	for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 23:29:57 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	jxiNExXf68F3A4iZ for <xfs@oss.sgi.com>;
	Mon, 20 Dec 2010 23:29:57 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	50839304-1927428
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 17:59:55 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PUwfI-0001CM-7w
	for xfs@oss.sgi.com; Tue, 21 Dec 2010 18:29:44 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PUwf6-0006Yk-TG
	for xfs@oss.sgi.com; Tue, 21 Dec 2010 18:29:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/34] xfs: use KM_NOFS for allocations during attribute list
	operations
Date: Tue, 21 Dec 2010 18:28:58 +1100
Message-Id: <1292916570-25015-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1292916570-25015-1-git-send-email-david@fromorbit.com>
References: <1292916570-25015-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

When listing attributes, we are doiing memory allocations under the
inode ilock using only KM_SLEEP. This allows memory allocation to
recurse back into the filesystem and do writeback, which may the
ilock we already hold on the current inode. THis will deadlock.
Hence use KM_NOFS for such allocations outside of transaction
context to ensure that reclaim recursion does not occur.

Reported-by: Nick Piggin <npiggin@gmail.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr_leaf.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index a6cff8e..71e90dc2 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -637,7 +637,7 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *context)
 	 * It didn't all fit, so we have to sort everything on hashval.
 	 */
 	sbsize = sf->hdr.count * sizeof(*sbuf);
-	sbp = sbuf = kmem_alloc(sbsize, KM_SLEEP);
+	sbp = sbuf = kmem_alloc(sbsize, KM_SLEEP | KM_NOFS);
 
 	/*
 	 * Scan the attribute list for the rest of the entries, storing
@@ -2386,7 +2386,7 @@ xfs_attr_leaf_list_int(xfs_dabuf_t *bp, xfs_attr_list_context_t *context)
 				args.dp = context->dp;
 				args.whichfork = XFS_ATTR_FORK;
 				args.valuelen = valuelen;
-				args.value = kmem_alloc(valuelen, KM_SLEEP);
+				args.value = kmem_alloc(valuelen, KM_SLEEP | KM_NOFS);
 				args.rmtblkno = be32_to_cpu(name_rmt->valueblk);
 				args.rmtblkcnt = XFS_B_TO_FSB(args.dp->i_mount, valuelen);
 				retval = xfs_attr_rmtval_get(&args);
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
