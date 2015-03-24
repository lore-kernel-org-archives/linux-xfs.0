Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 544607F37
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 10:33:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2216D8F8087
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 08:33:17 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 5TXbdiwBUKgau20m (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Mar 2015 08:33:12 -0700 (PDT)
Date: Tue, 24 Mar 2015 15:33:06 +0000
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 0/3] Reduce system overhead of automatic NUMA balancing
Message-ID: <20150324153306.GG4701@suse.de>
References: <1427113443-20973-1-git-send-email-mgorman@suse.de>
	<20150324115141.GS28621@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150324115141.GS28621@dastard>
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
Cc: linuxppc-dev@lists.ozlabs.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Linux-MM <linux-mm@kvack.org>, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>

On Tue, Mar 24, 2015 at 10:51:41PM +1100, Dave Chinner wrote:
> On Mon, Mar 23, 2015 at 12:24:00PM +0000, Mel Gorman wrote:
> > These are three follow-on patches based on the xfsrepair workload Dave
> > Chinner reported was problematic in 4.0-rc1 due to changes in page table
> > management -- https://lkml.org/lkml/2015/3/1/226.
> > 
> > Much of the problem was reduced by commit 53da3bc2ba9e ("mm: fix up numa
> > read-only thread grouping logic") and commit ba68bc0115eb ("mm: thp:
> > Return the correct value for change_huge_pmd"). It was known that the performance
> > in 3.19 was still better even if is far less safe. This series aims to
> > restore the performance without compromising on safety.
> > 
> > Dave, you already tested patch 1 on its own but it would be nice to test
> > patches 1+2 and 1+2+3 separately just to be certain.
> 
> 			   3.19  4.0-rc4    +p1      +p2      +p3
> mm_migrate_pages	266,750  572,839  558,632  223,706  201,429
> run time		  4m54s    7m50s    7m20s    5m07s    4m31s
> 

Excellent, this is in line with predictions and roughly matches what I
was seeing on bare metal + real NUMA + spinning disk instead of KVM +
fake NUMA + SSD.

Editting slightly;

> numa stats form p1+p2:    numa_pte_updates 46109698
> numa stats form p1+p2+p3: numa_pte_updates 24460492

The big drop in PTE updates matches what I expected -- migration
failures should not lead to increased scan rates which is what patch 3
fixes. I'm also pleased that there was not a drop in performance.

> 
> OK, the summary with all patches applied:
> 
> config                          3.19   4.0-rc1  4.0-rc4  4.0-rc5+
> defaults                       8m08s     9m34s    9m14s    6m57s
> -o ag_stride=-1                4m04s     4m38s    4m11s    4m06s
> -o bhash=101073                6m04s    17m43s    7m35s    6m13s
> -o ag_stride=-1,bhash=101073   4m54s     9m58s    7m50s    4m31s
> 
> So it looks like the patch set fixes the remaining regression and in
> 2 of the four cases actually improves performance....
> 

\o/

Linus, these three patches plus the small fixlet for pmd_mkyoung (to match
pte_mkyoung) is already in Andrew's tree. I'm expecting it'll arrive to
you before 4.0 assuming nothing else goes pear shaped.

> Thanks, Linus and Mel, for tracking this tricky problem down! 
> 

Thanks Dave for persisting with this and collecting the necessary data.
FWIW, I've marked the xfsrepair test case as a "large memory test".
It'll take time before the test machines have historical data for it but
in theory if this regresses again then I should spot it eventually.

-- 
Mel Gorman
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
