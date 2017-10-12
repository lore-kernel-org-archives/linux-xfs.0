Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:15941 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751576AbdJLVfY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2017 17:35:24 -0400
Date: Fri, 13 Oct 2017 08:33:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: implement cgroup writeback support
Message-ID: <20171012213342.GU15067@dastard>
References: <1f2527ae0951650976e788e10e2951bb3e2c1cac.1507835570.git.shli@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f2527ae0951650976e788e10e2951bb3e2c1cac.1507835570.git.shli@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Shaohua Li <shli@kernel.org>
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com, Kernel-team@fb.com, Shaohua Li <shli@fb.com>, Tejun Heo <tj@kernel.org>

On Thu, Oct 12, 2017 at 12:16:48PM -0700, Shaohua Li wrote:
> From: Shaohua Li <shli@fb.com>
> 
> Basically this is a copy of commit 001e4a8775f6(ext4: implement cgroup
> writeback support). Tested with a fio test, verified writeback is
> throttled against cgroup io.max write bandwidth, also verified moving
> the fio test to another cgroup and the writeback is throttled against
> new cgroup setting.

So, I pushed back on this originally because there is no test
infrastructure for it. IOWs, we can't actually validate this code
works as intended. It appears you have some method of validating it
- please turn that into some fstests so the filesystem
developers know when we break it. Because we will break it, and if
there's regression tests in fstests we'll also notice when somebody
else breaks it, too.

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

A comment, please. I'm going to look at this in a couple of months
and not have a clue why this is here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
