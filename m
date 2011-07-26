Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6Q3X8gB079492 for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 22:33:09 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A84C41359BEE
	for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 20:33:08 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	PfOD8kJuBrADMYP5 for <xfs@oss.sgi.com>;
	Mon, 25 Jul 2011 20:33:08 -0700 (PDT)
Date: Tue, 26 Jul 2011 13:33:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS internal error XFS_WANT_CORRUPTED_GOTO
Message-ID: <20110726033302.GB8048@dastard>
References: <CADDb1s3X5PANPrrz=GRZZyKmSK1=xiBQ8+zz3WNTW6xN=c80PQ@mail.gmail.com>
	<CADDb1s04zm48uQ0mZAUsNZ_rDX-KnSHNeFsYb06Hg10k59ijOQ@mail.gmail.com>
	<CADDb1s2rcEvik3Tb4zooq93A6BSP+W9K87VdJEWLN9iHY1StMQ@mail.gmail.com>
	<20110722083457.GC13963@dastard>
	<CADDb1s1MpajXEHhMVf-h2K1JKQqaDLZ0QQY41seURUpde8D7Sg@mail.gmail.com>
	<20110724013457.GB31951@dastard>
	<CADDb1s3JnFQiKqjD6ANDkUUyCtVwg=LDeKe4piK3ZwzQ6FK83w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADDb1s3JnFQiKqjD6ANDkUUyCtVwg=LDeKe4piK3ZwzQ6FK83w@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 25, 2011 at 10:56:01AM +0530, Amit Sahrawat wrote:
> On Sun, Jul 24, 2011 at 7:04 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Fri, Jul 22, 2011 at 04:03:53PM +0530, Amit Sahrawat wrote:
> >> On Fri, Jul 22, 2011 at 2:04 PM, Dave Chinner <david@fromorbit.com> wrote:
> >> > [<c0023000>] (dump_backtrace+0x0/0x110)
> >> > [<c02dd668>] (dump_stack+0x0/0x1c)
> >> > [<c0176b84>] (xfs_error_report+0x0/0x5c)
> >> > [<c0150cd4>] (xfs_free_ag_extent+0x0/0x600)
> >> > [<c0152b78>] (xfs_free_extent+0x0/0xa4)
> >> > [<c015fea0>] (xfs_bmap_finish+0x0/0x194)
> >> > [<c017e664>] (xfs_itruncate_finish+0x0/0x30c)
> >> > [<c0197bbc>] (xfs_inactive+0x0/0x40c)
> >> > [<c01a3d50>] (xfs_fs_clear_inode+0x0/0x60)
> >> > [<c00bdcf8>] (clear_inode+0x0/0xe8)
> >> > [<c00be4a8>] (generic_delete_inode+0x0/0x178)
> >> > [<c00be620>] (generic_drop_inode+0x0/0x68)
> >> > [<c00bd2fc>] (iput+0x0/0x7c)
> >> > [<c00b4b44>] (do_unlinkat+0x0/0x154)
> >> > [<c00b4c98>] (sys_unlink+0x0/0x1c)
> >> >
> >> > So, you powered off an active machine while writing to it, and after
> >> > it started back up it hit a free space between corruption. And then
> >> > you couldn't mount it because log replay was trying to replay the
> >> > last committed transaction to the log. That transaction shows inode
> >> > 132 being unlinked, added to the AGI unliked list, and then being
> >> > inactivated. There is an EFI committed for 1 extent. There is no EFD
> >> > committed, so the shutdown occurred during that operation. Log
> >> > replay then hits the corruption repeatedly by trying to replay the
> >> > EFI to complete the extent free operation.
> >> >
> >> Yes, it happened exactly as you mentioned above. But the problem
> >> happened much earlier.
> >
> > Obviously.
> >
> >> While writing the 'reset' happened. At the next reboot - the
> >> filesystem mounted even though there
> >> was corruption - the file and journal did not match.
> >
> > You found this how?
> Just before removing the file on next 'reboot' - I checked the values
> for file extents and the 'by-block' tree free length.
> File extents - no. of blocks was correct but the neighbouring blocks
> do not match with the occupied blocks in the allocation group.
> If a file of 'N' blocks is present in an allocation group, then the
> allocation group should now have (X-N) free blocks, where 'X' is the
> size of allocation group in blocks.
> But in this case - free size of allocation group is (X - M), where M
> is greater than 'N'.

Sure - there might be other metadata blocks that had to be allocated
so there may be more used space than just what is allocated to the
inode itself. e.g. bmap btree blocks, free space btree blocks due to
a btree node split, etc. You can't just look at the the number of
data blocks in an inode and the number of free blocks in an AG and
expect them to match exactly...

> which means when there is a free request for that file and then
> corresponsing blocks are checked in the allocation group - it will
> show the blocks as already free and point to corruption.
> Is the above observation  correct?
> >
> >> And it did not
> >> show any error either.
> >
> > Well, no. If the journal format is intact, then it's contents are
> > trusted.
> >
> >> The moment the issue happened and then if checked through xfs_logprint
> >> - the blocks free in the allocation group does not match up properly.
> >> I checked by taking the print from xfs_free_ag_extent - it showed the
> >> wrong blocks contigous to that file.
> >
> > Yes, which is why I suspect that the journal contained something it
> > shouldn't have.
> >
> >> Original file which was to be deleted is of '255' blocks and started
> >> from physical block number - 12.
> >
> > Yes, I saw that in the EFI record in the logprint output I quoted.
> >
> >> While the free space tree has free
> >> blocks larger than what it should be. it returns the length starting
> >> from block number and the length which is last committed to the log.
> >>
> >> As I mentioned in the last mail - the details about the observation.
> >> Please check.
> >
> > Going back to the transaction you quoted first: it doesn't match the
> > entries in the log print you attached in your second email. I can't
> > comment on it at all.
> In the last mail - I attached the log where-in 'reset' happened but
> there was no corruption. Just to check that what all is recorded in
> journal, and this time journal matched with the data on the disk.
> >
> >> > So, the log and the repair output are useless for determining what
> >> > caused the problem - you need the log from the mount *before* the
> >> > first shutdown occurred, and to have run repair *before* you
> >> > tried to unlink anything.
> >>
> >> It is only after 'first shutdown' I came to know about the corruption.
> >> Since, there was no error shown at the mount time, it did not seemed
> >> reasonable enough to run "repair" on the disk.
> >
> > It's standard practice for power failure integrity testing.
> Yes, Even I agree to this. But why was there a mount at first hand? I
> guess if it returned some error - xfs_repair could be run.

Sorry, I'm not sure what you are asking.

If you're doing power failure testing, then after the power failure
you should always run a mount/unmount/repair cycle before doing
anything else to check the filesystem and the journal were not
corrupted by the power failure. You can't test the integrity of the
journal any other way at this point in time....

> > The transaction was never committed completely in the journal. The
> > last complete transaction in the journal matches up with the inode
> > size in your ls -l output about.
> Yes, this is what I wanted to show using the latest log prints. But
> this is not case when there is an issue.

Then please tell me that what you attached is for a working case so
I won't waste my time analysing it. I don't care about the case
where everything works - I care about the case where it doesn't
work.

In that case, I want to be able to validate your analysis of the
case where the filesystem gets broken, and I need the log contents
from prior to the first mount after the power failure has occurred
to determine that. And to tell the truth, it's better if you don't
tell me what you think is wrong in the first place so my analysis is
independent of yours. Hence if they both point to the same problem,
then we've got a fairly good indication of where the bug lies.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
