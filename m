Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:42962 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbeGLGBm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Jul 2018 02:01:42 -0400
Date: Wed, 11 Jul 2018 22:53:20 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: linux-next: duplicate patches in the gfs2 and xfs trees
Message-ID: <20180712055320.GL32415@magnolia>
References: <20180712113724.413e4a3f@canb.auug.org.au>
 <CAHc6FU7jM=j6c028ycJS_NiaeOYMH3ofNeTJZxJ78iphujL0WQ@mail.gmail.com>
 <20180712144102.746cb560@canb.auug.org.au>
 <CAHc6FU6eTJvvRx3506v9f8Qo8mNZUgFqNYK6hz0N=cOYkx89Qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHc6FU6eTJvvRx3506v9f8Qo8mNZUgFqNYK6hz0N=cOYkx89Qw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Steven Whitehouse <swhiteho@redhat.com>, Bob Peterson <rpeterso@redhat.com>, David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On Thu, Jul 12, 2018 at 07:16:18AM +0200, Andreas Gruenbacher wrote:
> Hi Stephen,
> 
> On 12 July 2018 at 06:41, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Hi Andreas,
> >
> > On Thu, 12 Jul 2018 04:30:07 +0200 Andreas Gruenbacher <agruenba@redhat.com> wrote:
> >>
> >> this is what I'm seeing (git log --pretty=oneline --abbrev-commit
> >> --graph ^origin/master gfs2/for-next):
> >>
> >> * f79caf101801 (gfs2/for-next) gfs2: use iomap_readpage for blocksize
> >> == PAGE_SIZE
> >> * af58827ee500 gfs2: Use iomap for stuffed direct I/O reads
> >> *   c38e838abe42 Merge branch 'iomap-4.19-merge' into linux-gfs2/for-next
> >> |\
> >> | * 806a1477b10a (xfs/iomap-4.19-merge) iomap: add inline data support
> >> to iomap_readpage_actor
> >> | * ec181f6782d8 iomap: support direct I/O to inline data
> >> | * 09230435dffd iomap: refactor iomap_dio_actor
> >> | * c03cea42149d iomap: add initial support for writes without buffer heads
> >> | * 72b4daa24129 iomap: add an iomap-based readpage and readpages implementation
> >> * | 9ab5aa4f4e10 gfs2: fallocate_chunk: Always initialize struct iomap
> >> * | 2e2834ef1797 GFS2: Fix recovery issues for spectators
> >> * |   5db0147b887e Merge branch 'iomap-write' into linux-gfs2/for-next
> >> |\ \
> >> | * | 025d0e7f73c6 (gfs2/iomap-write) gfs2: Remove gfs2_write_{begin,end}
> >> | * | 967bcc91b044 gfs2: iomap direct I/O support
> >> | * | bcfe94139a45 gfs2: gfs2_extent_length cleanup
> >> | * | 64bc06bb32ee gfs2: iomap buffered write support
> >> | * | d505a96a3b16 gfs2: Further iomap cleanups
> >> | |/
> >> | * e184fde6f3f5 iomap: add private pointer to struct iomap
> >> | * 63899c6f8851 iomap: add a page_done callback
> >> | * 19e0c58f6552 iomap: generic inline data handling
> >> | * ebf00be37de3 iomap: complete partial direct I/O writes synchronously
> >> | * 3d7b6b21f6c5 iomap: mark newly allocated buffer heads as new
> >> | * a6d639da63ae fs: factor out a __generic_write_end helper
> >> * 3beacef8093b fs: gfs2: Adding new return type vm_fault_t
> >> * d80ff78468e4 gfs2: using posix_acl_xattr_size instead of posix_acl_to_xattr
> >> * e904f3d486f9 gfs2: Don't reject a supposedly full bitmap if we have
> >> blocks reserved
> >> * d1475c07f7ce GFS2: rgrp free blocks used incorrectly
> >> * b7eba890a228 gfs2: Eliminate redundant ip->i_rgd
> >> * 03f8c41c73da gfs2: Stop messing with ip->i_rgd in the rlist code
> >> * ee9c7f9ae3d4 gfs2: call ktime_get_coarse_real_ts64() directly
> >> * 00251a16d7f9 gfs2: Minor clarification to __gfs2_punch_hole
> >> * 9e1a9ecd13b9 gfs2: Don't withdraw under a spin lock
> >> * f85c10e24ab9 gfs2: eliminate rs_inum and reduce the size of gfs2 inodes
> >>
> >> Commit e184fde6f3f5 "iomap: add private pointer to struct iomap" is on
> >> xfs/iomap-4.19-merge. That was my initial merge from
> >> xfs/iomap-4.19-merge, but it was a fast-forward so there is no merge
> >> commit. I've then merged our iomap-write branch into for-next, with
> >> two additional commits on top. Then comes the rest of
> >> xfs/iomap-4.19-merge (that branch has moved ahead in the meantime),
> >> again with two more commits on top.
> >>
> >> There are no rebased commits, you're looking at the exact same commits.
> >
> > The problem is that commits
> >
> >   a6d639da63ae fs: factor out a __generic_write_end helper
> >
> > to
> >
> >   806a1477b10a (xfs/iomap-4.19-merge) iomap: add inline data support
> >
> > have been rebased in the xfs tree from a base of v4.18-rc1 to
> > v4.18-rc4, so that those patches now appear twice in linux-next where I
> > have merged the gfs2 tree and the xfs tree.
> 
> Ah, I see now. It's xfs/for-next that contains those rebased commits
> from xfs/iomap-4.19-merge.
> 
> > This has caused a few
> > conflicts today as there are more changes to the same files affected by
> > those commits in the xfs tree. to iomap_readpage_actor
> >
> > What should have happened is that those commits should not have been
> > rebased, so either the xfs tree needs rebuilding to use the old
> > commits, or your tree needs to be rebuilt using the new commits from
> > the xfs tree.  This is why we do not like the rebasing of published
> > trees (especially when a subset of the tree is shared with other
> > developers).
> >
> > Also, if you are going to merge (part of) another tree you need to make
> > sure that the other maintainer will not do a rebase of it (I assume
> > that this was probably talked about).
> 
> Indeed, the idea of setting up xfs/iomap-4.19-merge was to have a
> common base that xfs/for-next and gfs2/for-next could both merge from.
> Darrick, could you please fix xfs/for-next?

Ok, done, I think.  Sorry for the mess, I hadn't ever done 'shared
development branch merging into other tree' and clearly didn't get it
right. :/

--D

> Thanks a lot,
> Andreas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
