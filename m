Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:45098 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750730AbeFEEHB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jun 2018 00:07:01 -0400
Date: Mon, 4 Jun 2018 21:06:57 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/3] xfs: verify root inode more thoroughly
Message-ID: <20180605040657.GD9437@magnolia>
References: <20180605024313.18737-1-david@fromorbit.com>
 <20180605025704.GZ10363@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180605025704.GZ10363@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jun 05, 2018 at 12:57:04PM +1000, Dave Chinner wrote:
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> When looking up the root inode at mount time, we don't actually do
> any verification to check that the inode is allocated and accounted
> for correctly in the INOBT. Make the checks on the root inode more
> robust by making it an untrusted lookup. This forces the inode
> lookup to use the inode btree to verify the inode is allocated
> and mapped correctly to disk. This will also have the effect of
> catching a significant number of AGI/INOBT related corruptions in
> AG 0 at mount time.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> ---
>  fs/xfs/xfs_mount.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 189fa7b615d3..a3378252baa1 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -862,9 +862,12 @@ xfs_mountfs(
>  	 * Get and sanity-check the root inode.
>  	 * Save the pointer to it in the mount structure.
>  	 */
> -	error = xfs_iget(mp, NULL, sbp->sb_rootino, 0, XFS_ILOCK_EXCL, &rip);
> +	error = xfs_iget(mp, NULL, sbp->sb_rootino, XFS_IGET_UNTRUSTED,

One little quirk I've noticed with xfs_iget is that a corrupt inode
buffer's -EFSCORRUPTED gets turned into -EINVAL on the way out of iget.
There's no way to distinguish between "the inode number was crap" vs.
"the inode is marked in use but the buffer verifier failed".

This particularly roars its head in the (directory) parent pointer
scrubber where we try an untrusted iget of the .. entry and if the
alleged parent inode is corrupt we lack the ability to distinguish the
two (ideally we'd set SCRUB_OFLAG_CORRUPT if the .. entry is junk and
SCRUB_OFLAG_XCORRUPT if the inode buffer verifier failed).

I was just going to fix the parent pointer scrubber to check the inobt
directly, but since this has the same reporting problem I figured I'd
just air my dirty laundry on the list. :)

--D

> +			 XFS_ILOCK_EXCL, &rip);
>  	if (error) {
> -		xfs_warn(mp, "failed to read root inode");
> +		xfs_warn(mp,
> +			"Failed to read root inode 0x%llx, error %d",
> +			sbp->sb_rootino, -error);
>  		goto out_log_dealloc;
>  	}
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
