Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:44683 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726161AbfBFXnd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Feb 2019 18:43:33 -0500
Date: Thu, 7 Feb 2019 10:43:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: bcache on XFS: metadata I/O (dirent I/O?) not getting cached at
 all?
Message-ID: <20190206234328.GH14116@dastard>
References: <87h8dgefee.fsf@esperi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h8dgefee.fsf@esperi.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nix <nix@esperi.org.uk>
Cc: linux-bcache@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Feb 06, 2019 at 10:11:21PM +0000, Nix wrote:
> So I just upgraded to 4.20 and revived my long-turned-off bcache now
> that the metadata corruption leading to mount failure on dirty close may
> have been identified (applying Tang Junhui's patch to do so)... and I
> spotted something a bit disturbing. It appears that XFS directory and
> metadata I/O is going more or less entirely uncached.
> 
> Here's some bcache stats before and after a git status of a *huge*
> uncached tree (Chromium) on my no-writeback readaround cache. It takes
> many minutes and pounds the disk with massively seeky metadata I/O in
> the process:
> 
> Before:
> 
> stats_total/bypassed: 48.3G
> stats_total/cache_bypass_hits: 7942
> stats_total/cache_bypass_misses: 861045
> stats_total/cache_hit_ratio: 3
> stats_total/cache_hits: 16286
> stats_total/cache_miss_collisions: 25
> stats_total/cache_misses: 411575
> stats_total/cache_readaheads: 0
> 
> After:
> stats_total/bypassed: 49.3G
> stats_total/cache_bypass_hits: 7942
> stats_total/cache_bypass_misses: 1154887
> stats_total/cache_hit_ratio: 3
> stats_total/cache_hits: 16291
> stats_total/cache_miss_collisions: 25
> stats_total/cache_misses: 411625
> stats_total/cache_readaheads: 0
> 
> Huge increase in bypassed reads, essentially no new cached reads. This
> is... basically the optimum case for bcache, and it's not caching it!
> 
> From my reading of xfs_dir2_leaf_readbuf(), it looks like essentially
> all directory reads in XFS appear to bcache as a single non-readahead
> followed by a pile of readahead I/O: bcache bypasses readahead bios, so
> all directory reads (or perhaps all directory reads larger than a single
> block) are going to be bypassed out of hand.

That's a bcache problem, not an XFS problem. XFS does extensive
amounts of metadata readahead (btree traversals, directory access,
etc), and always has.

If bcache considers readahead as "not worth caching" then that has
nothing to do with XFS.

> 
> This seems... suboptimal, but so does filling up the cache with
> read-ahead blocks (particularly for non-metadata) that are never used.

Which is not the case for XFS. We do readahead when we know we are
going to need a block in the near future. It is rarely unnecessary,
it's a mechanism to reduce access latency when we do need to access
the metadata.

> Anyone got any ideas, 'cos I'm currently at a loss: XFS doesn't appear
> to let us distinguish between "read-ahead just in case but almost
> certain to be accessed" (like directory blocks) and "read ahead on the
> offchance because someone did a single-block file read and what the hell
> let's suck in a bunch more".

File data readahead: REQ_RAHEAD
Metadata readahead: REQ_META | REQ_RAHEAD

drivers/md/bcache/request.c::check_should_bypass():

        /*
         * Flag for bypass if the IO is for read-ahead or background,
         * unless the read-ahead request is for metadata (eg, for gfs2).
         */
        if (bio->bi_opf & (REQ_RAHEAD|REQ_BACKGROUND) &&
            !(bio->bi_opf & REQ_PRIO))
                goto skip;

bcache needs fixing - it thinks REQ_PRIO means metadata IO. That's
wrong - REQ_META means it's metadata IO, and so this is a bcache
bug.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
