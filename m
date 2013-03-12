Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CE6957F69
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 06:06:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5DFD7AC007
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 04:05:58 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id vtnjjUTmAOWNbewI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 12 Mar 2013 04:05:57 -0700 (PDT)
Message-ID: <513F0C07.1060000@oracle.com>
Date: Tue, 12 Mar 2013 19:05:43 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [ASSERT failure] transaction reservations changes bad?
References: <20130312062001.GJ21651@dastard> <20130312062531.GK21651@dastard>
	<513EE274.6090808@oracle.com> <20130312103138.GN21651@dastard>
In-Reply-To: <20130312103138.GN21651@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 03/12/2013 06:31 PM, Dave Chinner wrote:
> On Tue, Mar 12, 2013 at 04:08:20PM +0800, Jeff Liu wrote:
>> Hi Dave,
>>
>> On 03/12/2013 02:25 PM, Dave Chinner wrote:
>>> On Tue, Mar 12, 2013 at 05:20:02PM +1100, Dave Chinner wrote:
>>>> Folks,
>>>>
>>>> I just got this ASSERT failure running xfstests on a 3.1.8 xfsprogs
>>>> and a 3.9-rc1 kernel running test 297:
>>>
>>> FYI, it's 100% reproducable here with:
>>>
>>> # sudo MKFS_OPTIONS="-b size=512" ./check 297
>>>
>>> (reproduced on multiple VMs now with the same command line)
> ....
>>>> This implies that the permanent transaction reservation ended up
>>>> larger than the log itself:
>>>>
>>>> $ sudo xfs_info /mnt/scratch/
>>>> [sudo] password for dave: 
>>>> meta-data=/dev/vdb               isize=256    agcount=16, agsize=1441792 blks
>>>>          =                       sectsz=512   attr=2
>>>> data     =                       bsize=512    blocks=23068672, imaxpct=25
>>>>          =                       sunit=512    swidth=6144 blks
>>>> naming   =version 2              bsize=4096   ascii-ci=0
>>>> log      =internal               bsize=512    blocks=2560, version=2
>>>>          =                       sectsz=512   sunit=512 blks, lazy-count=1
>>>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>>>>
>>>> Can someone please check that the before/after mkdir transaction
>>>> reservation sizes are unchanged for such a configuration?
>> I just did a quick verification. 
>>
>> # mkfs.xfs -V
>> mkfs.xfs version 3.1.8
>>
>> # uname -a
>> Linux koala 3.9.0-rc1 #80 SMP Tue Mar 12 15:06:39 CST 2013 x86_64 x86_64 x86_64 GNU/Linux
>>
>> # mkfs.xfs -f -b size=512 /dev/sda6
>> meta-data=/dev/sda6              isize=256    agcount=4, agsize=5242880 blks
>>          =                       sectsz=512   attr=2, projid32bit=0
>> data     =                       bsize=512    blocks=20971520, imaxpct=25
>>          =                       sunit=0      swidth=0 blks
>> naming   =version 2              bsize=4096   ascii-ci=0
>> log      =internal log           bsize=512    blocks=20480, version=2
>>          =                       sectsz=512   sunit=0 blks, lazy-count=1
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> That's a different mkfs.xfs config to what test 297 is using.
> Different log size, different AG count, no log stripe unit, etc.
> 297 is using:
> 
> scratch_mkfs_xfs -d agcount=16,su=256k,sw=12 -l su=256k,size=2560b <dev>
> 
> And when I add the extra MKFS_OPTIONS in it actually is:
> 
> # mkfs.xfs -b size=512 -d agcount=16,su=256k,sw=12 -l su=256k,size=2560b <dev>
> 
>> The reservation size does not changed, both are 70072 bytes:
>>
>> [  230.905092] xfs_calc_mkdir_reservation: res=70072 bytes.
> 
> And it's not just the calculation that I'm worried about here - it's
> the actual reservation that ends up in the ticket that matters as
> that is fed into the code that has triggered the assert. The value
> in the ticket takes into account log stripe units and other
> roundings, so it's typically much larger than just the reservation
> calculation itself...
> 
>> However, I can always reproducing this issue with
>> '"MKFS_OPTIONS=-b size=512" ./check 297' as well.
> 
> Can you check that it also fails on kernels prior to the reservation
> changes? That will rule out it being a recent regression...
Sure, verified against a new built 3.8.0 kernel, so this should be a
regression issue.
$ uname -a
Linux koala 3.8.0 #81 SMP Tue Mar 12 18:03:44 CST 2013 x86_64 x86_64
x86_64 GNU/Linux

commit 19f949f52599ba7c3f67a5897ac6be14bfcb1200
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Feb 18 15:58:34 2013 -0800

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
