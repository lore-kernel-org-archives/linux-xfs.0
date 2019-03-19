Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:36976 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726857AbfCSPRy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Mar 2019 11:17:54 -0400
Date: Tue, 19 Mar 2019 08:17:47 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH V2] mkfs: Round down log device size if aligned value is
 larger than device size
Message-ID: <20190319151747.GR4929@magnolia>
References: <20190318155757.GM4929@magnolia>
 <20190319051027.27897-1-chandan@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190319051027.27897-1-chandan@linux.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chandan Rajendra <chandan@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net

On Tue, Mar 19, 2019 at 10:40:27AM +0530, Chandan Rajendra wrote:
> When using a disk of size 798903808 bytes as the log device and when
> having a log stripe unit size of 32768, align_log_size() rounds up log
> device size to 195048 4k blocks i.e. 798916608. This value is larger
> than the device size. Hence the last call to write(2) inside
> libxfs_device_zero() would end up returning an error.
> 
> To fix this bug, we now round down the log device size if the newly
> computed size is larger than the actual log device size.
> 
> Signed-off-by: Chandan Rajendra <chandan@linux.ibm.com>
> ---
> Changelog:
> v1 -> v2:
> 1. Remove extraneous parenthesis around conditions.
> 
>  mkfs/xfs_mkfs.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index d1387ddf..c9e22560 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2937,8 +2937,9 @@ _("log size %lld is not a multiple of the log stripe unit %d\n"),
>  	tmp_logblocks = ((cfg->logblocks + (sunit - 1)) / sunit) * sunit;
>  
>  	/* If the log is too large, round down instead of round up */
> -	if ((tmp_logblocks > XFS_MAX_LOG_BLOCKS) ||
> -	    ((tmp_logblocks << cfg->blocklog) > XFS_MAX_LOG_BYTES)) {
> +	if (tmp_logblocks > XFS_MAX_LOG_BLOCKS ||
> +	    tmp_logblocks > cfg->logblocks ||
> +	    (tmp_logblocks << cfg->blocklog) > XFS_MAX_LOG_BYTES) {
>  		tmp_logblocks = (cfg->logblocks / sunit) * sunit;

Looks better,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  	}
>  	cfg->logblocks = tmp_logblocks;
> -- 
> 2.19.1
> 
