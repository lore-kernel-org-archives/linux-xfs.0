Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:6972 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756621AbcJMTqb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Oct 2016 15:46:31 -0400
Date: Fri, 14 Oct 2016 06:46:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [LTP] [PATCH] m4/ltp-xfs_quota.m4: fix xfs quota check
Message-ID: <20161013194613.GP23194@dastard>
References: <1476150729-2128-1-git-send-email-yangx.jy@cn.fujitsu.com>
 <20161013141145.GA12204@rei.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161013141145.GA12204@rei.lan>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Cyril Hrubis <chrubis@suse.cz>
Cc: Xiao Yang <yangx.jy@cn.fujitsu.com>, ltp@lists.linux.it, linux-xfs@vger.kernel.org

On Thu, Oct 13, 2016 at 04:11:45PM +0200, Cyril Hrubis wrote:
> Hi!
> > Current check doesn't work since xfsprogs v4.5.0.
> > Undefined off64_t type leads to this issue, so we
> > need to define _GNU_SOURCE to make off64_t defined.
> > 
> > This has been broken by upstream xfsporgs-dev commmit
> > 
> > commit cb898f157f8410a03cf5f3400baa1df9e5eecd33
> > Author: Felix Janda <felix.janda@posteo.de>
> > Date: Fri Feb 5 08:34:06 2016 +1100
> > 
> >   linux.h: Use off64_t instead of loff_t
> 
> That kind of looks like a bug in xfs-progs, since off64_t is not exposed
> from glibc unless we enable either largefile support or define
> _GNU_SOURCE. As a matter of fact the _GNU_SOURCE enables
> _LARGEFILE64_SOURCE which then enables the typedef that exposes the
> off64_t typedef.

Which is a bug in the application build - if you are doing anything
with XFS, you need to define _LARGEFILE64_SOURCE. No ifs, buts or
maybes - it's a 64 bit filesystem with 64 bit interfaces (e.g.
ioctls) and so applications that include XFS headers to poke at XFS
filesystems need to fully support 64 bit file offsets....

> So they are depending on a type that is not defined by default but since
> the code has been part of at least three releases already we have to
> apply the workaround for it anyway.

We're only going to get stricter on this - next cycle we're removing
off64_t and replacing it with off_t, and then we'll be /explicitly/
breaking the build of any application that hasn't set up it's build
environment to define off_t as a 64 bit variable.  i.e.  specifying
_LARGEFILE64_SOURCE before the inclusion of XFS headers will be a
mandatory requirement - that's far better than ending up with clean
builds and subtly broken applications...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
