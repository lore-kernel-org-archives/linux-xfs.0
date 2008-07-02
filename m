Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Jul 2008 04:02:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m62B20WU012270
	for <xfs@oss.sgi.com>; Wed, 2 Jul 2008 04:02:02 -0700
Received: from bby1mta01.pmc-sierra.bc.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 23A89D82AEC
	for <xfs@oss.sgi.com>; Wed,  2 Jul 2008 04:03:02 -0700 (PDT)
Received: from bby1mta01.pmc-sierra.bc.ca (bby1mta01.pmc-sierra.com [216.241.235.116]) by cuda.sgi.com with ESMTP id egSCjQAobVNjBnYh for <xfs@oss.sgi.com>; Wed, 02 Jul 2008 04:03:02 -0700 (PDT)
Message-ID: <486B6062.6040201@pmc-sierra.com>
Date: Wed, 02 Jul 2008 16:32:58 +0530
From: Sagar Borikar <sagar_borikar@pmc-sierra.com>
MIME-Version: 1.0
Subject: Re: Xfs Access to block zero  exception and system crash
References: <20080628000516.GD29319@disturbed> <340C71CD25A7EB49BFA81AE8C8392667028A1CA7@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <20080629215647.GJ29319@disturbed> <20080630034112.055CF18904C4@bby1mta01.pmc-sierra.bc.ca> <4868B46C.9000200@pmc-sierra.com> <20080701064437.GR29319@disturbed> <486B01A6.4030104@pmc-sierra.com> <20080702051337.GX29319@disturbed> <486B13AD.2010500@pmc-sierra.com> <1214979191.6025.22.camel@verge.scott.net.au> <20080702065652.GS14251@build-svl-1.agami.com>
In-Reply-To: <20080702065652.GS14251@build-svl-1.agami.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nscott@aconex.com>, Sagar Borikar <sagar_borikar@pmc-sierra.com>, xfs@oss.sgi.com, sandeen@sandeen.net



Dave Chinner wrote:
> On Wed, Jul 02, 2008 at 04:13:11PM +1000, Nathan Scott wrote:
>   
>> On Wed, 2008-07-02 at 11:05 +0530, Sagar Borikar wrote:
>>     
>>> Unfortunately the architecture is customized mips for which the
>>> standard 
>>> kernel port is
>>> not available  and we have to port the new kernel in order to try
>>> this 
>>> which is why I was
>>> hesitating to do this.
>>>       
>> You can always try the reverse - replace fs/xfs from your mips build
>> tree with the one from the current/a recent kernel.  Theres very few
>> changes in the surrounding kernel code that xfs needs.
>>     
>
> Eric should be able to comment on the pitfalls in doing this having
> tried to backport a 2.6.25 fs/xfs to a 2.6.18 RHEL kernel. Eric -
> any comments?
>
> Cheers,
>
> Dave.
>   
Eric, Could you please let me know about bits and pieces that we need to 
remember while back porting xfs to 2.6.18?
If you share patches which takes care of it, that would be great.

Thanks
Sagar
