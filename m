Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o73C7FdD238873 for <xfs@oss.sgi.com>; Tue, 3 Aug 2010 07:07:15 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5BCC21688327
	for <xfs@oss.sgi.com>; Tue,  3 Aug 2010 05:07:32 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	8xrC3ZkBc2eBn8Z9 for <xfs@oss.sgi.com>;
	Tue, 03 Aug 2010 05:07:32 -0700 (PDT)
Date: Tue, 3 Aug 2010 22:07:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: dummy transactions should not dirty VFS state
Message-ID: <20100803120728.GA26402@dastard>
References: <1280826605-3506-1-git-send-email-david@fromorbit.com>
	<20100803095518.GA27470@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100803095518.GA27470@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Aug 03, 2010 at 05:55:18AM -0400, Christoph Hellwig wrote:
> I looks good to me, but there are two subtile differences between
> xfs_commit_dummy_trans and xfs_fs_log_dummy that get lost. 

Yes, I noticed those things. Especially as I modified the wrong
one in the first place and realised both need fixing and the
duplication of code seems completely unnecessary. We should have
only one copy of this code, not two copies that do slightly
different things.

> For one
> xfs_commit_dummy_trans doesn't actually commit a synchronous transaction
> (or rather forces out the log) unless SYNC_WAIT is set,

I don't think that we really _need_ a non-blocking version - waiting
for a single sync transaction in xfssyncd once every 36s is hardly
going to kill performance.

> in addition
> to that xfs_fs_log_dummy uses _xfs_trans_alloc, which doesn't get
> blocked by the filesystem freezing.

Everything will be clean on a frozen filesystem, so all the current
code does is block the xfssyncd until the filesytem is
unfrozen. Given that we can still read everything on the frozen
filesystem, inode caches can still grow and hence we still need to
run regular reclaiming. If the xfssyncd is blocked then only memory
pressure can free up inodes.

If we want to keep all these little differences, then we still
need to kill one of the two versions. Let me know which you
prefer...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
