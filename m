Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1BJ5asQ206866 for <xfs@oss.sgi.com>; Fri, 11 Feb 2011 13:05:36 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EC8EB12888A2
	for <xfs@oss.sgi.com>; Fri, 11 Feb 2011 11:08:10 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4cWxUEcZFp3h3iqY for
	<xfs@oss.sgi.com>; Fri, 11 Feb 2011 11:08:10 -0800 (PST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1BJ8Aoj026278
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 11 Feb 2011 14:08:10 -0500
Received: from segfault.boston.devel.redhat.com
	(segfault.boston.devel.redhat.com [10.16.60.26])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id p1BJ89VE022328
	for <xfs@oss.sgi.com>; Fri, 11 Feb 2011 14:08:09 -0500
From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch][xfstests-dev] aiodio_sparse2: fix up alignment for 4k logical
	block sized devices
Date: Fri, 11 Feb 2011 14:08:09 -0500
Message-ID: <x49y65m8k4m.fsf@segfault.boston.devel.redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

When running xfstests on a 4k logical sector device, I ran into a test
failure in test 198.  The errors were all due to trying to do 512 byte
aligned I/O on a 4k logical sector device.  The attached patch tries to
auto-detect the proper block size if no alignment is specified.  If it
fails for one reason or another, it defaults to 4k alignment.  This
seems to work fine in my test rig.

Cheers,
Jeff

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/src/aio-dio-regress/aiodio_sparse2.c b/src/aio-dio-regress/aiodio_sparse2.c
index f1225dd..0a96479 100644
--- a/src/aio-dio-regress/aiodio_sparse2.c
+++ b/src/aio-dio-regress/aiodio_sparse2.c
@@ -19,6 +19,8 @@
 #include <limits.h>
 #include <sys/mman.h>
 #include <sys/wait.h>
+#include <sys/ioctl.h>
+#include <sys/mount.h> // for BLKSSZGET
 
 #include <libaio.h>
 
@@ -274,6 +276,23 @@ void dirty_freeblocks(char *filename, int size)
 	unlink(filename2);
 }
 
+static long get_logical_block_size(char *filename)
+{
+	int fd;
+	int ret;
+	int logical_block_size;
+
+	fd = open(filename, O_RDONLY);
+	if (fd < 0)
+		return 4096;
+
+	ret = ioctl(fd, BLKSSZGET, &logical_block_size);
+	close(fd);
+	if (ret < 0)
+		return 4096;
+	return logical_block_size;
+}
+
 void usage()
 {
 	fprintf(stderr, "usage: dio_sparse [-n step] [-s filesize]"
@@ -314,7 +333,7 @@ long long scale_by_kmg(long long value, char scale)
 int main(int argc, char **argv)
 {
 	char filename[PATH_MAX];
-	long alignment = 512;
+	long alignment = 0;
 	int readsize = 65536;
 	int writesize = 65536;
 	int startoffset = 0;
@@ -376,6 +395,8 @@ int main(int argc, char **argv)
 
 	strncpy(filename, argv[argc-1], PATH_MAX);
 
+	if (alignment == 0)
+		alignment = get_logical_block_size(filename);
 	/*
 	 * Create some dirty free blocks by allocating, writing, syncing,
 	 * and then unlinking and freeing.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
