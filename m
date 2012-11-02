Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA21Pdql068337 for <xfs@oss.sgi.com>; Thu, 1 Nov 2012 20:25:39 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Ti3A5nQQxyQtZdQG for <xfs@oss.sgi.com>;
	Thu, 01 Nov 2012 18:27:30 -0700 (PDT)
Date: Fri, 2 Nov 2012 12:27:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs filesystem corruption with kernel 2.6.37
Message-ID: <20121102012728.GT29378@dastard>
References: <CAC=U0a2T_J9Y6WzvWyFfbBSDy__Pr7f4gfQBie2o0VhAm2jCaQ@mail.gmail.com>
	<20121025224713.GF29378@dastard> <34630253.post@talk.nabble.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <34630253.post@talk.nabble.com>
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
To: Kamal Dasu <kdasu.kdev@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Nov 01, 2012 at 12:30:13PM -0700, Kamal Dasu wrote:
> 
> Dave,
> 
> Thanks for you reply.
> 
> I am trying to act on the hints you gave me but I still have a few
> questions.
> 
> On Thu, Oct 25, 2012 at 6:47 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, Oct 25, 2012 at 09:45:10AM -0400, Kamal Dasu wrote:
> >> with  "CONFIG_XFS_DEBUG=y" I get the following assertion:
> >>
> >> Assertion failed: prev.br_state == XFS_EXT_NORM, file:
> >> fs/xfs/xfs_bmap.c, line: 5192
> >
> > Yup, that's pretty clear indication of a corrupted extent record.
> >
> 
> What is the best way to prevent  transactions that record bad
> extent length and block numbers.

That should never occur - there are already checks in place to
prevent that. However, the log must be treated as potentially
corrupt during recovery, so when freeing extents on recovered files
we might be walking corrupt extents. xfs_bunmapi() is the place that
should be checking that the extent being freed is of a sane length.
(Just like xfs_bmapi checks to ensure the extent allocated is of
sane length).


> > That's the open, unlinked file at the time the system crashed. That
> > may be where your problems are coming from. The RT is mostly
> > untested, and we sure as anything don't do any crash resiliency or
> > recovery testing on it, so there's a good chance there are bugs in
> > it that might show up in situations like this....
> >
> > You need to detect extents with invalid lengths in them and trigger
> > a corruption-based filesystem shutdown.
> 
> Looked at the log during one of the filesystem shutdown when the
> I/O error occurs. is this an indication of already corrupted log due to
> corrupted in-memory metadata structures?.
> ===
> attempt to access beyond end of device
> sda2: rw=0, want=33792081130943048, limit=31471329
> I/O error in filesystem ("sda2") meta-data dev sda2 block
> 0x780db80007f240       ("xfs_trans_read_buf") error 5 buf count 4096
> xfs_force_shutdown(sda2,0x1) called from line 395 of file
> fs/xfs/xfs_trans_buf.c.  Return address = 0x801f4f88
> Filesystem "sda2": I/O Error Detected.  Shutting down filesystem: sda2
> Please umount the filesystem, and rectify the problem(s)

The I/O error is what triggered the shutdown. The transaction tried
to read a metadata block beyond EOF.

> However the log is already corrupted. So is there a check on a write
> to the log ?.

No, the above check caught the corruption as soon as it was found.
You need to walk back from this event to find where the corruption
was introduced.

> >> also if there is something that can be done to avoid this situation in
> >> the first place.
> >
> > Track down where those stray upper bits in the block numbers are
> > coming from, and you'll have your answer.
> >
> 
> Have not been able to track this down yet. But could it be a possible memory
> corruption, leading to the in-memory metadata to get corrupted.

Yes, that is a possible cause that lead to a bad block number being
written to disk.

> On a similar occurrence of this issue on recovery after a reboot seems
> to always go through the evict path
> 
> Filesystem "sda2": XFS internal error xfs_trans_cancel at line 1815
> of file fs/xfs/xfs_trans.c.  Caller 0x801f8524
> 
> Call Trace:
> [<80439d2c>] dump_stack+0x8/0x34
> [<801f3bec>] xfs_trans_cancel+0x10c/0x128
> [<801f8524>] xfs_inactive+0x2fc/0x450
> [<800dcd54>] evict+0x28/0xd0
> [<800dd300>] iput+0x19c/0x2d8
> [<801e5bcc>] xlog_recover_process_one_iunlink+0xec/0x130
> [<801e7b60>] xlog_recover_process_iunlinks.clone.25+0xa8/0x108
> [<801eb360>] xlog_recover_finish+0x40/0x100
> [<801eedd8>] xfs_mountfs+0x434/0x654

That's where it is processing files that were unlinked but still
referenced at the time of the crash. We already know that these are
the corrupted files...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
