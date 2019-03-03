Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:23382 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725938AbfCCXDx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Mar 2019 18:03:53 -0500
Date: Mon, 4 Mar 2019 10:03:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 8/8] xfs: support project in xfs_getattr()
Message-ID: <20190303230334.GT23020@dastard>
References: <1551449141-7884-1-git-send-email-wshilong1991@gmail.com>
 <1551449141-7884-9-git-send-email-wshilong1991@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1551449141-7884-9-git-send-email-wshilong1991@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, lixi@ddn.com, adilger@dilger.ca, Wang Shilong <wshilong@ddn.com>

On Fri, Mar 01, 2019 at 11:05:41PM +0900, Wang Shilong wrote:
> From: Wang Shilong <wshilong@ddn.com>
> 
> From: Wang Shilong <wshilong@ddn.com>
> 
> Signed-off-by: Wang Shilong <wshilong@ddn.com>
> ---
>  fs/xfs/xfs_iops.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index c10466fe6ed4..a2f8c0f048cf 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -501,6 +501,7 @@ xfs_vn_getattr(
>  	if (XFS_FORCED_SHUTDOWN(mp))
>  		return -EIO;
>  
> +	stat->projid = xfs_projid_to_kprojid(xfs_get_projid(ip));

Should only be set if the caller is in the init_user_ns.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
