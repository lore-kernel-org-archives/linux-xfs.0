Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9BF317F6D
	for <xfs@oss.sgi.com>; Sat,  7 Mar 2015 09:21:00 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 86B108F8037
	for <xfs@oss.sgi.com>; Sat,  7 Mar 2015 07:21:00 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 4CUTDKY0vFGwCRBb (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 07 Mar 2015 07:20:59 -0800 (PST)
From: Mel Gorman <mgorman@suse.de>
Subject: [PATCH 3/4] mm: numa: Mark huge PTEs young when clearing NUMA hinting
	faults
Date: Sat,  7 Mar 2015 15:20:50 +0000
Message-Id: <1425741651-29152-4-git-send-email-mgorman@suse.de>
In-Reply-To: <1425741651-29152-1-git-send-email-mgorman@suse.de>
References: <1425741651-29152-1-git-send-email-mgorman@suse.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linuxppc-dev@lists.ozlabs.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Linux-MM <linux-mm@kvack.org>, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>

Base PTEs are marked young when the NUMA hinting information is cleared
but the same does not happen for huge pages which this patch addresses.
Note that migrated pages are not marked young as the base page migration
code does not assume that migrated pages have been referenced. This could
be addressed but beyond the scope of this series which is aimed at Dave
Chinners shrink workload that is unlikely to be affected by this issue.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/huge_memory.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 194c0f019774..ae13ad31e113 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1359,6 +1359,7 @@ int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 clear_pmdnuma:
 	BUG_ON(!PageLocked(page));
 	pmd = pmd_modify(pmd, vma->vm_page_prot);
+	pmd = pmd_mkyoung(pmd);
 	set_pmd_at(mm, haddr, pmdp, pmd);
 	update_mmu_cache_pmd(vma, addr, pmdp);
 	unlock_page(page);
-- 
2.1.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
