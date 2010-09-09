Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o891PRbD075625 for <xfs@oss.sgi.com>; Wed, 8 Sep 2010 20:25:28 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ACD7717C01F3
	for <xfs@oss.sgi.com>; Wed,  8 Sep 2010 18:26:12 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id wPwmSEUNp7iNFSPC for
	<xfs@oss.sgi.com>; Wed, 08 Sep 2010 18:26:12 -0700 (PDT)
Date: Wed, 8 Sep 2010 21:26:10 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: log IO completion workqueue is a high priority queue
Message-ID: <20100909012610.GA29825@infradead.org>
References: <1283936422-20160-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1283936422-20160-1-git-send-email-david@fromorbit.com>
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

On Wed, Sep 08, 2010 at 07:00:22PM +1000, Dave Chinner wrote:
> queued ahead of all data/metadata IO completions and processed before the
> data/metadata completions. Hence the log never gets stalled, and operations
> needed to clean memory can continue as quickly as possible. This avoids the
> livelock conditions and allos the system to keep running under heavy load as
> per normal.

>From a quick review of how the WQ_HIGHPRI flag is handled this look good
to me.  I'm still rather suspicious of the new workqueue code, and the
complete lack of documentation for it, though.


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
