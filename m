Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6DGrTxA172325 for <xfs@oss.sgi.com>; Fri, 13 Jul 2012 11:53:29 -0500
Date: Fri, 13 Jul 2012 11:59:05 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/2 v2] xfs: do not call xfs_bdstrat_cb in
	xfs_buf_iodone_callbacks
Message-ID: <20120713165905.GF29979@sgi.com>
References: <20120702100003.960640484@bombadil.infradead.org>
	<20120702100034.921366796@bombadil.infradead.org>
	<20120712230421.GE29979@sgi.com>
	<20120713061651.GA20909@infradead.org>
	<20120713062410.GA24788@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120713062410.GA24788@infradead.org>
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

On Fri, Jul 13, 2012 at 02:24:10AM -0400, Christoph Hellwig wrote:
> xfs_bdstrat_cb only adds a check for a shutdown filesystem over
> xfs_buf_iorequest, but xfs_buf_iodone_callbacks just checked for a shut down
> filesystem a little earlier.  In addition the shutdown handling in
> xfs_bdstrat_cb is not very suitable for this caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
