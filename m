Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p81JLkBJ035071 for <xfs@oss.sgi.com>; Thu, 1 Sep 2011 14:21:46 -0500
Subject: Re: [PATCH 01/11] xfs: remove delwri buffer handling from
	xfs_buf_iorequest
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110823082911.912827029@bombadil.infradead.org>
References: <20110823082802.335389799@bombadil.infradead.org>
	<20110823082911.912827029@bombadil.infradead.org>
Date: Thu, 1 Sep 2011 14:21:42 -0500
Message-ID: <1314904902.2903.58.camel@doink>
MIME-Version: 1.0
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
Cc: xfs@oss.sgi.com

On Tue, 2011-08-23 at 04:28 -0400, Christoph Hellwig wrote:
> We cannot ever reach xfs_buf_iorequest for a buffer with XBF_DELWRI set,
> given that all write handlers make sure that the buffer is remove from
> the delwri queue before, and we never do reads with the XBF_DELWRI flag
> set (which the code would not handle correctly anyway).
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
