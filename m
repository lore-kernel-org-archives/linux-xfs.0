Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p618q4fw053368 for <xfs@oss.sgi.com>; Fri, 1 Jul 2011 03:52:05 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DDE2645D33
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2011 01:51:34 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	9JIUVOE5omitMPiD for <xfs@oss.sgi.com>;
	Fri, 01 Jul 2011 01:51:34 -0700 (PDT)
Date: Fri, 1 Jul 2011 04:51:34 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/27] xfs: use write_cache_pages for writeback clustering
Message-ID: <20110701085134.GA30819@infradead.org>
References: <20110629140109.003209430@bombadil.infradead.org>
	<20110629140336.950805096@bombadil.infradead.org>
	<20110701022248.GM561@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110701022248.GM561@dastard>
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

> 
> This piece of logic checks is the type of buffer has changed from the
> previous buffer. This used to work just fine, but now "type" is
> local to the __xfs_vm_writepage() function, while the imap life
> span?? multiple calls to the __xfs_vm_writepage() function. Hence
> type is reinitialised to IO_OVERWRITE on every page that written,
> and so for delalloc we are invalidating the imap and looking it up
> again on every page. Traces show this sort of behaviour:

Ah crap.  I actually had it that way initially, but it got lost during
a rebase due to a minimal context change screwing most hunks of the
patch.

Thanks for tracking this down!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
