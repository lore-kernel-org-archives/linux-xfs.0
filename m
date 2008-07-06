Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 06 Jul 2008 12:06:43 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m66J6cvs000435
	for <xfs@oss.sgi.com>; Sun, 6 Jul 2008 12:06:38 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AC0891882A88
	for <xfs@oss.sgi.com>; Sun,  6 Jul 2008 12:07:42 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id m6ykREfWzWX7UD6S for <xfs@oss.sgi.com>; Sun, 06 Jul 2008 12:07:42 -0700 (PDT)
Message-ID: <487117FC.9090109@sandeen.net>
Date: Sun, 06 Jul 2008 14:07:40 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Xfs Access to block zero  exception and system crash
References: <486B01A6.4030104@pmc-sierra.com> <20080702051337.GX29319@disturbed> <486B13AD.2010500@pmc-sierra.com> <1214979191.6025.22.camel@verge.scott.net.au> <20080702065652.GS14251@build-svl-1.agami.com> <486B6062.6040201@pmc-sierra.com> <486C4F89.9030009@sandeen.net> <486C6053.7010503@pmc-sierra.com> <486CE9EA.90502@sandeen.net> <486DF8F0.5010700@pmc-sierra.com> <20080704122726.GG29319@disturbed> <340C71CD25A7EB49BFA81AE8C839266702997641@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <486E5F4D.1010009@sandeen.net> <340C71CD25A7EB49BFA81AE8C839266702997658@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <486FA095.1050106@sandeen.net> <340C71CD25A7EB49BFA81AE8C839266702A084A6@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
In-Reply-To: <340C71CD25A7EB49BFA81AE8C839266702A084A6@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sagar Borikar <Sagar_Borikar@pmc-sierra.com>
Cc: Dave Chinner <david@fromorbit.com>, Nathan Scott <nscott@aconex.com>, xfs@oss.sgi.com

Sagar Borikar wrote:
> Sagar Borikar wrote:
>> Copy is of the same file to 30 different directories and it is
> basically
>> overwrite.
>>
>> Here is the setup:
>>
>> It's a JBOD with Volume size 20 GB. The directories are empty and this
>> is basically continuous copy of the file on all thirty directories.
> But
>> surprisingly none of the copy succeeds. All the copy processes are in 
>> Uninterruptible sleep state and xfs_repair log I have already attached
> 
>> With the prep. As mentioned it is with 2.6.24 Fedora kernel.
> 
> It would probably be best to try a 2.6.26 kernel from rawhide to be sure
> you're closest to the bleeding edge.
> 
> <Sagar> Sure Eric but I reran the test and I got similar errors with
> 2.6.24 kernel on x86. I am still confused with the results that I see on
> 2.6.24 kernel on x86 machine. I see that the used size shown by ls is
> way too huge than the actual size. Here is the log of the system
> 
> [root@lab00 ~/test_partition]# ls -lSah
> total 202M
> -rw-r--r--  1 root root 202M Jul  4 14:06 original ---> this I sthe file
> Which I  copy.
> drwxr-x--- 65 root root  12K Jul  6 21:57 ..
> -rwxr-xr-x  1 root root  189 Jul  4 16:31 runall
> -rwxr-xr-x  1 root root   50 Jul  4 16:32 copy
> drwxr-xr-x  2 root root   45 Jul  6 22:07 .

It'd be great if you provided these actual scripts so we don't have to
guess at what you're doing or work backwards from the repair output :)

> dmesg log doesn't give any information. Here is XFS related
> info:
> 
> XFS mounting filesystem loop0
> Ending clean XFS mount for filesystem: loop0
> Which is basically for mounting XFS cleanly. But there is no exception
> in XFS. 

and nothing else of interest either?

> Filesystem has become completely sluggish and response time is increased
> to 
> 3-4 minutes for every command.  Not a single copy is complete and all
> the copy processes are sleeping continuously. 

And how did you recover from this; did you power-cycle the box?

-Eric
