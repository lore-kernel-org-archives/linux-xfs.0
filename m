Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 Jul 2008 00:59:28 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m647xNPK006061
	for <xfs@oss.sgi.com>; Fri, 4 Jul 2008 00:59:25 -0700
Received: from build-svl-1.agami.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 03A3F187862B
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2008 01:00:26 -0700 (PDT)
Received: from build-svl-1.agami.com (colo-nat-pool.agami.com [216.218.227.40]) by cuda.sgi.com with ESMTP id MzlpqpIUkyrhGccQ for <xfs@oss.sgi.com>; Fri, 04 Jul 2008 01:00:26 -0700 (PDT)
Date: Fri, 4 Jul 2008 00:59:41 -0700
From: Dave Chinner <dchinner@agami.com>
Subject: Re: XFS perfomance degradation on growing filesystem size
Message-ID: <20080704075941.GP16257@build-svl-1.agami.com>
References: <20080704064126.GA14847@webde.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080704064126.GA14847@webde.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jens Beyer <jens.beyer@1und1.de>
Cc: xfs@oss.sgi.com

On Fri, Jul 04, 2008 at 08:41:26AM +0200, Jens Beyer wrote:
> 
> Hi,
> 
> I have encountered a strange performance problem during some 
> hardware evaluation tests: 
> 
> I am running a benchmark to measure especially random read/write 
> I/O on an raid device and found that (under some circumstances) 
> the performance of Random Read I/O is inverse proportional to the 
> size of the tested XFS filesystem. 
> 
> In numbers this means that on a 100GB partition I get a throughput 
> of ~25 MB/s and on the same hardware at 1TB FS size only 18 MB/s 
> (and at 2+ TB like 14 MB/s) (absolute values depend on options, 
> kernel version and are for random read i/o at 8k test block size).

Of course - as the filesystem size grows, so does the amount of
each disk in use so the average seek distance increases and hence
read I/Os take longer.

Cheers,

Dave.
-- 
Dave Chinner
dchinner@agami.com
