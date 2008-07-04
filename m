Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 Jul 2008 08:32:42 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m64FWILs010600
	for <xfs@oss.sgi.com>; Fri, 4 Jul 2008 08:32:18 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BBA21DA4502
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2008 08:33:21 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id uO6rbXTRI59yw1tF for <xfs@oss.sgi.com>; Fri, 04 Jul 2008 08:33:21 -0700 (PDT)
Message-ID: <486E42C0.4090108@sandeen.net>
Date: Fri, 04 Jul 2008 10:33:20 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Xfs Access to block zero  exception and system crash
References: <20080628000516.GD29319@disturbed> <340C71CD25A7EB49BFA81AE8C8392667028A1CA7@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <20080629215647.GJ29319@disturbed> <20080630034112.055CF18904C4@bby1mta01.pmc-sierra.bc.ca> <4868B46C.9000200@pmc-sierra.com> <20080701064437.GR29319@disturbed> <486B01A6.4030104@pmc-sierra.com> <20080702051337.GX29319@disturbed> <486B13AD.2010500@pmc-sierra.com> <1214979191.6025.22.camel@verge.scott.net.au> <20080702065652.GS14251@build-svl-1.agami.com> <486B6062.6040201@pmc-sierra.com> <486C4F89.9030009@sandeen.net> <486C6053.7010503@pmc-sierra.com> <486CE9EA.90502@sandeen.net> <486DF8F0.5010700@pmc-sierra.com>
In-Reply-To: <486DF8F0.5010700@pmc-sierra.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sagar Borikar <sagar_borikar@pmc-sierra.com>
Cc: Nathan Scott <nscott@aconex.com>, xfs@oss.sgi.com

Sagar Borikar wrote:

>>   
> Even we too don't want to leave it as it is.  I still am working on back 
> porting the latest xfs code.
> Your patches are helping a lot .
> Just to check whether that issue lies with 2.6.18 or MIPS port, I tested 
> it on 2.6.24 x86 platform.
> Here we created a loop back device of 10 GB and mounted xfs on that.
> What I observe that xfs_repair reports quite a few bad blocks and bad 
> extents here as well.
> So is developing bad blocks and extents  normal behavior in xfs which 
> would be recovered
> in background or is it a bug? I still didn't see the exception but the 
> bad blocks and extents are
> generated within 10 minutes or running the tests.
> Attaching the log .

Repair finding corruption indicates a bug (or hardware problem) somewhere.

As a long shot you might re-test with this patch in place:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=6ab455eeaff6893cd06da33843e840d888cdc04a

But, as Dave said, please also provide the testcase.

-Eric
