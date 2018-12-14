Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from amazon.4net.rs ([159.69.148.70]:50856 "EHLO amazon.4net.rs"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726437AbeLNHDk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Dec 2018 02:03:40 -0500
Subject: Re: XFS and RAID10 with o2 layout
References: <d9fc0327-eef3-63bd-82a3-98545251bfe5@4net.rs>
 <20181213220533.GH6311@dastard>
From: Sinisa <sinisa@4net.rs>
Message-ID: <3e0e8def-2bb4-5e8a-56c1-d010ede059d4@4net.rs>
Date: Fri, 14 Dec 2018 08:03:36 +0100
MIME-Version: 1.0
In-Reply-To: <20181213220533.GH6311@dastard>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-raid@vger.kernel.org
Cc: linux-xfs@vger.kernel.org


On 12/13/18 11:05 PM, Dave Chinner wrote:
> On Wed, Dec 12, 2018 at 01:29:49PM +0100, Sinisa wrote:
>> Hello group,
>>
>> I have noticed something strange going on lately, but recently I
>> have come to conclusion that there is some unwanted interaction
>> between XFS and Linux RAID10 with "offset" layout.
>>
>> So here is the problem: I create a Linux RAID10 mirror with 2 disks
>> (HDD or SSD) and "o2" layout (best choice for read and write speed):
>> # mdadm -C -n2 -l10 -po2 /dev/mdX /dev/sdaX /dev/sdbX
>> # mkfs.xfs /dev/mdX
>> # mount /dev/mdX /mnt
>> # rsync -avxDPHS / /mnt
>>
>> So we have RAID10 initializing:
>>
>> # cat /proc/mdstat
>> Personalities : [raid1] [raid10]
>> md2 : active raid10 sdb3[1] sda3[0]
>>        314433536 blocks super 1.2 4096K chunks 2 offset-copies [2/2] [UU]
>>        [==>..................]  resync = 11.7% (36917568/314433536)
>> finish=8678.2min speed=532K/sec
>>        bitmap: 3/3 pages [12KB], 65536KB chunk
>>
>> but after a few minutes everything stops like you can see above.
>> Rsync (or any other process writing to that md device) also freezes.
>> If I try to read already copied files - freeze, usually with less
>> that 2GB copied.
> Just a quick note:
>
>> [ 1463.756426]  schedule+0x78/0x110
>> [ 1463.756433]  wait_barrier+0xdd/0x170 [raid10]
>> [ 1463.756448]  raid10_write_request+0xf2/0x900 [raid10]
>> [ 1463.756492]  raid10_make_request+0xc1/0x120 [raid10]
>> [ 1463.756514]  md_handle_request+0x121/0x190 [md_mod]
>> [ 1463.756535]  md_make_request+0x78/0x190 [md_mod]
>> [ 1463.756544]  generic_make_request+0x1c6/0x470
> This is XFS IO submission waiting on a MD sync barrier.
>
>> [ 1463.757013] Workqueue: md submit_flushes [md_mod]
>> [ 1463.757016] Call Trace:
>> [ 1463.757039]  schedule+0x78/0x110
>> [ 1463.757047]  wait_barrier+0xdd/0x170 [raid10]
>> [ 1463.757062]  raid10_write_request+0xf2/0x900 [raid10]
>> [ 1463.757104]  raid10_make_request+0xc1/0x120 [raid10]
>> [ 1463.757126]  md_handle_request+0x121/0x190 [md_mod]
>> [ 1463.757156]  submit_flushes+0x21/0x40 [md_mod]
>> [ 1463.757163]  process_one_work+0x1fd/0x420
>> [ 1463.757170]  worker_thread+0x2d/0x3d0
>> [ 1463.757177]  ? rescuer_thread+0x340/0x340
>> [ 1463.757181]  kthread+0x112/0x130
> This is an MD flush thread waiting on a MD sync barrier.
>
>> [ 1463.757212] md1_resync      D    0  5215      2 0x80000000
>> [ 1463.757216] Call Trace:
>> [ 1463.757236]  schedule+0x78/0x110
>> [ 1463.757243]  raise_barrier+0x8d/0x140 [raid10]
>> [ 1463.757257]  raid10_sync_request+0x1f6/0x1e30 [raid10]
>> [ 1463.757302]  md_do_sync.cold.78+0x404/0x969 [md_mod]
>> [ 1463.757351]  md_thread+0xe9/0x140 [md_mod]
> THis is the MD resync thread raising the sync barrier and waiting
> for all waiters to drain and pending IO to drain away.
>
>> [ 1463.757426]  schedule+0x78/0x110
>> [ 1463.757433]  wait_barrier+0xdd/0x170 [raid10]
>> [ 1463.757446]  raid10_write_request+0xf2/0x900 [raid10]
>> [ 1463.757485]  raid10_make_request+0xc1/0x120 [raid10]
>> [ 1463.757507]  md_handle_request+0x121/0x190 [md_mod]
>> [ 1463.757527]  md_make_request+0x78/0x190 [md_mod]
>> [ 1463.757536]  generic_make_request+0x1c6/0x470
>> [ 1463.757544]  submit_bio+0x45/0x140
> XFS waiting on MD sync barrier.
>
>> [ 1463.760718] Workqueue: md submit_flushes [md_mod]
>> [ 1463.760721] Call Trace:
>> [ 1463.760746]  schedule+0x78/0x110
>> [ 1463.760753]  wait_barrier+0xdd/0x170 [raid10]
>> [ 1463.760768]  raid10_write_request+0xf2/0x900 [raid10]
>> [ 1463.760810]  raid10_make_request+0xc1/0x120 [raid10]
>> [ 1463.760831]  md_handle_request+0x121/0x190 [md_mod]
>> [ 1463.760851]  md_make_request+0x78/0x190 [md_mod]
>> [ 1463.760860]  generic_make_request+0x1c6/0x470
>> [ 1463.760870]  raid10_write_request+0x77a/0x900 [raid10]
>> [ 1463.760904]  raid10_make_request+0xc1/0x120 [raid10]
>> [ 1463.760926]  md_handle_request+0x121/0x190 [md_mod]
>> [ 1463.760954]  submit_flushes+0x21/0x40 [md_mod]
> And another MD flush thread waiting on a MD sync barrier.
>
> Basically, this looks and smells like a MD sync barrier race
> condition, not an XFs problem.
>
> Cheers,
>
> Dave.

But why don't we see the same issue with other filesystems?


Srdačan pozdrav / Best regards,
Siniša Bandin
