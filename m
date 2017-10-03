Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:29028 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751117AbdJCVoF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 17:44:05 -0400
Date: Wed, 4 Oct 2017 08:44:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Something like ZFS Channel Programs for BTRFS & probably XFS or
 even VFS?
Message-ID: <20171003214401.GP3666@dastard>
References: <1799362.XC3pUdehxN@merkaba>
 <20171003201035.GL3666@dastard>
 <20171003204051.GA8848@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171003204051.GA8848@bombadil.infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Matthew Wilcox <willy@infradead.org>
Cc: Martin Steigerwald <martin@lichtvoll.de>, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

On Tue, Oct 03, 2017 at 01:40:51PM -0700, Matthew Wilcox wrote:
> On Wed, Oct 04, 2017 at 07:10:35AM +1100, Dave Chinner wrote:
> > On Tue, Oct 03, 2017 at 03:19:18PM +0200, Martin Steigerwald wrote:
> > > [repost. I didn´t notice autocompletion gave me wrong address for fsdevel, 
> > > blacklisted now]
> > > 
> > > Hello.
> > > 
> > > What do you think of
> > > 
> > > http://open-zfs.org/wiki/Projects/ZFS_Channel_Programs
> > 
> > Domain not found.
> 
> Must be an Australian problem ...

Probably, I forgot to stand on my head so everything must have been
sent to the server upside down....

Though it is a curious failure - it failed until I went to
"openzfs.org" and that redirected to "open-zfs.org" and now it all
works. Somewhat bizarre.

> A ZFS channel program (ZCP) is a small script written in a domain specific
> language that manipulate ZFS internals in a single, atomically-visible
> operation.  For instance, to delete all snapshots of a filesystem a ZCP
> could be written which 1) generates the list of snapshots, 2) traverses
> that list, and 3) destroys each snapshot unconditionally. Because
> each of these statements would be evaluated from within the kernel,
> ZCPs can guarantee safety from interference with other concurrent ZFS
> modifications. Executing from inside the kernel allows us to guarantee
> atomic visibility of these operations (correctness) and allows them to
> be performed in a single transaction group (performance).
>
> A successful implementation of ZCP will:
> 
> 1. Support equivalent functionality for all of the current ZFS commands
> with improved performance and correctness from the point of view of the
> user of ZFS.
> 
> 2. Facilitate the quick addition of new and useful commands as
> ZCP enables the implementation of more powerful operations which
> previously would have been unsafe to implement in user programs, or
> would require modifications to the kernel for correctness. Since the
> ZCP layer guarantees the atomicity of each ZCP, we only need to write
> new sync_tasks for individual simple operations, then can use ZCPs to
> chain those simple operations together into more complicated operations.
> 
> 3. Allow ZFS users to safely implement their own ZFS operations without
> performing operations they don’t have the privileges for.
> 
> 4. Improve the performance and correctness of existing applications
> built on ZFS operations.

/me goes and looks at the slides....

Seems like they are trying to solve a problem of their own making,
in that admin operations are run by the kernel from a separate task
that is really, really slow. So this scripting is a method of aggregating
multiple "sync tasks" into a single operation so there isn't delays
between tasks.

/me chokes on slide 8/8

"Add a Lua interpreter to the kernel, implement ZFS intrinsics (...)
as extensions to the Lua language...."

Somehow, I don't see that happening in Linux.

Yes, I can see us potentially adding some custom functionality in
filesystems with eBPF (e.g. custom allocation policies), but I think
admin operations need to be done from userspace through a clear,
stable interface that supports all the necessary primitives to
customise admin operations for different needs.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
