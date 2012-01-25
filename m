Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0PGAhDN013989 for <xfs@oss.sgi.com>; Wed, 25 Jan 2012 10:10:44 -0600
Date: Wed, 25 Jan 2012 11:10:41 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 04/12] xfs: cleanup xfs_log_space_wake
Message-ID: <20120125161041.GB8360@infradead.org>
References: <20111212141346.986825692@bombadil.infradead.org>
	<20111212141434.065702206@bombadil.infradead.org>
	<4F1DB36E.3060207@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F1DB36E.3060207@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Jan 23, 2012 at 01:22:22PM -0600, Mark Tinguely wrote:
> On 01/-10/63 13:59, Christoph Hellwig wrote:
> >Remove the now unused opportunistic parameter, and use the the
> >xlog_writeq_wake and xlog_reserveq_wake helpers now that we don't have
> >to care about the opportunistic wakeups.
> >
> >Signed-off-by: Christoph Hellwig<hch@lst.de>
> 
> Looks good. My only concern is the way that xlog_grant_push_ail()
> tries to kick start the writing of the log. It seems to me that a
> combination of very large log requests could plug the log until the
> next sync.

How exactly?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
