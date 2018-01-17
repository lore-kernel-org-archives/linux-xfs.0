Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:43997 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750796AbeAQAwP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Jan 2018 19:52:15 -0500
Received: by mail-oi0-f48.google.com with SMTP id t16so11938252oif.10
        for <linux-xfs@vger.kernel.org>; Tue, 16 Jan 2018 16:52:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180116075541.GO5602@magnolia>
References: <CA+0CQ21AhCGcBdNo5RY4Q=oakNQO1S_jgHU2f-BdG-fL71ZyFw@mail.gmail.com>
 <20180116075541.GO5602@magnolia>
From: Philipp Schrader <philipp@peloton-tech.com>
Date: Tue, 16 Jan 2018 16:52:14 -0800
Message-ID: <CA+0CQ21tLBLFfnn_ngY-arVzXAOyZU1XSuDu9RAjAo6VfK2PoA@mail.gmail.com>
Subject: Re: Reproducible XFS filesystem artifacts
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Austin Schuh <austin@peloton-tech.com>, Alison Chaiken <alison@peloton-tech.com>

> > I've not had much luck digging into the XFS spec to see prove that the
> > ctime is different, but I'm pretty certain. When I mount the images, I
> > can see that ctime is different:
> > $ stat -c %x,%y,%z,%n /mnt/{a,b}/log/syslog
> > 2017-12-28 11:26:53.552000096 -0800,1969-12-31 16:00:00.000000000
> > -0800,2017-12-28 11:28:50.524000060 -0800,/mnt/a/log/syslog
> > 2017-12-28 10:46:38.739999913 -0800,1969-12-31 16:00:00.000000000
> > -0800,2017-12-28 10:48:17.180000049 -0800,/mnt/b/log/syslog
> >
> > As far as I can tell, there are no mount options to null out the ctime
> > fields. (As an aside I'm curious as to the reason for this).
>
> Correct, there's (afaict) no userspace interface to change ctime, since
> it reflects the last time the inode metadata was updated by the kernel.
>
> > Is there a tool that lets me null out ctime fields on a XFS filesystem
> > image
>
> None that I know of.
>
> > Or maybe is there a library that lets me traverse the file
> > system and set the fields to zero manually?
>
> Not really, other than messing up the image with the debugger.

Which debugger are you talking about? Do you mean xfs_db? I was really
hoping to avoid that :)

>
> > Does what I'm asking make sense? I feel like I'm not the first person
> > to tackle this, but I haven't been lucky with finding anything to
> > address this.
>
> I'm not sure I understand the use case for exactly reproducible filesystem
> images (as opposed to the stuff inside said fs), can you tell us more?

For some background, these images serve as read-only root file system
images on vehicles. During the initial install or during a system
update, new images get written to the disks. This uses a process
equivalent to using dd(1).

We have two primary goals with reproducible filesystem images:

1. Caching for distributed builds.
We're in the process of moving to a distributed build system. That
includes a caching server. The build artifacts are cached so that they
can be quickly retrieved when someone else builds the same thing. To
make the caching actually work we need the artifacts to be
reproducible. In other words, each unique combination of source files
should produce a unique (but repeatable) result.
Until we can build these images in the distributed build it forces
each developer to build them on their own machine. It'd be nice to
move this into the caching infrastructure.

2. Confidence
We use the filesystem images as updates for our installs (and for
initial installs). We need the confidence that when a report from the
field comes in we can reliably re-create everything locally. If we
cannot reproduce the filesystem images, then it quickly becomes a lot
more difficult to validate that you're re-creating the same
environment locally. Having everything reproducible makes testing in
an automotive safety context a lot simpler.

I could dive into a lot more detail here, but I hope that that was a
reasonable high-level summary. The "Why does it matter?" section on
https://reproducible-builds.org/ provides some good links for more
reading.

Phil

>
> --D
