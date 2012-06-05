Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q55E0Qnj090496 for <xfs@oss.sgi.com>; Tue, 5 Jun 2012 09:00:26 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Bb9iFWyma9BpIHvI for <xfs@oss.sgi.com>;
	Tue, 05 Jun 2012 07:00:24 -0700 (PDT)
Date: Wed, 6 Jun 2012 00:00:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] XFS: Print error when xfs_ialloc_ag_select fails to
	find continuous free space.
Message-ID: <20120605140021.GC22848@dastard>
References: <cover.1338721614.git.rprabhu@wnohang.net>
	<2dabcd19de5dafab66154800d4985dff58343dc0.1338721614.git.rprabhu@wnohang.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2dabcd19de5dafab66154800d4985dff58343dc0.1338721614.git.rprabhu@wnohang.net>
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
Cc: Raghavendra D Prabhu <rprabhu@wnohang.net>, xfs@oss.sgi.com

On Sun, Jun 03, 2012 at 04:42:47PM +0530, raghu.prabhu13@gmail.com wrote:
> From: Raghavendra D Prabhu <rprabhu@wnohang.net>
> 
> When xfs_ialloc_ag_select fails to find any AG with continuous free blocks for
> needed inode allocation, printk error about it once.
> 
> Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
> ---
>  fs/xfs/xfs_ialloc.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
> index 177a21a..a02180a 100644
> --- a/fs/xfs/xfs_ialloc.c
> +++ b/fs/xfs/xfs_ialloc.c
> @@ -543,8 +543,11 @@ nextag:
>  		if (agno >= agcount)
>  			agno = 0;
>  		if (agno == pagno) {
> -			if (flags == 0)
> +			if (flags == 0) {
> +				pr_err_once("XFS (%s): Out of continuous free blocks for inode allocation",
> +						mp->m_fsname);

Couple of things for all 3 patches. Firstly - 80 columns. We tend to keep the
pformat string on a single line so it is easy to grep for like so:

				pr_err_once(mp,
		"Insufficient contiguous free space for inode allocation");

Secondly, I'm not sure "print once and once only" is the right
behaviour here.  This will only warn on one filesystem and only
once for the uptime of the system. So if you hit this 5 minutes
after boot, then clean up, you'll never get it emitted again even
when the condition reappears 6 months later. hence I think this
should be a rate-limited print, not a print once.

And finally, you should add a xfs_err_ratelimited wrapper, not not
use pr_err_ratelimited() directly and open code the identifier
prefixes.

i.e. something like:

#define xfs_printk_ratelimited(func, mp, fmt, ...)		\
({								\
	static DEFINE_RATELIMIT_STATE(_rs,			\
				DEFAULT_RATELIMIT_INTERVAL,	\
				DEFAULT_RATELIMIT_BURST);	\
								\
	if (__ratelimit(&_rs))					\
		(func)((mp), fmt, ##__VA_ARGS__);		\
})

#define xfs_err_once(mp, fmt, ...)			\
		xfs_printk_ratelimited(xfs_err, (mp), fmt, ##__VA_ARGS__); 

So we can easily extend it to other logging levels as needed.


Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
