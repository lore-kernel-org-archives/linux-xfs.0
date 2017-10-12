Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27285 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755688AbdJLUQZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2017 16:16:25 -0400
Date: Thu, 12 Oct 2017 13:16:18 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: implement cgroup writeback support
Message-ID: <20171012201618.GI7122@magnolia>
References: <1f2527ae0951650976e788e10e2951bb3e2c1cac.1507835570.git.shli@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f2527ae0951650976e788e10e2951bb3e2c1cac.1507835570.git.shli@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Shaohua Li <shli@kernel.org>
Cc: linux-xfs@vger.kernel.org, Kernel-team@fb.com, Shaohua Li <shli@fb.com>, Tejun Heo <tj@kernel.org>

On Thu, Oct 12, 2017 at 12:16:48PM -0700, Shaohua Li wrote:
> From: Shaohua Li <shli@fb.com>
> 
> Basically this is a copy of commit 001e4a8775f6(ext4: implement cgroup
> writeback support). Tested with a fio test, verified writeback is
> throttled against cgroup io.max write bandwidth, also verified moving
> the fio test to another cgroup and the writeback is throttled against
> new cgroup setting.

Just out of curiosity, is there an xfstests that covers this?

It /looks/ ok at a first glance, but I'll have to take a closer look to
figure out if the warnings in Documentation/ apply:

"Depending on the configuration, the bio may be executed at a lower
priority and if the writeback session is holding shared resources, e.g.
a journal entry, may lead to priority inversion."

--D

> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>  fs/xfs/xfs_aops.c  | 2 ++
>  fs/xfs/xfs_super.c | 1 +
>  2 files changed, 3 insertions(+)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index f18e593..6535054 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -630,8 +630,10 @@ xfs_add_to_ioend(
>  		if (wpc->ioend)
>  			list_add(&wpc->ioend->io_list, iolist);
>  		wpc->ioend = xfs_alloc_ioend(inode, wpc->io_type, offset, bh);
> +		wbc_init_bio(wbc, wpc->ioend->io_bio);
>  	}
>  
> +	wbc_account_io(wbc, bh->b_page, bh->b_size);
>  	/*
>  	 * If the buffer doesn't fit into the bio we need to allocate a new
>  	 * one.  This shouldn't happen more than once for a given buffer.
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 584cf2d..aea3bc2 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1634,6 +1634,7 @@ xfs_fs_fill_super(
>  	sb->s_max_links = XFS_MAXLINK;
>  	sb->s_time_gran = 1;
>  	set_posix_acl_flag(sb);
> +	sb->s_iflags |= SB_I_CGROUPWB;
>  
>  	/* version 5 superblocks support inode version counters. */
>  	if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
> -- 
> 2.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
