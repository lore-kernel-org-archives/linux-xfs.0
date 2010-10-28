Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9SBuhsF016045 for <xfs@oss.sgi.com>; Thu, 28 Oct 2010 06:56:43 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0C6801E87E77
	for <xfs@oss.sgi.com>; Thu, 28 Oct 2010 04:58:02 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 0VgBmdcRmHLzqmGD for
	<xfs@oss.sgi.com>; Thu, 28 Oct 2010 04:58:02 -0700 (PDT)
Date: Thu, 28 Oct 2010 07:58:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [bug, 2.6.37-current] Assertion failed:
	atomic_read(&pag->pag_ref) == 0
Message-ID: <20101028115800.GA4472@infradead.org>
References: <20101026071356.GY32255@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101026071356.GY32255@dastard>
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

On Tue, Oct 26, 2010 at 06:13:56PM +1100, Dave Chinner wrote:
> Folks,
> 
> Since themainline merge, I've been getting unmount failures during
> shutdown that look like:

I've done quite a few mainline runs, but haven't seen anything like
that.  On the other hand I see completely silent hangs in 076 once in
a while.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
