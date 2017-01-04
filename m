Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48056 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759138AbdADTmE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Jan 2017 14:42:04 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfsdump: handle bind mount targets
Message-ID: <2334e0d3-dde7-eb4b-2bf5-bd0457cf5912@redhat.com>
Date: Wed, 4 Jan 2017 13:42:02 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: Jason L Tibbitts III <tibbs@math.uh.edu>

Today, xfsdump looks at the mount point it was handed, gets
the inode of that directory, and assumes that it is the
filesystem's root inode.

This doesn't work if we have bind-mounted a subdirectory
somewhere, and point xfsdump at that.  The inode number retrieved
is not the filesystem's root inode number, and because this
goes into the dump header and gets checked on restore, things
go badly when the root inode found in the dump does not match
the root inode in the dump header:

# mkfs.xfs -dfile,name=fsfile,size=16g
# mkdir mnt
# mount -o loop fsfile mnt
# mkdir -p mnt/dir
# mkdir -p mnt2/dir
# mount -o bind mnt/dir mnt2/dir
# xfsdump -v trace -J -F -l 0 -  `pwd`/mnt2/dir | xfsdump/restore/xfsrestore -v trace -t - 
...
xfsrestore: tree.c:759: tree_begindir: Assertion `ino != persp->p_rootino || hardh == persp->p_rooth' failed.
#

Fix this by using bulkstat to get the first valid inode in the filesystem.
Compare this to the inode number of the mounted directory, and if they
differ, issue a notice that this may be a bind mount (which means that
more than just the tree under the mount will be dumped; the whole
filesystem is dumped by default).

Reported-by: Jason L Tibbitts III <tibbs@math.uh.edu>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

This passes xfstests dump group, FWIW, as well as the
testcase above (which probably should get turned into a test)

diff --git a/dump/content.c b/dump/content.c
index 1e86292..5a3c02f 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -1381,10 +1381,17 @@ baseuuidbypass:
 	}
 
 	/* figure out the ino for the root directory of the fs
-	 * and get its xfs_bstat_t for inomap_build()
+	 * and get its xfs_bstat_t for inomap_build().  This could
+	 * be a bind mount; don't ask for the mount point inode,
+	 * find the actual lowest inode number in the filesystem.
 	 */
 	{
 		stat64_t rootstat;
+		xfs_ino_t lastino = 0;
+		int ocount = 0;
+		xfs_fsop_bulkreq_t bulkreq;
+
+		/* Get the inode of the mount point */
 		rval = fstat64( sc_fsfd, &rootstat );
 		if ( rval ) {
 			mlog( MLOG_NORMAL, _(
@@ -1396,11 +1403,21 @@ baseuuidbypass:
 			( xfs_bstat_t * )calloc( 1, sizeof( xfs_bstat_t ));
 		assert( sc_rootxfsstatp );
 
-		if ( bigstat_one( sc_fsfd, rootstat.st_ino, sc_rootxfsstatp) < 0 ) {
+		/* Get the first valid (i.e. root) inode in this fs */
+		bulkreq.lastip = (__u64 *)&lastino;
+		bulkreq.icount = 1;
+		bulkreq.ubuffer = sc_rootxfsstatp;
+		bulkreq.ocount = &ocount;
+		if (ioctl(sc_fsfd, XFS_IOC_FSBULKSTAT, &bulkreq) < 0) {
 			mlog( MLOG_ERROR,
 			      _("failed to get bulkstat information for root inode\n"));
 			return BOOL_FALSE;
 		}
+
+		if (sc_rootxfsstatp->bs_ino != rootstat.st_ino)
+			mlog ( MLOG_NORMAL | MLOG_NOTE,
+			       _("root ino %lld differs from mount dir ino %lld, bind mount?\n"),
+			         sc_rootxfsstatp->bs_ino, rootstat.st_ino);
 	}
 	
 	/* alloc a file system handle, to be used with the jdm_open()



