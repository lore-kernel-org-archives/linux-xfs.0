Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 18 Oct 2007 15:24:14 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9IMO4Hw005618
	for <xfs@oss.sgi.com>; Thu, 18 Oct 2007 15:24:08 -0700
Date: Fri, 19 Oct 2007 08:23:57 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: raw vs XFS sequential write and system load
Message-ID: <20071018222357.GN995458@sgi.com>
References: <B4D42128-E5B2-48B1-AEF1-586FD90AF605@cern.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B4D42128-E5B2-48B1-AEF1-586FD90AF605@cern.ch>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mario Kadastik <mario.kadastik@cern.ch>
Cc: xfs@oss.sgi.com

On Thu, Oct 18, 2007 at 12:50:44PM +0200, Mario Kadastik wrote:
> Hello,
> 
> I have a slight problem. Namely we have 4 systems with each having 2x  
> 3ware 9550SX cards in them each with hardware RAID5. Everything is  
> running the latest FW etc. The systems have at least 3GB of memory  
> and at least 2 CPU-s (one has 4GB and 4 cpu-s).

Before going any further, what kernel are you using and what's
the output of xfs_info </mntpt> of the filesytsem you are testing?

FWIW, high iowait = high load average. High iowait is generally an
indicator of an overloaded disk subsystem.  You tests to the raw
device only used a single stream, so it's unlikely to show any of
the issues you're complaining about when running tens of parallel
streams....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
