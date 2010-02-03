Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o13KsP3m243862 for <xfs@oss.sgi.com>; Wed, 3 Feb 2010 14:54:25 -0600
Date: Wed, 3 Feb 2010 15:55:33 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/10] xfs: xfs_fs_write_inode() can fail to write
	inodes synchronously V2
Message-ID: <20100203205533.GB19415@infradead.org>
References: <1265153104-29680-1-git-send-email-david@fromorbit.com>
	<1265153104-29680-10-git-send-email-david@fromorbit.com>
	<20100203112753.GA19996@infradead.org>
	<20100203180706.GH5702@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100203180706.GH5702@sgi.com>
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
To: bpm@sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Feb 03, 2010 at 12:07:06PM -0600, bpm@sgi.com wrote:
> Hey Christoph,
> 
> On Wed, Feb 03, 2010 at 06:27:53AM -0500, Christoph Hellwig wrote:
> > That leaves open the NFSD case thought.  I'd prefer to have that fixed
> > if possibly.  Ben, any chance you could send your patch to use fsync
> > to the nfs list ASAP?
> 
> I'll make some time to work on it.
> 
> > I think we'd be even better off to just force
> > -o wsync and disable ->write_inode entirely for NFS, any chance you
> > could test such a patch on your setup?
> 
> Sure.  IIRC, previous tests were w/ -o wsync and write_inode switched to
> fsync passing 1 for fdatasync.  I'll try this too.

-o wsync should be very similar to using ->fsync or Dave's new
->write_inode.  What the synchronous transaction does is causing a log
force, which is exactly what fsync does in case the inode is still
pinned (except not quite as optimal, but I'll send a patch for that)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
