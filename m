Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39090 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756750AbdIHSCQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 8 Sep 2017 14:02:16 -0400
Subject: Re: [PATCH v2 2/2] mkfs: pass a custom cowextsize into the created
 filesystem
References: <20170901164035.GF3775@magnolia> <20170904174535.GI4671@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <0da45d14-7c4a-9cb9-4c0c-6abc309c5001@sandeen.net>
Date: Fri, 8 Sep 2017 13:02:15 -0500
MIME-Version: 1.0
In-Reply-To: <20170904174535.GI4671@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On 9/4/17 12:45 PM, Darrick J. Wong wrote:
> Create a -d option to mkfs.xfs that enables administrators to set
> the CoW extent size hint on the created files.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: port flags2diflags from the kernel

hm, I wonder if we need a libxfs/util.c in the kernel for stuff like
this so libxfs diff will keep such things in sync in the future.

a project for another day I guess.  One question below.

> ---
>  libxfs/util.c       |   64 +++++++++++++++++++++++++++++++++++++++++++++++++--
>  man/man8/mkfs.xfs.8 |    7 ++++++
>  mkfs/xfs_mkfs.c     |   20 ++++++++++++++++
>  3 files changed, 89 insertions(+), 2 deletions(-)
> 
> diff --git a/libxfs/util.c b/libxfs/util.c
> index 0e2f29e..b600594 100644
> --- a/libxfs/util.c
> +++ b/libxfs/util.c
> @@ -175,6 +175,64 @@ libxfs_trans_ichgtime(
>  	}
>  }
>  
> +STATIC uint16_t
> +xfs_flags2diflags(
> +	struct xfs_inode	*ip,
> +	unsigned int		xflags)
> +{
> +	/* can't set PREALLOC this way, just preserve it */
> +	uint16_t		di_flags =
> +		(ip->i_d.di_flags & XFS_DIFLAG_PREALLOC);
> +
> +	if (xflags & FS_XFLAG_IMMUTABLE)
> +		di_flags |= XFS_DIFLAG_IMMUTABLE;
> +	if (xflags & FS_XFLAG_APPEND)
> +		di_flags |= XFS_DIFLAG_APPEND;
> +	if (xflags & FS_XFLAG_SYNC)
> +		di_flags |= XFS_DIFLAG_SYNC;
> +	if (xflags & FS_XFLAG_NOATIME)
> +		di_flags |= XFS_DIFLAG_NOATIME;
> +	if (xflags & FS_XFLAG_NODUMP)
> +		di_flags |= XFS_DIFLAG_NODUMP;
> +	if (xflags & FS_XFLAG_NODEFRAG)
> +		di_flags |= XFS_DIFLAG_NODEFRAG;
> +	if (xflags & FS_XFLAG_FILESTREAM)
> +		di_flags |= XFS_DIFLAG_FILESTREAM;
> +	if (S_ISDIR(VFS_I(ip)->i_mode)) {
> +		if (xflags & FS_XFLAG_RTINHERIT)
> +			di_flags |= XFS_DIFLAG_RTINHERIT;
> +		if (xflags & FS_XFLAG_NOSYMLINKS)
> +			di_flags |= XFS_DIFLAG_NOSYMLINKS;
> +		if (xflags & FS_XFLAG_EXTSZINHERIT)
> +			di_flags |= XFS_DIFLAG_EXTSZINHERIT;
> +		if (xflags & FS_XFLAG_PROJINHERIT)
> +			di_flags |= XFS_DIFLAG_PROJINHERIT;
> +	} else if (S_ISREG(VFS_I(ip)->i_mode)) {
> +		if (xflags & FS_XFLAG_REALTIME)
> +			di_flags |= XFS_DIFLAG_REALTIME;
> +		if (xflags & FS_XFLAG_EXTSIZE)
> +			di_flags |= XFS_DIFLAG_EXTSIZE;
> +	}
> +
> +	return di_flags;
> +}
> +
> +STATIC uint64_t
> +xfs_flags2diflags2(
> +	struct xfs_inode	*ip,
> +	unsigned int		xflags)
> +{
> +	uint64_t		di_flags2 =
> +		(ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK);
> +
> +	if (xflags & FS_XFLAG_DAX)
> +		di_flags2 |= XFS_DIFLAG2_DAX;
> +	if (xflags & FS_XFLAG_COWEXTSIZE)
> +		di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
> +
> +	return di_flags2;
> +}
> +
>  /*
>   * Allocate an inode on disk and return a copy of its in-core version.
>   * Set mode, nlink, and rdev appropriately within the inode.
> @@ -254,15 +312,17 @@ libxfs_ialloc(
>  	ip->i_d.di_extsize = pip ? 0 : fsx->fsx_extsize;
>  	ip->i_d.di_dmevmask = 0;
>  	ip->i_d.di_dmstate = 0;
> -	ip->i_d.di_flags = pip ? 0 : fsx->fsx_xflags;
> +	ip->i_d.di_flags = pip ? 0 : xfs_flags2diflags(ip, fsx->fsx_xflags);

is this a bugfix?

The rest seems ok, just wondering if the above should be hidden in here -
at least a mention of the change in the changelog seems needed, but most
likely thjis is a separate change, no?  Or am I missing something?

-Eric
