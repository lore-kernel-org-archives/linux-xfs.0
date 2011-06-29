Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5TIabd6128031 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 13:36:37 -0500
Subject: Re: sbcount comment change
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1309366188.5505.6215.camel@chandra-lucid.beaverton.ibm.com>
References: <1309366188.5505.6215.camel@chandra-lucid.beaverton.ibm.com>
Date: Wed, 29 Jun 2011 13:36:32 -0500
Message-ID: <1309372592.4646.45.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: sekharan@us.ibm.com
Cc: xfs@oss.sgi.com

On Wed, 2011-06-29 at 09:49 -0700, Chandra Seetharaman wrote:
> Hi Alex,
> 
> Does this look fine ?

Yes.  But it's small enough that I think you should just
include this change with another change (especially if you
decide to drop the "sync" flag from this function as I
suggested).

					-Alex

> --------------
> @@ -1568,18 +1568,14 @@ xfs_fs_writable(xfs_mount_t *mp)
>  /*
>   * xfs_log_sbcount
>   *
> - * Called either periodically to keep the on disk superblock values
> - * roughly up to date or from unmount to make sure the values are
> - * correct on a clean unmount.
> + * Sync the superblock counters to disk.
>   *
>   * Note this code can be called during the process of freezing, so
> - * we may need to use the transaction allocator which does not not
> + * we may need to use the transaction allocator which does not
>   * block when the transaction subsystem is in its frozen state.
>   */
> ----------------
> 

	

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
