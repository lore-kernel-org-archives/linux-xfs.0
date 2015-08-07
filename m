Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6C7C07F55
	for <xfs@oss.sgi.com>; Thu,  6 Aug 2015 19:41:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 588218F804C
	for <xfs@oss.sgi.com>; Thu,  6 Aug 2015 17:41:54 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	pyOMruh9UniaImpC for <xfs@oss.sgi.com>;
	Thu, 06 Aug 2015 17:41:49 -0700 (PDT)
Date: Fri, 7 Aug 2015 10:41:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/11] xfs: fix efi/efd error handling to avoid fs
	shutdown hangs
Message-ID: <20150807004100.GD16638@dastard>
References: <1438883072-28706-1-git-send-email-bfoster@redhat.com>
	<1438883072-28706-4-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1438883072-28706-4-git-send-email-bfoster@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Aug 06, 2015 at 01:44:24PM -0400, Brian Foster wrote:
....
> Update the EFI/EFD item handling code to use a more straightforward and
> reliable approach to error handling. If an error occurs after the EFI
> transaction is committed and before the EFD is constructed, release the
> EFI explicitly from xfs_bmap_finish(). If the EFI transaction is
> cancelled, release the EFI in the unlock handler.
> 
> Once the EFD is constructed, it is responsible for releasing the EFI
> under any circumstances (including whether the EFI item aborts due to
> log I/O error).

Can you document these rules in a comment at the top of
fs/xfs/xfs_extfree_item.c?

> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 42c9b05..aceb54f 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -61,9 +61,15 @@ __xfs_efi_release(
>  
>  	if (atomic_dec_and_test(&efip->efi_refcount)) {
>  		spin_lock(&ailp->xa_lock);
> -		/* xfs_trans_ail_delete() drops the AIL lock. */
> -		xfs_trans_ail_delete(ailp, &efip->efi_item,
> -				     SHUTDOWN_LOG_IO_ERROR);
> +		/*
> +		 * We don't know whether the EFI made it to the AIL. Remove it
> +		 * if so. Note that xfs_trans_ail_delete() drops the AIL lock.
> +		 */
> +		if (efip->efi_item.li_flags & XFS_LI_IN_AIL)
> +			xfs_trans_ail_delete(ailp, &efip->efi_item,
> +					     SHUTDOWN_LOG_IO_ERROR);
> +		else
> +			spin_unlock(&ailp->xa_lock);
>  		xfs_efi_item_free(efip);
>  	}

We now have a lot of this pattern:

	spin_lock(&ailp->xa_lock);
	if (lip->li_flags & XFS_LI_IN_AIL)
		xfs_trans_ail_delete(ailp, lip, shutdown_reason);
	else
		spin_unlock(&ailp->xa_lock);

occurring in the code. Can you look into adding a helper function
for this, say xfs_trans_ail_remove()? (separate patch, of course!)

The rest of the patch looks fine - getting rid of almost all of
those aborted flag special cases is a big win :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
