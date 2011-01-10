Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0AJFmAU032807 for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 13:15:48 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E1B6BFBB7FB
	for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 11:18:00 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id iS7fOO7io8a1qwnk for
	<xfs@oss.sgi.com>; Mon, 10 Jan 2011 11:18:00 -0800 (PST)
Date: Mon, 10 Jan 2011 14:17:57 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_repair: multithread phase 2
Message-ID: <20110110191757.GA25029@infradead.org>
References: <1294620248-17098-1-git-send-email-david@fromorbit.com>
	<201101100857.53421@zmi.at> <20110110084122.GF28803@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110110084122.GF28803@dastard>
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
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, xfs@oss.sgi.com

On Mon, Jan 10, 2011 at 07:41:22PM +1100, Dave Chinner wrote:
> On Mon, Jan 10, 2011 at 08:57:52AM +0100, Michael Monnerie wrote:
> > On Montag, 10. Januar 2011 Dave Chinner wrote:
> > > This patch uses 32-way threading which results in no noticable
> > > slowdown on single SATA drives with NCQ, but results in ~10x
> > > reduction in runtime on a 12 disk RAID-0 array.
> > 
> > Is the fixed 32-way number reasonable, or shouldn't that be "number of 
> > available cpu cores"-way? Why threading when you have a single core cpu?
> 
> Sure, 32-way is reasonable on a single disk and CPU. Pretty much
> every sata disk supports NCQ these days, and default to a depth of
> 32, which means we can have 32 concurrent reads in progress at once.
> Phase 2 is all synchronous IO, so the only way to hide the IO
> latency is to queue work to multiple threads and switch between the
> threadsto work on another queue when the current one blocks waiting
> for IO.

The default queue depth for ATA NCQ actually is 31, not 32 for some odd
reason.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
