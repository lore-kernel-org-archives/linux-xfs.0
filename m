Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:4536 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750726AbeFSXWp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jun 2018 19:22:45 -0400
Date: Wed, 20 Jun 2018 09:22:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/2] xfs: zero length symlinks are not valid
Message-ID: <20180619232242.GJ19934@dastard>
References: <20180618055711.23391-1-david@fromorbit.com>
 <20180618055711.23391-2-david@fromorbit.com>
 <20180618132411.GB28320@bfoster>
 <20180618224259.GF19934@dastard>
 <20180619115434.GB2806@bfoster>
 <20180619154810.GC21698@magnolia>
 <20180619162839.GC2806@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180619162839.GC2806@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Tue, Jun 19, 2018 at 12:28:40PM -0400, Brian Foster wrote:
> On Tue, Jun 19, 2018 at 08:48:10AM -0700, Darrick J. Wong wrote:
> > On Tue, Jun 19, 2018 at 07:54:34AM -0400, Brian Foster wrote:
> > > On Tue, Jun 19, 2018 at 08:42:59AM +1000, Dave Chinner wrote:
> > > Rather, I'm asking about the pre-existing code that we remove. The hunk
> > > just above from xfs_inactive_symlink():
> > > 
> > > -	/*
> > > -	 * Zero length symlinks _can_ exist.
> > > -	 */
> > > -	if (!pathlen) {
> > > -		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > > -		return 0;
> > > -	}
> > > 
> > > ... obviously suggests that there could have been a situation where we'd
> > > see a zero-length symlink on entry to xfs_inactive_symlink(). This
> > > patch, however, focuses on fixing the transient zero-length symlink
> > > caused by xfs_inactive_symlink_rmt() (which comes after the above
> > > check).

It can't happen through normal VFS paths, and I don't think it can
happen through log recovery. That's why I replaced this with an ASSERT.

In the normal behaviour case, zero length symlinks were created
/after/ this point in time, and we've always been unable to read
such inodes because xfs_dinode_verify() has always rejected zero
length symlink inodes.

However, log recovery doesn't trip over the transient inode state
because it does not use xfs_dinode_verify() for inode recovery - it
reads the buffer with xfs_inode_buf_ops, and that just checks the
inode numbers and then recovers whatever is in the log over the top.
It never checks for zero length symlinks on recovery, and it never
goes through the dinode verifier (on read or write!) to catch this.

It's not until we then recover the remaining intent chain that we go
through xfs_iget/xfs_iread/xfs_inactive/xfs_ifree, and that
xfs_iget() call runs xfs_dinode_verify(). If we've already recovered
any part of the remote symlink removal intent chain (and we must
have to be replaying EFIs!) this should see a zero length symlink
inode. AIUI, we have no evidence that the verifier has ever fired at
this point in time, even when recovering known transient zero length
states.

i.e all the cases I've seen where repair complains about symlinks
with "dfork format 2 and size 0" it is because the log is dirty and
hasn't been replayed. Mounting the filesystem and running log
recovery makes the problem go away, and this is what lead to me
removing the zeor length handling - the verifier should already
be firing if it is recovering an intent on a zero length symlink
inode...

That said, I'll try some more focussed testing with intentional
corruption to see if it's just a case of my testing being (un)lucky
and not triggering this issue...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
