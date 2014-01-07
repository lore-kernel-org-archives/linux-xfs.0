Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B3FE47F37
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 20:20:31 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6D50B304082
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 18:20:28 -0800 (PST)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id rRAUIkuVOScfRplu for
	<xfs@oss.sgi.com>; Mon, 06 Jan 2014 18:20:23 -0800 (PST)
Message-ID: <52CB642C.10500@cn.fujitsu.com>
Date: Tue, 07 Jan 2014 10:19:24 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: fix wrong return check for case 022
References: <1388995737-3480-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
	<52CA67F2.9010108@jp.fujitsu.com> <52CA6DDF.3080306@cn.fujitsu.com>
	<52CB5441.3030004@jp.fujitsu.com>
In-Reply-To: <52CB5441.3030004@jp.fujitsu.com>
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

On 01/07/2014 09:11 AM, Tsutomu Itoh wrote:
> On 2014/01/06 17:48, Wang Shilong wrote:
>> Itoh San,
>>
>> On 01/06/2014 04:23 PM, Tsutomu Itoh wrote:
>>> On 2014/01/06 17:08, Wang Shilong wrote:
>>>> Here we expect 0 as return value, fix it.
>>>>
>>>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>>> Cc: Josef Bacik <jbacik@fb.com>
>>>> ---
>>>>    tests/btrfs/022 | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>    mode change 100644 => 100755 tests/btrfs/022
>>>>
>>>> diff --git a/tests/btrfs/022 b/tests/btrfs/022
>>>> old mode 100644
>>>> new mode 100755
>>>> index 5b18643..142aaf9
>>>> --- a/tests/btrfs/022
>>>> +++ b/tests/btrfs/022
>>>> @@ -106,7 +106,7 @@ _limit_test()
>>>>    	[ $? -ne 0 ] || _fail "quota should have limited us"
>>>>    	dd if=/dev/urandom of=$SCRATCH_MNT/a/file bs=4M count=1 >> \
>>>>    		$seqres.full 2>&1
>>>> -	[ $? -eq 0 ] || _fail "should have been allowed to write"
>>>> +	[ $? -ne 0 ] || _fail "should have been allowed to write"
>>> from "man bash",
>>>         An OR list has the form
>>>                command1 || command2
>>>         command2 is executed if and only if command1 returns a non-zero exit
>>>         status.
>>>
>>> So, original code is OK, I think.
>> You are absolutely right, during my test i found we fail this case.
>> I took a careful think about this:
>>
>> The problem is that we should clear the data we have written before,
>> Because we may write some data before, for example we limit subvolume to 5M
>> then we try this:
>>
>> # dd if=/dev/zero of=/mnt/data bs=10M count=1
>>
>> Although we try to write 10M once, in kernel, we may split it into
>> several request,
>> at the end, we can still write some data actually, you can try the
>> following command
>> after the above command.
>>
>> # du -sh /mnt/data
>>
>> Here i think the best way to fix this problem is we disable quota and
>> retry with 4m.
> Umm... I don't think so.
> Writing (or truncating) succeeds if sync is executed before writing 4MB.
> Therefore, I think that there are some problems in quota.
Itoh-San,

The problem is that 'btrfs filesystem sync' will flush and commit
transaction
which will release some space, and this may give us enough space to reserve
metadata space to truncate/remove file.

For the below example:

# dd if=/dev/zero of=/mnt/data bs=10M count=1
# sync
# btrfs qgroup show /mnt

qgroupid rfer excl
-------- ---- ----
0/5 5177344 5177344

Limit is 5M which means we still leave 65536 bytes space(4 leafsize).

If you try:
# rm -f /mnt/data

It must fail, because, unlink a file will first try to
reserve 5 nodesize(see __unlink_start_trans())

Let's see why truncate can succeed!

# btrfs-debug-tree /dev/sda

fs tree key (FS_TREE ROOT_ITEM 0)
leaf 29966336 items 7 free space 15641 generation 11 owner 5
fs uuid 2b854d8d-710c-43c5-a6d5-0cb8b6b232ea
chunk uuid 9b65e155-33b3-44d3-a413-bbc97af700a7
item 0 key (256 INODE_ITEM 0) itemoff 16123 itemsize 160
inode generation 3 transid 11 size 8 block group 0 mode 40755 links 1
item 1 key (256 INODE_REF 256) itemoff 16111 itemsize 12
inode ref index 0 namelen 2 name: ..
item 2 key (256 DIR_ITEM 2355243158) itemoff 16077 itemsize 34
location key (259 INODE_ITEM 0) type FILE
namelen 4 datalen 0 name: data
item 3 key (256 DIR_INDEX 4) itemoff 16043 itemsize 34
location key (259 INODE_ITEM 0) type FILE
namelen 4 datalen 0 name: data
item 4 key (259 INODE_ITEM 0) itemoff 15883 itemsize 160
inode generation 11 transid 11 size 5160960 block group 0 mode 100644
links 1
item 5 key (259 INODE_REF 256) itemoff 15869 itemsize 14
inode ref index 4 namelen 4 name: data
item 6 key (259 EXTENT_DATA 0) itemoff 15816 itemsize 53
extent data disk byte 12713984 nr 5160960
extent data offset 0 nr 5160960 ram 5160960
extent compression 0


For truncating inode, we will reserve 2 leafsize every time and and then
free qgroup
reserved space in btrfs_end_transaction(), however, for this case, we
only do one loop.
So command 'truncate -s 0 /mnt/data' should return successfully.

Please correct me if i miss something here ^_^

Thanks,
Wang
>
> ===============================================================
>
> # mkfs.btrfs -f /dev/sdc2
>
> WARNING! - Btrfs v3.12 IS EXPERIMENTAL
> WARNING! - see http://btrfs.wiki.kernel.org before using
>
> Turning ON incompat feature 'extref': increased hardlink limit per file to 65536
> fs created label (null) on /dev/sdc2
>         nodesize 16384 leafsize 16384 sectorsize 4096 size 9.31GiB
> Btrfs v3.12
> # mount /dev/sdc2 /test8
> # btrfs quota enable /test8
> # btrfs qgroup limit 5M /test8
> # dd if=/dev/zero of=/test8/file1 bs=10M count=1
> dd: error writing '/test8/file1': Disk quota exceeded
> 1+0 records in
> 0+0 records out
> 5160960 bytes (5.2 MB) copied, 0.012274 s, 420 MB/s
> # ls -ls /test8/file1
> 5040 -rw-r--r-- 1 root root 5160960 Jan  7 09:54 /test8/file1
> # truncate -s 0 /test8/file1
> truncate: failed to truncate '/test8/file1' at 0 bytes: Disk quota exceeded
> # ls -ls /test8/file1
> 5040 -rw-r--r-- 1 root root 5160960 Jan  7 09:54 /test8/file1
> # dd if=/dev/zero of=/test8/file1 bs=4M count=1
> dd: failed to open '/test8/file1': Disk quota exceeded
> # ls -ls /test8/file1
> 5040 -rw-r--r-- 1 root root 5160960 Jan  7 09:54 /test8/file1
> #
>
> ---------------------------------------------------------------
>
> # mkfs.btrfs -f /dev/sdc2
>
> WARNING! - Btrfs v3.12 IS EXPERIMENTAL
> WARNING! - see http://btrfs.wiki.kernel.org before using
>
> Turning ON incompat feature 'extref': increased hardlink limit per file to 65536
> fs created label (null) on /dev/sdc2
>         nodesize 16384 leafsize 16384 sectorsize 4096 size 9.31GiB
> Btrfs v3.12
> # mount /dev/sdc2 /test8
> # btrfs quota enable /test8
> # btrfs qgroup limit 5M /test8
> # dd if=/dev/zero of=/test8/file1 bs=10M count=1
> dd: error writing '/test8/file1': Disk quota exceeded
> 1+0 records in
> 0+0 records out
> 5160960 bytes (5.2 MB) copied, 0.0120232 s, 429 MB/s
> # ls -ls /test8/file1
> 5040 -rw-r--r-- 1 root root 5160960 Jan  7 09:54 /test8/file1
> # btrfs filesystem sync /test8
> FSSync '/test8'
> # truncate -s 0 /test8/file1
> # ls -ls /test8/file1
> 0 -rw-r--r-- 1 root root 0 Jan  7 09:54 /test8/file1
> # dd if=/dev/zero of=/test8/file1 bs=4M count=1
> 1+0 records in
> 1+0 records out
> 4194304 bytes (4.2 MB) copied, 0.00734557 s, 571 MB/s
> # ls -ls /test8/file1
> 4096 -rw-r--r-- 1 root root 4194304 Jan  7 09:54 /test8/file1
> #
>
> ===============================================================
>
> Thanks,
> Tsutomu
>
>> # btrfs qgroup limit none /mnt <------------- in case we are nearly full
>> and we can not delete file.
>> # rm -rf /mnt/data && btrfs filesystem sync /mnt
>> # btrfs qgroup limit 5m /mnt
>> # dd if=/dev/zero of=/mnt bs=4m count=1
>>
>> Please correct me if i miss something here.^_^
>>
>> Thanks,
>> Wang
>>> Thanks,
>>> Tsutomu
>>>
>>>>    }
>>>>    
>>>>    _scratch_mkfs > /dev/null 2>&1
>>>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
