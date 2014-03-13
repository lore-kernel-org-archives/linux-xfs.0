Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 85BCD7F3F
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 09:48:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 71FA5304043
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 07:48:02 -0700 (PDT)
Received: from mx11.netapp.com (mx11.netapp.com [216.240.18.76]) by
	cuda.sgi.com with ESMTP id 5ZC3ZBDMpmicomLL (version=TLSv1
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Mar 2014 07:47:59 -0700 (PDT)
From: "Mears, Morgan" <Morgan.Mears@netapp.com>
Subject: RE: Possible XFS bug encountered in 3.14.0-rc3+
Date: Thu, 13 Mar 2014 14:47:58 +0000
Message-ID: <33A0129EBFD46748804DE81B354CA1B21C0DDBAE@SACEXCMBX06-PRD.hq.netapp.com>
References: <33A0129EBFD46748804DE81B354CA1B21C0DC77A@SACEXCMBX06-PRD.hq.netapp.com>
	<20140312230241.GE6851@dastard>
In-Reply-To: <20140312230241.GE6851@dastard>
Content-Language: en-US
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Mar 12, 2014 at 07:03:14PM -0400, Dave Chinner wrote:
> On Wed, Mar 12, 2014 at 08:14:32PM +0000, Mears, Morgan wrote:
>> Hi,
>> 
>> Please CC me on any responses; I don't subscribe to this list.
>> 
>> I ran into a possible XFS bug while doing some Oracle benchmarking.  My test
>> system is running a 3.14.0-rc3+ kernel built from the for-next branch of
>> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git
>> on 2014-02-19 (last commit 1342f11e713792e53e4b7aa21167fe9caca81c4a).
>> 
>> The XFS instance in question is 200 GB and should have all default
>> parameters (mkfs.xfs /dev/mapper/<my_lun_partition>).  It contains Oracle
>> binaries and trace files.  At the time the issue occurred I had been
>> running Oracle with SQL*NET server tracing enabled.  The affected XFS
>> had filled up 100% with trace files several times; I was periodically
>> executing rm -f * in the trace file directory, which would reduce the
>> file system occupancy from 100% to 3%.  I had an Oracle load generating
>> tool running, so new log files were being created with some frequency.
>> 
>> The issue occurred during one of my rm -f * executions; afterwards the
>> file system would only produce errors.  Here is the traceback:
>> 
>> [1552067.297192] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1602 of file fs/xfs/xfs_alloc.c.  Caller 0xffffffffa04c4905
> 
> So, freeing a range that is already partially free. The problem
> appears to be in AG 15, according to the repair output.
> 
>> https://dl.dropboxusercontent.com/u/31522929/xfs-double-free-xfs_metadump-before-repair.gz
> 
> AGF 15 is full:
> 
> xfs_db> agf 15
> xfs_db> p
> magicnum = 0x58414746
> versionnum = 1
> seqno = 15
> length = 3276783
> bnoroot = 1
> cntroot = 2
> bnolevel = 1
> cntlevel = 1
> flfirst = 0
> fllast = 3
> flcount = 4
> freeblks = 1
> longest = 1
> btreeblks = 0
> uuid = 00000000-0000-0000-0000-000000000000
> lsn = 0
> crc = 0
> 
> And the one free block (other than the minimum 4 on teh AGFL) is:
> 
> xfs_db> p
> magic = 0x41425442
> level = 0
> numrecs = 1
> leftsib = null
> rightsib = null
> recs[1] = [startblock,blockcount] 1:[3119876,1]
> 
> But:
> 
> data fork in ino 940862056 claims dup extent, off - 11, start - 58836692, cnt 1
> correcting nextents for inode 940862056
> bad data fork in inode 940862056
> would have cleared inode 940862056
> 
> the block number here is in AG 14, which has much more free space:
> 
> xfs_db> p
> magicnum = 0x58414746
> versionnum = 1
> seqno = 14
> length = 3276783
> bnoroot = 1
> cntroot = 2
> bnolevel = 1
> cntlevel = 1
> flfirst = 42
> fllast = 45
> flcount = 4
> freeblks = 2092022
> longest = 2078090
> btreeblks = 0
> 
> which is in 2 extents:
> 
> xfs_db> a bnoroot
> xfs_db> p
> magic = 0x41425442
> level = 0
> numrecs = 2
> leftsib = null
> rightsib = null
> recs[1-2] = [startblock,blockcount] 1:[102466,13932] 2:[116476,2078090]
> xfs_db> convert agno 14 agbno 102466 fsb
> 0x3819042 (58822722)
> xfs_db> convert agno 14 agbno 116476 fsb
> 0x381c6fc (58836732)
> 
> and so 58836692 is just short of the second free space. Looking at
> all the other dup extent claims, they a remostly adjacent to the
> left edge of these two free spaces. No surprise - that's the way
> allocation occurs.
> 
> So, we've got a state where the allocation btree contains a
> corruption, so a shutdown occurs. The log has captured that
> corruption when it was made, so log recovery reintroduces that
> corruption. And so when the extent is freed after log recovery, the
> corruption is tripped over again.
> 
> There's two checkpoints in the log, both very small. The last
> modification to AGI 14 is there before it:
> 
> BUF: cnt:2 total:2 a:0x669350 len:24 a:0x6693d0 len:128 
>         BUF:  #regs:2   start blkno:0x15dff891   len:1   bmap size:1   flags:0x2800
>         AGF Buffer: (XAGF)
>             ver:1  seq#:14  len:3276783  
>             root BNO:1  CNT:2
>             level BNO:1  CNT:1
>             1st:42  last:45  cnt:4  freeblks:2092020  longest:2078090
> 
> As is the freespace btree buffer modification:
> 
> BUF: cnt:2 total:2 a:0x669460 len:24 a:0x6694e0 len:128 
>         BUF:  #regs:2   start blkno:0x15dff898   len:8   bmap size:1   flags:0x2000
>         BUF DATA
>  0 42544241  4000000 ffffffff ffffffff cb620100  1000000 fc7c0100  2000000 
>    magic = BTBA
>    level = 0
>    numrecs = 4
>    leftsib = NULLFSBLOCK
>    rightsib = NULLFSBLOCK
>    rec[0] = 0x162cb, 1 (90827,1)
>    rec[1] = 0x17cfc, 2 (97532,1)
>  8 47900100 67360000 fcc60100 8ab51f00 71ff3100  5000000 71ff3100  5000000 
>    rec[2] = 0x19047, 0x3667 (102471,13927)
>    rec[3] = 0x1c6fc, 0x1fb58a (116476,2078090)
> 
> so, from the pre-recovery case above, we've got two new freespaces
> in rec[0-1], rec[2] has 5 blocks removed from the left edge, and
> rec[3] is unchanged.
> 
> Confirming the ABTC buffer contains the same extents:
> 
> BUF: cnt:2 total:2 a:0x669570 len:24 a:0x6695f0 len:128 
>         BUF:  #regs:2   start blkno:0x15dff8a0   len:8   bmap size:1   flags:0x2000
>         BUF DATA
>  0 43544241  4000000 ffffffff ffffffff cb620100  1000000 fc7c0100  2000000 
>    magic = CTBA
>    level = 0
>    numrecs = 4
>    leftsib = NULLFSBLOCK
>    rightsib = NULLFSBLOCK
>    rec[0] = 0x162cb, 1 (90827,1)
>    rec[1] = 0x17cfc, 2 (97532,1)
>  8 47900100 67360000 fcc60100 8ab51f00 71ff3100  5000000 71ff3100  5000000 
>    rec[2] = 0x19047, 0x3667 (102471,13927)
>    rec[3] = 0x1c6fc, 0x1fb58a (116476,2078090)
> 10  8ca0100  8000000 71ff3100  5000000 71ff3100  5000000 71ff3100  5000000 
> 18 71ff3100  5000000 71ff3100  5000000 71ff3100  5000000 71ff3100  5000000 
> 
> It does. So the btrees contain consistent information, and so it's
> unlikely that we have a free space btree corruption in the log. So
> let's look at what was freed:
> 
> The EFI/EFDs in the log are:
> 
> EFI: cnt:1 total:1 a:0x668670 len:32 
>         EFI:  #regs:1    num_extents:1  id:0xffff881496024af0
>         (s: 0x38162cb, l: 1) 
> EFD: cnt:1 total:1 a:0x6684d0 len:32 
>         EFD:  #regs: 1    num_extents: 1  id: 0xffff881496024af0
> ....
> EFI: cnt:1 total:1 a:0x667da0 len:32 
>         EFI:  #regs:1    num_extents:1  id:0xffff8814960244b0
>         (s: 0x3817cfc, l: 1) 
> EFD: cnt:1 total:1 a:0x65fbd0 len:32 
>         EFD:  #regs: 1    num_extents: 1  id: 0xffff8814960244b0
> ....
> EFI: cnt:1 total:1 a:0x669250 len:32 
>         EFI:  #regs:1    num_extents:1  id:0xffff881496024000
>         (s: 0x3817cfd, l: 1) 
> EFD: cnt:1 total:1 a:0x6692d0 len:32 
>         EFD:  #regs: 1    num_extents: 1  id: 0xffff881496024000
> 
> These are all in ag#14, and have agbnos of 0x162cb, 0x17cfc and
> 0x17cfd. This corresponds exactly to the two new records in the AG
> btree. The one remaining EFI doesn't have an EFD in th elog, so this
> is what is being replayed:
> 
> EFI: cnt:1 total:1 a:0x669f40 len:32 
>         EFI:  #regs:1    num_extents:1  id:0xffff881496024640
> 	(s: 0x3869ff9, l: 1) 
> 
> Which is at agbno 0x69ff9 (434169). That's off to the right of the
> start of the last freespace range in rec[3]. rec[3] starts at
> 0x1c6fc and ends at 0x1fb58a. That means this efi clearly lands
> inside that freespace range - it's not an edge case, it's deep in
> the interior of the freespace range.
> 
> The inode logged just before the EFI - likely it's owner:
> 
> INO: cnt:2 total:2 a:0x668040 len:56 a:0x667fb0 len:96 
>         INODE: #regs:2   ino:0x3862d698  flags:0x1   dsize:0
>         CORE inode:
>             magic:IN  mode:0x81b0  ver:2  format:2  onlink:0
>             uid:1001  gid:1001  nlink:0 projid:0
>             atime:1394495104  mtime:1394495104  ctime:1394554526
>             flushiter:1
>             size:0x0  nblks:0x0  exsize:0  nextents:0  anextents:0
>             forkoff:13  dmevmask:0x0  dmstate:0  flags:0x0  gen:-121998876
> 
> Is an unlinked inode that has had all it's block removed. Yup - it's
> on the unlinked list:
> 
> agi unlinked bucket 24 is 6477464 in ag 14 (inode=946001560)
> 
> So, prior to recovery, what did it contain? it's got 287 bytes of
> date, and a single extent:
> 
> u.bmx[0] = [startoff,startblock,blockcount,extentflag] 0:[0,59154425,1,0]
> 
> xfs_db> convert fsb 59154425 agno
> 0xe (14)
> xfs_db> convert fsb 59154425 agbno
> 0x69ff9 (434169)
> 
> Ok, so the corruption, whatever it was, happened a long time ago,
> and it's only when removing the file that it was tripped over.
> There's nothing more I can really get from this - the root cause of
> the corruption is long gone.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

Thanks Dave.

Upon restarting my testing I immediately hit this error again (or a very
similar one in any case).  I suspect that the corruption you've noted was
not properly repaired by xfs_repair.

I captured all the same data as before, as well as an xfs_metadump from
after the xfs_repair.  If you're interested, it's all in this tarball:

https://dl.dropboxusercontent.com/u/31522929/xfs-unlink-internal-error-2013-03-13-1.tar.gz

Regards,
Morgan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
