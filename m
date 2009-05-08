Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4819bo1241533 for <xfs@oss.sgi.com>; Thu, 7 May 2009 20:09:37 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8CB6126F34F
	for <xfs@oss.sgi.com>; Thu,  7 May 2009 18:09:41 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id zXd9gDCIdu2cCyvm for
	<xfs@oss.sgi.com>; Thu, 07 May 2009 18:09:41 -0700 (PDT)
Message-ID: <4A038651.5010202@sandeen.net>
Date: Thu, 07 May 2009 20:09:37 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 2.6.30-rc4: xfs_fsr hangs
References: <a4423d670905011333s664115bdh1d72392897567c1d@mail.gmail.com>
	<4A036FBC.9020201@sandeen.net> <4A037503.1070904@sandeen.net>
	<ABCCDF18-5100-4891-AF1C-BA9513C8A334@sgi.com>
In-Reply-To: <ABCCDF18-5100-4891-AF1C-BA9513C8A334@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Felix Blyakher <felixb@sgi.com>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Alexander Beregalov <a.beregalov@gmail.com>, xfs@oss.sgi.com

Felix Blyakher wrote:

> I've been chasing this as well, and I found the double xfs iolock
> unlock which is causing xfs_fsr deadlock itself. I have a fix tested.
> The patch is coming.
>
> Felix
>   
Oh :)  I just sent this one to the list ...  :)

XFS: Fix double unlock of inodes in xfs_swap_extents()

commit ef8f7fc549bf345d92f396f5aa7b152b4969cbf7 had an error
where we would try to re-unlock the inodes after they had been
committed in the transaction; this double unlock caused a

=====================================
[ BUG: bad unlock balance detected! ]
-------------------------------------
xfs_fsr/1459 is trying to release lock (&(&ip->i_iolock)->mr_lock) at:
[<e248dedb>] xfs_iunlock+0x2c/0x92 [xfs]
but there are no more locks to release!

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: linux-2.6/fs/xfs/xfs_dfrag.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_dfrag.c
+++ linux-2.6/fs/xfs/xfs_dfrag.c
@@ -347,13 +347,15 @@ xfs_swap_extents(
 
 	error = xfs_trans_commit(tp, XFS_TRANS_SWAPEXT);
 
-out_unlock:
-	xfs_iunlock(ip,  XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
-	xfs_iunlock(tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
 out:
 	kmem_free(tempifp);
 	return error;
 
+out_unlock:
+	xfs_iunlock(ip,  XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	xfs_iunlock(tip, XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL);
+	goto out;
+
 out_trans_cancel:
 	xfs_trans_cancel(tp, 0);
 	goto out_unlock;





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
