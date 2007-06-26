Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Jun 2007 16:33:22 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5QNXEtL010115
	for <xfs@oss.sgi.com>; Tue, 26 Jun 2007 16:33:16 -0700
Date: Wed, 27 Jun 2007 09:32:53 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Message-ID: <20070626233253.GS31489@sgi.com>
References: <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134500.GE1951@amitarora.in.ibm.com> <20070625215239.GK5181@schatzie.adilger.int> <20070626104546.GB19870@amitarora.in.ibm.com> <20070626154250.GD6652@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626154250.GD6652@schatzie.adilger.int>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

On Tue, Jun 26, 2007 at 11:42:50AM -0400, Andreas Dilger wrote:
> On Jun 26, 2007  16:15 +0530, Amit K. Arora wrote:
> > On Mon, Jun 25, 2007 at 03:52:39PM -0600, Andreas Dilger wrote:
> > > In XFS one of the (many) ALLOC modes is to zero existing data on allocate.
> > > For ext4 all this would mean is calling ext4_ext_mark_uninitialized() on
> > > each extent.  For some workloads this would be much faster than truncate
> > > and reallocate of all the blocks in a file.
> > 
> > In ext4, we already mark each extent having preallocated blocks as
> > uninitialized. This is done as part of following code (which is part of
> > patch 5/7) in ext4_ext_get_blocks() :  
> 
> What I meant is that with XFS_IOC_ALLOCSP the previously-written data
> is ZEROED OUT, unlike with fallocate() which leaves previously-written
> data alone and only allocates in holes.
> 
> So, if you had a sparse file with some data in it:
> 
>      AAAAA         BBBBBB
> 
> fallocate() would allocate the holes:
> 
> 00000AAAAA000000000BBBBBB00000000
> 
> XFS_IOC_ALLOCSP would overwrite everything:
> 
> 000000000000000000000000000000000

No, it wouldn't. XFS_IOC_ALLOCSP would give you:


      AAAAA         BBBBBB00000000

because it only allocates the space between the old EOF and the new
EOF. Graphic demonstration - write 4k @ 4k, 4k @ 16k, allocsp out to 32k:

budgie:~ # xfs_io -f \
> -c "pwrite 4096 4096" \
> -c "pwrite 16384 4096" \
> -c "bmap -vvp" \
> -c "allocsp 32768 0" \
> -c "bmap -vvp" \
> /mnt/test/alfred
wrote 4096/4096 bytes at offset 4096
4 KiB, 1 ops; 0.0000 sec (108.507 MiB/sec and 27777.7778 ops/sec)
wrote 4096/4096 bytes at offset 16384
4 KiB, 1 ops; 0.0000 sec (260.417 MiB/sec and 66666.6667 ops/sec)
/mnt/test/alfred:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET          TOTAL
   0: [0..7]:          hole                                       8
   1: [8..15]:         5226864..5226871  4 (1022160..1022167)     8
   2: [16..31]:        hole                                      16
   3: [32..39]:        5226888..5226895  4 (1022184..1022191)     8
/mnt/test/alfred:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET          TOTAL
   0: [0..7]:          hole                                       8
   1: [8..15]:         5226864..5226871  4 (1022160..1022167)     8
   2: [16..31]:        hole                                      16
   3: [32..63]:        5226888..5226919  4 (1022184..1022215)    32
budgie:~ #

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
