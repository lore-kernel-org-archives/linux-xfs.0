Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 Jan 2008 19:54:01 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0E3rpiC002745
	for <xfs@oss.sgi.com>; Sun, 13 Jan 2008 19:53:55 -0800
Message-ID: <478ADD90.1000806@sgi.com>
Date: Mon, 14 Jan 2008 14:57:04 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] make inode reclaim synchronise with xfs_iflush_done()
References: <475F878D.6090407@sgi.com> <20071212230858.GO4612@sgi.com>
In-Reply-To: <20071212230858.GO4612@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

David Chinner wrote:
> (can ppl please post patches in line rather than as attachments
> as it's really hard to quote attachments)
> 
> On Wed, Dec 12, 2007 at 06:02:37PM +1100, Lachlan McIlroy wrote:
>> On a forced shutdown, xfs_finish_reclaim() will skip flushing the inode.
>> If the inode flush lock is not already held and there is an outstanding
>> xfs_iflush_done() then we might free the inode prematurely.  By acquiring
>> and releasing the flush lock we will synchronise with xfs_iflush_done().
> 
> Yes, That could happen. Good catch. Comments on the code below.
> 
>> Alternatively we could take a hold on the inode when when issuing I/Os
>> with xfs_iflush_done() and release it in xfs_iflush_done().  Would this
>> be a better approach?
> 
> No - we can't take a hold on the inode because it may not have a linux
> inode attached to it and hence there's nothing to hold the reference
> count (we use the linux inode reference count for this).
> 
> 
> --- fs/xfs/xfs_vnodeops.c_1.726	2007-12-12 17:14:59.000000000 +1100
> +++ fs/xfs/xfs_vnodeops.c	2007-12-12 17:15:42.000000000 +1100
> @@ -3762,20 +3762,29 @@ xfs_finish_reclaim(
>  				goto reclaim;
>  			}
>  			xfs_iflock(ip); /* synchronize with xfs_iflush_done */
> +			xfs_ifunlock(ip);
>  		}
> 
> Why do you unlock it here? If it is left locked, there is absolutely
> no chance for the inode to be flushed again after this point.
>  
>  		ASSERT(ip->i_update_core == 0);
>  		ASSERT(ip->i_itemp == NULL ||
>  		       ip->i_itemp->ili_format.ilf_fields == 0);
>  		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -	} else if (locked) {
> +	} else {
>  		/*
>  		 * We are not interested in doing an iflush if we're
>  		 * in the process of shutting down the filesystem forcibly.
>  		 * So, just reclaim the inode.
> -		 */
> -		xfs_ifunlock(ip);
> -		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +		 * 
> +		 * If the flush lock is not already held then temporarily
> +		 * acquire it to synchronize with xfs_iflush_done.
> +		 */
> +		if (locked) {
> +			xfs_ifunlock(ip);
> +			xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +		} else {
> +			xfs_iflock(ip);
> +			xfs_ifunlock(ip);
> +		}
>  	}
> 
> Oh, that just makes it messy :/
> 
> How about locking the inode unconditionally before the entire if..else
> statement like:
> 
> +	if (!locked) {
> +		xfs_ilock(ip, XFS_ILOCK_EXCL);
> +		xfs_iflock(ip);
> +	}
>         if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
> -		if (!locked) {
> -			xfs_ilock(ip, XFS_ILOCK_EXCL);
> -			xfs_iflock(ip);
> -		}
> 
> .....
> -	} else if (locked) {
> +	} else {
>  		/*
>  		 * We are not interested in doing an iflush if we're
>  		 * in the process of shutting down the filesystem forcibly.
>  		 * So, just reclaim the inode.
> -		xfs_ifunlock(ip);
> 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	}
>   reclaim:
> 
> That would mean we always go to xfs_ireclaim() with the flush lock held
> and hence a guarantee that no more I/O can be issued on the inode.

That would be a bad thing.  We are about to tear the inode down and free
the memory.  If any threads are still waiting on the flush lock they will
wait forever or eventually access freed memory.

This patch cleans up the code a little further by removing the
'else if (locked)' case.

--- fs/xfs/xfs_vnodeops.c_1.727	2008-01-10 16:00:48.000000000 +1100
+++ fs/xfs/xfs_vnodeops.c	2008-01-11 13:35:41.000000000 +1100
@@ -3721,12 +3721,12 @@ xfs_finish_reclaim(
  	 * We get the flush lock regardless, though, just to make sure
  	 * we don't free it while it is being flushed.
  	 */
-	if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
-		if (!locked) {
-			xfs_ilock(ip, XFS_ILOCK_EXCL);
-			xfs_iflock(ip);
-		}
+	if (!locked) {
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		xfs_iflock(ip);
+	}

+	if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
  		if (ip->i_update_core ||
  		    ((ip->i_itemp != NULL) &&
  		     (ip->i_itemp->ili_format.ilf_fields != 0))) {
@@ -3746,18 +3746,12 @@ xfs_finish_reclaim(
  		ASSERT(ip->i_update_core == 0);
  		ASSERT(ip->i_itemp == NULL ||
  		       ip->i_itemp->ili_format.ilf_fields == 0);
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	} else if (locked) {
-		/*
-		 * We are not interested in doing an iflush if we're
-		 * in the process of shutting down the filesystem forcibly.
-		 * So, just reclaim the inode.
-		 */
-		xfs_ifunlock(ip);
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
  	}

- reclaim:
+	xfs_ifunlock(ip);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+reclaim:
  	xfs_ireclaim(ip);
  	return 0;
  }
