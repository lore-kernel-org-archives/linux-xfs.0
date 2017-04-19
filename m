Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:42040 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936125AbdDST6s (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 19 Apr 2017 15:58:48 -0400
Subject: Re: [PATCH 1/3] xfs: remove the unused XFS_MAXLINK_1 define
References: <20170419192904.22203-1-hch@lst.de>
 <20170419192904.22203-2-hch@lst.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <74f171c9-1f2a-f1f3-6473-95e284856349@sandeen.net>
Date: Wed, 19 Apr 2017 14:58:46 -0500
MIME-Version: 1.0
In-Reply-To: <20170419192904.22203-2-hch@lst.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On 4/19/17 2:29 PM, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Tricky! ;)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_format.h | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 6b7579e7b60a..d114ed80a076 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -930,10 +930,8 @@ static inline uint xfs_dinode_size(int version)
>  /*
>   * The 32 bit link count in the inode theoretically maxes out at UINT_MAX.
>   * Since the pathconf interface is signed, we use 2^31 - 1 instead.
> - * The old inode format had a 16 bit link count, so its maximum is USHRT_MAX.
>   */
>  #define	XFS_MAXLINK		((1U << 31) - 1U)
> -#define	XFS_MAXLINK_1		65535U
>  
>  /*
>   * Values for di_format
> 
