Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7BNjM0K011828 for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 18:45:25 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 40362136833C
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 16:46:57 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	HKHEEwTOZ4KYTABq for <xfs@oss.sgi.com>;
	Thu, 11 Aug 2011 16:46:57 -0700 (PDT)
Date: Thu, 11 Aug 2011 19:45:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/7] Reduce filesystem writeback from page reclaim v3
Message-ID: <20110811234516.GA21649@infradead.org>
References: <1312973240-32576-1-git-send-email-mgorman@suse.de>
	<20110810110056.GA31756@infradead.org>
	<20110810111547.GZ19099@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110810111547.GZ19099@suse.de>
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
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, Minchan Kim <minchan.kim@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>

On Wed, Aug 10, 2011 at 12:15:47PM +0100, Mel Gorman wrote:
> > The right fix is to simply remove that fallback, possibly in combination
> > with implementating real migration support for btrfs.
> > 
> 
> Removing the fallback entirely is overkill as proper migration support
> is not going to get 100% coverage

It seems like btrfs is indeed the only important one missing.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
