Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p61FFFo2071770 for <xfs@oss.sgi.com>; Fri, 1 Jul 2011 10:15:15 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DFCFE1EE45BE
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2011 08:15:14 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	qDphks0vTcD947zq for <xfs@oss.sgi.com>;
	Fri, 01 Jul 2011 08:15:14 -0700 (PDT)
Date: Fri, 1 Jul 2011 11:15:09 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/27] xfs: use write_cache_pages for writeback clustering
Message-ID: <20110701151509.GA30620@infradead.org>
References: <20110629140109.003209430@bombadil.infradead.org>
	<20110629140336.950805096@bombadil.infradead.org>
	<20110701022248.GM561@dastard> <20110701041851.GN561@dastard>
	<20110701093305.GA28531@infradead.org>
	<20110701145935.GB29530@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110701145935.GB29530@suse.de>
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
To: Mel Gorman <mgorman@suse.de>
Cc: jack@suse.cz, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>

On Fri, Jul 01, 2011 at 03:59:35PM +0100, Mel Gorman wrote:
> On Fri, Jul 01, 2011 at 05:33:05AM -0400, Christoph Hellwig wrote:
> > Johannes, Mel, Wu,
> 
> Am adding Jan Kara as he has been working on writeback efficiency
> recently as well.
> 
> > Dave has been stressing some XFS patches of mine that remove the XFS
> > internal writeback clustering in favour of using write_cache_pages.
> > 
> 
> Against what kernel? 2.6.38 was a disaster for reclaim I've been
> finding out this week. I don't know about 2.6.38.8. 2.6.39 was better.

The patch series is against current 3.0-rc, I assume that's what Dave
tested as well.

> I'm assuming "test 180" is from xfstests which was not one of the tests
> I used previously. To run with 1000 files instead of 100, was the file
> "180" simply editted to make it look like this loop instead?

Yes. to both questions.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
