Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Jul 2008 17:21:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6H0Lsbm031141
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2008 17:21:55 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DADB22FC092
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2008 17:23:02 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id Ns1sWhdv5q7AhdVj for <xfs@oss.sgi.com>; Wed, 16 Jul 2008 17:23:02 -0700 (PDT)
Date: Thu, 17 Jul 2008 10:22:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: question about xfs_fsync on linux
Message-ID: <20080717002253.GF29319@disturbed>
References: <20080715024830.GZ29319@disturbed> <200807162158.m6GLwtE00281@elf.torek.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200807162158.m6GLwtE00281@elf.torek.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Torek <chris.torek@windriver.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 16, 2008 at 03:58:55PM -0600, Chris Torek wrote:
> >Well, you are pretty much on your own, then. Really, we cannot help
> >diagnose problems on old kernels with a random set of backported
> >patches in them.
> 
> Definitely understood.  I just wanted to ask that original
> question, really.  I had assumed that the file system itself
> had to start any dirty-page writes, having missed the top level
> filemap_fdatawrite() call.
> 
> We finally got a test case and did a bunch of analysis, and it
> turns out that the DB software is missing an fsync() call.  Of
> course XFS won't fsync the file if you don't *ask* it to!

Yes, that would help ;)

Thanks for following up and letting us know you found the
problem.

> As long as I am sending mail, there is something else I am curious
> about though.  While this is not XFS specific, I wonder if there
> is any desire to have different background write frequencies on
> different file systems.  By default, mm/page-writeback.c will start
> writebacks after a 30-second delay.  One can tune this to any other
> number (via /proc/sys/vm/dirty_{expire,writeback}_centisecs), but
> this affects the entire system.  It might be useful to be able
> to tune this per-FS instead.

Wouldn't be too difficult, but really if you have  data that needs
to go to disk quickly from a given application then the application
should be triggering the flush. e.g. іssuing
posix_fadvise(fd, ...., POSIX_FADV_DONTNEED) will trigger an
immediate async flush of the file....

> (On the other hand, perhaps if one really wants one's data journaled,
> one should just use a data-journaling file system....)

Or use the sync mount option.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
