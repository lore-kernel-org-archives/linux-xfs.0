Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q19ERqRI175990 for <xfs@oss.sgi.com>; Thu, 9 Feb 2012 08:27:53 -0600
Message-ID: <4F33D7B9.6050803@oracle.com>
Date: Thu, 09 Feb 2012 22:27:05 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/2] xfstests: introduce 279 for SEEK_DATA/SEEK_HOLE
	sanity check
References: <4F2FE40A.6050108@oracle.com> <20120208054241.GH20305@dastard>
	<4F33D1B8.1050505@oracle.com>
In-Reply-To: <4F33D1B8.1050505@oracle.com>
Reply-To: jeff.liu@oracle.com
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
To: jeff.liu@oracle.com
Cc: Christoph Hellwig <hch@infradead.org>, Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On 02/09/2012 10:01 PM, Jeff Liu wrote:

> Hi Dave,
> 
> Sorry! I missed your response for this patch.
> 
> On 02/08/2012 01:42 PM, Dave Chinner wrote:
> 
>> On Mon, Feb 06, 2012 at 10:30:34PM +0800, Jeff Liu wrote:
>>> Introduce 279 for SEEK_DATA/SEEK_HOLE sanity check.
>> .....
>>> +echo "QA output created by $seq"
>>> +
>>> +here=`pwd`
>>> +status=0	# success is the default!
>>
>> Why? failure should be the default, and it is in the new test
>> template...
> 
> That's my mistake, I manually changed this default setting at that time
> somehow. :(
> 
>>
>> $ grep failure new
>> status=1        # failure is the default!
> 
>>
>>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>>
>> Indeed, we want the test to fail if it is interrupted.
> 
>>
>>> +
>>> +# get standard environment, filters and checks
>>> +. ./common.rc
>>> +. ./common.filter
>>> +
>>> +# real QA test starts here
>>> +
>>> +# Modify as appropriate.
>>> +# FIXME: _supported_os should include Solaris too.
>>> +_supported_fs generic
>>> +_supported_os Linux Solaris
>>
>> What is the FIXME for?
> 
> At first, I was consider to let it also support Solaris lseek(2) tests,
> but xfstests only works on IRIX && Linux, so "FIXME" should be removed.
> 
>>
>>> +base_test_path=$TEST_DIR/seek_sanity_testfile
>>> +
>>> +[ -x $here/src/seek_sanity_tester ] || _notrun "seek_sanitfy_tester not built"
>>> +
>>> +_cleanup()
>>> +{
>>> +	rm -f $base_test_path.*
>>> +}
>>> +
>>> +rm -rf $seq.out
>>> +echo "QA output created by $seq" > $seq.out
>>
>> Anything output on stdout automatically gets put into $seq.out by
>> the test harness. The $seq.out file is truncated before the test, so
>> this is not necessary. Indeed, doing this is probably why the tee
>> command below only results in a single copy of the output in
>> $seq.out.
>>
>>> +$here/src/seek_sanity_tester $base_test_path 2>&1 | tee -a $seq.out
>>
>> This only needs to be:
>>
>> $here/src/seek_sanity_tester $base_test_path 2>&1
>>
>> to redirect both stdout and stderr to $seq.out.
> 
> Ok.
> 
>>
>>> --- /dev/null
>>> +++ b/279.out
>>> @@ -0,0 +1,116 @@
>>> +QA output created by 279
>>> +File system supports the default behavior.
>>> +File system magic#: 0x58465342
>>
>> You can't put the filesystem magic number in the output. It is
>> different for XFS, ext4, ext3, etc. Either it needs to be removed or
>> filtered.
> 
> I'll remove it. :)
> 
>>
>>> +Allocation size: 4096
>>
>> That's no good, either, as filesystems can easily return return
>> something other than 4k there as well.
>>
>>> +01. Test empty file
>>> +01.01 SEEK_DATA expected -1 with errno -6, got -6.                succ
>>> +01.02 SEEK_HOLE expected -1 with errno -6, got -6.                succ
>>> +01.03 SEEK_HOLE expected -1 with errno -6, got -6.                succ
>>> +
>>> +02. Test a tiny full file
>>> +02.01 SEEK_HOLE expected 8 or 8, got 8.                           succ
>>> +02.02 SEEK_DATA expected 0 or 0, got 0.                           succ
>>> +02.03 SEEK_DATA expected 1 or 1, got 1.                           succ
>>> +02.04 SEEK_HOLE expected 8 or 8, got 8.                           succ
>>> +02.05 SEEK_DATA expected 7 or 7, got 7.                           succ
>>> +02.06 SEEK_HOLE expected -1 with errno -6, got -6.                succ
>>> +02.07 SEEK_DATA expected -1 with errno -6, got -6.                succ
>>> +02.08 SEEK_HOLE expected -1 with errno -6, got -6.                succ
>>> +02.09 SEEK_DATA expected -1 with errno -6, got -6.                succ
>>> +
>>> +03. Test a larger full file
>>> +03.01 SEEK_HOLE expected 8292 or 8292, got 8292.                  succ
>>> +03.02 SEEK_HOLE expected 8292 or 8292, got 8292.                  succ
>>> +03.03 SEEK_DATA expected 0 or 0, got 0.                           succ
>>> +03.04 SEEK_DATA expected 1 or 1, got 1.                           succ
>>> +03.05 SEEK_HOLE expected 8292 or 8292, got 8292.                  succ
>>> +03.06 SEEK_DATA expected 8291 or 8291, got 8291.                  succ
>>
>> Hmmm, these are all numbers that are based on an allocation size of
>> 4k. So this test is guaranteed to fail on configurations that don't
>> report a 4k block size from fstat().
> 
> Hmm, although the numbers(like 8292, 8291) are based on an allocation
> size(4k in this case).  But they will adjusted to other numbers
> depending on the detected allocation size on the fly.
> 
> For example, if a file system blksize is 8k, then the old result:
> 03.01 SEEK_HOLE expected 8292 or 8292, got 8292.
> will show as:
> 03.01 SEEK_HOLE expected 16484 or 16484, got 16484.

> 
> Frankly speaking, I have not yet tried it on other allocation size, that
> is just the desired behavior per current implementation. I'll fix it up
> as you suggested if it run failed. :)

Ok, I just tried on an ext4 file system with 2k blksize, looks fine, the
number of expected size were shown as following:

$ ./seek_test
File system magic#: 0xef53
Allocation unit: 2048 bytes
File system supports the default behavior.

03. Test a larger full file
03.01 SEEK_HOLE expected 4196 or 4196, got 4196.                  succ
03.02 SEEK_HOLE expected 4196 or 4196, got 4196.                  succ
03.03 SEEK_DATA expected 0 or 0, got 0.                           succ
03.04 SEEK_DATA expected 1 or 1, got 1.                           succ
03.05 SEEK_HOLE expected 4196 or 4196, got 4196.                  succ
03.06 SEEK_DATA expected 4195 or 4195, got 4195.                  succ

Strange, I also tried to build XFS with 2k which shown as following:

$ sudo mkfs.xfs -b size=2k -n size=2k -f /dev/sda7

$ xfs_info /dev/sda7
meta-data=/dev/sda7              isize=256    agcount=4, agsize=1418736 blks
         =                       sectsz=512   attr=2
data     =                       bsize=2048   blocks=5674944, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=2048   ascii-ci=0
log      =internal               bsize=2048   blocks=5120, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

But the blksize still shown as 4k, I think I must have missed something,
will try it tomorrow.

Have a nice day!
-Jeff

> 
> Thanks,
> -Jeff
> 
>>
>> I'd suggest that what you need to do here is have the test exit with
>> a 1 or 0 to indicate success, and test for that in the 279 script,
>> and pipe all this output to $seq.full so it can be used for
>> debugging when a failure occurs.
>>
>> Basically, if numbers can change between different test configs,
>> then they either need to be filtered out of the golden output or
>> directed to the $seq.full and the test does something like:
>>
>> status=1 # failure is the default
>> rm -f $seq.full
>> ....
>> run_test >> $seq.full 2>&1 || _fail "run_test failed!"
>> status=0
>> exit
> 
>>
>> Cheers,
>>
>> Dave.
> 
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
