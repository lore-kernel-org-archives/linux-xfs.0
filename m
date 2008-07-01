Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 30 Jun 2008 23:43:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m616hrvE025447
	for <xfs@oss.sgi.com>; Mon, 30 Jun 2008 23:43:53 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 91B3C2A1F29
	for <xfs@oss.sgi.com>; Mon, 30 Jun 2008 23:44:55 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id u36qQ07IBIw59prz for <xfs@oss.sgi.com>; Mon, 30 Jun 2008 23:44:55 -0700 (PDT)
Date: Tue, 1 Jul 2008 16:44:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Xfs Access to block zero  exception and system crash
Message-ID: <20080701064437.GR29319@disturbed>
References: <20080625084931.GI16257@build-svl-1.agami.com> <340C71CD25A7EB49BFA81AE8C839266701323BE8@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <20080626070215.GI11558@disturbed> <4864BD5D.1050202@pmc-sierra.com> <4864C001.2010308@pmc-sierra.com> <20080628000516.GD29319@disturbed> <340C71CD25A7EB49BFA81AE8C8392667028A1CA7@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <20080629215647.GJ29319@disturbed> <20080630034112.055CF18904C4@bby1mta01.pmc-sierra.bc.ca> <4868B46C.9000200@pmc-sierra.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4868B46C.9000200@pmc-sierra.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sagar Borikar <sagar_borikar@pmc-sierra.com>
Cc: xfs@oss.sgi.com

On Mon, Jun 30, 2008 at 03:54:44PM +0530, Sagar Borikar wrote:
> After running my test for 20 min, when I check the fragmentation status  
> of file system, I observe that it
> is severely fragmented.

Depends on your definition of fragmentation....

> [root@NAS001ee5ab9c85 ~]# xfs_db -c frag -r /dev/RAIDA/vol
> actual 94343, ideal 107, fragmentation factor 99.89%

And that one is a bad one ;)

Still, there are a lot of extents - ~1000 to a file - which
will be stressing the btree extent format code.

> Do you think, this can cause the issue?

Sure - just like any other workload that generates enough
extents. Like I said originally, we've fixed so many problems
in this code since 2.6.18 I'd suggest that your only sane
hope for us to help you track done the problem is to upgrade
to a current kernel and go from there....

Cheers,,

Dave.
-- 
Dave Chinner
david@fromorbit.com
