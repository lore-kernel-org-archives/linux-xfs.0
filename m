Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Dec 2006 10:50:26 -0800 (PST)
Received: from astra.simleu.ro (astra.simleu.ro [80.97.18.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB1IoFaG030326
	for <xfs@oss.sgi.com>; Fri, 1 Dec 2006 10:50:17 -0800
Date: Fri, 1 Dec 2006 19:30:34 +0100
From: Iustin Pop <iusty@k1024.org>
Subject: Re: mkfs.xfs questions
Message-ID: <20061201183034.GA20595@teal.hq.k1024.org>
References: <20061129174553.e0ef3465.jasmin@pacifica.ch> <Pine.LNX.4.64.0612010410530.3735@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0612010410530.3735@sheep.housecafe.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian Kujau <lists@nerdbynature.de>
Cc: Jasmin Buchert <jasmin@pacifica.ch>, xfs@oss.sgi.com

On Fri, Dec 01, 2006 at 04:23:41AM +0000, Christian Kujau wrote:
> On Wed, 29 Nov 2006, Jasmin Buchert wrote:
> >Is there any real advantage of making the log size 32-64 MB and
> 
> From 'man mkfs.xfs':
> 
>    If the  log  is  contained within the data section and size isn't
>    specified, mkfs.xfs will try to select a suitable log
>    size depending on the size of the filesystem.  The actual
>    logsize depends on the filesystem block size and the directory
>    block size.
> 
>    Otherwise, the size suboption is only needed if the log
>    section of the filesystem should occupy less space than the size
>    of the special file.
> 
> So, if you're not limited by very special space restrictions, you won't 
> need the "size" option.

I don't understand how you took that conclusion. The explanations refer
to the default log size. I believe the original poster asked about the
performance advantage of *raising* the log size above the default values
for internal logs, and my impression is that metadata-intensive
workloads benefit from increasing the log size (however no hard numbers
are available).

A while back when mkfs.xfs had more conservative default value, bigger log
sizes indeed helped for big filesystems.

Regards,
Iustin
