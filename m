Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5BJMq81127761 for <xfs@oss.sgi.com>; Mon, 11 Jun 2012 14:22:53 -0500
Received: from whiskey.americas.sgi.com (whiskey.americas.sgi.com
	[128.162.233.19])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7BF64AC001
	for <xfs@oss.sgi.com>; Mon, 11 Jun 2012 12:22:49 -0700 (PDT)
Date: Mon, 11 Jun 2012 14:29:48 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH] xfs: xfs_release don't free eofblocks with extsize hint
Message-ID: <20120611192948.GX29173@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Testing has shown that there is a regression when using extent size
hints with NFS.  There are many more extents created than expected.

This is the workload, from a single NFS client:
# for e in `seq 1 8`;
do
	mkdir -p $e; (cd $e; dd if=/dev/zero of=file bs=4096k count=100) &
done

# xfs_io -c extsize .
[16777216] .

Here is the extent count for each file without this patch:

385 387 387 387 400 398 379 334

Here is the extent count with commit aff3a9ed reverted (using delayed
allocation):

3 4 2 3 4 4 3 3

In a comparison of traces, one with the above workload run locally and
the other with the above workload over NFS, there were occasional calls
to xfs_free_eofblocks in NFS but not on local workloads.  These turned
out to be from xfs_release.

Not calling xfs_free_eofblocks when using the extent size hint resolves this
issue when using extsize hints and NFS.  I suspect that delayed allocation
mitigated the effect of xfs_free_eofblocks until commit aff3a9ed.

Here is the extent count with this patch:

6 3 9 12 3 3 8 10

Signed-off-by: Ben Myers <bpm@sgi.com>

Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c
+++ xfs/fs/xfs/xfs_vnodeops.c
@@ -547,8 +547,9 @@ xfs_release(
 	if ((S_ISREG(ip->i_d.di_mode) &&
 	     (VFS_I(ip)->i_size > 0 ||
 	      (VN_CACHED(VFS_I(ip)) > 0 || ip->i_delayed_blks > 0)) &&
-	     (ip->i_df.if_flags & XFS_IFEXTENTS))  &&
-	    (!(ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)))) {
+	     (ip->i_df.if_flags & XFS_IFEXTENTS)) &&
+	    (!(ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC|XFS_DIFLAG_APPEND))) &&
+	    (!xfs_get_extsz_hint(ip))) {
 
 		/*
 		 * If we can't get the iolock just skip truncating the blocks
@@ -570,6 +571,11 @@ xfs_release(
 		 * release. Hence on the first dirty close we will still remove
 		 * the speculative allocation, but after that we will leave it
 		 * in place.
+		 *
+		 * Additionally, do not free eofblocks for files with the
+		 * extent size hint set.  This can cause excessive
+		 * fragmentation which is inconsistent with the intent
+		 * of the extsize feature.
 		 */
 		if (xfs_iflags_test(ip, XFS_IDIRTY_RELEASE))
 			return 0;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
