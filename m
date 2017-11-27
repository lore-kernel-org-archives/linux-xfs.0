Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:47056 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752763AbdK0T0h (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Nov 2017 14:26:37 -0500
Subject: Re: [PATCH for 4.15] libxfs: fix dev_t handling in inode forks
References: <20171116011505.GH5119@magnolia>
 <20171117165706.GB17447@infradead.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <91f84193-e3c8-c4f7-ca93-5caea3a7bb03@sandeen.net>
Date: Mon, 27 Nov 2017 13:26:36 -0600
MIME-Version: 1.0
In-Reply-To: <20171117165706.GB17447@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>

On 11/17/17 10:57 AM, Christoph Hellwig wrote:
> Hmm.
> 
> I guess we should just clean up the calling conventions, and keep
> the conversion helpers in xfs_linux.h so that xfsprogs can turn them
> into noops.
> 
> Something like the untested patch for the kernel space, xfsprogs would
> then just stub out the two inlines to return the passed in value.
> 
> ---
> From e0ed26ab66774c1611e71a3c290efbe4e21d483c Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Fri, 17 Nov 2017 17:55:48 +0100
> Subject: xfs: abstract out dev_t conversions
> 
> And move them to xfs_linux.h so that xfsprogs can stub them out more
> easily.

Ok I'm a little confused by this, actually (sorry for the late reply).

I added an i_rdev to the "vfs inode" in xfsprogs... but if that's
really supposed to be a "linux inode" then we probably want to keep
the conversions to/from linux dev_t format when it's stored there,
even if it's never actually used as such.

So I'm not sure no-ops are the right answer.  That'd work, but it
seems odd to carry around the xfs device format in the "linux" inode
even in xfsprogs, from a "least surprise" POV.

So moving these to the header file is (was) fine, but I'll probably
keep the translation in xfsprogs.

Unless I'm missing something ...

-Eric


> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_inode_fork.c |  8 ++------
>  fs/xfs/xfs_linux.h             | 10 ++++++++++
>  2 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 1c90ec41e9df..c79a1616b79d 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -42,11 +42,6 @@ STATIC int xfs_iformat_local(xfs_inode_t *, xfs_dinode_t *, int, int);
>  STATIC int xfs_iformat_extents(xfs_inode_t *, xfs_dinode_t *, int);
>  STATIC int xfs_iformat_btree(xfs_inode_t *, xfs_dinode_t *, int);
>  
> -static inline dev_t xfs_to_linux_dev_t(xfs_dev_t dev)
> -{
> -	return MKDEV(sysv_major(dev) & 0x1ff, sysv_minor(dev));
> -}
> -
>  /*
>   * Copy inode type and data and attr format specific information from the
>   * on-disk inode to the in-core inode and fork structures.  For fifos, devices,
> @@ -792,7 +787,8 @@ xfs_iflush_fork(
>  	case XFS_DINODE_FMT_DEV:
>  		if (iip->ili_fields & XFS_ILOG_DEV) {
>  			ASSERT(whichfork == XFS_DATA_FORK);
> -			xfs_dinode_put_rdev(dip, sysv_encode_dev(VFS_I(ip)->i_rdev));
> +			xfs_dinode_put_rdev(dip,
> +					linux_to_xfs_dev_t(VFS_I(ip)->i_rdev));
>  		}
>  		break;
>  
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index 6282bfc1afa9..99562ec0de56 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -204,6 +204,16 @@ static inline kgid_t xfs_gid_to_kgid(uint32_t gid)
>  	return make_kgid(&init_user_ns, gid);
>  }
>  
> +static inline dev_t xfs_to_linux_dev_t(xfs_dev_t dev)
> +{
> +	return MKDEV(sysv_major(dev) & 0x1ff, sysv_minor(dev));
> +}
> +
> +static inline xfs_dev_t linux_to_xfs_dev_t(dev_t dev)
> +{
> +	return sysv_encode_dev(dev);
> +}
> +
>  /*
>   * Various platform dependent calls that don't fit anywhere else
>   */
> 
