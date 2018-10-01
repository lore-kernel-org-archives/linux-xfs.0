Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:53182 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725266AbeJAWXh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Oct 2018 18:23:37 -0400
Date: Mon, 1 Oct 2018 08:44:59 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: Leaking Path in XFS's ioctl interface(missing LSM check)
Message-ID: <20181001154459.GB5872@magnolia>
References: <5EF0D46A-C098-4B51-AD13-225FFCA35D4C@vt.edu>
 <20180926013329.GD31060@dastard>
 <20180926192426.472360ea@alans-desktop>
 <20180927013812.GF31060@dastard>
 <20180930151652.6975610c@alans-desktop>
 <20181001002521.GM31060@dastard>
 <20181001160442.47c798bc@alans-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181001160442.47c798bc@alans-desktop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, TongZhang <ztong@vt.edu>, linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, Wenbo Shen <shenwenbosmile@gmail.com>

On Mon, Oct 01, 2018 at 04:04:42PM +0100, Alan Cox wrote:
> >         /* only root can play with this */
> >         if (!capable(CAP_SYS_ADMIN))
> >                 return -EACCES;
> > 
> > Think about it - if DM control ioctls only require CAP_SYS_ADMIN,
> > then if have that cap you can use DM to remap any block in a block
> > device to any other block. You don't need to the filesystem to move
> > stuff around, it can be moved around without the filesystem knowing
> > anything about it.
> 
> Yes - I am not surprised the XFS is not the only problem area. The fact
> XFS also isn't going via the security hooks so security hooks can fix it
> just makes it worse.
> 
> > > That's what people said about setuid shell scripts.  
> > 
> > Completely different. setuid shell scripts got abused as a hack for
> > the lazy to avoid setting up permissions properly and hence were
> > easily exploited.
> 
> Sounds to me like an accurate description of the current capabilities
> mess in the kernel (and not just XFS and not just file systems)
> 
> > Systems restricted by LSMs to the point where CAP_SYS_ADMIN is not
> > trusted have exactly the same issues. i.e. there's nobody trusted by
> > the kernel to administer the storage stack, and nobody has defined a
> > workable security model that can prevent untrusted users from
> > violating the existing storage trust model....
> 
> With a proper set of LSM checks you can lock the filesystem management
> and enforcement to a particular set of objects.

What would a proper set look like?  I /thought/ CAP_SYS_ADMIN was an
(admittedly overly general) way to do that, but evidently that view is
not considered correct.

Looking at include/linux/security.h, I don't see any hooks that seem
like an obvious fit for a lot of the XFS ioctls.  Do we need to add
some?  How do we do that?

Just looking at XFS, we let CAP_SYS_ADMIN processes do things like...

- Change the size of the filesystem
- Discard all post-EOF speculative preallocations
- Manage reserved block pools (which help us avoid ENOSPC)
- Query the filesystem for detailed space usage information
- Issue DISCARDs on unused space

- Set a new volume label
- Check and repair metadata

- Inject errors for testing
- Emergency shutdowns of the FS

- Bulk stat() of inodes
- Deal with files (open, read xattrs, read link targets) via file handles
- Read system xattrs

Can we create the necessary LSM hooks to check all of those things?  I
could see the following new hooks:

* Query filesystem space information
* Manage filesystem space information
* Set new filesystem label/uuid
* Run metadata integrity operations
* Access testing / debugging hooks
* Reading filesystem internal metadata
* Picking files by handle instead of path

I imagine block devices probably need a few explicit hooks too:

* Raw reads
* Raw writes
* Reconfigure block device

If we /did/ replace CAP_SYS_ADMIN checking with a pile of LSM hooks, how
do we make sure that we (XFS) avoid breaking existing XFS tools?  I
guess the default compatibility handler for all of those new hooks would
be "return capable(CAP_SYS_ADMIN) ? 0 : -EPERM;" and then other LSMs
could restrict that further if so configured.

Seriously, I don't know that much about how LSMs actually perform
security checks -- it looks like a number of them can be active
simultaneously, and we just call each of them in a chain until one of
them denies permission or we run out of LSMs and allow it?

FWIW I didn't have a particular security or threat model in mind when I
made the above list; all I did was break up the existing CAP_SYS_ADMIN
into rough functional areas.  Maybe it makes sense, but maybe I'm
rambling. :)

--D

> You can build that model where for example only an administrative
> login from a trusted console may launch processes to do that
> management.
> 
> Or you could - if things were not going around the LSM hooks.
> 
> Alan
