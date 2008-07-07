Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Jul 2008 20:57:56 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m673vrhx032597
	for <xfs@oss.sgi.com>; Sun, 6 Jul 2008 20:57:53 -0700
Received: from bby1mta02.pmc-sierra.bc.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E1FDC18840CB
	for <xfs@oss.sgi.com>; Sun,  6 Jul 2008 20:58:57 -0700 (PDT)
Received: from bby1mta02.pmc-sierra.bc.ca (bby1mta02.pmc-sierra.com [216.241.235.117]) by cuda.sgi.com with ESMTP id s9slWUz4MS1Oh4mG for <xfs@oss.sgi.com>; Sun, 06 Jul 2008 20:58:57 -0700 (PDT)
Message-ID: <4871947D.2090701@pmc-sierra.com>
Date: Mon, 07 Jul 2008 09:28:53 +0530
From: Sagar Borikar <sagar_borikar@pmc-sierra.com>
MIME-Version: 1.0
Subject: Re: Xfs Access to block zero  exception and system crash
References: <486B01A6.4030104@pmc-sierra.com> <20080702051337.GX29319@disturbed> <486B13AD.2010500@pmc-sierra.com> <1214979191.6025.22.camel@verge.scott.net.au> <20080702065652.GS14251@build-svl-1.agami.com> <486B6062.6040201@pmc-sierra.com> <486C4F89.9030009@sandeen.net> <486C6053.7010503@pmc-sierra.com> <486CE9EA.90502@sandeen.net> <486DF8F0.5010700@pmc-sierra.com> <20080704122726.GG29319@disturbed> <340C71CD25A7EB49BFA81AE8C839266702997641@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <486E5F4D.1010009@sandeen.net> <340C71CD25A7EB49BFA81AE8C839266702997658@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <486FA095.1050106@sandeen.net> <340C71CD25A7EB49BFA81AE8C839266702A084A6@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <487117FC.9090109@sandeen.net> <4871872B.9060107@pmc-sierra.com> <487187D2.8080105@sandeen.net> <4871885B.6090208@pmc-sierra.com> <48718977.1090005@sandeen.net> <48718AB6.80709@pmc-sierra.com> <48718BF0.2040700@sandeen.net> <48719093.3060907@pmc-sierra.com> <487191C2.6090803@sandeen
 .net>
In-Reply-To: <487191C2.6090803@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>, Nathan Scott <nscott@aconex.com>, xfs@oss.sgi.com



Eric Sandeen wrote:
> Sagar Borikar wrote:
>
>
>   
>> Ok. So initially our multi client iozone stress test used to fail. 
>>     
>
> Are these multiple nfs clients?
>   
Actually mix of them. 15 CIFS clients, 4 NFS clients ( 19 iozone clients 
) , 2 FTP clients,
4 HTTP transfers. ( Total 25 transactions simultaneously )
>   
>> But 
>> as it took 2-3 days
>> to replicate the issue, I tried the test, standalone on MIPS and 
>>     
>
> the iozone test again?
>   
iozone test is continuously giving the access to block zero exception 
and xfs shutdown
errors with transaction cancel exceptions plus alloc btree corruption 
exception which I
reported earlier. And my test gives transaction cancel exception and 
block zero exception
with processes under test in deadlock state on MIPS but on x86 there are 
no exceptions but
only incomplete copies due to uninterruptible sleep state and deadlock.
>   
>> observed similar failures which
>> I used to get in multi client test. The test is exactly same what I do 
>> in mutli client
>> iozoen over network. Hence I came to conclusion that if we fix system to 
>> pass my test case
>> then we can try iozone test with that fix.  And now on x86 with 2.6.24, 
>> I am finding similar deadlock but
>> the system is responsive and there are no lockups or exceptions. Do you 
>> observe similar failures on x86
>> at your setup? 
>>     
>
> So far I've not seen the deadlocks.
>   
Could you kindly try with my test? I presume you should see failure 
soon. I tried this on
2 different x86 systems 2 times ( after rebooting the system ) and I saw 
it every time.
>   
>> Also do you think the issues which I am seeing on x86 and 
>> MIPS are coming from the
>> same sources?
>>     
>
> hard to say at this point, I think.
>
> -Eric
>
>   
>> Thanks
>> Sagar
>>
>>     
>
>   
