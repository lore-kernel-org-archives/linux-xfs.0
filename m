Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 12 Oct 2006 18:48:00 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9D1llaG025172
	for <xfs@oss.sgi.com>; Thu, 12 Oct 2006 18:47:48 -0700
Date: Fri, 13 Oct 2006 11:46:51 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [patch] Fix xfs_iunpin() sets I_DIRTY_SYNC after clear_inode().
Message-ID: <20061013014651.GC19345@melbourne.sgi.com>
References: <45237CCE.4010007@ah.jp.nec.com> <20061006032617.GC11034@melbourne.sgi.com> <20061011064357.GN19345@melbourne.sgi.com> <452E32FF.8010109@ah.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <452E32FF.8010109@ah.jp.nec.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takenori Nagano <t-nagano@ah.jp.nec.com>
Cc: xfs@oss.sgi.com

On Thu, Oct 12, 2006 at 09:20:15PM +0900, Takenori Nagano wrote:
> Hi David,
> 
> I tried those patches, but they caused degradation.
> These are results of "vmstat 10" while my test program was running.
> 
> - Before applying those patches:
> procs -----------memory---------- ---swap-- -----io---- -system-- -----cpu------
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
>  7  0      0 2768240  37632 210512    0    0     7 43367  268  676  1 49 50  0  0
>  9  0      0 2716352  37632 210672    0    0     0 362864 2154 47915  1 51 48  0  0
>  9  0      0 2663136  37664 210048    0    0     0 361745 2154 48258  1 50 49  0  0
> 10  0      0 2610688  37664 211184    0    0     0 360908 2152 48068  1 51 49  0  0
>  9  0      0 2557904  37680 210512    0    0     0 360254 2154 49036  1 51 48  0  0
> 10  0      0 2504832  37696 210304    0    0     0 362525 2153 48460  1 50 49  0  0
> 
> 
> - After applying those patches:
> procs -----------memory---------- ---swap-- -----io---- -system-- -----cpu------
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
>  0  0      0 15584608  21776 153072    0    0    69   403  256  394  1  3 95  1  0
>  0  0      0 15586032  21824 153024    0    0     1  2319 2161 2944  0  2 98  0  0
>  1  0      0 15585920  21824 153104    0    0     0  2342 2161 2951  0  2 98  0  0
>  0  0      0 15585696  21824 152976    0    0     0  2364 2160 2978  0  2 98  0  0
>  1  0      0 15585360  21824 153168    0    0     0  2380 2161 3027  0  2 98  0  0
>  0  0      0 15585248  21824 152976    0    0     0  2348 2161 2983  0  2 98  0  0
> 
> 
> Block I/O performance degradation was very serious.

That was unexpected. :/

> Now, I am trying to ease the degradation.
> Do you have any idea for resolving the degradation?

Did you see a degradation with your original fix? I suspect
not.

I think that the lsn based flush is tripping over a sync
transaction "optimisation" - if the previous log buffer needs
syncing or is currently being synced, then we don't try to flush the
active log buffer straight away - we wait for the previous log
buffer to complete it's I/O in the hope that we get more
transactions into the current log buffer.

IOWs, we introduce a pipeline bubble where we don't force the
current log buffer until the I/O on the previous log buffer has
completed and this effectively serialises these log forces. I
suspect that this is not needed anymore, but I'll look
inot this separately.

When flushing the entire log, (using 0 as the lsn as your
original patch did), we simply close off the current buffer
and flush it out, waiting on it completion if we need a sync
flush. IOWs, no pipeline bubble is introduced and we continue
to issue concurrent log I/O.

Can you test this patch (on top of the last patch I sent)
and see if it fixes the degradation?

Regards,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/xfs_inode.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.c	2006-10-11 17:09:12.000000000 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_inode.c	2006-10-13 11:43:38.236562541 +1000
@@ -2773,26 +2773,16 @@ void
 xfs_iunpin_wait(
 	xfs_inode_t	*ip)
 {
-	xfs_inode_log_item_t	*iip;
-	xfs_lsn_t	lsn;
-
 	ASSERT(ismrlocked(&ip->i_lock, MR_UPDATE | MR_ACCESS));
 
 	if (atomic_read(&ip->i_pincount) == 0) {
 		return;
 	}
 
-	iip = ip->i_itemp;
-	if (iip && iip->ili_last_lsn) {
-		lsn = iip->ili_last_lsn;
-	} else {
-		lsn = (xfs_lsn_t)0;
-	}
-
 	/*
 	 * Give the log a push so we don't wait here too long.
 	 */
-	xfs_log_force(ip->i_mount, lsn, XFS_LOG_FORCE);
+	xfs_log_force(ip->i_mount, 0, XFS_LOG_FORCE);
 
 	wait_event(ip->i_ipin_wait, (atomic_read(&ip->i_pincount) == 0));
 }
