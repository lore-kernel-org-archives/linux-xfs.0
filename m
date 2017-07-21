Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30440 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752780AbdGUQVj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2017 12:21:39 -0400
Date: Fri, 21 Jul 2017 09:21:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: quotacheck deadlock?
Message-ID: <20170721162130.GF23625@magnolia>
References: <20170720065804.GR4224@magnolia>
 <20170720123846.GC3944@bfoster.bfoster>
 <20170720185855.GT4224@magnolia>
 <20170720200129.GU4224@magnolia>
 <20170721142248.GC44069@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170721142248.GC44069@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>

On Fri, Jul 21, 2017 at 10:22:48AM -0400, Brian Foster wrote:
> On Thu, Jul 20, 2017 at 01:01:29PM -0700, Darrick J. Wong wrote:
> > On Thu, Jul 20, 2017 at 11:58:55AM -0700, Darrick J. Wong wrote:
> > > On Thu, Jul 20, 2017 at 08:38:46AM -0400, Brian Foster wrote:
> > > > On Wed, Jul 19, 2017 at 11:58:04PM -0700, Darrick J. Wong wrote:
> > > > > Hi,
> > > > > 
> > > > > I ran the following sequence of commands on 4.13-rc1:
> > > > > 
> > > > > # mkfs.xfs -f /dev/sdf
> > > > > # xfs_db -x -c 'sb 0' -c 'addr rootino' -c 'write -d core.uid 4294967295' /dev/sdf
> > > > > # mount /dev/sdf -o usrquota
> > > > > 
> > > > > The kernel reports that it's starting quotacheck, but never finishes.
> > > > > echo t > /proc/sysrq produces this for the hung mount command:
> > > > > 
> > > > > mount           R  running task        0   988    895 0x00000000
> > > > > Call Trace:
> > > > >  ? sched_clock_cpu+0xa8/0xe0
> > > > >  ? xfs_qm_flush_one+0x3c/0x120 [xfs]
> > > > >  ? lock_acquire+0xac/0x200
> > > > >  ? lock_acquire+0xac/0x200
> > > > >  ? xfs_qm_flush_one+0x3c/0x120 [xfs]
> > > > >  ? xfs_qm_dquot_walk+0xa1/0x170 [xfs]
> > > > >  ? get_lock_stats+0x19/0x60
> > > > >  ? get_lock_stats+0x19/0x60
> > > > >  ? xfs_qm_dquot_walk+0xa1/0x170 [xfs]
> > > > >  ? xfs_qm_dquot_walk+0x125/0x170 [xfs]
> > > > >  ? radix_tree_gang_lookup+0xd1/0xf0
> > > > >  ? xfs_qm_shrink_count+0x20/0x20 [xfs]
> > > > >  ? xfs_qm_dquot_walk+0xbb/0x170 [xfs]
> > > > >  ? kfree+0x23f/0x2d0
> > > > >  ? kvfree+0x2a/0x40
> > > > >  ? xfs_bulkstat+0x315/0x680 [xfs]
> > > > >  ? xfs_qm_get_rtblks+0xa0/0xa0 [xfs]
> > > > >  ? xfs_qm_quotacheck+0x2bd/0x360 [xfs]
> > > > >  ? xfs_qm_mount_quotas+0x106/0x1f0 [xfs]
> > > > >  ? xfs_mountfs+0x6f2/0xb00 [xfs]
> > > > >  ? xfs_fs_fill_super+0x483/0x610 [xfs]
> > > > >  ? mount_bdev+0x180/0x1b0
> > > > >  ? xfs_finish_flags+0x150/0x150 [xfs]
> > > > >  ? xfs_fs_mount+0x15/0x20 [xfs]
> > > > >  ? mount_fs+0x14/0x80
> > > > >  ? vfs_kern_mount+0x67/0x170
> > > > >  ? do_mount+0x195/0xd00
> > > > >  ? kmem_cache_alloc_trace+0x231/0x2a0
> > > > >  ? SyS_mount+0x95/0xe0
> > > > >  ? entry_SYSCALL_64_fastpath+0x1f/0xbe
> > > > > 
> > > > > Any thoughts?  I'm not sure what's going on for sure, other than the
> > > > > call stack looks funny and it's midnight so I'm going to sleep. :)
> > > > > 
> > > > 
> > > > It looks like a problem with the loop in xfs_qm_dquot_walk(). The next
> > > > lookup index is calculated as:
> > > > 
> > > > 	 next_index = be32_to_cpu(dqp->q_core.d_id) + 1;
> > > > 
> > > > ... each time through the loop. With the uid written above, the +1
> > > > overflows the 32-bit next_index back to zero and the lookup starts over.
> > > > I suppose a simple fix might be to do something like the following.
> > > > Thoughts?
> > > > 
> > > > --- 8< ---
> > > > 
> > > > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > > > index 6ce948c..f013c893 100644
> > > > --- a/fs/xfs/xfs_qm.c
> > > > +++ b/fs/xfs/xfs_qm.c
> > > > @@ -111,6 +111,8 @@ xfs_qm_dquot_walk(
> > > >  			skipped = 0;
> > > >  			break;
> > > >  		}
> > > > +		if (!next_index)
> > > > +			break;
> > > 
> > > Well, this /does/ fix the quotacheck lockup... but leads me straight
> > > into the next problem, which is that xfs_quota -x -c 'report -i' just
> > > goes into an infinite loop:
> > > 
> > > root                3          0          0     00 [--------]
> > > #4294967295           1          0          0     00 [--------]
> > > <repeats>
> > > 
> 
> That's a different codepath, right? Do we have a similar problem
> somewhere else..?

I think it's a bug in quota/report.c.

> > > That said, the userland APIs *chown/set*uid return -EINVAL if you pass
> > > in a userid of -1U, so one could argue that it's not a valid id anyway.
> > > Via stat(), the kernel squashes -1U down to 65534 (nobody), which
> > > implies that (Linux, anyway) doesn't consider -1U to be a valid id.
> > > ISTR XFS treats uids as a mostly opaque value that we get from and pass
> > > to the VFS without a whole lot of interpretation...?
> > 
> 
> That's my understanding. At least, I just looked at the size of the id
> and assumed anything therein was valid. I'd still probably want to fix
> the loop in quotacheck either way just to avoid leaving around a
> landmine.

Ok, want to package that up into a patch?

> > Poking around in include/linux/uidgid.h, it seems that uid_valid()
> > thinks that -1U is not a valid user id, so perhaps the inode verifier
> > should chck for that.  Ditto for gid_valid().
> > 
> 
> Seems reasonable, assuming that has always been the case.
> 
> > But then there's project id -- xfs_quota won't let us set a projid of
> > 4294967295, though I don't see anything in the kernel that prohibits
> > that.  chattr -p 4294967295 succeeds in setting the project id, which
> > means that we probably can't just ban it retroactively(??)
> > 
> > Thoughts?
> > 
> 
> Not sure.. any idea why the xfs_quota command fails if chattr does not?

xfs_quota explicitly disallows -1U, but chattr just treats it as an
arbitrary 32-bit value.  I'd like to amend _dinode_verify to look for
[ugp]id of -1U, but I'm having trouble figuring out if they're /really/
invalid, at least from the perspective of the disk format.

(Maybe Dave knows something? :))

--D

> 
> Brian
> 
> > --D
> > 
> > > 
> > > --D
> > > 
> > > >  	}
> > > >  
> > > >  	if (skipped) {
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
