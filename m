Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 17 Oct 2007 21:17:56 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9I4Hkgw004914
	for <xfs@oss.sgi.com>; Wed, 17 Oct 2007 21:17:47 -0700
Date: Thu, 18 Oct 2007 14:17:36 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] flush inode when changing atime.
Message-ID: <20071018041736.GA66820511@sgi.com>
References: <200710170456.AA06101@TNESG9305.wm.jp.nec.com> <20071017090844.GZ995458@sgi.com> <4716D891.1060108@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4716D891.1060108@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: David Chinner <dgc@sgi.com>, Utako Kusaka <u-kusaka@wm.jp.nec.com>, xfs@oss.sgi.com

On Thu, Oct 18, 2007 at 01:52:49PM +1000, Lachlan McIlroy wrote:
> David Chinner wrote:
> >On Wed, Oct 17, 2007 at 01:56:00PM +0900, Utako Kusaka wrote:
> >>Hi,
> >>
> >>The atime is changed for reading but it returns to a previous value
> >>after unmount. i_update_core is still off after reading a file using
> >>read(), readdir() and readlink(). So an inode isn't flushed to disk.
> >
> >I think this was done by design - Christoph? I can't remember exactly
> >as it was more than two years ago this change was made. It is effectively
> >equivalent to using the relatime mount option.
> >
> >The question is whether we want to change the default behaviour or
> >whether we need to supply an "atimeisatime" mount option for those
> >that really need atime to be updated on every access.
> >
> If we change it back then will anything that scans the filesystem cause
> inodes to be dirtied and create a lot of inode flush traffic that we
> don't currently have?

Right. And given that it's taken over 2 years for anyone to notice
that atime only get updated when a file is otherwise dirtied....

> >If we are going to put these back in, then they should be
> >calls to xfs_ichgtime_fast() so that we know what the reason
> >for marking the core dirty is.
> 
> xfs_ichgtime_fast() will also dirty the linux inode so that sync
> will push out the change.

The VFS already calls filp_accessed, which marks the linux inode
dirty. We're telling sync that the inode really isn't dirty when
it tries to flush it, so it's not going to disk....

As Christoph pointed out last night to me the problem really is that
VFS atime updates don't have a callback into the filesystem(*) so if
we want to write back atime we've basically got to duplicate VFS
infrastructure. 

(*) i.e. call ->setattr to set the atime.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
