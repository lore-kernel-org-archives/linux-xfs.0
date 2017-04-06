Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49050 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753041AbdDFShC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Apr 2017 14:37:02 -0400
Subject: Re: [PATCH] xfs: actually report xattr extents via iomap
References: <20170406160356.GY4864@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ec62ec40-ce03-6e42-a28f-b0ed9716f0ad@sandeen.net>
Date: Thu, 6 Apr 2017 13:37:01 -0500
MIME-Version: 1.0
In-Reply-To: <20170406160356.GY4864@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Eryu Guan <eguan@redhat.com>

On 4/6/17 11:03 AM, Darrick J. Wong wrote:
> Apparently FIEMAP for xattrs has been broken since we switched to
> the iomap backend because of an incorrect check for xattr presence.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

nothing tests this?  eek.  Who wants to fix that? :)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/xfs_iomap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 288ee5b..4f118a1 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1173,7 +1173,7 @@ xfs_xattr_iomap_begin(
>  	lockmode = xfs_ilock_data_map_shared(ip);
>  
>  	/* if there are no attribute fork or extents, return ENOENT */
> -	if (XFS_IFORK_Q(ip) || !ip->i_d.di_anextents) {
> +	if (!XFS_IFORK_Q(ip) || !ip->i_d.di_anextents) {
>  		error = -ENOENT;
>  		goto out_unlock;
>  	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
