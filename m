Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:23614 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731062AbfFSH6W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jun 2019 03:58:22 -0400
Message-ID: <5D09EB1A.6000301@cn.fujitsu.com>
Date: Wed, 19 Jun 2019 15:58:18 +0800
From: Yang Xu <xuyang2018.jy@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfs/191: update mkfs.xfs input results
References: <1560414701-2590-1-git-send-email-xuyang2018.jy@cn.fujitsu.com> <20190616143956.GC15846@desktop>
In-Reply-To: <20190616143956.GC15846@desktop>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: darrick.wong@oracle.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

on 2019/06/16 22:39, Eryu Guan wrote:

> [cc xfs list for xfs specific test]
>
> On Thu, Jun 13, 2019 at 04:31:41PM +0800, Yang Xu wrote:
>> Currently, on 5.2.0-rc4+ kernel, when I run xfs/191-input-validation with upstream xfsprogs,
>> I get the following errors because mkfs.xfs binary has changed a lot.
> Lines are too long for commit log, please wrap at column 68.
>
>> --------------------------
>> PLATFORM      -- Linux/x86_64  5.2.0-rc4+
>> MKFS_OPTIONS  -- -f -bsize=4096 /dev/sda11
>> MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sda11 /mnt/xfstests/scratch
> But these quotes don't need to be wrapped.
>
>> pass -n size=2b /dev/sda11
>> pass -d agsize=8192b /dev/sda11
>> pass -d agsize=65536s /dev/sda11
>> pass -d su=0,sw=64 /dev/sda11
>> pass -d su=4096s,sw=64 /dev/sda11
>> pass -d su=4096b,sw=64 /dev/sda11
>> pass -l su=10b /dev/sda11
>> fail -n log=15 /dev/sda11
>> fail -r size=65536,rtdev=$fsimg /dev/sda11
>> fail -r rtdev=$fsimg /dev/sda11
>> fail -i log=10 /dev/sda11
>> --------------------------
>>
>> "pass -d su=0,sw=64 /dev/sda11", expect fail, this behavior has been fixed by commit 16adcb88:
>> (mkfs: more sunit/swidth sanity checking).
>>
>> "fail -n log=15 /dev/sda11" "fail -i log=10 /dev/sda11", expect pass, this option has been removed
>> since commit 2cf637c(mkfs: remove logarithm based CLI option).
>>
>> "fail -r size=65536,rtdev=$fsimg /dev/sda11" "fail -r rtdev=$fsimg /dev/sda11" works well if we disable
>> reflink, fail if we enable reflink. It fails because reflink was not supported in realtime devices
>> since commit bfa66ec.
>>
>> I change the expected result for compatibility with current xfsprogs and add rtdev test with reflink .
>>
>> Signed-off-by: Yang Xu<xuyang2018.jy@cn.fujitsu.com>
> I noticed Darrick provided a Reviewed-by tag, but as Darrick also noted,
> it'd be good to know what do other xfs maintainers think about this
> test.
>
Hi Eryu

I have sent a v3 patch about your comment.
Besides, I also want to know what other xfs maintainers think about this case. keep it or update it?
Let's wait for a short time.

Thanks
Yang Xu

>> ---
>>   tests/xfs/191-input-validation | 36 ++++++++++++++++++++++------------
>>   1 file changed, 24 insertions(+), 12 deletions(-)
>>
>> diff --git a/tests/xfs/191-input-validation b/tests/xfs/191-input-validation
>> index b6658015..9fe72051 100755
>> --- a/tests/xfs/191-input-validation
>> +++ b/tests/xfs/191-input-validation
>> @@ -112,10 +112,11 @@ do_mkfs_fail -b size=2b $SCRATCH_DEV
>>   do_mkfs_fail -b size=nfi $SCRATCH_DEV
>>   do_mkfs_fail -b size=4096nfi $SCRATCH_DEV
>>   do_mkfs_fail -n size=2s $SCRATCH_DEV
>> -do_mkfs_fail -n size=2b $SCRATCH_DEV
>>   do_mkfs_fail -n size=nfi $SCRATCH_DEV
>>   do_mkfs_fail -n size=4096nfi $SCRATCH_DEV
>>
>> +do_mkfs_pass -n size=2b $SCRATCH_DEV
>> +
>>   # bad label length
>>   do_mkfs_fail -L thisiswaytoolong $SCRATCH_DEV
>>
>> @@ -129,6 +130,8 @@ do_mkfs_pass -d agsize=32M $SCRATCH_DEV
>>   do_mkfs_pass -d agsize=1g $SCRATCH_DEV
>>   do_mkfs_pass -d agsize=$((32 * 1024 * 1024)) $SCRATCH_DEV
>>   do_mkfs_pass -b size=4096 -d agsize=8192b $SCRATCH_DEV
>> +do_mkfs_pass -d agsize=8192b $SCRATCH_DEV
>> +do_mkfs_pass -d agsize=65536s $SCRATCH_DEV
>>   do_mkfs_pass -d sectsize=512,agsize=65536s $SCRATCH_DEV
>>   do_mkfs_pass -s size=512 -d agsize=65536s $SCRATCH_DEV
>>   do_mkfs_pass -d noalign $SCRATCH_DEV
>> @@ -136,7 +139,10 @@ do_mkfs_pass -d sunit=0,swidth=0 $SCRATCH_DEV
>>   do_mkfs_pass -d sunit=8,swidth=8 $SCRATCH_DEV
>>   do_mkfs_pass -d sunit=8,swidth=64 $SCRATCH_DEV
>>   do_mkfs_pass -d su=0,sw=0 $SCRATCH_DEV
>> +do_mkfs_pass -d su=0,sw=64 $SCRATCH_DEV
>>   do_mkfs_pass -d su=4096,sw=1 $SCRATCH_DEV
>> +do_mkfs_pass -d su=4096s,sw=64 $SCRATCH_DEV
>> +do_mkfs_pass -d su=4096b,sw=64 $SCRATCH_DEV
>>   do_mkfs_pass -d su=4k,sw=1 $SCRATCH_DEV
>>   do_mkfs_pass -d su=4K,sw=8 $SCRATCH_DEV
>>   do_mkfs_pass -b size=4096 -d su=1b,sw=8 $SCRATCH_DEV
>> @@ -147,8 +153,6 @@ do_mkfs_pass -s size=512 -d su=8s,sw=8 $SCRATCH_DEV
>>   do_mkfs_fail -d size=${fssize}b $SCRATCH_DEV
>>   do_mkfs_fail -d size=${fssize}s $SCRATCH_DEV
>>   do_mkfs_fail -d size=${fssize}yerk $SCRATCH_DEV
>> -do_mkfs_fail -d agsize=8192b $SCRATCH_DEV
>> -do_mkfs_fail -d agsize=65536s $SCRATCH_DEV
>>   do_mkfs_fail -d agsize=32Mbsdfsdo $SCRATCH_DEV
>>   do_mkfs_fail -d agsize=1GB $SCRATCH_DEV
>>   do_mkfs_fail -d agcount=1k $SCRATCH_DEV
>> @@ -159,13 +163,10 @@ do_mkfs_fail -d sunit=64,swidth=0 $SCRATCH_DEV
>>   do_mkfs_fail -d sunit=64,swidth=64,noalign $SCRATCH_DEV
>>   do_mkfs_fail -d sunit=64k,swidth=64 $SCRATCH_DEV
>>   do_mkfs_fail -d sunit=64,swidth=64m $SCRATCH_DEV
>> -do_mkfs_fail -d su=0,sw=64 $SCRATCH_DEV
>>   do_mkfs_fail -d su=4096,sw=0 $SCRATCH_DEV
>>   do_mkfs_fail -d su=4097,sw=1 $SCRATCH_DEV
>>   do_mkfs_fail -d su=4096,sw=64,noalign $SCRATCH_DEV
>>   do_mkfs_fail -d su=4096,sw=64s $SCRATCH_DEV
>> -do_mkfs_fail -d su=4096s,sw=64 $SCRATCH_DEV
>> -do_mkfs_fail -d su=4096b,sw=64 $SCRATCH_DEV
>>   do_mkfs_fail -d su=4096garabge,sw=64 $SCRATCH_DEV
>>   do_mkfs_fail -d su=4096,sw=64,sunit=64,swidth=64 $SCRATCH_DEV
>>   do_mkfs_fail -d sectsize=10,agsize=65536s $SCRATCH_DEV
>> @@ -206,6 +207,7 @@ do_mkfs_pass -l sunit=64 $SCRATCH_DEV
>>   do_mkfs_pass -l sunit=64 -d sunit=8,swidth=8 $SCRATCH_DEV
>>   do_mkfs_pass -l sunit=8 $SCRATCH_DEV
>>   do_mkfs_pass -l su=$((4096*10)) $SCRATCH_DEV
>> +do_mkfs_pass -l su=10b $SCRATCH_DEV
>>   do_mkfs_pass -b size=4096 -l su=10b $SCRATCH_DEV
>>   do_mkfs_pass -l sectsize=512,su=$((4096*10)) $SCRATCH_DEV
>>   do_mkfs_pass -l internal $SCRATCH_DEV
>> @@ -228,7 +230,6 @@ do_mkfs_fail -l agnum=32 $SCRATCH_DEV
>>   do_mkfs_fail -l sunit=0  $SCRATCH_DEV
>>   do_mkfs_fail -l sunit=63 $SCRATCH_DEV
>>   do_mkfs_fail -l su=1 $SCRATCH_DEV
>> -do_mkfs_fail -l su=10b $SCRATCH_DEV
>>   do_mkfs_fail -l su=10s $SCRATCH_DEV
>>   do_mkfs_fail -l su=$((4096*10+1)) $SCRATCH_DEV
>>   do_mkfs_fail -l sectsize=10,agsize=65536s $SCRATCH_DEV
>> @@ -246,7 +247,6 @@ do_mkfs_fail -l version=0  $SCRATCH_DEV
>>
>>   # naming section, should pass
>>   do_mkfs_pass -n size=65536 $SCRATCH_DEV
>> -do_mkfs_pass -n log=15 $SCRATCH_DEV
>>   do_mkfs_pass -n version=2 $SCRATCH_DEV
>>   do_mkfs_pass -n version=ci $SCRATCH_DEV
>>   do_mkfs_pass -n ftype=0 -m crc=0 $SCRATCH_DEV
>> @@ -257,6 +257,7 @@ do_mkfs_fail -n version=1 $SCRATCH_DEV
>>   do_mkfs_fail -n version=cid $SCRATCH_DEV
>>   do_mkfs_fail -n ftype=4 $SCRATCH_DEV
>>   do_mkfs_fail -n ftype=0 $SCRATCH_DEV
>> +do_mkfs_fail -n log=15 $SCRATCH_DEV
>>
>>   reset_fsimg
>>
>> @@ -273,14 +274,24 @@ do_mkfs_fail -m crc=0,finobt=1 $SCRATCH_DEV
>>   do_mkfs_fail -m crc=1 -n ftype=0 $SCRATCH_DEV
>>
>>
>> +# realtime section, results depend on reflink
>> +$MKFS_XFS_PROG -f -m reflink=0 $SCRATCH_DEV>/dev/null 2>&1
> _scratch_mkfs_xfs_supported -m reflink=0>/dev/null 2>&1
>
> This helper doesn't actually create new fs but tests the given param
> with a dry run.
>
> And I think we need _require_scratch_nocheck instead of
> _require_scratch, as we test mkfs function and do wipefs $SCRATCH_DEV
> before every test now.
>
> Thanks,
> Eryu
>
