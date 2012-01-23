Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0NJMNGA132710 for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 13:22:23 -0600
Message-ID: <4F1DB36E.3060207@sgi.com>
Date: Mon, 23 Jan 2012 13:22:22 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [patch 04/12] xfs: cleanup xfs_log_space_wake
References: <20111212141346.986825692@bombadil.infradead.org>
	<20111212141434.065702206@bombadil.infradead.org>
In-Reply-To: <20111212141434.065702206@bombadil.infradead.org>
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

On 01/-10/63 13:59, Christoph Hellwig wrote:
> Remove the now unused opportunistic parameter, and use the the
> xlog_writeq_wake and xlog_reserveq_wake helpers now that we don't have
> to care about the opportunistic wakeups.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>

Looks good. My only concern is the way that xlog_grant_push_ail() tries 
to kick start the writing of the log. It seems to me that a combination 
of very large log requests could plug the log until the next sync. I am 
not sure if that is why the opportunistic wakeups were put in or not. If 
this is an issue, there are better ways than opportunistic wakeups in 
the unlock code (patch3 xfs: remove xfs_trans_unlocked_item).

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
