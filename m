Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Jul 2008 23:13:42 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m626DSSY018353
	for <xfs@oss.sgi.com>; Tue, 1 Jul 2008 23:13:29 -0700
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0541718607AE
	for <xfs@oss.sgi.com>; Tue,  1 Jul 2008 23:14:30 -0700 (PDT)
Received: from postoffice2.aconex.com (prod.aconex.com [203.89.192.138]) by cuda.sgi.com with ESMTP id A78DuKs9sroIDqmm for <xfs@oss.sgi.com>; Tue, 01 Jul 2008 23:14:30 -0700 (PDT)
Subject: Re: Xfs Access to block zero  exception and system crash
From: Nathan Scott <nscott@aconex.com>
In-Reply-To: <486B13AD.2010500@pmc-sierra.com>
References: <20080626070215.GI11558@disturbed>
	 <4864BD5D.1050202@pmc-sierra.com> <4864C001.2010308@pmc-sierra.com>
	 <20080628000516.GD29319@disturbed>
	 <340C71CD25A7EB49BFA81AE8C8392667028A1CA7@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
	 <20080629215647.GJ29319@disturbed>
	 <20080630034112.055CF18904C4@bby1mta01.pmc-sierra.bc.ca>
	 <4868B46C.9000200@pmc-sierra.com> <20080701064437.GR29319@disturbed>
	 <486B01A6.4030104@pmc-sierra.com> <20080702051337.GX29319@disturbed>
	 <486B13AD.2010500@pmc-sierra.com>
Content-Type: text/plain
Date: Wed, 02 Jul 2008 16:13:11 +1000
Message-Id: <1214979191.6025.22.camel@verge.scott.net.au>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sagar Borikar <sagar_borikar@pmc-sierra.com>
Cc: xfs@oss.sgi.com

On Wed, 2008-07-02 at 11:05 +0530, Sagar Borikar wrote:
> 
> Unfortunately the architecture is customized mips for which the
> standard 
> kernel port is
> not available  and we have to port the new kernel in order to try
> this 
> which is why I was
> hesitating to do this.

You can always try the reverse - replace fs/xfs from your mips build
tree with the one from the current/a recent kernel.  Theres very few
changes in the surrounding kernel code that xfs needs.

cheers.

--
Nathan
