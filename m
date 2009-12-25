Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBPGLv3C197692 for <xfs@oss.sgi.com>; Fri, 25 Dec 2009 10:21:57 -0600
Received: from mail.bitmover.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DCB0D1277CF
	for <xfs@oss.sgi.com>; Fri, 25 Dec 2009 08:22:41 -0800 (PST)
Received: from mail.bitmover.com (ipcop.bitmover.com [192.132.92.15]) by
	cuda.sgi.com with ESMTP id FsOCIfh6J60c5BVv for
	<xfs@oss.sgi.com>; Fri, 25 Dec 2009 08:22:41 -0800 (PST)
Date: Fri, 25 Dec 2009 08:22:38 -0800
From: Larry McVoy <lm@bitmover.com>
Subject: Re: [Jfs-discussion] benchmark results
Message-ID: <20091225162238.GB19303@bitmover.com>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
	<19251.26403.762180.228181@tree.ty.sabi.co.uk>
	<20091224212756.GM21594@thunk.org>
	<alpine.DEB.2.01.0912241739160.3483@bogon.housecafe.de>
	<20091225161453.GD32757@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091225161453.GD32757@thunk.org>
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
To: tytso@mit.edu
Cc: jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-ext4@vger.kernel.org, Peter Grandi <pg_jf2@jf2.for.sabi.co.UK>, reiserfs-devel@vger.kernel.org, ext-users <ext3-users@redhat.com>, xfs@oss.sgi.com, linux-btrfs@vger.kernel.org

On Fri, Dec 25, 2009 at 11:14:53AM -0500, tytso@mit.edu wrote:
> On Thu, Dec 24, 2009 at 05:52:34PM -0800, Christian Kujau wrote:
> > 
> > Well, I do "sync" after each operation, so the data should be on disk, but 
> > that doesn't mean it'll clear the filesystem buffers - but this doesn't 
> > happen that often in the real world too. Also, all filesystem were tested 
> > equally (I hope), yet some filesystem perform better than another - even 
> > if all the content copied/tar'ed/removed would perfectly well fit into the 
> > machines RAM.
> 
> Did you include the "sync" in part of what you timed?  Peter was quite
> right --- the fact that the measured bandwidth in your "cp" test is
> five times faster than the disk bandwidth as measured by hdparm, and
> many file systems had exactly the same bandwidth, makes me very
> suspicious that what was being measured was primarily memory bandwidth
> --- and not very useful when trying to measure file system
> performance.

Dudes, sync() doesn't flush the fs cache, you have to unmount for that.
Once upon a time Linux had an ioctl() to flush the fs buffers, I used
it in lmbench.  

	ioctl(fd, BLKFLSBUF, 0);

No idea if that is still supported, but sync() is a joke for benchmarking.
-- 
---
Larry McVoy                lm at bitmover.com           http://www.bitkeeper.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
