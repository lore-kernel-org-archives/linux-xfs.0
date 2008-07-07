Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Jul 2008 22:57:35 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m675vWvw007372
	for <xfs@oss.sgi.com>; Sun, 6 Jul 2008 22:57:32 -0700
Received: from bby1mta01.pmc-sierra.bc.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 875942BFF3F
	for <xfs@oss.sgi.com>; Sun,  6 Jul 2008 22:58:36 -0700 (PDT)
Received: from bby1mta01.pmc-sierra.bc.ca (bby1mta01.pmc-sierra.com [216.241.235.116]) by cuda.sgi.com with ESMTP id 6HKEE6GcrHr6KaLH for <xfs@oss.sgi.com>; Sun, 06 Jul 2008 22:58:36 -0700 (PDT)
Message-ID: <4871B085.10902@pmc-sierra.com>
Date: Mon, 07 Jul 2008 11:28:29 +0530
From: Sagar Borikar <sagar_borikar@pmc-sierra.com>
MIME-Version: 1.0
Subject: Re: Xfs Access to block zero  exception and system crash
References: <486B01A6.4030104@pmc-sierra.com> <1214979191.6025.22.camel@verge.scott.net.au> <20080702065652.GS14251@build-svl-1.agami.com> <486B6062.6040201@pmc-sierra.com> <486C4F89.9030009@sandeen.net> <486C6053.7010503@pmc-sierra.com> <486CE9EA.90502@sandeen.net> <486DF8F0.5010700@pmc-sierra.com> <20080704122726.GG29319@disturbed> <340C71CD25A7EB49BFA81AE8C839266702997641@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <486E5F4D.1010009@sandeen.net> <340C71CD25A7EB49BFA81AE8C839266702997658@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <486FA095.1050106@sandeen.net> <340C71CD25A7EB49BFA81AE8C839266702A084A6@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <487117FC.9090109@sandeen.net> <4871872B.9060107@pmc-sierra.com> <487187D2.8080105@sandeen.net> <4871885B.6090208@pmc-sierra.com> <48718977.1090005@sandeen.net> <48718AB6.80709@pmc-sierra.com> <48718BF0.2040700@sandeen.net> <48719093.3060907@pmc-sierra.com> <487191C2.6090803@sandeen  .net> <4871947D.2090701@pmc-sierr a.com> <4871A77D.7050803@sandeen.
 net>
In-Reply-To: <4871A77D.7050803@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com



Eric Sandeen wrote:
> Sagar Borikar wrote:
>
>
>   
>> Could you kindly try with my test? I presume you should see failure 
>> soon. I tried this on
>> 2 different x86 systems 2 times ( after rebooting the system ) and I saw 
>> it every time.
>>     
>
>
> Sure.  Is there a reason you're doing this on a loopback file?  That
> probably stresses the vm a bit more, and might get even trickier if the
> loopback file is sparse...
>   
Initially I thought to do that since I didn't want to have a strict 
allocation limit but
allowing allocations to  grow as needed until the backing filesystem 
runs out of free space
due to type of the test case I had. But then I dropped the plan and 
created a non-sparse
loopback device. There was no specific reason to create loopback but as 
it was
simplest option to do it.
> But anyway, on an x86_64 machine with 2G of memory and a non-sparse 10G
> loopback file on 2.6.24.7-92.fc8, your test runs w/o problems for me,
> though the system does get sluggish.  I let it run a bit then ran repair
> and it found no problems, I'll run it overnight to see if anything else
> turns up.
>   
That will be great.  Thanks indeed.
Sagar

> -Eric
>   
