Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB8LaHdg165326 for <xfs@oss.sgi.com>; Thu, 8 Dec 2011 15:36:17 -0600
Date: Thu, 8 Dec 2011 15:36:43 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch 05/19] xfs: make sure to really flush all dquots in
	xfs_qm_quotacheck
Message-ID: <20111208213643.GV29840@sgi.com>
References: <20111206215806.844405397@bombadil.infradead.org>
	<20111206215853.434529389@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111206215853.434529389@bombadil.infradead.org>
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

On Tue, Dec 06, 2011 at 04:58:11PM -0500, Christoph Hellwig wrote:
> Make sure we do not skip any dquots when flushing them out after a
> quotacheck to make sure that we will never have any dirty dquots on a
> live filesystem.  At this point no dquot should be pinnable, but lets
> be pedantic about it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Ben Myers <bpm@sgi.com>
 
> ---
>  fs/xfs/xfs_qm.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: xfs/fs/xfs/xfs_qm.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_qm.c	2011-11-25 11:45:32.672075575 +0100
> +++ xfs/fs/xfs/xfs_qm.c	2011-11-25 11:45:35.875391556 +0100
> @@ -1661,7 +1661,7 @@ xfs_qm_quotacheck(
>  	 * successfully.
>  	 */
>  	if (!error)
> -		error = xfs_qm_dqflush_all(mp, SYNC_TRYLOCK);
> +		error = xfs_qm_dqflush_all(mp, 0);

It's hard to know what 0 means here, but I also see what's coming up in
your series.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
