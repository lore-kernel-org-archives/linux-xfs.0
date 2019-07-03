Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57560 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726621AbfGCNXt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Jul 2019 09:23:49 -0400
Date: Wed, 3 Jul 2019 09:23:46 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/9] xfs: introduce new v5 bulkstat structure
Message-ID: <20190703132346.GC26057@bfoster>
References: <156158193320.495715.6675123051075804739.stgit@magnolia>
 <156158195258.495715.3305107510637882010.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156158195258.495715.3305107510637882010.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, allison.henderson@oracle.com

On Wed, Jun 26, 2019 at 01:45:52PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Introduce a new version of the in-core bulkstat structure that supports
> our new v5 format features.  This structure also fills the gaps in the
> previous structure.  We leave wiring up the ioctls for the next patch.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_fs.h     |   48 ++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_health.h |    2 +
>  fs/xfs/xfs_health.c        |    2 +
>  fs/xfs/xfs_ioctl.c         |    9 ++++-
>  fs/xfs/xfs_ioctl.h         |    2 +
>  fs/xfs/xfs_ioctl32.c       |   10 ++++--
>  fs/xfs/xfs_itable.c        |   75 +++++++++++++++++++++++++++++++++-----------
>  fs/xfs/xfs_itable.h        |    4 ++
>  fs/xfs/xfs_ondisk.h        |    2 +
>  9 files changed, 124 insertions(+), 30 deletions(-)
> 
> 
...
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 45f0618efb8d..50c2bb8e13c4 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
...
> @@ -266,6 +266,43 @@ xfs_bulkstat(
>  	return error;
>  }
>  
> +/* Convert bulkstat (v5) to bstat (v1). */
> +void
> +xfs_bulkstat_to_bstat(
> +	struct xfs_mount		*mp,
> +	struct xfs_bstat		*bs1,
> +	const struct xfs_bulkstat	*bstat)
> +{
> +	bs1->bs_ino = bstat->bs_ino;
> +	bs1->bs_mode = bstat->bs_mode;
> +	bs1->bs_nlink = bstat->bs_nlink;
> +	bs1->bs_uid = bstat->bs_uid;
> +	bs1->bs_gid = bstat->bs_gid;
> +	bs1->bs_rdev = bstat->bs_rdev;
> +	bs1->bs_blksize = bstat->bs_blksize;
> +	bs1->bs_size = bstat->bs_size;
> +	bs1->bs_atime.tv_sec = bstat->bs_atime;
> +	bs1->bs_mtime.tv_sec = bstat->bs_mtime;
> +	bs1->bs_ctime.tv_sec = bstat->bs_ctime;
> +	bs1->bs_atime.tv_nsec = bstat->bs_atime_nsec;
> +	bs1->bs_mtime.tv_nsec = bstat->bs_mtime_nsec;
> +	bs1->bs_ctime.tv_nsec = bstat->bs_ctime_nsec;
> +	bs1->bs_blocks = bstat->bs_blocks;
> +	bs1->bs_xflags = bstat->bs_xflags;
> +	bs1->bs_extsize = bstat->bs_extsize_blks << mp->m_sb.sb_blocklog;
> +	bs1->bs_extents = bstat->bs_extents;
> +	bs1->bs_gen = bstat->bs_gen;
> +	bs1->bs_projid_lo = bstat->bs_projectid & 0xFFFF;
> +	bs1->bs_forkoff = bstat->bs_forkoff;
> +	bs1->bs_projid_hi = bstat->bs_projectid >> 16;
> +	bs1->bs_sick = bstat->bs_sick;
> +	bs1->bs_checked = bstat->bs_checked;
> +	bs1->bs_cowextsize = bstat->bs_cowextsize_blks << mp->m_sb.sb_blocklog;
> +	bs1->bs_dmevmask = 0;
> +	bs1->bs_dmstate = 0;

Any particular reason these fields are now stubbed out?
Deprecated/unused? It looks like we at least still have a mechanism to
set these values, but I have no idea if there are any users (or what
they're for for that matter :P).

Also, should we zero the padding space in bs1 here? It looks like the
callers allocate bs1 on the stack without any initialization, do the
conversion and immediately copy to userspace.

Brian

> +	bs1->bs_aextents = bstat->bs_aextents;
> +}
> +
>  struct xfs_inumbers_chunk {
>  	inumbers_fmt_pf		formatter;
>  	struct xfs_ibulk	*breq;
> diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
> index cfd3c93226f3..60e259192056 100644
> --- a/fs/xfs/xfs_itable.h
> +++ b/fs/xfs/xfs_itable.h
> @@ -38,10 +38,12 @@ xfs_ibulk_advance(
>   */
>  
>  typedef int (*bulkstat_one_fmt_pf)(struct xfs_ibulk *breq,
> -		const struct xfs_bstat *bstat);
> +		const struct xfs_bulkstat *bstat);
>  
>  int xfs_bulkstat_one(struct xfs_ibulk *breq, bulkstat_one_fmt_pf formatter);
>  int xfs_bulkstat(struct xfs_ibulk *breq, bulkstat_one_fmt_pf formatter);
> +void xfs_bulkstat_to_bstat(struct xfs_mount *mp, struct xfs_bstat *bs1,
> +		const struct xfs_bulkstat *bstat);
>  
>  typedef int (*inumbers_fmt_pf)(struct xfs_ibulk *breq,
>  		const struct xfs_inogrp *igrp);
> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> index c8ba98fae30a..0b4cdda68524 100644
> --- a/fs/xfs/xfs_ondisk.h
> +++ b/fs/xfs/xfs_ondisk.h
> @@ -146,6 +146,8 @@ xfs_check_ondisk_structs(void)
>  	XFS_CHECK_OFFSET(struct xfs_dir3_data_hdr, hdr.magic,	0);
>  	XFS_CHECK_OFFSET(struct xfs_dir3_free, hdr.hdr.magic,	0);
>  	XFS_CHECK_OFFSET(struct xfs_attr3_leafblock, hdr.info.hdr, 0);
> +
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat,		192);
>  }
>  
>  #endif /* __XFS_ONDISK_H */
> 
