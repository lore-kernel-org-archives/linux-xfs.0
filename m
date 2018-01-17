Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:30941 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752144AbeAQGfA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jan 2018 01:35:00 -0500
Date: Wed, 17 Jan 2018 17:34:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Reproducible XFS filesystem artifacts
Message-ID: <20180117063454.GK6304@dastard>
References: <CA+0CQ21AhCGcBdNo5RY4Q=oakNQO1S_jgHU2f-BdG-fL71ZyFw@mail.gmail.com>
 <20180116075541.GO5602@magnolia>
 <CA+0CQ21tLBLFfnn_ngY-arVzXAOyZU1XSuDu9RAjAo6VfK2PoA@mail.gmail.com>
 <CAOQ4uxgKonrPQLSaxhL5ok=NEVT9XAatTab4BsQt9tA7gNBJ2g@mail.gmail.com>
 <20180117061533.GJ6304@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180117061533.GJ6304@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Philipp Schrader <philipp@peloton-tech.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>, Austin Schuh <austin@peloton-tech.com>, Alison Chaiken <alison@peloton-tech.com>, Theodore Tso <tytso@mit.edu>

On Wed, Jan 17, 2018 at 05:15:33PM +1100, Dave Chinner wrote:
> IOWs, you're chasing a goal (100% reproducable filesystem images)
> that simply cannot be acheived via writing files through a
> kernel-based filesystem....

That said, we do have a mechanism for populating XFS filesystems
from userspace in a manner that we may be able to make deterministic
enough for reproducable image file creation: the mkfs.xfs protofile
infrastructure. That runs from mkfs in userspace, and creates the
directory structure and files specified in the protofile. There's
nothing that runs concurrently with this, it will always run the
creation operations in the same order, and I think we could
extend it to specify a global timestamp for all inodes and solve
that problem too.

The protofile infrastructure uses the kernel allocation code which
we already know is deterministic (i.e. gives the same allocation
results for the same operations if the initial state is the same)
and so we can probably get very close to 100% reproducable
filesystem image through this mechanism.

It's need some work and extensions to provide everything that is
needed in a reliable manner, and a bunch of regression tests
added to fstests to make sure it works and keeps working. If you
want to stick with XFS as the base filesystem for your images, this
may be the best way to proceed....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
