Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0QLKAPV165787 for <xfs@oss.sgi.com>; Wed, 26 Jan 2011 15:20:10 -0600
Subject: Re: [PATCH 2/8] xfs: fix efi item leak on forced shutdown
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1295945444-29488-3-git-send-email-david@fromorbit.com>
References: <1295945444-29488-1-git-send-email-david@fromorbit.com>
	<1295945444-29488-3-git-send-email-david@fromorbit.com>
Date: Wed, 26 Jan 2011 15:22:34 -0600
Message-ID: <1296076954.1980.939.camel@doink>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, 2011-01-25 at 19:50 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> After test 139, kmemleak shows:
> 
> unreferenced object 0xffff880078b405d8 (size 400):
>   comm "xfs_io", pid 4904, jiffies 4294909383 (age 1186.728s)
>   hex dump (first 32 bytes):
. . .

> 
> The cause of the leak is that the "remove" parameter of IOP_UNPIN()
> is never set when a CIL push is aborted. This means that the EFI
> item is never freed if it was in the push being cancelled. The
> problem is specific to delayed logging.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Like Christoph, I was a bit confused about xfs_buf_item_unpin()
retaining the call to xfs_trans_del_item().  They all ought to
be done consistently.  Hopefully you can straighten that out.

Two other minor comments:  I'd prefer that an explicit "1" be
passed to IOP_UNPIN() rather than the variable "aborted" (which is
known to have non-zero value) in xfs_trans_committed_bulk().  And
there are some long-lined comments right near what you're changing
that you could touch up while you're at it.

> ---
>  fs/xfs/xfs_extfree_item.c |    1 -
>  fs/xfs/xfs_trans.c        |   35 ++++++++++++++++++++++++++++++-----
>  2 files changed, 30 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
. . .
> @@ -1472,6 +1480,16 @@ xfs_trans_committed_bulk(
>  		if (XFS_LSN_CMP(item_lsn, (xfs_lsn_t)-1) == 0)
>  			continue;
>  
> +		/*
> +		 * if we are aborting the operation, no point in inserting the
> +		 * object into the AIL as we are in a shutdown situation.
> +		 */
> +		if (aborted) {
> +			ASSERT(XFS_FORCED_SHUTDOWN(ailp->xa_mount));
> +			IOP_UNPIN(lip, aborted);
                            Here           ^^^

> +			continue;
> +		}
> +
>  		if (item_lsn != commit_lsn) {
>  
>  			/*


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
