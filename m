Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58936 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755614AbdCGOdE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 7 Mar 2017 09:33:04 -0500
Date: Tue, 7 Mar 2017 09:32:36 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: XFS kernel BUG during generic/270 with v4.10
Message-ID: <20170307143236.GA8144@bfoster.bfoster>
References: <20170222191300.GA29474@linux.intel.com>
 <20170302162934.GM3213@bfoster.bfoster>
 <20170306184109.GA19127@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170306184109.GA19127@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Mon, Mar 06, 2017 at 11:41:09AM -0700, Ross Zwisler wrote:
> On Thu, Mar 02, 2017 at 11:29:34AM -0500, Brian Foster wrote:
> > On Wed, Feb 22, 2017 at 12:13:00PM -0700, Ross Zwisler wrote:
> > > By running generic/270 in a loop on an XFS filesystem mounted with DAX I'm
> > > able to reliably generate the following kernel bug after a few (~10)
> > > iterations (output passed through kasan_symbolize.py):
> > > 
> > > run fstests generic/270 at 2017-02-22 12:01:05
> > > XFS (pmem0p2): Unmounting Filesystem
> > > XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
> > > XFS (pmem0p2): Mounting V5 Filesystem
> > > XFS (pmem0p2): Ending clean mount
> > > XFS (pmem0p2): Quotacheck needed: Please wait.
> > > XFS (pmem0p2): Quotacheck: Done.
> > > XFS (pmem0p2): xlog_verify_grant_tail: space > BBTOB(tail_blocks)
> > > XFS: Assertion failed: XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0, file: fs/xfs/xfs_super.c, line: 965
> > 
> > This means we've reclaimed an inode that still has delayed allocation
> > blocks, which shouldn't occur. We do have one recent fix in this area:
> > fa7f138 ("xfs: clear delalloc and cache on buffered write failure"). Do
> > you still reproduce this? If so, does it reproduce with that patch?
> 
> Cool, I've done a bunch more testing and have some interesting info.
> 
> First, this issue isn't specific to DAX.  If I turn DAX off, it actually
> reproduces much faster, usually on the first test run.
> 
> The branch I could find in the xfs repo that contained commit
> 
> fa7f138 ("xfs: clear delalloc and cache on buffered write failure")
> 
> Was based on v4.10-rc6.  Interestingly, this baseline does not reproduce this
> issue, whereas v4.10 release reproduces it very consistently.  The commit
> between v4.10-rc6 and v4.10 that changes this behavior is:
> 
> d1908f52557b ("fs: break out of iomap_file_buffered_write on fatal signals")
> 
> As of this commit the problem reproduces very easily, but with the previous
> commit I can't get it to happen at all.
> 
> So, once I figured out that I needed d1908f52557b to make the issue appear, I
> tested v4.10 merged with different commits in the current xfs/for-next branch
> to try and see if the commit you referenced above fixed the problem, and it
> does appear to.
> 
> So, quick summary:
> 
> v4.10				= failure
> v4.10 + xfs/for_next 		= success
> v4.10 + fa7f138			= success
> v4.10 + fa7f138~1 (4560e78)	= failure
> 
> So, as far as I can tell, fa7f138 does indeed seem to fix the issue.
> 

Ok, great. Thanks for working that all out.

> I don't know if this issue was actually introduced by d1908f52557b, or if that
> commit just changed things enough that the issue started happening much more
> regularly?
> 

I think the latter.. I originally hit the problem fixed by fa7f138 when
adding a minor error injection hack to facilitate an xfstests test
(related to your previous report, iirc). That hack resulted in the
possibility of 'written == 0' cases for the XFS ->iomap_end() handler
which were otherwise unlikely due to the limited error possibilities
between the time ->iomap_begin() returns successfully and ->iomap_end()
is invoked.

Commit d1908f52557b adds another error check right in that window
(iomap_write_actor()->iomap_write_begin()->fatal_signal_pending()),
which apparently turned this into a much more likely case to hit in
practice (wrt to generic/270, I'm guessing when the fsstress processes
are killed).

Note that we do still have one more issue with this code with a fix
in-progress[1].

> > > ------------[ cut here ]------------
> > ...
> > > ---[ end trace 384d06985052f068 ]---
> > > 
> > > Here's the xfstests run:
> > > 
> > > FSTYP         -- xfs (debug)
> > > PLATFORM      -- Linux/x86_64 alara 4.10.0
> > > MKFS_OPTIONS  -- -f -bsize=4096 /dev/pmem0p2
> > > MOUNT_OPTIONS -- -o dax -o context=system_u:object_r:nfs_t:s0 /dev/pmem0p2 /mnt/xfstests_scratch
> > > 
> > > generic/270 24s ..../check: line 596: 15817 Segmentation fault      ./$seq > $tmp.rawout 2>&1
> > >  [failed, exit status 139] - output mismatch (see /root/xfstests/results//generic/270.out.bad)
> > >     --- tests/generic/270.out	2016-10-21 15:31:10.568945780 -0600
> > >     +++ /root/xfstests/results//generic/270.out.bad	2017-02-22 12:01:29.272718284 -0700
> > >     @@ -3,6 +3,3 @@
> > >      Run fsstress
> > >      
> > >      Run dd writers in parallel
> > >     -Comparing user usage
> > >     -Comparing group usage
> > >     -Comparing filesystem consistency
> > >     ...
> > >     (Run 'diff -u tests/generic/270.out /root/xfstests/results//generic/270.out.bad'  to see the entire diff)
> > > 
> > > This was done in my normal test setup, which is a pair of PMEM disks that
> > > enable DAX.
> > > 
> > 
> > What I'm a little confused about though is that I thought DAX meant we
> > bypassed buffered I/O and always used direct I/O (which means you should
> > never perform delayed allocation). :/
> 
> Sorry, I don't know about this one.  :/

This is kind of a separate question, more pertaining why this issue is
even possible with DAX as opposed to purely buffered writes (where it is
expected prior to the fix in commit fa7f138). With the info above, I ran
generic/270 against an xfs for-next kernel with d1908f52557b applied and
fa7f138 reverted and reproduced the issue after several iterations.
Digging further, I see that buffered writes do indeed occur and what
looks like is going on here is that our hacky XFS_MOUNT_DAX logic in
xfs_diflags_to_iflags() doesn't survive an XFS_IOC_FSSETXATTR on the
inode. That ioctl is called by fsstress to set/change things like extent
size allocation hints, sync/append mode, project quota id, etc. 

It looks like the intent of the XFS_MOUNT_DAX thing is to set S_DAX for
every inode in memory, regardless of the on disk flags. It doesn't
actually change the on-disk flags. If a XFS_IOC_FSGETXATTR/FSSETXATTR
cycle occurs that makes some unrelated change on the inode, we
effectively revalidate the in-core inode flags based on what is on-disk
(i.e., we clear S_DAX). From that point forward (unless the inode is
reclaimed and re-read from disk I suppose), the DAX state is lost on the
inode.

My understanding is the '-o dax' mount option is a debug tool and slated
for removal. Given that, I'm not sure how critical a problem this really
is. If the mount option is going to stay around, I think something like
the appended hunk can probably fix it up. Otherwise, it might be a good
idea to disable the setxattr fsstress op and otherwise avoid any such
inode attribute changes when using it, or to set the DAX flag on disk
explicitly.

Brian

[1] http://www.spinics.net/lists/linux-xfs/msg04685.html

---8<---

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index edfa6a5..e6a4c38 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -686,8 +686,12 @@ xfs_ip2xflags(
 	struct xfs_inode	*ip)
 {
 	struct xfs_icdinode	*dic = &ip->i_d;
+	uint			flags;
 
-	return _xfs_dic2xflags(dic->di_flags, dic->di_flags2, XFS_IFORK_Q(ip));
+	flags = _xfs_dic2xflags(dic->di_flags, dic->di_flags2, XFS_IFORK_Q(ip));
+	if ((ip->i_mount->m_flags & XFS_MOUNT_DAX) && IS_DAX(VFS_I(ip)))
+		flags |= FS_XFLAG_DAX;
+	return flags;
 }
 
 /*
