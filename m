Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3D1InSp177975 for <xfs@oss.sgi.com>; Mon, 12 Apr 2010 20:18:49 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ABE7EFE474F
	for <xfs@oss.sgi.com>; Mon, 12 Apr 2010 18:20:42 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	3zH9swFoAjP48osq for <xfs@oss.sgi.com>;
	Mon, 12 Apr 2010 18:20:42 -0700 (PDT)
Date: Mon, 12 Apr 2010 16:56:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCHv2 8/10] xfs: avoid repeated pointer dereferences
Message-ID: <20100412065644.GJ2493@dastard>
References: <1270852242.7840.158.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1270852242.7840.158.camel@doink>
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

On Fri, Apr 09, 2010 at 05:30:42PM -0500, Alex Elder wrote:
> In xlog_find_cycle_start() use a local variable for some repeated
> operations rather than constantly updating the memory location
> whose address is passed in.

Won't the compiler optimise that out for us? i.e. does the dissassembly
of the function look any better before and after this change?

> Signed-off-by: Alex Elder <aelder@sgi.com>
> 
> ---
> fs/xfs/xfs_log_recover.c |   83 ++++++++++++++++++++++++-----------------------
>  fs/xfs/xfs_log_recover.c |   26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
> 
> Index: b/fs/xfs/xfs_log_recover.c
> ===================================================================
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -354,26 +354,28 @@ xlog_find_cycle_start(
>  {
>  	xfs_caddr_t	offset;
>  	xfs_daddr_t	mid_blk;
> +	xfs_daddr_t	end_blk;
>  	uint		mid_cycle;
>  	int		error;
>  
> -	mid_blk = BLK_AVG(first_blk, *last_blk);
> -	while (mid_blk != first_blk && mid_blk != *last_blk) {
> +	ASSERT(last_blk != NULL);
> +	end_blk = *last_blk;

FWIW, there is no need for that ASSERT there - the machine will
panic on the very next line, anyway....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
