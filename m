Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6DA9WYQ139495 for <xfs@oss.sgi.com>; Fri, 13 Jul 2012 05:09:32 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BD5FD8F8049
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2012 03:09:29 -0700 (PDT)
Received: from [134.15.68.149] (cf-vpn-sw-corp-68-149.corp.sgi.com
	[134.15.68.149])
	by estes.americas.sgi.com (Postfix) with ESMTP id 4718870017D6
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2012 05:09:29 -0500 (CDT)
Message-ID: <4FFFF3D8.7060001@sgi.com>
Date: Fri, 13 Jul 2012 12:09:28 +0200
From: Alain Renaud <arenaud@sgi.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: prevent xfs_bmap_extsize_align() to exceed maximum extent
	size.
References: <20120712154554.377970666@sgi.com>
In-Reply-To: <20120712154554.377970666@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

xfs: prevent xfs_bmap_extsize_align() to exceed maximum extent size.

When trying to do preallocation that exceed the the maximum size of
an extent, the extsize alignment can exceed this value.
We are already trying to solve this issue for delay allocation but we
have the same with prealloc. So I think the simple solution is to limit
the size in xfs_bmap_extsize_align() and remove the code specific to
delay allocation.

We do have a simple test case to confirm that the problem exist.

# cd /xfs_dir/
# xfs_io -c 'extsize 4m' .
# xfs_io -f -c 'resvsp 0 8g' test_file
XFS_IOC_RESVSP64: No space left on device

Signed-off-by: Alain Renaud <arenaud@sgi.com>

---
  fs/xfs/xfs_bmap.c |   12 +++++-------
  1 file changed, 5 insertions(+), 7 deletions(-)

Index: b/fs/xfs/xfs_bmap.c
===================================================================
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -1912,6 +1912,11 @@ xfs_bmap_extsize_align(
  		align_alen += extsz - temp;
  	}
  	/*
+	 * Make sure we do not exceed the maximum len of an extent.
+	 */
+	align_alen = XFS_FILBLKS_MIN(align_alen,
+				     MAXEXTLEN - (MAXEXTLEN % extsz));
+	/*
  	 * If the previous block overlaps with this proposed allocation
  	 * then move the start forward without adjusting the length.
  	 */
@@ -4450,13 +4455,6 @@ xfs_bmapi_reserve_delalloc(
  	/* Figure out the extent size, adjust alen */
  	extsz = xfs_get_extsz_hint(ip);
  	if (extsz) {
-		/*
-		 * Make sure we don't exceed a single extent length when we
-		 * align the extent by reducing length we are going to
-		 * allocate by the maximum amount extent size aligment may
-		 * require.
-		 */
-		alen = XFS_FILBLKS_MIN(len, MAXEXTLEN - (2 * extsz - 1));
  		error = xfs_bmap_extsize_align(mp, got, prev, extsz, rt, eof,
  					       1, 0, &aoff, &alen);
  		ASSERT(!error);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
