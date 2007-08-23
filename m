Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 15:56:41 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7NMuY4p006811
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 15:56:37 -0700
Date: Fri, 24 Aug 2007 08:56:26 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: sb_ifree and sb_fdblocks are unequal
Message-ID: <20070823225626.GX72985246@sgi.com>
References: <Pine.LNX.4.21.0708221713020.11516-100000@orbis.oth.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.21.0708221713020.11516-100000@orbis.oth.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Pearson <kermit4@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Aug 22, 2007 at 05:17:33PM -0500, Chris Pearson wrote:
> I have the same problem as posted in:
> http://oss.sgi.com/archives/xfs/2006-02/msg00091.html
> 
> using xfsprogs-2.9.3  in linux  2.4.29

linux 2.4.29, eh?

I first a bunch of freespace/inode count issues quite some
time ago, but the went into a 2.6 kernel, not a 2.4 kernel.
Perhaps you should upgrade ;)

> after running xfs_repair on a read-only mounted root filesystem, xfs_check
> still shows errors:                                    
>                                                                                                                              
> # ./xfs_check.sh -f /dev/md1
> sb_ifree 993009, counted 993008
> sb_fdblocks 3119630, counted 3119633

Boot from a bootable cd (e.g. knoppix) and run repair from there
without the filesytem mounted. it should fix everything up.

> It's possible, even likely, I had corruption due to a power outtage and
> Seagate ATAPI drives that had write caching enabled by default.

Possible. no way to prove or disprove, though.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
