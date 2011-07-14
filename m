Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6E4pRkw115283 for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 23:51:27 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C96F6B884
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 21:51:26 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	MRGB0HD01b8fVJ3L for <xfs@oss.sgi.com>;
	Wed, 13 Jul 2011 21:51:26 -0700 (PDT)
Date: Thu, 14 Jul 2011 00:51:23 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 0/5] Reduce filesystem writeback from page reclaim
	(again)
Message-ID: <20110714045123.GB3203@infradead.org>
References: <1310567487-15367-1-git-send-email-mgorman@suse.de>
	<20110714003340.GZ23038@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110714003340.GZ23038@dastard>
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
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>, Minchan Kim <minchan.kim@gmail.com>

On Thu, Jul 14, 2011 at 10:33:40AM +1000, Dave Chinner wrote:
> patchset. After all, that's what I keep asking for (so we can get
> rid of .writepage altogether), and if the numbers don't add up, then
> I'll shut up about it. ;)

Unfortunately there's a few more users of ->writepage in addition to
memory reclaim.  The most visible on is page migration, but there's also
a write_one_page helper used by a few filesystems that would either
need to get a writepage-like callback or a bigger rewrite.

I agree that killing of ->writepage would be a worthwhile goal, though.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
