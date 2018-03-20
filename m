Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:62894 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753091AbeCTNIG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Mar 2018 09:08:06 -0400
Date: Wed, 21 Mar 2018 00:08:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Question about XFS_MAXINUMBER
Message-ID: <20180320130803.GQ18129@dastard>
References: <CAOQ4uxhubJhspfj+x7yRkTJ4rUXyhZoF0x3kjuFyv-0=Lxrctw@mail.gmail.com>
 <CAOQ4uxh0H8mbbAZt0MEdLGRY-8Aqg2c9UFM56-KL2b90fLYCFQ@mail.gmail.com>
 <20180317212814.GI7000@dastard>
 <CAOQ4uxit=nHvd2C080QeM27icSFra+0Anwu8vXqs4sd=8tCCNg@mail.gmail.com>
 <20180318230259.GJ7000@dastard>
 <CAOQ4uxiHkW41RB4LogWi8+rp_NhoC+SHGNY9_ShdQi7OyJTTVA@mail.gmail.com>
 <20180320014709.GC1150@dastard>
 <CAOQ4uxh+90vyCOqhLXtNi0U+YTsi6nCYuZFJMPhBWUaRwSBDvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh+90vyCOqhLXtNi0U+YTsi6nCYuZFJMPhBWUaRwSBDvQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Mar 20, 2018 at 08:29:35AM +0200, Amir Goldstein wrote:
> On Tue, Mar 20, 2018 at 3:47 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Mon, Mar 19, 2018 at 06:03:30AM +0200, Amir Goldstein wrote:
> [...]
> >> Well, it is not an assumption if filesystem is inclined to publish
> >> s_max_ino_bits, which is not that different in concept from publishing
> >> s_maxbytes and s_max_links, which are also limitations in current
> >> kernel/sb that could be lifted in the future.
> >
> > It is different, because you're expecting to be able to publish
> > persistent user visible information based on it.
> >
> > If we change s_max_ino_bits in the underlying filesystem, then
> > overlay inode numbers change and that can cause all sorts of problem
> > with things like filehandles, backups that use dev/inode number
> > tuples to detect identical files, etc.  i.e. there's a heap of
> > downstream impacts of changing inode numbers. If we have to
> > publish s_max_ino_bits to the VFS, we essentially fix the ABI of the
> > user visible inode number the filesysetm publishes. IOWs, we
> > effectively can't change it without breaking external users.
> >
> 
> You are right.
> 
> > I suspect you don't realise we already expose the full 64 bit
> > inode number space completely to userspace through other ABIs. e.g.
> > the bulkstat ioctls. We've already got applications that use the XFS
> > inode number as a 64 bit value both to and from the kernel (e.g.
> > xfs_dump, file handle encoding, etc), so the idea that we can now
> > take bits back from what we've already agreed to expose to userspace
> > is fraught with problems.
> 
> I'm sorry. There must be something I am missing.
> Are users exposed to high ino bits via xfs tools other than NULLFSINO
> NULLAGINO? If they are then I did not find where.
> And w.r.t to NULLINO (-1), that ino is not exposed via getattr() and readdir(),
> so not a problem for overlayfs.

Bulkstat exposes the on-disk inode number directly to userspace, and
other ioctls take those inode numbers back in as ioctl parameters
(e.g.  as bulkstat iteration cookies) and as part of userspce
constructed filehandles (i.e. in libhandle, xfs_fsr, xfsdump, etc).
The filehandles are explicitly encoded with 64 bit inode numbers....

> > That's the problem I see here - it's not that we /can't/ implement
> > s_max_ino_bits, the problem is that once we publish it we can't
> > change it because it will cause random breakage of applications
> > using it. And because we've already effectively published it to
> > userspace applications as s_max_ino_bits = 64, there's no scope for
> > movement at all.
> >
> 
> Agreed. So we can add an explicit compat feature bit to declare that user
> would like to limit future use of high ino bits on his fs.
> Makes me wonder, how come there is no feature to block "inode64"
> mount option, so user can declare he wishes to keep the fs fully
> compatible for mounting on 32bit systems?

Because inode64 was the original mechanism for allocating inodes.
inode32 was introduced years after XFS was first shipped. You need
to go ask the old Irix engineers why they implemented inode32 as a
mount option and not an on-disk feature flag and created the mess
that is the inode32 mount option.

These days, inode32 reads 64 bit inode just fine - it just can't
create new 64 bit inode numbers.  And if you *really* still need
only 32 bit inodes in this day and age, there's that old xfs_reno
tool:

http://xfs.org/index.php/Unfinished_work#The_xfs_reno_tool

CHeers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
