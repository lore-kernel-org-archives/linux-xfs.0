Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:35619 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726682AbeI0IZT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Sep 2018 04:25:19 -0400
Date: Thu, 27 Sep 2018 12:08:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Leaking Path in XFS's ioctl interface(missing LSM check)
Message-ID: <20180927020822.GG31060@dastard>
References: <5EF0D46A-C098-4B51-AD13-225FFCA35D4C@vt.edu>
 <20180926013329.GD31060@dastard>
 <dc3bf978-1b98-bebd-6f35-9b2795693ea7@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc3bf978-1b98-bebd-6f35-9b2795693ea7@tycho.nsa.gov>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: TongZhang <ztong@vt.edu>, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, Wenbo Shen <shenwenbosmile@gmail.com>

On Wed, Sep 26, 2018 at 09:23:03AM -0400, Stephen Smalley wrote:
> On 09/25/2018 09:33 PM, Dave Chinner wrote:
> >On Tue, Sep 25, 2018 at 08:51:50PM -0400, TongZhang wrote:
> >>Hi,
> >>
> >>I'm bringing up this issue again to let of LSM developers know the situation, and would like to know your thoughts.
> >>Several weeks ago I sent an email to the security list to discuss the issue where
> >>XFS's ioctl interface can do things like vfs_readlink without asking LSM's
> >>permission, which we think is kind of weird and this kind of operation should be
> >>audited by LSM.
> >
> >These aren't user interfaces. They are filesystem maintenance and
> >extension interfaces.  They are intended for low level filesystem
> >utilities that require complete, unrestricted access to the
> >underlying filesystem via holding CAP_SYSADMIN in the initns.
> >
> >i.e.  they are used to perform filesystem maintenance and extension
> >operations that need to be completely invisible to users from
> >userspace. e.g.  online file defragmentation (xfs_fsr), data
> >migration (e.g. HSM products), efficient backup of data (xfsdump),
> >metadata and data scrubbing, online repair, etc.
> >
> >IOWs, I really don't think these interfaces are something the LSMs
> >should be trying to intercept or audit, because they are essentially
> >internal filesystem interfaces used by trusted code and not general
> >user application facing APIs.
> 
> If they are interfaces exposed to userspace, then they should be
> mediated via LSM.  We only omit the LSM hook when the usage is
> purely kernel-internal.

/me points to the mass of diverse management ioctls across the
kernel that aren't mediated by LSM hooks.

> Security modules are often used to limit
> even "trusted" applications to least privilege and protect them from
> untrustworthy inputs, moving from binary trust notions to only
> trusting them for what they must be trusted to do.  CAP_SYS_ADMIN
> doesn't necessarily indicate that they are trusted to override any
> given MAC policy restrictions.

Applications that are tightly integrated into the filesystem to
extend it's functionality effectively operate in the same trust
space as the kernel filesystem implementation itself.  i.e. they
interact with the filesystem at levels below the DAC/MAC checks that
are performed on user filesystem accesses, and perform manipluation
of the on-disk filesystem structure that is invisible to users
accessing the filesystem.

As such, there are very few trusted applications have "massive data
loss" as a potential failure mode if an inappropriately configured
LSM is loaded into the kernel. Breaking a HSM application's access
to the filesystem unexpectedly because someone didn't set up a new
security policy correctly brings a whole new level of risk to
administrating sites that mix non-trivial storage solutions with
LSM-based security.

> Wondering why we don't perform the security_inode_readlink() call
> inside of vfs_readlink() currently.  The general pattern is that we
> do perform security_inode_*() calls inside the other vfs_*()
> helpers, so vfs_readlink() is an exception currently.

Pretty sure that was done to mitigate the risk of breaking existing
userspace applications using the handle interfaces to read links.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
