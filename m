Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Jun 2008 17:01:10 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5S015Un002203
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 17:01:06 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 453632966F1
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 17:02:06 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id 9LT2omt8LzQwgxUy for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 17:02:06 -0700 (PDT)
Date: Sat, 28 Jun 2008 10:02:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Xfs Access to block zero  exception and system crash
Message-ID: <20080628000203.GC29319@disturbed>
References: <340C71CD25A7EB49BFA81AE8C839266701323BD8@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <20080625084931.GI16257@build-svl-1.agami.com> <340C71CD25A7EB49BFA81AE8C839266701323BE8@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <20080626070215.GI11558@disturbed> <4864BD5D.1050202@pmc-sierra.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4864BD5D.1050202@pmc-sierra.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sagar Borikar <sagar_borikar@pmc-sierra.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 27, 2008 at 03:43:49PM +0530, Sagar Borikar wrote:
> Dave Chinner wrote:
>> Yes, but all the same pattern of corruption, so it is likely
>> that it is one problem.
>>
>>   All I can suggest is working out a reproducable test case in your
>> development environment, attaching a debugger and start digging around
>> in memory when the problem is hit and try to find out exactly what
>> is corrupted. If you can't reproduce it or work out what is
>> occurring to trigger the problem, then we're not going to be able to
>> find the cause...
>>
> Thanks Dave
> I did some experiments today with the corrupted filesystem.
> setup : NAS box contains one volume /share and 10 subdirectories.
> In first subdirectory sh1, I kept 512MB file. Through a script I  
> continuously copy this file
> simultaneously from sh2 to sh10 subdirectories.
> The script looks like
> ....
> while [ 1 ]
> do
> cp $1 $2
> done
....
> uninterruptible sleep state continuously.  Ran xfs_repair with -n option  
> on filesystem mounted on JBOD
> Here is the output :
....
> entry "iozone_68.tst" in shortform directory 67108993 references free  
> inode 67108995
....
> entry "iozone_68.tst" in shortform directory 100663425 references free  
> inode 100663427
....
> entry "iozone_68.tst" in shortform directory 301990016 references free  
> inode 301990019
....
> entry "iozone_68.tst" in shortform directory 335544448 references free  
> inode 335544451
....
> entry "iozone_68.tst" in shortform directory 402653313 references free  
> inode 402653318
....

And so on. There's a pattern here. Can you try to find out what
part of your workload is producing these errors?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
