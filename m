Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 84E7E7F37
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 18:30:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 107D1AC002
	for <xfs@oss.sgi.com>; Mon, 18 Mar 2013 16:30:34 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	5yCRay7X9pbXaPgq for <xfs@oss.sgi.com>;
	Mon, 18 Mar 2013 16:30:32 -0700 (PDT)
Date: Tue, 19 Mar 2013 10:30:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: fix assertion failure in xfs_vm_write_failed()
Message-ID: <20130318233026.GS6369@dastard>
References: <51469C90.1000001@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51469C90.1000001@oracle.com>
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
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Mar 18, 2013 at 12:48:16PM +0800, Jeff Liu wrote:
> Hello,
> 
> Here is the v2 patch for fixing ASSERTION failed at xfs_vm_write_failed() according
> to Dave's comments, so I added Dave as SOB for credit.

No, please don't add my SOB to a patch you wrote, even if I came up
with the idea of how to do something. A SOB indicates that someone
has verified the origin of the patch (e.g. for copyright reasons),
not who contributed to finding the problem.  IOWs, adding someone
else's SOB to a patch you wrote is almost always the wrong thing to
do.

The correct way to acknowledge someone's contribution to the
fix if they didn't write the patch is by a line in the commit
message saying something like "Thanks to .... for helping find and
fix the problem." [Edit: I just noticed you did this bit. ;) ]

If .... agrees with your fix, then they can add a reviewed-by line
to the patch, which has significantly different meaning to a SOB...

....

> Reported-by: Michael L. Semon <mlsemon35@gmail.com>
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> ---
>  fs/xfs/xfs_aops.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 5f707e5..a418e17 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -1494,7 +1494,8 @@ xfs_vm_write_failed(
>  	loff_t			pos,
>  	unsigned		len)
>  {
> -	loff_t			block_offset = pos & PAGE_MASK;
> +	loff_t			block_offset = (pos >> PAGE_CACHE_SHIFT) <<
> +						PAGE_CACHE_SHIFT;
>  	loff_t			block_start;
>  	loff_t			block_end;
>  	loff_t			from = pos & (PAGE_CACHE_SIZE - 1);

This needs a comment explaining why we aren't just masking the value
off with PAGE_MASK. And given that it wraps, something like:

-	loff_t			block_offset = pos & PAGE_MASK;
+	loff_t			block_offset;
.....

+	/*
+	 * comment about 32 bit systems, 64 bit variables and masks
+	 */
+	block_offset = (pos >> PAGE_CACHE_SHIFT) << PAGE_CACHE_SHIFT;

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
