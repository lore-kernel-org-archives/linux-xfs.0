Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Jun 2008 17:04:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5S04MCQ002900
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 17:04:22 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 183791235C1A
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 17:05:22 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id Dc5LfAsb6wHT8UzG for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 17:05:22 -0700 (PDT)
Date: Sat, 28 Jun 2008 10:05:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Xfs Access to block zero  exception and system crash
Message-ID: <20080628000516.GD29319@disturbed>
References: <340C71CD25A7EB49BFA81AE8C839266701323BD8@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <20080625084931.GI16257@build-svl-1.agami.com> <340C71CD25A7EB49BFA81AE8C839266701323BE8@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <20080626070215.GI11558@disturbed> <4864BD5D.1050202@pmc-sierra.com> <4864C001.2010308@pmc-sierra.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4864C001.2010308@pmc-sierra.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sagar Borikar <sagar_borikar@pmc-sierra.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 27, 2008 at 03:55:05PM +0530, Sagar Borikar wrote:
>
> Dave,
>
> I also got continuous exceptions
>
>
> XFS internal error XFS_WANT_CORRUPTED_RETURN at line 296 of file  
> fs/xfs/xfs_alloc.c.  Caller 0x802962c0

corrupt alloc btree. xfs_repair won't report errors in this btree;
it simply rebuilds it. xfs_check will report errors in it, though.

> So memory was also not available for pdflush threads to flush the data  
> back to disks. But when

nothing to do with memory availabilty, I think.

FWIW, can you send the output of xfs_growfs -n <mntpt> and details
of the partitioning and volume config?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
