Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6DFVbv1089640 for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 10:31:37 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 353231501B78
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 08:31:35 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id hcsB3wFum8hT7kqY for <xfs@oss.sgi.com>;
	Wed, 13 Jul 2011 08:31:35 -0700 (PDT)
Date: Wed, 13 Jul 2011 16:31:30 +0100
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [RFC PATCH 0/5] Reduce filesystem writeback from page reclaim
	(again)
Message-ID: <20110713153130.GH7529@suse.de>
References: <1310567487-15367-1-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1310567487-15367-1-git-send-email-mgorman@suse.de>
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
To: Linux-MM <linux-mm@kvack.org>
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Minchan Kim <minchan.kim@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>

On Wed, Jul 13, 2011 at 03:31:22PM +0100, Mel Gorman wrote:
> <SNIP>
> The objective of the series - reducing writes from reclaim - is
> met with filesystem writes from reclaim reduced to 0 with reclaim
> in general doing less work. ext3, ext4 and xfs all showed marked
> improvements for fs_mark in this configuration. btrfs looked worse
> but it's within the noise and I'd expect the patches to have little
> or no impact there due it ignoring ->writepage from reclaim.
> 

My bad, I accidentally looked at an old report for btrfs based on
older patches. In the report posted with all patches applied, the
performance of btrfs does look better but as the patches should make
no difference, it's still in the noise.

-- 
Mel Gorman
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
