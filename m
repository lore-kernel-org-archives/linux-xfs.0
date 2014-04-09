Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A1F717F5F
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 15:30:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7756E8F8052
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 13:30:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0b8x9zpAAoz73Cbf for
	<xfs@oss.sgi.com>; Wed, 09 Apr 2014 13:30:50 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s39KUnRB032007
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2014 16:30:49 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s39KUmTh007548
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 9 Apr 2014 16:30:49 -0400
Message-ID: <5345ADF9.2030402@redhat.com>
Date: Wed, 09 Apr 2014 15:30:49 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: remove pointless pointer increment in
	xfs_dir2_block_compact()
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

xfs_dir2_block_compact() is passed a pointer to *blp, and
advances it locally - but nobody uses the pointer (locally)
after that.

This behavior came about as part of prior refactoring,

20f7e9f xfs: factor dir2 block read operations

and looking at the code as it was before, it seems quite clear
that this change introduced a bug; the pre-refactoring code
expects blp to be modified after compaction.
And indeed it did; see this commit which fixed it:

37f1356 xfs: recalculate leaf entry pointer after compacting a dir2 block

So the bug was introduced & resolved in the 3.8 cycle.

Whoops.  Well, it's fixed now, and mystery solved; just remove
the now-pointless local increment of the blp pointer.

(I guess we should have run clang earlier!)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
index 4f6a38c..5259939 100644
--- a/fs/xfs/xfs_dir2_block.c
+++ b/fs/xfs/xfs_dir2_block.c
@@ -319,7 +319,6 @@ xfs_dir2_block_compact(
 		(xfs_dir2_data_aoff_t)((char *)blp - (char *)hdr),
 		(xfs_dir2_data_aoff_t)((be32_to_cpu(btp->stale) - 1) * sizeof(*blp)),
 		needlog, &needscan);
-	blp += be32_to_cpu(btp->stale) - 1;
 	btp->stale = cpu_to_be32(1);
 	/*
 	 * If we now need to rebuild the bestfree map, do so.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
