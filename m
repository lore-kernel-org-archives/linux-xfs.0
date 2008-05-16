Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 May 2008 20:50:50 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4G3oLMo013441
	for <xfs@oss.sgi.com>; Thu, 15 May 2008 20:50:23 -0700
Date: Fri, 16 May 2008 13:51:08 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] xfs_dm_rdwr() needs to pass a vfsmount to dentry_open()
Message-ID: <20080516035108.GF155679365@sgi.com>
References: <482CE39F.9050404@sgi.com> <20080516015828.GC155679365@sgi.com> <482CEE1F.9050105@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482CEE1F.9050105@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, May 16, 2008 at 12:14:55PM +1000, Lachlan McIlroy wrote:
> David Chinner wrote:
> >On Fri, May 16, 2008 at 11:30:07AM +1000, Lachlan McIlroy wrote:
> >>There's a new check added to dentry_open():
> >>
> >>   if (!mnt) {
> >>       printk(KERN_WARNING "%s called with NULL vfsmount\n", __func__);
> >>       dump_stack();
> >>       return ERR_PTR(-EINVAL);
> >>   }
> >>
> >>We need to pass a mountpoint in the call to dentry_open() in xfs_dm_rdwr()
> >>to avoid this code.
> >>
> >>--- fs/xfs/dmapi/xfs_dm.c_1.72	2008-05-15 13:23:41.000000000 +1000
> >>+++ fs/xfs/dmapi/xfs_dm.c	2008-05-15 17:51:41.000000000 +1000
> >>@@ -52,6 +52,8 @@
> >>#include <dmapi_kern.h>
> >>#include "xfs_dm.h"
> >>
> >>+#include <linux/mount.h>
> >
> >Should be defined in fs/xfs/linux-2.6/xfs_linux.h, right?
> It's not currently in xfs_linux.h.  It's needed for mntget().  I saw that
> xfs_ioctl.c uses mntget() and pulls in linux/mount.h directly so I followed
> suit.  I can add it to xfs_linux.h if you prefer.

Typically we include linux specific headers in code outside fs/xfs/linux-2.6
via an implicit include (xfs.h pulls in linux-2.6/xfs_linux.h) to try and
keep platform specific headers out of the core code. Whether that rule applies
to dmapi is a good question - the dmapi code needs so much cleaning up
anyway I'm not sure it matters.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
