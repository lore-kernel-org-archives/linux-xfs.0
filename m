Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Mar 2007 16:00:13 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2FN076p016934
	for <xfs@oss.sgi.com>; Thu, 15 Mar 2007 16:00:09 -0700
Date: Fri, 16 Mar 2007 09:59:59 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Strange XFS issue on tiny-NAS ARM NFS server
Message-ID: <20070315225959.GO6095633@melbourne.sgi.com>
References: <EXNANE01iR9Odutox7n000000c6@exnane01.hq.netapp.com> <45F85BFA.1070505@sandeen.net> <EXNANE01yeKzGZuNY1S000000cb@exnane01.hq.netapp.com> <EXNANE01pH71yEXUIEA000000d3@exnane01.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EXNANE01pH71yEXUIEA000000d3@exnane01.hq.netapp.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Talpey, Thomas" <Thomas.Talpey@netapp.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 15, 2007 at 07:34:37AM -0400, Talpey, Thomas wrote:
> Evidently that was not the only compiling issue (surprise):
> 
> ><6>attempt to access beyond end of device
> ><6>sda3: rw=2, want=2574098408, limit=154272195
> ><6>attempt to access beyond end of device
> ><6>sda3: rw=2, want=2574098408, limit=154272195
> ><6>attempt to access beyond end of device
> ><6>sda3: rw=2, want=2574098408, limit=154272195
> ><6>attempt to access beyond end of device
> ><6>sda3: rw=0, want=2574098408, limit=154272195
> ><1>I/O error in filesystem ("sda3") meta-data dev sda3 block 0x996d9fe0       ("xfs_trans_read_buf") error 5 buf count 4096

That's a long way past the end of the partition.

Tom, did you run xfs_repair on that filesystem after
running with a busted compiler? Who knows how
it broke stuff on disk.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
