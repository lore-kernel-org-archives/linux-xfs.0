Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 04 Oct 2007 16:27:00 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l94NQrVM000910
	for <xfs@oss.sgi.com>; Thu, 4 Oct 2007 16:26:55 -0700
Date: Fri, 5 Oct 2007 09:26:44 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Reading directory entries from BMAP
Message-ID: <20071004232644.GK23367404@sgi.com>
References: <13040897.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13040897.post@talk.nabble.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: cyjoyp <cyjoyp@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Oct 04, 2007 at 07:27:19AM -0700, cyjoyp wrote:
> 
> Hi there,
>           I am a beginner in learning XFS file system.. I have a doubt, dont
> know whether is silly..If you could help me with this...Thank you..
> 
>    An extent is 128 bit in size and uses the following struct,
>   
>         typedef struct xfs_bmbt_irec {
>                       xfs_fileoff_t              br_startoff;
>                       xfs_fsblock_t            br_startblock;
>                       xfs_filblks_t              br_blockcount;
>                       xfs_exntst_t             br_state;
>                      }

That's the unpacked, in-memory format. The on disk format for
extents is converted by xfs_bmbt_set_allf/xfs_bmbt_disk_set_allf().

>      
>      I have got in to the BMAP position after traversing the BTREE..
>      The BMAP has a leaf and no other siblings..
>      I have the extents for directory entries stored in the BMAP..
>      This is where is struck badly..
>    
>     Now I have a 16 byte value from which I can calculate the block count
> ,AG number ,etc...
>              00 00 00 01 00 00 02 00 00 00 00 00 02 A0 00 02

If that is the start of the block, theres a block header first, right?
i.e.:

/*
 *  * Bmap root header, on-disk form only.
 *   */
typedef struct xfs_bmdr_block {
        __be16          bb_level;       /* 0 is a leaf */
	__be16          bb_numrecs;     /* current # of data records */
} xfs_bmdr_block_t;

So the above woul dbe telling me that this is a level zero block
(a leaf), with one record. Then there's the first record in packed
format....

>    In this case I lan up some where else instead going to the block of
> directory entries..
>    This br_startoff (logical offset) is causing a difference...I am going
> wrong somwhere in this case..

unpack the extent record first before decoding it. Perhaps you should
be using xfs_db to look at your disk structures rather than trying
to manually decode it from hex dumps. i.e.:

# xfs_db -r -c "inode 128" -c "p core.size core.nblocks core.format u.bmx"  -c "dblock 0" -c "type dir2" -c p /dev/sdb8
core.size = 4096
core.nblocks = 1
core.format = 2 (extents)
u.bmx[0] = [startoff,startblock,blockcount,extentflag] 0:[0,132,1,0]
bhdr.magic = 0x58443242
bhdr.bestfree[0].offset = 0x618
bhdr.bestfree[0].length = 0x770
bhdr.bestfree[1].offset = 0x370
bhdr.bestfree[1].length = 0x128
bhdr.bestfree[2].offset = 0x88
bhdr.bestfree[2].length = 0x58
bu[0].inumber = 128
bu[0].namelen = 1
bu[0].name = "."
bu[0].tag = 0x10
bu[1].inumber = 128
bu[1].namelen = 2
bu[1].name = ".."
bu[1].tag = 0x20
bu[2].inumber = 131
bu[2].namelen = 3
bu[2].name = "tmp"
bu[2].tag = 0x30
bu[3].inumber = 132
bu[3].namelen = 11
bu[3].name = "syscalltest"
bu[3].tag = 0x40
......

Note that this will print the entire block, including unused space with
it's stale contents.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
