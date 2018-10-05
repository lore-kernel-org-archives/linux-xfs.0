Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:38950 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726759AbeJFG72 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Oct 2018 02:59:28 -0400
Date: Fri, 5 Oct 2018 16:58:21 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] xfs: fix data corruption w/ unaligned dedupe ranges
Message-ID: <20181005235821.GA28243@magnolia>
References: <20181005012336.1418-1-david@fromorbit.com>
 <20181005012336.1418-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181005012336.1418-2-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Oct 05, 2018 at 11:23:35AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> A deduplication data corruption is Exposed by fstests generic/505 on
> XFS. It is caused by extending the block match range to include the
> partial EOF block, but then allowing unknown data beyond EOF to be
> considered a "match" to data in the destination file because the
> comparison is only made to the end of the source file. This corrupts
> the destination file when the source extent is shared with it.
> 
> XFS only supports whole block dedupe, but we still need to appear to
> support whole file dedupe correctly.  Hence if the dedupe request
> includes the last block of the souce file, don't include it in the
> actual XFS dedupe operation. If the rest of the range dedupes
> successfully, then report the partial last block as deduped, too, so
> that userspace sees it as a successful dedupe rather than return
> EINVAL because we can't dedupe unaligned blocks.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_reflink.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 5289e22cb081..6b0da1b80103 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1222,6 +1222,19 @@ xfs_iolock_two_inodes_and_break_layout(
>  
>  /*
>   * Link a range of blocks from one file to another.
> + *
> + * The VFS allows partial EOF blocks to "match" for dedupe even though it hasn't
> + * checked that the bytes beyond EOF physically match. Hence we cannot use the
> + * EOF block in the source dedupe range because it's not a complete block match,
> + * hence can introduce a corruption into the file that has it's
> + * block replaced.
> + *
> + * Despite this issue, we still need to report that range as successfully
> + * deduped to avoid confusing userspace with EINVAL errors on completely
> + * matching file data. The only time that an unaligned length will be passed to
> + * us is when it spans the EOF block of the source file, so if we simply mask it
> + * down to be block aligned here the we will dedupe everything but that partial
> + * EOF block.
>   */
>  int
>  xfs_reflink_remap_range(
> @@ -1274,6 +1287,14 @@ xfs_reflink_remap_range(
>  	if (ret <= 0)
>  		goto out_unlock;
>  
> +	/*
> +	 * If the dedupe data matches, chop off the partial EOF block
> +	 * from the source file so we don't try to dedupe the partial
> +	 * EOF block.
> +	 */
> +	if (is_dedupe)
> +		len &= ~((u64)i_blocksize(inode_in) - 1);

I think that truncating the length like this is going to cause a mess
since we don't have the plumbing to report the shorter dedupe length to
userspace.  Granted, this also causes stale data exposure and I don't
want to hold this up for my big long clonerange cleanup to land.

I'll probably end up cleaning up all this into a generic "check these
clone args for block alignment" later anyway, so you might as well go
ahead:

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> +
>  	/* Attach dquots to dest inode before changing block map */
>  	ret = xfs_qm_dqattach(dest);
>  	if (ret)
> -- 
> 2.17.0
> 
