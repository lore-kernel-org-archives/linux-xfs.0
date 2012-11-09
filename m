Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA936YF7058434 for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 21:06:34 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	NpSKZ6wEpWKpFeAu for <xfs@oss.sgi.com>;
	Thu, 08 Nov 2012 19:08:31 -0800 (PST)
Date: Fri, 9 Nov 2012 14:08:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: How to reserve disk space in XFS to make the blocks over many
	files continuous?
Message-ID: <20121109030829.GZ6434@dastard>
References: <CANS6a=D4SMMqhGJVMLbr-BWqLb-Z4L4LnofzfhqChBvE9dEtPQ@mail.gmail.com>
	<20121107031952.GA6434@dastard>
	<CANS6a=DpNTtnV1aLjX1TW_2dNSvwi-nPOB+EiQ=gyg9jwr81oA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANS6a=DpNTtnV1aLjX1TW_2dNSvwi-nPOB+EiQ=gyg9jwr81oA@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: huubby zhou <huubby1@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Nov 09, 2012 at 10:04:57AM +0800, huubby zhou wrote:
> Hi, Dave,
> 
> Thanks for the answer, it's great, and I apologize for the terrible format.
> 
> >You can't, directly. If you have enough contiguous free space in the
> >AG that you are allocating in, then you will get contiguous files if
> >the allocation size lines up with the filesystem geometry:
> >
> >$ for i in `seq 1 10` ; do sudo xfs_io -f -c "truncate 512m" -c "resvsp 0
> 512m" foo.$i ; done
> >$ sudo xfs_bmap -vp foo.[1-9] foo.10 |grep " 0:"
> > EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
> > sudo xfs_bmap -vp foo.[1-9] foo.10 |grep " 0:"
> >   0: [0..1048575]:    8096..1056671     0 (8096..1056671)  1048576 10000
> >   0: [0..1048575]:    1056672..2105247  0 (1056672..2105247) 1048576 10000
> >   0: [0..1048575]:    2105248..3153823  0 (2105248..3153823) 1048576 10000
> >   0: [0..1048575]:    3153824..4202399  0 (3153824..4202399) 1048576 10000
> >   0: [0..1048575]:    4202400..5250975  0 (4202400..5250975) 1048576 10000
> >   0: [0..1048575]:    5250976..6299551  0 (5250976..6299551) 1048576 10000
> >   0: [0..1048575]:    6299552..7348127  0 (6299552..7348127) 1048576 10000
> >   0: [0..1048575]:    7348128..8396703  0 (7348128..8396703) 1048576 10000
> >   0: [0..1048575]:    8396704..9445279  0 (8396704..9445279) 1048576 10000
> >   0: [0..1048575]:    9445280..10493855  0 (9445280..10493855) 1048576
> 10000
> >
> >So all those files are contiguous both internally and externally. If
> >there isn't sufficient contiguous freespace, or there is allocator
> >contention, this won't happen - it's best effort behaviour....
> 
> I believe you got these in a single AG, but I do the allocation in
> filesystem
> with multi-AGs, specifically, it is a 6T storage space, and I run the
> mkfs.xfs
> without setting the AG number/size, it ends up with 32 AGs.
> My files layout:
>     - 0                         - dir
>     | - 0                       - dir
>     | | - 1                     - file
>     | | - 2                     - file
>     | | - 3                     - file
>     | | - 4                     - file
>     | | - 5                     - file
>     | | - ...                   - file
>     | | - 128                   - file
>     | - 1                       - dir
>     | | - 1                     - file
>     | | - 2                     - file
>     | | - 3                     - file
>     | | - 4                     - file
>     | | - 5                     - file
>     | | - ...                   - file
>     | | - 128                   - file
>     | - ...                     - dir
> Every file is 512MB, every directory holds 512MB*128=64GB.

Yup, that's exactly by design. That's how the inode64 allocation
policy is supposed to work.

> According to your advice and XFS document, I tried to set the AG size to
> 64GB,

What advice might that be? I don't thikn I've ever recommended
anyone use 96*64GB AGs. Unless you have 96 allocations all occurring
at the same time (very rare, in my experience), there is no need for
some many AGs.


> for avoiding the allocator contention and keeping all files in single
> directory
> fall in the same AG, but it didn't work. The files are still in different
> AGs.
> My xfs_info:
> meta-data=/dev/sdc2              isize=256    agcount=96, agsize=16777216
> blks
>          =                       sectsz=512   attr=0
> data     =                       bsize=4096   blocks=1610116329, imaxpct=25
>          =                       sunit=0      swidth=0 blks, unwritten=1
> naming   =version 2              bsize=4096
> log      =internal log           bsize=4096   blocks=32768, version=1
>          =                       sectsz=512   sunit=0 blks, lazy-count=0
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> The files:
> $ for i in `seq 1 10` ; do sudo xfs_io -f -c "truncate 512m" -c "resvsp 0
> 512m" foo.$i ; done
> $ sudo xfs_bmap -vp *| grep " 0:"
>    0: [0..1048575]:    2147483712..2148532287 16 (64..1048639)    1048576
> 10000
>    0: [0..1048575]:    3355443264..3356491839 25 (64..1048639)    1048576
> 10000
>    0: [0..1048575]:    2281701440..2282750015 17 (64..1048639)    1048576
> 10000
>    0: [0..1048575]:    2415919168..2416967743 18 (64..1048639)    1048576
> 10000
>    0: [0..1048575]:    2550136896..2551185471 19 (64..1048639)    1048576
> 10000
>    0: [0..1048575]:    2684354624..2685403199 20 (64..1048639)    1048576
> 10000
>    0: [0..1048575]:    2818572352..2819620927 21 (64..1048639)    1048576
> 10000
>    0: [0..1048575]:    2952790080..2953838655 22 (64..1048639)    1048576
> 10000
>    0: [0..1048575]:    3087007808..3088056383 23 (64..1048639)    1048576
> 10000
>    0: [0..1048575]:    3221225536..3222274111 24 (64..1048639)    1048576
> 10000

That's inode32 allocator behaviour (rotoring each new allocation
across a different AG). Mount with inode64 - it's the default in the
latest kernels - and it will behave as I demonstrated.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
