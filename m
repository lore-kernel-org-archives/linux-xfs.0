Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 508997F50
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 20:08:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2D2868F8033
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 18:08:31 -0800 (PST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [119.145.14.64])
	by cuda.sgi.com with ESMTP id KcLErodk7eZh0F94 (version=TLSv1
	cipher=RC4-SHA bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Feb 2014 18:08:28 -0800 (PST)
Message-ID: <530BFB0C.7080602@huawei.com>
Date: Tue, 25 Feb 2014 10:08:12 +0800
From: ZhangZhen <zhenzhang.zhang@huawei.com>
MIME-Version: 1.0
Subject: Re: [PATCH for xfstests] xfstests: fix to make tests/btrfs/013 really
	work
References: <530AF3E3.9060202@huawei.com> <530B2418.20905@huawei.com>
	<530B26C9.9060606@cn.fujitsu.com>
In-Reply-To: <530B26C9.9060606@cn.fujitsu.com>
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
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Hi Wang,
Thank you for reviewing my patch.

I ran the test using btrfs progs v0.19(OpenSuse 12.3) previously and got a fail situation.
I verified v3.12 this morning and it work well as you mentioned.

Althouth the new version doesn't have this problem, I think it would be better to fix this.
I'll fix the titile and resend it.

On 2014/2/24 19:02, Wang Shilong wrote:
> Hi Zhang,
> 
> On 02/24/2014 06:51 PM, ZhangZhen wrote:
>> The test 013 couldn't work because here lacked "start".
>> This patch fix it.
>>
>> Signed-off-by: Zhang Zhen<zhenzhang.zhang@huawei.com>
>> ---
>>   tests/btrfs/013 | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tests/btrfs/013 b/tests/btrfs/013
>> index 7620fcc..fb81663 100644
>> --- a/tests/btrfs/013
>> +++ b/tests/btrfs/013
>> @@ -72,7 +72,7 @@ _check_csum_error()
>>   }
>>   $XFS_IO_PROG -f -c "falloc 0 1M" -c "pwrite 16k 8k" -c "fsync" \
>>       $SCRATCH_MNT/foo > $seqres.full 2>&1
>> -$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT >> $seqres.full 2>&1 || \
>> +$BTRFS_UTIL_PROG filesystem balance start $SCRATCH_MNT >> $seqres.full 2>&1 || \
>>       _fail "balance failed"
> Due to historical reasons, we have 'btrfs file balance <>'.. Until now, it is also
> ok to run 'btrfs file balance <mnt>', and it has equal effect as 'btrfs filesystem balance start'.
> 
> Anyway, using latest 'btrfs file balance start <mnt>' is better than previous codes..but patch's
> title is not right any more...
> 
> BTW,Dave Chinner previously pointed out that we need a cleanup, url can be seen:
> 
> http://oss.sgi.com/archives/xfs/2014-02/msg00482.html
> 
> Thanks,
> Wang
>>   _scratch_unmount
>>   _scratch_mount
> 
> 
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
