Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 27A907F3F
	for <xfs@oss.sgi.com>; Fri, 23 May 2014 06:52:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0C88E8F8039
	for <xfs@oss.sgi.com>; Fri, 23 May 2014 04:52:33 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GlFzZAWnPDcMPaBE for
	<xfs@oss.sgi.com>; Fri, 23 May 2014 04:52:32 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s4NBqWST004446
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 23 May 2014 07:52:32 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id s4NBqVbx028613
	for <xfs@oss.sgi.com>; Fri, 23 May 2014 07:52:31 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 0/3] xfs: run eofblocks scan on ENOSPC
Date: Fri, 23 May 2014 07:52:27 -0400
Message-Id: <1400845950-41435-1-git-send-email-bfoster@redhat.com>
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
To: xfs@oss.sgi.com

Hi all,

Here's v2 of the eofblocks scan on ENOSPC series, incorporating feedback
from v1:

http://oss.sgi.com/archives/xfs/2014-03/msg00388.html

The major change here is to simplify the error checking logic and tie
the eofblocks scan to the inode flush in the ENOSPC scenario. I've done
some high-level testing that doesn't seem to elicit any sort of
pathological behavior given the circumstances (i.e., performance will
never be ideal as we head into ENOSPC).

I tested on a hacked filesystem that makes preallocation persistent (no
trim on close), disables preallocation throttling and set the background
scanner to a high value to create worst case conditions. I ran an
fs_mark workload to create 64k 1MB files. Then, started 16x8GB
sequential dd writers expected to hit ENOSPC. This is on a 16xcpu box
with 32GB RAM and a 200GB fs (with agcounts of 32 and 1024).

Via tracepoints, I generally observe that the inode flush acts as a
filter to prevent many threads from entering into eofblocks scans at
once. E.g., by the time the first handful of threads make it through a
scan, they and/or others have dirtied more data for the remaining queued
up inode flushers to work with. I notice some occasional spikes in
kworkers or rcu processing, but nothing for longer than a couple seconds
or so.

A downside I've noticed with this logic is that once one thread runs a
scan and makes it through this retry sequence, it has a better chance to
allocate more of the recently freed space than the others, all of which
might have queued on the inode flush lock by the time the first
flush/scan completes.

This leads to what one might consider "unfair" allocation across the set
of writers when we enter this scenario. E.g., I saw tests were some
threads were able to complete the 8GB write while others only made it to
2-3GB before the filesystem completely ran out of space. Given the
benefit of the series, I think this is something that can be potentially
enhanced incrementally if it turns out to be a problem in practice.

I also have an xfstests test I'm planning to post soon that verifies
lingering preallocations can be reclaimed in a reasonable manner before
returning ENOSPC.

Thoughts, reviews, flames appreciated.

Brian

v2:
- Drop flush mechanism during eofblocks scan (along with prereq patch).
- Simplify scan logic on ENOSPC. Separate EDQUOT from ENOSPC and tie
  ENOSPC scan to inode flush.
- Eliminate unnecessary project quota handling from
  xfs_inode_free_quota_eofblocks() (ENOSPC is a separate path).

Brian Foster (3):
  xfs: add scan owner field to xfs_eofblocks
  xfs: run an eofblocks scan on ENOSPC/EDQUOT
  xfs: squash prealloc while over quota free space as well

 fs/xfs/xfs_dquot.h  | 15 ++++++++++++++
 fs/xfs/xfs_file.c   | 23 +++++++++++++++++----
 fs/xfs/xfs_icache.c | 59 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_icache.h |  3 +++
 fs/xfs/xfs_iomap.c  | 20 ++++++++++++------
 5 files changed, 109 insertions(+), 11 deletions(-)

-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
