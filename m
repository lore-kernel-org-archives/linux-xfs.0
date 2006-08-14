Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Aug 2006 07:31:40 -0700 (PDT)
Received: from alnrmhc11.comcast.net (alnrmhc14.comcast.net [206.18.177.54])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7EEVUDW009282
	for <xfs@oss.sgi.com>; Mon, 14 Aug 2006 07:31:30 -0700
Message-ID: <44E07AC6.6000104@comcast.net>
Date: Mon, 14 Aug 2006 09:29:42 -0400
From: Brian Davis <bridavis@comcast.net>
MIME-Version: 1.0
Subject: Re: Negligible improvement when using su/sw for hardware RAID5,	expected?
References: <44DD46A5.7010308@comcast.net> <1155545494.1238.11.camel@donner.tecosim.de>
In-Reply-To: <1155545494.1238.11.camel@donner.tecosim.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: utz lehmann <u.lehmann@de.tecosim.com>
Cc: xfs@oss.sgi.com

I'll admit to being ignorant here....all I did was created the Linux 
partition with fdisk and then created the fs on top of that.  Was there 
something else that needed to be done?

Thanks,
Brian

utz lehmann wrote:
> Hi
>
> You are using a partition. Is it correctly aligned? Usually the first
> partition starts at sector 63. Which is in the middle of your stripe.
> Use the whole disk (/dev/sda) or align the start of the partition to a
> multiple of the stripe size.
> But i doubt you will see a performance improvement with such a simple
> test (single threaded sequential read/ write).
>
>
> utz 
>
> On Fri, 2006-08-11 at 23:10 -0400, Brian Davis wrote:
>   
>> Is this expected? I thought I would see more improvement when tweaking 
>> my su/sw values for hardware RAID 5.
>>
>> Details, 3x300GB drives, 3Ware 7506-4LP Hardware RAID 5 using a 64K 
>> stripe size (non-configurable on this card).
>>
>> FS creation and Bonnie++ results:
>>
>> Untweaked:---------------------------------------------------------------------- 
>>
>>
>> localhost / # mkfs.xfs -f /dev/sda1
>> meta-data=/dev/sda1              isize=256    agcount=32, agsize=4578999 
>> blks
>>         =                       sectsz=512   attr=0
>> data     =                       bsize=4096   blocks=146527968, imaxpct=25
>>         =                       sunit=0      swidth=0 blks, unwritten=1
>> naming   =version 2              bsize=4096
>> log      =internal log           bsize=4096   blocks=32768, version=1
>>         =                       sectsz=512   sunit=0 blks
>> realtime =none                   extsz=65536  blocks=0, rtextents=0
>> localhost / # mount -t xfs /dev/sda1 /raid
>> localhost / # cd /raid
>> localhost raid # bonnie++ -n0 -u0 -r 768 -s 30720 -b -f
>> Using uid:0, gid:0.
>> Writing intelligently...done
>> Rewriting...done
>> Reading intelligently...done
>> start 'em...done...done...done...done...done...
>> Version 1.93c       ------Sequential Output------ --Sequential Input- 
>> --Random-
>> Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
>> --Seeks--
>> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  
>> /sec %CP
>> localhost       30G           27722  40 23847  37           98367  99  
>> 88.6  11
>> Latency                         891ms     693ms             16968us     
>> 334ms
>>
>> Tweaked:------------------------------------------------------------------------- 
>>
>>
>> localhost / # mkfs.xfs -f -d sw=2,su=64k /dev/sda1
>> meta-data=/dev/sda1              isize=256    agcount=32, agsize=4578992 
>> blks
>>         =                       sectsz=512   attr=0
>> data     =                       bsize=4096   blocks=146527744, imaxpct=25
>>         =                       sunit=16     swidth=32 blks, unwritten=1
>> naming   =version 2              bsize=4096
>> log      =internal log           bsize=4096   blocks=32768, version=1
>>         =                       sectsz=512   sunit=0 blks
>> realtime =none                   extsz=65536  blocks=0, rtextents=0
>> localhost / # mount -t xfs /dev/sda1 /raid
>> localhost / # cd /raid
>> localhost raid # bonnie++ -n0 -u0 -r 768 -s 30720 -b -f
>> Using uid:0, gid:0.
>> Writing intelligently...done
>> Rewriting...done
>> Reading intelligently...done
>> start 'em...done...done...done...done...done...
>> Version 1.93c       ------Sequential Output------ --Sequential Input- 
>> --Random-
>> Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
>> --Seeks--
>> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  
>> /sec %CP
>> localhost       30G           27938  43 23880  40           98066  99  
>> 91.8   9
>> Latency                         772ms     584ms             19889us     
>> 340ms
>>
>>     
