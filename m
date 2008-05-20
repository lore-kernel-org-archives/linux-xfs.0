Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 May 2008 01:33:17 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4K8XD2S020954
	for <xfs@oss.sgi.com>; Tue, 20 May 2008 01:33:14 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 51873170123A
	for <xfs@oss.sgi.com>; Tue, 20 May 2008 01:34:02 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id PN8Rw3XSS0SoHFYS for <xfs@oss.sgi.com>; Tue, 20 May 2008 01:34:02 -0700 (PDT)
Date: Tue, 20 May 2008 10:33:51 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] always set a/c/mtime through ->setattr
Message-ID: <20080520083351.GA14826@lst.de>
References: <20080520060838.GA6436@lst.de> <E1JyMSu-0001au-96@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JyMSu-0001au-96@pomaz-ex.szeredi.hu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@lst.de, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, Artem.Bityutskiy@nokia.com

On Tue, May 20, 2008 at 09:40:56AM +0200, Miklos Szeredi wrote:
> > Currently touch_atime and file_update_time directly update a/c/mtime
> > in the inode and just mark the inode dirty afterwards.  This is pretty
> > bad for some more complex filesystems that have various different types
> > of dirtying an inode and/or need to store the data in another place
> > for example for a buffer to be logged.
> > 
> > This patch changes touch_atime and file_update_time to not update the
> > inode directly but rather call through ->setattr into the filessystem.
> 
> Do we know what effect this will have on read/write performance?  I
> can imagine that some ->setattr() implementations are orders of
> magnitude slower than just dirtying the inode.

All major disk or in-memory filesystems except for XFS just pass down
ATTR_*TIME requests to inode_setattr which is not more than just
dirtying the inode.  NFS and CIFS set S_NOCMTIME so they're not affected
by this at all.

> This optimization is fishy.  Remember, inode->i_*time are just cached
> values, and the actual times on the (remote) filesystem itself can
> differ.  Which means that we will now optimize out a "touch" because
> we happened to have the current time cached in the inode.  Not that
> this would be a likely event, but still...
> 
> So at least this check should be made dependent on ATTR_UPDTIMES, and
> explicit time updates left alone.

Good catch.  I'll fix by either/or moving the check into ->setattr and
making it conditional on ATTR_UPDTIMES.
