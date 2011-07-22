Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MDVhBl086104 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 08:31:43 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 81E1DEF35C3
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 06:31:42 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id FtatjeQAGoRy8Mhe for <xfs@oss.sgi.com>;
	Fri, 22 Jul 2011 06:31:42 -0700 (PDT)
Date: Fri, 22 Jul 2011 14:31:38 +0100
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 8/8] mm: vmscan: Do not writeback filesystem pages from
	kswapd
Message-ID: <20110722133138.GY5349@suse.de>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
	<1311265730-5324-9-git-send-email-mgorman@suse.de>
	<1311339432.27400.36.camel@twins>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1311339432.27400.36.camel@twins>
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
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, Minchan Kim <minchan.kim@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>

On Fri, Jul 22, 2011 at 02:57:12PM +0200, Peter Zijlstra wrote:
> On Thu, 2011-07-21 at 17:28 +0100, Mel Gorman wrote:
> > Assuming that flusher threads will always write back dirty pages promptly
> > then it is always faster for reclaimers to wait for flushers. This patch
> > prevents kswapd writing back any filesystem pages. 
> 
> That is a somewhat sort changelog for such a big assumption ;-)
> 

That is an understatement but the impact of the patch is discussed in
detail in the leader. On NUMA, this patch has a negative impact so
I put no effort into the changelog. The patch is part of the series
because it was specifically asked for.

> I think it can use a few extra words to explain the need to clean pages
> from @zone vs writeback picks whatever fits best on disk and how that
> works out wrt the assumption.
> 

At the time of writing the changelog, I knew that flushers were
not finding pages from the correct zones quickly enough in the NUMA
usecase. The changelog documents the assumptions testing shows them to
be false.

> What requirements does this place on writeback and how does it meet
> them.

It places a requirement on writeback to prioritise pages from zones
under memory pressure. It doesn't meet them. I mention in the leader
that I think patch 8 should be dropped which is why the changelog
sucks.

-- 
Mel Gorman
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
