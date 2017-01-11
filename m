Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37167 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933957AbdAKH7w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jan 2017 02:59:52 -0500
Date: Tue, 10 Jan 2017 23:59:37 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Reading about CoW architecture / Performance Limits
Message-ID: <20170111075937.GA5883@birch.djwong.org>
References: <BC894F29-47E7-47A3-93FB-3E4EEE1DCDD5@flyingcircus.io>
 <20170110074524.GI14038@birch.djwong.org>
 <C97BB12C-3C30-493B-BE9A-9E8C7CB5D1A4@flyingcircus.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C97BB12C-3C30-493B-BE9A-9E8C7CB5D1A4@flyingcircus.io>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christian Theune <ct@flyingcircus.io>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 10, 2017 at 11:54:23AM +0100, Christian Theune wrote:
> Hi,
> 
> > On 10 Jan 2017, at 08:45, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > 
> > As in making snapshots of a disk image via something like
> > "cp --reflink=always a.img a.img.20170110” ?
> 
> Yes. Or rather in our case:
> 
> cp —reflink=always a-20170109.img a-20170110.img
> 
> and then go to the live storage and retrieve the changes from its
> 20170109 snapshot to the 20170110 snapshot and write them into the
> reflink-copied a-201701010.img
> 
> Once a backup expires we just delete the file. This perpetuates based
> on the backup schema.

<nod>

> >> We’re currently considering to move away from CoW filesystems for our
> >> use case and implement a higher level strategy. I now wonder whether
> >> XFS will have the same issue or whether the architecture is different
> >> in a significant way that will avoid prohibitive performance
> >> regressions on long CoW chains (think: hundreds to a few thousand).
> > 
> > The primary strategies XFS uses to combat fragmentation are a
> > combination of reusing the delayed allocation mechanism to defer CoW
> > block allocation as long as possible in the hopes of being able to make
> > larger requests; and implementing the "CoW extent size hint" (default 32
> > blocks or 128K) which rounds the start and end of an allocation request
> > to the nearest $cowextsize boundary.  So for example if you write to 32
> > adjacent shared blocks in random order, they'll end up on disk with a
> > single 128K extent, if possible.
> 
> Ah. In our case even larger extends might make sense, like 4MiB or such.

Perhaps.  You're only likely to see benefits if you actually write
4MB chunks.

> > Note also that XFS only performs CoW if the block is shared, so if you
> > write the same shared block in a file 20 times, the first write goes to
> > a new block and the next 19 overwrite that new block.  There will not be
> > another CoW unless you reflink the file again.
> 
> Actually every snapshot will be written exactly once, so depending on
> the workload larger extents might cause higher overhead (or will the
> hint + deferred still make smaller extents if only a small piece was
> changed?) if the overwrite ratio is small.

It'll make smaller extents if only a small piece gets changed.  We don't
try any tricks like preemptively CoWing non-dirty data to reduce
fragmentation.

> We definitely write all changes that exist sequentially (and skip the
> non-changed areas).
> 
> In our schema a new reflink would be created either every hour or
> every day. For hourly backups that’s a bit less than 9k “reflink
> generations” per year. For long running instances this can be in the
> range of 5-6 years for us easily.

~60,000, that will be interesting.  Haven't gotten that high in normal
usage, though a couple of the xfstests shoot for sharing the same block
1 million times to see how well the FS responds.

--D

> >> I would appreciate a pointer where to look at - I’m a coder but
> >> following kernel code to understand architecture hasn’t been
> >> successful/efficient for me in the past …
> > 
> > You might try reading the huge comment blocks in fs/xfs/xfs_reflink.c.
> 
> Great, thanks! I admit not having looked there myself as I didn’t
> expect it. Lesson learned!
> 
> Christian
> 
> --
> Christian Theune · ct@flyingcircus.io · +49 345 219401 0
> Flying Circus Internet Operations GmbH · http://flyingcircus.io
> Forsterstraße 29 · 06112 Halle (Saale) · Deutschland
> HR Stendal HRB 21169 · Geschäftsführer: Christian. Theune, Christian. Zagrodnick
> 


