Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0MMiVum118040 for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 16:44:32 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CFADDAE842
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2009 14:43:47 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id K3KwUEmplRSqkPZG for
	<xfs@oss.sgi.com>; Thu, 22 Jan 2009 14:43:47 -0800 (PST)
Date: Thu, 22 Jan 2009 17:43:47 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: spurious -ENOSPC on XFS
Message-ID: <20090122224347.GA18751@infradead.org>
References: <Pine.LNX.4.64.0901120509550.11089@hs20-bc2-1.build.redhat.com>
	<20090113214949.GN8071@disturbed>
	<Pine.LNX.4.64.0901132324070.16396@hs20-bc2-1.build.redhat.com>
	<20090118173144.GA1999@infradead.org>
	<Pine.LNX.4.64.0901201430250.4603@hs20-bc2-1.build.redhat.com>
	<20090120232422.GF10158@disturbed>
	<20090122205913.GA30859@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090122205913.GA30859@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Mikulas Patocka <mpatocka@redhat.com>, Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 03:59:13PM -0500, Christoph Hellwig wrote:
> On Wed, Jan 21, 2009 at 10:24:22AM +1100, Dave Chinner wrote:
> > Right, so you need to use internal xfs sync functions that don't
> > have these problems. That is:
> > 
> > 	error = xfs_sync_inodes(ip->i_mount, SYNC_DELWRI|SYNC_WAIT);
> > 
> > will do a blocking flush of all the inodes without deadlocks occurring.
> > Then you can remove the 500ms wait.
> 
> I've given this a try with Eric's testcase from #724 in the oss bugzilla,
> but it's not enough yet.  I thinks that's because SYNC_WAIT is rather
> meaningless for data writeout, and we need SYNC_IOWAIT instead.  The
> patch below gets the testcase working for me:

Actually I still see failures happing sometimes.  I guess tha'ts because
our flush is still asynchronous due to the schedule_work..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
