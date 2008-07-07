Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Jul 2008 20:10:50 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m673Alnb023662
	for <xfs@oss.sgi.com>; Sun, 6 Jul 2008 20:10:47 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BF1702BFA4D
	for <xfs@oss.sgi.com>; Sun,  6 Jul 2008 20:11:52 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id GIlhASmqd3PyCso6 for <xfs@oss.sgi.com>; Sun, 06 Jul 2008 20:11:52 -0700 (PDT)
Message-ID: <48718977.1090005@sandeen.net>
Date: Sun, 06 Jul 2008 22:11:51 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Xfs Access to block zero  exception and system crash
References: <486B01A6.4030104@pmc-sierra.com> <20080702051337.GX29319@disturbed> <486B13AD.2010500@pmc-sierra.com> <1214979191.6025.22.camel@verge.scott.net.au> <20080702065652.GS14251@build-svl-1.agami.com> <486B6062.6040201@pmc-sierra.com> <486C4F89.9030009@sandeen.net> <486C6053.7010503@pmc-sierra.com> <486CE9EA.90502@sandeen.net> <486DF8F0.5010700@pmc-sierra.com> <20080704122726.GG29319@disturbed> <340C71CD25A7EB49BFA81AE8C839266702997641@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <486E5F4D.1010009@sandeen.net> <340C71CD25A7EB49BFA81AE8C839266702997658@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <486FA095.1050106@sandeen.net> <340C71CD25A7EB49BFA81AE8C839266702A084A6@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <487117FC.9090109@sandeen.net> <4871872B.9060107@pmc-sierra.com> <487187D2.8080105@sandeen.net> <4871885B.6090208@pmc-sierra.com>
In-Reply-To: <4871885B.6090208@pmc-sierra.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sagar Borikar <sagar_borikar@pmc-sierra.com>
Cc: Dave Chinner <david@fromorbit.com>, Nathan Scott <nscott@aconex.com>, xfs@oss.sgi.com

Sagar Borikar wrote:
> 
> Eric Sandeen wrote:
>> Sagar Borikar wrote:
>>
>>
>>   
>>> There was no failure. Only the processes were stalled. System was 
>>> operative.
>>>     
>>
>> I'm curious, if the processes were stalled, how did you unmount the
>> filesystem to run repair on it?
>>
>> -Eric
>>   
> I ran with -n option.
> 
> xfs_repair -fvn /root/test_partition

oh....

So, you basically ran repair on a live, mounted filesystem; it's
expected that it would not be consistent at this point.

So, the errors you are seeing on this x86 are likely not related to
those you see on mips.  (the D state process might be interesting and
worth looking into, but probably not related to the problem you're
trying to solve.)

-Eric
