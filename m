Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2LHMNkG104779 for <xfs@oss.sgi.com>; Wed, 21 Mar 2012 12:22:23 -0500
Message-ID: <4F6A0E49.4000606@sgi.com>
Date: Wed, 21 Mar 2012 12:22:17 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/4] xfs: allow assigning the tail lsn with the AIL lock
	held
References: <20120316175541.258282540@bombadil.infradead.org>
	<20120316175636.373605151@bombadil.infradead.org>
In-Reply-To: <20120316175636.373605151@bombadil.infradead.org>
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

On 03/16/12 12:55, Christoph Hellwig wrote:
> Provide a variant of xlog_assign_tail_lsn that has the AIL lock already
> held.  By doing so we do an additional atomic_read + atomic_set under
> the lock, which comes down to two instructions.
>
> Switch xfs_trans_ail_update_bulk and xfs_trans_ail_delete_bulk to the
> new version to reduce the number of lock roundtrips, and prepare for
> a new addition that would require a third lock roundtrip in
> xfs_trans_ail_delete_bulk.  This addition is also the reason for
> slightly rearranging the conditionals and relying on xfs_log_space_wake
> for checking that the filesystem has been shut down internally.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
>
> ---
>   fs/xfs/xfs_log.c        |   31 +++++++++++++++++++++++--------
>   fs/xfs/xfs_log.h        |    1 +
>   fs/xfs/xfs_trans_ail.c  |   22 +++++++++++++++-------
>   fs/xfs/xfs_trans_priv.h |    1 +
>   4 files changed, 40 insertions(+), 15 deletions(-)
>
> Index: xfs/fs/xfs/xfs_log.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_log.c	2012-03-16 12:44:55.880363918 +0100
> +++ xfs/fs/xfs/xfs_log.c	2012-03-16 12:50:24.040370003 +0100
> @@ -915,27 +915,42 @@ xfs_log_need_covered(xfs_mount_t *mp)
>    * We may be holding the log iclog lock upon entering this routine.
>    */

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
