Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D6FC57F51
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 12:32:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 66013AC003
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 10:31:59 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 8dJbn8zCRY7uTQ9w for <xfs@oss.sgi.com>;
	Thu, 21 Aug 2014 10:31:57 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 3E253602D5AE
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 12:31:57 -0500 (CDT)
Message-ID: <53F62D12.8010505@sandeen.net>
Date: Thu, 21 Aug 2014 12:32:02 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: use abort() not ASSERT(0) for impossible switch case
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

The original reason for the expletive below has been lost
in the mists of time, but at any rate, ASSERT() goes away in
libxfs, and this leads static analysis checkers to believe that
XFS_BTNUM_MAX is possible, and that we might overflow an array
later when using it as an index.

We can shut this up and mark it as truly impossible with abort().

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/include/xfs_btree.h b/include/xfs_btree.h
index 2590d40..f4a1f61 100644
--- a/include/xfs_btree.h
+++ b/include/xfs_btree.h
@@ -69,7 +69,7 @@ do {    \
 	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_INC(bmbt, stat); break;	\
 	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(ibt, stat); break;	\
 	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_INC(fibt, stat); break;	\
-	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
+	case XFS_BTNUM_MAX: abort(); /* fucking gcc */ ; break;	\
 	}       \
 } while (0)
 
@@ -83,7 +83,7 @@ do {    \
 	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_ADD(bmbt, stat, val); break; \
 	case XFS_BTNUM_INO: __XFS_BTREE_STATS_ADD(ibt, stat, val); break; \
 	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_ADD(fibt, stat, val); break; \
-	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
+	case XFS_BTNUM_MAX: abort(); /* fucking gcc */ ; break;	\
 	}       \
 } while (0)
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
