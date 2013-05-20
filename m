Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EA85C7F50
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 12:58:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C4BB8304053
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 10:58:54 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cQ1NMkKG3o8FQ0Zw for
	<xfs@oss.sgi.com>; Mon, 20 May 2013 10:58:54 -0700 (PDT)
Message-ID: <519A655A.3020900@redhat.com>
Date: Mon, 20 May 2013 14:03:06 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 03/14] xfs: Don't reference the EFI after it is freed
References: <1369007481-15185-1-git-send-email-david@fromorbit.com>
	<1369007481-15185-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1369007481-15185-4-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 05/19/2013 07:51 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Checking the EFI for whether it is being released from recovery
> after we've already released the known active reference is a mistake
> worthy of a brown paper bag. Fix the (now) obvious use after free
> that it can cause.
> 
> Reported-by: Dave Jones <davej@redhat.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Looks good to me.

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_extfree_item.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index c0f3750..452920a 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -305,11 +305,12 @@ xfs_efi_release(xfs_efi_log_item_t	*efip,
>  {
>  	ASSERT(atomic_read(&efip->efi_next_extent) >= nextents);
>  	if (atomic_sub_and_test(nextents, &efip->efi_next_extent)) {
> -		__xfs_efi_release(efip);
> -
>  		/* recovery needs us to drop the EFI reference, too */
>  		if (test_bit(XFS_EFI_RECOVERED, &efip->efi_flags))
>  			__xfs_efi_release(efip);
> +
> +		__xfs_efi_release(efip);
> +		/* efip may now have been freed, do not reference it again. */
>  	}
>  }
>  
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
