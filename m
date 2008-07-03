Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Jul 2008 22:14:08 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m635E2Tr007042
	for <xfs@oss.sgi.com>; Wed, 2 Jul 2008 22:14:04 -0700
Received: from bby1mta01.pmc-sierra.bc.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 82E6AD94B21
	for <xfs@oss.sgi.com>; Wed,  2 Jul 2008 22:15:05 -0700 (PDT)
Received: from bby1mta01.pmc-sierra.bc.ca (bby1mta01.pmc-sierra.com [216.241.235.116]) by cuda.sgi.com with ESMTP id X46MIiRAmP9gobKW for <xfs@oss.sgi.com>; Wed, 02 Jul 2008 22:15:05 -0700 (PDT)
Message-ID: <486C6053.7010503@pmc-sierra.com>
Date: Thu, 03 Jul 2008 10:44:59 +0530
From: Sagar Borikar <sagar_borikar@pmc-sierra.com>
MIME-Version: 1.0
Subject: Re: Xfs Access to block zero  exception and system crash
References: <20080628000516.GD29319@disturbed> <340C71CD25A7EB49BFA81AE8C8392667028A1CA7@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <20080629215647.GJ29319@disturbed> <20080630034112.055CF18904C4@bby1mta01.pmc-sierra.bc.ca> <4868B46C.9000200@pmc-sierra.com> <20080701064437.GR29319@disturbed> <486B01A6.4030104@pmc-sierra.com> <20080702051337.GX29319@disturbed> <486B13AD.2010500@pmc-sierra.com> <1214979191.6025.22.camel@verge.scott.net.au> <20080702065652.GS14251@build-svl-1.agami.com> <486B6062.6040201@pmc-sierra.com> <486C4F89.9030009@sandeen.net>
In-Reply-To: <486C4F89.9030009@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Nathan Scott <nscott@aconex.com>, xfs@oss.sgi.com



Eric Sandeen wrote:
> Sagar Borikar wrote:
>   
>> Dave Chinner wrote:
>>     
>>> On Wed, Jul 02, 2008 at 04:13:11PM +1000, Nathan Scott wrote:
>>>       
>
>
>   
>>>> You can always try the reverse - replace fs/xfs from your mips build
>>>> tree with the one from the current/a recent kernel.  Theres very few
>>>> changes in the surrounding kernel code that xfs needs.
>>>>     
>>>>         
>>> Eric should be able to comment on the pitfalls in doing this having
>>> tried to backport a 2.6.25 fs/xfs to a 2.6.18 RHEL kernel. Eric -
>>> any comments?
>>>
>>> Cheers,
>>>
>>> Dave.
>>>   
>>>       
>> Eric, Could you please let me know about bits and pieces that we need to 
>> remember while back porting xfs to 2.6.18?
>> If you share patches which takes care of it, that would be great.
>>     
>
> http://sandeen.net/rhel5_xfs/xfs-2.6.25-for-rhel5-testing.tar.bz2
>
> should be pretty close.  It was quick 'n' dirty and it has some warts
> but would give an idea of what backporting was done (see patches/ and
> the associated quilt series; quilt push -a to apply them all)
>   
Thanks a lot Eric. I'll go through it .I am actually trying another 
option of regularly defragmenting the file system under stress.
I wanted to understand couple of things for using xfs_fsr utility:

1. What should be the state of filesystem when I am running xfs_fsr. 
Ideally we should stop all io before running defragmentation.
2. How effective is the utility when ran on highly fragmented file 
system? I saw that if filesystem is 99.89% fragmented, the recovery is 
very slow. It took around 25 min to clean up 100GB JBOD volume and after 
that system was fragmented to 82%. So I was confused on how exactly the 
fragmentation works.
Any pointers on probable optimum use of xfs_fsr?
3. Any precautions I need to take when working with that from data 
consistency, robustness point of view? Any disadvantages?
4. Any threshold for starting the defragmentation on xfs?

Thanks
Sagar
> -Eric
>   
