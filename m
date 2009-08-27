Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7R03cRf051131 for <xfs@oss.sgi.com>; Wed, 26 Aug 2009 19:03:54 -0500
Date: Wed, 26 Aug 2009 20:04:23 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/17] vfs: Introduce new helpers for syncing after
	writing to O_SYNC file or IS_SYNC inode
Message-ID: <20090827000423.GA30076@infradead.org>
References: <1250697884-22288-1-git-send-email-jack@suse.cz>
	<1250697884-22288-8-git-send-email-jack@suse.cz>
	<20090819162638.GE6150@infradead.org>
	<20090820121531.GC16486@duck.novell.com>
	<20090820162729.GA24659@infradead.org>
	<20090826182236.GA1290@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090826182236.GA1290@infradead.org>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, linux-ntfs-dev@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>, Joel Becker <joel.becker@oracle.com>, Christoph Hellwig <hch@infradead.org>, Anton Altaparmakov <aia21@cantab.net>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Evgeniy Polyakov <zbr@ioremap.net>, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

On Wed, Aug 26, 2009 at 02:22:36PM -0400, Christoph Hellwig wrote:
> On Thu, Aug 20, 2009 at 12:27:29PM -0400, Christoph Hellwig wrote:
> > Maybe you can help brain storming, but I still can't see any way in that
> > the
> > 
> >   - write data
> >   - write inode
> >   - wait for data
> > 
> > actually is a benefit in terms of semantics (I agree that it could be
> > faster in theory, but even that is debatable with todays seek latencies
> > in disks)
> 
> Btw, another reason why our current default is actively harmful:
> 
> 	barriers
> 
> With volatile write caches we do have to flush the disk write cache in
> ->fsync, either implicitly by a metadata operation, or explicitly if
> only data changed.  Unless the filesystems waits itself for the data
> to hit the disk like XFS or btrfs will be issue the cache flush
> potentially before the data write has actually reached the disk cache.

Ok, this one failed the reality check - no matter how hard I tried
I could not reproduce that case in my test harness.  It turns out
cache flush request are quite sensibly treated as barriers by the block
layer and thus we drain the queue before issueing the cache flush.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
