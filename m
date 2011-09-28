Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8S7CLEV093926 for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 02:12:21 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4C87514268A4
	for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 00:18:21 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id e6t8RSphxZ1D4kqB for
	<xfs@oss.sgi.com>; Wed, 28 Sep 2011 00:18:21 -0700 (PDT)
Date: Wed, 28 Sep 2011 09:11:54 +0200
From: Johannes Weiner <jweiner@redhat.com>
Subject: Re: [patch 2/2/4] mm: try to distribute dirty pages fairly across
	zones
Message-ID: <20110928071154.GA23535@redhat.com>
References: <1316526315-16801-1-git-send-email-jweiner@redhat.com>
	<1316526315-16801-3-git-send-email-jweiner@redhat.com>
	<20110921160226.1bf74494.akpm@google.com>
	<20110922085242.GA29046@redhat.com>
	<20110923144248.GC2606@redhat.com>
	<20110928055640.GB14561@barrios-desktop>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110928055640.GB14561@barrios-desktop>
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
Cc: Andrew Morton <akpm@google.com>, Rik van Riel <riel@redhat.com>, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Mel Gorman <mgorman@suse.de>, linux-fsdevel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Wu Fengguang <fengguang.wu@intel.com>, Chris Mason <chris.mason@oracle.com>

On Wed, Sep 28, 2011 at 02:56:40PM +0900, Minchan Kim wrote:
> On Fri, Sep 23, 2011 at 04:42:48PM +0200, Johannes Weiner wrote:
> > The maximum number of dirty pages that exist in the system at any time
> > is determined by a number of pages considered dirtyable and a
> > user-configured percentage of those, or an absolute number in bytes.
> 
> It's explanation of old approach.

What do you mean?  This does not change with this patch.  We still
have a number of dirtyable pages and a limit that is applied
relatively to this number.

> > This number of dirtyable pages is the sum of memory provided by all
> > the zones in the system minus their lowmem reserves and high
> > watermarks, so that the system can retain a healthy number of free
> > pages without having to reclaim dirty pages.
> 
> It's a explanation of new approach.

Same here, this aspect is also not changed with this patch!

> > But there is a flaw in that we have a zoned page allocator which does
> > not care about the global state but rather the state of individual
> > memory zones.  And right now there is nothing that prevents one zone
> > from filling up with dirty pages while other zones are spared, which
> > frequently leads to situations where kswapd, in order to restore the
> > watermark of free pages, does indeed have to write pages from that
> > zone's LRU list.  This can interfere so badly with IO from the flusher
> > threads that major filesystems (btrfs, xfs, ext4) mostly ignore write
> > requests from reclaim already, taking away the VM's only possibility
> > to keep such a zone balanced, aside from hoping the flushers will soon
> > clean pages from that zone.
> 
> It's a explanation of old approach, again!
> Shoudn't we move above phrase of new approach into below?

Everything above describes the current behaviour (at the point of this
patch, so respecting lowmem_reserve e.g. is part of the current
behaviour by now) and its problems.  And below follows a description
of how the patch tries to fix it.

> > Enter per-zone dirty limits.  They are to a zone's dirtyable memory
> > what the global limit is to the global amount of dirtyable memory, and
> > try to make sure that no single zone receives more than its fair share
> > of the globally allowed dirty pages in the first place.  As the number
> > of pages considered dirtyable exclude the zones' lowmem reserves and
> > high watermarks, the maximum number of dirty pages in a zone is such
> > that the zone can always be balanced without requiring page cleaning.
> > 
> > As this is a placement decision in the page allocator and pages are
> > dirtied only after the allocation, this patch allows allocators to
> > pass __GFP_WRITE when they know in advance that the page will be
> > written to and become dirty soon.  The page allocator will then
> > attempt to allocate from the first zone of the zonelist - which on
> > NUMA is determined by the task's NUMA memory policy - that has not
> > exceeded its dirty limit.
> > 
> > At first glance, it would appear that the diversion to lower zones can
> > increase pressure on them, but this is not the case.  With a full high
> > zone, allocations will be diverted to lower zones eventually, so it is
> > more of a shift in timing of the lower zone allocations.  Workloads
> > that previously could fit their dirty pages completely in the higher
> > zone may be forced to allocate from lower zones, but the amount of
> > pages that 'spill over' are limited themselves by the lower zones'
> > dirty constraints, and thus unlikely to become a problem.
> 
> That's a good justification.
> 
> > For now, the problem of unfair dirty page distribution remains for
> > NUMA configurations where the zones allowed for allocation are in sum
> > not big enough to trigger the global dirty limits, wake up the flusher
> > threads and remedy the situation.  Because of this, an allocation that
> > could not succeed on any of the considered zones is allowed to ignore
> > the dirty limits before going into direct reclaim or even failing the
> > allocation, until a future patch changes the global dirty throttling
> > and flusher thread activation so that they take individual zone states
> > into account.
> > 
> > Signed-off-by: Johannes Weiner <jweiner@redhat.com>
> 
> Otherwise, looks good to me.
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Thanks!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
