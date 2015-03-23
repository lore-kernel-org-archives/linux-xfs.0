Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 183527F4E
	for <xfs@oss.sgi.com>; Mon, 23 Mar 2015 15:11:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DBC09304043
	for <xfs@oss.sgi.com>; Mon, 23 Mar 2015 13:11:27 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id n3GGKLROMoT0MmLk for <xfs@oss.sgi.com>;
	Mon, 23 Mar 2015 13:11:26 -0700 (PDT)
Message-ID: <5510736D.8020307@sandeen.net>
Date: Mon, 23 Mar 2015 15:11:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 02/13 V2] xfs_db: fix inode CRC validity state, and warn on
	read if invalid
References: <1426624395-8258-1-git-send-email-sandeen@redhat.com>
	<1426624395-8258-3-git-send-email-sandeen@redhat.com>
In-Reply-To: <1426624395-8258-3-git-send-email-sandeen@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

Currently, the "ino_crc_ok" field on the io cursor reflects
overall inode validity, not CRC correctness.  Because it is
only used when printing CRC validity, change it to reflect
only that state - and update it whenever we re-write the
inode (thus updating the CRC).

In addition, when reading an inode, warn if the CRC is bad.

Note, when specifying an inode which doesn't actually exist,
this will claim corruption; I'm not sure if that's good or
bad. Today, it already issues corruption errors on the way;
this adds a new message as well:

xfs_db> inode 129
Metadata corruption detected at block 0x80/0x2000
Metadata corruption detected at block 0x80/0x2000
...
Metadata CRC error detected for ino 129

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: move ino_crc_ok calculations under "if (xfs_sb_version_hascrc())"

diff --git a/db/inode.c b/db/inode.c
index 24170ba..4f9c65d 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -684,13 +684,22 @@ set_cur_inode(
 		numblks, DB_RING_IGN, NULL);
 	off_cur(offset << mp->m_sb.sb_inodelog, mp->m_sb.sb_inodesize);
 	dip = iocur_top->data;
-	iocur_top->ino_crc_ok = libxfs_dinode_verify(mp, ino, dip);
 	iocur_top->ino_buf = 1;
 	iocur_top->ino = ino;
 	iocur_top->mode = be16_to_cpu(dip->di_mode);
 	if ((iocur_top->mode & S_IFMT) == S_IFDIR)
 		iocur_top->dirino = ino;
 
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		iocur_top->ino_crc_ok = libxfs_verify_cksum((char *)dip,
+						    mp->m_sb.sb_inodesize,
+						    XFS_DINODE_CRC_OFF);
+		if (!iocur_top->ino_crc_ok)
+			dbprintf(
+_("Metadata CRC error detected for ino %lld\n"),
+				ino);
+	}
+
 	/* track updated info in ring */
 	ring_add();
 }
diff --git a/db/io.c b/db/io.c
index c5898f1..d906123 100644
--- a/db/io.c
+++ b/db/io.c
@@ -471,8 +471,10 @@ write_cur(void)
 		return;
 	}
 
-	if (iocur_top->ino_buf)
+	if (xfs_sb_version_hascrc(&mp->m_sb) && iocur_top->ino_buf) {
 		libxfs_dinode_calc_crc(mp, iocur_top->data);
+		iocur_top->ino_crc_ok = 1;
+	}
 	if (iocur_top->dquot_buf)
 		xfs_update_cksum(iocur_top->data, sizeof(struct xfs_dqblk),
 				 XFS_DQUOT_CRC_OFF);
diff --git a/include/libxfs.h b/include/libxfs.h
index 45a924f..962e319 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -782,6 +782,8 @@ extern uint32_t crc32c_le(uint32_t crc, unsigned char const *p, size_t len);
 
 #include <xfs/xfs_cksum.h>
 
+#define libxfs_verify_cksum	xfs_verify_cksum
+
 static inline int
 xfs_buf_verify_cksum(struct xfs_buf *bp, unsigned long cksum_offset)
 {


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
