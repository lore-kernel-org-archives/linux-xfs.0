Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7PIPM30216609 for <xfs@oss.sgi.com>; Tue, 25 Aug 2009 13:25:37 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8ECF71532B7A
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2009 11:26:14 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id MdHINFLvPeFGldPt for
	<xfs@oss.sgi.com>; Tue, 25 Aug 2009 11:26:14 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1Mg0ii-0001CO-61
	for xfs@oss.sgi.com; Tue, 25 Aug 2009 18:26:12 +0000
Message-Id: <20090825182134.299870049@bombadil.infradead.org>
Date: Tue, 25 Aug 2009 14:21:34 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/9] stop taking the iolock in the reclaim path
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Currently we take the iolock in the reclaim path in various places.
Taking it in the inode reclaim path means however that we can't take
it while doing memory allocations that recurse back into the filesystem,
and recently lockdep has been enhanced to find these cases and noticed
quite a few of these in XFS.

We had similar issues with the ilock, but we could get away with just
stopping to do filesystem-recursing allocation under the ilock as there
were just a few.  The iolock is however taken over larger critical sections
protection actual I/O and it's almost impossible to switch all these to
NOFS allocations.  Based on what the iolock is used for we don't actually
need it in the reclaim path, though - at this point the inode is dead
and no one has any other reference to it.  See the listing in the
first patch for a more detailed list of our current iolock holders and
why they can't contend with the reclaim path.

I would greatly appreciate some indepth-review of this to make sure I
haven't missed a big loophole..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
