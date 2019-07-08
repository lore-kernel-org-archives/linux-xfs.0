Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59768 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727373AbfGHM2K (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Jul 2019 08:28:10 -0400
Date: Mon, 8 Jul 2019 08:28:00 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: don't update lastino for FSBULKSTAT_SINGLE
Message-ID: <20190708122800.GC51396@bfoster>
References: <20190706212517.GH1654093@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190706212517.GH1654093@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, kernel test robot <rong.a.chen@intel.com>, lkp@01.org

On Sat, Jul 06, 2019 at 02:25:17PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The kernel test robot found a regression of xfs/054 in the conversion of
> bulkstat to use the new iwalk infrastructure -- if a caller set *lastip
> = 128 and invoked FSBULKSTAT_SINGLE, the bstat info would be for inode
> 128, but *lastip would be increased by the kernel to 129.
> 
> FSBULKSTAT_SINGLE never incremented lastip before, so it's incorrect to
> make such an update to the internal lastino value now.
> 
> Fixes: 2810bd6840e463 ("xfs: convert bulkstat to new iwalk infrastructure")
> Reported-by: kernel test robot <rong.a.chen@intel.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_ioctl.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 6bf04e71325b..1876461e5104 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -797,7 +797,6 @@ xfs_ioc_fsbulkstat(
>  		breq.startino = lastino;
>  		breq.icount = 1;
>  		error = xfs_bulkstat_one(&breq, xfs_fsbulkstat_one_fmt);
> -		lastino = breq.startino;
>  	} else {	/* XFS_IOC_FSBULKSTAT */
>  		breq.startino = lastino ? lastino + 1 : 0;
>  		error = xfs_bulkstat(&breq, xfs_fsbulkstat_one_fmt);
