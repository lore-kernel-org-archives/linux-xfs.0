Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:34580 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751218AbeGIWEY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Jul 2018 18:04:24 -0400
Date: Mon, 9 Jul 2018 16:04:02 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: XFS: Assertion failed: !rwsem_is_locked(&inode->i_rwsem)
Message-ID: <20180709220402.GA26254@linux.intel.com>
References: <20180619021746.GA6652@linux.intel.com>
 <20180619023246.GG19934@dastard>
 <20180619164420.GB6679@linux.intel.com>
 <20180619232953.GK19934@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180619232953.GK19934@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-xfs@vger.kernel.org

On Wed, Jun 20, 2018 at 09:29:54AM +1000, Dave Chinner wrote:
> On Tue, Jun 19, 2018 at 10:44:20AM -0600, Ross Zwisler wrote:
> > On Tue, Jun 19, 2018 at 12:32:46PM +1000, Dave Chinner wrote:
> > > On Mon, Jun 18, 2018 at 08:17:46PM -0600, Ross Zwisler wrote:
> > > > During some xfstest runs on next-20180615 I hit the following with DAX +
> > > > generic/388:
> > > > 
> > > > ================================================
> > > > WARNING: lock held when returning to user space!
> > > > 4.17.0-next-20180615-00001-gf09d99951966 #2 Not tainted
> > > > ------------------------------------------------
> > > > fsstress/6598 is leaving the kernel with locks still held!
> > > > 2 locks held by fsstress/6598:
> > > >  #0: 00000000d8f89e14 (&sb->s_type->i_mutex_key#13){++++}, at: xfs_ilock+0x211/0x310
> > > >  #1: 000000005cc93137 (&(&ip->i_mmaplock)->mr_lock){++++}, at: xfs_ilock+0x1eb/0x310
> > > 
> > > What errors occurred before this? generic/388 is testing all sorts
> > > of error paths by randomly shutting down the filesystem, so it'e
> > > entirely possible that we've leaked those locks (XFS_IOLOCK and
> > > XFS_MMAPLOCK) on some rarely travelled error path. The prior errors
> > > might help identify that path.
> > 
> > Here is the full output from another reproduction:
> ....
> >  XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
> >  XFS (pmem0p2): Mounting V5 Filesystem
> >  XFS (pmem0p2): Starting recovery (logdev: internal)
> >  XFS (pmem0p2): Ending recovery (logdev: internal)
> >  XFS (pmem0p2): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -5, agno 0
> >  
> >  ================================================
> >  WARNING: lock held when returning to user space!
> >  4.17.0-next-20180615 #1 Not tainted
> >  ------------------------------------------------
> 
> Ok, nothing extra to go on there. can you get lockdep to dump the
> stack or oops so we at least know what syscall was being run when
> this is detected?

Well, I can't seem to reproduce this reliably anymore.  :(

I did reproduce it once with the debug you requested, and the syscall that wsa
being run when we found the lock imbalance was __x64_sys_ioctl, for whatever
that's worth.
