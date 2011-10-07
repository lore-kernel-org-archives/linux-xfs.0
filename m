Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p97EI4C2242720 for <xfs@oss.sgi.com>; Fri, 7 Oct 2011 09:18:04 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AD8B61B6375
	for <xfs@oss.sgi.com>; Fri,  7 Oct 2011 07:18:02 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	82Zv27BvRxdQdXYO for <xfs@oss.sgi.com>;
	Fri, 07 Oct 2011 07:18:02 -0700 (PDT)
Date: Fri, 7 Oct 2011 10:17:59 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/9] xfs: clean up xfs_ioerror_alert
Message-ID: <20111007141759.GA7948@infradead.org>
References: <20111006210607.175284390@bombadil.infradead.org>
	<20111006210639.731475087@bombadil.infradead.org>
	<20111007015441.GD3159@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111007015441.GD3159@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Oct 07, 2011 at 12:54:41PM +1100, Dave Chinner wrote:
> Only thing I'm wondering about is whether is should be renamed
> xfs_buf_ioerror_alert(), now that it really is a xfs_buf specific
> function?

That probably is a better name.  There are a few other functions in the
buffer code that are misnamed like that e.g. xfs_incore and to a lesser
extent xfs_bwrite or XFS_bflush.

> Also, many of the callers could probably pass __func__ rather than a
> manually set string...

True.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
