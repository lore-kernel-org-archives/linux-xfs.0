Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB3Ax2c7011502 for <xfs@oss.sgi.com>; Wed, 3 Dec 2008 04:59:02 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1839E1B92795
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2008 02:59:01 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id DgHHAhvW3OyzAzq2 for
	<xfs@oss.sgi.com>; Wed, 03 Dec 2008 02:59:01 -0800 (PST)
Date: Wed, 3 Dec 2008 05:58:31 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 20/22] move vn_iowait / vn_iowake into xfs_aops.c
Message-ID: <20081203105831.GB19287@infradead.org>
References: <20081202160430.775774000@bombadil.infradead.org>
	<20081202160652.542003000@bombadil.infradead.org>
	<20081203031719.GQ18236@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081203031719.GQ18236@disturbed>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Dec 03, 2008 at 02:17:19PM +1100, Dave Chinner wrote:
> On Tue, Dec 02, 2008 at 11:04:50AM -0500, Christoph Hellwig wrote:
> > The whole machinery to wait on I/O completion is related to the I/O path
> > and should be there instead of in xfs_vnode.c.  Also give the functions
> > more descriptive names.
> 
> I'm not sure that "xfs_ioend_..." is the best name - it looks
> slightly weird in some of the callers' contexts. Just dropping the
> "end" out of the names makes the code read much better (i.e.
> xfs_io_wait() and xfs_io_wake()). Not particularly important,
> though, and everything else looks good.

xfs_ioend_* wasn't my first choice either.  I first did
xfs_iowait/xfs_iowake, but that clashes with the buffercache.  And
having names just different by an underscore doesn't seem good either.

Any other suggestions?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
