Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 637AF7F52
	for <xfs@oss.sgi.com>; Sun,  4 May 2014 16:40:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2D9048F8039
	for <xfs@oss.sgi.com>; Sun,  4 May 2014 14:40:02 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	MenWi1kUDVOAzVjr for <xfs@oss.sgi.com>;
	Sun, 04 May 2014 14:39:56 -0700 (PDT)
Date: Mon, 5 May 2014 07:39:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_iflush_int: Bad inode, xfs_do_force_shutdown from
	xfs_inode.c during file copy
Message-ID: <20140504213941.GN26353@dastard>
References: <20140503124933.7ed0ff3e@innuk.localdomain>
	<20140504001746.GL26353@dastard>
	<20140503231838.219df8ac@innuk.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140503231838.219df8ac@innuk.localdomain>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Marcel Giannelia <info@skeena.net>
Cc: xfs@oss.sgi.com

On Sat, May 03, 2014 at 11:18:38PM -0700, Marcel Giannelia wrote:
> On Sun, 4 May 2014 10:17:46 +1000
> Dave Chinner <david@fromorbit.com> wrote:
> 
> > > 
> > > - Distribution & kernel version: Debian 7, uname -a returns:
> > > 
> > > Linux hostname 3.2.0-4-686-pae #1 SMP Debian 3.2.41-2+deb7u2 i686
> > > GNU/Linux
> > 
> > So, old hardware...
> 
> Actually no, fairly new underlying hardware -- but this is for a
> not-for-profit with no hardware budget, and that one new machine is
> the exception. At the time they had a lot more 32-bit hardware lying
> around to build spares with, so I built it to run on that if needed :)

OK. If it were me, I would run a x86-64 kernel with a 32 bit
userspace rather than put up with all the highmem weirdness of a
686-pae kernel...

> > > dmesg entries:
> > > 
> > > > Immediately after the cp command exited with "i/o error":
> > > 
> > > XFS (md126): xfs_iflush_int: Bad inode 939480132, ptr 0xd12fa080,
> > > magic number 0x494d
> > 
> > The magic number has a single bit error in it.
> > 
> > #define XFS_DINODE_MAGIC                0x494e  /* 'IN' */
> > 
> > That's the in-memory inode, not the on-disk inode. It caught the
> > problem before writing the bad magic number to disk - the in-memory
> > disk buffer was checked immediately before the in-memory copy, and
> > it checked out OK...
...
> > However, I'd almost certainly be checking you hardware at this
> > point, as software doesn't usually cause random single bit flips...
> 
> Yeah, going to take that server offline for a full memtest next time
> I'm out there.
> 
> I also discovered that the third disk I mentioned from that RAID array
> was actually having serious problems (hardware ECC recovery and
> reallocated sectors through the roof), which explains the performance
> issues it was causing -- and that disk was still part of the array
> containing the root filesystem.

Ok, so it may be that the error came from disk in the first place.
The kernel you are running is old enough that it doesn't rigourously
check every inode that is read from disk, so maybe it slipped
through and was only caught by the writeback checks.


> A memory problem still seems more likely to me, as I wouldn't expect
> the part of the xfs filesystem driver containing the definition of that
> magic number to ever need to be re-read from disk after boot

The magic number is in every inode that is allocated on disk...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
