Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Sep 2007 08:34:08 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8JFXbuw030965
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 08:33:41 -0700
Date: Wed, 19 Sep 2007 13:04:38 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/4] simplify xfs_vn_getattr
Message-ID: <20070919110438.GB3703@lst.de>
References: <20070914162757.GD7110@lst.de> <46F08F98.9070102@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F08F98.9070102@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Wed, Sep 19, 2007 at 12:55:20PM +1000, Lachlan McIlroy wrote:
> Why do we copy the atime from the inode and not the xfs_inode?
> 
> I think I see what's the deal here - the atime in the inode is
> the authoritative atime.  It gets updated from various places and
> we synchronise it to the xfs inode before flushing the xfs inode
> to disk.  This means we shouldn't be using the atime in the
> xfs_inode because it will be stale - is this correct?

Yes.   atime is updated by the vfs without callouts to the filesystem
in various places unfortunately.
