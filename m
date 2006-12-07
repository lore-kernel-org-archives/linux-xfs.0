Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 06 Dec 2006 17:24:45 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kB71OaaG028414
	for <xfs@oss.sgi.com>; Wed, 6 Dec 2006 17:24:38 -0800
Date: Thu, 7 Dec 2006 12:23:38 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: mkfs.xfs questions
Message-ID: <20061207012338.GK44411608@melbourne.sgi.com>
References: <20061129174553.e0ef3465.jasmin@pacifica.ch> <Pine.LNX.4.64.0612010410530.3735@sheep.housecafe.de> <20061201183034.GA20595@teal.hq.k1024.org> <Pine.LNX.4.64.0612012349020.3735@sheep.housecafe.de> <20061202111546.GA18661@teal.hq.k1024.org> <Pine.LNX.4.64.0612051741520.22257@sheep.housecafe.de> <20061205212649.GV44411608@melbourne.sgi.com> <Pine.LNX.4.64.0612052219440.22257@sheep.housecafe.de> <Pine.LNX.4.64.0612061522530.22257@sheep.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0612061522530.22257@sheep.housecafe.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian Kujau <lists@nerdbynature.de>
Cc: xfs@oss.sgi.com

On Wed, Dec 06, 2006 at 03:57:55PM +0000, Christian Kujau wrote:
> On Tue, 5 Dec 2006, Christian Kujau wrote:
> >I started a test with 4GB of data (bonnie++ -s 4096m) an hour ago...
> 
> took 16hrs to complete, wow:
> 
> http://nerdbynature.de/bench/amd64/2.6.19-git7_xfs.2/
> http://nerdbynature.de/wp/?cat=4

You should try version 2 logs and larger log buffer sizes.

Also - external log I/O is not cached, so throughput to
the log is determined by the hardware. If the external
log is slow, it may be worse than an internal log in
terms of performance. Larger log buffers (v2 logs) should
improve performance for these tests on both internal
and external logs.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
