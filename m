Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:63964 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727339AbfA2VlV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Jan 2019 16:41:21 -0500
Date: Wed, 30 Jan 2019 08:41:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [Bug 202441] Possibly vfs cache related replicable xfs
 regression since 4.19.0  on sata hdd:s
Message-ID: <20190129214116.GZ4205@dastard>
References: <bug-202441-201763@https.bugzilla.kernel.org/>
 <bug-202441-201763-Av2K1cZ8fw@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-202441-201763-Av2K1cZ8fw@https.bugzilla.kernel.org/>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 29, 2019 at 05:55:00PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=202441
> 
> --- Comment #12 from Roger (rogan6710@gmail.com) ---
> Now I have tested all rc versions as well. None of them have the problem.
> I'm watching "top" as the compile executes and seeing a _large_ difference
> in how the problem free kernel versions handles buff/cache versus the others.

You've been busy! And your results are very interesting.

> Beginnig from rc5, might have been earlier also, cache get's released,
> sometimes almost all of it, and begins to fill up slowly again,

Which I'd consider bad behaviour - trashing the entire working set
because memory pressure is occurring is pathological behaviour.

Can you confirm which -rcX that behaviour starts in? e.g. between
-rc4 and -rc5 there is this commit:

172b06c32b94 mm: slowly shrink slabs with a relatively small number of objects

Which does change the way that the inode caches are reclaimed by
forcably triggering reclaim for caches that would have previously
been ignored. That's one of the "red flag" commits I noticed when
first looking at the history between 4.18 and 4.19....

> while for
> instance on 4.19.18 it get's almost completely filled (23.5 of 24 G) and is not
> released unless the copying is manually halted.

Which is how I'd expect memory reclaim to work - only free enough
for the current demand. What seems to be the issue is that it's not
freeing enough page cache, and so dumping more reclaim load on the
shrinkers and that's driving XFS inode reclaim into IO and
blocking...

Looking at the sysrq-w info from 4.19-rc1, it's all just waiting on
IO as the disk is busy, as I'd expect to see. Given that this
doesn't appear to be a problem in the early 4.19-rcX kernels, that
means it's either a problem in the released 4.19.0 or it's something
backported from a 4.20 kernel into the stable kernels.

SO, three questions:
	- did you test a 4.19.0 kernel?
	- if not, can you test it?
	- if 4.19.0 doesn't have the problem, can you sample a
	  couple of 4.19.x stable kernels (say .5, .10 and .15,
	  but definitely not .11 or .12 as they contain memory
	  corrupting bugs from an auto-backport of a buggy, untested
	  4.20-rc commit)

Basically, we're now at the point where this needs to be isolated
to the stable kernel series, and then we have a much smaller bunch
of commits that might be causing it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
