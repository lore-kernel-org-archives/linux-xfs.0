Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o14Hldw4080167 for <xfs@oss.sgi.com>; Thu, 4 Feb 2010 11:47:40 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D6977137B519
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2010 09:48:49 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 96Cd6tqr4zVqOTj9 for
	<xfs@oss.sgi.com>; Thu, 04 Feb 2010 09:48:49 -0800 (PST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o14Hmn25023698
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 4 Feb 2010 12:48:49 -0500
Message-ID: <4B6B087F.80901@sandeen.net>
Date: Thu, 04 Feb 2010 11:48:47 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] mkfs: don't try to detect filesystems on regular files
	via	blkid
References: <4B6AF6FC.6030101@redhat.com>
In-Reply-To: <4B6AF6FC.6030101@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Jim Meyering <meyering@redhat.com>, xfs mailing list <xfs@oss.sgi.com>

from RH bug 
https://bugzilla.redhat.com/show_bug.cgi?id=561870

# dd if=/dev/zero of=k bs=1MB count=2 seek=20; mkfs.xfs k 
# mkfs.xfs: probe of k failed, cannot detect existing filesystem.
# mkfs.xfs: Use the -f option to force overwrite.

blkid fails to do a probe of a regular file.

I wish blkid would cope with this, but for now it might
be better to just turn it off.

I kept the size==0 check just in case we stumble on a 0-sized
device, blkid doesn't like that either...

Reported-by: Jim Meyering <meyering@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: use fstat after the open

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 9baf116..219c81e 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -300,6 +300,7 @@ check_overwrite(
 	int		fd;
 	long long	size;
 	int		bsz;
+	struct stat	statbuf;
 
 	if (!device || !*device)
 		return 0;
@@ -309,6 +310,14 @@ check_overwrite(
 	fd = open(device, O_RDONLY);
 	if (fd < 0)
 		goto out;
+
+	/* blkid can't get info from a regular file */
+	if (!fstat(fd, &statbuf) && S_ISREG(statbuf.st_mode)) {
+		close(fd);
+		ret = 0;
+		goto out;
+	}
+
 	platform_findsizes(device, fd, &size, &bsz);
 	close(fd);
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
