Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o24DnMXx171013 for <xfs@oss.sgi.com>; Thu, 4 Mar 2010 07:49:22 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2A83D21837B
	for <xfs@oss.sgi.com>; Thu,  4 Mar 2010 05:50:51 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ChxOjGxKFNFLT663 for
	<xfs@oss.sgi.com>; Thu, 04 Mar 2010 05:50:51 -0800 (PST)
Date: Thu, 4 Mar 2010 08:50:50 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfs: check for more work before sleeping in xfssyncd
Message-ID: <20100304135050.GA31753@infradead.org>
References: <1267667185-7736-1-git-send-email-david@fromorbit.com>
	<1267667185-7736-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1267667185-7736-2-git-send-email-david@fromorbit.com>
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

On Thu, Mar 04, 2010 at 12:46:23PM +1100, Dave Chinner wrote:
> xfssyncd processes a queue of work by detaching the queue and
> then iterating over all the work items. It then sleeps for a
> time period or until new work comes in. If new work is queued
> while xfssyncd is actively processing the detached work queue,
> it will not process that new work until after a sleep timeout
> or the next work event queued wakes it.
> 
> Fix this by checking the work queue again before going to sleep.

Looks good, as does the list_splice cleanup not mentioned in the
changelog.  But I really wonder if we shouldn't just call the
flushing routine directly instead of going through xfssyncd.

The xfssyncd queueing infrastructure is quite a lot of hairy code
just to save a bit of stack space in two places rather high
up in the callchain.


Signed-off-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
