Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6ADCC29DFB
	for <xfs@oss.sgi.com>; Sun, 22 Sep 2013 19:25:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 55F438F8039
	for <xfs@oss.sgi.com>; Sun, 22 Sep 2013 17:25:45 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	GFsCNVMj3titi23z for <xfs@oss.sgi.com>;
	Sun, 22 Sep 2013 17:25:43 -0700 (PDT)
Date: Mon, 23 Sep 2013 10:24:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix the extent count when allocating an new
	indirection array entry
Message-ID: <20130923002448.GL12541@dastard>
References: <523DAF67.9070206@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <523DAF67.9070206@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sat, Sep 21, 2013 at 10:38:31PM +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> At xfs_iext_add(), if extent(s) are being appended to the last
> page in the indirection array and the new extent(s) don't fit
> in the page, the number of extents(erp->er_extcount) in a new
> allocated entry should be the minimum value between count and
> XFS_LINEAR_EXTS, instead of count.

Definitely looks like a bug, but what are the symptoms of it and how
did you find the problem? Is there any test case that demonstrates a
problem with the er_extcount being set incorrectly here?

> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  fs/xfs/xfs_inode_fork.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode_fork.c b/fs/xfs/xfs_inode_fork.c
> index 02f1083..dfb4226 100644
> --- a/fs/xfs/xfs_inode_fork.c
> +++ b/fs/xfs/xfs_inode_fork.c
> @@ -1035,11 +1035,11 @@ xfs_iext_add(
>  
>  			while (count) {
>  				erp = xfs_iext_irec_new(ifp, erp_idx);
> -				erp->er_extcount = count;
> -				count -= MIN(count, (int)XFS_LINEAR_EXTS);
> -				if (count) {
> +				erp->er_extcount = MIN(count,
> +						       (int)XFS_LINEAR_EXTS);
> +				count -= erp->er_extcount;

count is declared as an int, whereas XFS_LINEAR_EXTS probably ends
up with a type of uint because of a cast in the macro. because we
are decrementing to zero, the count can be declared as a uint, too,
and the cast in the MIN() can go away. Indeed, MIN() should be
converted to min() seeing as we are touching the code here, and if
you want to retain the current types, the min_t() is appropriate,
not min(x, (some cast)y)....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
