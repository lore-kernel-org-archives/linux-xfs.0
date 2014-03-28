Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 08F437F51
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 08:16:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DDED630406A
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 06:16:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2nmcWAduGVGmTrFh for
	<xfs@oss.sgi.com>; Fri, 28 Mar 2014 06:16:06 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2SDG5FI009887
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 09:16:05 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id s2SDG5SR027819
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 09:16:05 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/5] xfs: run eofblocks scan on ENOSPC
Date: Fri, 28 Mar 2014 09:15:58 -0400
Message-Id: <1396012563-60973-1-git-send-email-bfoster@redhat.com>
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

The purpose of this series is to help address the inefficient use of
preallocation for larger files on smaller filesystems. When the
filesystem is small, so is the 5% low free space threshold that enables
preallocation throttling. When the low free space threshold is reduced
to a couple GB or so, we can ram into ENOSPC prematurely due to larger,
active preallocations.

We resolve this condition with an eofblocks scan in the pre-existing
ENOSPC retry write sequence. The scan resets outstanding preallocations
such that throttling is guaranteed an opportunity to manage future
preallocations gracefully into ENOSPC and thus ensures closer to 100%
utilization before ENOSPC is reported to userspace.

Patches 1-3 make some small enhancements to the eofblocks scanner that
facilitate running a scan in the context of a write. Patch 4 adds the
actual scan-on-ENOSPC policy. Patch 5 updates the preallocation
throttling algorithm to take quota free space into account.

Thoughts, reviews, flames appreciated.

Brian

Brian Foster (5):
  xfs: do eofb filtering before dirty check
  xfs: add flush flag to xfs_eofblocks
  xfs: add scan owner field to xfs_eofblocks
  xfs: run an eofblocks scan on ENOSPC/EDQUOT
  xfs: squash prealloc while over quota free space as well

 fs/xfs/xfs_dquot.h  | 15 +++++++++
 fs/xfs/xfs_file.c   | 32 +++++++++++++++++--
 fs/xfs/xfs_fs.h     |  4 ++-
 fs/xfs/xfs_icache.c | 90 +++++++++++++++++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_icache.h |  3 ++
 fs/xfs/xfs_iomap.c  | 20 ++++++++----
 6 files changed, 145 insertions(+), 19 deletions(-)

-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
