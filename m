Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 02 Dec 2006 04:26:27 -0800 (PST)
Received: from astra.simleu.ro (astra.simleu.ro [80.97.18.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB2CQFaG002586
	for <xfs@oss.sgi.com>; Sat, 2 Dec 2006 04:26:17 -0800
Date: Sat, 2 Dec 2006 12:15:46 +0100
From: Iustin Pop <iusty@k1024.org>
Subject: Re: mkfs.xfs questions
Message-ID: <20061202111546.GA18661@teal.hq.k1024.org>
References: <20061129174553.e0ef3465.jasmin@pacifica.ch> <Pine.LNX.4.64.0612010410530.3735@sheep.housecafe.de> <20061201183034.GA20595@teal.hq.k1024.org> <Pine.LNX.4.64.0612012349020.3735@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0612012349020.3735@sheep.housecafe.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian Kujau <lists@nerdbynature.de>
Cc: xfs@oss.sgi.com

On Fri, Dec 01, 2006 at 11:59:08PM +0000, Christian Kujau wrote:
> On Fri, 1 Dec 2006, Iustin Pop wrote:
> >I don't understand how you took that conclusion. The explanations refer
> >to the default log size. I believe the original poster asked about the
> >performance advantage of *raising* the log size above the default values
> >for internal logs,
> 
> I was under the assumption that the OP asked about altering the size of 
> the log at all and the manpage only states a reason for *decreasing* the 
> logsize.
Ah, I see. Sorry for the confusion.

> >and my impression is that metadata-intensive
> >workloads benefit from increasing the log size (however no hard numbers
> >are available).
> 
> As no numbers are known to me either, I did not see a point in 
> increasing the log, hence my statement.
Hmm, I am pretty sure that it makes a difference, but only from personal
experience, not from benchmarks. A while ago, mkfs.xfs used to make <8M
logs even for big filesystems[0]. Nowadays it chooses a more sane value.

> >A while back when mkfs.xfs had more conservative default value, bigger log
> >sizes indeed helped for big filesystems.
> 
> As I've done a few benchmarks[0] for different filesystems lately I 
> might find some time to play around with different fs tweaks...

That would be interesting!

[0] http://oss.sgi.com/archives/xfs/2002-04/msg00443.html and the
    corresponding thread, especially
    http://oss.sgi.com/archives/xfs/2002-04/msg00441.html

Iustin
