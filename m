Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BA8387F4E
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 02:49:31 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A57F18F8035
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 00:49:28 -0800 (PST)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id Bi7nGfqChJ1hsaKc for
	<xfs@oss.sgi.com>; Mon, 06 Jan 2014 00:49:26 -0800 (PST)
Message-ID: <52CA6DDF.3080306@cn.fujitsu.com>
Date: Mon, 06 Jan 2014 16:48:31 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix wrong return check for case 022
References: <1388995737-3480-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
	<52CA67F2.9010108@jp.fujitsu.com>
In-Reply-To: <52CA67F2.9010108@jp.fujitsu.com>
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
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Itoh San,

On 01/06/2014 04:23 PM, Tsutomu Itoh wrote:
> On 2014/01/06 17:08, Wang Shilong wrote:
>> Here we expect 0 as return value, fix it.
>>
>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>> Cc: Josef Bacik <jbacik@fb.com>
>> ---
>>   tests/btrfs/022 | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>   mode change 100644 => 100755 tests/btrfs/022
>>
>> diff --git a/tests/btrfs/022 b/tests/btrfs/022
>> old mode 100644
>> new mode 100755
>> index 5b18643..142aaf9
>> --- a/tests/btrfs/022
>> +++ b/tests/btrfs/022
>> @@ -106,7 +106,7 @@ _limit_test()
>>   	[ $? -ne 0 ] || _fail "quota should have limited us"
>>   	dd if=/dev/urandom of=$SCRATCH_MNT/a/file bs=4M count=1 >> \
>>   		$seqres.full 2>&1
>> -	[ $? -eq 0 ] || _fail "should have been allowed to write"
>> +	[ $? -ne 0 ] || _fail "should have been allowed to write"
> from "man bash",
>        An OR list has the form
>               command1 || command2
>        command2 is executed if and only if command1 returns a non-zero exit
>        status.
>
> So, original code is OK, I think.

You are absolutely right, during my test i found we fail this case.
I took a careful think about this:

The problem is that we should clear the data we have written before,
Because we may write some data before, for example we limit subvolume to 5M
then we try this:

# dd if=/dev/zero of=/mnt/data bs=10M count=1

Although we try to write 10M once, in kernel, we may split it into
several request,
at the end, we can still write some data actually, you can try the
following command
after the above command.

# du -sh /mnt/data

Here i think the best way to fix this problem is we disable quota and
retry with 4m.

# btrfs qgroup limit none /mnt <------------- in case we are nearly full
and we can not delete file.
# rm -rf /mnt/data && btrfs filesystem sync /mnt
# btrfs qgroup limit 5m /mnt
# dd if=/dev/zero of=/mnt bs=4m count=1

Please correct me if i miss something here.^_^

Thanks,
Wang
> Thanks,
> Tsutomu
>
>>   }
>>   
>>   _scratch_mkfs > /dev/null 2>&1
>>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
