Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 Jul 2008 10:50:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m64Ho9Tk021003
	for <xfs@oss.sgi.com>; Fri, 4 Jul 2008 10:50:09 -0700
Received: from bby1mta01.pmc-sierra.bc.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 115D12B8A17
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2008 10:51:12 -0700 (PDT)
Received: from bby1mta01.pmc-sierra.bc.ca (bby1mta01.pmc-sierra.com [216.241.235.116]) by cuda.sgi.com with ESMTP id NcJj7Sk7q68QF8Ar for <xfs@oss.sgi.com>; Fri, 04 Jul 2008 10:51:12 -0700 (PDT)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: Xfs Access to block zero  exception and system crash
Date: Fri, 4 Jul 2008 10:51:47 -0700
Message-ID: <340C71CD25A7EB49BFA81AE8C839266702997658@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
In-Reply-To: <486E5F4D.1010009@sandeen.net>
References: <486B01A6.4030104@pmc-sierra.com> <20080702051337.GX29319@disturbed> <486B13AD.2010500@pmc-sierra.com> <1214979191.6025.22.camel@verge.scott.net.au> <20080702065652.GS14251@build-svl-1.agami.com> <486B6062.6040201@pmc-sierra.com> <486C4F89.9030009@sandeen.net> <486C6053.7010503@pmc-sierra.com> <486CE9EA.90502@sandeen.net> <486DF8F0.5010700@pmc-sierra.com> <20080704122726.GG29319@disturbed> <340C71CD25A7EB49BFA81AE8C839266702997641@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <486E5F4D.1010009@sandeen.net>
From: "Sagar Borikar" <Sagar_Borikar@pmc-sierra.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>, Nathan Scott <nscott@aconex.com>, xfs@oss.sgi.com


Copy is of the same file to 30 different directories and it is basically
overwrite.

Here is the setup:

It's a JBOD with Volume size 20 GB. The directories are empty and this
is basically continuous copy of the file on all thirty directories. But
surprisingly none of the copy succeeds. All the copy processes are in 
Uninterruptible sleep state and xfs_repair log I have already attached 
With the prep. As mentioned it is with 2.6.24 Fedora kernel.

Thanks
Sagar




-----Original Message-----
From: Eric Sandeen [mailto:sandeen@sandeen.net] 
Sent: Friday, July 04, 2008 11:05 PM
To: Sagar Borikar
Cc: Dave Chinner; Nathan Scott; xfs@oss.sgi.com
Subject: Re: Xfs Access to block zero exception and system crash

Sagar Borikar wrote:
> The script is pretty straight forward:
> 
> While [ 1 ]
> Do
> Cp -f $1 $2
> Done
> 
> Where I pass the first parameter as the 300+ MB file in one directory
> and $2 are is other directory. I run 30 instances of the script in
> parallel.

Copying the same file to the same directory, or 30 different files to 30
different directories?  Or the ame file to 30 different directories?  If
different directories what is the layout of the target directories?
Etc...

-Eric
