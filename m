Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 21 Jul 2006 11:07:50 -0700 (PDT)
Received: from smtp102.sbc.mail.mud.yahoo.com (smtp102.sbc.mail.mud.yahoo.com [68.142.198.201])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6LI7VDW011398
	for <linux-xfs@oss.sgi.com>; Fri, 21 Jul 2006 11:07:35 -0700
Date: Fri, 21 Jul 2006 11:07:07 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: stable xfs
Message-ID: <20060721180707.GB13892@tuatara.stupidest.org>
References: <20060720061527.GB18135@tuatara.stupidest.org> <1153404502.2768.50.camel@localhost.localdomain> <20060720161707.GB26748@tuatara.stupidest.org> <1153413481.2768.65.camel@localhost.localdomain> <20060720190401.GA28836@tuatara.stupidest.org> <1153441178.2768.158.camel@localhost.localdomain> <20060721032632.GA4138@tuatara.stupidest.org> <1153487431.2841.8.camel@localhost.localdomain> <20060721160709.GB12347@tuatara.stupidest.org> <1153501244.2841.50.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1153501244.2841.50.camel@localhost.localdomain>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ming Zhang <mingz@ele.uri.edu>
Cc: Peter Grandi <pg_xfs@xfs.for.sabi.co.UK>, Linux XFS <linux-xfs@oss.sgi.com>

On Fri, Jul 21, 2006 at 01:00:44PM -0400, Ming Zhang wrote:

> what u mean overlay fs over small fs? like a unionfs?

sorta not really, it's userspace libraries which create a virtual
filesystem over real filesystems with some database (bezerkely db).
it sorta evolved from an attempt to unify several filesystems spread
over cheap PCs into something that pretended to be one larger fs

> but other than fsr. there is no better way for this right?

not publicly, you could patch fsr or nag me for my patches if that
helps

> of course, preallocate is always good. but i do not have control
> over applications.

well, in some cases you could use LD_PRELOAD and influence things,  it
depends on the application and what you need from it

fwiw, most modern p2p applicaitons have terribly access patterns which
cause cause horrible fragmentation (on all fs's, not just XFS)

> sounds like a useful patch. :P will it be merged into fsr code?

no, because it's ugly and i don't think i ever decoupled it from other
changes and posted it

> what kind of assistance you mean?

[WARNING: lots of hand waving ahead, plenty of minor, but important,
details ignored]

if you wanted much smarter defragmentation semantics, it would
probably make sense to

  * bulkstat the entire volume, this will give you the inode cluster
    locations and enough information to start building a tree of where
    all the files are (XFS_IOC_FSGEOMETRY details obviously)

  * opendir/read to build a full directory tree

  * use XFS_IOC_GETBMAP & XFS_IOC_GETBMAPA to figure out which blocks
    are occupied by which files

you would now have a pretty good idea of what is using what parts of
the disk, except of course it could be constantly changing underneath
you to make things harder

also, doing this using the existing interfaces is (when i tried it)
really really painfully slow if you have a large filesystem with a lot
of small files (even when you try to optimized you accesses for
minimize seeking by sorting by inode number and submitting several
requests in parallel to try and help the elevator merge accesses)


one you have some overall picture of the disk, you can decide what you
want to move to achieve your goal, typically this would be to reduce
the fragmentation of the largest files, and this would be be
relocating some of all of those blocks to another place

if you want to allocate space in a given AG, you open/creat a
temporary file in a directory in that AG (create multiple dirs as
needed to ensure you have one or more of these), and preallocate the
space --- there you can copy the file over

we could also add ioctls to further bias XFSs allocation strategies,
like telling it to never allocate in some AGs (needed for an online
shrink if someone wanted to make such a thing) or simply bias strongly
away from some places, then add other ioctls to allow you to
specifically allocate space in those AGs so you can bias what is
allocated where

another useful ioctl would be a variation of XFS_IOC_SWAPEXT which
would swap only some extents.  there is no internal support for this
now except we do have code for XFS_IOC_UNRESVSP64 and XFS_IOC_RESVSP64
so perhaps the idea would be to swap some (but not all) blocks of a
file by creating a function that do the equivalent of 'punch a hole'
where we want to replace the blocks, and then 'allocate new blocks
given some i already have elsewhere' (however, making that all work as
one transaction might be very very difficult)

it's a lot of effort for what for many people wouldn't only have
marginal gains
