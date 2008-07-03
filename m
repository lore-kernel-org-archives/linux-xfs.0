Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Jul 2008 21:02:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6342JCL001822
	for <xfs@oss.sgi.com>; Wed, 2 Jul 2008 21:02:19 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 71EEBD9443D
	for <xfs@oss.sgi.com>; Wed,  2 Jul 2008 21:03:22 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id 6BB6OGih8wPCQQ4R for <xfs@oss.sgi.com>; Wed, 02 Jul 2008 21:03:22 -0700 (PDT)
Message-ID: <486C4F89.9030009@sandeen.net>
Date: Wed, 02 Jul 2008 23:03:21 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Xfs Access to block zero  exception and system crash
References: <20080628000516.GD29319@disturbed> <340C71CD25A7EB49BFA81AE8C8392667028A1CA7@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <20080629215647.GJ29319@disturbed> <20080630034112.055CF18904C4@bby1mta01.pmc-sierra.bc.ca> <4868B46C.9000200@pmc-sierra.com> <20080701064437.GR29319@disturbed> <486B01A6.4030104@pmc-sierra.com> <20080702051337.GX29319@disturbed> <486B13AD.2010500@pmc-sierra.com> <1214979191.6025.22.camel@verge.scott.net.au> <20080702065652.GS14251@build-svl-1.agami.com> <486B6062.6040201@pmc-sierra.com>
In-Reply-To: <486B6062.6040201@pmc-sierra.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sagar Borikar <sagar_borikar@pmc-sierra.com>
Cc: Nathan Scott <nscott@aconex.com>, xfs@oss.sgi.com

Sagar Borikar wrote:
> 
> Dave Chinner wrote:
>> On Wed, Jul 02, 2008 at 04:13:11PM +1000, Nathan Scott wrote:


>>> You can always try the reverse - replace fs/xfs from your mips build
>>> tree with the one from the current/a recent kernel.  Theres very few
>>> changes in the surrounding kernel code that xfs needs.
>>>     
>> Eric should be able to comment on the pitfalls in doing this having
>> tried to backport a 2.6.25 fs/xfs to a 2.6.18 RHEL kernel. Eric -
>> any comments?
>>
>> Cheers,
>>
>> Dave.
>>   
> Eric, Could you please let me know about bits and pieces that we need to 
> remember while back porting xfs to 2.6.18?
> If you share patches which takes care of it, that would be great.

http://sandeen.net/rhel5_xfs/xfs-2.6.25-for-rhel5-testing.tar.bz2

should be pretty close.  It was quick 'n' dirty and it has some warts
but would give an idea of what backporting was done (see patches/ and
the associated quilt series; quilt push -a to apply them all)

-Eric
