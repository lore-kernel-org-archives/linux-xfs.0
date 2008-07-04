Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 Jul 2008 10:29:15 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m64HTDCi017373
	for <xfs@oss.sgi.com>; Fri, 4 Jul 2008 10:29:13 -0700
Received: from bby1mta03.pmc-sierra.bc.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DAA4E2B9B44
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2008 10:30:16 -0700 (PDT)
Received: from bby1mta03.pmc-sierra.bc.ca (bby1mta03.pmc-sierra.com [216.241.235.118]) by cuda.sgi.com with ESMTP id YbYGtgpMB9d3OeXn for <xfs@oss.sgi.com>; Fri, 04 Jul 2008 10:30:16 -0700 (PDT)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: Xfs Access to block zero  exception and system crash
Date: Fri, 4 Jul 2008 10:30:47 -0700
Message-ID: <340C71CD25A7EB49BFA81AE8C839266702997641@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
In-Reply-To: <20080704122726.GG29319@disturbed>
References: <486B01A6.4030104@pmc-sierra.com> <20080702051337.GX29319@disturbed> <486B13AD.2010500@pmc-sierra.com> <1214979191.6025.22.camel@verge.scott.net.au> <20080702065652.GS14251@build-svl-1.agami.com> <486B6062.6040201@pmc-sierra.com> <486C4F89.9030009@sandeen.net> <486C6053.7010503@pmc-sierra.com> <486CE9EA.90502@sandeen.net> <486DF8F0.5010700@pmc-sierra.com> <20080704122726.GG29319@disturbed>
From: "Sagar Borikar" <Sagar_Borikar@pmc-sierra.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Nathan Scott <nscott@aconex.com>, xfs@oss.sgi.com


The script is pretty straight forward:

While [ 1 ]
Do
Cp -f $1 $2
Done

Where I pass the first parameter as the 300+ MB file in one directory
and $2 are is other directory. I run 30 instances of the script in
parallel.

Thanks
Sagar


On Fri, Jul 04, 2008 at 03:48:24PM +0530, Sagar Borikar wrote:
> Even we too don't want to leave it as it is.  I still am working on
back  
> porting the latest xfs code.
> Your patches are helping a lot .
> Just to check whether that issue lies with 2.6.18 or MIPS port, I
tested  
> it on 2.6.24 x86 platform.
> Here we created a loop back device of 10 GB and mounted xfs on that.

And the script that generates the workload can be found where?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
