Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2RIIMsl145685 for <xfs@oss.sgi.com>; Tue, 27 Mar 2012 13:18:22 -0500
Message-ID: <4F72046C.4090703@sgi.com>
Date: Tue, 27 Mar 2012 13:18:20 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 03/10] xfs: allow assigning the tail lsn with the AIL
	lock held
References: <20120327164400.967415009@bombadil.infradead.org>
	<20120327164644.597749707@bombadil.infradead.org>
In-Reply-To: <20120327164644.597749707@bombadil.infradead.org>
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

On 03/27/12 11:44, Christoph Hellwig wrote:
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


Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
