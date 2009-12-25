Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBPGX3d2198572 for <xfs@oss.sgi.com>; Fri, 25 Dec 2009 10:33:03 -0600
Received: from thunker.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 55348E9BBB8
	for <xfs@oss.sgi.com>; Fri, 25 Dec 2009 08:33:47 -0800 (PST)
Received: from thunker.thunk.org (THUNK.ORG [69.25.196.29]) by cuda.sgi.com
	with ESMTP id 3Aob5HveWmHH9OHV for <xfs@oss.sgi.com>;
	Fri, 25 Dec 2009 08:33:47 -0800 (PST)
Date: Fri, 25 Dec 2009 11:33:41 -0500
From: tytso@mit.edu
Subject: Re: [Jfs-discussion] benchmark results
Message-ID: <20091225163341.GE32757@thunk.org>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
	<19251.26403.762180.228181@tree.ty.sabi.co.uk>
	<20091224212756.GM21594@thunk.org>
	<alpine.DEB.2.01.0912241739160.3483@bogon.housecafe.de>
	<20091225161453.GD32757@thunk.org>
	<20091225162238.GB19303@bitmover.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091225162238.GB19303@bitmover.com>
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
To: Larry McVoy <lm@bitmover.com>, Christian Kujau <lists@nerdbynature.de>, jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, xfs@oss.sgi.com, reiserfs-devel@vger.kernel.org, Peter Grandi <pg_jf2@jf2.for.sabi.co.UK>, ext-users <ext3-users@redhat.com>, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Fri, Dec 25, 2009 at 08:22:38AM -0800, Larry McVoy wrote:
> 
> Dudes, sync() doesn't flush the fs cache, you have to unmount for that.
> Once upon a time Linux had an ioctl() to flush the fs buffers, I used
> it in lmbench.  
> 
> 	ioctl(fd, BLKFLSBUF, 0);
> 
> No idea if that is still supported, but sync() is a joke for benchmarking.

Depends on what you are trying to do (flush has multiple meanings, so
using can be ambiguous).  BLKFLSBUF will write out any dirty buffers,
*and* empty the buffer cache.  I use it when benchmarking e2fsck
optimization.  It doesn't do anything for the page cache.  If you are
measuring the time to write a file, using fsync() or sync() will
include the time to actually write the data to disk.  It won't empty
caches, though; if you are going to measure read as well as writes,
then you'll probably want to do something like "echo 3 >
/proc/sys/vm/drop-caches".

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
