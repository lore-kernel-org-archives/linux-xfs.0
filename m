Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 32AF47F56
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2015 13:10:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C0A14AC00E
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2015 11:10:10 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id B3KTKR7ATDZ0KNw9 for <xfs@oss.sgi.com>;
	Thu, 20 Aug 2015 11:10:09 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id BC3A461D1A43
	for <xfs@oss.sgi.com>; Thu, 20 Aug 2015 13:10:08 -0500 (CDT)
Message-ID: <55D61800.2080802@sandeen.net>
Date: Thu, 20 Aug 2015 13:10:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 3/4] xfs_repair: call IRELE(ip) after libxfs_trans_iget calls
References: <55D61740.9070507@sandeen.net>
In-Reply-To: <55D61740.9070507@sandeen.net>
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

Commit 260c85e libxfs: dont free xfs_inode until complete
changed the alloc/free convention a bit:

    Originally, the xfs_inode are released upon the first
    call to xfs_trans_cancel, xfs_trans_commit, or
    inode_item_done.
    <snip>
    This patch does the following:
     1) Removes the iput from the transaction completion and
        requires that the xfs_inode allocators call IRELE()
        when they are done with the pointer.

But that change missed several callers in xfs_repair phase6;
fix that up.

Addresses-Coverity-Id: 1315100
Addresses-Coverity-Id: 1315101
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 repair/phase6.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index 9cfedbf..04638c2 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -585,6 +585,7 @@ mk_rbmino(xfs_mount_t *mp)
 			error);
 	}
 	libxfs_trans_commit(tp);
+	IRELE(ip);
 }
 
 static int
@@ -654,6 +655,7 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime bitmap inode %
 	}
 
 	libxfs_trans_commit(tp);
+	IRELE(ip);
 	return(0);
 }
 
@@ -714,6 +716,7 @@ fill_rsumino(xfs_mount_t *mp)
 			do_warn(
 _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime summary inode %" PRIu64 "\n"),
 				bno, map.br_startblock, mp->m_sb.sb_rsumino);
+			IRELE(ip);
 			return(1);
 		}
 
@@ -726,6 +729,7 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime summary inode
 	}
 
 	libxfs_trans_commit(tp);
+	IRELE(ip);
 	return(0);
 }
 
@@ -846,6 +850,7 @@ mk_rsumino(xfs_mount_t *mp)
 			error);
 	}
 	libxfs_trans_commit(tp);
+	IRELE(ip);
 }
 
 /*
@@ -920,6 +925,7 @@ mk_root_dir(xfs_mount_t *mp)
 	libxfs_dir_init(tp, ip, ip);
 
 	libxfs_trans_commit(tp);
+	IRELE(ip);
 
 	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino),
 				XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rootino));
-- 1.7.1


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
