Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53245 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932627AbcJQJQk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Oct 2016 05:16:40 -0400
Date: Mon, 17 Oct 2016 11:16:14 +0200
From: Cyril Hrubis <chrubis@suse.cz>
Subject: Re: [LTP] [PATCH] m4/ltp-xfs_quota.m4: fix xfs quota check
Message-ID: <20161017091614.GA26999@rei.lan>
References: <1476150729-2128-1-git-send-email-yangx.jy@cn.fujitsu.com>
 <20161013141145.GA12204@rei.lan>
 <20161013194613.GP23194@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161013194613.GP23194@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Xiao Yang <yangx.jy@cn.fujitsu.com>, ltp@lists.linux.it, linux-xfs@vger.kernel.org

Hi!
> > That kind of looks like a bug in xfs-progs, since off64_t is not exposed
> > from glibc unless we enable either largefile support or define
> > _GNU_SOURCE. As a matter of fact the _GNU_SOURCE enables
> > _LARGEFILE64_SOURCE which then enables the typedef that exposes the
> > off64_t typedef.
> 
> Which is a bug in the application build - if you are doing anything
> with XFS, you need to define _LARGEFILE64_SOURCE. No ifs, buts or
> maybes - it's a 64 bit filesystem with 64 bit interfaces (e.g.
> ioctls) and so applications that include XFS headers to poke at XFS
> filesystems need to fully support 64 bit file offsets....

Ok, so this was our fault.

Is there somewhere bit fat warning that I've missed somewhere?

> > So they are depending on a type that is not defined by default but since
> > the code has been part of at least three releases already we have to
> > apply the workaround for it anyway.
> 
> We're only going to get stricter on this - next cycle we're removing
> off64_t and replacing it with off_t, and then we'll be /explicitly/
> breaking the build of any application that hasn't set up it's build
> environment to define off_t as a 64 bit variable.  i.e.  specifying
> _LARGEFILE64_SOURCE before the inclusion of XFS headers will be a
> mandatory requirement - that's far better than ending up with clean
> builds and subtly broken applications...

Ending the build with clear #error or something similar sounds much
better than failing with undefined type to me.

-- 
Cyril Hrubis
chrubis@suse.cz
