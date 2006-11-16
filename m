Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Nov 2006 13:17:35 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAGLHQaG013918
	for <xfs@oss.sgi.com>; Thu, 16 Nov 2006 13:17:27 -0800
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.188])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3A2F6D1E05F2
	for <xfs@oss.sgi.com>; Thu, 16 Nov 2006 13:16:36 -0800 (PST)
Received: by nf-out-0910.google.com with SMTP id x30so1069256nfb
        for <xfs@oss.sgi.com>; Thu, 16 Nov 2006 13:16:35 -0800 (PST)
From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH][RFC][resend] potential NULL pointer deref in XFS on failed mount
Date: Thu, 16 Nov 2006 22:18:26 +0100
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200611162218.26945.jesper.juhl@gmail.com>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: xfs@oss.sgi.com, xfs-masters@oss.sgi.com, nathans@sgi.com, Jesper Juhl <jesper.juhl@gmail.com>, Andrew Morton <akpm@osdl.org>

(got no reply on this when I originally send it on 20061031, so resending
 now that a bit of time has passed.  The patch still applies cleanly to
 Linus' git tree as of today.)


The Coverity checker spotted a potential problem in XFS.

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

Comments welcome (please keep me on Cc: on replies).

Here's a proposed patch to fix this by testing 'btp' against NULL in 
xfs_free_buftarg().


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 fs/xfs/linux-2.6/xfs_buf.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index db5f5a3..6ef1860 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1450,6 +1450,9 @@ xfs_free_buftarg(
 	xfs_buftarg_t		*btp,
 	int			external)
 {
+	if (unlikely(!btp))
+		return;
+
 	xfs_flush_buftarg(btp, 1);
 	if (external)
 		xfs_blkdev_put(btp->bt_bdev);
