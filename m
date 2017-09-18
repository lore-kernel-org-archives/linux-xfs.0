Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51068 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753001AbdIRMon (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Sep 2017 08:44:43 -0400
Date: Mon, 18 Sep 2017 08:44:42 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: Output warning message when discard option was
 enabled even though the device does not support discard
Message-ID: <20170918124440.GA29965@bfoster.bfoster>
References: <20170917073252.15432-1-nakayamakenjiro@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170917073252.15432-1-nakayamakenjiro@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kenjiro Nakayama <nakayamakenjiro@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Sun, Sep 17, 2017 at 04:32:52PM +0900, Kenjiro Nakayama wrote:
> In order to using discard function, it is necessary that not only xfs
> is mounted with discard option, but also the discard function is
> supported by the device. Current code doesn't output any message when
> users mount with discard option on unsupported device, so it is
> difficult to notice that it was not enabled actually.
> 
> This patch adds the warning message to notice that discard option is
> not enabled due to unsupported device when the filesystem is mounted.
> 
> Signed-off-by: Kenjiro Nakayama <nakayamakenjiro@gmail.com>
> ---
>  fs/xfs/xfs_super.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index c996f4ae4a5f..60397f9cc786 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -407,6 +407,13 @@ xfs_parseargs(
>  		return -EINVAL;
>  	}
>  #endif
> +	if (mp->m_flags & XFS_MOUNT_DISCARD) {
> +		struct request_queue *q = bdev_get_queue(sb->s_bdev);
> +
> +		if (!blk_queue_discard(q))
> +			xfs_warn(mp, "mounting with \"discard\" option, but "
> +					"the device does not support discard");
> +	}

Seems reasonable to me. Though perhaps we should move this into
xfs_fs_fill_super() (where we have a similar check for DAX support of
the underlying device) and also clear the discard flag so we don't
continue to queue discards that won't ever succeed.

Brian

>  
>  	if ((dsunit && !dswidth) || (!dsunit && dswidth)) {
>  		xfs_warn(mp, "sunit and swidth must be specified together");
> -- 
> 2.13.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
