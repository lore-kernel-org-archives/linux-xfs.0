Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D10927F3F
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 08:33:33 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A9104304064
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 06:33:30 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FTisEYZH21eTLa2u for
	<xfs@oss.sgi.com>; Mon, 10 Feb 2014 06:33:29 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s1AEXTnR025632
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 09:33:29 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s1AEXR1v019172
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 09:33:28 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: avoid AGI/AGF deadlock scenario for inode chunk
	allocation
Date: Mon, 10 Feb 2014 09:33:27 -0500
Message-Id: <1392042807-41697-1-git-send-email-bfoster@redhat.com>
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

The inode chunk allocation path can lead to deadlock conditions if
a transaction is dirtied with an AGF (to fix up the freelist) for
an AG that cannot satisfy the actual allocation request. This code
path is written to try and avoid this scenario, but it can be
reproduced by running xfstests generic/270 in a loop on a 512b fs.

An example situation is:
- process A attempts an inode allocation on AG 3, modifies
  the freelist, fails the allocation and ultimately moves on to
  AG 0 with the AG 3 AGF held
- process B is doing a free space operation (i.e., truncate) and
  acquires the AG 0 AGF, waits on the AG 3 AGF
- process A acquires the AG 0 AGI, waits on the AG 0 AGF (deadlock)

The problem here is that process A acquired the AG 3 AGF while
moving on to AG 0 (and releasing the AG 3 AGI with the AG 3 AGF
held). xfs_dialloc() makes one pass through each of the AGs when
attempting to allocate an inode chunk. The expectation is a clean
transaction if a particular AG cannot satisfy the allocation
request. xfs_ialloc_ag_alloc() is written to support this through
use of the minalignslop allocation args field.

When using the agi->agi_newino optimization, we attempt an exact
bno allocation request based on the location of the previously
allocated chunk. minalignslop is set to inform the allocator that
we will require alignment on this chunk, and thus to not allow the
request for this AG if the extra space is not available. Suppose
that the AG in question has just enough space for this request, but
not at the requested bno. xfs_alloc_fix_freelist() will proceed as
normal as it determines the request should succeed, and thus it is
allowed to modify the agf. xfs_alloc_ag_vextent() ultimately fails
because the requested bno is not available. In response, the caller
moves on to a NEAR_BNO allocation request for the same AG. The
alignment is set, but the minalignslop field is never reset. This
increases the overall requirement of the request from the first
attempt. If this delta is the difference between allocation success
and failure for the AG, xfs_alloc_fix_freelist() rejects this
request outright the second time around and causes the allocation
request to unnecessarily fail for this AG.

To address this situation, reset the minalignslop field when we
transition from a THIS_BNO to a NEAR_BNO allocation request in
xfs_ialloc_ag_alloc().

[NOTE: It appears at first glance that the optimized agi_newino
 allocation case is problematic in that it doesn't consider use of
 mp->m_sinoalign, if enabled. If the m_sinoalign allocation fails,
 however, we revert back to normal cluster alignment, which I think
 makes the overall sequence safe.]

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_ialloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 5d7f105..584daf0 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -382,6 +382,8 @@ xfs_ialloc_ag_alloc(
 			isaligned = 1;
 		} else
 			args.alignment = xfs_ialloc_cluster_alignment(&args);
+		args.minalignslop = 0;
+
 		/*
 		 * Need to figure out where to allocate the inode blocks.
 		 * Ideally they should be spaced out through the a.g.
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
