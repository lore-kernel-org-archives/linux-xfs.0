Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2HEKUqW244373 for <xfs@oss.sgi.com>; Thu, 17 Mar 2011 09:20:41 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E12A310EE14E
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2011 07:23:15 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 3V7jPhOIbsEm655m for
	<xfs@oss.sgi.com>; Thu, 17 Mar 2011 07:23:15 -0700 (PDT)
Date: Thu, 17 Mar 2011 10:23:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: preallocation transactions do not need to be
	synchronous
Message-ID: <20110317142313.GA32673@infradead.org>
References: <1299713852-7663-1-git-send-email-david@fromorbit.com>
	<20110310073634.GA25374@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110310073634.GA25374@infradead.org>
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

On Thu, Mar 10, 2011 at 02:36:34AM -0500, Christoph Hellwig wrote:
> I had the same patch in my queue, but it turns out even that isn't
> enough for good performance when used fallocate in the fast path (e.g.
> recent Samba).  I'll send a more comprehensive optimization that
> includes this soon.
> 
> I also refactored the whole area to make the various flags more
> sensible.

Given that 2.6.38 is out now and I won't have my series ready in time
I'm fine with putting your minimal version in for now, I'll port mine
on top.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
