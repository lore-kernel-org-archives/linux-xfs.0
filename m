Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45282 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932221AbdK0RpM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Nov 2017 12:45:12 -0500
Date: Mon, 27 Nov 2017 09:44:34 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: Don't trim file extents during iomap
Message-ID: <20171127174434.GB19379@magnolia>
References: <1511437203-4329-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1511437203-4329-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-xfs@vger.kernel.org, hch@infradead.org, sandeen@redhat.com

On Thu, Nov 23, 2017 at 01:40:03PM +0200, Nikolay Borisov wrote:
> For file extents xfs currently calls xfs_bmapi_read with flag set to 0,
> meaning extents are going to be truncated to the requested range. Since the
> same codepath is used for fiemap this means xfs is special in that regard, since
> other filesystems (ext4/btrfs) do not trim extents for fiemap. Make the behavior
> consistent by always passing XFS_BMAPI_ENTIRE. A full xfstest run validated that
> this doesn't regress on ordinary read/write IO.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Looks ok, will also test...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/xfs_iomap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index f179bdf1644d..8942324a4d3d 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1008,7 +1008,7 @@ xfs_file_iomap_begin(
>  	end_fsb = XFS_B_TO_FSB(mp, offset + length);
>  
>  	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
> -			       &nimaps, 0);
> +			       &nimaps, XFS_BMAPI_ENTIRE);
>  	if (error)
>  		goto out_unlock;
>  
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
