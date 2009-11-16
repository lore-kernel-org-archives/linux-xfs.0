Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAGB51ST123009 for <xfs@oss.sgi.com>; Mon, 16 Nov 2009 05:05:02 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 989468CD1E
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2009 03:05:23 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 4h0CkXhzGf8vmOgK for
	<xfs@oss.sgi.com>; Mon, 16 Nov 2009 03:05:23 -0800 (PST)
Date: Mon, 16 Nov 2009 06:05:23 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: improve metadata I/O merging in the elevator
Message-ID: <20091116110523.GB19835@infradead.org>
References: <20091112190930.GB32110@infradead.org>
	<20091116035019.GI9467@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091116035019.GI9467@discord.disaster>
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

On Mon, Nov 16, 2009 at 02:50:19PM +1100, Dave Chinner wrote:
> Definitely should be done, but....
> 
> It looks like the patch you posted isn't quite doing what was
> intended - async write buffers are being classified as WRITE, not
> WRITE_META. That means we get more write combining in the elevator
> (performance increase) like with WRITE_META, but don't get the
> faster dispatch (latency reduction) by using the META queue to keep
> the metadata writeback separate from the bulk data writeback.
> That may be why deadline is not showing any improvement...
> 
> FWIW, the original patch here:
> 
> http://oss.sgi.com/archives/xfs/2008-01/msg00630.html
> 
> uses WRITE_META, but it looks like you've taken bits of this
> patch:

Indeed.  I'l re-add the write-side markings and will re-bench and
re-submit.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
