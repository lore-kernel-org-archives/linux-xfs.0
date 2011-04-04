Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p34LA5jx185506 for <xfs@oss.sgi.com>; Mon, 4 Apr 2011 16:10:05 -0500
Subject: Re: [PATCH] xfs: use proper interfaces for on-stack plugging
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110330110509.GA9507@infradead.org>
References: <20110330110509.GA9507@infradead.org>
Date: Mon, 04 Apr 2011 16:12:58 -0500
Message-ID: <1301951578.2630.77.camel@doink>
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
Cc: jaxboe@fusionio.com, xfs@oss.sgi.com

On Wed, 2011-03-30 at 07:05 -0400, Christoph Hellwig wrote:
> Add proper blk_start_plug/blk_finish_plug pairs for the two places where
> we issue buffer I/O, and remove the blk_flush_plug in xfs_buf_lock and
> xfs_buf_iowait, given that context switches already flush the per-process
> plugging lists.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
