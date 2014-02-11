Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CFC817F50
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 12:00:43 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C13B2304043
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 10:00:40 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8eOPxxOsyzs8v9hW for
	<xfs@oss.sgi.com>; Tue, 11 Feb 2014 10:00:39 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s1BI0VRM010971
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 13:00:31 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s1BI0Sl1018835
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 13:00:28 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2] xfs: avoid AGI/AGF deadlock scenario for inode chunk
	allocation
Date: Tue, 11 Feb 2014 13:07:46 -0500
Message-Id: <1392142066-16174-1-git-send-email-bfoster@redhat.com>
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

To address this situation, reset the minalignslop field immediately
after use and prevent it from leaking into subsequent requests.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v2:
- Reset minalignslop immediately after use rather than prior to the
  subsequent request and add a comment. [dchinner]

 fs/xfs/xfs_ialloc.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 5d7f105..a57843f 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -363,6 +363,18 @@ xfs_ialloc_ag_alloc(
 		args.minleft = args.mp->m_in_maxlevels - 1;
 		if ((error = xfs_alloc_vextent(&args)))
 			return error;
+
+		/*
+		 * This request might have dirtied the transaction if the AG can
+		 * satisfy the request, but the exact block was not available. 
+		 * If the allocation did fail, subsequent requests will relax 
+		 * the exact agbno requirement and increase the alignment
+		 * instead. It is critical that the total size of the request
+		 * (len + alignment + slop) does not increase from this point
+		 * on, so reset minalignslop to ensure it is not included in
+		 * subsequent requests.
+		 */
+		args.minalignslop = 0;
 	} else
 		args.fsbno = NULLFSBLOCK;
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
