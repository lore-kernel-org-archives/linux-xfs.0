Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7FFF77F3F
	for <xfs@oss.sgi.com>; Sat,  6 Sep 2014 12:46:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6EDF28F8039
	for <xfs@oss.sgi.com>; Sat,  6 Sep 2014 10:46:10 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id kypjftlLYLYIsGx3 for <xfs@oss.sgi.com>;
	Sat, 06 Sep 2014 10:46:06 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 3974A60FCA5B
	for <xfs@oss.sgi.com>; Sat,  6 Sep 2014 12:46:05 -0500 (CDT)
Message-ID: <540B485F.8070502@sandeen.net>
Date: Sat, 06 Sep 2014 12:46:07 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 1/2] xfs_db: fix inode CRC validity state, and warn on read
	if invalid
References: <540B4399.4020804@sandeen.net>
In-Reply-To: <540B4399.4020804@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Currently, the "ino_crc_ok" field on the io cursor
reflects overall inode validity, not CRC correctness.
Because it is only used when printing CRC validity,
change it to reflect only that.

In addition, when reading an inode, print the current
CRC state.

Note, if specifying an inode which doesn't actually
exist, this will claim corruption; I'm not sure if
that's good or bad.  Today, it already issues corruption
errors on the way; this adds a new message as well ;)

xfs_db> inode 129
Metadata corruption detected at block 0x80/0x2000
Metadata corruption detected at block 0x80/0x2000
...
Metadata CRC error detected for ino 129

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/db/inode.c b/db/inode.c
index 24170ba..244d03b 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -684,13 +684,18 @@ set_cur_inode(
  		numblks, DB_RING_IGN, NULL);
  	off_cur(offset << mp->m_sb.sb_inodelog, mp->m_sb.sb_inodesize);
  	dip = iocur_top->data;
-	iocur_top->ino_crc_ok = libxfs_dinode_verify(mp, ino, dip);
+	iocur_top->ino_crc_ok = xfs_verify_cksum((char *)dip,
+						 mp->m_sb.sb_inodesize,
+						 XFS_DINODE_CRC_OFF);
  	iocur_top->ino_buf = 1;
  	iocur_top->ino = ino;
  	iocur_top->mode = be16_to_cpu(dip->di_mode);
  	if ((iocur_top->mode & S_IFMT) == S_IFDIR)
  		iocur_top->dirino = ino;
  
+	if (xfs_sb_version_hascrc(&mp->m_sb) && !iocur_top->ino_crc_ok)
+		dbprintf(_("Metadata CRC error detected for ino %lld\n"), ino);
+
  	/* track updated info in ring */
  	ring_add();
  }
diff --git a/db/io.c b/db/io.c
index 7f1b76a..93ebf5c 100644
--- a/db/io.c
+++ b/db/io.c
@@ -473,6 +473,17 @@ write_cur(void)
  		write_cur_bbs();
  	else
  		write_cur_buf();
+
+	if (iocur_top->ino_buf) {
+		xfs_dinode_t    *dip;
+		xfs_ino_t       ino;
+
+		dip = iocur_top->data;
+		ino = iocur_top->ino;
+		iocur_top->ino_crc_ok = xfs_verify_cksum((char *)dip,
+						 mp->m_sb.sb_inodesize,
+						 XFS_DINODE_CRC_OFF);
+	}
  }
  
  void


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
