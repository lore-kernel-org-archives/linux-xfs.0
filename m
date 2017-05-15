Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57374 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964908AbdEONfw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 15 May 2017 09:35:52 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6051F3D960
        for <linux-xfs@vger.kernel.org>; Mon, 15 May 2017 13:35:52 +0000 (UTC)
Date: Mon, 15 May 2017 09:35:50 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: bad assertion for delalloc an extent that start at
 i_size
Message-ID: <20170515133550.GC27809@bfoster.bfoster>
References: <1494843710-15350-1-git-send-email-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1494843710-15350-1-git-send-email-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, May 15, 2017 at 06:21:50PM +0800, Zorro Lang wrote:
> By run fsstress long enough time enough in RHEL-7, I find an
> assertion failure (harder to reproduce on linux-4.11, but problem
> is still there):
> 
>   XFS: Assertion failed: (iflags & BMV_IF_DELALLOC) != 0, file: fs/xfs/xfs_bmap_util.c
> 
> The assertion is in xfs_getbmap() funciton:
> 
>   if (map[i].br_startblock == DELAYSTARTBLOCK &&
> -->   map[i].br_startoff <= XFS_B_TO_FSB(mp, XFS_ISIZE(ip)))
>           ASSERT((iflags & BMV_IF_DELALLOC) != 0);
> 
> When map[i].br_startoff == XFS_B_TO_FSB(mp, XFS_ISIZE(ip)), the
> startoff is just at EOF. But we only need to make sure delalloc
> extents that are within EOF, not include EOF.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_bmap_util.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 8795e9c..a6d83ea 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -713,7 +713,7 @@ xfs_getbmap(
>  			 * extents.
>  			 */
>  			if (map[i].br_startblock == DELAYSTARTBLOCK &&
> -			    map[i].br_startoff <= XFS_B_TO_FSB(mp, XFS_ISIZE(ip)))
> +			    map[i].br_startoff < XFS_B_TO_FSB(mp, XFS_ISIZE(ip)))
>  				ASSERT((iflags & BMV_IF_DELALLOC) != 0);
>  
>                          if (map[i].br_startblock == HOLESTARTBLOCK &&
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
