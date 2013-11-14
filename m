Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 797CC7F54
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 14:54:05 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3DC99304039
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 12:54:05 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2QMNymL7Q89Nj4EP for
	<xfs@oss.sgi.com>; Thu, 14 Nov 2013 12:54:03 -0800 (PST)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rAEKs3Vc025669
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 15:54:03 -0500
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id rAEKs2ro001089
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 15:54:02 -0500
Message-ID: <5285386A.8020800@redhat.com>
Date: Thu, 14 Nov 2013 14:54:02 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: Fix stray semicolon in libxfs/rdwr.c
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
To: xfs-oss <xfs@oss.sgi.com>

The commit:

800db1c1 libxfs: refactor libxfs_buf_read_map for xfs_db

introduced a stray semicolon during the refactoring.  Luckily it
only breaks the error case.

(Caught by Coverity, CID 1128894)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 0aa2eba..0219a08 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -754,7 +754,7 @@ libxfs_readbufr_map(struct xfs_buftarg *btp, struct xfs_buf *bp,
 		offset += len;
 	}
 
-	if (!error);
+	if (!error)
 		bp->b_flags |= LIBXFS_B_UPTODATE;
 #ifdef IO_DEBUG
 	printf("%lx: %s: read %u bytes, error %d, blkno=0x%llx(0x%llx), %p\n",

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
