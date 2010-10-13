Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9D0O4Vj188408 for <xfs@oss.sgi.com>; Tue, 12 Oct 2010 19:24:05 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E48E1E1E3B
	for <xfs@oss.sgi.com>; Tue, 12 Oct 2010 17:25:11 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	bh9JtSErBG8ikATW for <xfs@oss.sgi.com>;
	Tue, 12 Oct 2010 17:25:11 -0700 (PDT)
Date: Wed, 13 Oct 2010 11:25:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: ENOSPC at 90% with plenty of inodes
Message-ID: <20101013002509.GR4681@dastard>
References: <AANLkTinwnOm0V=9WwbXiUGFnyjCwT3GUHo0hiQahQNUV@mail.gmail.com>
	<20101008225146.GJ4681@dastard>
	<AANLkTikLyEuSoFRVwirKLws97Vemz4ScNHOqu2Jc5sWR@mail.gmail.com>
	<20101011223507.GB32255@dastard> <4CB3B964.40109@hardwarefreak.com>
	<20101012102954.GQ4681@dastard>
	<4CB4ED86.1010909@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4CB4ED86.1010909@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Tue, Oct 12, 2010 at 06:21:42PM -0500, Stan Hoeppner wrote:
> Dave Chinner put forth on 10/12/2010 5:29 AM:
> > On Mon, Oct 11, 2010 at 08:27:00PM -0500, Stan Hoeppner wrote:
> >> Dave Chinner put forth on 10/11/2010 5:35 PM:
> >>> On Mon, Oct 11, 2010 at 03:03:28PM +0100, James Braid wrote:
> >>>> On Fri, Oct 8, 2010 at 23:51, Dave Chinner <david@fromorbit.com> wrote:
> >>>>> Sounds like fragmented free space. What is the output of:
> >>>>>
> >>>>> # xfs_db -r -c "freesp -s" <device>
> >>>>
> >>>> # xfs_db -r -c "freesp -s" /dev/sdb
> >>>>    from      to extents  blocks    pct
> >>>>       1       1 2298052 2298052  40.52
> >>>>       2       3 1568338 3337017  58.84
> >>>>       4       7    8432   35716   0.63
> >>>>       8      15      50     423   0.01
> >>>> total free extents 3874872
> >>>> total free blocks 5671208
> >>>> average free extent size 1.46359
> >>>>
> >>>> Which seems to say there are a few tiny pieces of free space
> >>>> available? The files that were failing to be written were a few
> >>>> hundred bytes in size.
> >>>
> >>> The error has nothing to do with the size of the files, but
> >>> everything to do with being able to allocate more inodes. Inode
> >>> allocation requires 4 contiguous blocks (for 256 byte inodes, more
> >>> for larger inodes) with alignment constraints. That means when you
> >>> run out of 8 block or larger free extents, inode allocation will
> >>> start failing and you'll get ENOSPC being reported.
> >>>
> >>>> We haven't seen any errors so far today, but xfs_fsr ran over the
> >>>> weekend, so perhaps I guess it's reorganized the filesystem.
> >>>
> >>> Only a little. xfs_fsr will not improve fragmented free space
> >>> conditions (indeed, it normally fragments free space more). The only
> >>> way to reduce the fragmentation of free space is to remove a
> >>> significant amount of data and inodes from the filesystem...
> >>
> >> Hay Dave, would a "backup/reformat/restore" help with free space
> >> fragmentation in this case?
> > 
> > Of course. But that's the last resort....
> > 
> >> If so, could/should the OP specify anything
> >> during the mkfs.xfs reformat that may help alleviate or mitigate his
> >> problem in the future?
> > 
> > No. These problems usually appear in filesystems that have run at
> > greater than 85-90% full for extended periods of time without being
> > emptied at all. Once you start to free up space, it naturally
> > defragments itself, but if you never free up any significant amount
> > of space in the filesytesm, this cannot occur and so fragmentation
> > just keeps getting worse....
> 
> So, given that this problem is on a production IMAP server, and the OP
> likely can't just willy nilly start deleting user files, would adding
> more disk (and assuming he's using LVM or somesuch) and growing the
> filesystem alleviate this inode issue?

As long as you are unsing inode64 then growing the filesystem will
alow more inodes to be allocated.

> Or would he be better off adding more disk, creating a new filesystem,
> and moving half or so of his mailboxen over to the new filesystem at the
> Cyrus (application) level?  I've never used Cyrus, though IIRC Dovecot
> can do this "split mail store" setup.

Sure, that'd work, too.

Fundamentally, moving data and inodes around after a grow (or new
filesystem is added) is the only way to reduce existing free space
fragmentation. Achieving this data movement is left as an exercise
for the reader.  ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
