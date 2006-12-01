Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Dec 2006 15:59:59 -0800 (PST)
Received: from mail.g-house.de (ns2.g-housing.de [81.169.133.75])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB1NxoaG005694
	for <xfs@oss.sgi.com>; Fri, 1 Dec 2006 15:59:52 -0800
Date: Fri, 1 Dec 2006 23:59:08 +0000 (GMT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: mkfs.xfs questions
In-Reply-To: <20061201183034.GA20595@teal.hq.k1024.org>
Message-ID: <Pine.LNX.4.64.0612012349020.3735@sheep.housecafe.de>
References: <20061129174553.e0ef3465.jasmin@pacifica.ch>
 <Pine.LNX.4.64.0612010410530.3735@sheep.housecafe.de>
 <20061201183034.GA20595@teal.hq.k1024.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Iustin Pop <iusty@k1024.org>
Cc: xfs@oss.sgi.com

On Fri, 1 Dec 2006, Iustin Pop wrote:
> I don't understand how you took that conclusion. The explanations refer
> to the default log size. I believe the original poster asked about the
> performance advantage of *raising* the log size above the default values
> for internal logs,

I was under the assumption that the OP asked about altering the size of 
the log at all and the manpage only states a reason for *decreasing* the 
logsize.

> and my impression is that metadata-intensive
> workloads benefit from increasing the log size (however no hard numbers
> are available).

As no numbers are known to me either, I did not see a point in 
increasing the log, hence my statement.

> A while back when mkfs.xfs had more conservative default value, bigger log
> sizes indeed helped for big filesystems.

As I've done a few benchmarks[0] for different filesystems lately I 
might find some time to play around with different fs tweaks...

Christian.

[0] http://nerdbynature.de/wp/?cat=4
-- 
BOFH excuse #353:

Second-system effect.
