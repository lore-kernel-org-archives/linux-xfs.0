Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CFE657F78
	for <xfs@oss.sgi.com>; Sat,  7 Mar 2015 09:21:01 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AEA08304062
	for <xfs@oss.sgi.com>; Sat,  7 Mar 2015 07:20:58 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id x8gnLcbvwFCGdP50 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 07 Mar 2015 07:20:57 -0800 (PST)
From: Mel Gorman <mgorman@suse.de>
Subject: [RFC PATCH 0/4] Automatic NUMA balancing and PROT_NONE handling
	followup v2r8
Date: Sat,  7 Mar 2015 15:20:47 +0000
Message-Id: <1425741651-29152-1-git-send-email-mgorman@suse.de>
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

Dave Chinner reported a problem due to excessive NUMA balancing activity
and bisected it. The first patch in this series corrects a major problem
that is unlikely to affect Dave but is still serious. Patch 2 is a minor
cleanup that was spotted while looking at scan rate control. Patch 3 is
minor and unlikely to make a difference but is still an inconsistentcy
between base and THP handling. Patch 4 is the important one, it slows
PTE scan updates if migrations are failing or throttled. Details of the
performance impact on local tests is included in the patch.

 include/linux/migrate.h |  5 -----
 include/linux/sched.h   |  9 +++++----
 kernel/sched/fair.c     |  8 ++++++--
 mm/huge_memory.c        |  8 +++++---
 mm/memory.c             |  3 ++-
 mm/migrate.c            | 20 --------------------
 6 files changed, 18 insertions(+), 35 deletions(-)

-- 
2.1.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
