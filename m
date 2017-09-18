Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32277 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750883AbdIRTGg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 15:06:36 -0400
Date: Mon, 18 Sep 2017 12:06:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: Output warning message when discard option was
 enabled even though the device does not support discard
Message-ID: <20170918190630.GP6540@magnolia>
References: <20170918135738.14642-1-nakayamakenjiro@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170918135738.14642-1-nakayamakenjiro@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Kenjiro Nakayama <nakayamakenjiro@gmail.com>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

On Mon, Sep 18, 2017 at 10:57:38PM +0900, Kenjiro Nakayama wrote:
> In order to using discard function, it is necessary that not only xfs
> is mounted with discard option, but also the discard function is
> supported by the device. Current code doesn't output any message when
> users mount with discard option on unsupported device, so it is
> difficult to notice that it was not enabled actually.
> 
> This patch adds the warning message to notice that discard option is
> not enabled due to unsupported device when the filesystem is mounted.
> 
> Changes in v2 (Suggested by Brian Foster):
>   - Move the unsupported device check into xfs_fs_fill_super().
>   - Clear the discard flag when device is unsupported.
> 
> Signed-off-by: Kenjiro Nakayama <nakayamakenjiro@gmail.com>

Looks ok, will test...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/xfs_super.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index c996f4ae4a5f..584cf2d573ba 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1654,6 +1654,16 @@ xfs_fs_fill_super(
>  		"DAX and reflink have not been tested together!");
>  	}
>  
> +	if (mp->m_flags & XFS_MOUNT_DISCARD) {
> +		struct request_queue *q = bdev_get_queue(sb->s_bdev);
> +
> +		if (!blk_queue_discard(q)) {
> +			xfs_warn(mp, "mounting with \"discard\" option, but "
> +					"the device does not support discard");
> +			mp->m_flags &= ~XFS_MOUNT_DISCARD;
> +		}
> +	}
> +
>  	if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
>  		if (mp->m_sb.sb_rblocks) {
>  			xfs_alert(mp,
> -- 
> 2.13.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
