Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Jul 2008 20:41:14 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m673fBuA031071
	for <xfs@oss.sgi.com>; Sun, 6 Jul 2008 20:41:11 -0700
Received: from bby1mta02.pmc-sierra.bc.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AAB0A11DD133
	for <xfs@oss.sgi.com>; Sun,  6 Jul 2008 20:42:15 -0700 (PDT)
Received: from bby1mta02.pmc-sierra.bc.ca (bby1mta02.pmc-sierra.com [216.241.235.117]) by cuda.sgi.com with ESMTP id CxYPKGyvQnK50kqt for <xfs@oss.sgi.com>; Sun, 06 Jul 2008 20:42:15 -0700 (PDT)
Message-ID: <48719093.3060907@pmc-sierra.com>
Date: Mon, 07 Jul 2008 09:12:11 +0530
From: Sagar Borikar <sagar_borikar@pmc-sierra.com>
MIME-Version: 1.0
Subject: Re: Xfs Access to block zero  exception and system crash
References: <486B01A6.4030104@pmc-sierra.com> <20080702051337.GX29319@disturbed> <486B13AD.2010500@pmc-sierra.com> <1214979191.6025.22.camel@verge.scott.net.au> <20080702065652.GS14251@build-svl-1.agami.com> <486B6062.6040201@pmc-sierra.com> <486C4F89.9030009@sandeen.net> <486C6053.7010503@pmc-sierra.com> <486CE9EA.90502@sandeen.net> <486DF8F0.5010700@pmc-sierra.com> <20080704122726.GG29319@disturbed> <340C71CD25A7EB49BFA81AE8C839266702997641@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <486E5F4D.1010009@sandeen.net> <340C71CD25A7EB49BFA81AE8C839266702997658@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <486FA095.1050106@sandeen.net> <340C71CD25A7EB49BFA81AE8C839266702A084A6@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <487117FC.9090109@sandeen.net> <4871872B.9060107@pmc-sierra.com> <487187D2.8080105@sandeen.net> <4871885B.6090208@pmc-sierra.com> <48718977.1090005@sandeen.net> <48718AB6.80709@pmc-sierra.com> <48718BF0.2040700@sandeen.net>
In-Reply-To: <48718BF0.2040700@sandeen.net>
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
>> All the the copies are pending and file size in those directories is 
>> constant. It is not
>> increasing.
>>  And as the processes are in D state, the file system is marked as busy 
>> and I can't unmount
>> it.
>>     
>
> Understood.  It looks like you've deadlocked somewhere.  But, this is
> not the problem you are really trying to solve, right?  You just were
> trying to recreate the mips problem on x86?
>   
That's right. The intention behind testing on 2.6.24 was to check 
whether we can imitate
failure on x86 which is considered to be more robust. If we replicate 
the failure then
there could be some issue in XFS and if the test passes then we can back 
port this kernel
on MIPS ( Which any way I am doing with your patches ). But I faced 
similar deadlock on MIPS
with exceptions which I posted earlier.

> If you want, do a sysrq-t to get traces of all those cp's to see where
> they're stuck, but this probably isn't getting you much closer to
> solving the original problem.
>
>   
I'll keep you posted with it.
> (BTW: is this the exact same testcase that led to the block 0 access on
> mips which started this thread?)
>
> -Eric
>   
Ok. So initially our multi client iozone stress test used to fail. But 
as it took 2-3 days
to replicate the issue, I tried the test, standalone on MIPS and 
observed similar failures which
I used to get in multi client test. The test is exactly same what I do 
in mutli client
iozoen over network. Hence I came to conclusion that if we fix system to 
pass my test case
then we can try iozone test with that fix.  And now on x86 with 2.6.24, 
I am finding similar deadlock but
the system is responsive and there are no lockups or exceptions. Do you 
observe similar failures on x86
at your setup? Also do you think the issues which I am seeing on x86 and 
MIPS are coming from the
same sources?

Thanks
Sagar
