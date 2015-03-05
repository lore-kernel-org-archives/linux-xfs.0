Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7EDC57F3F
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2015 17:54:59 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5E3658F808E
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2015 15:54:59 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id E1qqu4U3c4b2rvdc (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Mar 2015 15:54:57 -0800 (PST)
From: Mel Gorman <mgorman@suse.de>
Subject: [PATCH 1/2] mm: thp: Return the correct value for change_huge_pmd
Date: Thu,  5 Mar 2015 23:54:51 +0000
Message-Id: <1425599692-32445-2-git-send-email-mgorman@suse.de>
In-Reply-To: <1425599692-32445-1-git-send-email-mgorman@suse.de>
References: <1425599692-32445-1-git-send-email-mgorman@suse.de>
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

The wrong value is being returned by change_huge_pmd since commit
10c1045f28e8 ("mm: numa: avoid unnecessary TLB flushes when setting
NUMA hinting entries") which allows a fallthrough that tries to adjust
non-existent PTEs. This patch corrects it.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/huge_memory.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index fc00c8cb5a82..194c0f019774 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1482,6 +1482,7 @@ int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 
 	if (__pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
 		pmd_t entry;
+		ret = 1;
 
 		/*
 		 * Avoid trapping faults against the zero page. The read-only
@@ -1490,11 +1491,10 @@ int change_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
 		 */
 		if (prot_numa && is_huge_zero_pmd(*pmd)) {
 			spin_unlock(ptl);
-			return 0;
+			return ret;
 		}
 
 		if (!prot_numa || !pmd_protnone(*pmd)) {
-			ret = 1;
 			entry = pmdp_get_and_clear_notify(mm, addr, pmd);
 			entry = pmd_modify(entry, newprot);
 			ret = HPAGE_PMD_NR;
-- 
2.1.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
