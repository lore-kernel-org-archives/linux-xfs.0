Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 16 Sep 2008 00:02:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8G72nQO013219
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2008 00:02:49 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 338C21275DD9
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2008 00:04:20 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id UA17gOajnzPp801Y for <xfs@oss.sgi.com>; Tue, 16 Sep 2008 00:04:20 -0700 (PDT)
Date: Tue, 16 Sep 2008 17:03:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.27-rc6: lockdep warning: iprune_mutex at
	shrink_icache_memory+0x38/0x1a8
Message-ID: <20080916070317.GB5811@disturbed>
References: <20080913233138.GA19576@orion> <20080916025204.GL5811@disturbed> <7iduc45t9dvo0396fm78d8uat84uurh131@4ax.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7iduc45t9dvo0396fm78d8uat84uurh131@4ax.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Grant Coady <gcoady.lk@gmail.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>, rjw@sisk.pl, linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Sep 16, 2008 at 02:31:05PM +1000, Grant Coady wrote:
> On Tue, 16 Sep 2008 12:52:04 +1000, Dave Chinner <david@fromorbit.com> wrote:
> 
> >On Sun, Sep 14, 2008 at 03:31:38AM +0400, Alexander Beregalov wrote:
> >> Hi
> >> 
> >> [ INFO: possible circular locking dependency detected ]
> >> 2.6.27-rc6-00034-gd1c6d2e #3
> >> -------------------------------------------------------
> >> nfsd/1766 is trying to acquire lock:
> >>  (iprune_mutex){--..}, at: [<c01743fb>] shrink_icache_memory+0x38/0x1a8
> >> 
> >>  but task is already holding lock:
> >>   (&(&ip->i_iolock)->mr_lock){----}, at: [<c021134f>]
> >>   xfs_ilock+0xa2/0xd6
> >> 
> >> 
> >> I read files through nfs and saw delay for few seconds.
> >> System is x86_32, nfs, xfs.
> >> The last working kernel is 2.6.27-rc5,
> >> I do not know yet is it reproducible or not.
> >
> ><sigh>
> >
> >We need a FAQ for this one. It's a false positive.  Google for an
> >explanation - I've explained it 4 or 5 times in the past year and
> >asked that the lockdep folk invent a special annotation for the
> >iprune_mutex (or memory reclaim) because of the way it can cause
> >recursion into the filesystem and hence invert lock orders without
> >causing deadlocks.....
> 
> Yeah, but a 30 second dreadlock?  It's a long wait wondering what's 
> gone down or not ;)

The delay will be probably due to how slow the system can be when it
runs out of memory, not from the lockdep report.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
