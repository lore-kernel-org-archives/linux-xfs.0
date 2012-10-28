Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9SM9SQK069223 for <xfs@oss.sgi.com>; Sun, 28 Oct 2012 17:09:28 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	fiT6q92RZqqQ99Fj for <xfs@oss.sgi.com>;
	Sun, 28 Oct 2012 15:11:15 -0700 (PDT)
Date: Mon, 29 Oct 2012 09:10:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 2/3] xfs: Print error when xfs_ialloc_ag_select fails
	to find continuous free space.
Message-ID: <20121028221059.GC4353@dastard>
References: <cover.1348641483.git.rprabhu@wnohang.net>
	<9acdfb22ee7a1fbf777f866182d01009a3bea879.1348641483.git.rprabhu@wnohang.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <9acdfb22ee7a1fbf777f866182d01009a3bea879.1348641483.git.rprabhu@wnohang.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: raghu.prabhu13@gmail.com
Cc: bpm@sgi.com, elder@kernel.org, Raghavendra D Prabhu <rprabhu@wnohang.net>, xfs@oss.sgi.com

On Wed, Sep 26, 2012 at 12:26:48PM +0530, raghu.prabhu13@gmail.com wrote:
> From: Raghavendra D Prabhu <rprabhu@wnohang.net>
> 
> When xfs_ialloc_ag_select fails to find any AG with continuous free blocks
> required for inode allocation, printk the error in ratelimited manner.
> 
> Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
> ---
>  fs/xfs/xfs_ialloc.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
> index 5aceb3f..e75a39d 100644
> --- a/fs/xfs/xfs_ialloc.c
> +++ b/fs/xfs/xfs_ialloc.c
> @@ -539,8 +539,11 @@ nextag:
>  		if (agno >= agcount)
>  			agno = 0;
>  		if (agno == pagno) {
> -			if (flags == 0)
> +			if (flags == 0) {
> +				xfs_err_ratelimited(mp,
> +					"Out of continuous free blocks for inode allocation");
>  				return NULLAGNUMBER;
> +			}

>From here:

http://oss.sgi.com/archives/xfs/2012-09/msg00138.html

I quote:

| http://oss.sgi.com/archives/xfs/2012-06/msg00041.html
| 
| <quote>
| Couple of things for all 3 patches. Firstly - 80 columns. We tend
| to keep the pformat string on a single line so it is easy to grep
| for like so:
| 
|				pr_err_once(mp,
|                 "Insufficient contiguous free space for inode allocation");
| </quote>
| 
| So, you need to change the error message to the one suggested, and
| follow 80-character width limits like the rest of the code.
| 
| Also, I think the error message is better at the caller site, not in
| the function itself. i.e. if we get a NULLAGNUMBER returned, the
| caller decided whether to emit an error message or not."

So, the message here needs to change to what is suggested above, and
the location of the message needs to change i.e. to the caller, not
within the function itself.

Review comments need to be addressed before you repost patches....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
