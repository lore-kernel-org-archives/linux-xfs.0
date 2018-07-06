Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:25570 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932291AbeGFFmy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Jul 2018 01:42:54 -0400
Date: Fri, 6 Jul 2018 15:42:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC 0/8] xfs: introduce inode data inline feature
Message-ID: <20180706054250.GU2234@dastard>
References: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Shan Hai <shan.hai@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jul 06, 2018 at 11:12:21AM +0800, Shan Hai wrote:
> 
> This series implements xfs inode data inlining feature.

Cool. I was actually thinking about this earlier this week. :)

> Refered below link during development:
> https://marc.info/?l=linux-xfs&m=120493585731509&w=2
> 
> 
> How it works:
> - the data inlining happens at:
>   write_iter: for DIO/DAX write
>   writeback: for buffered write
> - extents to local format conversion is done in writeback but not in write_iter
> - local to extents format conversion is done in the write_iter and writeback

The problem with the way local to extents conversion is imlpemented
in this patchset is that we do not synchronise data writeback with
journal commits and log recovery.  The local to extents conversion
appears to be done like so:

----
writeback arrives in local format, data in extent cached page
convert inode to extent format
allocate new block
commit allocation and inode format conversion
submit data IO to newly allocated block.
----

This works when nothing goes wrong, but it's not failsafe. The
problem is that we've logged the inode data fork conversion before
we've completed writing the data to the new block. IOWs, we can end
up in the state where the active journal recoery window does not contain
the data in the inode and the data has not yet reached the new
allocated block on disk, either.

If we crash in this window, we lose the data that was in the inode -
log recovery finishes with the inode in extent form pointing to
uninitialised data blocks. i.e. not only is it a data loss event,
it's also a security issue because it exposes stale data.

This has been the unsolved problem from all previous attempts to
implement inline data in XFS. I actually outlined this problem and
ways to solve it in the mailing list post linked above, but it
doesn't appear that either mechanism was implemented in this
patchset.

However, unlike that post from 2008, we now have infrastructure that
can be used to solve to this problem: the data path copy-on-write
mechanism.  The COW mechanism is essentially a generic
implementation of the "Method 1: use an intent/done transaction
pair" solution I describe in the above post.

This mechanism solves the above problem by storing the newly
allocated block in the in-memory COW fork and doesn't modify the
data fork until after the data write IO completes. IOWs, we do
allocation before the write IO, and do the data fork and BMBT
manipulation after the IO completes. i.e. we do the local->extent
data fork modification at IO completion using the extent that was
stored in the in memory COW fork.

Hence I think the inline data write path needs to piggy back on the
iomap COW path that we use for writing to shared extents if the
write would cause a data fork format change.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
