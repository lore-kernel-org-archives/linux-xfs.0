Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Jul 2008 21:17:55 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m624HnCB010902
	for <xfs@oss.sgi.com>; Tue, 1 Jul 2008 21:17:51 -0700
Received: from bby1mta03.pmc-sierra.bc.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4904FD80B3F
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2008 21:18:51 -0700 (PDT)
Received: from bby1mta03.pmc-sierra.bc.ca (bby1mta03.pmc-sierra.com [216.241.235.118]) by cuda.sgi.com with ESMTP id W6hCAbKDnJsQ8LlT for <xfs@oss.sgi.com>; Tue, 01 Jul 2008 21:18:51 -0700 (PDT)
Received: from bby1mta03.pmc-sierra.bc.ca (localhost.pmc-sierra.bc.ca [127.0.0.1])
	by localhost (Postfix) with SMTP id 6159610704C3
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2008 21:21:24 -0700 (PDT)
Received: from bby1exg02.pmc_nt.nt.pmc-sierra.bc.ca (BBY1EXG02.pmc-sierra.bc.ca [216.241.231.167])
	by bby1mta03.pmc-sierra.bc.ca (Postfix) with SMTP id 1779610703BC
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2008 21:21:22 -0700 (PDT)
Message-ID: <486B01A6.4030104@pmc-sierra.com>
Date: Wed, 02 Jul 2008 09:48:46 +0530
From: Sagar Borikar <sagar_borikar@pmc-sierra.com>
MIME-Version: 1.0
Subject: Re: Xfs Access to block zero  exception and system crash
References: <20080625084931.GI16257@build-svl-1.agami.com> <340C71CD25A7EB49BFA81AE8C839266701323BE8@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <20080626070215.GI11558@disturbed> <4864BD5D.1050202@pmc-sierra.com> <4864C001.2010308@pmc-sierra.com> <20080628000516.GD29319@disturbed> <340C71CD25A7EB49BFA81AE8C8392667028A1CA7@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <20080629215647.GJ29319@disturbed> <20080630034112.055CF18904C4@bby1mta01.pmc-sierra.bc.ca> <4868B46C.9000200@pmc-sierra.com> <20080701064437.GR29319@disturbed>
In-Reply-To: <20080701064437.GR29319@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sagar Borikar <sagar_borikar@pmc-sierra.com>, xfs@oss.sgi.com



Dave Chinner wrote:
> On Mon, Jun 30, 2008 at 03:54:44PM +0530, Sagar Borikar wrote:
>   
>> After running my test for 20 min, when I check the fragmentation status  
>> of file system, I observe that it
>> is severely fragmented.
>>     
>
> Depends on your definition of fragmentation....
>
>   
>> [root@NAS001ee5ab9c85 ~]# xfs_db -c frag -r /dev/RAIDA/vol
>> actual 94343, ideal 107, fragmentation factor 99.89%
>>     
>
> And that one is a bad one ;)
>
> Still, there are a lot of extents - ~1000 to a file - which
> will be stressing the btree extent format code.
>
>   
>> Do you think, this can cause the issue?
>>     
>
> Sure - just like any other workload that generates enough
> extents. Like I said originally, we've fixed so many problems
> in this code since 2.6.18 I'd suggest that your only sane
> hope for us to help you track done the problem is to upgrade
> to a current kernel and go from there....
>
> Cheers,,
>
> Dave.
>   
Thanks again Dave. But we can't upgrade the kernel as it is already in 
production and on field.
So do you think, periodic cleaning of file system using xfs_fsr can 
solve the issue? If not, could you
kindly direct me what all patches were fixing similar problem? I can try 
back porting them.

Thanks
Sagar
