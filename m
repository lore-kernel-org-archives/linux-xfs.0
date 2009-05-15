Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4FHLFaY048391 for <xfs@oss.sgi.com>; Fri, 15 May 2009 12:21:15 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8DFE5FB547D
	for <xfs@oss.sgi.com>; Fri, 15 May 2009 10:26:15 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 7Np2527BXDFqtKbZ for
	<xfs@oss.sgi.com>; Fri, 15 May 2009 10:26:15 -0700 (PDT)
Date: Fri, 15 May 2009 13:21:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/7] xfs: split inode data writeback from
	xfs_sync_inodes_ag
Message-ID: <20090515172122.GB14804@infradead.org>
References: <20090514171233.942489000@bombadil.infradead.org>
	<20090514171558.014747000@bombadil.infradead.org>
	<921ca19c0905142149m68c9717cg83db37c468769c4d@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <921ca19c0905142149m68c9717cg83db37c468769c4d@mail.gmail.com>
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
To: Sujit Karataparambil <sjt.kar@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, May 15, 2009 at 10:19:11AM +0530, Sujit Karataparambil wrote:
>  should not there be an.
> 
>  error = xfs_flush_pages(ip, 0, -1, (flags & SYNC_WAIT) ?
>                        0 : XFS_B_ASYNC, FI_NONE);
> 
> for the out_wait. This will ensure flush while the xfs_ioend_wait is being
> waited for. Would this be an better way to flush the data than waiting for
> the inode to be flushed during power off or scheduler cycles.
> Would this be an performance hit.

For now I don't want to change behaviour here.    It only matters for
the SYNC_TRYLOCK case which is used for delalloc flushing on ENOSPC, so
it's not too important.

That beeing said I don't really like the current implementation where we
have a SYNC_WAIT that waits for completion of data I/O and need a
separate SYNC_IOWAIT that waits for the after data I/O metadata
transaction completions.  I think we would be better unifying the two,
especially given the current callers:

fs/xfs/linux-2.6/xfs_quotaops.c:        return -xfs_sync_data(mp, 0);
fs/xfs/linux-2.6/xfs_super.c:           xfs_sync_data(mp, 0);
fs/xfs/linux-2.6/xfs_sync.c:    xfs_sync_data(mp, 0);
fs/xfs/linux-2.6/xfs_sync.c:    xfs_sync_data(mp, SYNC_WAIT|SYNC_IOWAIT);
fs/xfs/linux-2.6/xfs_sync.c:    xfs_sync_data(mp, SYNC_TRYLOCK);
fs/xfs/linux-2.6/xfs_sync.c:    xfs_sync_data(mp, SYNC_TRYLOCK | SYNC_IOWAIT);

So in most cases we do a purely asynchronous writeout, we have one case
that does a full synchronous writeout (SYNC_WAIT|SYNC_IOWAIT) and we
have the two ENOSPC flushing cases doing SYNC_TRYLOCK + async writeout
and SYNC_TRYLOCK + IOWAIT.  I don't really see any reason to only do the
IOWAIT here and will try to unify the two flags at some point.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
