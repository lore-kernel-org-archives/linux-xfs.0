Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6R7bkjw167817 for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 02:37:47 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 387B6168699C
	for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 00:37:53 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 2ZZCPDAvK3KgzxRR for <xfs@oss.sgi.com>;
	Wed, 27 Jul 2011 00:37:53 -0700 (PDT)
Date: Wed, 27 Jul 2011 08:37:37 +0100
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [RFC PATCH 0/8] Reduce filesystem writeback from page reclaim v2
Message-ID: <20110727073737.GG3010@suse.de>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
	<CAEwNFnA_OGUYfCQrLCMt9NuU0O0ftWWBB4_Si8NypKyaeuRg2A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAEwNFnA_OGUYfCQrLCMt9NuU0O0ftWWBB4_Si8NypKyaeuRg2A@mail.gmail.com>
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
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>

On Wed, Jul 27, 2011 at 01:32:17PM +0900, Minchan Kim wrote:
> >
> > http://www.csn.ul.ie/~mel/postings/reclaim-20110721
> >
> > Unfortunately, the volume of data is excessive but here is a partial
> > summary of what was interesting for XFS.
> 
> Could you clarify the notation?
> 1P :  1 Processor?
> 512M: system memory size?
> 2X , 4X, 16X: the size of files created during test
> 

1P   == 1 Processor
512M == 512M RAM (mem=512M)
2X   == 2 x NUM_CPU fsmark threads

-- 
Mel Gorman
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
