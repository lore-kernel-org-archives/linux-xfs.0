Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:24589 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754026AbeCRXEs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Mar 2018 19:04:48 -0400
Date: Mon, 19 Mar 2018 10:02:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Question about XFS_MAXINUMBER
Message-ID: <20180318230259.GJ7000@dastard>
References: <CAOQ4uxhubJhspfj+x7yRkTJ4rUXyhZoF0x3kjuFyv-0=Lxrctw@mail.gmail.com>
 <CAOQ4uxh0H8mbbAZt0MEdLGRY-8Aqg2c9UFM56-KL2b90fLYCFQ@mail.gmail.com>
 <20180317212814.GI7000@dastard>
 <CAOQ4uxit=nHvd2C080QeM27icSFra+0Anwu8vXqs4sd=8tCCNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxit=nHvd2C080QeM27icSFra+0Anwu8vXqs4sd=8tCCNg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Sun, Mar 18, 2018 at 08:21:16AM +0200, Amir Goldstein wrote:
> On Sat, Mar 17, 2018 at 11:28 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Sat, Mar 17, 2018 at 09:56:19AM +0200, Amir Goldstein wrote:
> >> On Sat, Mar 17, 2018 at 7:40 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> >> > On Fri, Mar 16, 2018 at 11:24 PM, Dave Chinner <david@fromorbit.com> wrote:
> >> >> On Fri, Mar 16, 2018 at 04:05:22PM +0200, Amir Goldstein wrote:
> >> >>> Hi guys,
> >> >>>
> >> >>> I am trying to get a lower bound for unused inode number MSB on
> >> >>> a mounted xfs super block, so I can publish it on struct super_block.
> >> >>
> >> >> Sorry, what?
> >> >>
> >> >> The inode number is owned by the filesystem - nobody should be
> >> >> touching it or making assumptions they can screw with it in any way.
> >> >>
> >>
> >> Let me clarify with the simplest example:
> >>
> >> With overlay of 2 layers, lower and upper on 2 different xfs fs
> >> assuming that stat(2) from xfs will not be using the 63 MSB:
> >>
> >> On stat(2) of an overlay upper inode we want to return:
> >>   st_dev = <overlay anon bdev>
> >>   st_ino = <real upper st_ino>
> >>
> >> On stat(2) of an overlay lower inode we want to return:
> >>   st_dev = <overlay anon bdev>
> >>   st_ino = <real lower st_ino> | 1 << 63

[....]

> I should have mentioned that "foo" is a pure upper - a file that was created
> as upper and let's suppose the real ino of "foo" in upper fs is 10.
> And let's suppose that the real ino of "bar" on lower fs is also 10, which is
> possible when lower fs is a different fs than upper fs.

Ok, so to close the loop. The problem is that overlay has no inode
number space of it's own, nor does it have any persistent inode
number mapping scheme. Hence overlay has no way of providing users
with a consistent, unique {dev,ino #} tuple to userspace when it's
different directories lie on different filesystems.

[....]

> > across different superblocks? Why do you need special "inode number
> > bits" exposed to userspace to identify upper->lower inode
> > mappings that overlay should already have a persistent mapping
> > mechanism for?
> 
> Because real pure upper inode and lower inode can have the same
> inode number and we want to multiplex our way our of this collision.
> 
> Note that we do NOT maintain a data structure for looking up used
> lower/upper inode numbers, nor do we want to maintain a persistent
> data structure for persistent overlay inode numbers that map to
> real underlying inodes. AFAIK, aufs can use a small db for it's 'xino'
> feature. This is something that we wish to avoid.

SO instead of maintaining your own data structure to provide the
necessary guarantees, the solution is to steal bits from the
underlying filesystem inode numbers on the assumption they they will
never user them?

What happens when a user upgrades their kernel, the underlying fs
changes all it's inode numbers because it's done some virtual
mapping thing for, say, having different inode number ranges for
separate mount namespaces? And so instead of having N bits of free
inode number space before upgrade, it now has zero? How will overlay
react to this sort of change, given it could expose duplicate inode
numbers....

Quite frankly, I think this "steal bits from the underlying
filesystems" mechanism is a recipe for trouble. If you want play
these games, you get to keep all the broken bits when filesystems
change the number of available bits.

Given that overlay has a persistent inode numbering problem, why
doesn't overlay just allocate and store it's own inode numbers and
other required persistent state in an xattr? 

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
