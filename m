Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7INtAR3233768 for <xfs@oss.sgi.com>; Thu, 18 Aug 2011 18:55:10 -0500
Received: from smtp1.linux-foundation.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F0FFB1BBA0CC
	for <xfs@oss.sgi.com>; Thu, 18 Aug 2011 16:55:07 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org
	[140.211.169.13]) by cuda.sgi.com with ESMTP id
	jggh8QOFe1o63DJB for <xfs@oss.sgi.com>;
	Thu, 18 Aug 2011 16:55:07 -0700 (PDT)
Date: Thu, 18 Aug 2011 16:54:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7] Reduce filesystem writeback from page reclaim v3
Message-Id: <20110818165420.0a7aabb5.akpm@linux-foundation.org>
In-Reply-To: <1312973240-32576-1-git-send-email-mgorman@suse.de>
References: <1312973240-32576-1-git-send-email-mgorman@suse.de>
Mime-Version: 1.0
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

On Wed, 10 Aug 2011 11:47:13 +0100
Mel Gorman <mgorman@suse.de> wrote:

> The new problem is that
> reclaim has very little control over how long before a page in a
> particular zone or container is cleaned which is discussed later.

Confused - where was this discussed?  Please tell us more about
this problem and how it was addressed.


Another (and somewhat interrelated) potential problem I see with this
work is that it throws a big dependency onto kswapd.  If kswapd gets
stuck somewhere for extended periods, there's nothing there to perform
direct writeback.  This has happened in the past in weird situations
such as kswpad getting blocked on ext3 journal commits which are
themselves stuck for ages behind lots of writeout which itself is stuck
behind lots of reads.  That's an advantage of direct reclaim: more
threads available.

How forcefully has this stuff been tested with multiple disks per
kswapd?  Where one disk is overloaded-ext3-on-usb-stick?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
