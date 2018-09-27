Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:36495 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726914AbeI0HyB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Sep 2018 03:54:01 -0400
Date: Thu, 27 Sep 2018 11:38:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Leaking Path in XFS's ioctl interface(missing LSM check)
Message-ID: <20180927013812.GF31060@dastard>
References: <5EF0D46A-C098-4B51-AD13-225FFCA35D4C@vt.edu>
 <20180926013329.GD31060@dastard>
 <20180926192426.472360ea@alans-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180926192426.472360ea@alans-desktop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: TongZhang <ztong@vt.edu>, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, Wenbo Shen <shenwenbosmile@gmail.com>

On Wed, Sep 26, 2018 at 07:24:26PM +0100, Alan Cox wrote:
> On Wed, 26 Sep 2018 11:33:29 +1000
> Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Tue, Sep 25, 2018 at 08:51:50PM -0400, TongZhang wrote:
> > > Hi,
> > > 
> > > I'm bringing up this issue again to let of LSM developers know the situation, and would like to know your thoughts.
> > > Several weeks ago I sent an email to the security list to discuss the issue where
> > > XFS's ioctl interface can do things like vfs_readlink without asking LSM's
> > > permission, which we think is kind of weird and this kind of operation should be
> > > audited by LSM.  
> > 
> > These aren't user interfaces. They are filesystem maintenance and
> > extension interfaces.  They are intended for low level filesystem
> > utilities that require complete, unrestricted access to the
> > underlying filesystem via holding CAP_SYSADMIN in the initns.
> 
> CAP_SYS_ADMIN is meaningless in an environment using a strong LSM set up.

Sure, but there are so many CAP_SYS_ADMIN-only ioctls in the kernel
that have no LSM coverage that this is not an isolated problem that
people setting up such systems have to deal with. the LSM hooks are
already complex enough without adding hundreds more hooks to control
individual ioctl behaviour for every filesystem, device, etc.

Unless you are going to add LSM hooks to all ioctls, I don't see
much point in singling out one set of ioctls in a way that will
break existing configurations. It's just a knee jerk reaction (like
ariport security) because it doesn't meaningfully address the
problem of all the other management ioctls in the kernel being
completely unconstrainted by LSMs.

> CAP_SYS_ADMIN is also a bit weird because low level access usually
> implies you can bypass access controls so you should also check
> CAP_SYS_DAC ?

Do you mean CAP_DAC_READ_SEARCH as per the newer handle syscalls?
But that only allows bypassing directory search operations, so maybe
you mean CAP_DAC_OVERRIDE?

Regardless, this horse bolted long before those syscalls were
introduced.  The time to address this issue was when XFS was merged
into linux all those years ago, back when the apps that run in
highly secure restricted environments that use these interfaces were
being ported to linux. We can't change this now without breaking
userspace....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
