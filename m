Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAALlZDf258360 for <xfs@oss.sgi.com>; Wed, 10 Nov 2010 15:47:35 -0600
Subject: Re: [PATCH] xfs: remove incorrect assert in xfs_vm_writepage
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20101110213911.GA11214@infradead.org>
References: <20101110213911.GA11214@infradead.org>
Date: Wed, 10 Nov 2010 15:48:47 -0600
Message-ID: <1289425727.1925.4.camel@doink>
Mime-Version: 1.0
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

On Wed, 2010-11-10 at 16:39 -0500, Christoph Hellwig wrote:
> In commit 20cb52ebd1b5ca6fa8a5d9b6b1392292f5ca8a45, titled
> "xfs: simplify xfs_vm_writepage" I added an assert that any !mapped
> and
> uptodate buffers are not dirty.  That asserts turns out to trigger a
> lot
> when running fsx on filesystems with small block sizes.  The reason
> for
> that is that the assert is simply incorrect.  !mapped and uptodate
> just mean this buffer covers a hole, and whenever we do a
> set_page_dirty
> we mark all blocks in the page dirty, no matter if they have data or
> not.  So remove the assert, and update the comment above the condition
> to match reality.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
