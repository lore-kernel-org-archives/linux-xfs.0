Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o73DoVrP242327 for <xfs@oss.sgi.com>; Tue, 3 Aug 2010 08:50:32 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3E94248F4AC
	for <xfs@oss.sgi.com>; Tue,  3 Aug 2010 06:50:51 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id PPy8NPUwsTphBblw for
	<xfs@oss.sgi.com>; Tue, 03 Aug 2010 06:50:51 -0700 (PDT)
Date: Tue, 3 Aug 2010 09:50:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: dummy transactions should not dirty VFS state
Message-ID: <20100803135049.GA32679@infradead.org>
References: <1280826605-3506-1-git-send-email-david@fromorbit.com>
	<20100803095518.GA27470@infradead.org>
	<20100803120728.GA26402@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100803120728.GA26402@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Aug 03, 2010 at 10:07:28PM +1000, Dave Chinner wrote:
> Yes, I noticed those things. Especially as I modified the wrong
> one in the first place and realised both need fixing and the
> duplication of code seems completely unnecessary. We should have
> only one copy of this code, not two copies that do slightly
> different things.

Yes, having one copy is much better.

> > For one
> > xfs_commit_dummy_trans doesn't actually commit a synchronous transaction
> > (or rather forces out the log) unless SYNC_WAIT is set,
> 
> I don't think that we really _need_ a non-blocking version - waiting
> for a single sync transaction in xfssyncd once every 36s is hardly
> going to kill performance.

Sounds fair, but it needs documentation in the changelog, and possibly
in the source code as well.

> > in addition
> > to that xfs_fs_log_dummy uses _xfs_trans_alloc, which doesn't get
> > blocked by the filesystem freezing.
> 
> Everything will be clean on a frozen filesystem, so all the current
> code does is block the xfssyncd until the filesytem is
> unfrozen. Given that we can still read everything on the frozen
> filesystem, inode caches can still grow and hence we still need to
> run regular reclaiming. If the xfssyncd is blocked then only memory
> pressure can free up inodes.

That's a reason not to wait.  But given the bugs we had in this area
I'd rather not blindly start the transaction here.

Instead we could check s_frozen manually to no bother even doing
the calls to write the dummy record, plus maybe an assert so that it
trips up for debug builds.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
