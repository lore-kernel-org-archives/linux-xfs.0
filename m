Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:25567 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751781AbdLCWEq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Dec 2017 17:04:46 -0500
Date: Mon, 4 Dec 2017 09:03:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Filesystem crash
Message-ID: <20171203220359.GW5858@dastard>
References: <3f4d2b55-9dd1-bc5a-2e49-cdfdc9a134b3@genome.arizona.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f4d2b55-9dd1-bc5a-2e49-cdfdc9a134b3@genome.arizona.edu>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chandler <admin@genome.arizona.edu>
Cc: linux-xfs@vger.kernel.org

On Fri, Dec 01, 2017 at 03:35:07PM -0700, Chandler wrote:
> Hi, we had our filesystem crash the other day after getting 100%
> full (although 53GB were still reported free).  I had to reboot the
> system and use xfs_repair.

Yup, it tripped over an freespace tree corruption and shut down to
prevent it from being propagatd. Could have been caused by anything
- hardware, kernel memory corruption, a bug, a MD rebuild issue,
etc. Did you save the output of xfs_repair so we can see what errors
it fixed up?

> It seem to me this shouldn't happen just
> because it got full, so maybe there is some other issue?  The
> filesystem resides on an MD RAID-5 array with 4x 2TB disks that are
> in good health, the array gets checked weekly by mdadm.  The only
> error messages in the system log were related to XFS (see below).
> The OS is RHEL 6.9 with kernel 2.6.32-642.11.1.el6.x86_64.

Not much we can do to diagnose the problem on old RHEL kernels on
upstream lists - the codebase has diverged from upstream too far.
Report the problem to your local RHEL support engineer if you need
further diagnostic help.

Cheers.

Dave.
-- 
Dave Chinner
david@fromorbit.com
