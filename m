Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAL9n5Z2028157 for <xfs@oss.sgi.com>; Wed, 21 Nov 2012 03:49:06 -0600
Date: Wed, 21 Nov 2012 04:51:13 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: use b_maps[] for discontiguous buffers
Message-ID: <20121121095113.GA23339@infradead.org>
References: <20121120224120.224166649@sgi.com>
	<20121120224146.376767354@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121120224146.376767354@sgi.com>
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
Cc: xfs@oss.sgi.com

On Tue, Nov 20, 2012 at 04:41:21PM -0600, Mark Tinguely wrote:
> This patch sets all the b_bmap accesses to be b_maps[0]. b_maps[0]
> works for single and multiple segment buffers.
> 
> This fixes a bug where xfs_trans_buf_item_match() could not find a
> multi-segment buffer associated with the transaction because it was
> looking for the block number in the single segment location
> b_map.bm.bn rather than the new generic b_maps[0].bm.bn. This
> resulted in recursive buffer lock that can never be satisfied.

Should b_map be renamed to __b_map so that accesses to it are cought
more easily?

Also do hyou have a test case for the issue?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
