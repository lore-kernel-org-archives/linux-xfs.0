Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 23 Sep 2007 00:58:08 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8N7vxQ3017177
	for <xfs@oss.sgi.com>; Sun, 23 Sep 2007 00:58:03 -0700
Date: Sun, 23 Sep 2007 17:57:56 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 4 of 4] Restore ihashsize mount option as deprecated
Message-ID: <20070923075756.GP995458@sgi.com>
References: <20070809114548.GG12413810@sgi.com> <46F4390A.5070407@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F4390A.5070407@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Sep 21, 2007 at 04:35:06PM -0500, Eric Sandeen wrote:
> David Chinner wrote:
> 
> > The ihashsize option should remain so that filesystems with
> > this set don't fail to mount. Ignore the mount option value
> > and issue a deprecation warning to syslog.
> >
> > Update the ihashsize mount option documentation to indicate this
> > behaviour.  Update the ikeep/noikeep mount option documentation
> > while we are there.
> >
> >   
> Hm, but shouldn't some of these mount struct items go too, now?

Yes. I thought I killed them - must have missed them in some
of the patch juggling I had to do at one point.

> (I may go looking for more unused struct members for fun if I have
> time...)
> 
> -------------
> 
> Remove unused xfs_mount and xfs_mount_args structure members
> post radix-tree conversion.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Looks ok to me...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
