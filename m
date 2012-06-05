Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q559Dv5f065900 for <xfs@oss.sgi.com>; Tue, 5 Jun 2012 04:13:57 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	k4bE8JVh4gFzqfn7 for <xfs@oss.sgi.com>;
	Tue, 05 Jun 2012 02:13:55 -0700 (PDT)
Date: Tue, 5 Jun 2012 19:13:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/1] xfstest: using extsize cause corruption with multi
	buffer page
Message-ID: <20120605091352.GL4347@dastard>
References: <20120601185815.883227033@sgi.com>
	<20120601185935.708235862@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120601185935.708235862@sgi.com>
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
To: Alain Renaud <arenaud@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 01, 2012 at 02:58:16PM -0400, Alain Renaud wrote:
>   Test using extsize to create a file with multiple extent in one 
> PAGE. This show an error in the block conversion from unwritten
> to real. As a result we tag raw disk block as valid(3-4) and 
> valid data as unwritten(5-6)
> 
> On an x86_64 machine the page should look like this.
> 
> buffer  content
> 0       empty  b_state = 0
> 1       DATA   b_state = 0x1023
> 2       DATA   b_state = 0x1023
> 3       empty  b_state = 0
> 4       empty  b_state = 0
> 5       DATA   b_state = 0x1023
> 6       DATA   b_state = 0x1023
> 7       empty  b_state = 0
> 
> Signed-off-by: Alain Renaud <arenaud@sgi.com>
> 
> ---
>  .gitignore         |    1 	1 +	0 -	0 !
>  287                |   74 	74 +	0 -	0 !
>  287.out            |    1 	1 +	0 -	0 !
>  group              |    1 	1 +	0 -	0 !
>  src/Makefile       |    2 	1 +	1 -	0 !
>  src/extsize_page.c |  113 	113 +	0 -	0 !
>  6 files changed, 191 insertions(+), 1 deletion(-)
>  create mode 100755 287
>  create mode 100644 287.out
>  create mode 100644 src/extsize_page.c
.....

Far too verbose - xfs_io can do just about everything for you in 5
lines.  And you don't need a template file to compare to - just dump
the hexdump output in the to golden image and the test harness will
do the comapre for you.

Also, see test 194 for the way we normally set up such a test:

pgsize=`$here/src/feature -s`
blksize=`expr $pgsize / 8`
....
_scratch_mkfs_xfs -b size=$blksize >/dev/null 2>&1

and the core of the xfs_io based test is:

mnt=/mnt/scratch
test_file=$mnt/foo

rm -f $test_file
xfs_io -f -c "extsize `expr $pgsize \* 10`" \
        -c "pwrite `expr $pgsize + $blksize` `expr $blksize \* 2`" \
        -c "pwrite `expr $pgsize + $blksize \* 5` `expr $blksize \* 2`" \
        -c "truncate `expr $pgsize \* 3`" \
        -c stat -c "bmap -vp" \
        $test_file
hexdump $test_file

umount $mnt
mount $mnt

hexdump $test_file

--

The output I get on a current 3.5-rc1 kernel is this:

wrote 1024/1024 bytes at offset 4608
1 KiB, 2 ops; 0.0000 sec (15.751 MiB/sec and 32258.0645 ops/sec)
wrote 1024/1024 bytes at offset 6656
1 KiB, 2 ops; 0.0000 sec (97.656 MiB/sec and 200000.0000 ops/sec)
fd.path = "/mnt/scratch/foo"
fd.flags = non-sync,non-direct,read-write
stat.ino = 35
stat.type = regular file
stat.size = 12288
stat.blocks = 80
fsxattr.xflags = 0x800 [----------e---]
fsxattr.projid = 0
fsxattr.extsize = 40960
fsxattr.nextents = 3
fsxattr.naextents = 0
dioattr.mem = 0x200
dioattr.miniosz = 512
dioattr.maxiosz = 2147483136
/mnt/scratch/foo:
 EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
   0: [0..8]:          48..56            0 (48..56)             9 10000
   1: [9..12]:         57..60            0 (57..60)             4 00000
   2: [13..79]:        61..127           0 (61..127)           67 10000
0000000 0000 0000 0000 0000 0000 0000 0000 0000
*
0001200 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
*
0001600 0000 0000 0000 0000 0000 0000 0000 0000
*
0001a00 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
*
0001e00 0000 0000 0000 0000 0000 0000 0000 0000
*
0003000
0000000 0000 0000 0000 0000 0000 0000 0000 0000
*
0001200 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
*
0001600 0000 0000 0000 0000 0000 0000 0000 0000
*
0003000


Which shows that the second region wasn't converted. I'm not sure
why you are seeing stale data - you should see zeros because the
region is still unwritten. What kernel are you testing on?



-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
