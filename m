Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 33AA67F53
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 19:45:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 104828F8049
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 17:45:43 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	gEpuM6nacm8qL7rN for <xfs@oss.sgi.com>;
	Sun, 11 Oct 2015 17:45:41 -0700 (PDT)
Date: Mon, 12 Oct 2015 11:45:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: Fix error path in xfs_get_acl
Message-ID: <20151012004539.GA31326@dastard>
References: <1444569791-26719-1-git-send-email-agruenba@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1444569791-26719-1-git-send-email-agruenba@redhat.com>
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
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: xfs@oss.sgi.com

On Sun, Oct 11, 2015 at 03:23:11PM +0200, Andreas Gruenbacher wrote:
> Error codes from xfs_attr_get other than -ENOATTR were not properly 
> reported.  Fix that, and clean the code up somewhat.

Test case for xfstests?

> In addition, the declaration of struct xfs_inode in xfs_acl.h isn't needed.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
>  fs/xfs/xfs_acl.c | 19 +++++++------------
>  fs/xfs/xfs_acl.h |  1 -
>  2 files changed, 7 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
> index 4b64167..0f4ee92 100644
> --- a/fs/xfs/xfs_acl.c
> +++ b/fs/xfs/xfs_acl.c
> @@ -122,7 +122,7 @@ struct posix_acl *
>  xfs_get_acl(struct inode *inode, int type)
>  {
>  	struct xfs_inode *ip = XFS_I(inode);
> -	struct posix_acl *acl = NULL;
> +	struct posix_acl *acl;
>  	struct xfs_acl *xfs_acl;
>  	unsigned char *ea_name;
>  	int error;
> @@ -158,18 +158,13 @@ xfs_get_acl(struct inode *inode, int type)
>  		 * cache entry, for any other error assume it is transient and
>  		 * leave the cache entry as ACL_NOT_CACHED.
>  		 */
> -		if (error == -ENOATTR)
> -			goto out_update_cache;
> -		goto out;
> -	}
> +		acl = (error == -ENOATTR) ? NULL : ERR_PTR(error);

AFAICT, this single line here is the bugfix, right?

So the entire patch could simply be replaced by:

 		if (error == -ENOATTR)
 			goto out_update_cache;
+		acl = ERR_PTR(error);
 		goto out;
 	}

Or have I missed the missed the fix in all the code rearranging you
did?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
