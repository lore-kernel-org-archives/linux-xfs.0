Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o13BQi7M225072 for <xfs@oss.sgi.com>; Wed, 3 Feb 2010 05:26:45 -0600
Date: Wed, 3 Feb 2010 06:27:53 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/10] xfs: xfs_fs_write_inode() can fail to write
	inodes synchronously V2
Message-ID: <20100203112753.GA19996@infradead.org>
References: <1265153104-29680-1-git-send-email-david@fromorbit.com>
	<1265153104-29680-10-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1265153104-29680-10-git-send-email-david@fromorbit.com>
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
Cc: bpm@sgi.com, xfs@oss.sgi.com

Still not entirely happy with this one.  The first one is that I think
the barriers in fsync are still too heavy for the normal sync use
case.  I'd be more happy with exporting the body of xfs_fsync without
the cache flushes (and a ebtter name than xfs_fsync) and use that
for write_inode.

That leaves open the NFSD case thought.  I'd prefer to have that fixed
if possibly.  Ben, any chance you could send your patch to use fsync
to the nfs list ASAP?  I think we'd be even better off to just force
-o wsync and disable ->write_inode entirely for NFS, any chance you
could test such a patch on your setup?


Besides that the patch is missing the comment from the previous
iteration why we're still doing the delwri iflush for the sync == 1
case.  I think keeping that one is important to explain the really
weird reason for it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
