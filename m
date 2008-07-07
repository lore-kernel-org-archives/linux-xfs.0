Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 Jul 2008 01:03:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6782rqG022479
	for <xfs@oss.sgi.com>; Mon, 7 Jul 2008 01:02:55 -0700
Received: from mailgate02.web.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9FE7911DE847
	for <xfs@oss.sgi.com>; Mon,  7 Jul 2008 01:03:58 -0700 (PDT)
Received: from mailgate02.web.de (mailgate02.web.de [217.72.192.252]) by cuda.sgi.com with ESMTP id vsgGyXW5HYa0GJus for <xfs@oss.sgi.com>; Mon, 07 Jul 2008 01:03:58 -0700 (PDT)
Date: Mon, 7 Jul 2008 10:04:09 +0200
From: Jens Beyer <jens.beyer@1und1.de>
Subject: Re: XFS perfomance degradation on growing filesystem size
Message-ID: <20080707080409.GA18390@webde.de>
References: <20080704064126.GA14847@webde.de> <20080704075941.GP16257@build-svl-1.agami.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080704075941.GP16257@build-svl-1.agami.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Fri, Jul 04, 2008 at 12:59:41AM -0700, Dave Chinner wrote:
> On Fri, Jul 04, 2008 at 08:41:26AM +0200, Jens Beyer wrote:
> > 
> > I have encountered a strange performance problem during some 
> > hardware evaluation tests: 
> > 
> > I am running a benchmark to measure especially random read/write 
> > I/O on an raid device and found that (under some circumstances) 
> > the performance of Random Read I/O is inverse proportional to the 
> > size of the tested XFS filesystem. 
> > 
> > In numbers this means that on a 100GB partition I get a throughput 
> > of ~25 MB/s and on the same hardware at 1TB FS size only 18 MB/s 
> > (and at 2+ TB like 14 MB/s) (absolute values depend on options, 
> > kernel version and are for random read i/o at 8k test block size).
> 
> Of course - as the filesystem size grows, so does the amount of
> each disk in use so the average seek distance increases and hence
> read I/Os take longer.
> 

But then - why does the rate of ext3 does not decrease and stays at the
higher value? 

Thanks,
Jens
