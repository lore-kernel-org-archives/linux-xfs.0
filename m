Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38392 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754245AbdIFQoI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Sep 2017 12:44:08 -0400
Date: Wed, 6 Sep 2017 12:44:07 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 06/12] xfs: move inode fork verifiers to xfs_dinode_verify
Message-ID: <20170906164406.GF55280@bfoster.bfoster>
References: <150394418979.24826.12970283067445908653.stgit@magnolia>
 <150394422787.24826.14809466383851827337.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150394422787.24826.14809466383851827337.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Aug 28, 2017 at 11:17:07AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Consolidate the fork size and format verifiers to xfs_dinode_verify so
> that we can reject bad inodes earlier and in a single place.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c  |   68 ++++++++++++++++++++++++++-
>  fs/xfs/libxfs/xfs_inode_fork.c |   99 ----------------------------------------
>  2 files changed, 65 insertions(+), 102 deletions(-)
> 
> 
...
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 0e80f34..bba45f1 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -61,70 +61,11 @@ xfs_iformat_fork(
...
> -	if (unlikely(xfs_is_reflink_inode(ip) &&
> -	    (VFS_I(ip)->i_mode & S_IFMT) != S_IFREG)) {
> -		xfs_warn(ip->i_mount,
> -			"corrupt dinode %llu, wrong file type for reflink.",
> -			ip->i_ino);
> -		XFS_CORRUPTION_ERROR("xfs_iformat(reflink)",
> -				     XFS_ERRLEVEL_LOW, ip->i_mount, dip);
> -		return -EFSCORRUPTED;
> -	}
> -
> -	if (unlikely(xfs_is_reflink_inode(ip) &&
> -	    (ip->i_d.di_flags & XFS_DIFLAG_REALTIME))) {
> -		xfs_warn(ip->i_mount,
> -			"corrupt dinode %llu, has reflink+realtime flag set.",
> -			ip->i_ino);
> -		XFS_CORRUPTION_ERROR("xfs_iformat(reflink)",
> -				     XFS_ERRLEVEL_LOW, ip->i_mount, dip);
> -		return -EFSCORRUPTED;
> -	}

It looks like a couple of these reflink inode checks have disappeared.
Intentional?

...
> @@ -209,18 +122,6 @@ xfs_iformat_fork(
>  		atp = (xfs_attr_shortform_t *)XFS_DFORK_APTR(dip);
>  		size = be16_to_cpu(atp->hdr.totsize);
>  
> -		if (unlikely(size < sizeof(struct xfs_attr_sf_hdr))) {
> -			xfs_warn(ip->i_mount,
> -				"corrupt inode %Lu (bad attr fork size %Ld).",
> -				(unsigned long long) ip->i_ino,
> -				(long long) size);
> -			XFS_CORRUPTION_ERROR("xfs_iformat(8)",
> -					     XFS_ERRLEVEL_LOW,
> -					     ip->i_mount, dip);
> -			error = -EFSCORRUPTED;
> -			break;
> -		}
> -

Same question here..?

Brian

>  		error = xfs_iformat_local(ip, dip, XFS_ATTR_FORK, size);
>  		break;
>  	case XFS_DINODE_FMT_EXTENTS:
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
