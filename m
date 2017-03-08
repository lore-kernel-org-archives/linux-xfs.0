Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41444 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753818AbdCHSmD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Mar 2017 13:42:03 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7E7E380477
        for <linux-xfs@vger.kernel.org>; Wed,  8 Mar 2017 18:40:18 +0000 (UTC)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH] repair: handle reading superblock from image on larger sector size filesystem
Date: Thu,  9 Mar 2017 02:40:07 +0800
Message-Id: <1488998407-9094-1-git-send-email-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: zlang@redhat.com

Due to xfs_repair uses direct IO, sometimes it can't read superblock
from an image file has smaller sector size than host filesystem.
Especially that superblock doesn't align with host filesystem's
sector size.

To avoid this, when direct read returns EINVAL, turn off direct IO,
then try to read again.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

I found this bug when I try to modify xfstests' xfs/078 on s390x,
manually reproduce this bug by below steps:

    [root@ibm-z-32 ~]# blockdev --getss --getpbsz --getbsz  /dev/dasda1
    4096
    4096
    4096
    [root@ibm-z-32 ~]# truncate -s $((168024*1024)) fsfile
    [root@ibm-z-32 ~]# echo $((168024*1024))
    172056576
    [root@ibm-z-32 ~]# losetup /dev/loop0 fsfile
    [root@ibm-z-32 ~]# mkfs.xfs -f -b size=1k /dev/loop0
    meta-data=/dev/loop0             isize=512    agcount=4, agsize=42006 blks
             =                       sectsz=512   attr=2, projid32bit=1
             =                       crc=1        finobt=0, sparse=0
    data     =                       bsize=1024   blocks=168024, imaxpct=25
             =                       sunit=0      swidth=0 blks
    naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
    log      =internal log           bsize=1024   blocks=2573, version=2
             =                       sectsz=512   sunit=0 blks, lazy-count=1
    realtime =none                   extsz=4096   blocks=0, rtextents=0
    [root@ibm-z-32 ~]# losetup -d /dev/loop0
    [root@ibm-z-32 ~]# xfs_io -c "pwrite 688230400 1024" fsfile
    wrote 1024/1024 bytes at offset 688230400
    1 KiB, 1 ops; 0.0000 sec (13.563 MiB/sec and 13888.8889 ops/sec)
    [root@ibm-z-32 ~]# losetup /dev/loop0 fsfile
    [root@ibm-z-32 ~]# mount /dev/loop0 /mnt/test
    [root@ibm-z-32 ~]# xfs_growfs /mnt/test
    meta-data=/dev/loop0             isize=512    agcount=4, agsize=42006 blks
             =                       sectsz=512   attr=2, projid32bit=1
             =                       crc=1        finobt=0 spinodes=0
    data     =                       bsize=1024   blocks=168024, imaxpct=25
             =                       sunit=0      swidth=0 blks
    naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
    log      =internal               bsize=1024   blocks=2573, version=2
             =                       sectsz=512   sunit=0 blks, lazy-count=1
    realtime =none                   extsz=4096   blocks=0, rtextents=0
    data blocks changed from 168024 to 672096
    [root@ibm-z-32 ~]# umount -d /mnt/test
    [root@ibm-z-32 ~]# losetup -a
    [root@ibm-z-32 ~]# xfs_repair -f -n fsfile
    Phase 1 - find and verify superblock...
    superblock read failed, offset 43014144, size 131072, ag 1, rval -1
     
    fatal error -- Invalid argument


To avoid this problem, I use the same way as Dave did in:

  f63fd26 repair: handle repair of image files on large sector size filesystems

So there're some duplicate code in "fcntl" part, I want to pick up
this part to be a common function in xfsprogs or xfsprogs/repair,
but I don't know where's the proper place and if that's necessary?

Thanks,
Zorro

 repair/sb.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/repair/sb.c b/repair/sb.c
index 77e5154..617ad98 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -567,11 +567,32 @@ get_sb(xfs_sb_t *sbp, xfs_off_t off, int size, xfs_agnumber_t agno)
 	}
 
 	if ((rval = read(x.dfd, buf, size)) != size)  {
+		/*
+		 * If file image sector is smaller than the host filesystem
+		 * sector, this O_DIRECT read will return EINVAL. So turn
+		 * off O_DIRECT and try to buffer read.
+		 */
+		if (errno == EINVAL) {
+			long old_flags;
+
+			old_flags = fcntl(x.dfd, F_GETFL, 0);
+			if (fcntl(x.dfd, F_SETFL, old_flags & ~O_DIRECT) < 0) {
+				do_warn(
+        _("Sector size on host filesystem larger than image sector size.\n"
+          "Cannot turn off direct IO, so exiting.\n"));
+				exit(1);
+			} else if ((rval = read(x.dfd, buf, size)) == size) {
+				errno = 0;
+			}
+		}
 		error = errno;
-		do_warn(
+		if (error != 0) {
+			do_warn(
 	_("superblock read failed, offset %" PRId64 ", size %d, ag %u, rval %d\n"),
 			off, size, agno, rval);
-		do_error("%s\n", strerror(error));
+			do_error("%s\n", strerror(error));
+		}
+
 	}
 	libxfs_sb_from_disk(sbp, buf);
 
-- 
2.7.4

