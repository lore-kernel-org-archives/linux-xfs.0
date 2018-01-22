Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:43288 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750830AbeAVTpN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jan 2018 14:45:13 -0500
Received: by mail-oi0-f49.google.com with SMTP id t16so6783183oif.10
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2018 11:45:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180117063454.GK6304@dastard>
References: <CA+0CQ21AhCGcBdNo5RY4Q=oakNQO1S_jgHU2f-BdG-fL71ZyFw@mail.gmail.com>
 <20180116075541.GO5602@magnolia> <CA+0CQ21tLBLFfnn_ngY-arVzXAOyZU1XSuDu9RAjAo6VfK2PoA@mail.gmail.com>
 <CAOQ4uxgKonrPQLSaxhL5ok=NEVT9XAatTab4BsQt9tA7gNBJ2g@mail.gmail.com>
 <20180117061533.GJ6304@dastard> <20180117063454.GK6304@dastard>
From: Philipp Schrader <philipp@peloton-tech.com>
Date: Mon, 22 Jan 2018 11:45:12 -0800
Message-ID: <CA+0CQ2366L-QDrTnHC2F4DbhguUuoj4GGyAMJjTZmN6G9O5a7Q@mail.gmail.com>
Subject: Re: Reproducible XFS filesystem artifacts
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Amir Goldstein <amir73il@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, Austin Schuh <austin@peloton-tech.com>, Alison Chaiken <alison@peloton-tech.com>, Theodore Tso <tytso@mit.edu>

On Tue, Jan 16, 2018 at 10:34 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Jan 17, 2018 at 05:15:33PM +1100, Dave Chinner wrote:
>> IOWs, you're chasing a goal (100% reproducable filesystem images)
>> that simply cannot be acheived via writing files through a
>> kernel-based filesystem....
>
> That said, we do have a mechanism for populating XFS filesystems
> from userspace in a manner that we may be able to make deterministic
> enough for reproducable image file creation: the mkfs.xfs protofile
> infrastructure. That runs from mkfs in userspace, and creates the
> directory structure and files specified in the protofile. There's
> nothing that runs concurrently with this, it will always run the
> creation operations in the same order, and I think we could
> extend it to specify a global timestamp for all inodes and solve
> that problem too.
>
> The protofile infrastructure uses the kernel allocation code which
> we already know is deterministic (i.e. gives the same allocation
> results for the same operations if the initial state is the same)
> and so we can probably get very close to 100% reproducable
> filesystem image through this mechanism.
>
> It's need some work and extensions to provide everything that is
> needed in a reliable manner, and a bunch of regression tests
> added to fstests to make sure it works and keeps working. If you
> want to stick with XFS as the base filesystem for your images, this
> may be the best way to proceed....

Wow, thank you very much for all that information! I'm starting to see
that I've been approaching this problem from the wrong angle.

It sounds like in the long run I should look at other filesystems more
suitable/amenable to this kind of thing.

The protofile infrastructure, however, sounds really interesting. I've
not encountered it before, but the documentation for it makes me agree
with your assessment.  I'll spend more time looking at all the
information everyone provided on this thread. It sounds like there are
a few decisions ahead of us :)

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
