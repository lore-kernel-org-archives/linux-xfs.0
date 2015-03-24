Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DB8DF7F54
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 16:11:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 741B9AC001
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 14:11:27 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id GfzpJFbwWjsCWwCE for <xfs@oss.sgi.com>;
	Tue, 24 Mar 2015 14:11:25 -0700 (PDT)
Message-ID: <5511D2FC.8080907@sandeen.net>
Date: Tue, 24 Mar 2015 16:11:24 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/5] xfs: clean up inode locking for RENAME_WHITEOUT
References: <1427194771-3105-1-git-send-email-david@fromorbit.com>
	<1427194771-3105-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1427194771-3105-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 3/24/15 5:59 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When doing RENAME_WHITEOUT, we now have to lock 5 inodes into the
> rename transaction. This means we need to update
> xfs_sort_for_rename() and xfs_lock_inodes() to handle up to 5
> inodes. Because of the vagaries of rename, this means we could have
> anywhere between 3 and 5 inodes locked into the transaction....
> 
> While xfs_lock_inodes() does not need anything other than an assert
> telling us we are passing more inodes that we ever thought we should
> see, it could do with a logic rework to remove all the indenting.
> This is not a functional change - it just makes the code a lot
> easier to read.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

...

> @@ -2681,19 +2668,22 @@ xfs_remove(
>  /*
>   * Enter all inodes for a rename transaction into a sorted array.
>   */
> +#define __XFS_SORT_INODES	5
>  STATIC void
>  xfs_sort_for_rename(
> -	xfs_inode_t	*dp1,	/* in: old (source) directory inode */
> -	xfs_inode_t	*dp2,	/* in: new (target) directory inode */
> -	xfs_inode_t	*ip1,	/* in: inode of old entry */
> -	xfs_inode_t	*ip2,	/* in: inode of new entry, if it
> -				   already exists, NULL otherwise. */
> -	xfs_inode_t	**i_tab,/* out: array of inode returned, sorted */
> -	int		*num_inodes)  /* out: number of inodes in array */
> +	struct xfs_inode	*dp1,	/* in: old (source) directory inode */
> +	struct xfs_inode	*dp2,	/* in: new (target) directory inode */
> +	struct xfs_inode	*ip1,	/* in: inode of old entry */
> +	struct xfs_inode	*ip2,	/* in: inode of new entry */
> +	struct xfs_inode	*wino,	/* in: whiteout inode */

I'm not 100% morally opposed, but you still have a wino lurking around here ;)

Patch5 uses *wip, so if you want consistency, might consider that.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
