Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Sep 2007 06:09:53 -0700 (PDT)
Received: from cernmxlb.cern.ch (cernmx07.cern.ch [137.138.166.171])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8PD9iQ3019024
	for <linux-xfs@oss.sgi.com>; Tue, 25 Sep 2007 06:09:48 -0700
Date: Tue, 25 Sep 2007 14:57:33 +0200
From: KELEMEN Peter <Peter.Kelemen@cern.ch>
Subject: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
Message-ID: <20070925125733.GA20873@luba.cern.ch>
References: <20070923093841.GH19983@p15145560.pureserver.info> <20070924173155.GI19983@p15145560.pureserver.info> <Pine.LNX.4.64.0709241400370.12025@p34.internal.lan> <20070924203958.GA4082@p15145560.pureserver.info> <Pine.LNX.4.64.0709241642110.19847@p34.internal.lan> <20070924213358.GB4082@p15145560.pureserver.info> <Pine.LNX.4.64.0709241736370.19847@p34.internal.lan> <20070924215223.GC4082@p15145560.pureserver.info> <20070925123501.GA20499@p15145560.pureserver.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070925123501.GA20499@p15145560.pureserver.info>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

* Ralf Gross (ralf-lists@ralfgross.de) [20070925 14:35]:

> There is a second RAID device attached to the server (24x
> RAID5). The numbers I get from this device are a bit worse than
> the 16x RAID 5 numbers (150MB/s read with dd).

You are expecting 24 spindles to align up when you have a write
request, which has to be 23*chunksize bytes in order to avoid RMW.
Additionally, your array is so big that you're very likely to hit
another error while rebuilding.  Chop up your monster RAID5 array
into smaller arrays and stripe across them.  Even better, consider
RAID10.

Peter

-- 
    .+'''+.         .+'''+.         .+'''+.         .+'''+.         .+''
 Kelemen Péter     /       \       /       \     Peter.Kelemen@cern.ch
.+'         `+...+'         `+...+'         `+...+'         `+...+'
