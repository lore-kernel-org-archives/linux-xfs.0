Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Jul 2008 22:34:47 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m625Yg7d015697
	for <xfs@oss.sgi.com>; Tue, 1 Jul 2008 22:34:44 -0700
Received: from bby1mta02.pmc-sierra.bc.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 49111D8107D
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2008 22:35:45 -0700 (PDT)
Received: from bby1mta02.pmc-sierra.bc.ca (bby1mta02.pmc-sierra.com [216.241.235.117]) by cuda.sgi.com with ESMTP id qFXhqzqvzD8QsATh for <xfs@oss.sgi.com>; Tue, 01 Jul 2008 22:35:45 -0700 (PDT)
Received: from bby1mta02.pmc-sierra.bc.ca (localhost.pmc-sierra.bc.ca [127.0.0.1])
	by localhost (Postfix) with SMTP id 495D08E0246
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2008 22:38:19 -0700 (PDT)
Received: from bby1exg02.pmc_nt.nt.pmc-sierra.bc.ca (BBY1EXG02.pmc-sierra.bc.ca [216.241.231.167])
	by bby1mta02.pmc-sierra.bc.ca (Postfix) with SMTP id 4025D8E023C
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2008 22:38:19 -0700 (PDT)
Message-ID: <486B13AD.2010500@pmc-sierra.com>
Date: Wed, 02 Jul 2008 11:05:41 +0530
From: Sagar Borikar <sagar_borikar@pmc-sierra.com>
MIME-Version: 1.0
Subject: Re: Xfs Access to block zero  exception and system crash
References: <20080626070215.GI11558@disturbed> <4864BD5D.1050202@pmc-sierra.com> <4864C001.2010308@pmc-sierra.com> <20080628000516.GD29319@disturbed> <340C71CD25A7EB49BFA81AE8C8392667028A1CA7@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <20080629215647.GJ29319@disturbed> <20080630034112.055CF18904C4@bby1mta01.pmc-sierra.bc.ca> <4868B46C.9000200@pmc-sierra.com> <20080701064437.GR29319@disturbed> <486B01A6.4030104@pmc-sierra.com> <20080702051337.GX29319@disturbed>
In-Reply-To: <20080702051337.GX29319@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sagar Borikar <sagar_borikar@pmc-sierra.com>, xfs@oss.sgi.com



Dave Chinner wrote:
> On Wed, Jul 02, 2008 at 09:48:46AM +0530, Sagar Borikar wrote:
>   
>> Dave Chinner wrote:
>>     
>>> On Mon, Jun 30, 2008 at 03:54:44PM +0530, Sagar Borikar wrote:
>>> Sure - just like any other workload that generates enough
>>> extents. Like I said originally, we've fixed so many problems
>>> in this code since 2.6.18 I'd suggest that your only sane
>>> hope for us to help you track done the problem is to upgrade
>>> to a current kernel and go from there....
>>>   
>>>       
>> Thanks again Dave. But we can't upgrade the kernel as it is already in  
>> production and on field.
>>     
>
> Yes, but you can run it in your test environment where you are
> reproducing this problem, right?
>
>   
Unfortunately the architecture is customized mips for which the standard 
kernel port is
not available  and we have to port the new kernel in order to try this 
which is why I was
hesitating to do this.
>> So do you think, periodic cleaning of file system using xfs_fsr can  
>> solve the issue?
>>     
>
> No, at best it would only delay the problem (whatever it is).
>
>   
>> If not, could you
>> kindly direct me what all patches were fixing similar problem? I can try  
>> back porting them.
>>     
>
> I don't have time to try to identify some set of changes from the
> past 3-4 years that might fix your problem. There may not even be a
> patch that fixes your problem, which is one of the reasons why I've
> asked if you can reproduce it on a current kernel....
>
> I pointed you the files that the bug could lie in earlier in the
> thread. You can find the history of changes to those files via the
> mainline git repository or via the XFS CVS repository. You'd
> probably do best to look at the git tree because all the changes are
> well described in the commit logs and you should be able to isolate
> ones that fix btree problems fairly easily...
>
> Cheers,
>
> Dave.
>   
Sure I'll go through these changelogs.  Thanks for all your help and 
really appreciate your
time. I hope you don't mind to help me in future if I find something new :)

Regards,
Sagar
