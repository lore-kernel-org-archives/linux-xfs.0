Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Sep 2007 06:50:20 -0700 (PDT)
Received: from stlx01.stz-softwaretechnik.com (stz-softwaretechnik.de [217.160.223.211])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8PDoCQ3027487
	for <linux-xfs@oss.sgi.com>; Tue, 25 Sep 2007 06:50:16 -0700
Received: from rg by stlx01.stz-softwaretechnik.com with local (Exim 3.36 #1 (Debian))
	id 1IaAne-0005AF-00
	for <linux-xfs@oss.sgi.com>; Tue, 25 Sep 2007 15:50:06 +0200
Date: Tue, 25 Sep 2007 15:49:56 +0200
From: Ralf Gross <Ralf-Lists@ralfgross.de>
Subject: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
Message-ID: <20070925134955.GB20499@p15145560.pureserver.info>
References: <20070923093841.GH19983@p15145560.pureserver.info> <20070924173155.GI19983@p15145560.pureserver.info> <Pine.LNX.4.64.0709241400370.12025@p34.internal.lan> <20070924203958.GA4082@p15145560.pureserver.info> <Pine.LNX.4.64.0709241642110.19847@p34.internal.lan> <20070924213358.GB4082@p15145560.pureserver.info> <Pine.LNX.4.64.0709241736370.19847@p34.internal.lan> <20070924215223.GC4082@p15145560.pureserver.info> <20070925123501.GA20499@p15145560.pureserver.info> <20070925125733.GA20873@luba.cern.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070925125733.GA20873@luba.cern.ch>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

KELEMEN Peter schrieb:
> * Ralf Gross (ralf-lists@ralfgross.de) [20070925 14:35]:
> 
> > There is a second RAID device attached to the server (24x
> > RAID5). The numbers I get from this device are a bit worse than
> > the 16x RAID 5 numbers (150MB/s read with dd).
> 
> You are expecting 24 spindles to align up when you have a write
> request, which has to be 23*chunksize bytes in order to avoid RMW.
> Additionally, your array is so big that you're very likely to hit
> another error while rebuilding.  Chop up your monster RAID5 array
> into smaller arrays and stripe across them.  Even better, consider
> RAID10.

RAID10 is no option, we need 60+ TB at the moment, mostly large video
files. Basically the read/write performance we get with the 16x RAID 5
is sufficient for our needs. The 24x RAID 5 is only a test device. The
volumes that will be used in the future are the 16/15x RAIDs (48 disk
shelf with 3 volumes).

I'm just wondering how people get 400+ MB/s with HW-RAID 5.

Ralf
