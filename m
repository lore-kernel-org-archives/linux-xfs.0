Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44738 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750975AbcJHP4A (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 8 Oct 2016 11:56:00 -0400
Subject: Re: [PATCH 6/7] xfs: fix error initialization
References: <147588163396.12127.8356851783027062457.stgit@birch.djwong.org>
 <147588167673.12127.8923121358064293920.stgit@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <05debeab-15ec-2b6b-1704-e6d396242cfe@sandeen.net>
Date: Sat, 8 Oct 2016 10:55:58 -0500
MIME-Version: 1.0
In-Reply-To: <147588167673.12127.8923121358064293920.stgit@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, david@fromorbit.com
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>

On 10/7/16 6:07 PM, Darrick J. Wong wrote:
> Eric Sandeen reported a gcc complaint about uninitialized error
> variables, so fix that.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reported-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  fs/xfs/xfs_reflink.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 220d263..5965e94 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1437,7 +1437,7 @@ xfs_reflink_dirty_extents(
>  	xfs_off_t		flen;
>  	struct xfs_bmbt_irec	map[2];
>  	int			nmaps;
> -	int			error;
> +	int			error = 0;
>  
>  	while (end - fbno > 0) {

If we should never get here w/ end <= fbno, then maybe an ASSERT is
in order.

And if we ever do get here w/ that case, perhaps default error to a relevant
error so we don't return success and carry on in that case?

-Eric

>  		nmaps = 1;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
