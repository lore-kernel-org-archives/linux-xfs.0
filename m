Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:47524 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725930AbfHAKkB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Aug 2019 06:40:01 -0400
Date: Thu, 1 Aug 2019 20:38:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: show error code when printing writeback error
 messages.
Message-ID: <20190801103851.GL7777@dread.disaster.area>
References: <1564653826-8916-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564653826-8916-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-xfs@vger.kernel.org

On Thu, Aug 01, 2019 at 07:03:46PM +0900, Tetsuo Handa wrote:
> Even without backtraces, including error code should be helpful.
> 
>   [  630.162595][ T9218] XFS (sda1): writeback error -12 on sector 131495992
>   [  631.718685][ T9432] XFS (sda1): writeback error -12 on sector 131503928
>   [  632.015588][  T442] XFS (sda1): writeback error -12 on sector 157773936
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  fs/xfs/xfs_aops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index f16d5f196c6b..d2c9076643cf 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -112,7 +112,7 @@ xfs_destroy_ioend(
>  
>  	if (unlikely(error && !quiet)) {
>  		xfs_err_ratelimited(XFS_I(inode)->i_mount,
> -			"writeback error on sector %llu", start);
> +			"writeback error %d on sector %llu", error, start);

If you are going to do this, make the error message properly useful.
Report the inode number and the ioend offset and length so we know
what file and where in the file the writeback failure occurred.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
