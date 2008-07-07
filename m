Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Jul 2008 20:16:13 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m673G9Ol024457
	for <xfs@oss.sgi.com>; Sun, 6 Jul 2008 20:16:10 -0700
Received: from bby1mta02.pmc-sierra.bc.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 58B672BF940
	for <xfs@oss.sgi.com>; Sun,  6 Jul 2008 20:17:14 -0700 (PDT)
Received: from bby1mta02.pmc-sierra.bc.ca (bby1mta02.pmc-sierra.com [216.241.235.117]) by cuda.sgi.com with ESMTP id lR62va5hIcMAtFJE for <xfs@oss.sgi.com>; Sun, 06 Jul 2008 20:17:14 -0700 (PDT)
Message-ID: <48718AB6.80709@pmc-sierra.com>
Date: Mon, 07 Jul 2008 08:47:10 +0530
From: Sagar Borikar <sagar_borikar@pmc-sierra.com>
MIME-Version: 1.0
Subject: Re: Xfs Access to block zero  exception and system crash
References: <486B01A6.4030104@pmc-sierra.com> <20080702051337.GX29319@disturbed> <486B13AD.2010500@pmc-sierra.com> <1214979191.6025.22.camel@verge.scott.net.au> <20080702065652.GS14251@build-svl-1.agami.com> <486B6062.6040201@pmc-sierra.com> <486C4F89.9030009@sandeen.net> <486C6053.7010503@pmc-sierra.com> <486CE9EA.90502@sandeen.net> <486DF8F0.5010700@pmc-sierra.com> <20080704122726.GG29319@disturbed> <340C71CD25A7EB49BFA81AE8C839266702997641@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <486E5F4D.1010009@sandeen.net> <340C71CD25A7EB49BFA81AE8C839266702997658@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <486FA095.1050106@sandeen.net> <340C71CD25A7EB49BFA81AE8C839266702A084A6@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <487117FC.9090109@sandeen.net> <4871872B.9060107@pmc-sierra.com> <487187D2.8080105@sandeen.net> <4871885B.6090208@pmc-sierra.com> <48718977.1090005@sandeen.net>
In-Reply-To: <48718977.1090005@sandeen.net>
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
>> Eric Sandeen wrote:
>>     
>>> Sagar Borikar wrote:
>>>
>>>
>>>   
>>>       
>>>> There was no failure. Only the processes were stalled. System was 
>>>> operative.
>>>>     
>>>>         
>>> I'm curious, if the processes were stalled, how did you unmount the
>>> filesystem to run repair on it?
>>>
>>> -Eric
>>>   
>>>       
>> I ran with -n option.
>>
>> xfs_repair -fvn /root/test_partition
>>     
>
> oh....
>
> So, you basically ran repair on a live, mounted filesystem; it's
> expected that it would not be consistent at this point.
>
> So, the errors you are seeing on this x86 are likely not related to
> those you see on mips.  (the D state process might be interesting and
> worth looking into, but probably not related to the problem you're
> trying to solve.)
>
> -Eric
>   
Ok. But then I was surprised as why the copy is not successful. Here is 
the ps output

root     29200  0.0  0.1   2088   652 ?        D    01:41   0:00 cp -f 
testfile testdir_16
root     29201  0.0  0.1   2088   648 ?        D    01:41   0:00 cp -f 
testfile testfile_16
root     29202  0.0  0.1   2088   648 ?        D    01:41   0:00 cp -f 
testfile testfile_14
root     29203  0.0  0.1   2088   648 ?        D    01:41   0:00 cp -f 
testfile testfile_2
root     29204  0.0  0.1   2088   652 ?        D    01:41   0:00 cp -f 
testfile testdir_9
root     29205  0.0  0.1   2088   648 ?        D    01:41   0:00 cp -f 
testfile testfile_5
root     29206  0.0  0.1   2088   652 ?        D    01:41   0:00 cp -f 
testfile testdir_3
root     29207  0.0  0.1   2088   648 ?        D    01:41   0:00 cp -f 
testfile testfile_15
root     29208  0.0  0.1   2088   648 ?        D    01:41   0:00 cp -f 
testfile testdir_2
root     29209  0.0  0.1   2088   652 ?        D    01:41   0:00 cp -f 
testfile testdir_12
root     29210  0.0  0.1   2088   644 ?        D    01:41   0:00 cp -f 
testfile testfile_10
root     29211  0.0  0.1   2088   648 ?        D    01:41   0:00 cp -f 
testfile testfile_4
root     29212  0.0  0.1   2088   652 ?        D    01:41   0:00 cp -f 
testfile testdir_13
root     29213  0.0  0.1   2088   648 ?        D    01:41   0:00 cp -f 
testfile testfile_20
root     29214  0.0  0.1   2088   648 ?        D    01:41   0:00 cp -f 
testfile testdir_20
root     29215  0.0  0.1   2088   656 ?        D    01:41   0:00 cp -f 
testfile testdir_18
root     29216  0.0  0.1   2088   644 ?        D    01:41   0:00 cp -f 
testfile testfile_13
root     29217  0.0  0.1   2088   648 ?        D    01:41   0:00 cp -f 
testfile testdir_1
root     29218  0.0  0.1   2088   652 ?        D    01:41   0:00 cp -f 
testfile testdir_8
root     29219  0.0  0.1   2088   648 ?        D    01:41   0:00 cp -f 
testfile testfile_11
root     29220  0.0  0.1   2088   652 ?        D    01:41   0:00 cp -f 
testfile testdir_6
root     29221  0.0  0.1   2088   644 ?        D    01:41   0:00 cp -f 
testfile testfile_6
root     29222  0.0  0.1   2088   652 ?        D    01:41   0:00 cp -f 
testfile testdir_10
root     29223  0.0  0.1   2088   652 ?        D    01:41   0:00 cp -f 
testfile testdir_14
root     29224  0.0  0.1   2088   648 ?        D    01:41   0:00 cp -f 
testfile testfile_19
root     29225  0.0  0.1   2088   644 ?        D    01:41   0:00 cp -f 
testfile testfile_12
root     29226  0.0  0.1   2088   652 ?        D    01:41   0:00 cp -f 
testfile testdir_5
root     29227  0.0  0.1   2088   648 ?        D    01:41   0:00 cp -f 
testfile testdir_11
root     29228  0.0  0.1   2088   648 ?        D    01:41   0:00 cp -f 
testfile testfile_8
root     29229  0.0  0.1   2088   652 ?        D    01:41   0:00 cp -f 
testfile testdir_4
root     29230  0.0  0.1   2088   652 ?        D    01:41   0:00 cp -f 
testfile testdir_17
root     29231  0.0  0.1   2088   644 ?        D    01:41   0:00 cp -f 
testfile testfile_18
root     29232  0.0  0.1   2088   648 ?        D    01:41   0:00 cp -f 
testfile testdir_15
root     29233  0.0  0.1   2088   648 ?        D    01:41   0:00 cp -f 
testfile testfile_7
root     29234  0.0  0.1   2088   644 ?        D    01:41   0:00 cp -f 
testfile testfile_3
root     29235  0.0  0.1   2088   644 ?        D    01:41   0:00 cp -f 
testfile testfile_1
root     29236  0.0  0.1   2088   648 ?        D    01:41   0:00 cp -f 
testfile testfile_17
root     29237  0.0  0.1   2088   652 ?        D    01:41   0:00 cp -f 
testfile testdir_7
root     29238  0.0  0.1   2088   648 ?        D    01:41   0:00 cp -f 
testfile testdir_19
root     29239  0.0  0.1   2088   648 ?        D    01:41   0:00 cp -f 
testfile testfile_9

All the the copies are pending and file size in those directories is 
constant. It is not
increasing.
 And as the processes are in D state, the file system is marked as busy 
and I can't unmount
it.

Thanks
Sagar
