Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 07E6A7F50
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2015 17:55:02 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 88B09AC004
	for <xfs@oss.sgi.com>; Thu,  5 Mar 2015 15:54:58 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 3fym8k4oXchZRWkZ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Mar 2015 15:54:56 -0800 (PST)
From: Mel Gorman <mgorman@suse.de>
Subject: [RFC PATCH 0/2] Automatic NUMA balancing and PROT_NONE handling
	followup
Date: Thu,  5 Mar 2015 23:54:50 +0000
Message-Id: <1425599692-32445-1-git-send-email-mgorman@suse.de>
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

Dave Chinner reported a problem due to excessive NUMA balancing activity and
bisected it. These are two patches that address two major issues with that
series. The first patch is almost certainly unrelated to what he saw due
to fact his vmstats showed no huge page activity but the fix is important.
The second patch restores performance of one benchmark to similar levels
to 3.19-vanilla but it still has to be tested on his workload. While I
have a test configuration for his workload, I don't have either the KVM
setup or suitable storage to test against. It also needs to be reviewed
and tested on ppc64.

 arch/powerpc/include/asm/pgtable-ppc64.h | 16 ++++++++++++++++
 arch/x86/include/asm/pgtable.h           | 14 ++++++++++++++
 include/asm-generic/pgtable.h            | 19 +++++++++++++++++++
 mm/huge_memory.c                         | 23 ++++++++++++++++++-----
 mm/mprotect.c                            |  5 +++++
 5 files changed, 72 insertions(+), 5 deletions(-)

-- 
2.1.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
