Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A2C9C7F37
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 09:28:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 90B8A304098
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 07:28:00 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id ukm6fepZAw7gj7IE (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Jul 2013 07:27:59 -0700 (PDT)
Date: Thu, 25 Jul 2013 10:27:54 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: Re: [PATCH] xfstests: 091, 240, 268 fix for xfs on 4k sector hard
	drive
Message-ID: <20130725102754.7c564098@oracle.com>
In-Reply-To: <51F0AB56.7020705@hardwarefreak.com>
References: <20130724143208.34b77534@oracle.com>
	<20130724235739.GR19986@dastard>
	<51F0AB56.7020705@hardwarefreak.com>
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
To: stan@hardwarefreak.com, Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, 24 Jul 2013 23:36:38 -0500
Stan Hoeppner <stan@hardwarefreak.com> wrote:

> On 7/24/2013 6:57 PM, Dave Chinner wrote:
> > On Wed, Jul 24, 2013 at 02:32:08PM -0400, Dwight Engen wrote:
> >> Tests 091,240, and 268 are failing on my 4k sector hard disk. The
> >> dio writes from fsx and aiodio_sparse2 are failing on xfs with
> >> EINVAL which is returned from the check at the top of
> >> xfs_file_dio_aio_write().
> >>
> >> The fix is to use blockdev -getpbsz to get the physical sector
> >> size instead of the logical sector size. This makes 091 and 268
> >> work. 240 will not run on a 4k drive since fs block size == device
> >> block size. Tested against xfs,ext4, and btrfs.
> > 
> > What's the logical sector size of the drive? If it's 4k, then
> > blockdev --getss should be returning 4k. If it's not, then either
> > the drive is reporting that it supports 512 bytes sectors when it
> > doesn't (i.e. the drive is broken) or blockdev is returning the
> > wrong information (i.e. blockdev is broken)....

# blockdev --getss /dev/sda
512
# blockdev --getpbsz /dev/sda 
4096

So it looks like blockdev is reporting the correct values.

> > What does mkfs.xfs output on that device?

mkfs.xfs -f /dev/sda1
meta-data=/dev/sda1              isize=256    agcount=8, agsize=262144
blks =                       sectsz=4096  attr=2, projid32bit=0
data     =                       bsize=4096   blocks=2097152, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=2560, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

So mkfs.xfs is reporting sectsz=4096. I added a printf into mkfs.xfs
right after it is setting sectorsize = ft.psectorsize and saw:

sectorsize 4096 ft.psectorsize 4096 ft.lsectorsize 512
 
> >>  rm -f $TEST_DIR/aiodio_sparse
> >>  
> >> -logical_block_size=`blockdev --getss $TEST_DEV`
> >> +logical_block_size=`blockdev --getpbsz $TEST_DEV`
> > 
> > FWIW, that doesn't make much sense - putting the physical block size
> > into a variable named "logical_block_size".....

Yeah, that name wouldn't make much sense with this change. Its actually
being used to compare to the fs block size and then its passed into
aiodio_sparse2 as offset. 091 and 268 use the more generic name bsize,
should I can change it to that?

> > Cheers,
> > 
> > Dave.
> 
> AFAIK there are no native 4K sector drives on the market yet.  All of
> the currently shipping models with physical 4K sectors are "Advanced
> Format" drives.  The Advanced Format standard specifies 4K physical
> sectors -internal- to the drive, but with traditional 512B LBA
> addressing.
> 
> Dwight, what disk drive is this in question?  Make/model?

Yep its an Advanced Format drive, some relevant lines from dmesg:

ata1.00: ATA-8: HITACHI HTS725050A7E630, GH2ZB390, max UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      HITACHI HTS72505 GH2Z PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 0:0:0:0: [sda] 4096-byte physical blocks

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
