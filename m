Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 30 Jun 2007 16:42:30 -0700 (PDT)
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.174])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5UNgPtL030322
	for <xfs@oss.sgi.com>; Sat, 30 Jun 2007 16:42:26 -0700
Received: by ug-out-1314.google.com with SMTP id z36so1202639uge
        for <xfs@oss.sgi.com>; Sat, 30 Jun 2007 16:42:26 -0700 (PDT)
From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH][XFS][resend] fix memory leak in xfs_inactive()
Date: Sun, 1 Jul 2007 01:16:51 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707010116.52012.jesper.juhl@gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: David Chinner <dgc@sgi.com>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>, Jesper Juhl <jesper.juhl@gmail.com>

(this is back from May 16 2007, resending since it doesn't look like 
the patch ever made it in anywhere)


The Coverity checker found a memory leak in xfs_inactive().

The offending code is this bit :

1671            tp = xfs_trans_alloc(mp, XFS_TRANS_INACTIVE);

At conditional (1): "truncate != 0" taking true path

1672            if (truncate) {
1673                    /*
1674                     * Do the xfs_itruncate_start() call before
1675                     * reserving any log space because itruncate_start
1676                     * will call into the buffer cache and we can't
1677                     * do that within a transaction.
1678                     */
1679                    xfs_ilock(ip, XFS_IOLOCK_EXCL);
1680
1681                    error = xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE, 0);

At conditional (2): "error != 0" taking true path

1682                    if (error) {
1683                            xfs_iunlock(ip, XFS_IOLOCK_EXCL);

Event leaked_storage: Returned without freeing storage "tp"
Also see events: [alloc_fn][var_assign]

1684                            return VN_INACTIVE_CACHE;
1685                    }

So, the code allocates a transaction, but in the case where 'truncate' is !=0 and xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE, 0); happens to return an error, we'll just return from the function without dealing with the memory allocated byxfs_trans_alloc() and assigned to 'tp', thus it'll be orphaned/leaked - not good.

The bug was introduced by this commit:
http://git2.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d3cf209476b72c83907a412b6708c5e498410aa7

The patch below is

From: Dave Chinner <dgc@sgi.com>
Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
 fs/xfs/xfs_vnodeops.c |    1 +
 1 file changed, 1 insertion(+)

Index: 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_vnodeops.c	2007-05-11 16:04:03.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_vnodeops.c	2007-05-17 12:37:25.671399078 +1000
@@ -1710,6 +1710,7 @@ xfs_inactive(
 
 		error = xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE, 0);
 		if (error) {
+			xfs_trans_cancel(tp, 0);
 			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 			return VN_INACTIVE_CACHE;
 		}
