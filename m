Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:3229 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750885AbeAQGQA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jan 2018 01:16:00 -0500
Date: Wed, 17 Jan 2018 17:15:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Reproducible XFS filesystem artifacts
Message-ID: <20180117061533.GJ6304@dastard>
References: <CA+0CQ21AhCGcBdNo5RY4Q=oakNQO1S_jgHU2f-BdG-fL71ZyFw@mail.gmail.com>
 <20180116075541.GO5602@magnolia>
 <CA+0CQ21tLBLFfnn_ngY-arVzXAOyZU1XSuDu9RAjAo6VfK2PoA@mail.gmail.com>
 <CAOQ4uxgKonrPQLSaxhL5ok=NEVT9XAatTab4BsQt9tA7gNBJ2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgKonrPQLSaxhL5ok=NEVT9XAatTab4BsQt9tA7gNBJ2g@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Philipp Schrader <philipp@peloton-tech.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, Austin Schuh <austin@peloton-tech.com>, Alison Chaiken <alison@peloton-tech.com>, Theodore Tso <tytso@mit.edu>

On Wed, Jan 17, 2018 at 06:05:17AM +0200, Amir Goldstein wrote:
> On Wed, Jan 17, 2018 at 2:52 AM, Philipp Schrader
> <philipp@peloton-tech.com> wrote:
> >> > I've not had much luck digging into the XFS spec to see prove that the
> >> > ctime is different, but I'm pretty certain. When I mount the images, I
> >> > can see that ctime is different:
> >> > $ stat -c %x,%y,%z,%n /mnt/{a,b}/log/syslog
> >> > 2017-12-28 11:26:53.552000096 -0800,1969-12-31 16:00:00.000000000
> >> > -0800,2017-12-28 11:28:50.524000060 -0800,/mnt/a/log/syslog
> >> > 2017-12-28 10:46:38.739999913 -0800,1969-12-31 16:00:00.000000000
> >> > -0800,2017-12-28 10:48:17.180000049 -0800,/mnt/b/log/syslog
> >> >
> >> > As far as I can tell, there are no mount options to null out the ctime
> >> > fields. (As an aside I'm curious as to the reason for this).
> >>
> >> Correct, there's (afaict) no userspace interface to change ctime, since
> >> it reflects the last time the inode metadata was updated by the kernel.
> >>
> >> > Is there a tool that lets me null out ctime fields on a XFS filesystem
> >> > image
> >>
> >> None that I know of.
> >>
> >> > Or maybe is there a library that lets me traverse the file
> >> > system and set the fields to zero manually?
> >>
> >> Not really, other than messing up the image with the debugger.
> >
> > Which debugger are you talking about? Do you mean xfs_db? I was really
> > hoping to avoid that :)

Yup, xfs_db is the only way you can write custom timestamps in XFS
inodes in an OOB manner. But it's not scalable in any way :/

> >> > Does what I'm asking make sense? I feel like I'm not the first person
> >> > to tackle this, but I haven't been lucky with finding anything to
> >> > address this.
> >>
> >> I'm not sure I understand the use case for exactly reproducible filesystem
> >> images (as opposed to the stuff inside said fs), can you tell us more?
> >
> > For some background, these images serve as read-only root file system
> > images on vehicles. During the initial install or during a system
> > update, new images get written to the disks. This uses a process
> > equivalent to using dd(1).

[....]


> That is not to suggest that you should not use xfs. You probably
> have your reasons for it, but whatever was already done by
> others for other fs (e.g. e2image -Qa) may be the way to go
> for xfs. xfs_copy would be the first tool I would look into extending
> for your use case.

Let's make sure we're all on the same page here.

xfs_copy was written for efficient installation of XFS filesystem
images. It doesn't store or copy unused space in it's packed
filesystem image....

What xfs_copy cannot do is modify filesystem metadata. IOWs, it can't
solve the timestamp problem the reproducable build process needs
fixed - it can only be used to optimise deployment of images, and
that's not the problem that is being discussed here.

Philipp, if you need bulk modification of all inodes in the
filesystem, then the only tool we have that has the capability of
doing this in an automated fashion is xfs_repair. It wouldn't take
much modification to set all inode timestamps to a fixed timestamp
(including the hidden ones that users can't see like crtime) and
zero out other variable things like change counters.

*However*

Even with timestamp normalisation, there's still no absolute
guarantee that two filesystems produced by different builds will be
identical. The kernel can decide to write back two files in a
different order (e.g. due to differences in memory pressure on the
machine during the build), and that means they'll be allocated
differently on disk. Or there could be races with background
filesystem operations, resulting in an AG being locked when an
allocation is attempted and so the data extent is allocated in the
next available AG rather than the one local to the inode. And so on.
Even minor kernel version differences can result in the filesystem
images having different layouts.

This is not an XFS specific issue, either. All kernel filesystem are
susceptible to physical layout variance for one reason or another.
The fundamental problem is that build system /cannot control the
filesystem layout/, so even if the contents and user visible
metadata are the same the filesystem images will still not be 100%
identical on every build.

IOWs, you're chasing a goal (100% reproducable filesystem images)
that simply cannot be acheived via writing files through a
kernel-based filesystem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
