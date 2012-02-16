Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1GJ64pt012464 for <xfs@oss.sgi.com>; Thu, 16 Feb 2012 13:06:04 -0600
Date: Thu, 16 Feb 2012 13:06:07 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch 04/12] xfs: cleanup xfs_log_space_wake
Message-ID: <20120216190607.GT7762@sgi.com>
References: <20111212141346.986825692@bombadil.infradead.org>
	<20111212141434.065702206@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111212141434.065702206@bombadil.infradead.org>
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

On Mon, Dec 12, 2011 at 09:13:51AM -0500, Christoph Hellwig wrote:
> Remove the now unused opportunistic parameter, and use the the
> xlog_writeq_wake and xlog_reserveq_wake helpers now that we don't have
> to care about the opportunistic wakeups.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.
Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
