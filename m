Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7B7597F3F
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 17:02:16 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ED318AC008
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 15:02:12 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	GVPJy23vk2EcBbfC for <xfs@oss.sgi.com>;
	Wed, 04 Mar 2015 15:02:08 -0800 (PST)
Date: Thu, 5 Mar 2015 10:00:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [regression v4.0-rc1] mm: IPIs from TLB flushes causing
	significant performance degradation.
Message-ID: <20150304230045.GZ18360@dastard>
References: <CA+55aFzGFvVGD_8Y=jTkYwgmYgZnW0p0Fjf7OHFPRcL6Mz4HOw@mail.gmail.com>
	<20150303014733.GL18360@dastard>
	<CA+55aFw+7V9DfxBA2_DhMNrEQOkvdwjFFga5Y67-a6yVeAz+NQ@mail.gmail.com>
	<CA+55aFw+fb=Fh4M2wA4dVskgqN7PhZRGZS6JTMx4Rb1Qn++oaA@mail.gmail.com>
	<20150303052004.GM18360@dastard>
	<CA+55aFyczb5asoTwhzaJr1JdRi1epg1A6cFJgnzMMZj6U0gFWA@mail.gmail.com>
	<20150303113437.GR4251@dastard> <20150303134346.GO3087@suse.de>
	<20150303213353.GS4251@dastard> <20150304200046.GP3087@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150304200046.GP3087@suse.de>
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

On Wed, Mar 04, 2015 at 08:00:46PM +0000, Mel Gorman wrote:
> On Wed, Mar 04, 2015 at 08:33:53AM +1100, Dave Chinner wrote:
> > On Tue, Mar 03, 2015 at 01:43:46PM +0000, Mel Gorman wrote:
> > > On Tue, Mar 03, 2015 at 10:34:37PM +1100, Dave Chinner wrote:
> > > > On Mon, Mar 02, 2015 at 10:56:14PM -0800, Linus Torvalds wrote:
> > > > > On Mon, Mar 2, 2015 at 9:20 PM, Dave Chinner <david@fromorbit.com> wrote:
> > > > > >>
> > > > > >> But are those migrate-page calls really common enough to make these
> > > > > >> things happen often enough on the same pages for this all to matter?
> > > > > >
> > > > > > It's looking like that's a possibility.
> > > > > 
> > > > > Hmm. Looking closer, commit 10c1045f28e8 already should have
> > > > > re-introduced the "pte was already NUMA" case.
> > > > > 
> > > > > So that's not it either, afaik. Plus your numbers seem to say that
> > > > > it's really "migrate_pages()" that is done more. So it feels like the
> > > > > numa balancing isn't working right.
> > > > 
> > > > So that should show up in the vmstats, right? Oh, and there's a
> > > > tracepoint in migrate_pages, too. Same 6x10s samples in phase 3:
> > > > 
> > > 
> > > The stats indicate both more updates and more faults. Can you try this
> > > please? It's against 4.0-rc1.
> > > 
> > > ---8<---
> > > mm: numa: Reduce amount of IPI traffic due to automatic NUMA balancing
> > 
> > Makes no noticable difference to behaviour or performance. Stats:
> > 
> 
> After going through the series again, I did not spot why there is a
> difference. It's functionally similar and I would hate the theory that
> this is somehow hardware related due to the use of bits it takes action
> on.

I doubt it's hardware related - I'm testing inside a VM, and the
host is a year old Dell r820 server, so it's a pretty common
hardware I'd think.

Guest:

processor       : 15
vendor_id       : GenuineIntel
cpu family      : 6
model           : 6
model name      : QEMU Virtual CPU version 2.0.0
stepping        : 3
microcode       : 0x1
cpu MHz         : 2199.998
cache size      : 4096 KB
physical id     : 15
siblings        : 1
core id         : 0
cpu cores       : 1
apicid          : 15
initial apicid  : 15
fpu             : yes
fpu_exception   : yes
cpuid level     : 4
wp              : yes
flags           : fpu de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pse36 clflush mmx fxsr sse sse2 syscall nx lm rep_good nopl pni cx16 x2apic popcnt hypervisor lahf_lm
bugs            :
bogomips        : 4399.99
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management:

Host:

processor       : 31
vendor_id       : GenuineIntel
cpu family      : 6
model           : 45
model name      : Intel(R) Xeon(R) CPU E5-4620 0 @ 2.20GHz
stepping        : 7
microcode       : 0x70d
cpu MHz         : 1190.750
cache size      : 16384 KB
physical id     : 1
siblings        : 16
core id         : 7
cpu cores       : 8
apicid          : 47
initial apicid  : 47
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm pcid dca sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx lahf_lm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips        : 4400.75
clflush size    : 64
cache_alignment : 64
address sizes   : 46 bits physical, 48 bits virtual
power management:

> There is nothing in the manual that indicates that it would. Try this
> as I don't want to leave this hanging before LSF/MM because it'll mask other
> reports. It alters the maximum rate automatic NUMA balancing scans ptes.
> 
> ---
>  kernel/sched/fair.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 7ce18f3c097a..40ae5d84d4ba 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -799,7 +799,7 @@ update_stats_curr_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
>   * calculated based on the tasks virtual memory size and
>   * numa_balancing_scan_size.
>   */
> -unsigned int sysctl_numa_balancing_scan_period_min = 1000;
> +unsigned int sysctl_numa_balancing_scan_period_min = 2000;
>  unsigned int sysctl_numa_balancing_scan_period_max = 60000;

Made absolutely no difference:

	357,635      migrate:mm_migrate_pages      ( +-  4.11% )

numa_hit 36724642
numa_miss 92477
numa_foreign 92477
numa_interleave 11835
numa_local 36709671
numa_other 107448
numa_pte_updates 83924860
numa_huge_pte_updates 0
numa_hint_faults 81856035
numa_hint_faults_local 22104529
numa_pages_migrated 32766735
pgmigrate_success 32766735
pgmigrate_fail 0

Runtime was actually a minute worse (18m35s vs 17m39s) than without
this patch.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
