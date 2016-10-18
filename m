Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:5590 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753763AbcJRAFw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2016 20:05:52 -0400
Date: Tue, 18 Oct 2016 11:04:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [LTP] [PATCH] m4/ltp-xfs_quota.m4: fix xfs quota check
Message-ID: <20161018000439.GZ23194@dastard>
References: <1476150729-2128-1-git-send-email-yangx.jy@cn.fujitsu.com>
 <20161013141145.GA12204@rei.lan>
 <20161013194613.GP23194@dastard>
 <20161017091614.GA26999@rei.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161017091614.GA26999@rei.lan>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Cyril Hrubis <chrubis@suse.cz>
Cc: Xiao Yang <yangx.jy@cn.fujitsu.com>, ltp@lists.linux.it, linux-xfs@vger.kernel.org

On Mon, Oct 17, 2016 at 11:16:14AM +0200, Cyril Hrubis wrote:
> Hi!
> > > That kind of looks like a bug in xfs-progs, since off64_t is not exposed
> > > from glibc unless we enable either largefile support or define
> > > _GNU_SOURCE. As a matter of fact the _GNU_SOURCE enables
> > > _LARGEFILE64_SOURCE which then enables the typedef that exposes the
> > > off64_t typedef.
> > 
> > Which is a bug in the application build - if you are doing anything
> > with XFS, you need to define _LARGEFILE64_SOURCE. No ifs, buts or
> > maybes - it's a 64 bit filesystem with 64 bit interfaces (e.g.
> > ioctls) and so applications that include XFS headers to poke at XFS
> > filesystems need to fully support 64 bit file offsets....
> 
> Ok, so this was our fault.

No, not your fault - the XFS headers have never made this clear.  In
the past we've tried to hide this requirement by using
glibc-specific types and it wasn't until we changed stuff to support
C libraries other than glibc for building xfsprogs that it became
clear that we needed to be explicit about this requirement.

> Is there somewhere bit fat warning that I've missed somewhere?

This was an unintentional "first warning" that there may be bugs
lurking in 32 bit application builds. It's when the first app build
failure reports started coming that we realised there was a bigger
problem we needed to fix.  :/

> > > So they are depending on a type that is not defined by default but since
> > > the code has been part of at least three releases already we have to
> > > apply the workaround for it anyway.
> > 
> > We're only going to get stricter on this - next cycle we're removing
> > off64_t and replacing it with off_t, and then we'll be /explicitly/
> > breaking the build of any application that hasn't set up it's build
> > environment to define off_t as a 64 bit variable.  i.e.  specifying
> > _LARGEFILE64_SOURCE before the inclusion of XFS headers will be a
> > mandatory requirement - that's far better than ending up with clean
> > builds and subtly broken applications...
> 
> Ending the build with clear #error or something similar sounds much
> better than failing with undefined type to me.

Yup, that's exactly what it will do. It's part of a cleanup of
xfsprogs to simply use LFS for ensuring everything is 64 bit clean
when we build. last set of patches for this were posted here:

http://oss.sgi.com/archives/xfs/2016-08/msg00390.html

And this is the one that will break the build if off_t is not a
64 bit size:

http://oss.sgi.com/archives/xfs/2016-08/msg00402.html

I'm hoping to get this in the next xfsprogs cycle....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
