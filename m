Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6QFUtKF048280 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 10:30:55 -0500
Message-ID: <501162B0.10806@sgi.com>
Date: Thu, 26 Jul 2012 10:30:56 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/5] xfs: clean up xfs_inactive
References: <20120704151328.928543446@bombadil.infradead.org>
	<20120704151443.077344815@bombadil.infradead.org>
In-Reply-To: <20120704151443.077344815@bombadil.infradead.org>
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
> The code to reserve log space and join the inode to the transaction is
> common for all cases, so don't duplicate it.  Also remove the trivial
> xfs_inactive_symlink_local helper which can simply be opencode now.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> ---
>  fs/xfs/xfs_vnodeops.c |  171 ++++++++++++--------------------------------------
>  1 file changed, 43 insertions(+), 128 deletions(-)
>
As stated this patch cleans up duplicate code and removed local helper 
function.  Looks good.

Reviewed-by:	Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
