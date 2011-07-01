Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p619KShY055038 for <xfs@oss.sgi.com>; Fri, 1 Jul 2011 04:20:29 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D4DEA176761C
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2011 02:20:26 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	BDDvUY6Q6NBKM3nu for <xfs@oss.sgi.com>;
	Fri, 01 Jul 2011 02:20:26 -0700 (PDT)
Date: Fri, 1 Jul 2011 19:20:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/27] xfs: use write_cache_pages for writeback clustering
Message-ID: <20110701092021.GP561@dastard>
References: <20110629140109.003209430@bombadil.infradead.org>
	<20110629140336.950805096@bombadil.infradead.org>
	<20110701022248.GM561@dastard> <20110701041851.GN561@dastard>
	<20110701085958.GB30819@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110701085958.GB30819@infradead.org>
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

On Fri, Jul 01, 2011 at 04:59:58AM -0400, Christoph Hellwig wrote:
> > xfs: writepage context needs to handle discontiguous page ranges
> > 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > If the pages sent down by write_cache_pages to the writepage
> > callback are discontiguous, we need to detect this and put each
> > discontiguous page range into individual ioends. This is needed to
> > ensure that the ioend accurately represents the range of the file
> > that it covers so that file size updates during IO completion set
> > the size correctly. Failure to take into account the discontiguous
> > ranges results in files being too small when writeback patterns are
> > non-sequential.
> 
> Looks good.  I still wonder why I haven't been able to hit this.
> Haven't seen any 180 failure for a long time, with both 4k and 512 byte
> filesystems and since yesterday 1k as well.

It requires the test to run the VM out of RAM and then force enough
memory pressure for kswapd to start writeback from the LRU. The
reproducer I have is a 1p, 1GB RAM VM with it's disk image on a
100MB/s HW RAID1 w/ 512MB BBWC disk subsystem.

When kswapd starts doing writeback from the LRU, the iops rate goes
through the roof (from ~300iops @~320k/io to ~7000iops @4k/io) and
throughput drops from 100MB/s to ~30MB/s. BBWC is the only reason
the IOPS stays as high as it does - maybe that is why I saw this and
you haven't.

As it is, the kswapd writeback behaviour is utterly atrocious and,
ultimately, quite easy to provoke. I wish the MM folk would fix that
goddamn problem already - we've only been complaining about it for
the last 6 or 7 years. As such, I'm wondering if it's a bad idea to
even consider removing the .writepage clustering...

> I'll merge this, and to avoid bisect regressions it'll have to go into
> the main writepages patch.  That probaby means folding the add_to_ioend
> cleanup into it as well to not make the calling convention too ugly.

Yup, I figured you'd want to do that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
