Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 119947F51
	for <xfs@oss.sgi.com>; Mon, 17 Nov 2014 16:45:13 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C90F7304039
	for <xfs@oss.sgi.com>; Mon, 17 Nov 2014 14:45:09 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	D3NuAHLcF7D2zKXd for <xfs@oss.sgi.com>;
	Mon, 17 Nov 2014 14:45:04 -0800 (PST)
Date: Tue, 18 Nov 2014 09:44:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] Add support to RENAME_EXCHANGE flag V7
Message-ID: <20141117224422.GE29950@dastard>
References: <1415989940-20004-1-git-send-email-cmaiolino@redhat.com>
	<1415989940-20004-3-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1415989940-20004-3-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Nov 14, 2014 at 04:32:20PM -0200, Carlos Maiolino wrote:
> Adds a new function named xfs_cross_rename(), responsible to handle requests
> from sys_renameat2() using RENAME_EXCHANGE flag.
> 
> Changelog:
> 
> 	V2: - refactor xfs_cross_rename() to not duplicate code from xfs_rename()
> 
> 	V3: - fix indentation to avoid 80 column crossing, decrease the amount of
> 	      arguments passed to xfs_cross_rename()
> 	    - Rebase patches over the latest linux code
> 
> 	v4: - use a label/goto statement instead of an if conditional after
> 	      xfs_cross_rename() return, to finish the rename operation
> 	    - Make xfs_cross_rename() static
> 	    - Fix some comments
> 
> 	V5: - Keep all the code under 80 columns
> 
> 	V6: - Ensure i_mode of both files are updated during exchange
> 
> 	V7: - Use struct names instead of typedefs in the xfs_cross_rename()
> 	      definition
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_inode.c | 113 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/xfs/xfs_inode.h |   2 +-
>  fs/xfs/xfs_iops.c  |  15 +++++--
>  3 files changed, 124 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 8ed049d..3a77254 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2668,6 +2668,103 @@ xfs_sort_for_rename(
>  	}
>  }
>  
> +/* xfs_cross_rename()
> + *
> + * responsible to handle RENAME_EXCHANGE flag
> + * in renameat2() sytemcall
> + */
> +STATIC int
> +xfs_cross_rename(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*src_dp,
> +	struct xfs_name		*src_name,
> +	struct xfs_inode	*src_ip,
> +	struct xfs_inode	*target_dp,
> +	struct xfs_name		*target_name,
> +	struct xfs_inode	*target_ip,
> +	struct xfs_bmap_free	*free_list,
> +	xfs_fsblock_t		*first_block,
> +	int			spaceres)
> +{
> +	int		error = 0;
> +	int		new_parent;
> +	int		src_is_directory;
> +	int		tgt_is_directory;
> +
> +	new_parent = (src_dp != target_dp);
> +	src_is_directory = S_ISDIR(src_ip->i_d.di_mode);
> +	tgt_is_directory = S_ISDIR(target_ip->i_d.di_mode);

As I read the code below, I read src_is_directory and wonder "is
that the src_dp or the src_ip it refers to?"

None of these local variables are really needed - they don't
actually clarify or simplify the code. Can you just use the
S_ISDIR() macros directly, and kill the new_parent variable, too?

Also, I find the src/target names
to be very hard to follow as this is an exchange and so there isn't
any source/target difference in the logic. I'd actually prefer
something like "dp1, ip1, name1, dp2, ip2, name2" because it implies
(correctly) that the inodes/name parameters could be swapped and the
result would be the same. 

> +
> +	/* Replace source inode */
> +	error = xfs_dir_replace(tp, src_dp, src_name,
> +				target_ip->i_ino,
> +				first_block, free_list, spaceres);
> +	if (error)
> +		goto out;
> +
> +	/* Replace target inode */
> +	error = xfs_dir_replace(tp, target_dp, target_name,
> +				src_ip->i_ino,
> +				first_block, free_list, spaceres);
> +	if (error)
> +		goto out;
> +
> +	xfs_trans_ichgtime(tp, src_dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);

Timestamp updates are usually done at the same time we log the
inode cores, so it's obvious that we are logging the inodes we are
modifying, otherwise mistakes are made.....

> +
> +	/*
> +	* If we're renaming one or more directories across different parents,
> +	* update the respective ".." entries (and link counts) to match the new
> +	* parents.
> +	*/
> +	if (new_parent) {
> +		xfs_trans_ichgtime(tp, target_dp,
> +				   XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
> +
> +		if (tgt_is_directory) {
> +			error = xfs_dir_replace(tp, target_ip, &xfs_name_dotdot,
> +						src_dp->i_ino, first_block,
> +						free_list, spaceres);

Here is the only place we modify target_ip, hence the core should be
logged here and not unconditionally a the end of the function.

However, we should also bump the ctime of this inode (and the
src_ip, too), because as per the comment in the rename code proper:

        /*
         * We always want to hit the ctime on the source inode.
         *
         * This isn't strictly required by the standards since the source
         * inode isn't really being changed, but old unix file systems did
         * it and some incremental backup programs won't work without it.
         */

So while we strictly aren't touching either inode, we really should
be unconditionally bumping the ctimes on them so that userspace can
see that some change to the inode has actually taken place.


> +			if (error)
> +				goto out;
> +
> +			/* transfer target ".." reference to src_dp */
> +			if (!src_is_directory) {
> +				error = xfs_droplink(tp, target_dp);
> +				if (error)
> +					goto out;
> +				error = xfs_bumplink(tp, src_dp);
> +				if (error)
> +					goto out;
> +			}
> +		}
> +
> +		if (src_is_directory) {
> +			error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
> +						target_dp->i_ino, first_block,
> +						free_list, spaceres);

Same here.

> +			if (error)
> +				goto out;
> +
> +			/* transfer src ".." reference to target_dp */
> +			if (!tgt_is_directory) {
> +				error = xfs_droplink(tp, src_dp);
> +				if (error)
> +					goto out;
> +				error = xfs_bumplink(tp, target_dp);
> +				if (error)
> +					goto out;
> +			}
> +		}
> +		xfs_trans_log_inode(tp, src_dp, XFS_ILOG_CORE);

That's wrong (see my comment above about pairing timestamp/inode
logging together) as it should be the target_dp that is logged here
to match the timestamp update done in this branch.

> +	}
> +	xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);

And this should be src_dp.

> +	xfs_trans_log_inode(tp, src_ip, XFS_ILOG_CORE);
> +	xfs_trans_log_inode(tp, target_ip, XFS_ILOG_CORE);

And those aren't modified unless we update the dotdot entries and
update timestamps, and hence need to be moved to where we modify
those.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
