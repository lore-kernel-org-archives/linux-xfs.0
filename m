Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:6354 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726149AbfAAWae (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Jan 2019 17:30:34 -0500
Date: Wed, 2 Jan 2019 09:30:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [Bug 202077] New: xfs transaction overruns on 4.14.67
Message-ID: <20190101223028.GI4205@dastard>
References: <bug-202077-201763@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-202077-201763@https.bugzilla.kernel.org/>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-xfs@vger.kernel.org

On Wed, Dec 26, 2018 at 05:19:12PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> We've encountered two recent examples of xfs transaction overruns on production
> systems running 4.14.67 kernels.  Both systems in this case are running docker
> with dozens of overlay mounts, using this xfs fs as both upper and lower.  In
> both cases the filesystem was able to successfully recover when the filesystem
> was unmounted and remounted again.

Inboth cases, it looks like there were two free space manipulations
in a single transaction, likely first modifying the free list
(pattern is EFD, XAGF, ABTB, ABTC, then AGFL) followed by freeing
the actual extent (more ABTB, ABTC buffers).

> It looks like there has been a good bit of work in 4.16+

The first fixes went into 4.18 with the deferred AGFL free
operations. Those were the commits associated with the patchset
titled "[PATCH v2 0/6] xfs: defer agfl block frees".

There were more fixes in 4.19 to always defer the AGFL free for all
operations. This was a much larger and more significant change, and
can be found from the series titled "[PATCH 00/24] xfs: broad
enablement of deferred agfl frees".

> addressing similar issues but none of it has made it back into the
> 4.14 LTS.  Any chance that any of the attached debug output points
> to anything specific that might be a candidate for backport?

Backporting the first series might be sufficient to avoid your
problem (both are from the inode inactivation path) but it is no
guarantee. I also have no idea what dependencies that patchset has
on the rest of the code (e.g. is there enough deferred op
infrastructure in place in 4.14?), and seeing as it touches core
allocation algorithms it would require a substantial amount of QA
before release....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
