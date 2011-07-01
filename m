Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p618xxcf053681 for <xfs@oss.sgi.com>; Fri, 1 Jul 2011 04:00:00 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 40EB9B29A4B
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2011 01:59:58 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Lw1Nzqtatncanr5Y for <xfs@oss.sgi.com>;
	Fri, 01 Jul 2011 01:59:58 -0700 (PDT)
Date: Fri, 1 Jul 2011 04:59:58 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/27] xfs: use write_cache_pages for writeback clustering
Message-ID: <20110701085958.GB30819@infradead.org>
References: <20110629140109.003209430@bombadil.infradead.org>
	<20110629140336.950805096@bombadil.infradead.org>
	<20110701022248.GM561@dastard> <20110701041851.GN561@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110701041851.GN561@dastard>
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

> xfs: writepage context needs to handle discontiguous page ranges
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> If the pages sent down by write_cache_pages to the writepage
> callback are discontiguous, we need to detect this and put each
> discontiguous page range into individual ioends. This is needed to
> ensure that the ioend accurately represents the range of the file
> that it covers so that file size updates during IO completion set
> the size correctly. Failure to take into account the discontiguous
> ranges results in files being too small when writeback patterns are
> non-sequential.

Looks good.  I still wonder why I haven't been able to hit this.
Haven't seen any 180 failure for a long time, with both 4k and 512 byte
filesystems and since yesterday 1k as well.

I'll merge this, and to avoid bisect regressions it'll have to go into
the main writepages patch.  That probaby means folding the add_to_ioend
cleanup into it as well to not make the calling convention too ugly.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
