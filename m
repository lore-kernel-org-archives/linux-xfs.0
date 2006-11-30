Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Nov 2006 17:16:22 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAU1GAaG015225
	for <xfs@oss.sgi.com>; Wed, 29 Nov 2006 17:16:13 -0800
Message-ID: <456E30A5.6080109@melbourne.sgi.com>
Date: Thu, 30 Nov 2006 12:15:17 +1100
From: David Chatterton <chatz@melbourne.sgi.com>
Reply-To: chatz@melbourne.sgi.com
MIME-Version: 1.0
Subject: Re: inode64 workaround
References: <200611290027.AA04740@TNESG9305.tnes.nec.co.jp> <1164838985.4992.30.camel@edge> <456E1B08.7090802@delusion.com> <456E2A30.4010101@melbourne.sgi.com> <456E2D0E.2000007@delusion.com>
In-Reply-To: <456E2D0E.2000007@delusion.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Deanan <delusion@delusion.com>
Cc: xfs@oss.sgi.com

This is a sysctl, see sysctl(8).

It was introduced to XFS in October 2004, I'm not sure if it made 2.6.9.

If this doesn't help a little then I'm unsure why you think that inode64 is
going to solve your problem?

David


Deanan wrote:
> Hi David,
> 
> I'm not sure if it will help but I'd like to try.
> Where do you set the rotor?
>  BTW< tis particular box is 2.6.9.
> 
> Thanks,
> 
> Deanan
> 
> 
>> Deanan,
>>
>> Would something like the inode rotor help?
>>
>>   fs.xfs.rotorstep              (Min: 1  Default: 1  Max: 256)
>>
>>         In "inode32" allocation mode, this option determines how many
>>
>>         files the allocator attempts to allocate in the same allocation
>>
>>         group before moving to the next allocation group.  The intent
>>
>>         is to control the rate at which the allocator moves between
>>
>>         allocation groups when allocating extents for new files.
>>
>> David
>>
>>
>> Deanan wrote:
>>   
>>> Hi,
>>>
>>> I've got some systems that I can't change the kernel on (external
>>> vendor) that
>>> are 32bit but I'm running into the performance problem that is fixed by
>>> using
>>> inode64. Is there any known way of working around the problem on a 32bit
>>> kernel?
>>>
>>> In our case, the problem occurs as soon as you start to delete files and
>>> write new ones.
>>>
>>> Cheers,
>>>
>>> Deanan
>>>
>>>     
>>
>>   
> 

-- 
David Chatterton
XFS Engineering Manager
SGI Australia
