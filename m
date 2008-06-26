Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 25 Jun 2008 23:45:36 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5Q6jURO021763
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 23:45:31 -0700
Received: from bby1mta01.pmc-sierra.bc.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AFAB3282E1C
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 23:46:30 -0700 (PDT)
Received: from bby1mta01.pmc-sierra.bc.ca (bby1mta01.pmc-sierra.com [216.241.235.116]) by cuda.sgi.com with ESMTP id UtQwCoid5PjRUVJe for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 23:46:30 -0700 (PDT)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: Xfs Access to block zero  exception and system crash
Date: Wed, 25 Jun 2008 23:46:59 -0700
Message-ID: <340C71CD25A7EB49BFA81AE8C839266701323BE8@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
In-Reply-To: <20080625084931.GI16257@build-svl-1.agami.com>
References: <340C71CD25A7EB49BFA81AE8C839266701323BD8@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <20080625084931.GI16257@build-svl-1.agami.com>
From: "Sagar Borikar" <Sagar_Borikar@pmc-sierra.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <dchinner@agami.com>
Cc: xfs@oss.sgi.com

 

Thanks Dave.

>> with 2.6.18 kernel,128 MB of RAM, MIPS architecture and XFS version 
>> 2.8.11.

> [...]

>> Can anyone let me know what could be the probable cause of this issue.

> they are all from  corrupted extent btrees.
> There are many possible causes of this that we've fixed over the past years since 2.6.18 was released. Indeed, we are currently discussing fixes for a 
> bunch of problems that lead to corrupted extent btrees and problems like this. I'd suggest that you should probably start with a more recent kernel, 
> make sure you have a serial console and set the xfs_error_level to 11 so that it gives as much information as possible on the console when the error it > hit.
> if that doesn't give a stack trace, then  you need to set the xfs_panic_mask to crash the machine on block zero accesses and report the stack ﬆraces 
> that it outputs...
 

Yes, I went through the changes between 2.6.24 and 2.6.18 and they are quite a few. But as this is production system and on field, its not viable to upgrade the kernel. I do understand that there could be many places which can cause the corruption. Unfortunately, three different systems have given three different places of corruption as stated. Now I am sleeping in the access to block zero exception and rescheduling so that it won't stall the system and I can monitor the state of the filesystem. As the frequency of landing the error is once in 2.5 days under extreme stress,  if you could point me to the probable place to look at, I can narrow down the debugging path.

Thanks in advance
Sagar  
