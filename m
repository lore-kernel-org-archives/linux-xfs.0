Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Nov 2006 20:24:33 -0800 (PST)
Received: from mail.g-house.de (ns2.g-housing.de [81.169.133.75])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB14OOaG007564
	for <xfs@oss.sgi.com>; Thu, 30 Nov 2006 20:24:25 -0800
Date: Fri, 1 Dec 2006 04:23:41 +0000 (GMT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: mkfs.xfs questions
In-Reply-To: <20061129174553.e0ef3465.jasmin@pacifica.ch>
Message-ID: <Pine.LNX.4.64.0612010410530.3735@sheep.housecafe.de>
References: <20061129174553.e0ef3465.jasmin@pacifica.ch>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jasmin Buchert <jasmin@pacifica.ch>
Cc: xfs@oss.sgi.com

On Wed, 29 Nov 2006, Jasmin Buchert wrote:
> Is there any real advantage of making the log size 32-64 MB and

>From 'man mkfs.xfs':

    If the  log  is  contained within the data section and size isn't
    specified, mkfs.xfs will try to select a suitable log
    size depending on the size of the filesystem.  The actual
    logsize depends on the filesystem block size and the directory
    block size.

    Otherwise, the size suboption is only needed if the log
    section of the filesystem should occupy less space than the size
    of the special file.

So, if you're not limited by very special space restrictions, you won't 
need the "size" option.

> what is the difference between log version 1 and 2 regarding to
> efficency/performance?

The "version" option should have no effect on performance, from 'man 
mkfs.xfs' again:

      Using the version suboption to specify a version 2 log enables the
      sunit  suboption,  and  allows  the  logbsize  to  be increased
      beyond  32K.

The "sunit" options can be tweaked to provide better performace in raid5 
environments, same for the "agcount" option: for special needs only but 
I'm not aware of any benchmarks for different sunit/agcount values.

> Is it true that a small agcount is better for most systems
> (Gentoo and some other sources recommend this)? It's a desktop machine.

Hm, some people are indeed suggesting this [0], you might ask the author 
of the doc why he's doing this or test this by yourself.

Christian.

[0] http://www.rootforum.de/wiki/howto/gentoo/basesystem#formatieren_der_partitionen
-- 
BOFH excuse #244:

Your cat tried to eat the mouse.
