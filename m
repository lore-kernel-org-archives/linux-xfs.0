Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45551 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753664AbdAJHpf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Jan 2017 02:45:35 -0500
Date: Mon, 9 Jan 2017 23:45:24 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Reading about CoW architecture / Performance Limits
Message-ID: <20170110074524.GI14038@birch.djwong.org>
References: <BC894F29-47E7-47A3-93FB-3E4EEE1DCDD5@flyingcircus.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BC894F29-47E7-47A3-93FB-3E4EEE1DCDD5@flyingcircus.io>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christian Theune <ct@flyingcircus.io>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 10, 2017 at 08:07:39AM +0100, Christian Theune wrote:
> Hi,
> 
> As XFS is gaining CoW support I’d like to understand the
> implementation on a specific aspect: we’re using CoW for making disk
> image backups as image files in btrfs. This has proven prohibitive
> once the chain of CoW reflinks grows too long and everything becomes
> too fragmented. btrfs has improved in some places but the issue still
> persists.

As in making snapshots of a disk image via something like
"cp --reflink=always a.img a.img.20170110" ?

> We’re currently considering to move away from CoW filesystems for our
> use case and implement a higher level strategy. I now wonder whether
> XFS will have the same issue or whether the architecture is different
> in a significant way that will avoid prohibitive performance
> regressions on long CoW chains (think: hundreds to a few thousand).

The primary strategies XFS uses to combat fragmentation are a
combination of reusing the delayed allocation mechanism to defer CoW
block allocation as long as possible in the hopes of being able to make
larger requests; and implementing the "CoW extent size hint" (default 32
blocks or 128K) which rounds the start and end of an allocation request
to the nearest $cowextsize boundary.  So for example if you write to 32
adjacent shared blocks in random order, they'll end up on disk with a
single 128K extent, if possible.

Note also that XFS only performs CoW if the block is shared, so if you
write the same shared block in a file 20 times, the first write goes to
a new block and the next 19 overwrite that new block.  There will not be
another CoW unless you reflink the file again.

> I would appreciate a pointer where to look at - I’m a coder but
> following kernel code to understand architecture hasn’t been
> successful/efficient for me in the past …

You might try reading the huge comment blocks in fs/xfs/xfs_reflink.c.

--D

> 
> Kind regards,
> Christian
> 
> --
> Christian Theune · ct@flyingcircus.io · +49 345 219401 0
> Flying Circus Internet Operations GmbH · http://flyingcircus.io
> Forsterstraße 29 · 06112 Halle (Saale) · Deutschland
> HR Stendal HRB 21169 · Geschäftsführer: Christian. Theune, Christian. Zagrodnick
> 


