Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AE1A47F5F
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 05:34:46 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8CC078F8073
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 03:34:43 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	bXNDgWUGC4DyqHzt for <xfs@oss.sgi.com>;
	Tue, 03 Mar 2015 03:34:40 -0800 (PST)
Date: Tue, 3 Mar 2015 22:34:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [regression v4.0-rc1] mm: IPIs from TLB flushes causing
	significant performance degradation.
Message-ID: <20150303113437.GR4251@dastard>
References: <20150302010413.GP4251@dastard>
	<CA+55aFzGFvVGD_8Y=jTkYwgmYgZnW0p0Fjf7OHFPRcL6Mz4HOw@mail.gmail.com>
	<20150303014733.GL18360@dastard>
	<CA+55aFw+7V9DfxBA2_DhMNrEQOkvdwjFFga5Y67-a6yVeAz+NQ@mail.gmail.com>
	<CA+55aFw+fb=Fh4M2wA4dVskgqN7PhZRGZS6JTMx4Rb1Qn++oaA@mail.gmail.com>
	<20150303052004.GM18360@dastard>
	<CA+55aFyczb5asoTwhzaJr1JdRi1epg1A6cFJgnzMMZj6U0gFWA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFyczb5asoTwhzaJr1JdRi1epg1A6cFJgnzMMZj6U0gFWA@mail.gmail.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt B <jackdachef@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-mm <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>

On Mon, Mar 02, 2015 at 10:56:14PM -0800, Linus Torvalds wrote:
> On Mon, Mar 2, 2015 at 9:20 PM, Dave Chinner <david@fromorbit.com> wrote:
> >>
> >> But are those migrate-page calls really common enough to make these
> >> things happen often enough on the same pages for this all to matter?
> >
> > It's looking like that's a possibility.
> 
> Hmm. Looking closer, commit 10c1045f28e8 already should have
> re-introduced the "pte was already NUMA" case.
> 
> So that's not it either, afaik. Plus your numbers seem to say that
> it's really "migrate_pages()" that is done more. So it feels like the
> numa balancing isn't working right.

So that should show up in the vmstats, right? Oh, and there's a
tracepoint in migrate_pages, too. Same 6x10s samples in phase 3:

3.19:

	55,898      migrate:mm_migrate_pages

And a sample of the events shows 99.99% of these are:

mm_migrate_pages:     nr_succeeded=1 nr_failed=0 mode=MIGRATE_ASYNC reason=

4.0-rc1:

	364,442      migrate:mm_migrate_pages

They are also single page MIGRATE_ASYNC events like for 3.19.

And 'grep "numa\|migrate" /proc/vmstat' output for the entire
xfs_repair run:

3.19:

numa_hit 5163221
numa_miss 121274
numa_foreign 121274
numa_interleave 12116
numa_local 5153127
numa_other 131368
numa_pte_updates 36482466
numa_huge_pte_updates 0
numa_hint_faults 34816515
numa_hint_faults_local 9197961
numa_pages_migrated 1228114
pgmigrate_success 1228114
pgmigrate_fail 0

4.0-rc1:

numa_hit 36952043
numa_miss 92471
numa_foreign 92471
numa_interleave 10964
numa_local 36927384
numa_other 117130
numa_pte_updates 84010995
numa_huge_pte_updates 0
numa_hint_faults 81697505
numa_hint_faults_local 21765799
numa_pages_migrated 32916316
pgmigrate_success 32916316
pgmigrate_fail 0

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
