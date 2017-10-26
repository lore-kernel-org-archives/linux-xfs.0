Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:14480 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932185AbdJZMfx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 08:35:53 -0400
Date: Thu, 26 Oct 2017 23:35:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 0/14] xfs: Towards thin provisioning aware filesystems
Message-ID: <20171026123548.GA3666@dastard>
References: <20171026083322.20428-1-david@fromorbit.com>
 <CAOQ4uxi9K+3M95VgiPLHRr9cQC6bEzRiddKnAxEgJ3H4Ea+AoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi9K+3M95VgiPLHRr9cQC6bEzRiddKnAxEgJ3H4Ea+AoQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Oct 26, 2017 at 02:09:26PM +0300, Amir Goldstein wrote:
> On Thu, Oct 26, 2017 at 11:33 AM, Dave Chinner <david@fromorbit.com> wrote:
> > This patchset is aimed at filesystems that are installed on sparse
> > block devices, a.k.a thin provisioned devices. The aim of the
> > patchset is to bring the space management aspect of the storage
> > stack up into the filesystem rather than keeping it below the
> > filesystem where users and the filesystem have no clue they are
> > about to run out of space.
.....
> > I've smoke tested the non-thinspace code paths (running auto tests
> > on a scrub enabled kernel+userspace right now) as I haven't updated
> > the userspace code to exercise the thinp code paths yet. I know the
> > concept works, but my userspace code has an older on-disk format
> > from the prototype so it will take me a couple of days to update and
> > work out how to get fstests to integrate it reliably. So this is
> > mainly a heads-up RFC patchset....
> >
> > Comments, thoughts, flames all welcome....
> >
> 
> This proposal is very interesting outside the scope of xfs, so I hope you
> don't mind I've CC'ed fsdevel.
> 
> I am thinking how a slightly similar approach could be used to online shrink
> the physical size for filesystems that are not on thin provisioned devices:
> 
> - Set/get a geometry variable of "agsoftlimit" (better names are welcome)
>   which is <= agcount.
> - agsoftlimit < agcount means that free space of AG > agsoftlimit is zero,
>   so total disk space usage will not show this space as available user space.
> - inode and block allocators will avoid dipping into the high AG pool,
>   expect for metadata block needed for freeing high AG inodes/blocks.
> - A variant of xfs_fsr (or e4defrag for that matter) could "migrate" inodes
>   and/or blocks from high to low AGs.
> - Migrating directories is quite different than migrating files, but doable.
> - Finally, on XFS_IOC_FSGROWFSDATA, if shrinking filesystem size and
>   high AG usage counters are zero, then physical size can be shrunk
>   as down as agsoftlimit instead of reducing usable_blocks.

Yup, you've just described all the craziness that a physical shrink
requires on XFS. Lots of new user APIs, new tools to move data
around, new code to transparently migrate directories and other
metadata (like xattrs), etc.

Also, the log is placed half way through the XFS filesystem, so
unless we add code to allocate and switch to a new journal (in a
crash safe and recoverable way!) we can't shrink by more than 50%.

Also, none of the growfs code touches existing AGs - they'll have to
be scanned to determine they really are empty before they get
removed from the filesystem, and then there's the other issues like
we can't shrink to less than 2 AGs, which puts a significant minimum
shrink size on filesystems (again there's that "shrink more than 50%
requires a lot more work" problem for filesystems < 4TB).

And to do it efficiently, we really need rmap support in filesystems
so the fs can tell us what files and metadata need to be moved,
rather than having to do brute force scans to work out what needs
moving. Especially as the brute force scans can't find all the
metadata that we might need to relocate before we've emptied the
space we need to stop using.

IOWs, it's a *lot* of work, and IMO there's more work in
verification and proving that everything is crash safe, recoverable
and restartable. We've known how much work it is for years - why do
you think it hasn't been implemented? See:

http://xfs.org/index.php/Shrinking_Support

And:

http://xfs.org/index.php/Unfinished_work#The_xfs_reno_tool

And specifically follow the reference to a discussion in 2007:

https://marc.info/?l=linux-xfs&m=119131697224361&w=2

> With this, xfs can gain physical shrink support and ext4 can gain online
> (and safe) shrink support.

Yes, I estimate it'll probably take about a man-year's worth of work
to get xfs shrink to production ready from all the pieces we have
sitting around today.

> Assuming that this idea is not shot down on sight, the only implication
> I can think of w.r.t your current patches is leaving enough room in new APIs
> to accomodate this prospect functionality.

I'm not introducing any new APIs. XFS_IOC_FSGROWFSDATA already
supports shrinking and resizing/moving the log, they just aren't
implemented.

> You have already reserved 15 u64 in geometry V5 ioctl struct, so that's good.
> You have not changed XFS_IOC_FSGROWFSDATA at all, so going forward
> the ambiguity of physical shrink vs. virtual shrink could either be determined
> by heuristics

No heuristics at all. filesystems on thin devices will have a
feature bit in the superblock indicating they are thin filesystems.
If the "thinspace" bit is set, shrink is just an accounting
operation. If it's not set, then it needs to physically change the
geometry of the filesystem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
