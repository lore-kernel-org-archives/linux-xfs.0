Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7KJXxjP171706 for <xfs@oss.sgi.com>; Sat, 20 Aug 2011 14:34:01 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 50676FB08B
	for <xfs@oss.sgi.com>; Sat, 20 Aug 2011 12:33:57 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 9zuW3WHCwVuGbhSi for <xfs@oss.sgi.com>;
	Sat, 20 Aug 2011 12:33:57 -0700 (PDT)
Date: Sat, 20 Aug 2011 20:33:52 +0100
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 0/7] Reduce filesystem writeback from page reclaim v3
Message-ID: <20110820193351.GA8349@suse.de>
References: <1312973240-32576-1-git-send-email-mgorman@suse.de>
	<20110818165420.0a7aabb5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110818165420.0a7aabb5.akpm@linux-foundation.org>
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, Minchan Kim <minchan.kim@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>

On Thu, Aug 18, 2011 at 04:54:20PM -0700, Andrew Morton wrote:
> On Wed, 10 Aug 2011 11:47:13 +0100
> Mel Gorman <mgorman@suse.de> wrote:
> 
> > The new problem is that
> > reclaim has very little control over how long before a page in a
> > particular zone or container is cleaned which is discussed later.
> 
> Confused - where was this discussed?  Please tell us more about
> this problem and how it was addressed.
> 

I'm currently on holiday. I am only online checking train timetables.
I'll be back online properly on August 30th.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
