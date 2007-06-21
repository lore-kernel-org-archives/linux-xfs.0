Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Jun 2007 22:50:30 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5P5oCds020911
	for <xfs@oss.sgi.com>; Sun, 24 Jun 2007 22:50:23 -0700
Date: Fri, 22 Jun 2007 09:59:32 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Poor performance -- poor config?
Message-ID: <20070621235932.GZ85884050@sgi.com>
References: <4679951E.8050601@bnl.gov> <Pine.LNX.4.64.0706201703310.27484@p34.internal.lan> <46799939.2080503@bnl.gov> <Pine.LNX.4.64.0706201723050.30471@p34.internal.lan> <55EF1E5D5804A542A6CA37E446DDC206F5C5AA@mapibe17.exchange.xchg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55EF1E5D5804A542A6CA37E446DDC206F5C5AA@mapibe17.exchange.xchg>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sebastian Brings <sebas@silexmedia.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Robert Petkus <rpetkus@bnl.gov>, xfs@oss.sgi.com

On Thu, Jun 21, 2007 at 08:37:36AM +0200, Sebastian Brings wrote:
> Not sure if it makes much sense to set stripe unit and width for a Raid
> which appears as a single device. 

Certainly it does.

That way you get stripe aligned allocation and therfore you are
much more likely to get full-stripe width writes instead of unaligned
writes that force RMW cycles on the RAID controller for parity calculations.

> As you state, the "width" of your DS lun is 4 x 512K == 2MB. In case you
> don't have write cache enabled each of your 1MB writes will cause the DS
> to write to two out of four disks only, causing heavy overhead to create
> parity. 

You're assuming stripe aligned I/O there. That 1MB could hit 3 of the 4
data disks - if you don't have a stripe unit set then that will
be the common case. i.e. its worse than you think :/

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
