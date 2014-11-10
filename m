Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 264B17F75
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 12:13:10 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DDBEB304043
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 10:13:06 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id y4hyewSDlIEso5HW for <xfs@oss.sgi.com>;
	Mon, 10 Nov 2014 10:13:04 -0800 (PST)
Message-ID: <5461002E.8090506@sandeen.net>
Date: Mon, 10 Nov 2014 12:13:02 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] Add support to RENAME_EXCHANGE flag
References: <1415641272-29383-1-git-send-email-cmaiolino@redhat.com>
	<1415641272-29383-3-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1415641272-29383-3-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>, xfs@oss.sgi.com

On 11/10/14 11:41 AM, Carlos Maiolino wrote:
> Adds a new function named xfs_cross_rename(), responsible to handle requests
> from sys_renameat2() using RENAME_EXCHANGE flag.
> 
> Changelog:
> 
> 	V2: refactor xfs_cross_rename() to not duplicate code from xfs_rename()

Which tree is this against?

> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_inode.c | 315 +++++++++++++++++++++++++++++++++++------------------
>  fs/xfs/xfs_inode.h |   8 +-
>  fs/xfs/xfs_iops.c  |   4 +-
>  3 files changed, 220 insertions(+), 107 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index fea3c92..bf09bfc 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2674,12 +2674,14 @@ xfs_rename(
>  	xfs_inode_t	*src_ip,
>  	xfs_inode_t	*target_dp,
>  	struct xfs_name	*target_name,
> -	xfs_inode_t	*target_ip)
> +	xfs_inode_t	*target_ip,
> +	unsigned int	flags)
>  {
>  	xfs_trans_t	*tp = NULL;
>  	xfs_mount_t	*mp = src_dp->i_mount;
>  	int		new_parent;		/* moving to a new dir */
>  	int		src_is_directory;	/* src_name is a directory */
> +	int		tgt_is_directory;
>  	int		error;
>  	xfs_bmap_free_t free_list;
>  	xfs_fsblock_t   first_block;
> @@ -2752,141 +2754,158 @@ xfs_rename(
>  	}
>  
>  	/*
> -	 * Set up the target.
> -	 */
> -	if (target_ip == NULL) {
> +	 * Handle RENAME_EXCHANGE flags
> +	*/
> +	if (flags & RENAME_EXCHANGE) {
>  		/*
> -		 * If there's no space reservation, check the entry will
> -		 * fit before actually inserting it.
> +		 * target_ip will always exist if RENAME_EXCHANGE flag is set
>  		 */
> -		error = xfs_dir_canenter(tp, target_dp, target_name, spaceres);
> +		tgt_is_directory = S_ISDIR(target_ip->i_d.di_mode);
> +
> +		error = xfs_cross_rename(src_dp, src_name, src_ip, target_dp, target_name, target_ip,
> +					 new_parent, src_is_directory, tgt_is_directory,
> +					 &free_list, &first_block, tp, spaceres);

Ok, just some style drive-by comments, first -

EEK ;)  13 args and ~100 chars wide ;)

You could at least move some of those back to local vars in the
cross_rename function so you don't have to pass them on the stack.
It's also customary to pass the transaction pointer as the first arg,
i.e.:

+		error = xfs_cross_rename(tp, src_dp, src_name, src_ip,
+					 target_dp, target_name, target_ip,
+					 &free_list, &first_block, spaceres);

and:

xfs_cross_rename()
{
	...
	new_parent = (src_dp != target_dp);
	src_is_directory = S_ISDIR(src_ip->i_d.di_mode);
	tgt_is_directory = S_ISDIR(target_ip->i_d.di_mode);
	...

}

There are a few other places where you go well beyond 80 chars, would rather
not do that if at all possible.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
