Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 23 Sep 2007 02:24:57 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8N9OoQ3031430
	for <xfs@oss.sgi.com>; Sun, 23 Sep 2007 02:24:52 -0700
Date: Sun, 23 Sep 2007 19:24:44 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: something very strange w/ filestreams...
Message-ID: <20070923092444.GQ995458@sgi.com>
References: <46F49C80.60007@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F49C80.60007@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Sep 21, 2007 at 11:39:28PM -0500, Eric Sandeen wrote:
> if I do:
> 
> for I in 173 174 178; do ./check $I; done
> 
> it's not terribly interesting, things seem to go ok, just normal
> filestreams failures ;-)
> 
> if I do:
> 
> ./check 173 174 178
> 
> things go very badly; the very first repair in 178 finds a horribly
> corrupted filesystem, and repair tips over (memory appears corrupted, as
> witnessed by):

Well, i get:

budgie:~/dgc/xfstests # ./check -l 173 174 178
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/ia64 budgie 2.6.23-rc4-dgc-xfs
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sdb9
MOUNT_OPTIONS -- /dev/sdb9 /mnt/scratch

173 75s ...
174 16s ...
178     *** glibc detected *** /sbin/xfs_repair: double free or corruption (!prev): 0x600000000000ebc0 ***
======= Backtrace: =========
/lib/libc.so.6.1[0x20000000001a2f50]
/lib/libc.so.6.1(__libc_free+0x15f0e8)[0x20000000001a6ce0]
/sbin/xfs_repair[0x40000000000320e0]
/sbin/xfs_repair[0x4000000000043a90]
/sbin/xfs_repair[0x400000000006d230]
/lib/libc.so.6.1(__libc_start_main+0xb4018)[0x20000000000fbc20]
/sbin/xfs_repair[0x4000000000003520]
======= Memory map: ========
.....

Just executing ./check -l 174 178 isn't sufficient, but
./check -l 172 174 178 triggers it. 172,173,178 does not
trigger it, so it's something to do with test 174 running after
another filestreams test but before 178.

Well, what does test 178 do? Oh, it mkfs's a new filesystem on
the scratch device and then hoses the superblock and tries to
use secondary superblocks to reconstruct it successfully.

I'm guessing that it is finding a superblock from a previous test
and incorrectly using that, finding stuff all nasty and inconsistent
due to the more recent mkfs....

Given this error:

bad length 156382 for agf 0, should be LENGTH
bad length # 156382 for agi 0, should be LENGTH

I think that is what is happening - those messages only come up
when teh agf/agi lengths don't match the superblock, and that points
to using the wrong superblock for recovery.

Especially as:

# mkfs.xfs -f /dev/sdb9
meta-data=/dev/sdb9              isize=256    agcount=8, agsize=156382 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=1251056, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=2560, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

An AG length of 156382 is correct.

Hmmm - just a plain:

# ./check -l 172 174 ; mkfs.xfs -f /dev/sdb9; dd if=/dev/zero of=/dev/sdb9 bs=512 count=1 ; xfs_repair /dev/sdb9

reproduces the problem.

Barry - I think xfs_repair might be finding the incorrect superblock
for the repair. Tests 172, 173 and 174 use less than the whole disk,
so there are going to be stale superblocks all over the place....

> hm, no zone name, length of 0x22222274?
> 
> I already provided a metadump image to Barry, but I wonder why the
> timing(?) seems to make a difference here... first sign of things going
> awry in repair is:
> 
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
> bad length 131072 for agf 0, should be 4096
> bad length # 131072 for agi 0, should be 4096

Yes - test 173 uses 1GB filesystem with 64x16MB AGs - 4096 * 4k block
size = 16MB AG. definitely looks like a stale superblock being
found.

Barry, I think that the secondary superblock needs better verification
(e.g. that there really are AG headers where the sb says there
are supposed to be and all the lengths match up).

Eric - you can relax. Filestreams is not hosing your filesystem; xfs_reapir
is....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
