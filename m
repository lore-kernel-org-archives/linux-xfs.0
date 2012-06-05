Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q55CMxa3082413 for <xfs@oss.sgi.com>; Tue, 5 Jun 2012 07:22:59 -0500
Message-ID: <4FCDFA16.9050808@sgi.com>
Date: Tue, 05 Jun 2012 08:22:46 -0400
From: Alain Renaud <arenaud@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] xfstest: using extsize cause corruption with multi
	buffer page
References: <20120601185815.883227033@sgi.com>
	<20120601185935.708235862@sgi.com> <20120605091352.GL4347@dastard>
In-Reply-To: <20120605091352.GL4347@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi Dave,

The reason I did it the way I did is because if I do not do the unmount it 
can take 5 to 10 iteration to reproduce the problem. However your version 
with xfs_io is much simpler I will
update the code with your change.

Second for the stale data if you look at buffer 3(11) and 4(12) you see 
that xfs_bmap show the buffer as REAL but they should be unwritten so what 
you read is what ever is on disk at the time (aka stale data).

The kernel I used for the testing is  3.4.0-rc2-0.2-default+ it is from 
oss.sgi.com and the branch head is

14c26c6a05de138a4fd9a0c05ff8e7435a618324 xfs: add trace points for log forces
3ba316037470bbf98c8a16c2179c02794fb8862e xfs: fix memory reclaim deadlock 
on agi buffer
ea562ed6e7df5acd9392d993882c39e855099165 xfs: fix delalloc quota accounting 
on failure


Again thanks a lot for the feedback I will provide an updated test with 
your suggested change.




On 12-06-05 05:13 AM, Dave Chinner wrote:
> On Fri, Jun 01, 2012 at 02:58:16PM -0400, Alain Renaud wrote:
>>    Test using extsize to create a file with multiple extent in one
>> PAGE. This show an error in the block conversion from unwritten
>> to real. As a result we tag raw disk block as valid(3-4) and
>> valid data as unwritten(5-6)
>>
>> On an x86_64 machine the page should look like this.
>>
>> buffer  content
>> 0       empty  b_state = 0
>> 1       DATA   b_state = 0x1023
>> 2       DATA   b_state = 0x1023
>> 3       empty  b_state = 0
>> 4       empty  b_state = 0
>> 5       DATA   b_state = 0x1023
>> 6       DATA   b_state = 0x1023
>> 7       empty  b_state = 0
>>
>> Signed-off-by: Alain Renaud<arenaud@sgi.com>
>>
>> ---
>>   .gitignore         |    1 	1 +	0 -	0 !
>>   287                |   74 	74 +	0 -	0 !
>>   287.out            |    1 	1 +	0 -	0 !
>>   group              |    1 	1 +	0 -	0 !
>>   src/Makefile       |    2 	1 +	1 -	0 !
>>   src/extsize_page.c |  113 	113 +	0 -	0 !
>>   6 files changed, 191 insertions(+), 1 deletion(-)
>>   create mode 100755 287
>>   create mode 100644 287.out
>>   create mode 100644 src/extsize_page.c
> .....
>
> Far too verbose - xfs_io can do just about everything for you in 5
> lines.  And you don't need a template file to compare to - just dump
> the hexdump output in the to golden image and the test harness will
> do the comapre for you.
>
> Also, see test 194 for the way we normally set up such a test:
>
> pgsize=`$here/src/feature -s`
> blksize=`expr $pgsize / 8`
> ....
> _scratch_mkfs_xfs -b size=$blksize>/dev/null 2>&1
>
> and the core of the xfs_io based test is:
>
> mnt=/mnt/scratch
> test_file=$mnt/foo
>
> rm -f $test_file
> xfs_io -f -c "extsize `expr $pgsize \* 10`" \
>          -c "pwrite `expr $pgsize + $blksize` `expr $blksize \* 2`" \
>          -c "pwrite `expr $pgsize + $blksize \* 5` `expr $blksize \* 2`" \
>          -c "truncate `expr $pgsize \* 3`" \
>          -c stat -c "bmap -vp" \
>          $test_file
> hexdump $test_file
>
> umount $mnt
> mount $mnt
>
> hexdump $test_file
>
> --
>
> The output I get on a current 3.5-rc1 kernel is this:
>
> wrote 1024/1024 bytes at offset 4608
> 1 KiB, 2 ops; 0.0000 sec (15.751 MiB/sec and 32258.0645 ops/sec)
> wrote 1024/1024 bytes at offset 6656
> 1 KiB, 2 ops; 0.0000 sec (97.656 MiB/sec and 200000.0000 ops/sec)
> fd.path = "/mnt/scratch/foo"
> fd.flags = non-sync,non-direct,read-write
> stat.ino = 35
> stat.type = regular file
> stat.size = 12288
> stat.blocks = 80
> fsxattr.xflags = 0x800 [----------e---]
> fsxattr.projid = 0
> fsxattr.extsize = 40960
> fsxattr.nextents = 3
> fsxattr.naextents = 0
> dioattr.mem = 0x200
> dioattr.miniosz = 512
> dioattr.maxiosz = 2147483136
> /mnt/scratch/foo:
>   EXT: FILE-OFFSET      BLOCK-RANGE      AG AG-OFFSET        TOTAL FLAGS
>     0: [0..8]:          48..56            0 (48..56)             9 10000
>     1: [9..12]:         57..60            0 (57..60)             4 00000
>     2: [13..79]:        61..127           0 (61..127)           67 10000
> 0000000 0000 0000 0000 0000 0000 0000 0000 0000
> *
> 0001200 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
> *
> 0001600 0000 0000 0000 0000 0000 0000 0000 0000
> *
> 0001a00 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
> *
> 0001e00 0000 0000 0000 0000 0000 0000 0000 0000
> *
> 0003000
> 0000000 0000 0000 0000 0000 0000 0000 0000 0000
> *
> 0001200 cdcd cdcd cdcd cdcd cdcd cdcd cdcd cdcd
> *
> 0001600 0000 0000 0000 0000 0000 0000 0000 0000
> *
> 0003000
>
>
> Which shows that the second region wasn't converted. I'm not sure
> why you are seeing stale data - you should see zeros because the
> region is still unwritten. What kernel are you testing on?
>
>
>

-- 
===============================================
Alain Renaud     - Cluster File System Engineer
arenaud@sgi.com  - SGI
===============================================

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
