Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3BNccud117508 for <xfs@oss.sgi.com>; Mon, 11 Apr 2011 18:38:38 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 163283C5398
	for <xfs@oss.sgi.com>; Mon, 11 Apr 2011 16:41:58 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 5DNhOCUobhmxyGnl for
	<xfs@oss.sgi.com>; Mon, 11 Apr 2011 16:41:58 -0700 (PDT)
Date: Mon, 11 Apr 2011 19:41:58 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix bmbt block allocation failures
Message-ID: <20110411234158.GB29358@infradead.org>
References: <1302489251-1512-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1302489251-1512-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Apr 11, 2011 at 12:34:11PM +1000, Dave Chinner wrote:
> http://oss.sgi.com/archives/xfs/2010-09/msg00438.html).  Firstly,
> the missing args->total was causing the initial block to be
> allocated from the freespace reserve. Secondly that the NEAR_BNO
> allocation should probably be a START_BNO allocation to allow blocks
> to be taken from a higher numbered AG.

Looking over the use of ->total, isn't the ialloc btree code also
incorrect by setting ->total to 0?

The actual change looks good to me,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
