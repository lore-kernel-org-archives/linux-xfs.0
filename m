Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17339 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751979AbdARUzW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2017 15:55:22 -0500
Date: Wed, 18 Jan 2017 12:55:12 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: fix xfs_mode_to_ftype() prototype
Message-ID: <20170118205512.GA12985@birch.djwong.org>
References: <20170118151353.1544332-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170118151353.1544332-1-arnd@arndb.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, Brian Foster <bfoster@redhat.com>, Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org

On Wed, Jan 18, 2017 at 04:12:58PM +0100, Arnd Bergmann wrote:
> A harmless warning just got introduced:
> 
> fs/xfs/libxfs/xfs_dir2.h:40:8: error: type qualifiers ignored on function return type [-Werror=ignored-qualifiers]
> 
> Removing the 'const' modifier avoids the warning and has no
> other effect.
> 
> Fixes: 1fc4d33fed12 ("xfs: replace xfs_mode_to_ftype table with switch statement")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied, thanks.

--D

> ---
>  fs/xfs/libxfs/xfs_dir2.c | 2 +-
>  fs/xfs/libxfs/xfs_dir2.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index eb64f3884d3d..2f389d366e93 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -38,7 +38,7 @@ struct xfs_name xfs_name_dotdot = { (unsigned char *)"..", 2, XFS_DIR3_FT_DIR };
>  /*
>   * Convert inode mode to directory entry filetype
>   */
> -const unsigned char xfs_mode_to_ftype(int mode)
> +unsigned char xfs_mode_to_ftype(int mode)
>  {
>  	switch (mode & S_IFMT) {
>  	case S_IFREG:
> diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
> index d4b77ab37a98..d6e6d9d16f6c 100644
> --- a/fs/xfs/libxfs/xfs_dir2.h
> +++ b/fs/xfs/libxfs/xfs_dir2.h
> @@ -37,7 +37,7 @@ extern struct xfs_name	xfs_name_dotdot;
>  /*
>   * Convert inode mode to directory entry filetype
>   */
> -extern const unsigned char xfs_mode_to_ftype(int mode);
> +extern unsigned char xfs_mode_to_ftype(int mode);
>  
>  /*
>   * directory operations vector for encode/decode routines
> -- 
> 2.9.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
