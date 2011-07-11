Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6BHOvrG235544 for <xfs@oss.sgi.com>; Mon, 11 Jul 2011 12:24:58 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CE64717B5A3A
	for <xfs@oss.sgi.com>; Mon, 11 Jul 2011 10:24:56 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	kF57UuGUjKGbS5S4 for <xfs@oss.sgi.com>;
	Mon, 11 Jul 2011 10:24:56 -0700 (PDT)
Date: Mon, 11 Jul 2011 13:24:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/27] xfs: use write_cache_pages for writeback clustering
Message-ID: <20110711172444.GA6657@infradead.org>
References: <20110629140109.003209430@bombadil.infradead.org>
	<20110629140336.950805096@bombadil.infradead.org>
	<20110701022248.GM561@dastard> <20110701041851.GN561@dastard>
	<20110701093305.GA28531@infradead.org>
	<20110701154136.GA17881@localhost> <20110704032534.GD1026@dastard>
	<20110706151229.GA1998@redhat.com> <20110708095456.GI1026@dastard>
	<20110711172050.GA2849@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110711172050.GA2849@redhat.com>
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
To: Johannes Weiner <jweiner@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>, Wu Fengguang <fengguang.wu@intel.com>

On Mon, Jul 11, 2011 at 07:20:50PM +0200, Johannes Weiner wrote:
> > Yet the file pages on the active list are unlikely to be dirty -
> > overwrite-in-place cache hot workloads are pretty scarce in my
> > experience. hence writeback of dirty pages from the active LRU is
> > unlikely to be a problem.
> 
> Just to clarify, I looked at this too much from the reclaim POV, where
> use-once applies to full pages, not bytes.
> 
> Even if you do not overwrite the same bytes over and over again,
> issuing two subsequent write()s that end up against the same page will
> have it activated.
> 
> Are your workloads writing in perfectly page-aligned chunks?

Many workloads do, given that we already tell them our preferred
I/O size through struct stat, which alway is the page size or larger.

That won't help with workloads having to write in small chunksizes.
The performance critical ones using small chunksizes usually use
O_(D)SYNC, so pages will be clean after the write returned to userspace.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
