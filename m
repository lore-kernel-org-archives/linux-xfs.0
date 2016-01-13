Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1EA217F37
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 07:22:30 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BBD9EAC001
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 05:22:29 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9zCjPWRXBhthxfbS (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Jan 2016 05:22:28 -0800 (PST)
Date: Wed, 13 Jan 2016 08:22:26 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] Revert "xfs: clear PF_NOFREEZE for xfsaild kthread"
Message-ID: <20160113132226.GA37138@bfoster.bfoster>
References: <1452661968-11482-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1452661968-11482-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: jkosina@suse.cz, xfs@oss.sgi.com

On Wed, Jan 13, 2016 at 04:12:48PM +1100, Dave Chinner wrote:
> This reverts commit 24ba16bb3d499c49974669cd8429c3e4138ab102 as it
> prevents machines from suspending. This regression occurs when the
> xfsaild is idle on entry to suspend, and so there s no activity to
> wake it from it's idle sleep and hence see that it is supposed to
> freeze. Hence the freezer times out waiting for it and suspend is
> cancelled.
> 
> There is no obvious fix for this short of freezing the filesystem
> properly, so revert this change for now.
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_trans_ail.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> index aa67339..4f18fd9 100644
> --- a/fs/xfs/xfs_trans_ail.c
> +++ b/fs/xfs/xfs_trans_ail.c
> @@ -497,7 +497,6 @@ xfsaild(
>  	long		tout = 0;	/* milliseconds */
>  
>  	current->flags |= PF_MEMALLOC;
> -	set_freezable();
>  
>  	while (!kthread_should_stop()) {
>  		if (tout && tout <= 20)
> -- 
> 2.5.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
