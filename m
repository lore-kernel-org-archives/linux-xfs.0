Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 05 Nov 2007 23:10:25 -0800 (PST)
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.176])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA67AIrt002874
	for <xfs@oss.sgi.com>; Mon, 5 Nov 2007 23:10:20 -0800
Received: by py-out-1112.google.com with SMTP id u77so3727623pyb
        for <xfs@oss.sgi.com>; Mon, 05 Nov 2007 23:10:22 -0800 (PST)
Message-ID: <64bb37e0711052310r5214cf50nd148d989524490ea@mail.gmail.com>
Date: Tue, 6 Nov 2007 08:10:21 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Subject: Re: writeout stalls in current -git
In-Reply-To: <20071106042527.GT995458@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <393903856.06449@ustc.edu.cn>
	 <64bb37e0711011200n228e708eg255640388f83da22@mail.gmail.com>
	 <E1InmAI-0003ME-2i@localhost> <1193998532.27652.343.camel@twins>
	 <64bb37e0711021222q7d12c825mc62d433c4fe19e8@mail.gmail.com>
	 <20071102204258.GR995458@sgi.com>
	 <64bb37e0711040319l5de285c3xea64474540a51b6e@mail.gmail.com>
	 <20071105014510.GU66820511@sgi.com>
	 <64bb37e0711051027v49869699s9593ea54713b15ff@mail.gmail.com>
	 <20071106042527.GT995458@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Fengguang Wu <wfg@mail.ustc.edu.cn>, Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On 11/6/07, David Chinner <dgc@sgi.com> wrote:
> On Mon, Nov 05, 2007 at 07:27:16PM +0100, Torsten Kaiser wrote:
> > On 11/5/07, David Chinner <dgc@sgi.com> wrote:
> > > Ok, so it's probably a side effect of the writeback changes.
> > >
> > > Attached are two patches (two because one was in a separate patchset as
> > > a standalone change) that should prevent async writeback from blocking
> > > on locked inode cluster buffers. Apply the xfs-factor-inotobp patch first.
> > > Can you see if this fixes the problem?
> >
> > Now testing v2.6.24-rc1-650-gb55d1b1+ the fix for the missapplied raid5-patch
> > Applying your two patches ontop of that does not fix the stalls.
>
> So you are having RAID5 problems as well?

The first 2.6.24-rc1-git-kernel that I patched with your patches did
not boot for me. (Oops send in one of my previous mails) But given
that the stacktrace was not xfs related and I had seen this patch on
the lkml, I tried to fix this Oops this way.
I did not have troubles with the RAID5 otherwise.

> I'm struggling to understand what possible changed in XFS or writeback that
> would lead to stalls like this, esp. as you appear to be removing files when
> the stalls occur. Rather than vmstat, can you use something like iostat to
> show how busy your disks are?  i.e. are we seeing RMW cycles in the raid5 or
> some such issue.

Will do this this evening.

> OOC, what is the 'xfs_info <mtpt>' output for your filesystem?

meta-data=/dev/mapper/root       isize=256    agcount=32, agsize=4731132 blks
         =                       sectsz=512   attr=1
data     =                       bsize=4096   blocks=151396224, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0


> > vmstat 10 output from unmerging (uninstalling) a kernel:
> >  1  0      0 3512188    332 192644    0    0   185    12  368  735 10  3 85  1
> > -> emerge starts to remove the kernel source files
> >  3  0      0 3506624    332 192836    0    0    15  9825 2458 8307  7 12 81  0
> >  0  0      0 3507212    332 192836    0    0     0   554  630 1233  0  1 99  0
> >  0  0      0 3507292    332 192836    0    0     0   537  580 1328  0  1 99  0
> >  0  0      0 3507168    332 192836    0    0     0   633  626 1380  0  1 99  0
> >  0  0      0 3507116    332 192836    0    0     0  1510  768 2030  1  2 97  0
> >  0  0      0 3507596    332 192836    0    0     0   524  540 1544  0  0 99  0
> > procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
> >  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
> >  0  0      0 3507540    332 192836    0    0     0   489  551 1293  0  0 99  0
> >  0  0      0 3507528    332 192836    0    0     0   527  510 1432  1  1 99  0
> >  0  0      0 3508052    332 192840    0    0     0  2088  910 2964  2  3 95  0
> >  0  0      0 3507888    332 192840    0    0     0   442  565 1383  1  1 99  0
> >  0  0      0 3508704    332 192840    0    0     0   497  529 1479  0  0 99  0
> >  0  0      0 3508704    332 192840    0    0     0   594  595 1458  0  0 99  0
> >  0  0      0 3511492    332 192840    0    0     0  2381 1028 2941  2  3 95  0
> >  0  0      0 3510684    332 192840    0    0     0   699  600 1390  0  0 99  0
> >  0  0      0 3511636    332 192840    0    0     0   741  661 1641  0  0 100  0
> >  0  0      0 3524020    332 192840    0    0     0  2452 1080 3910  2  3 95  0
> >  0  0      0 3524040    332 192844    0    0     0   530  617 1297  0  0 99  0
> >  0  0      0 3524128    332 192844    0    0     0   812  674 1667  0  1 99  0
> >  0  0      0 3527000    332 193672    0    0   339   721  754 1681  3  2 93  1
> > -> emerge is finished, no dirty or writeback data in /proc/meminfo
>
> At this point, can you run a "sync" and see how long that takes to
> complete?

Already tried that: http://lkml.org/lkml/2007/11/2/178
See the logs from the second unmerge in the second half of the mail.

The sync did not stop this writeout, but returned immediately.

> The only thing I can think that woul dbe written out after
> this point is inodes, but even then it seems to go on for a long,
> long time and it really doesn't seem like XFS is holding up the
> inode writes.

Yes, I completly agree that this is much to long. Thats why I included
the after-emerge-finished parts of the logs. But I still partly
suspect xfs, because the xfssyncd shows up when I hip SysRq+W.

> Another option is to use blktrace/blkparse to determine which process is
> issuing this I/O.
>
> >  0  0      0 3583780    332 195060    0    0     0   494  555 1080  0  1 99  0
> >  0  0      0 3584352    332 195060    0    0     0    99  347  559  0  0 99  0
> >  0  0      0 3585232    332 195060    0    0     0    11  301  621  0  0 99  0
> > -> disks go idle.
> >
> > So these patches do not seem to be the source of these excessive disk writes...
>
> Well, the patches I posted should prevent blocking in the places that it
> was seen, so if that does not stop the slowdowns then either the writeback
> code is not feeding us inodes fast enough or the block device below is
> having some kind of problem....

I don't think its the block device, because reading/writing larger
files do not seem to be troubled. It looks much more like an inode
problem. For example both installing and uninstalling kernel source
trees show these stalls, but during uninstalling this is much more
noticeable.

But I agree that this might not be xfs specific, as this showed up at
the same time as other people started reporting about the 100% iowait
bug. Could be that this is the same bug and the differences between
reiserfs and xfs might explain the iowait vs. idle. Or that I don't
see the 100% iowait is something else on my system...

Torsten
