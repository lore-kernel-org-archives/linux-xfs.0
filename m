Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8519829DF9
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 11:57:26 -0600 (CST)
Date: Fri, 6 Dec 2013 11:57:26 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/7] extent list locking fixes V2
Message-ID: <20131206175726.GT10553@sgi.com>
References: <20131206164819.371654241@bombadil.infradead.org>
	<20131206173729.GR1935@sgi.com>
	<20131206175444.GA25669@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131206175444.GA25669@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Dec 06, 2013 at 09:54:44AM -0800, Christoph Hellwig wrote:
> On Fri, Dec 06, 2013 at 11:37:29AM -0600, Ben Myers wrote:
> > Hey Christoph,
> > 
> > On Fri, Dec 06, 2013 at 08:48:19AM -0800, Christoph Hellwig wrote:
> > > Fixed the review feedback, and includes Bens original patch for completeness.
> > 
> > I ran your initial series overnight with xfstests... oddly I hit this:
> 
> I think I understand the problem:
> 
> uint
> xfs_ilock_map_shared(
> 	xfs_inode_t     *ip)
> {
> 	uint    lock_mode;
> 
> 	if ((ip->i_d.di_format == XFS_DINODE_FMT_BTREE) &&
> 	    ((ip->i_df.if_flags & XFS_IFEXTENTS) == 0)) {
> 	    	lock_mode = XFS_ILOCK_EXCL;
> 	} else {
> 		lock_mode = XFS_ILOCK_SHARED;
> 	}
> 
> 	xfs_ilock(ip, lock_mode);
> 	return lock_mode;
> }
> 
> This only looks at the data fork, while we'd need to use it for the
> fork we plan to operate on.  Looks like we'll need some bigger surgery
> this area.

Ah, that makes sense.  Maybe just add a flags arg?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
