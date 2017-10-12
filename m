Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753209AbdJLUbN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Oct 2017 16:31:13 -0400
Date: Thu, 12 Oct 2017 12:49:13 -0700
From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] xfs: implement cgroup writeback support
Message-ID: <20171012194913.gtrxsqtji6o7ffr5@kernel.org>
References: <1f2527ae0951650976e788e10e2951bb3e2c1cac.1507835570.git.shli@fb.com>
 <20171012201618.GI7122@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171012201618.GI7122@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Kernel-team@fb.com, Shaohua Li <shli@fb.com>, Tejun Heo <tj@kernel.org>

On Thu, Oct 12, 2017 at 01:16:18PM -0700, Darrick J. Wong wrote:
> On Thu, Oct 12, 2017 at 12:16:48PM -0700, Shaohua Li wrote:
> > From: Shaohua Li <shli@fb.com>
> > 
> > Basically this is a copy of commit 001e4a8775f6(ext4: implement cgroup
> > writeback support). Tested with a fio test, verified writeback is
> > throttled against cgroup io.max write bandwidth, also verified moving
> > the fio test to another cgroup and the writeback is throttled against
> > new cgroup setting.
> 
> Just out of curiosity, is there an xfstests that covers this?

No as far as I know
 
> It /looks/ ok at a first glance, but I'll have to take a closer look to
> figure out if the warnings in Documentation/ apply:
> 
> "Depending on the configuration, the bio may be executed at a lower
> priority and if the writeback session is holding shared resources, e.g.
> a journal entry, may lead to priority inversion."

The writepages code path is for file data, which I think should not cause
priority inversion because there is dependence between writeback to different
files. For metadata write, the priority inversion could happen. This happens to
other filesystems too, like ext4 and btrfs. Tejun submitted patches recently to
force metadata write from root cgroup, which could fix the issue. We might need
to do similar thing for xfs later.

Thanks,
Shaohua
> > Cc: Tejun Heo <tj@kernel.org>
> > Signed-off-by: Shaohua Li <shli@fb.com>
> > ---
> >  fs/xfs/xfs_aops.c  | 2 ++
> >  fs/xfs/xfs_super.c | 1 +
> >  2 files changed, 3 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index f18e593..6535054 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -630,8 +630,10 @@ xfs_add_to_ioend(
> >  		if (wpc->ioend)
> >  			list_add(&wpc->ioend->io_list, iolist);
> >  		wpc->ioend = xfs_alloc_ioend(inode, wpc->io_type, offset, bh);
> > +		wbc_init_bio(wbc, wpc->ioend->io_bio);
> >  	}
> >  
> > +	wbc_account_io(wbc, bh->b_page, bh->b_size);
> >  	/*
> >  	 * If the buffer doesn't fit into the bio we need to allocate a new
> >  	 * one.  This shouldn't happen more than once for a given buffer.
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 584cf2d..aea3bc2 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1634,6 +1634,7 @@ xfs_fs_fill_super(
> >  	sb->s_max_links = XFS_MAXLINK;
> >  	sb->s_time_gran = 1;
> >  	set_posix_acl_flag(sb);
> > +	sb->s_iflags |= SB_I_CGROUPWB;
> >  
> >  	/* version 5 superblocks support inode version counters. */
> >  	if (XFS_SB_VERSION_NUM(&mp->m_sb) == XFS_SB_VERSION_5)
> > -- 
> > 2.9.5
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
