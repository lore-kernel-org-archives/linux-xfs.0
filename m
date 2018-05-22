Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:5419 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753088AbeEVW0X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 May 2018 18:26:23 -0400
Date: Wed, 23 May 2018 08:26:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: INFO: task hung in xlog_grant_head_check
Message-ID: <20180522222620.GW23861@dastard>
References: <000000000000457b2d056cbb0044@google.com>
 <20180522123107.GC3751@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180522123107.GC3751@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: syzbot <syzbot+568245b88fbaedcb1959@syzkaller.appspotmail.com>, darrick.wong@oracle.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com

On Tue, May 22, 2018 at 08:31:08AM -0400, Brian Foster wrote:
> On Mon, May 21, 2018 at 10:55:02AM -0700, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following crash on:
> > 
> > HEAD commit:    203ec2fed17a Merge tag 'armsoc-fixes' of git://git.kernel...
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=11c1ad77800000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=f3b4e30da84ec1ed
> > dashboard link: https://syzkaller.appspot.com/bug?extid=568245b88fbaedcb1959
> > compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> > syzkaller repro:https://syzkaller.appspot.com/x/repro.syz?x=122c7427800000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10387057800000
> > 
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+568245b88fbaedcb1959@syzkaller.appspotmail.com
> > 
> >         (ptrval): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > ................
> >         (ptrval): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > ................
> > XFS (loop0): metadata I/O error in "xfs_trans_read_buf_map" at daddr 0x2 len
> > 1 error 117
> > XFS (loop0): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -117,
> > agno 0
> > XFS (loop0): failed to read root inode
> 
> FWIW, the initial console output is actually:
> 
> [  448.028253] XFS (loop0): Mounting V4 Filesystem
> [  448.033540] XFS (loop0): Log size 9371840 blocks too large, maximum size is 1048576 blocks
> [  448.042287] XFS (loop0): Log size out of supported range.
> [  448.047841] XFS (loop0): Continuing onwards, but if log hangs are experienced then please report this message in the bug report.
> [  448.060712] XFS (loop0): totally zeroed log
> 
> ... which warns about an oversized log and resulting log hangs. Not
> having dug into the details of why this occurs so quickly in this mount
> failure path,

I suspect that it is a head and/or log tail pointer overflow, so when it
tries to do the first trans reserve of the mount - to write the
unmount record - it says "no log space available, please wait".

> it does look like we'd never have got past this point on a
> v5 fs (i.e., the above warning would become an error and we'd not enter
> the xfs_log_mount_cancel() path).

And this comes back to my repeated comments about fuzzers needing
to fuzz properly made V5 filesystems as we catch and error out on
things like this. Fuzzing random collections of v4 filesystem
fragments will continue to trip over problems we've avoided with v5
filesystems, and this is further evidence to point to that.

I'd suggest that at this point, syzbot XFS reports should be
redirected to /dev/null. It's not worth our time to triage
unreviewed bot generated bug reports until the syzbot developers
start listening and acting on what we have been telling them
about fuzzing filesystems and reproducing bugs that are meaningful
and useful to us.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
