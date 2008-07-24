Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 23:54:25 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6O6sNhl014937
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 23:54:23 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5B0C1191F8BA
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 23:55:33 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id XHc4bFE3BZHC8dWJ for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 23:55:33 -0700 (PDT)
Date: Thu, 24 Jul 2008 16:22:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] kill xfs_lock_dir_and_entry
Message-ID: <20080724062200.GS6761@disturbed>
References: <20080502105803.GC17870@lst.de> <20080520063639.GC8869@lst.de> <20080627130627.GC23431@lst.de> <20080723081315.GA3863@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723081315.GA3863@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Wed, Jul 23, 2008 at 10:13:15AM +0200, Christoph Hellwig wrote:
> ping^3 - this time for real :)
> 
> On Fri, Jun 27, 2008 at 03:06:27PM +0200, Christoph Hellwig wrote:
> > ping^2
> > 
> > On Tue, May 20, 2008 at 08:36:39AM +0200, Christoph Hellwig wrote:
> > > ping?
> > > 
> > > On Fri, May 02, 2008 at 12:58:03PM +0200, Christoph Hellwig wrote:
> > > > When multiple inodes are locked in XFS it happens in order of the inode
> > > > number, with the everything but the first inode trylocked if any of
> > > > the previous inodes is in the AIL.
> > > > 
> > > > Except for the sorting of the inodes this logic is implemented in
> > > > xfs_lock_inodes, but also partially duplicated in xfs_lock_dir_and_entry
> > > > in a particularly stupid way adds a lock roundtrip if the inode ordering
> > > > is not optimal.
> > > > 
> > > > This patch adds a new helper xfs_lock_two_inodes that takes two inodes
> > > > and locks them in the most optimal way according to the above locking
> > > > protocol and uses it for all places that want to lock two inodes.
> > > > 
> > > > The only caller of xfs_lock_inodes is xfs_rename which might lock up to
> > > > four inodes.

Looks good and passes xfsqa here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
