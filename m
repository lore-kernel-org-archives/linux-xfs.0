Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA73I0Jr114013 for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 21:18:00 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ZsQoy0CJdqRWQYJZ for <xfs@oss.sgi.com>;
	Tue, 06 Nov 2012 19:19:55 -0800 (PST)
Date: Wed, 7 Nov 2012 14:19:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: How to reserve disk space in XFS to make the blocks over many
	files continuous?
Message-ID: <20121107031952.GA6434@dastard>
References: <CANS6a=D4SMMqhGJVMLbr-BWqLb-Z4L4LnofzfhqChBvE9dEtPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CANS6a=D4SMMqhGJVMLbr-BWqLb-Z4L4LnofzfhqChBvE9dEtPQ@mail.gmail.com>
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

On Wed, Nov 07, 2012 at 09:02:11AM +0800, huubby zhou wrote:
> Hi, folks,
> 
> I'm using *CentOS5.8*, with *XFS* filesystem extend storage disks. What I
> want to do is, pre-allocating many files, with continuous blocks in
> filesystem, both single file and crossing files. That is the start block ID
> of the next file is following the end block ID of current file.
> 
> I could do space pre-allocation by *posix_allocate()*, problem is the API
> zeros all disk space, I can't afford time consuming(I'm not sure if this
> API could make the blocks continuous).

it doesn't on more recent releases - it uses fallocate() in the back
end, which does the same as:

> then I tried
> *xfsctl()*<http://linux.die.net/man/3/xfsctl>,
> with *XFS_IOC_RESVSP* flag, I can reserve space faster.

This command.

> The problem with *xfsctl()* is, it could make the blocks continuous for
> individual file, but the blocks over files are *not* continuous. For
> example, 10 files, a/b/c/d/e/f... reserved. After I do the real writing to
> these files, it turns out the file 'b' isn't next to file 'a', and some
> file could be far from both previous one and next one, though other files
> may be neighboring with each other, rarely.
> 
> I use the following code to do the pre-allocation:
> 
> ftruncate(fd, FILE_SIZE);
> 
> xfs_flock_t flag = {0};
> flag.l_whence = SEEK_SET;
> flag.l_start  = 0;
> flag.l_len    = 512*1024*1024;
> xfsctl(fileName, fd, XFS_IOC_RESVSP64, &flag);
> 
> My question is, how can I guarantee the file system blocks over files
> continuous? Thanks for your time and appreciate your answer.

You can't, directly. If you have enough contiguous free space in the
AG that you are allocating in, then you will get contiguous files if
the allocation size lines up with the filesystem geometry:

$ for i in `seq 1 10` ; do sudo xfs_io -f -c "truncate 512m" -c "resvsp 0 512m" foo.$i ; done
$ sudo xfs_bmap -vp foo.[1-9] foo.10 |grep " 0:"
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
 sudo xfs_bmap -vp foo.[1-9] foo.10 |grep " 0:"
   0: [0..1048575]:    8096..1056671     0 (8096..1056671)  1048576 10000
   0: [0..1048575]:    1056672..2105247  0 (1056672..2105247) 1048576 10000
   0: [0..1048575]:    2105248..3153823  0 (2105248..3153823) 1048576 10000
   0: [0..1048575]:    3153824..4202399  0 (3153824..4202399) 1048576 10000
   0: [0..1048575]:    4202400..5250975  0 (4202400..5250975) 1048576 10000
   0: [0..1048575]:    5250976..6299551  0 (5250976..6299551) 1048576 10000
   0: [0..1048575]:    6299552..7348127  0 (6299552..7348127) 1048576 10000
   0: [0..1048575]:    7348128..8396703  0 (7348128..8396703) 1048576 10000
   0: [0..1048575]:    8396704..9445279  0 (8396704..9445279) 1048576 10000
   0: [0..1048575]:    9445280..10493855  0 (9445280..10493855) 1048576 10000

So all those files are contiguous both internally and externally. If
there isn't sufficient contiguous freespace, or there is allocator
contention, this won't happen - it's best effort behaviour....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
