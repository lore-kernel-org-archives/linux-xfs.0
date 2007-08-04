Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 04 Aug 2007 12:00:17 -0700 (PDT)
Received: from mu-out-0910.google.com (mu-out-0910.google.com [209.85.134.188])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l74J0Cbm010459
	for <xfs@oss.sgi.com>; Sat, 4 Aug 2007 12:00:13 -0700
Received: by mu-out-0910.google.com with SMTP id i10so1488937mue
        for <xfs@oss.sgi.com>; Sat, 04 Aug 2007 12:00:16 -0700 (PDT)
From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH][RESEND] fix a potential NULL pointer deref in XFS on failed mount.
Date: Sat, 4 Aug 2007 20:30:21 +0200
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200708042030.21375.jesper.juhl@gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Jesper Juhl <jesper.juhl@gmail.com>

Back in 2006 (2006-10-31 to be specific, reposted on 2006-11-16), I 
submitted a patch to fix a potential NULL pointer deref in XFS on 
failed mount.

The patch drew some comments and it turned out that my initial 
approach to a fix was wrong.
David Chinner kindly offered some tips on how to implement a proper 
fix, and on 2006-11-20 I submitted a revised fix.  This patch, 
unfortunately, didn't draw any comments, nor did it ever get merged 
anywhere.  
I believe that now sufficient time has passed to warrent a repost.

And now, on August 4, 2007 - yet another resend. 
it would really be nice if this patch could either get merged or, 
if it is wrong for some reason, get an explicit NACK. Come on people, 
what's it going to be?



The Coverity checker spotted (as bug #346) a potential problem in XFS.

The problem is that if, in xfs_mount(), this code triggers:

       ...
       if (!mp->m_logdev_targp)
               goto error0;
       ...

Then we'll end up calling xfs_unmountfs_close() with a NULL
'mp->m_logdev_targp'.
This in turn will result in a call to xfs_free_buftarg() with its 'btp'
argument == NULL. xfs_free_buftarg() dereferences 'btp' leading to
a NULL pointer dereference and crash.

I think this can happen, since the fatal call to xfs_free_buftarg()
happens when 'm_logdev_targp != m_ddev_targp' and due to a check of
'm_ddev_targp' against NULL in xfs_mount() (and subsequent return if it is
NULL) the two will never both be NULL when we hit the error0 label from
the two lines cited above.

This patch fixes the issue by checking mp->m_logdev_targp against NULL 
in xfs_unmountfs_close() and doing the proper xfs_blkdev_put(logdev); 
and xfs_blkdev_put(rtdev); on (!mp->m_rtdev_targp) in xfs_mount().

Compile tested.

Comments and feedback welcome.

Please consider merging.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
 fs/xfs/xfs_mount.c  |    2 +-
 fs/xfs/xfs_vfsops.c |   10 ++++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index a66b398..215e041 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1275,7 +1275,7 @@ xfs_unmountfs(xfs_mount_t *mp, struct cred *cr)
 void
 xfs_unmountfs_close(xfs_mount_t *mp, struct cred *cr)
 {
-	if (mp->m_logdev_targp != mp->m_ddev_targp)
+	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
 		xfs_free_buftarg(mp->m_logdev_targp, 1);
 	if (mp->m_rtdev_targp)
 		xfs_free_buftarg(mp->m_rtdev_targp, 1);
diff --git a/fs/xfs/xfs_vfsops.c b/fs/xfs/xfs_vfsops.c
index 11f5ea2..6d4bc5d 100644
--- a/fs/xfs/xfs_vfsops.c
+++ b/fs/xfs/xfs_vfsops.c
@@ -482,13 +482,19 @@ xfs_mount(
 	}
 	if (rtdev) {
 		mp->m_rtdev_targp = xfs_alloc_buftarg(rtdev, 1);
-		if (!mp->m_rtdev_targp)
+		if (!mp->m_rtdev_targp) {
+			xfs_blkdev_put(logdev);
+			xfs_blkdev_put(rtdev);
 			goto error0;
+		}
 	}
 	mp->m_logdev_targp = (logdev && logdev != ddev) ?
 				xfs_alloc_buftarg(logdev, 1) : mp->m_ddev_targp;
-	if (!mp->m_logdev_targp)
+	if (!mp->m_logdev_targp) {
+		xfs_blkdev_put(logdev);
+		xfs_blkdev_put(rtdev);
 		goto error0;
+	}
 
 	/*
 	 * Setup flags based on mount(2) options and then the superblock
