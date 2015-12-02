Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D269F7F5A
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 14:45:18 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 51D2EAC001
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 12:45:18 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	zGmEcEqHH07dVTNA for <xfs@oss.sgi.com>;
	Wed, 02 Dec 2015 12:45:16 -0800 (PST)
Date: Thu, 3 Dec 2015 07:45:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests failures with xfs, dax and v4.4-rc3
Message-ID: <20151202204502.GI19199@dastard>
References: <20151202183438.GA1319@linux.intel.com>
	<20151202202910.GH19199@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151202202910.GH19199@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ross Zwisler <ross.zwisler@linux.intel.com>, xfs@oss.sgi.com, Brian Foster <bfoster@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>

On Thu, Dec 03, 2015 at 07:29:10AM +1100, Dave Chinner wrote:
> On Wed, Dec 02, 2015 at 11:34:38AM -0700, Ross Zwisler wrote:
> > I'm hitting a few more test failures in my testing setup with v4.4-rc3, xfs
> > and DAX.  My test setup is a pair of 4GiB PMEM partitions in a KVM virtual
> > machine.  Here are the failures:
> 
> Which are caused by commit 1ca1915 ("xfs: Don't use unwritten extents
> for DAX") because of this code for unwritten extent conversion in
> get_blocks:
> 
> 	tp->t_flags |= XFS_TRANS_RESERVE;
> 
> It's a minor problem compared to all the other issues DAX has right
> now, so I ignored it to get the bigger problem solved first.

Patch to fix the problem below.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: Don't use reserved blocks for data blocks with DAX

From: Dave Chinner <dchinner@redhat.com>

Commit 1ca1915 ("xfs: Don't use unwritten extents for DAX") enabled
the DAX allocation call to dip into the reserve pool in case it was
converting unwritten extents rather than allocating blocks. This was
a direct copy of the unwritten extent conversion code, but had an
unintended side effect of allowing normal data block allocation to
use the reserve pool. Hence normal block allocation could deplete
the reserve pool and prevent unwritten extent conversion at ENOSPC,
hence violating fallocate guarantees on preallocated space.

Fix it by checking whether the incoming map from __xfs_get_blocks()
spans an unwritten extent and only use the reserve pool if the
allocation covers an unwritten extent.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iomap.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index f4f5b43..9ed146b 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -203,15 +203,20 @@ xfs_iomap_write_direct(
 	 * this outside the transaction context, but if we commit and then crash
 	 * we may not have zeroed the blocks and this will be exposed on
 	 * recovery of the allocation. Hence we must zero before commit.
+	 *
 	 * Further, if we are mapping unwritten extents here, we need to zero
 	 * and convert them to written so that we don't need an unwritten extent
 	 * callback for DAX. This also means that we need to be able to dip into
-	 * the reserve block pool if there is no space left but we need to do
-	 * unwritten extent conversion.
+	 * the reserve block pool for bmbt block allocation if there is no space
+	 * left but we need to do unwritten extent conversion.
 	 */
+
 	if (IS_DAX(VFS_I(ip))) {
 		bmapi_flags = XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO;
-		tp->t_flags |= XFS_TRANS_RESERVE;
+		if (ISUNWRITTEN(imap)) {
+			tp->t_flags |= XFS_TRANS_RESERVE;
+			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1;
+		}
 	}
 	error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
 				  resblks, resrtextents);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
