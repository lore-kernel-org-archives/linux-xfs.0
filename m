Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:14742 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750919AbeCQV2S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 17 Mar 2018 17:28:18 -0400
Date: Sun, 18 Mar 2018 08:28:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Question about XFS_MAXINUMBER
Message-ID: <20180317212814.GI7000@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhubJhspfj+x7yRkTJ4rUXyhZoF0x3kjuFyv-0=Lxrctw@mail.gmail.com>
 <CAOQ4uxh0H8mbbAZt0MEdLGRY-8Aqg2c9UFM56-KL2b90fLYCFQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Sat, Mar 17, 2018 at 09:56:19AM +0200, Amir Goldstein wrote:
> On Sat, Mar 17, 2018 at 7:40 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > On Fri, Mar 16, 2018 at 11:24 PM, Dave Chinner <david@fromorbit.com> wrote:
> >> On Fri, Mar 16, 2018 at 04:05:22PM +0200, Amir Goldstein wrote:
> >>> Hi guys,
> >>>
> >>> I am trying to get a lower bound for unused inode number MSB on
> >>> a mounted xfs super block, so I can publish it on struct super_block.
> >>
> >> Sorry, what?
> >>
> >> The inode number is owned by the filesystem - nobody should be
> >> touching it or making assumptions they can screw with it in any way.
> >>
> 
> Let me clarify with the simplest example:
> 
> With overlay of 2 layers, lower and upper on 2 different xfs fs
> assuming that stat(2) from xfs will not be using the 63 MSB:
> 
> On stat(2) of an overlay upper inode we want to return:
>   st_dev = <overlay anon bdev>
>   st_ino = <real upper st_ino>
> 
> On stat(2) of an overlay lower inode we want to return:
>   st_dev = <overlay anon bdev>
>   st_ino = <real lower st_ino> | 1 << 63
> 
> Now for ext4 this is always safe to do and we find that automatically
> due to the fact that ext4 uses the default encode_fh generic 32bit
> inode encoding.
> 
> For xfs this should also be safe, but we don't want to whitelist xfs
> by name/magic, so we want xfs to publish the max amount of bits
> exposed to user with stat(2)/getdents(3).
> 
> Recently, I became aware of an nfsd use case that also looks
> at inode->i_ino, so we may want to also be able to assume
> max_ino_bits also applies to inode->i_ino, but if you tell us to
> stay clear of inode->i_ino, then we can always use stat.st_ino.
> 
> Thanks,
> Amir.
> 

On Sat, Mar 17, 2018 at 10:24:39AM +0200, Amir Goldstein wrote:
> On Sat, Mar 17, 2018 at 10:04 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Sat, Mar 17, 2018 at 06:40:23AM +0100, Miklos Szeredi wrote:
> [...]
> >> I ask, because we've thought long and hard about what to do for
> >> multiplexing inum space in overlayfs, and found no other sane options.
> >> Ideas welcome, of course.
> >
> > Why do you need to "multiplex" the inum space? perhaps you'd do
> > better to start with a description of why you want to play games
> > with inode numbers, rather than just posting a patch to steal bits
> > from other filesytem inode number spaces....
> >
> 
> I think this patch perhaps explains best what we want to do:
> https://marc.info/?l=linux-unionfs&m=151007386219743&w=2
> 
> I had already given a simple example in an earlier response.

So, I'll quote that here:

> > > On stat(2) of an overlay upper inode we want to return:
> > >   st_dev = <overlay anon bdev>
> > >   st_ino = <real upper st_ino>
> > > 
> > > On stat(2) of an overlay lower inode we want to return:
> > >   st_dev = <overlay anon bdev>
> > >   st_ino = <real lower st_ino> | 1 << 63

This makes no sense to me - this implies the inode number changes on
copy-up, and ....

> As the the "why" question, we have several requirements for
> overlay inode numbers:
> 1. st_ino is persistent
> 2. st_ino/st_dev pair is unique in the system
> 3. st_ino is consistent with d_ino
> 4. st_ino doesn't change on copy up
> 5. st_dev is uniform across all overlay inodes

.... this means requierment #4 isn't met, even on the same
filesystem.

IOWs, if overlay has already met #4 on the same filesystem, then
there is a persistent mapping between lower and upper inodes (Req.
#1) that maps the upper inode # to the lower inode #. That has to be
overlay information, because the underlying filesystem doesn't store
it. And because the lower inode/dev is unique, then req. 2 is met,
too.

FWIW, req 5 is badly worded - st_dev is uniform across all inodes in
a single overlay filesystem, not all overlay inodes.

> With upstream overlayfs we meet all requirements above for
> the case of all underlying layers on the same fs, by using a real
> underlying inode st_ino and the overlay st_dev.

Yeah, that's what I thought. So why can't you do exactly the same
thing for different underlying filesystems? You've already got a
mapping between upper and lower inode numbers, why can't that map
across different superblocks? Why do you need special "inode number
bits" exposed to userspace to identify upper->lower inode
mappings that overlay should already have a persistent mapping
mechanism for?

> With the 'xino' patch set [1], we can meet all requirements above
> also for the case of underlying layers on different fs, by multiplpexing
> the inum space, as long as we know about unused high ino bits.

Your example makes no sense to me - I don't see how adding extra
bits to the lower inode number allows you to meet requirement #4,
not why presenting "st_ino = <real upper st_ino>" for inodes that
have been copied up iis being done because that violates requirement
#4....

> The ovl-xino branch already has the xfs patch (not yet posted) to publish
> max_ino_bits.

That has no explanation of why you need to screw with inode number
bits, either. It's all mechanism, and there's zero explanation of
what problem it solves.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
