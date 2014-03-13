Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E604F7F3F
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 17:59:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 705F3AC004
	for <xfs@oss.sgi.com>; Thu, 13 Mar 2014 15:59:19 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	F3t5JWZEmE5WQBmM for <xfs@oss.sgi.com>;
	Thu, 13 Mar 2014 15:59:16 -0700 (PDT)
Date: Fri, 14 Mar 2014 09:58:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Possible XFS bug encountered in 3.14.0-rc3+
Message-ID: <20140313225842.GA10057@dastard>
References: <33A0129EBFD46748804DE81B354CA1B21C0DC77A@SACEXCMBX06-PRD.hq.netapp.com>
	<20140312230241.GE6851@dastard>
	<33A0129EBFD46748804DE81B354CA1B21C0DDBAE@SACEXCMBX06-PRD.hq.netapp.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <33A0129EBFD46748804DE81B354CA1B21C0DDBAE@SACEXCMBX06-PRD.hq.netapp.com>
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
To: "Mears, Morgan" <Morgan.Mears@netapp.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, Mar 13, 2014 at 02:47:58PM +0000, Mears, Morgan wrote:
> On Wed, Mar 12, 2014 at 07:03:14PM -0400, Dave Chinner wrote:
> > On Wed, Mar 12, 2014 at 08:14:32PM +0000, Mears, Morgan wrote:
> >> Hi,
> >> 
> >> Please CC me on any responses; I don't subscribe to this list.
> >> 
> >> I ran into a possible XFS bug while doing some Oracle benchmarking.  My test
> >> system is running a 3.14.0-rc3+ kernel built from the for-next branch of
> >> git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git
> >> on 2014-02-19 (last commit 1342f11e713792e53e4b7aa21167fe9caca81c4a).
> >> 
> >> The XFS instance in question is 200 GB and should have all default
> >> parameters (mkfs.xfs /dev/mapper/<my_lun_partition>).  It contains Oracle
> >> binaries and trace files.  At the time the issue occurred I had been
> >> running Oracle with SQL*NET server tracing enabled.  The affected XFS
> >> had filled up 100% with trace files several times; I was periodically
> >> executing rm -f * in the trace file directory, which would reduce the
> >> file system occupancy from 100% to 3%.  I had an Oracle load generating
> >> tool running, so new log files were being created with some frequency.
> >> 
> >> The issue occurred during one of my rm -f * executions; afterwards the
> >> file system would only produce errors.  Here is the traceback:
> >> 
> >> [1552067.297192] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1602 of file fs/xfs/xfs_alloc.c.  Caller 0xffffffffa04c4905
> > 
> > So, freeing a range that is already partially free. The problem
> > appears to be in AG 15, according to the repair output.
> > 
> >> https://dl.dropboxusercontent.com/u/31522929/xfs-double-free-xfs_metadump-before-repair.gz
> > 
> > AGF 15 is full:
....
> > on the unlinked list:
> > 
> > agi unlinked bucket 24 is 6477464 in ag 14 (inode=946001560)
> > 
> > So, prior to recovery, what did it contain? it's got 287 bytes of
> > date, and a single extent:
> > 
> > u.bmx[0] = [startoff,startblock,blockcount,extentflag] 0:[0,59154425,1,0]
> > 
> > xfs_db> convert fsb 59154425 agno
> > 0xe (14)
> > xfs_db> convert fsb 59154425 agbno
> > 0x69ff9 (434169)
> > 
> > Ok, so the corruption, whatever it was, happened a long time ago,
> > and it's only when removing the file that it was tripped over.
> > There's nothing more I can really get from this - the root cause of
> > the corruption is long gone.
> > 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> 
> Thanks Dave.
> 
> Upon restarting my testing I immediately hit this error again (or a very
> similar one in any case).  I suspect that the corruption you've noted was
> not properly repaired by xfs_repair.

What happens if you run xfs_repair twice in a row?

> I captured all the same data as before, as well as an xfs_metadump from
> after the xfs_repair.  If you're interested, it's all in this tarball:
> 
> https://dl.dropboxusercontent.com/u/31522929/xfs-unlink-internal-error-2013-03-13-1.tar.gz

Ok, that's triggered the right side btree checks, not the left side
like the previous one. It's probably AG 14 again.

EFI:

EFI: cnt:1 total:1 a:0x19c77b0 len:48 
        EFI:  #regs:1    num_extents:2  id:0xffff880f8011c640
	(s: 0x3816a3b, l: 112) (s: 0x3817cb1, l: 1920) 

So, two extents being freed:

xfs_db> convert fsb 0x3816a3b agno
0xe (14)
xfs_db> convert fsb 0x3816a3b agbno
0x16a3b (92731)
xfs_db> convert fsb 0x3817cb1 agbno
0x17cb1 (97457)

Surrounding free space regions:

66:[92551,180] 67:[92856,2]	-> used space range [92731,125]
...
172:[97415,42] 173:[97622,4]	-> used space range [97457,65]

So the first extent is good. The second, however, aligns correctly
to the free space region to the left, but massively overruns the
used space region which is only 165 blocks long. So it's a similar
problem here - both the free space trees are internally consistent,
the inode BMBT is internally consistent, but the space that they
track is not consistent.

After repair:

63:[92551,292] 64:[92856,2]	-> correctly accounted
....
169:[97415,49] 170:[97468,56] 171:[97528,168]
	-> used space [97464,2], [97524,4]

But that's a very different freespace map around the second extent
in the EFI. It's most definitely not a contiguous range of 1920
blocks now that repair has made sure the inode has no extents and
the range is correctly accounted for, so that indicates that the
length in the EFI is suspect.  Maybe it should only be 7 blocks?

Did you run the filesystem out of space again before this happened?
If you don't hit enospc, does removing files trigger this
corruption?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
