Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32078 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751150AbdCMWec (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Mar 2017 18:34:32 -0400
Date: Mon, 13 Mar 2017 15:34:24 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v6A 00/19] xfs: online scrub support
Message-ID: <20170313223424.GK5281@birch.djwong.org>
References: <148918798893.6959.7972227235163150709.stgit@birch.djwong.org>
 <CAOQ4uxhAd673EKcWYFHD0JqDOfber5DxtiA984pt9BK0uZkkaw@mail.gmail.com>
 <CAOQ4uxgQqxxccovcG8=EQWfQtC79yWUEKCVVvxLBjgz6bR=2Vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgQqxxccovcG8=EQWfQtC79yWUEKCVVvxLBjgz6bR=2Vg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Sun, Mar 12, 2017 at 11:33:04AM +0200, Amir Goldstein wrote:
> On Sat, Mar 11, 2017 at 12:35 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> > On Sat, Mar 11, 2017 at 1:19 AM, Darrick J. Wong
> > <darrick.wong@oracle.com> wrote:
> >> Hi all,
> >>
> >> [Yes, this is a pre-LSFMM patch dump.]
> >>
> >> This is the sixth revision of a patchset that adds to XFS kernel support
> >> for online metadata scrubbing and repair.  There aren't any on-disk
> >> format changes.  Changes since v5 include bug fixes to the repair code
> >> to eliminate weird hangs and to do a better job of temporarily stopping
> >> access to the filesystem in the rare event that we need todo so to
> >> rebuild something.  For my own dogfooding amusement, I now perform
> >> automated periodic scans of the XFS filesystems on my development
> >> workstations, which (so far) haven't destroyed anything or blown up.
> >>
> >> Online scrub/repair support consists of four major pieces -- first, an
> >> ioctl that maps physical extents to their owners (GETFSMAP; queued for
> >> 4.12); second, various in-kernel metadata scrubbing ioctls to examine
> >> metadata records and cross-reference them with other filesystem
> >> metadata; third, an in-kernel mechanism for rebuilding damaged metadata
> >> objects and btrees; and fourth, a userspace component to coordinate
> >> scrubbing and repair operations.
> >>
> >> This new utility, xfs_scrub, is separate from the existing offline
> >> xfs_repair tool.  The program uses GETFSMAP and various XFS ioctls to
> >> iterate all XFS metadata and asks the kernel to check the metadata and
> >> repair it if necessary.
> >>
> >> Per reviewer request, the v6 patch series has been broken into four
> >> smaller series -- this first one to add the minimum code necessary to
> >> scrub objects; a second one to add the ability to cross reference with
> >> other metadata; a third one containing the rebuilding code; and a fourth
> >> series with the userspace tool code.
> >>
> >> If you're going to start using this mess, you probably ought to just
> >> pull from my git trees.  The kernel patches[1] should apply against
> >> 4.11-rc1.  xfsprogs[2] and xfstests[3] can be found in their usual
> >> places.  The git trees contain all four series' worth of changes.
> >>
> >> This is an extraordinary way to eat your data.  Enjoy!
> >> Comments and questions are, as always, welcome.
> >>
> >> --D
> >>
> >> [1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
> >> [2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
> >> [3] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=djwong-devel
> >
> > Hi Darrick,
> >
> > My first attempt to run the dengerous_scrub tests did not go so well.
> >
> > 1. For some reason, xfsprogs configure does not correctly detect that my system
> >     include files are missing FICLONE and friends, so had to manually add:
> > --- a/include/builddefs.in
> > +++ b/include/builddefs.in
> > @@ -178,6 +178,10 @@ ifeq ($(PKG_PLATFORM)_$(HAVE_SYS_GETFSMAP),linux_)
> >  PCFLAGS+= -DOVERRIDE_GETFSMAP
> >  endif
> >
> > +PCFLAGS+= -DOVERRIDE_FICLONE
> > +PCFLAGS+= -DOVERRIDE_FICLONERANGE
> > +PCFLAGS+= -DOVERRIDE_FIDEDUPERANGE
> > +PCFLAGS+= -DOVERRIDE_GETFSMAP
> >
> > I'll investigate this next week.
> >
> 
> This was my bad. needed make realclean.
> 
> > 2. On first attempt to run -g xfs/dengerous_scrub, 1378 triggered an
> > ASSERT, so modified:
> > --- a/fs/xfs/xfs_linux.h
> > +++ b/fs/xfs/xfs_linux.h
> > @@ -335,7 +335,7 @@ static inline __uint64_t howmany_64(__uint64_t x,
> > __uint32_t y)
> >
> >  #ifdef DEBUG
> >  #define ASSERT(expr)   \
> > -       (likely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
> > +       (likely(expr) ? (void)0 : asswarn(#expr, __FILE__, __LINE__))
> >
> > 3. Second attempt did not get much further. scratch mount wasn't able
> > to umount after 262
> >     (attached out.bad full and dmesg of this run)

This happens because we can call xfs_repair_fix_freelist prior to adding
the rmap for the AG headers; if fix_freelist wants to expand the AGFL it
has to add an rmap for the new AGFL blocks, but the xfs_rmap_map function
assumes that there will always be at least one record to the left of
wherever we're adding an rmap.  Not true in this case, and it won't be
true when we add rmap to realtime device.

In theory this should be fixed by this patch (from the realtime rmap patchset):
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?h=djwong-wtf&id=0bbf1483e0b59a29884e456946148d24a9d1d8ce

But it sounds like I ought to move it to the scrub patches...

> > 4. 3rd attempt, I just ran 350, it got a kernel page fault on logsunit fuzzing
> >     (attached full output and dmesg of this run)
> >
> 
> This page fault is reproducible on my system.
> 350 hits the page fault during logsunit middlebit verb, same as previous run.

Ugh, yes, logsunit fuzzing still totally breaks xfs...

Anyway, thanks for trying this out!

--D

> 
> This is my scratch setup (100GB LV on rotating drive):
> 
> $ xfs_info /mnt/scratch
> meta-data=/dev/mapper/storage-scratch isize=512    agcount=4,
> agsize=6553600 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1 spinodes=0 rmapbt=1
>          =                       reflink=1
> data     =                       bsize=4096   blocks=26214400, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> log      =internal               bsize=4096   blocks=12800, version=2
>          =                       sectsz=512   sunit=8 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> This is my kernel xfs config:
> 
> CONFIG_JFS_STATISTICS=y
> CONFIG_XFS_FS=m
> CONFIG_XFS_QUOTA=y
> CONFIG_XFS_POSIX_ACL=y
> CONFIG_XFS_RT=y
> CONFIG_XFS_DEBUG=y
> 
> 
> Do you need anymore info about my setup?
