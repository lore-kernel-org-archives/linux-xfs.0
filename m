Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55612 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750716AbdAXRIN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Jan 2017 12:08:13 -0500
Date: Tue, 24 Jan 2017 12:08:12 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v5 00/55] xfs: online scrub/repair support
Message-ID: <20170124170811.GG60234@bfoster.bfoster>
References: <148498561504.15323.8531512066874274553.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148498561504.15323.8531512066874274553.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Trimmed CC to XFS.

On Sat, Jan 21, 2017 at 12:00:15AM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> This is the fifth revision of a patchset that adds to XFS kernel support
> for online metadata scrubbing and repair.  There aren't any on-disk
> format changes.  Changes since v4 include numerous bug fixes, somewhat
> more aggressive log flushing so that on-disk metadata, and the ability
> to distinguish between metadata that's obviously corrupt and metadata
> that merely fails cross-referencing checks in the status that is sent
> back to userspace.  I have also begun using it to check all my
> development workstations, which has been useful for flushing out more
> bugs.
> 

Hi Darrick,

Sorry I haven't got to looking into this yet.. I have kind of a
logistical suggestion if I may...

Can we reduce and repost this in the smallest possible "mergeable
units?" I ask because, at least for me, this kind of huge patchset tends
to continuously get pushed down my todo list because the size of it
suggests I'm going to need to set aside a decent amount of time to grok
the whole thing, test it, etc.

We obviously lose quite a bit of (already limited) review throughput
(and expertise) without Dave around. I think this would be easier for us
to digest from a review perspective if we could do so in smaller chunks.
For example, and just going by some of the patch titles:

- Some of the patches look like they are standalone bugfixes. If so, a
  collection of those could be put into a single series, reviewed and
  merged probably fairly quickly.
- getfsmap looks like a standalone ioctl()..? That seems like something
  that could also be reviewed and merged incrementally.
- Getting into the scrub stuff, could we separate scrubbing and online
  repair into incremental series?

A nice side effect of that is we don't have to repost the entire thing
if we haven't made progress on the next particular dependency. ;)

That aside, in general I think that the whole patchbomb thing kind of
jams up the review process for the associated patches. IMO, better to
feed the list in digestable chunks such that we can try to make
continuous progress (even if that progress is slow) as opposed to trying
to get the whole thing in at once. I think the latter kind of depends on
having somebody like Dave around who can digest and review the whole
thing much more quickly. Just my .02 though.. thoughts?

Brian

> Online scrub/repair support consists of four major pieces -- first, an
> ioctl that maps physical extents to their owners; second, various
> in-kernel metadata scrubbing ioctls to examine metadata records and
> cross-reference them with other filesystem metadata; third, an in-kernel
> mechanism for rebuilding damaged metadata objects and btrees; and
> fourth, a userspace component to initiate kernel scrubbing, walk all
> inodes and the directory tree, scrub data extents, and ask the kernel to
> repair anything that is broken.
> 
> This new utility, xfs_scrub, is separate from the existing offline
> xfs_repair tool.  Scrub has three main modes of operation -- in its most
> powerful mode, it iterates all XFS metadata and asks the kernel to check
> the metadata and repair it if necessary.  The second most powerful mode
> can use certain VFS methods and XFS ioctls (BULKSTAT, GETBMAP, and
> GETFSMAP) to check as much metadata as it reasonably can from userspace.
> It cannot repair anything.  The least powerful mode uses only VFS
> functions to access as much of the directory/file/xattr graph as
> possible.  It has no mechanism to check internal metadata and also
> cannot repair anything.  This is good enough for scrubbing non-XFS
> filesystems, but the primary goal is first-class XFS support.
> 
> As usual, the first patches in this series are bug fixes for problems
> discovered while running the code through rigorous fuzz testing.
> 
> The next few patches in this series implements the GETFSMAP ioctl that
> maps a device number and physical extent either to filesystem metadata
> or to a range of file blocks.  The initial implementation uses the
> reverse-mapping B+tree to supply the mapping information, however a
> fallback implementation based on the free space btrees is also provided.
> The flexibility of having both implementations is important when it
> comes to the userspace tool -- even without the owner/offset data, we
> still have enough information to set up a read verification.  There's
> also a patch to enable xfs_scrub to query the per-AG block reservations
> so that the summary counters can be sanity-checked.
> 
> The next big chunk of patches implement in-kernel scrubbing.  This is
> implemented as a new ioctl.  Pass in a metadata type and control data
> such as an AG number or inode (when applicable); the kernel will examine
> each record in that metadata structure looking for obvious logical
> errors.  External corruption should be discoverable via the checksum
> embedded in each (v5) filesystem metadata block.  When applicable, the
> metadata record will be cross-referenced with the other metadata
> structures to look for discrepancies.  Should any errors be found, an
> error code is returned to userspace, which in the old days would require
> the administrator to take the filesystem offline and repair it.  I've
> hidden the new online scrubber behind CONFIG_XFS_DEBUG to keep it
> disabled by default.
> 
> Last comes the online *repair* functionality, which largely uses the
> redundancy between the new reverse-mapping feature introduced in 4.8 and
> the existing storage space records (bno, cnt, ino, fino, and bmap) to
> reconstruct primary metadata from the secondary, or secondary metadata
> from the primaries.  That's right, we can regrow (some) of the XFS
> metadata even if parts of the filesystem go bad!  Should the kernel
> succeed, it is not necessary to take the filesystem offline for repair.
> 
> Finally, there's a patch that uses one of the new scrub features to
> prevent mount-time deadlocks if the refcountbt is corrupt.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my github trees.  The kernel patches[1] should apply against
> 4.10-rc4.  xfsprogs[2] and xfstests[3] can be found in their usual
> places.
> 
> The patches have survived all of the new tests in [3] that try to fuzz
> every field in every data structure on disk, which has shaken out
> several bugs in the scrubber and in other parts of XFS.
> 
> This is an extraordinary way to eat your data.  Enjoy! 
> Comments and questions are, as always, welcome.
> 
> --D
> 
> [1] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=djwong-devel
> [2] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=djwong-devel
> [3] https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=djwong-devel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
