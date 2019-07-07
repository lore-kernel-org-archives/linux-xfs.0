Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:51050 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726968AbfGGAUJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Jul 2019 20:20:09 -0400
Subject: Re: [PATCH] xfs: don't update lastino for FSBULKSTAT_SINGLE
References: <20190706212517.GH1654093@magnolia>
From: Allison Collins <allison.henderson@oracle.com>
Message-ID: <bdbee426-9b4e-4179-a207-c84318e5192e@oracle.com>
Date: Sat, 6 Jul 2019 17:19:48 -0700
MIME-Version: 1.0
In-Reply-To: <20190706212517.GH1654093@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, kernel test robot <rong.a.chen@intel.com>
Cc: Brian Foster <bfoster@redhat.com>, lkp@01.org

On 7/6/19 2:25 PM, Darrick J. Wong wrote:
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

Looks ok to me.  Thanks!
Reviewed-by: Allison Collins <allison.henderson@oracle.com>

> Fixes: 2810bd6840e463 ("xfs: convert bulkstat to new iwalk infrastructure")
> Reported-by: kernel test robot <rong.a.chen@intel.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   fs/xfs/xfs_ioctl.c |    1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 6bf04e71325b..1876461e5104 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -797,7 +797,6 @@ xfs_ioc_fsbulkstat(
>   		breq.startino = lastino;
>   		breq.icount = 1;
>   		error = xfs_bulkstat_one(&breq, xfs_fsbulkstat_one_fmt);
> -		lastino = breq.startino;
>   	} else {	/* XFS_IOC_FSBULKSTAT */
>   		breq.startino = lastino ? lastino + 1 : 0;
>   		error = xfs_bulkstat(&breq, xfs_fsbulkstat_one_fmt);
> 
