Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6QFVAc8048335 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 10:31:10 -0500
Message-ID: <501162C2.5020506@sgi.com>
Date: Thu, 26 Jul 2012 10:31:14 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 4/5] xfs: avoid the iolock in xfs_free_eofblocks for
	evicted inodes
References: <20120704151328.928543446@bombadil.infradead.org>
	<20120704151444.136872347@bombadil.infradead.org>
In-Reply-To: <20120704151444.136872347@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 07/04/2012 10:13 AM, Christoph Hellwig wrote:
> Same rational as the last patch - these inodes are not reachable, so
> don't bother with locking.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> ---
>  fs/xfs/xfs_vnodeops.c |   24 ++++++++++--------------
>  1 file changed, 10 insertions(+), 14 deletions(-)
>
> Index: xfs/fs/xfs/xfs_vnodeops.c

Next step in removing the iolocks.  Looks good.

Reviewed-by:	Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
