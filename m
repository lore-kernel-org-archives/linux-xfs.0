Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:24562 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751251AbeA1B4d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 27 Jan 2018 20:56:33 -0500
Date: Sun, 28 Jan 2018 12:57:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFD] XFS: Subvolumes and snapshots....
Message-ID: <20180128015726.czd42ajhqfdqdtnz@destitution>
References: <20180125055144.qztiqeakw4u3pvqf@destitution>
 <CAOQ4uxiCN1yXFOs--pQhEczk8SyXX+-gk5QKF_2YO-VvvZ0sVw@mail.gmail.com>
 <20180127112833.g624srgy4qdhk6yd@destitution>
 <CAOQ4uxi-UY1Ak3Ppu7yFux9v4S3BwgbwFYLJdivvc-Vt4REdFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi-UY1Ak3Ppu7yFux9v4S3BwgbwFYLJdivvc-Vt4REdFg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Sat, Jan 27, 2018 at 05:56:53PM +0200, Amir Goldstein wrote:
> On Sat, Jan 27, 2018 at 1:28 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Sat, Jan 27, 2018 at 10:34:25AM +0200, Amir Goldstein wrote:
> >> On Thu, Jan 25, 2018 at 7:51 AM, Dave Chinner <david@fromorbit.com> wrote:
> >> >
> >> > The video from my talk at LCA 2018 yesterday about the XFS subvolume and
> >> > snapshot support I'm working on has been uploaded and can be found
> >> > here:
> >> >
> >> > https://www.youtube.com/watch?v=wG8FUvSGROw
> >> >
> >> > I don't have the code in a reviewable form yet - there's still quite
> >> > a bit of work before I get to that point, but this is a good
> >> > introduction to how all the pieces will fit together....
> >> >
> >>
> >> Very cool!
> >>
> >> Got any paper napkin design photo to share?
> >
> > No. I have some arch docs I wrote after the initial Poc on loopback
> > devices and a bunch of bash, sed, awk and xfs_io hacks....
> >
> [...]
> >
> >> I suppose all subvolumes use the host fs journal?
> >
> > No. A subvolume is a "fully functioning filesystem" and so - by
> > definition - they each have their own internal journal. The journal
> > IO remapping and COW functionality all works as seen in that demo...
> 
> So is FUA from subvolume going to be handled the same as with loop
> (fsync of entire image file) or more efficiently? for example by flushing
> only dirty pages that are already mapped?

FUA from the subvoume is mapped directly to the nuderlying device,
just like all other IO. i.e. we never need to "fsync" the underlying
file. We only need to make sure the underlying extent map for the
subvolume is flushed when necessary. This is exactly the same
constraint as the PNFS file layout offload case, handled by the
->commit_metadata() export operation. (i.e
xfs_fs_nfs_commit_metadata()).

(I did mention in the talk that the pNFS model was instructive in
the talk, because it already handles issues like this.... :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
