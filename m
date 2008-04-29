Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Apr 2008 23:34:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3T6Xmf2024933
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 23:33:50 -0700
Received: from mail.gmx.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 808CAFFDEB
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 23:34:31 -0700 (PDT)
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20]) by cuda.sgi.com with SMTP id 9qu2V464rHjmpufB for <xfs@oss.sgi.com>; Mon, 28 Apr 2008 23:34:31 -0700 (PDT)
Message-ID: <4816C175.6090505@gmx.net>
Date: Tue, 29 Apr 2008 08:34:29 +0200
From: Daniel Bast <daniel.bast@gmx.net>
MIME-Version: 1.0
Subject: Re: xfs_admin -c 1  + xfs_repair problem
References: <481617E0.3070801@gmx.net> <op.uacki1au3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.uacki1au3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi Barry,

'xfs_repair -P device' ran through and finished without any problem. So 
everything should be fine?
Or should I also run something like 'xfs_repair -P -c lazy-counts=1 
device' to make sure that one lazy-count-enable command got through?

After one '-P' run another one without '-P' doesn't finish so I'll send 
you the metadump later after finding out how to send a 28MB eMail 
attachment.

Thanks
  Daniel




Barry Naujok schrieb:
> On Tue, 29 Apr 2008 04:30:56 +1000, Daniel Bast <daniel.bast@gmx.net> 
> wrote:
> 
>> Hi,
>>
>> i tried to enable lazy counts with "xfs_admin -c 1 device" with 
>> xfs_admin from xfsprogs 2.9.8. Unfortunately that process got stuck 
>> without any message. After several hours without any IO or CPU 
>> workload i killed the process and started xfs_repair, but that also 
>> got stuck (in "Phase 6") without any IO or CPU workload or any extra 
>> message. The xfs_repair being stuck in "Phase 6" is reproduceable with 
>> a metadump-image of the filesystem.
>>
>> I was able to mount the device but don't want to use it because i'm 
>> not sure if everything is ok.
> 
> "xfs_admin -c 1" internally runs xfs_repair and hence why it got stuck
> too. Your filesystems is fine, the only changes that occured for enabling
> lazy-counters was in Phase 5, but may not have been written to disk.
> 
>> How can i resolve that problem? What information do you need? I can 
>> provide the metadump image (bzip compressed: 28MB) if necessary.
> 
> Run xfs_repair -P <device> to disable prefetch.
> 
> The metadump would be very useful in finding out why xfs_repair got stuck.
> 
> Regards,
> Barry.
> 
>> Here are some informations that are maybe useful:
>>
>>   xfs_repair -v /dev/sda7
>>   Phase 1 - find and verify superblock...
>>           - block cache size set to 11472 entries
>>   Phase 2 - using internal log
>>           - zero log...
>>   zero_log: head block 2 tail block 2
>>           - scan filesystem freespace and inode maps...
>>           - found root inode chunk
>>   Phase 3 - for each AG...
>>           - scan and clear agi unlinked lists...
>>           - process known inodes and perform inode discovery...
>>           - agno = 0
>>           - agno = 1
>>           - agno = 2
>>           - agno = 3
>>           - process newly discovered inodes...
>>   Phase 4 - check for duplicate blocks...
>>           - setting up duplicate extent list...
>>           - check for inodes claiming duplicate blocks...
>>           - agno = 0
>>           - agno = 1
>>           - agno = 2
>>           - agno = 3
>>   Phase 5 - rebuild AG headers and trees...
>>           - agno = 0
>>           - agno = 1
>>           - agno = 2
>>           - agno = 3
>>           - reset superblock...
>>   Phase 6 - check inode connectivity...
>>           - resetting contents of realtime bitmap and summary inodes
>>           - traversing filesystem ...
>>           - agno = 0
>>
>>
>> after the killed xfs_admin -c 1 and xfs_repair processes:
>> xfs_info /dev/sda7
>> meta-data=/dev/sda7              isize=256    agcount=4, 
>> agsize=24719013 blks
>>           =                       sectsz=512   attr=2
>> data     =                       bsize=4096   blocks=98876050, imaxpct=25
>>           =                       sunit=0      swidth=0 blks
>> naming   =version 2              bsize=4096
>> log      =internal               bsize=4096   blocks=32768, version=2
>>           =                       sectsz=512   sunit=0 blks, lazy-count=1
>> realtime =none                   extsz=65536  blocks=0, rtextents=0
>>
>>
>> a new 'xfs_repair -v /dev/sda7' straced:
>> strace -ff -p 6364
>> Process 6409 attached with 6 threads - interrupt to quit
>> [pid  6364] futex(0x851e2cc, FUTEX_WAIT, 2, NULL <unfinished ...>
>> [pid  6405] futex(0xb146e3d8, FUTEX_WAIT, 0, NULL <unfinished ...>
>> [pid  6406] futex(0xb146e358, FUTEX_WAIT, 1, NULL <unfinished ...>
>> [pid  6407] futex(0xb146e358, FUTEX_WAIT, 2, NULL <unfinished ...>
>> [pid  6408] futex(0xb146e358, FUTEX_WAIT, 3, NULL <unfinished ...>
>> [pid  6409] futex(0xb146e358, FUTEX_WAIT, 4, NULL <unfinished ...>
>> [pid  6406] <... futex resumed> )       = -1 EAGAIN (Resource 
>> temporarily unavailable)
>> [pid  6407] <... futex resumed> )       = -1 EAGAIN (Resource 
>> temporarily unavailable)
>> [pid  6408] <... futex resumed> )       = -1 EAGAIN (Resource 
>> temporarily unavailable)
>> [pid  6406] futex(0xb146e358, FUTEX_WAIT, 4, NULL <unfinished ...>
>> [pid  6407] futex(0xb146e358, FUTEX_WAIT, 4, NULL <unfinished ...>
>> [pid  6408] futex(0xb146e358, FUTEX_WAIT, 4, NULL
>>
>>
>> Thanks
>>   Daniel
>>
>> P.S. Please CC me, because i'm not subscribed to the list.
>>
>>
> 
> 
