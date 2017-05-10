Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56158 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753899AbdEJSKf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 May 2017 14:10:35 -0400
Date: Wed, 10 May 2017 14:10:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: bmap shouldn't barf on inline-format directories
Message-ID: <20170510181032.GB10534@localhost.localdomain>
References: <20170510160329.GS5973@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170510160329.GS5973@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Wed, May 10, 2017 at 09:03:29AM -0700, Darrick J. Wong wrote:
> When we're fulfilling a BMAPX request, check that the fork is still in
> extents or btree format just prior to calling bmapi.  This prevents us
> from hitting a debugging check in bmapi_read and barfing errors back
> to userspace.  The on-disk extent count check later isn't sufficient for
> IF_DELALLOC mode because da extents are in memory and not on disk.
> 
> To reproduce, run "xfs_io -c 'bmap -e'" on any inline directory.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_bmap_util.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 7ac80a1..378f142 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -614,6 +614,11 @@ xfs_getbmap(
>  		return -EINVAL;
>  	bmvend = bmv->bmv_offset + bmv->bmv_length;
>  
> +	/* Local format inodes don't have any extents to report. */
> +	if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
> +		bmv->bmv_entries = 0;
> +		return 0;
> +	}

This means we'd return 0 extents for any inode where the data fork is in
local format, even if the bmap query is of the attr fork. For example,
consider something like an 'xfs_io -c "bmap -a" <dir>' where the attr
fork of the directory is extent format and the data fork is local
format.

Could we be more explicit about the check here? Actually, is there any
reason we couldn't pull this check up a bit earlier into the whichfork
switch statement?

Brian

>  
>  	if (bmv->bmv_count > ULONG_MAX / sizeof(struct getbmapx))
>  		return -ENOMEM;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
