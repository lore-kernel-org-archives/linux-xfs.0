Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 Jul 2008 08:01:02 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m63F10kq000760
	for <xfs@oss.sgi.com>; Thu, 3 Jul 2008 08:01:00 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 86EC812D9798
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2008 08:02:03 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id wAh3CEXjxhLwBsXm for <xfs@oss.sgi.com>; Thu, 03 Jul 2008 08:02:03 -0700 (PDT)
Message-ID: <486CE9EA.90502@sandeen.net>
Date: Thu, 03 Jul 2008 10:02:02 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Xfs Access to block zero  exception and system crash
References: <20080628000516.GD29319@disturbed> <340C71CD25A7EB49BFA81AE8C8392667028A1CA7@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <20080629215647.GJ29319@disturbed> <20080630034112.055CF18904C4@bby1mta01.pmc-sierra.bc.ca> <4868B46C.9000200@pmc-sierra.com> <20080701064437.GR29319@disturbed> <486B01A6.4030104@pmc-sierra.com> <20080702051337.GX29319@disturbed> <486B13AD.2010500@pmc-sierra.com> <1214979191.6025.22.camel@verge.scott.net.au> <20080702065652.GS14251@build-svl-1.agami.com> <486B6062.6040201@pmc-sierra.com> <486C4F89.9030009@sandeen.net> <486C6053.7010503@pmc-sierra.com>
In-Reply-To: <486C6053.7010503@pmc-sierra.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sagar Borikar <sagar_borikar@pmc-sierra.com>
Cc: Nathan Scott <nscott@aconex.com>, xfs@oss.sgi.com

Sagar Borikar wrote:
> 
> Eric Sandeen wrote:


>>> Eric, Could you please let me know about bits and pieces that we need to 
>>> remember while back porting xfs to 2.6.18?
>>> If you share patches which takes care of it, that would be great.
>>>     
>> http://sandeen.net/rhel5_xfs/xfs-2.6.25-for-rhel5-testing.tar.bz2
>>
>> should be pretty close.  It was quick 'n' dirty and it has some warts
>> but would give an idea of what backporting was done (see patches/ and
>> the associated quilt series; quilt push -a to apply them all)
>>   
> Thanks a lot Eric. I'll go through it .I am actually trying another 
> option of regularly defragmenting the file system under stress.

Ok, but that won't get to the bottom of the problem.  It might alleviate
it at best, but if I were shipping a product using xfs I'd want to know
that it was properly solved.  :)

The tarball above should give you almost everything you need to run your
testcase with current xfs code on your older kernel to see if the bug
persists or if it's been fixed upstream, in which case you have a
relatively easy path to an actual solution that your customers can
depend on.

> I wanted to understand couple of things for using xfs_fsr utility:
> 
> 1. What should be the state of filesystem when I am running xfs_fsr. 
> Ideally we should stop all io before running defragmentation.

you can run in any state.  Some files will not get defragmented due to
busy-ness or other conditions; look at the xfs_swap_extents() function
in the kernel which is very well documented; some cases return EBUSY.

> 2. How effective is the utility when ran on highly fragmented file 
> system? I saw that if filesystem is 99.89% fragmented, the recovery is 
> very slow. It took around 25 min to clean up 100GB JBOD volume and after 
> that system was fragmented to 82%. So I was confused on how exactly the 
> fragmentation works.

Again read the code, but basically it tries to preallocate as much space
as the file is currently using, then checks that it is more contiguous
space than the file currently has and if so, it copies the data from old
to new and swaps the new allocation for the old.  Note, this involves a
fair amount of IO.

Also don't get hung up on that fragmentation factor, at least not until
you've read xfs_db code to see how it's reported, and you've thought
about what that means.  For example: a 100G filesystem with 10 10G files
each with 5x2G extents will report 80% fragmentation.  Now, ask
yourself, is a 10G file in 5x2G extents "bad" fragmentation?

> Any pointers on probable optimum use of xfs_fsr?
> 3. Any precautions I need to take when working with that from data 
> consistency, robustness point of view? Any disadvantages?

Anything which corrupts data is a bug, and I'm not aware of any such
bugs in the defragmentation process.

> 4. Any threshold for starting the defragmentation on xfs?

Pretty well determined by your individual use case and requirements, I
think.

-Eric
