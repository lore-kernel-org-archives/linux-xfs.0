Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 022267F4E
	for <xfs@oss.sgi.com>; Wed, 27 Nov 2013 23:16:43 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E3E10304043
	for <xfs@oss.sgi.com>; Wed, 27 Nov 2013 21:16:39 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	JwHoxUJ4cznONTIV for <xfs@oss.sgi.com>;
	Wed, 27 Nov 2013 21:16:36 -0800 (PST)
Date: Thu, 28 Nov 2013 16:16:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Problem with mkfs.xfs on a regular file
Message-ID: <20131128051626.GM10988@dastard>
References: <20131127023119.GB13101@boogeyman> <20131127024713.GE10988@dastard>
	<5296ACFB.4030901@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5296ACFB.4030901@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Phil White <cerise-xfs@l.armory.com>, xfs@oss.sgi.com

On Wed, Nov 27, 2013 at 08:39:55PM -0600, Eric Sandeen wrote:
> On 11/26/13, 8:47 PM, Dave Chinner wrote:
> > On Tue, Nov 26, 2013 at 06:31:19PM -0800, Phil White wrote:
> >> Gents:
> >>
> >> I was making an image for a VM using everyone's favorite fs with a line
> >> that looked something like this:
> >> -------------
> >> dd if=/dev/zero of=~/image bs=1024 count=1048576 && ./mkfs/mkfs.xfs && mount -o loop ~/image /mnt/loop
> >> -------------
> >>
> >>
> >> mkfs.xfs gave me this output:
> >> -------------
> >> meta-data=/root/image            isize=256    agcount=4, agsize=65536 blks
> >>          =                       sectsz=512   attr=2, projid32bit=0
> >> data     =                       bsize=4096   blocks=262144, imaxpct=25
> >>          =                       sunit=0      swidth=0 blks
> >> naming   =version 2              bsize=4096   ascii-ci=0
> >> log      =internal log           bsize=4096   blocks=2560, version=2
> >>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> >> realtime =none                   extsz=4096   blocks=0, rtextents=0
> >> existing superblock read failed: Invalid argument
> >> mkfs.xfs: pwrite64 failed: Invalid argument
> >> mkfs.xfs: read failed: Invalid argument
> >> -------------
> > .....
> >>
> >> While it occurred to me that the problem might just be line 806 of some files
> >> in xfsprogs, I threw it under a debugger and took a closer look.  The file
> >> descriptor value in xi->dfd pointed at ~/image.  errno was set to 22.  I
> >> thought that might indicate a problem with lseek(), so I rewrote the pwrite64()
> >> and pread() as lseek()s and read()/write()
> >>
> >> As you may have guessed, this did me no good at all.
> >>
> >> It's trying to read/write 512 bytes at the beginning of the file which seems
> >> reasonably innocuous.  I double checked the man page which says that under
> >> 2.6, O_DIRECT writes can be aligned to 512 bytes without a problem.
> > 
> > That doesn't mean it is correct, because the man page also says:
> > 
> > " In Linux alignment restrictions vary by filesystem and kernel
> > version and might be absent entirely."
> > 
> > So, I bet that your underlying filesystem (i.e. the host filesystem)
> > has a sector size of 4k, and that's why direct Io on 512 byte
> > alignment is failing. In that case, run "mkfs.xfs -s size=4k ..."
> > and mkfs should just work fine...
> 
> Sadly, no.  Or at least, probably not.
> 
> __initbuf
> 	memalign(libxfs_device_alignment(), bytes);
> 
> where libxfs_device_alignment() does:

Yeah, that's for memory buffer alignment, though, not IO alignment.
It's busted because that should always default to page size, not
sector size. But that's not the problem - for example:

# xfs_info /storage
meta-data=/dev/md0               isize=256    agcount=32, agsize=21503744 blks
         =                       sectsz=4096  attr=2, projid32bit=0
         =                       crc=0
data     =                       bsize=4096   blocks=688119680, imaxpct=5
         =                       sunit=32     swidth=320 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=335995, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

That's a 4k sector filesystem, and:

# dd if=/dev/zero of=/storage/fubar.img bs=1024 count=1048576 && mkfs.xfs -d file,size=1g,name=/storage/fubar.img
1048576+0 records in
1048576+0 records out
1073741824 bytes (1.1 GB) copied, 4.18106 s, 257 MB/s
meta-data=/storage/fubar.img     isize=256    agcount=4, agsize=65536 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0
data     =                       bsize=4096   blocks=262144, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=7344, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
#

mkfs works fine on it. As does xfs_repair:

# xfs_repair -f /storage/fubar.img
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 1
        - agno = 0
        - agno = 2
        - agno = 3
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...

And xfs_db works just fine, too:

$ sudo xfs_db -f /storage/fubar.img
xfs_db> sb 0
xfs_db> p
magicnum = 0x58465342
blocksize = 4096
dblocks = 262144
rblocks = 0
rextents = 0
uuid = 73d16c96-df35-4f1f-b781-34da486f089c
logstart = 131076
rootino = 128
rbmino = 129
....

because it doesn't set the LIBXFS_DIRECT flag on the device
instantiation structures yet and so is using buffered IO.

> IOWS: xfsprogs is a braindead package that doesn't know how to
> properly handle non-512-aligned DIO.  ;)  </snark>

Yeah, it doesn't know how to handle it but it avoids the problem
completely by using buffered IO instead. It works just fine. ;)

So, let's recreate the problem knowing that:

$ sudo dd if=/dev/zero of=/storage/fubar.img bs=1024 count=1048576 && sudo strace -f -o t.t mkfs.xfs -d size=1g,name=/storage/fubar.img
1048576+0 records in
1048576+0 records out
1073741824 bytes (1.1 GB) copied, 4.52546 s, 237 MB/s
meta-data=/storage/fubar.img     isize=256    agcount=4, agsize=65536 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0
data     =                       bsize=4096   blocks=262144, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=7344, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
mkfs.xfs: pwrite64 failed: Invalid argument
mkfs.xfs: read failed: Invalid argument

So, it failed to write using direct IO because of IO alignment
because I didn't tell mkfs that it was running on a file. i.e. I
forgot the "-d file" option.

$ sudo mkfs.xfs -d size=1g,name=/storage/fubar.img
meta-data=/storage/fubar.img     isize=256    agcount=4, agsize=65536 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0
data     =                       bsize=4096   blocks=262144, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=7344, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
mkfs.xfs: pwrite64 failed: Invalid argument
mkfs.xfs: read failed: Invalid argument

Yup, still fails. Let's force it!

$ sudo mkfs.xfs -f -d size=1g,name=/storage/fubar.img
meta-data=/storage/fubar.img     isize=256    agcount=4, agsize=65536 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0
data     =                       bsize=4096   blocks=262144, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=7344, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
existing superblock read failed: Invalid argument
mkfs.xfs: pwrite64 failed: Invalid argument
mkfs.xfs: read failed: Invalid argument

And there's the identical failure to what was reported.

So, user error - the user is telling mkfs.xfs that it is making a
filesystem on a block device named "/storage/fubar.img".  The same
thing happens with the normal method of specifying the block device:

sudo mkfs.xfs -f -d size=1g /storage/fubar.img
meta-data=/storage/fubar.img     isize=256    agcount=4, agsize=65536 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=0
data     =                       bsize=4096   blocks=262144, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=7344, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
existing superblock read failed: Invalid argument
mkfs.xfs: pwrite64 failed: Invalid argument
mkfs.xfs: read failed: Invalid argument

But if we remove the image file:

$ sudo mkfs.xfs -f -d size=1g /storage/fubar.img
/storage/fubar.img: No such file or directory
Usage: mkfs.xfs
....

It's pretty clear that we need the "-d file" when the file doesn't
actually exist.

IOWs, mkfs does not expect a block device to lie about it's sector
sizes, but that's exactly what treating an image file like a block
device leads to. This isn't the DIO sector size problem you were
looking for, Eric ;)

FWIW, an strace shows:

12256 ioctl(3, BLKDISCARD, 0x7fff76f4ea50) = -1 ENOTTY (Inappropriate ioctl for device)

... that we make that same mistake in several places in mkfs.

What mkfs needs to do is reject devices that are files when "-d
file", "-l file" and "-r file" is not specified, and the problem
will go away because it will catch users who forget to tell mkfs
that it is supposed to be operating on an image file...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
