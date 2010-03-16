Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2G1qRUT108616 for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 20:52:27 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 409FE19E1F24
	for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 18:54:02 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	geRfIrKMDtzHgEYk for <xfs@oss.sgi.com>;
	Mon, 15 Mar 2010 18:54:02 -0700 (PDT)
Date: Tue, 16 Mar 2010 12:53:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/4] xfs_log_write cleanups and vector support
Message-ID: <20100316015359.GF12369@dastard>
References: <20100315155151.642965370@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100315155151.642965370@bombadil.infradead.org>
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

On Mon, Mar 15, 2010 at 11:51:51AM -0400, Christoph Hellwig wrote:
> As mention during the review of the first posting of the transaction
> subsystem cleanup series I really didn't like the concept of mixing
> the xfs_log_write cleanup with adding the new vector functionality.
> 
> Here's a patch series to reshuffle this work into a series that I
> feel able to follow and throw in some minimal additional cleanups.
> 
> First patch is the factoring out of helpers from xlog_write without
> functionality change, second is a re-indent of xlog_write including
> moving variable declaration to inner blocks, again without functionality
> change, third is the introduction of the log vectors, including the
> relatively small changes in xlog_write, and fourth is a small incremental
> cleanup patch.

I've had a quick look over this and it seems ok. I'll test and
review them more closely, and if they are OK I'll add them to the
trans-cleanup branch...

Thanks for doing this, Christoph.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
