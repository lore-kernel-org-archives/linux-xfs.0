Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BF53B7F74
	for <xfs@oss.sgi.com>; Wed, 14 Aug 2013 01:20:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 56FEFAC004
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 23:20:48 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	GDiFnapmcvV9EeVW for <xfs@oss.sgi.com>;
	Tue, 13 Aug 2013 23:20:46 -0700 (PDT)
Date: Wed, 14 Aug 2013 16:20:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Failure growing xfs with linux 3.10.5
Message-ID: <20130814062041.GB12779@dastard>
References: <52073905.8010608@allmail.net> <5207D9C4.7020102@sandeen.net>
	<52090C6C.6060604@allmail.net> <20130813000453.GQ12779@dastard>
	<520A5132.6090608@allmail.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <520A5132.6090608@allmail.net>
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
To: Michael Maier <m1278468@allmail.net>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Tue, Aug 13, 2013 at 05:30:58PM +0200, Michael Maier wrote:
> Dave Chinner wrote:
> > [ re-ccing the list, because finding this is in everyone's interest ]
> > 
> > On Mon, Aug 12, 2013 at 06:25:16PM +0200, Michael Maier wrote:
> >> Eric Sandeen wrote:
> >>> On 8/11/13 2:11 AM, Michael Maier wrote:
> >>>> Hello!
> >>>>
> >>>> I think I'm facing the same problem as already described here:
> >>>> http://thread.gmane.org/gmane.comp.file-systems.xfs.general/54428
> >>>
> >>> Maybe you can try the tracing Dave suggested in that thread?
> >>> It certainly does look similar.
> >>
> >> I attached a trace report while executing xfs_growfs /mnt on linux 3.10.5 (does not happen with 3.9.8).
> >>
> >> xfs_growfs /mnt
> >> meta-data=/dev/mapper/backupMy-daten3 isize=256    agcount=42, agsize=7700480 blks
> >>          =                       sectsz=512   attr=2
> >> data     =                       bsize=4096   blocks=319815680, imaxpct=25
> >>          =                       sunit=0      swidth=0 blks
> >> naming   =version 2              bsize=4096   ascii-ci=0
> >> log      =internal               bsize=4096   blocks=60160, version=2
> >>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> >> realtime =none                   extsz=4096   blocks=0, rtextents=0
> >> xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Structure needs cleaning
> >> data blocks changed from 319815680 to 346030080
> >>
> >> The entry in messages was:
> >>
> >> Aug 12 18:09:50 dualc kernel: [  257.368030] ffff8801e8dbd400: 58 46 53 42 00 00 10 00 00 00 00 00 13 10 00 00  XFSB............
> >> Aug 12 18:09:50 dualc kernel: [  257.368037] ffff8801e8dbd410: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >> Aug 12 18:09:50 dualc kernel: [  257.368042] ffff8801e8dbd420: 46 91 c6 80 a9 a9 4d 8c 8f e2 18 fd e8 7f 66 e1  F.....M.......f.
> >> Aug 12 18:09:50 dualc kernel: [  257.368045] ffff8801e8dbd430: 00 00 00 00 04 00 00 04 00 00 00 00 00 00 00 80  ................
> >> Aug 12 18:09:50 dualc kernel: [  257.368051] XFS (dm-33): Internal error xfs_sb_read_verify at line 730 of file
> >> /daten2/tmp/rpm/BUILD/kernel-desktop-3.10.5/linux-3.10/fs/xfs/xfs_mount.c.  Caller 0xffffffffa099a2fd
> > .....
> >> Aug 12 18:09:50 dualc kernel: [  257.368533] XFS (dm-33): Corruption detected. Unmount and run xfs_repair
> >> Aug 12 18:09:50 dualc kernel: [  257.368611] XFS (dm-33): metadata I/O error: block 0x3ac00000 ("xfs_trans_read_buf_map") error 117 numblks 1
> >> Aug 12 18:09:50 dualc kernel: [  257.368623] XFS (dm-33): error 117 reading secondary superblock for ag 16
> > 
> > Ok, so that's reading the secondary superblock for AG 16. You're
> > growing the filesystem from 42 to 45 AGs, so this problem is not
> > related to the actual grow operation - it's tripping over a problem
> > that already exists on disk before the grow operation is started.
> > i.e. this is likely to be a real corruption being seen, and it
> > happened some time in the distant past and so we probably won't ever
> > be able to pinpoint the cause of the problem.
> > 
> > That said, let's have a look at the broken superblock. Can you post
> > the output of the commands:
> > 
> > # xfs_db -r -c "sb 16" -c p <dev>
> 
> done after the failed growfs mentioned above:

Looks fine....

> > and
> > 
> > # xfs_db -r -c "sb 16" -c "type data" -c p <dev>
> 
> 000: 58465342 00001000 00000000 13100000 00000000 00000000 00000000 00000000
> 020: 4691c680 a9a94d8c 8fe218fd e87f66e1 00000000 04000004 00000000 00000080
> 040: 00000000 00000081 00000000 00000082 00000001 00758000 0000002a 00000000
> 060: 0000eb00 b4a40200 01000010 00000000 00000000 00000000 0c090804 17000019
> 080: 00000000 00001940 00000000 00000277 00000000 001126ba 00000000 00000000
> 0a0: 00000000 00000000 00000000 00000000 00000000 00000002 00000000 00000000
> 0c0: 00000000 00000001 0000000a 0000000a 8f980320 73987e9e db829704 ef73fe2e
> 0e0: 8f980320 73987e9e db829704 ef73fe2e 8f980320 73987e9e db829704 ef73fe2e
> 100: 8f980320 73987e9e db829704 ef73fe2e 8f980320 73987e9e db829704 ef73fe2e
> 120: 8f980320 73987e9e db829704 ef73fe2e 8f980320 73987e9e db829704 ef73fe2e
> 140: 8f980320 73987e9e db829704 ef73fe2e 8f980320 73987e9e db829704 ef73fe2e
> 160: 8f980320 73987e9e db829704 ef73fe2e 8f980320 73987e9e db829704 ef73fe2e
> 180: 8f980320 73987e9e db829704 ef73fe2e 8f980320 73987e9e db829704 ef73fe2e
> 1a0: 8f980320 73987e9e db829704 ef73fe2e 8f980320 73987e9e db829704 ef73fe2e
> 1c0: 8f980320 73987e9e db829704 ef73fe2e 8f980320 73987e9e db829704 ef73fe2e
> 1e0: 8f980320 73987e9e db829704 ef73fe2e 8f980320 73987e9e db829704 ef73fe2e

There's your problem - the empty space in the superblock is supposed
to be zero. mkfs zeros it and we rely on it being zero for various
reasons.

And one of those reasons is that we use the fact it shoul dbe zero
to determine if we should be checking the CRC of the superblock.
That is if there's a single bit error in the superblock and we are
missing the correct bit in the version numbers that say CRCs are
enabled, we use the fact that the superblock CRC field - which your
filesystem knowns nothing about - should be zero to validate that
the CRC feature bit is correctly set. The above superblock will
indicate that there is a CRC set on the superblock, find the
necessary version number is not correct, and so therefore we have a
corruption in that superblock that the kernel code cannot handle
without a user telling it what is correct.

So, the fact grwofs is failing is actually the correct behaviour for
the filesystem to have in this case - the superblock is corrupt,
just not obviously so.

> > so we can see the exact contents of that superblock?
> > 
> > FWIW, how many times has this filesystem ben grown?
> 
> I can't say for sure, about 4 or 5 times?
> 
> > Did it start
> > with only 32 AGs (i.e. 10TB in size)?
> 
> 10TB? No. The device just has 3 TB. You most probably meant 10GB?
> I'm not sure, but it definitely started with > 100GB.

I misplaced a digit A block size of 4096 bytes and:

    agcount=42, agsize=7700480 blks

So the filesystem size is 42 * 7700480 * 4096 = 1.26TB.

The question I'm asking is how many AGs did the filesystem start
with, because this:

commit 1375cb65e87b327a8dd4f920c3e3d837fb40e9c2
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Oct 9 14:50:52 2012 +1100

    xfs: growfs: don't read garbage for new secondary superblocks
    
    When updating new secondary superblocks in a growfs operation, the
    superblock buffer is read from the newly grown region of the
    underlying device. This is not guaranteed to be zero, so violates
    the underlying assumption that the unused parts of superblocks are
    zero filled. Get a new buffer for these secondary superblocks to
    ensure that the unused regions are zero filled correctly.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

Is the only possible reason I can think of that would result in
non-zero empty space in a secondary superblock. And that implies
that the filesystem started with 16 AGs or less, and was grown with
an older kernel with this bug in it.

If it makes you feel any better, the bug that caused this had been
in the code for 15+ years and you are the first person I know of to
have ever hit it....

xfs_repair doesn't appear to have any checks in it to detect this
situation or repair it - there are some conditions for zeroing the
unused parts of a superblock, but they are focussed around detecting
and correcting damage caused by a buggy Irix 6.5-beta mkfs from 15
years ago.

Hence looks like we'll need some new xfs_repair functionality to fix
this. It might take me a little while to get you a fix - perhaps
someone else with a little bit of spare time could get it done
sooner than I can. Anyone?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
