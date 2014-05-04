Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5AEB07F3F
	for <xfs@oss.sgi.com>; Sun,  4 May 2014 01:19:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DDDACAC002
	for <xfs@oss.sgi.com>; Sat,  3 May 2014 23:18:57 -0700 (PDT)
Received: from skeena.net ([199.60.222.33]) by cuda.sgi.com with ESMTP id
	74ay0UAHT8iZKA6A (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 03 May 2014 23:18:52 -0700 (PDT)
Received: from innuk.localdomain (S01061caff7de9d56.gv.shawcable.net
	[184.66.28.75])
	(using SSLv3 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: felix@skeena.net)
	by skeena.net (Postfix) with ESMTPSA id 02185125BDA5
	for <xfs@oss.sgi.com>; Sat,  3 May 2014 23:18:52 -0700 (PDT)
Date: Sat, 3 May 2014 23:18:38 -0700
From: Marcel (Felix) Giannelia <info@skeena.net>
Subject: Re: xfs_iflush_int: Bad inode, xfs_do_force_shutdown from
	xfs_inode.c during file copy
Message-ID: <20140503231838.219df8ac@innuk.localdomain>
In-Reply-To: <20140504001746.GL26353@dastard>
References: <20140503124933.7ed0ff3e@innuk.localdomain>
	<20140504001746.GL26353@dastard>
Mime-Version: 1.0
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
To: xfs@oss.sgi.com

On Sun, 4 May 2014 10:17:46 +1000
Dave Chinner <david@fromorbit.com> wrote:

> > 
> > - Distribution & kernel version: Debian 7, uname -a returns:
> > 
> > Linux hostname 3.2.0-4-686-pae #1 SMP Debian 3.2.41-2+deb7u2 i686
> > GNU/Linux
> 
> So, old hardware...

Actually no, fairly new underlying hardware -- but this is for a
not-for-profit with no hardware budget, and that one new machine is
the exception. At the time they had a lot more 32-bit hardware lying
around to build spares with, so I built it to run on that if needed :)

> 
> > dmesg entries:
> > 
> > > Immediately after the cp command exited with "i/o error":
> > 
> > XFS (md126): xfs_iflush_int: Bad inode 939480132, ptr 0xd12fa080,
> > magic number 0x494d
> 
> The magic number has a single bit error in it.
> 
> #define XFS_DINODE_MAGIC                0x494e  /* 'IN' */
> 
> That's the in-memory inode, not the on-disk inode. It caught the
> problem before writing the bad magic number to disk - the in-memory
> disk buffer was checked immediately before the in-memory copy, and
> it checked out OK...
> 
> > After this, I ran xfs_repair with -L. xfs_repair noted the same bad
> > inode number and deleted the file I had tried to copy, but
> > otherwise made no changes that I could see. After this, the
> > filesystem mounted normally and there were no further issues.
> 
> What was the error that xfs_repair returned? There may have been
> other things wrong with the inode that weren't caught when it was
> loaded into memory.

Sorry; I didn't capture that output. From what I remember, the only
line different from a clean xfs_repair run was a line quite similar to
what was in the dmesg, about inode # 939480132.

> 
> However, I'd almost certainly be checking you hardware at this
> point, as software doesn't usually cause random single bit flips...

Yeah, going to take that server offline for a full memtest next time
I'm out there.

I also discovered that the third disk I mentioned from that RAID array
was actually having serious problems (hardware ECC recovery and
reallocated sectors through the roof), which explains the performance
issues it was causing -- and that disk was still part of the array
containing the root filesystem.

Since mdadm RAID1 reads from whichever individual disk is least busy
(and doesn't read from all disks in the array and compare, during
normal I/O), is it conceivable that this is what happened?:

Copying that file busied out the two healthy disks, which were both in
the array I was writing to. So of the three disks backing the root
filesystem, the only one not busy was the failing one. During the file
copy, some piece of code was needed that was not in the memory cache
and had to be read from disk, so mdadm read it from the failing drive,
which silently flipped a bit (or several).

A memory problem still seems more likely to me, as I wouldn't expect
the part of the xfs filesystem driver containing the definition of that
magic number to ever need to be re-read from disk after boot -- but I
don't know. Memory load on this system is always very high; there's
almost no room for cache, so maybe... And is there a definition of
that constant someplace that might only be needed when creating a file
bigger than 2 or 4 GB (a very infrequent operation on this filesystem)?

Thanks,

~Felix.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
