Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3E76F7F37
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 16:09:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2D07B304062
	for <xfs@oss.sgi.com>; Wed, 29 May 2013 14:09:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Ll6RDpElE1oYM5Ka for
	<xfs@oss.sgi.com>; Wed, 29 May 2013 14:09:02 -0700 (PDT)
Message-ID: <51A66DC0.10405@redhat.com>
Date: Wed, 29 May 2013 17:06:08 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 6/9] xfs: disable swap extents ioctl on CRC enabled
	filesystems
References: <1369636707-15150-1-git-send-email-david@fromorbit.com>
	<1369636707-15150-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1369636707-15150-7-git-send-email-david@fromorbit.com>
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

On 05/27/2013 02:38 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Currently, swapping extents from one inode to another is a simple
> act of switching data and attribute forks from one inode to another.
> This, unfortunately in no longer so simple with CRC enabled
> filesystems as there is owner information embedded into the BMBT
> blocks that are swapped between inodes. Hence swapping the forks
> between inodes results in the inodes having mapping blocks that
> point to the wrong owner and hence are considered corrupt.
> 
> To fix this we need an extent tree block or record based swap
> algorithm so that the BMBT block owner information can be updated
> atomically in the swap transaction. This is a significant piece of
> new work, so for the moment simply don't allow swap extent
> operations to succeed on CRC enabled filesystems.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Pretty straightforward...

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_dfrag.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
> index f852b08..c407e1c 100644
> --- a/fs/xfs/xfs_dfrag.c
> +++ b/fs/xfs/xfs_dfrag.c
> @@ -219,6 +219,14 @@ xfs_swap_extents(
>  	int		taforkblks = 0;
>  	__uint64_t	tmp;
>  
> +	/*
> +	 * We have no way of updating owner information in the BMBT blocks for
> +	 * each inode on CRC enabled filesystems, so to avoid corrupting the
> +	 * this metadata we simply don't allow extent swaps to occur.
> +	 */
> +	if (xfs_sb_version_hascrc(&mp->m_sb))
> +		return XFS_ERROR(EINVAL);
> +
>  	tempifp = kmem_alloc(sizeof(xfs_ifork_t), KM_MAYFAIL);
>  	if (!tempifp) {
>  		error = XFS_ERROR(ENOMEM);
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
