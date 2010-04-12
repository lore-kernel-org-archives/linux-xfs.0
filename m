Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3D1IlKL177960 for <xfs@oss.sgi.com>; Mon, 12 Apr 2010 20:18:48 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 597EC1269E23
	for <xfs@oss.sgi.com>; Mon, 12 Apr 2010 18:20:41 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	iQHxuGo9CSBuBXj3 for <xfs@oss.sgi.com>;
	Mon, 12 Apr 2010 18:20:41 -0700 (PDT)
Date: Mon, 12 Apr 2010 16:32:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/10] xfs: fix min bufsize bugs in two places
Message-ID: <20100412063248.GG2493@dastard>
References: <1270852013.7840.132.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1270852013.7840.132.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Apr 09, 2010 at 05:26:53PM -0500, Alex Elder wrote:
> This fixes a bug in two places that I found by inspection.  In
> xlog_find_verify_cycle() and xlog_write_log_records(), the code
> attempts to allocate a buffer to hold as many blocks as possible.
> It gives up if the number of blocks to be allocated gets too small.
> Right now it uses log->l_sectbb_log as that lower bound, but I'm
> sure it's supposed to be the actual log sector size instead.  That
> is, the lower bound should be (1 << log->l_sectbb_log).
> 
> Also define a simple macro xlog_sectbb(log) to represent the number
> of basic blocks in a sector for the given log.
> 
> (No change from original submission; I have implemented Christoph's
> suggestion about storing l_sectsize rather than l_sectbb_log in
> a new, separate patch in this series.)
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>
> 
> ---
> fs/xfs/xfs_log_recover.c |   21 +++++++++++++++++----
>  fs/xfs/xfs_log_recover.c |   21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
> 
> Index: b/fs/xfs/xfs_log_recover.c
> ===================================================================
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -66,6 +66,9 @@ STATIC void	xlog_recover_check_summary(x
>  	((bbs + (log)->l_sectbb_mask + 1) & ~(log)->l_sectbb_mask) : (bbs) )
>  #define XLOG_SECTOR_ROUNDDOWN_BLKNO(log, bno)	((bno) & ~(log)->l_sectbb_mask)
>  
> +/* Number of basic blocks in a log sector */
> +#define xlog_sectbb(log) (1 << (log)->l_sectbb_log)
> +

Can you do this without the #define? There's a spot in
xlog_alloc_log() where the l_sectbb_mask is set up that
open code this shift, so it seems to me that this woul dbe the spot
to set up a l_sect_size variable and reference that instead...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
