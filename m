Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 226207F3F
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 09:49:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9F529AC005
	for <xfs@oss.sgi.com>; Tue,  3 Jun 2014 07:49:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qW7DQqAwQSwVhI8s for
	<xfs@oss.sgi.com>; Tue, 03 Jun 2014 07:49:41 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s53EndTh006763
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Tue, 3 Jun 2014 10:49:39 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s53EndVO000387
	for <xfs@oss.sgi.com>; Tue, 3 Jun 2014 10:49:39 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 0/4] xfs: run eofblocks scan on ENOSPC
Date: Tue,  3 Jun 2014 10:49:34 -0400
Message-Id: <1401806978-59205-1-git-send-email-bfoster@redhat.com>
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

Here's v3 of the eofblocks scan on ENOSPC series. The primary change is
the insertion of patch 2, which implements a union inode filter for
eofblocks scans. This facilitates the EDQUOT handling in patch 3 to
cover multiple quotas with a single scan. Version 2 and associated
feedback is available here:

	http://oss.sgi.com/archives/xfs/2014-05/msg00527.html

There was also some discussion about dropping the iolock in favor of
introducing the scan owner field, but it's not clear if that is totally
safe. FWIW, the scan owner field is kernel only, so can be removed and
replaced with smarter locking any time down the road. Thoughts, reviews,
flames appreciated.

Brian

v3:
- Removed NULLFSINO check in eofblocks scan owner logic, added ASSERT.
- Added union-based eofblocks scan filter patch and use in quota ENOSPC
  scan.
v2:
- Drop flush mechanism during eofblocks scan (along with prereq patch).
- Simplify scan logic on ENOSPC. Separate EDQUOT from ENOSPC and tie
  ENOSPC scan to inode flush.
- Eliminate unnecessary project quota handling from
  xfs_inode_free_quota_eofblocks() (ENOSPC is a separate path).

Brian Foster (4):
  xfs: add scan owner field to xfs_eofblocks
  xfs: support a union-based filter for eofblocks scans
  xfs: run an eofblocks scan on ENOSPC/EDQUOT
  xfs: squash prealloc while over quota free space as well

 fs/xfs/xfs_dquot.h  | 15 +++++++++
 fs/xfs/xfs_file.c   | 23 ++++++++++---
 fs/xfs/xfs_fs.h     |  3 ++
 fs/xfs/xfs_icache.c | 96 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_icache.h |  3 ++
 fs/xfs/xfs_iomap.c  | 20 +++++++----
 6 files changed, 148 insertions(+), 12 deletions(-)

-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
