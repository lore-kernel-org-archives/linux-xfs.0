Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:45287 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751901AbeBBWes (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Feb 2018 17:34:48 -0500
Date: Sat, 3 Feb 2018 09:35:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS over device mapper dm-thin device
Message-ID: <20180202223541.i27bfjij7itt3q5r@destitution>
References: <147a1764-1988-4efd-4f02-e942a1001b4e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <147a1764-1988-4efd-4f02-e942a1001b4e@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Todd Gill <tgill@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Feb 02, 2018 at 04:45:33PM -0500, Todd Gill wrote:
> 
> Hi,
> 
> I'd like to be able to take a snapshot of an XFS filesystem on top of
> dm-thin.
> 
> The goal for the snapshot is:
> 
>     - fast to complete (couple seconds or better)
>     - independent of origin (UUID updated?)
>     - read/write
> 
> To satisfy the independent goal, I'm updating the UUID on the snapshot.
> Currently "xfs_admin -U xxx" takes in the ballpark of 14 seconds on my
> test system.

There's a very good chance that this is caused by dm-thinp doing
COW for the storage underlying the superblocks modified by the UUID
change.

Best to start by measuring how much IO is going on when you change
the UUID.  e.g. `iostat -x -d -m 1`. An strace showing how long the
xfs_db read() and write() calls to the dm-thinp device would lso be
instructive.

> Is there a better approach to achieve the goals?

No, you are doing the right thing.

> Or can the UUID update
> be changed to be faster?

Not sure - there's a fixed amount of modification we need to make
to change the UUID so I'm not sure there is any optimisations we
can make here.

If it's the speed of the underlying snapshot device doing COW after
a snapshot that is causing this issue, then there's probably nothing
we can do about it at the filesystem layer, anyway....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
