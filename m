Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:36954 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbfBFX0i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Feb 2019 18:26:38 -0500
From: Nix <nix@esperi.org.uk>
Subject: bcache on XFS: metadata I/O (dirent I/O?) not getting cached at all?
Date: Wed, 06 Feb 2019 22:11:21 +0000
Message-ID: <87h8dgefee.fsf@esperi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-bcache@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

So I just upgraded to 4.20 and revived my long-turned-off bcache now
that the metadata corruption leading to mount failure on dirty close may
have been identified (applying Tang Junhui's patch to do so)... and I
spotted something a bit disturbing. It appears that XFS directory and
metadata I/O is going more or less entirely uncached.

Here's some bcache stats before and after a git status of a *huge*
uncached tree (Chromium) on my no-writeback readaround cache. It takes
many minutes and pounds the disk with massively seeky metadata I/O in
the process:

Before:

stats_total/bypassed: 48.3G
stats_total/cache_bypass_hits: 7942
stats_total/cache_bypass_misses: 861045
stats_total/cache_hit_ratio: 3
stats_total/cache_hits: 16286
stats_total/cache_miss_collisions: 25
stats_total/cache_misses: 411575
stats_total/cache_readaheads: 0

After:
stats_total/bypassed: 49.3G
stats_total/cache_bypass_hits: 7942
stats_total/cache_bypass_misses: 1154887
stats_total/cache_hit_ratio: 3
stats_total/cache_hits: 16291
stats_total/cache_miss_collisions: 25
stats_total/cache_misses: 411625
stats_total/cache_readaheads: 0

Huge increase in bypassed reads, essentially no new cached reads. This
is... basically the optimum case for bcache, and it's not caching it!

>From my reading of xfs_dir2_leaf_readbuf(), it looks like essentially
all directory reads in XFS appear to bcache as a single non-readahead
followed by a pile of readahead I/O: bcache bypasses readahead bios, so
all directory reads (or perhaps all directory reads larger than a single
block) are going to be bypassed out of hand.

This seems... suboptimal, but so does filling up the cache with
read-ahead blocks (particularly for non-metadata) that are never used.
Anyone got any ideas, 'cos I'm currently at a loss: XFS doesn't appear
to let us distinguish between "read-ahead just in case but almost
certain to be accessed" (like directory blocks) and "read ahead on the
offchance because someone did a single-block file read and what the hell
let's suck in a bunch more".

As it is, this seems to render bcache more or less useless with XFS,
since bcache's primary raison d'etre is precisely to cache seeky stuff
like metadata. :(
