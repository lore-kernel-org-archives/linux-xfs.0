Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3BNrB0M118111 for <xfs@oss.sgi.com>; Mon, 11 Apr 2011 18:53:11 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E789F1B6B82E
	for <xfs@oss.sgi.com>; Mon, 11 Apr 2011 16:56:30 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	PQC29P8HUnGigpj9 for <xfs@oss.sgi.com>;
	Mon, 11 Apr 2011 16:56:30 -0700 (PDT)
Date: Tue, 12 Apr 2011 09:56:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix bmbt block allocation failures
Message-ID: <20110411235627.GF21395@dastard>
References: <1302489251-1512-1-git-send-email-david@fromorbit.com>
	<20110411234158.GB29358@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110411234158.GB29358@infradead.org>
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

On Mon, Apr 11, 2011 at 07:41:58PM -0400, Christoph Hellwig wrote:
> On Mon, Apr 11, 2011 at 12:34:11PM +1000, Dave Chinner wrote:
> > http://oss.sgi.com/archives/xfs/2010-09/msg00438.html).  Firstly,
> > the missing args->total was causing the initial block to be
> > allocated from the freespace reserve. Secondly that the NEAR_BNO
> > allocation should probably be a START_BNO allocation to allow blocks
> > to be taken from a higher numbered AG.
> 
> Looking over the use of ->total, isn't the ialloc btree code also
> incorrect by setting ->total to 0?

It probably is - I hadn't got that far yet. I wanted to get this
tested and reviewed so test 250 would no longer assert fail
everyone's debug build....

> The actual change looks good to me,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
