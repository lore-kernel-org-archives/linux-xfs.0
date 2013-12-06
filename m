Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DFFC129DF9
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 11:59:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C77A68F8052
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 09:59:25 -0800 (PST)
Date: Fri, 6 Dec 2013 09:59:24 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/7] extent list locking fixes V2
Message-ID: <20131206175924.GA31131@infradead.org>
References: <20131206164819.371654241@bombadil.infradead.org>
	<20131206173729.GR1935@sgi.com>
	<20131206175444.GA25669@infradead.org>
	<20131206175726.GT10553@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131206175726.GT10553@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Dec 06, 2013 at 11:57:26AM -0600, Ben Myers wrote:
> > uint
> > xfs_ilock_map_shared(
> > 	xfs_inode_t     *ip)
> > {
> > 	uint    lock_mode;
> > 
> > 	if ((ip->i_d.di_format == XFS_DINODE_FMT_BTREE) &&
> > 	    ((ip->i_df.if_flags & XFS_IFEXTENTS) == 0)) {
> > 	    	lock_mode = XFS_ILOCK_EXCL;
> > 	} else {
> > 		lock_mode = XFS_ILOCK_SHARED;
> > 	}
> > 
> > 	xfs_ilock(ip, lock_mode);
> > 	return lock_mode;
> > }
> > 
> > This only looks at the data fork, while we'd need to use it for the
> > fork we plan to operate on.  Looks like we'll need some bigger surgery
> > this area.
> 
> Ah, that makes sense.  Maybe just add a flags arg?

My plan was to replace the helper with two different ones that just
return the flag value, and the use ilock on the return value.  I'll
have to see if there's enough places where we could lock for either
for that adding a variant that takes an "int whichfork" argument would
make sense.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
