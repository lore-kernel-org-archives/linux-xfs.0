Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 899F27F37
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 20:43:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6A13A8F8035
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 18:43:58 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Coh5llqlgvGzi0qG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Aug 2015 18:43:56 -0700 (PDT)
Subject: [PATCH 02/10] xfs_db: don't crash on a corrupt inode
From: "Darrick J. Wong" <djwong@alder.djwong.org>
Date: Fri, 14 Aug 2015 18:43:51 -0700
Message-ID: <20150815014351.1839.81382.stgit@birch.djwong.org>
In-Reply-To: <20150815014338.1839.37405.stgit@birch.djwong.org>
References: <20150815014338.1839.37405.stgit@birch.djwong.org>
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

If the user selects a corrupt inode via the 'inode XXX' command, the
read verifier will fail and the io cursor at the top of the ring will
not have any data attached.  When this is the case, we cannot
dereference the NULL pointer or xfs_db will crash.  Therefore, check
the buffer pointer before using it.

It's arguable that we ought to retry the read without the verifiers
if the inode is corrupt or fails CRC, since this /is/ a debugging
tool, and maybe you wanted the contents anyway.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/inode.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/db/inode.c b/db/inode.c
index e86dabd..64b263b 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -682,6 +682,8 @@ set_cur_inode(
 	set_cur(&typtab[TYP_INODE], XFS_AGB_TO_DADDR(mp, agno, cluster_agbno),
 		numblks, DB_RING_IGN, NULL);
 	off_cur(offset << mp->m_sb.sb_inodelog, mp->m_sb.sb_inodesize);
+	if (!iocur_top->data)
+		return;
 	dip = iocur_top->data;
 	iocur_top->ino_buf = 1;
 	iocur_top->ino = ino;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
