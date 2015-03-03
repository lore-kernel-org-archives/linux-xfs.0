Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 352DE7F47
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 15:34:03 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A5BF8AC003
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 13:33:59 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	0eioMFgWsBzGfn3s for <xfs@oss.sgi.com>;
	Tue, 03 Mar 2015 13:33:55 -0800 (PST)
Date: Wed, 4 Mar 2015 08:33:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [regression v4.0-rc1] mm: IPIs from TLB flushes causing
	significant performance degradation.
Message-ID: <20150303213353.GS4251@dastard>
References: <20150302010413.GP4251@dastard>
	<CA+55aFzGFvVGD_8Y=jTkYwgmYgZnW0p0Fjf7OHFPRcL6Mz4HOw@mail.gmail.com>
	<20150303014733.GL18360@dastard>
	<CA+55aFw+7V9DfxBA2_DhMNrEQOkvdwjFFga5Y67-a6yVeAz+NQ@mail.gmail.com>
	<CA+55aFw+fb=Fh4M2wA4dVskgqN7PhZRGZS6JTMx4Rb1Qn++oaA@mail.gmail.com>
	<20150303052004.GM18360@dastard>
	<CA+55aFyczb5asoTwhzaJr1JdRi1epg1A6cFJgnzMMZj6U0gFWA@mail.gmail.com>
	<20150303113437.GR4251@dastard> <20150303134346.GO3087@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150303134346.GO3087@suse.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mel Gorman <mgorman@suse.de>
Cc: Matt B <jackdachef@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-mm <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>

On Tue, Mar 03, 2015 at 01:43:46PM +0000, Mel Gorman wrote:
> On Tue, Mar 03, 2015 at 10:34:37PM +1100, Dave Chinner wrote:
> > On Mon, Mar 02, 2015 at 10:56:14PM -0800, Linus Torvalds wrote:
> > > On Mon, Mar 2, 2015 at 9:20 PM, Dave Chinner <david@fromorbit.com> wrote:
> > > >>
> > > >> But are those migrate-page calls really common enough to make these
> > > >> things happen often enough on the same pages for this all to matter?
> > > >
> > > > It's looking like that's a possibility.
> > > 
> > > Hmm. Looking closer, commit 10c1045f28e8 already should have
> > > re-introduced the "pte was already NUMA" case.
> > > 
> > > So that's not it either, afaik. Plus your numbers seem to say that
> > > it's really "migrate_pages()" that is done more. So it feels like the
> > > numa balancing isn't working right.
> > 
> > So that should show up in the vmstats, right? Oh, and there's a
> > tracepoint in migrate_pages, too. Same 6x10s samples in phase 3:
> > 
> 
> The stats indicate both more updates and more faults. Can you try this
> please? It's against 4.0-rc1.
> 
> ---8<---
> mm: numa: Reduce amount of IPI traffic due to automatic NUMA balancing

Makes no noticable difference to behaviour or performance. Stats:

359,857      migrate:mm_migrate_pages ( +-  5.54% )

numa_hit 36026802
numa_miss 14287
numa_foreign 14287
numa_interleave 18408
numa_local 36006052
numa_other 35037
numa_pte_updates 81803359
numa_huge_pte_updates 0
numa_hint_faults 79810798
numa_hint_faults_local 21227730
numa_pages_migrated 32037516
pgmigrate_success 32037516
pgmigrate_fail 0

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
