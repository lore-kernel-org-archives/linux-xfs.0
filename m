Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 377E97F63
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 20:06:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 16F6C8F8064
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 18:06:31 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	2wCA5Z5aQ9WzuzuV for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 18:06:29 -0700 (PDT)
Date: Fri, 7 Jun 2013 11:06:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/1] xfs: fix the symbolic link assert in xfs_ifree
Message-ID: <20130607010615.GH29338@dastard>
References: <20130606161032.753011157@sgi.com>
	<20130606161027.166439519@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130606161027.166439519@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Jun 06, 2013 at 11:10:33AM -0500, Mark Tinguely wrote:
> Adding an extended attribute to a symbolic link can force that
> link to an remote extent. xfs_inactive() incorrectly assumes
> that any symbolic link small enough to be in the inode core
> is incore, the remote extent is not cleaned and xfs_ifree()
> asserts on presence the remote extent.
> 
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
> ---
>  fs/xfs/xfs_vnodeops.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/fs/xfs/xfs_vnodeops.c
> ===================================================================
> --- a/fs/xfs/xfs_vnodeops.c
> +++ b/fs/xfs/xfs_vnodeops.c
> @@ -325,7 +325,7 @@ xfs_inactive(
>  		/*
>  		 * Zero length symlinks _can_ exist.
>  		 */
> -		if (ip->i_d.di_size > XFS_IFORK_DSIZE(ip)) {
> +		if (ip->i_d.di_nextents) {
>  			error = xfs_inactive_symlink_rmt(ip, &tp);
>  			if (error)
>  				goto out_cancel;

This should match the check done in xfs_readlink. i.e. it should
check against the fork format being in local or extent form, not
check against the inode size.

Also, I think that this symlink specific code should be factored out
of xfs_inactive() and moved to fs/xfs/xfs_symlink.c as
xfs_symlink_truncate() so that all the intricacies of the symlink
truncation are in the one place. This would make
xfs_symlink_truncate() look very similar to xfs_readlink()...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
