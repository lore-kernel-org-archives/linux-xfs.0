Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23192 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753037AbdCFSmJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 6 Mar 2017 13:42:09 -0500
Date: Mon, 6 Mar 2017 11:41:09 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: XFS kernel BUG during generic/270 with v4.10
Message-ID: <20170306184109.GA19127@linux.intel.com>
References: <20170222191300.GA29474@linux.intel.com>
 <20170302162934.GM3213@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170302162934.GM3213@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Thu, Mar 02, 2017 at 11:29:34AM -0500, Brian Foster wrote:
> On Wed, Feb 22, 2017 at 12:13:00PM -0700, Ross Zwisler wrote:
> > By running generic/270 in a loop on an XFS filesystem mounted with DAX I'm
> > able to reliably generate the following kernel bug after a few (~10)
> > iterations (output passed through kasan_symbolize.py):
> > 
> > run fstests generic/270 at 2017-02-22 12:01:05
> > XFS (pmem0p2): Unmounting Filesystem
> > XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
> > XFS (pmem0p2): Mounting V5 Filesystem
> > XFS (pmem0p2): Ending clean mount
> > XFS (pmem0p2): Quotacheck needed: Please wait.
> > XFS (pmem0p2): Quotacheck: Done.
> > XFS (pmem0p2): xlog_verify_grant_tail: space > BBTOB(tail_blocks)
> > XFS: Assertion failed: XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0, file: fs/xfs/xfs_super.c, line: 965
> 
> This means we've reclaimed an inode that still has delayed allocation
> blocks, which shouldn't occur. We do have one recent fix in this area:
> fa7f138 ("xfs: clear delalloc and cache on buffered write failure"). Do
> you still reproduce this? If so, does it reproduce with that patch?

Cool, I've done a bunch more testing and have some interesting info.

First, this issue isn't specific to DAX.  If I turn DAX off, it actually
reproduces much faster, usually on the first test run.

The branch I could find in the xfs repo that contained commit

fa7f138 ("xfs: clear delalloc and cache on buffered write failure")

Was based on v4.10-rc6.  Interestingly, this baseline does not reproduce this
issue, whereas v4.10 release reproduces it very consistently.  The commit
between v4.10-rc6 and v4.10 that changes this behavior is:

d1908f52557b ("fs: break out of iomap_file_buffered_write on fatal signals")

As of this commit the problem reproduces very easily, but with the previous
commit I can't get it to happen at all.

So, once I figured out that I needed d1908f52557b to make the issue appear, I
tested v4.10 merged with different commits in the current xfs/for-next branch
to try and see if the commit you referenced above fixed the problem, and it
does appear to.

So, quick summary:

v4.10				= failure
v4.10 + xfs/for_next 		= success
v4.10 + fa7f138			= success
v4.10 + fa7f138~1 (4560e78)	= failure

So, as far as I can tell, fa7f138 does indeed seem to fix the issue.

I don't know if this issue was actually introduced by d1908f52557b, or if that
commit just changed things enough that the issue started happening much more
regularly?

> > ------------[ cut here ]------------
> ...
> > ---[ end trace 384d06985052f068 ]---
> > 
> > Here's the xfstests run:
> > 
> > FSTYP         -- xfs (debug)
> > PLATFORM      -- Linux/x86_64 alara 4.10.0
> > MKFS_OPTIONS  -- -f -bsize=4096 /dev/pmem0p2
> > MOUNT_OPTIONS -- -o dax -o context=system_u:object_r:nfs_t:s0 /dev/pmem0p2 /mnt/xfstests_scratch
> > 
> > generic/270 24s ..../check: line 596: 15817 Segmentation fault      ./$seq > $tmp.rawout 2>&1
> >  [failed, exit status 139] - output mismatch (see /root/xfstests/results//generic/270.out.bad)
> >     --- tests/generic/270.out	2016-10-21 15:31:10.568945780 -0600
> >     +++ /root/xfstests/results//generic/270.out.bad	2017-02-22 12:01:29.272718284 -0700
> >     @@ -3,6 +3,3 @@
> >      Run fsstress
> >      
> >      Run dd writers in parallel
> >     -Comparing user usage
> >     -Comparing group usage
> >     -Comparing filesystem consistency
> >     ...
> >     (Run 'diff -u tests/generic/270.out /root/xfstests/results//generic/270.out.bad'  to see the entire diff)
> > 
> > This was done in my normal test setup, which is a pair of PMEM disks that
> > enable DAX.
> > 
> 
> What I'm a little confused about though is that I thought DAX meant we
> bypassed buffered I/O and always used direct I/O (which means you should
> never perform delayed allocation). :/

Sorry, I don't know about this one.  :/
