Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37468 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750720AbdAXCg2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Jan 2017 21:36:28 -0500
Subject: Re: [PATCH] xfs: verify dirblocklog correctly
References: <20170124004655.GG31202@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <14bc9e53-b834-22da-fcd0-0f732c3cfdd3@sandeen.net>
Date: Mon, 23 Jan 2017 20:36:24 -0600
MIME-Version: 1.0
In-Reply-To: <20170124004655.GG31202@birch.djwong.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>



On 1/23/17 6:46 PM, Darrick J. Wong wrote:
> sb_dirblklog is added to sb_blocklog to compute the directory block size
> in bytes.  Therefore, we must compare the sum of both those values
> against XFS_MAX_BLOCKSIZE_LOG, not just dirblklog.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

matches the assert in xfs_da_mount():

        ASSERT((1 << (mp->m_sb.sb_blocklog + mp->m_sb.sb_dirblklog)) <=
               XFS_MAX_BLOCKSIZE);

so yup.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_sb.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 2580262..584ec89 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -242,7 +242,7 @@ xfs_mount_validate_sb(
>  	    sbp->sb_blocklog < XFS_MIN_BLOCKSIZE_LOG			||
>  	    sbp->sb_blocklog > XFS_MAX_BLOCKSIZE_LOG			||
>  	    sbp->sb_blocksize != (1 << sbp->sb_blocklog)		||
> -	    sbp->sb_dirblklog > XFS_MAX_BLOCKSIZE_LOG			||
> +	    sbp->sb_dirblklog + sbp->sb_blocklog > XFS_MAX_BLOCKSIZE_LOG ||
>  	    sbp->sb_inodesize < XFS_DINODE_MIN_SIZE			||
>  	    sbp->sb_inodesize > XFS_DINODE_MAX_SIZE			||
>  	    sbp->sb_inodelog < XFS_DINODE_MIN_LOG			||
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
