Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Apr 2008 17:06:57 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3I06VIY008909
	for <xfs@oss.sgi.com>; Thu, 17 Apr 2008 17:06:34 -0700
Date: Fri, 18 Apr 2008 10:06:57 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: 2.6.25 released with bug, which leads to XFS crash?
Message-ID: <20080418000657.GC108924158@sgi.com>
References: <200804170949.36864.denys@visp.net.lb>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804170949.36864.denys@visp.net.lb>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Denys Fedoryshchenko <denys@visp.net.lb>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Apr 17, 2008 at 09:49:36AM +0300, Denys Fedoryshchenko wrote:
> Hi again
> 
> I reported about http://bugzilla.kernel.org/show_bug.cgi?id=10421 , and it
> is triggerable on different loaded servers with XFS (squid with aufs),
> just it is happening even on heavy load after 1-2 days. IMHO such bugs is
> critical (same as getting kernel panic, and etc),

Well, yes, and we treat shutdown bugs as such. A filesystem shutdown
is effectively a filesystem panic and is indicative of either a
corruption or a bug. The reality is that it takes time to triage
such a problem that only occurs on one workload on one set of
identical machines once every day or two. This does not make the
problem a release blocker, though.

The other side of it is that problems like this in Linux are often
the result of a bug in a lower layer and not XFS itself. Given this
particular problem seems to be memory corruption it could be anything
that is causing it....

> cause they are unrecoverable, causing minor filesystem corruption, and only
> way to fix them - wakeup sysadmin. Worst thing, it is hapenning at night,
> when i restart squid, and probably it is doing agressive unlinking stale
> cache entries. It doesn't do panic, or even oops, but filesystem will be
> disconnected, > and squid will remain in loop trying to restart. Sure it is
> easy to restart it, but maybe it has to be OOPS? so at least i can do
> sysctl -w kernel.panic_on_oops = 1, and FS will be recovered on reboot.

Rather than fearmongering, perhaps you should ask on the XFS list
(xfs@oss.sgi.com) whether anything like this can be done.  Then you
might have learnt about Documentation/filesystems/xfs.txt and
/proc/sys/fs/xfs/panic_mask:

  fs.xfs.panic_mask             (Min: 0  Default: 0  Max: 127)
        Causes certain error conditions to call BUG(). Value is a bitmask;
        AND together the tags which represent errors which should cause panics:

> Just want to warn people who is using XFS on loaded servers to keep
> attention while using 2.6.25, and if you face same bug, report to bugzilla.

Actually, I'd much prefer XFS bug reports to go to xfs@oss.sgi.com
rather than the kernel bugzilla - that way most of the XFS community
will see the bug report and the triage being done and then there's
no need for spamming lkml like this....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
