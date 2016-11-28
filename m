Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:18949 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753284AbcK1Vev (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Nov 2016 16:34:51 -0500
Date: Tue, 29 Nov 2016 08:33:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Silent skipping of file during xfsrestore
Message-ID: <20161128213350.GB28177@dastard>
References: <b6f1eb73-c038-1573-c026-c38ae8eea2f0@gmail.com>
 <20161128015956.GX28177@dastard>
 <d669a091-dd58-6809-f18c-2fc796568a1d@gmail.com>
 <20161128082116.GA28177@dastard>
 <d555ad16-5b1e-1c22-5ee2-b4f248164b06@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d555ad16-5b1e-1c22-5ee2-b4f248164b06@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Will Dormann <wdormann@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 28, 2016 at 08:17:00AM -0500, Will Dormann wrote:
> On 11/28/16 3:21 AM, Dave Chinner wrote:
> > I think you misunderstand how the inventory and dump process
> > works. The dump process first builds the inventory inode map that it
> > needs to back up, then goes and backs up what it mapped in the
> > inventory.  The filesystem can change between the inventory build
> > an dump trying to backup the file, and if the file does not match
> > the inventory for some reason (e.g. different inode generation
> > number) it will skip it. The file does not get removed from the
> > inventory, though, because that's already been written to the dump
> > file.
> 
> 
> Got it.  Thanks.   At the end of the backup, wouldn't xfsdump know what
> files were not able to be backed up, though?   In my case, I had a level
> 0 backup, and also a level 1 backup.   The problematic file wasn't
> present / able-to-be-restored in either backup set.

In many cases, yes it does. Certain types of issues end up with
inodes being placed in the "orphanage" - this happens if dump finds
open but unlinked inodes that weren't unlinked at the time the inode
map was built. The orphange updates only occur if the inode can be
read - if it's completely gone, it is simply skipped and restore
doesn't care.

Remember - xfsdump was designed to write direct to tape media - it
effectively generates a write-once stream of information, so once it
is written it can't be rewritten. It's an unfortunate side effect
of this "tape algorithm" that we see all sorts of weird behaviours
and limitations when we come across unexpected states.

> That is, if somebody does a level 0 backup, and a file isn't properly
> backed up for whatever reason, that file is flagged as "not backed up".
> That would allow it to be subsequently backed up in a
> higher-level-number backup.   Note that in my case, I tried restoring
> from the most-recent level 1 backup, the most-recent level 0 backup, and
> an older level 0 backup as well.  None were able to restore the file.

If it was supposed to be in the level 0 dump, and it wasn't, then
unless it was modified again before the level 1 dump it won't be in
that dump file, either.

> If this isn't possible, then I suspect that an xfsdump/xfsrestore of a
> (running?) system perhaps isn't as robust as I had hoped. 

It has never been 100% robust when run on a live filesystem that is
being modified as the backup is running. If you want robust, exact
point in time backups, then snapshot the filesystem and run the
backup from the snapshot. Then remove the snapshot once the backup
completes....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
