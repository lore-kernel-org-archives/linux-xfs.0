Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:63414 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965015AbeFOCeS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jun 2018 22:34:18 -0400
Date: Fri, 15 Jun 2018 12:34:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: symlinks can be zero length during log recovery
Message-ID: <20180615023416.GQ10363@dastard>
References: <20180615014314.27574-1-david@fromorbit.com>
 <2a19410d-171e-37b0-c4d4-5ae427ee8901@sandeen.net>
 <596c6c42-371a-0a77-8dc6-6f34e7e6d897@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <596c6c42-371a-0a77-8dc6-6f34e7e6d897@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Thu, Jun 14, 2018 at 09:02:11PM -0500, Eric Sandeen wrote:
> 
> 
> On 6/14/18 8:57 PM, Eric Sandeen wrote:
> > On 6/14/18 8:43 PM, Dave Chinner wrote:
> >> From: Dave Chinner <dchinner@redhat.com>
> >>
> >> A log recovery failure has been reproduced where a symlink inode has
> >> a zero length in extent form. It was caused by a shutdown during a
> >> combined fstress+fsmark workload.
> >>
> >> To fix it, we have to allow zero length symlink inodes through
> >> xfs_dinode_verify() during log recovery. We already specifically
> >> check and allow this case in the shortform symlink fork verifier,
> >> but in this case we don't get that far, and the inode is not in
> >> shortform format.
> >>
> >> Update the dinode verifier to handle this case, and change the
> >> symlink fork verifier to only allow this case to exist during log
> >> recovery.
> >>
> >> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > 
> > Looks reasonable.
> > 
> > Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> Also probably worth tagging with
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=200063

Why? I didn't know that existed until you pointed it out, and I
still haven't looked at it as I write this....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
