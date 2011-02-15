Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1FIpUTG221864 for <xfs@oss.sgi.com>; Tue, 15 Feb 2011 12:51:30 -0600
Subject: Re: [PATCH] xfs: check if device support discard in xfs_ioc_trim()
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1297789656-6088-1-git-send-email-lczerner@redhat.com>
References: <1297789656-6088-1-git-send-email-lczerner@redhat.com>
Date: Tue, 15 Feb 2011 12:54:06 -0600
Message-ID: <1297796046.2435.28.camel@doink>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: hch@infradead.org, xfs@oss.sgi.com

On Tue, 2011-02-15 at 18:07 +0100, Lukas Czerner wrote:
> Right now we, are relying on the fact that when we attempt to actually do
> the discard, blkdev_issue_discar() returns -EOPNOTSUPP and the user is
> informed that the device does not support discard.
> 
> However, in the case where the we do not hit any suitable free extent to
> trim in FITRIM code, it will finish without any error. This is very
> confusing, because it seems that FITRIM was successful even though the
> device does not actually supports discard.
> 
> Solution: Check for the discard support before attempt to search for
> free extents.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  fs/xfs/linux-2.6/xfs_discard.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_discard.c b/fs/xfs/linux-2.6/xfs_discard.c
> index 05201ae..d61611c 100644
> --- a/fs/xfs/linux-2.6/xfs_discard.c
> +++ b/fs/xfs/linux-2.6/xfs_discard.c
> @@ -152,6 +152,8 @@ xfs_ioc_trim(
>  
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -XFS_ERROR(EPERM);
> +	if (!blk_queue_discard(q))
> +		return -XFS_ERROR(EOPNOTSUPP);
>  	if (copy_from_user(&range, urange, sizeof(range)))
>  		return -XFS_ERROR(EFAULT);
>  

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
