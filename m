Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36634 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751111AbdJCUkv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 16:40:51 -0400
Date: Tue, 3 Oct 2017 13:40:51 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: Something like ZFS Channel Programs for BTRFS & probably XFS or
 even VFS?
Message-ID: <20171003204051.GA8848@bombadil.infradead.org>
References: <1799362.XC3pUdehxN@merkaba>
 <20171003201035.GL3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171003201035.GL3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Martin Steigerwald <martin@lichtvoll.de>, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

On Wed, Oct 04, 2017 at 07:10:35AM +1100, Dave Chinner wrote:
> On Tue, Oct 03, 2017 at 03:19:18PM +0200, Martin Steigerwald wrote:
> > [repost. I didn´t notice autocompletion gave me wrong address for fsdevel, 
> > blacklisted now]
> > 
> > Hello.
> > 
> > What do you think of
> > 
> > http://open-zfs.org/wiki/Projects/ZFS_Channel_Programs
> 
> Domain not found.

Must be an Australian problem ...

A ZFS channel program (ZCP) is a small script written in a domain specific
language that manipulate ZFS internals in a single, atomically-visible
operation. For instance, to delete all snapshots of a filesystem a ZCP
could be written which 1) generates the list of snapshots, 2) traverses
that list, and 3) destroys each snapshot unconditionally. Because
each of these statements would be evaluated from within the kernel,
ZCPs can guarantee safety from interference with other concurrent ZFS
modifications. Executing from inside the kernel allows us to guarantee
atomic visibility of these operations (correctness) and allows them to
be performed in a single transaction group (performance).

A successful implementation of ZCP will:

1. Support equivalent functionality for all of the current ZFS commands
with improved performance and correctness from the point of view of the
user of ZFS.

2. Facilitate the quick addition of new and useful commands as
ZCP enables the implementation of more powerful operations which
previously would have been unsafe to implement in user programs, or
would require modifications to the kernel for correctness. Since the
ZCP layer guarantees the atomicity of each ZCP, we only need to write
new sync_tasks for individual simple operations, then can use ZCPs to
chain those simple operations together into more complicated operations.

3. Allow ZFS users to safely implement their own ZFS operations without
performing operations they don’t have the privileges for.

4. Improve the performance and correctness of existing applications
built on ZFS operations.
