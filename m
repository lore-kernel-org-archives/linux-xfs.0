Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 41A2C7F3F
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 14:00:58 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F4057304048
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 12:00:57 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id whZcagOzkzcU4R8X (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 04 Mar 2015 12:00:52 -0800 (PST)
Date: Wed, 4 Mar 2015 20:00:46 +0000
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [regression v4.0-rc1] mm: IPIs from TLB flushes causing
	significant performance degradation.
Message-ID: <20150304200046.GP3087@suse.de>
References: <20150302010413.GP4251@dastard>
	<CA+55aFzGFvVGD_8Y=jTkYwgmYgZnW0p0Fjf7OHFPRcL6Mz4HOw@mail.gmail.com>
	<20150303014733.GL18360@dastard>
	<CA+55aFw+7V9DfxBA2_DhMNrEQOkvdwjFFga5Y67-a6yVeAz+NQ@mail.gmail.com>
	<CA+55aFw+fb=Fh4M2wA4dVskgqN7PhZRGZS6JTMx4Rb1Qn++oaA@mail.gmail.com>
	<20150303052004.GM18360@dastard>
	<CA+55aFyczb5asoTwhzaJr1JdRi1epg1A6cFJgnzMMZj6U0gFWA@mail.gmail.com>
	<20150303113437.GR4251@dastard> <20150303134346.GO3087@suse.de>
	<20150303213353.GS4251@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150303213353.GS4251@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Matt B <jackdachef@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-mm <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>

On Wed, Mar 04, 2015 at 08:33:53AM +1100, Dave Chinner wrote:
> On Tue, Mar 03, 2015 at 01:43:46PM +0000, Mel Gorman wrote:
> > On Tue, Mar 03, 2015 at 10:34:37PM +1100, Dave Chinner wrote:
> > > On Mon, Mar 02, 2015 at 10:56:14PM -0800, Linus Torvalds wrote:
> > > > On Mon, Mar 2, 2015 at 9:20 PM, Dave Chinner <david@fromorbit.com> wrote:
> > > > >>
> > > > >> But are those migrate-page calls really common enough to make these
> > > > >> things happen often enough on the same pages for this all to matter?
> > > > >
> > > > > It's looking like that's a possibility.
> > > > 
> > > > Hmm. Looking closer, commit 10c1045f28e8 already should have
> > > > re-introduced the "pte was already NUMA" case.
> > > > 
> > > > So that's not it either, afaik. Plus your numbers seem to say that
> > > > it's really "migrate_pages()" that is done more. So it feels like the
> > > > numa balancing isn't working right.
> > > 
> > > So that should show up in the vmstats, right? Oh, and there's a
> > > tracepoint in migrate_pages, too. Same 6x10s samples in phase 3:
> > > 
> > 
> > The stats indicate both more updates and more faults. Can you try this
> > please? It's against 4.0-rc1.
> > 
> > ---8<---
> > mm: numa: Reduce amount of IPI traffic due to automatic NUMA balancing
> 
> Makes no noticable difference to behaviour or performance. Stats:
> 

After going through the series again, I did not spot why there is a
difference. It's functionally similar and I would hate the theory that
this is somehow hardware related due to the use of bits it takes action
on. There is nothing in the manual that indicates that it would. Try this
as I don't want to leave this hanging before LSF/MM because it'll mask other
reports. It alters the maximum rate automatic NUMA balancing scans ptes.

---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7ce18f3c097a..40ae5d84d4ba 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -799,7 +799,7 @@ update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
  * calculated based on the tasks virtual memory size and
  * numa_balancing_scan_size.
  */
-unsigned int sysctl_numa_balancing_scan_period_min = 1000;
+unsigned int sysctl_numa_balancing_scan_period_min = 2000;
 unsigned int sysctl_numa_balancing_scan_period_max = 60000;
 
 /* Portion of address space to scan in MB */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
