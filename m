Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:41069 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751157AbeEWErx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 May 2018 00:47:53 -0400
Date: Wed, 23 May 2018 14:47:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: INFO: task hung in xlog_grant_head_check
Message-ID: <20180523044742.GZ23861@dastard>
References: <000000000000457b2d056cbb0044@google.com>
 <20180522123107.GC3751@bfoster.bfoster>
 <20180522222620.GW23861@dastard>
 <20180522225208.GB658@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180522225208.GB658@sol.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Biggers <ebiggers3@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>, syzbot <syzbot+568245b88fbaedcb1959@syzkaller.appspotmail.com>, darrick.wong@oracle.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com

On Tue, May 22, 2018 at 03:52:08PM -0700, Eric Biggers wrote:
> On Wed, May 23, 2018 at 08:26:20AM +1000, Dave Chinner wrote:
> > On Tue, May 22, 2018 at 08:31:08AM -0400, Brian Foster wrote:
> > > On Mon, May 21, 2018 at 10:55:02AM -0700, syzbot wrote:
> > > > Hello,
> > > > 
> > > > syzbot found the following crash on:
> > > > 
> > > > HEAD commit:    203ec2fed17a Merge tag 'armsoc-fixes' of git://git.kernel...
> > > > git tree:       upstream
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=11c1ad77800000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=f3b4e30da84ec1ed
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=568245b88fbaedcb1959
> > > > compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> > > > syzkaller repro:https://syzkaller.appspot.com/x/repro.syz?x=122c7427800000
> > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10387057800000
> > > > 
> > > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > > Reported-by: syzbot+568245b88fbaedcb1959@syzkaller.appspotmail.com
> > > > 
> > > >         (ptrval): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > > ................
> > > >         (ptrval): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > > > ................
> > > > XFS (loop0): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x2 len
> > > > 1 error 117
> > > > XFS (loop0): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -117,
> > > > agno 0
> > > > XFS (loop0): failed to read root inode
> > > 
> > > FWIW, the initial console output is actually:
> > > 
> > > [  448.028253] XFS (loop0): Mounting V4 Filesystem
> > > [  448.033540] XFS (loop0): Log size 9371840 blocks too large, maximum size is 1048576 blocks
> > > [  448.042287] XFS (loop0): Log size out of supported range.
> > > [  448.047841] XFS (loop0): Continuing onwards, but if log hangs are experienced then please report this message in the bug report.
> > > [  448.060712] XFS (loop0): totally zeroed log
> > > 
> > > ... which warns about an oversized log and resulting log hangs. Not
> > > having dug into the details of why this occurs so quickly in this mount
> > > failure path,
> > 
> > I suspect that it is a head and/or log tail pointer overflow, so when it
> > tries to do the first trans reserve of the mount - to write the
> > unmount record - it says "no log space available, please wait".
> > 
> > > it does look like we'd never have got past this point on a
> > > v5 fs (i.e., the above warning would become an error and we'd not enter
> > > the xfs_log_mount_cancel() path).
> > 
> > And this comes back to my repeated comments about fuzzers needing
> > to fuzz properly made V5 filesystems as we catch and error out on
> > things like this. Fuzzing random collections of v4 filesystem
> > fragments will continue to trip over problems we've avoided with v5
> > filesystems, and this is further evidence to point to that.
> >
> > 
> > I'd suggest that at this point, syzbot XFS reports should be
> > redirected to /dev/null. It's not worth our time to triage
> > unreviewed bot generated bug reports until the syzbot developers
> > start listening and acting on what we have been telling them
> > about fuzzing filesystems and reproducing bugs that are meaningful
> > and useful to us.
> 
> The whole point of fuzzing is to provide improper inputs.

Eric, we know what fuzzing is.

If people listened to us rather just throwing stuff over the wall at
us, they'd already know that our own fuzzing code works on v5
filesystems and that it has found a lot more problems in recent
times than syzbot has.

And they'd also know that our own fuzzing stuff provides us with
easily debuggable, reproducable test cases instead of opaque,
difficult to analyse reports of things we already know about and
can't fix in a legacy on-disk format. i.e. it already does all the
things we're asking from the syzbot fuzzing.

> A kernel bug is a
> kernel bug, even if it's in deprecated/unmaintained code, or involves userspace
> doing something unexpected.

Yup, but then the severity and impact of the problem the bug exposes
has to weighed against the risk it poses to the userbase, and the
impact the fix will have on the userbase. We went through this
process several years ago for this specific problem, like we do for
all on-disk format bugs.

Keep in mind that filesystems are persistent structures that have
lifetimes of tens of years. We have to support users with old
formats, regardless of the unfixable problems they may have. We do
what we can to mitigate those issues for them and encourage users to
upgrade their kernels and on-disk formats, but we can't just shut
off access to the old formats in new kernels because a new fuzzer
found an old problem we've known about for years.

[ FYI, this report is for an on-disk v4 format bug that was
introduced into mkfs about 15 years ago.  It has since been fixed
for both v4 and v5 filesystems (~4 years ago, IIRC), but still
leaves us with about a really, really long tail of production v4
format filesystems with the on-disk format bug present in them.

IOWs, when we came across this problem, we had the choice of two
things when initially validating the log size:

- only warning users of v4 filesystems and leaving them exposed to a
  bug that could caused runtime hangs in very rare corner cases
  (very low risk); or

- preventing them from accessing their filesystems and data on
  kernel upgrade, thereby directly affecting millions of existing
  filesystems in production around the world.

In this case, the *choice of least harm* was to warn about the
problem for v4 filesystems and continue onwards, but to reject
mounts that failed log size validation on the new v5 filesystem
because the on-disk format bug is fixed in v5 filesystems. ]

> If you have known buggy code in XFS that you refuse to fix, then
> please provide a kernel config option so that users can disable
> the unmaintained XFS formats/features, leaving the maintained
> ones.

What's the point of doing that when the attacker can just move to
some other exploitable filesystem e.g.  ext2/3/4, vfat, btrfs, hfs,
etc? They have known vulnerable and exploitable on disk formats,
too.

i.e. this isn't an "XFS problem", this is a "all current block
device based kernel filesystems are built on top of a trust model
that breaks down when 3rd party storage access is allowed" problem.
This is not solvable by just saying "don't use filesystem X"....

> As-is, you seem to be forcing everyone who enables
> CONFIG_XFS_FS to build known buggy/unmaintained code into their
> kernel.

That's just hyperbole - software /by definition/ is known to be
buggy. And all Linux filesystems have unfixable, known bugs when it
comes to 3rd party manipulation of their on-disk format and that's the
reality we live in right now. How we chose to deal with that is
not a black/white decision (as I outlined above) - every distro has
users of the legacy XFS format, so even if we made it a config
option it will never be turned off in shipping distros kernels.

IOWs, mitigation decisions are difficult, but we have to draw a line
somewhere. In the case of XFS, we decided that the legacy format
needs to remain accepting of some bad input so users of those
formats don't get nasty surprises, but all new formats will strictly
validate all inputs and reject anything invalid. i.e. we get better
as time goes on, and that's why we want syzbot and other fuzzers to
focus on finding flaws in the new formats rather than the old.

Cheers,

-Dave.
-- 
Dave Chinner
david@fromorbit.com
