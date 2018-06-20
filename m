Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:56558 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752829AbeFTW7W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Jun 2018 18:59:22 -0400
Date: Thu, 21 Jun 2018 08:59:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: zero length symlinks are not valid
Message-ID: <20180620225918.GN19934@dastard>
References: <20180618055711.23391-1-david@fromorbit.com>
 <20180618055711.23391-2-david@fromorbit.com>
 <20180618132411.GB28320@bfoster>
 <20180618224259.GF19934@dastard>
 <20180619115434.GB2806@bfoster>
 <20180619154810.GC21698@magnolia>
 <20180619162839.GC2806@bfoster>
 <20180619232242.GJ19934@dastard>
 <20180620115048.GA3241@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180620115048.GA3241@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Wed, Jun 20, 2018 at 07:50:48AM -0400, Brian Foster wrote:
> On Wed, Jun 20, 2018 at 09:22:42AM +1000, Dave Chinner wrote:
> > On Tue, Jun 19, 2018 at 12:28:40PM -0400, Brian Foster wrote:
> > > On Tue, Jun 19, 2018 at 08:48:10AM -0700, Darrick J. Wong wrote:
> > > > On Tue, Jun 19, 2018 at 07:54:34AM -0400, Brian Foster wrote:
> > > > > On Tue, Jun 19, 2018 at 08:42:59AM +1000, Dave Chinner wrote:
> > > > > Rather, I'm asking about the pre-existing code that we remove. The hunk
> > > > > just above from xfs_inactive_symlink():
> > > > > 
> > > > > -	/*
> > > > > -	 * Zero length symlinks _can_ exist.
> > > > > -	 */
> > > > > -	if (!pathlen) {
> > > > > -		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > > > > -		return 0;
> > > > > -	}
> > > > > 
> > > > > ... obviously suggests that there could have been a situation where we'd
> > > > > see a zero-length symlink on entry to xfs_inactive_symlink(). This
> > > > > patch, however, focuses on fixing the transient zero-length symlink
> > > > > caused by xfs_inactive_symlink_rmt() (which comes after the above
> > > > > check).
> > 
> > It can't happen through normal VFS paths, and I don't think it can
> > happen through log recovery. That's why I replaced this with an ASSERT.
> > 
> > In the normal behaviour case, zero length symlinks were created
> > /after/ this point in time, and we've always been unable to read
> > such inodes because xfs_dinode_verify() has always rejected zero
> > length symlink inodes.
> > 
> 
> That was my initial understanding as well..
> 
> > However, log recovery doesn't trip over the transient inode state
> > because it does not use xfs_dinode_verify() for inode recovery - it
> > reads the buffer with xfs_inode_buf_ops, and that just checks the
> > inode numbers and then recovers whatever is in the log over the top.
> > It never checks for zero length symlinks on recovery, and it never
> > goes through the dinode verifier (on read or write!) to catch this.
> > 
> > It's not until we then recover the remaining intent chain that we go
> > through xfs_iget/xfs_iread/xfs_inactive/xfs_ifree, and that
> > xfs_iget() call runs xfs_dinode_verify(). If we've already recovered
> > any part of the remote symlink removal intent chain (and we must
> > have to be replaying EFIs!) this should see a zero length symlink
> > inode. AIUI, we have no evidence that the verifier has ever fired at
> > this point in time, even when recovering known transient zero length
> > states.
> > 
> 
> Hmm, not sure we're talking about the same thing. I ran a quick
> experiment to try and clear up my confusion here, at least. I injected a
> shutdown at the point inactive creates the zero sized symlink and
> created/removed a remote symlink. On a remount, I hit the following
> during log recovery:
> 
> [  685.931834] XFS (dm-3): Starting recovery (logdev: internal)
> [  685.993014] XFS (dm-3): Metadata corruption detected at xfs_dinode_verify+0x331/0x490 [xfs], inode 0x85 dinode
> [  685.996287] XFS (dm-3): Unmount and run xfs_repair
> [  685.996911] XFS (dm-3): First 128 bytes of corrupted metadata buffer:
> ...
> [  686.006647] Call Trace:
> [  686.006922]  dump_stack+0x85/0xcb
> [  686.007338]  xfs_iread+0xeb/0x220 [xfs]
> [  686.007820]  xfs_iget+0x4bd/0x1100 [xfs]
> [  686.008344]  xlog_recover_process_one_iunlink+0x4d/0x3c0 [xfs]
> ...
> 
> That seems to show that the verifier can impede unlinked list processing
> if the change is at least present in the log.

Which happens after we process intents - ah, the bmap intents only
occur from swap extents, so the inode is not read via xfs_iget()
in this case until unlinked list processing.

So, yeah, we are talking about the same thing - it's the second
phase of recovery that reads inodes through xfs_iget() (for whatever
reason) that will trip over the xfs_dinode_verifier.

> If I recreate that same dirty log state and mount with this patch
> applied (note that the fs is created without this patch to simulate an
> old kernel that has not changed i_mode in the same transaction that sets
> di_size = 0) along with a hack to avoid the check in
> xfs_dinode_verify(), I now hit the new assert and corruption error
> that's been placed in xfs_inactive_symlink().
> 
> So to Darrick's point, that seems to show that this is a vector to the
> pre-existing len == 0 check in xfs_inactive_symlink(). Given that, it
> seems to me that if we want to handle recovery from this state, we'd
> still need to work around the verifier check and retain the initial
> di_size == 0 check in xfs_inactive_symlink().

I think we should get rid of the transient state, not continue to
work around it. Because the transient state only exists in a log
recovery context, we can change the behaviour and not care about
older kernels still having the problem because all that is needed to
avoid the issue is a clean log when upgrading the kernel.

> > i.e all the cases I've seen where repair complains about symlinks
> > with "dfork format 2 and size 0" it is because the log is dirty and
> > hasn't been replayed. Mounting the filesystem and running log
> > recovery makes the problem go away, and this is what lead to me
> > removing the zeor length handling - the verifier should already
> > be firing if it is recovering an intent on a zero length symlink
> > inode...
> > 
> 
> I haven't grokked all the details here, but the behavior you describe
> does sound like this might be a different scenario from the above.

No, we are talking about the same thing. The only difference is that
I've been working from a bug report and corrupted fuzzer image, not
a real world corruption vector. Hence I'm trying to work backwards
from "here's a corrupt image that crashed" to "this is all the paths
that can lead to that on disk state".

While writing my last reply, I suspected you were correct about the
log recovery state, which is why I said:

> > That said, I'll try some more focussed testing with intentional
> > corruption to see if it's just a case of my testing being (un)lucky
> > and not triggering this issue...

As you've shown, I was being (un)lucky, so more work is needed on
this one.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
