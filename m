Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p952NjDx078776 for <xfs@oss.sgi.com>; Tue, 4 Oct 2011 21:23:45 -0500
Subject: Re: [PATCH] xfs: optimize fsync on directories
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20111002142516.GA6361@infradead.org>
References: <20111002142516.GA6361@infradead.org>
Date: Tue, 4 Oct 2011 21:23:40 -0500
Message-ID: <1317781420.2270.4.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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

On Sun, 2011-10-02 at 10:25 -0400, Christoph Hellwig wrote:
> Directories are only updated transactionally, which means fsync only
> needs to flush the log the inode is currently dirty, but not bother
> with checking for dirty data, non-transaction updates, an most importanly
> doesn't have to flush disk caches except as part of a transaction commit.
> 
> While the first two optimizations can't easily be measured the latter
> actually make a difference when doing lots of fsync that do not actually
> have to commit the inode, e.g. becase an ealier fsync already pushed
> the log far enough.
> 
> The new xfs_dir_fsync is identifical to xfs_nfs_commit_metadata except
> for the prototype, but I'm not sure creating a common helper for the
> two is worth it given how simple the functions are.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
