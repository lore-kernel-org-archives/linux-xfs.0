Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6C7C37CA0
	for <xfs@oss.sgi.com>; Thu, 15 Sep 2016 18:24:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3946530407A
	for <xfs@oss.sgi.com>; Thu, 15 Sep 2016 16:24:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id X9W2cFXmzLjveEso (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 15 Sep 2016 16:24:00 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_quota: fix free command for foreign fs
Message-ID: <4a5fdfec-d1a7-cef6-ba3d-50703dc56d44@redhat.com>
Date: Thu, 15 Sep 2016 18:23:58 -0500
MIME-Version: 1.0
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
To: xfs-oss <xfs@oss.sgi.com>, linux-xfs@vger.kernel.org

The "free" command is really just a fancy df that knows about
log space and realtime blocks for an xfs filesystem.

We can simply use statfs to get more or less the same thing
on a non-xfs filesystem, so, ah, do that I guess, and re-enable
it.

# quota/xfs_quota -f -x -c path -c free /mnt/test
          Filesystem          Pathname
[000] (F) /mnt/test           /dev/sdb1 (uquota)

Filesystem           1K-blocks       Used  Available  Use% Pathname
/dev/sdb1             20511356      45000   20466356    0% /mnt/test

Fix the short help text for -N while we're at it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/quota/free.c b/quota/free.c
index 3c8a5ce..cee15ee 100644
--- a/quota/free.c
+++ b/quota/free.c
@@ -77,34 +77,50 @@ mount_free_space_data(
 		close(fd);
 		return 0;
 	}
-	if ((xfsctl(mount->fs_dir, fd, XFS_IOC_FSGEOMETRY_V1, &fsgeo)) < 0) {
-		perror("XFS_IOC_FSGEOMETRY_V1");
-		close(fd);
-		return 0;
-	}
-	if ((xfsctl(mount->fs_dir, fd, XFS_IOC_FSCOUNTS, &fscounts)) < 0) {
-		perror("XFS_IOC_FSCOUNTS");
-		close(fd);
-		return 0;
+
+	if (!(mount->fs_flags & FS_FOREIGN)) {
+		if ((xfsctl(mount->fs_dir, fd, XFS_IOC_FSGEOMETRY_V1,
+							&fsgeo)) < 0) {
+			perror("XFS_IOC_FSGEOMETRY_V1");
+			close(fd);
+			return 0;
+		}
+		if ((xfsctl(mount->fs_dir, fd, XFS_IOC_FSCOUNTS,
+							&fscounts)) < 0) {
+			perror("XFS_IOC_FSCOUNTS");
+			close(fd);
+			return 0;
+		}
+
+		logsize = fsgeo.logstart ? fsgeo.logblocks : 0;
+		count = (fsgeo.datablocks - logsize) * fsgeo.blocksize;
+		free  = fscounts.freedata * fsgeo.blocksize;
+		*bcount = BTOBB(count);
+		*bfree  = BTOBB(free);
+		*bused  = BTOBB(count - free);
+
+		count = fsgeo.rtextents * fsgeo.rtextsize * fsgeo.blocksize;
+		free  = fscounts.freertx * fsgeo.rtextsize * fsgeo.blocksize;
+		*rcount = BTOBB(count);
+		*rfree  = BTOBB(free);
+		*rused  = BTOBB(count - free);
+	} else {
+		count = st.f_blocks * st.f_bsize;
+		free = st.f_bfree * st.f_bsize;
+		*bcount = BTOBB(count);
+		*bfree  = BTOBB(free);
+		*bused  = BTOBB(count - free);
+
+		*rcount = BTOBB(0);
+		*rfree  = BTOBB(0);
+		*rused  = BTOBB(0);
 	}
 
-	logsize = fsgeo.logstart ? fsgeo.logblocks : 0;
-	count = (fsgeo.datablocks - logsize) * fsgeo.blocksize;
-	free  = fscounts.freedata * fsgeo.blocksize;
-	*bcount = BTOBB(count);
-	*bfree  = BTOBB(free);
-	*bused  = BTOBB(count - free);
 
 	*icount = st.f_files;
 	*ifree  = st.f_ffree;
 	*iused  = st.f_files - st.f_ffree;
 
-	count = fsgeo.rtextents * fsgeo.rtextsize * fsgeo.blocksize;
-	free  = fscounts.freertx * fsgeo.rtextsize * fsgeo.blocksize;
-	*rcount = BTOBB(count);
-	*rfree  = BTOBB(free);
-	*rused  = BTOBB(count - free);
-
 	close(fd);
 	return 1;
 }
@@ -369,9 +385,10 @@ free_init(void)
 	free_cmd.cfunc = free_f;
 	free_cmd.argmin = 0;
 	free_cmd.argmax = -1;
-	free_cmd.args = _("[-bir] [-hn] [-f file]");
+	free_cmd.args = _("[-bir] [-hN] [-f file]");
 	free_cmd.oneline = _("show free and used counts for blocks and inodes");
 	free_cmd.help = free_help;
+	free_cmd.flags = CMD_FLAG_FOREIGN_OK;
 
 	add_command(&free_cmd);
 }


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
