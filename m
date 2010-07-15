Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6FI79LZ216375 for <xfs@oss.sgi.com>; Thu, 15 Jul 2010 13:07:09 -0500
Subject: Re: [PATCH 4/5] xfs: use GFP_NOFS for page cache allocation
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1279154300-2018-5-git-send-email-david@fromorbit.com>
References: <1279154300-2018-1-git-send-email-david@fromorbit.com>
	<1279154300-2018-5-git-send-email-david@fromorbit.com>
Date: Thu, 15 Jul 2010 13:10:05 -0500
Message-ID: <1279217405.2054.34.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, 2010-07-15 at 10:38 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Avoid a lockdep warning by preventing page cache allocation from
> recursing back into the filesystem during memory reclaim.

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/linux-2.6/xfs_aops.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
> index ed9c3db..1075791 100644
> --- a/fs/xfs/linux-2.6/xfs_aops.c
> +++ b/fs/xfs/linux-2.6/xfs_aops.c
> @@ -1501,8 +1501,9 @@ xfs_vm_write_begin(
>  	void			**fsdata)
>  {
>  	*pagep = NULL;
> -	return block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
> -								xfs_get_blocks);
> +	return block_write_begin(file, mapping, pos, len,
> +				 (flags | AOP_FLAG_NOFS),

                            Why the parentheses?

> +				 pagep, fsdata, xfs_get_blocks);
>  }
>  
>  STATIC sector_t



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
