Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38658 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753824AbdEIPkc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 May 2017 11:40:32 -0400
Subject: Re: [PATCH] xfs: remove XFS_HSIZE
References: <20170509090018.30094-1-hch@lst.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ba048d82-a8b9-863f-121e-a1319fdef0f3@sandeen.net>
Date: Tue, 9 May 2017 10:40:31 -0500
MIME-Version: 1.0
In-Reply-To: <20170509090018.30094-1-hch@lst.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On 5/9/17 4:00 AM, Christoph Hellwig wrote:
> XFS_HSIZE is an extremly confusing way to calculate the size of handle_t.
> Given that handle_t always only had two sizes, and one of them isn't
> even covered by XFS_HSIZE to start with just remove the macro and use
> a constant sizeof expression.
> 
> Note that XFS_HSIZE isn't used in xfsprogs, xfsdump or xfstests either.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Ok, so with this assignment a few lines before:

handle.ha_fid.fid_len = sizeof(xfs_fid_t) - sizeof(handle.ha_fid.fid_len);

(so: fid_len == size of (fid_pad + fid_gen + fid_ino))

and:

(((char *) &(handle).ha_fid.fid_pad - (char *) &(handle)) + (handle).ha_fid.fid_len)
|< --        size of ha_u + sizeof fid_len         -->  |  |<-sizeof(pad+gen+ino)->|

this does indeed seem to come out to sizeof(xfs_handle_t).

Looks winning, minor comment below

> ---
>  fs/xfs/libxfs/xfs_fs.h | 4 ----
>  fs/xfs/xfs_ioctl.c     | 3 +--
>  2 files changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 095bdf049a3f..a9aa13e66046 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -446,10 +446,6 @@ typedef struct xfs_handle {
>  } xfs_handle_t;
>  #define ha_fsid ha_u._ha_fsid
>  
> -#define XFS_HSIZE(handle)	(((char *) &(handle).ha_fid.fid_pad	 \
> -				 - (char *) &(handle))			  \
> -				 + (handle).ha_fid.fid_len)
> -
>  /*
>   * Structure passed to XFS_IOC_SWAPEXT
>   */
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 6190697603c9..f6af76975bc8 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -120,8 +120,7 @@ xfs_find_handle(
>  		handle.ha_fid.fid_pad = 0;
>  		handle.ha_fid.fid_gen = inode->i_generation;
>  		handle.ha_fid.fid_ino = ip->i_ino;
> -
> -		hsize = XFS_HSIZE(handle);
> +		hsize = sizeof(xfs_handle_t);

at this point, no need to have the hsize assignment in if { } as well as else { }, right?

-Eric

>  	}
>  
>  	error = -EFAULT;
> 
