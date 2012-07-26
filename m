Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6QFUxRc048293 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 10:30:59 -0500
Message-ID: <501162B6.1050207@sgi.com>
Date: Thu, 26 Jul 2012 10:31:02 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/5] xfs: remove xfs_inactive_attrs
References: <20120704151328.928543446@bombadil.infradead.org>
	<20120704151443.421487431@bombadil.infradead.org>
In-Reply-To: <20120704151443.421487431@bombadil.infradead.org>
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
> Remove this helper as the code flow is a lot more obvious when it gets
> merged into its only caller.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> ---
>  fs/xfs/xfs_vnodeops.c |   97 ++++++++++++++++++--------------------------------
>  1 file changed, 36 insertions(+), 61 deletions(-)
>
I agree the code flows much better with this patch.  Looks good.

Reviewed-by:	Rich Johnston <rjohnston@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
