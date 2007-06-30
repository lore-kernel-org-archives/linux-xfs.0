Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 30 Jun 2007 16:46:07 -0700 (PDT)
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.172])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5UNk0tL031451
	for <xfs@oss.sgi.com>; Sat, 30 Jun 2007 16:46:03 -0700
Received: by ug-out-1314.google.com with SMTP id z36so1202865uge
        for <xfs@oss.sgi.com>; Sat, 30 Jun 2007 16:46:02 -0700 (PDT)
From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH][XFS][resend] memory leak; allocated transaction not freed in xfs_inactive_free_eofblocks() in failure case.
Date: Sun, 1 Jul 2007 01:16:54 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707010116.54884.jesper.juhl@gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: David Chinner <dgc@sgi.com>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>, Jesper Juhl <jesper.juhl@gmail.com>

(this is back from May 16 2007, resending since it doesn't look like 
the patch ever made it in anywhere)


Fix XFS memory leak; allocated transaction not freed in xfs_inactive_free_eofblocks() in failure case.

the code allocates a transaction, but in the case where 'truncate' is
!=0 and xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE, 0); happens to return
an error, we'll just return from the function without dealing with the
memory allocated byxfs_trans_alloc() and assigned to 'tp', thus it'll be
orphaned/leaked - not good.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
--- 
 fs/xfs/xfs_vnodeops.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index de17aed..32519cf 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -1260,6 +1260,7 @@ xfs_inactive_free_eofblocks(
 		error = xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE,
 				    ip->i_size);
 		if (error) {
+			xfs_trans_cancel(tp, 0);
 			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 			return error;
 		}
