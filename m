Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB79NRlp062238 for <xfs@oss.sgi.com>; Wed, 7 Dec 2011 03:23:27 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 288FA1DC37CD
	for <xfs@oss.sgi.com>; Wed,  7 Dec 2011 01:23:25 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	qZYghtfv9PlsbGaq for <xfs@oss.sgi.com>;
	Wed, 07 Dec 2011 01:23:25 -0800 (PST)
Date: Wed, 7 Dec 2011 20:23:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC, PATCH 0/12] xfs: compound buffers for directory blocks
Message-ID: <20111207092320.GA14273@dastard>
References: <1323238703-13198-1-git-send-email-david@fromorbit.com>
	<20111207063508.GA13931@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111207063508.GA13931@infradead.org>
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

On Wed, Dec 07, 2011 at 01:35:08AM -0500, Christoph Hellwig wrote:
> On Wed, Dec 07, 2011 at 05:18:11PM +1100, Dave Chinner wrote:
> > The series passes xfstests on 4k/4k, 4k/512b, 64k/4k and 64k/512b
> > (dirblksz/fsblksz) configurations without any new regressions, and
> > survives 100 million inode fs_mark benchmarks on a 17TB filesystem
> > using 4k/4k, 64k/512b and 64k/512b configurations.
> 
> Do you have any benchmark numbers showing performance improvements
> for the large directory block case?

I haven't run real comparisons yet (it hasn't been working for long
enough for me to do so), but I suspect that the gains are lost
in the amount of CPU overhead the buffer formatting code is
consuming - it's around 40-50% of the entire CPU time on the
parallel create tests:

  +  13.10%  [kernel]  [k] memcpy
  +   7.94%  [kernel]  [k] xfs_next_bit
  +   7.63%  [kernel]  [k] xfs_buf_find_irec.isra.11
  +   5.86%  [kernel]  [k] xfs_buf_offset
  +   4.36%  [kernel]  [k] xfs_buf_item_format_segment
  +   4.11%  [kernel]  [k] xfs_buf_item_size_segment.isra.0

That's all cpu usage under the transaction commit path.

Basically I'm getting 100-110k files/s with 4k directory sizes, and
70-80k files/s with 64k dirs for the same workload consuming the
same amount of roughly the same CPU time. Killing the buffer logging
overhead (which barely registers on the 4k directory block size)
looks like it will now bring parity to large block size directory
performance compared to 4k block size performance because the amount
written to the log (~30MB/s) is identical for both configurations...

It might cwbe as simple as checking the hamming weight of the dirty
bitmap, and if it is over a certain amount just log the buffer in
it's entirity, skipping the bitmap based dirty region processing
altogether...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
