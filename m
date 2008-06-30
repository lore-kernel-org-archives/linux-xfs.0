Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 29 Jun 2008 23:06:28 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5U66PC7016228
	for <xfs@oss.sgi.com>; Sun, 29 Jun 2008 23:06:25 -0700
Received: from bby1mta03.pmc-sierra.bc.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 880BA1239AB0
	for <xfs@oss.sgi.com>; Sun, 29 Jun 2008 23:07:27 -0700 (PDT)
Received: from bby1mta03.pmc-sierra.bc.ca (bby1mta03.pmc-sierra.com [216.241.235.118]) by cuda.sgi.com with ESMTP id dXiK2ua1FRBgiFA2 for <xfs@oss.sgi.com>; Sun, 29 Jun 2008 23:07:27 -0700 (PDT)
Received: from bby1mta03.pmc-sierra.bc.ca (localhost.pmc-sierra.bc.ca [127.0.0.1])
	by localhost (Postfix) with SMTP id 872061070598
	for <xfs@oss.sgi.com>; Sun, 29 Jun 2008 23:09:55 -0700 (PDT)
Received: from bby1exg02.pmc_nt.nt.pmc-sierra.bc.ca (BBY1EXG02.pmc-sierra.bc.ca [216.241.231.167])
	by bby1mta03.pmc-sierra.bc.ca (Postfix) with SMTP id 5C904107049A
	for <xfs@oss.sgi.com>; Sun, 29 Jun 2008 23:09:55 -0700 (PDT)
Message-ID: <4868781B.40907@pmc-sierra.com>
Date: Mon, 30 Jun 2008 11:37:23 +0530
From: Sagar Borikar <sagar_borikar@pmc-sierra.com>
MIME-Version: 1.0
Subject: Re: Xfs Access to block zero  exception and system crash
References: <340C71CD25A7EB49BFA81AE8C839266701323BD8@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <20080625084931.GI16257@build-svl-1.agami.com> <340C71CD25A7EB49BFA81AE8C839266701323BE8@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <20080626070215.GI11558@disturbed> <4864BD5D.1050202@pmc-sierra.com> <4864C001.2010308@pmc-sierra.com> <20080628000516.GD29319@disturbed> <340C71CD25A7EB49BFA81AE8C8392667028A1CA7@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <20080629215647.GJ29319@disturbed> <20080630034112.055CF18904C4@bby1mta01.pmc-sierra.bc.ca>
In-Reply-To: <20080630034112.055CF18904C4@bby1mta01.pmc-sierra.bc.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com



Sagar Borikar wrote:
> Dave Chinner wrote:
>> On Sat, Jun 28, 2008 at 09:47:44AM -0700, Sagar Borikar wrote:
>>   Device Boot Start End Blocks Id System
>>> /dev/scsibd1             126         286       20608   83  Linux
>>> /dev/scsibd2             287        1023       94336   83  Linux
>>> /dev/scsibd3            1149        1309       20608   83  Linux
>>> /dev/scsibd4            1310        2046       94336   83  Linux
>>>     
>>
>> I'd have to assume thats a flash based root drive, right?
>>
>>   
> That's right,
>>> Disk /dev/md0: 251.0 GB, 251000160256 bytes
>>> 2 heads, 4 sectors/track, 61279336 cylinders
>>> Units = cylinders of 8 * 512 = 4096 bytes
>>>
>>> Disk /dev/md0 doesn't contain a valid partition table
>>>
>>> Disk /dev/dm-0: 107.3 GB, 107374182400 bytes
>>> 255 heads, 63 sectors/track, 13054 cylinders
>>> Units = cylinders of 16065 * 512 = 8225280 bytes
>>>     
>>
>> Neither of these tell me what /dev/RAIDA/vol is....
>> It is the device node to which /mnt/RAIDA/vol is mapped to. Its a 
>> JBOD with 233 GB size.
>>  
>>> But still the issue is why doesn't it happen every time and less 
>>> stress?
>>>
>>> I am surprised to see to let this happen immediately when the
>>> subdirectories increase more than 30. Else it decays slowly.
>>>     
>>
>> So it happens when you get more than 30 entries in a directory
>> under a certain load? That might be an extent->btree format
>> conversion bug or vice versa. I'd suggest setting up a test based
>> around this to try to narrow down the problem.
>>
>> Cheers,
>>
>> Dave.
>>   
> Thanks for all your help. Shall keep you posted with the progress on 
> debugging.
>
> Regards
> Sagar
>
>
Sorry if I was not clear.  As I mentioned the frequency of finding bad 
extents is much higher
when I increase simultaneous transactions to 30 ( say in 5 min ) but if 
I run only
two copies in infinite loop, the issue crops up in 2-3 hours roughly. 
And all the copies plus pdflush
are in uninterruptible sleep state continuously. And it is not 
uninterruptible sleep and waiting state ( DW )  but
just uninterruptible ( D ). 

Thanks
Sagar
