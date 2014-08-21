Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EAE1E7F3F
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 13:27:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C9DD58F8039
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 11:26:59 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id cfzWYGQQDjqbdBBh for <xfs@oss.sgi.com>;
	Thu, 21 Aug 2014 11:26:57 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 60E7B63D7D24
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 13:26:57 -0500 (CDT)
Message-ID: <53F639F6.6050905@sandeen.net>
Date: Thu, 21 Aug 2014 13:27:02 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfsprogs: use ASSERT_ALWAYS for impossible switch case
References: <53F62D12.8010505@sandeen.net>
In-Reply-To: <53F62D12.8010505@sandeen.net>
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

We can shut this up and mark it as truly impossible by adding
a userspace definition for ASSERT_ALWAYS and using it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: do it in a kernel-compatible way.

diff --git a/include/xfs_btree.h b/include/xfs_btree.h
index 2590d40..f24f787 100644
--- a/include/xfs_btree.h
+++ b/include/xfs_btree.h
@@ -69,7 +69,7 @@ do {    \
 	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_INC(bmbt, stat); break;	\
 	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(ibt, stat); break;	\
 	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_INC(fibt, stat); break;	\
-	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
+	case XFS_BTNUM_MAX: ASSERT_ALWAYS(0); /* fucking gcc */ ; break; \
 	}       \
 } while (0)
 
@@ -83,7 +83,7 @@ do {    \
 	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_ADD(bmbt, stat, val); break; \
 	case XFS_BTNUM_INO: __XFS_BTREE_STATS_ADD(ibt, stat, val); break; \
 	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_ADD(fibt, stat, val); break; \
-	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
+	case XFS_BTNUM_MAX: ASSERT_ALWAYS(0); /* fucking gcc */ ; break; \
 	}       \
 } while (0)
 
diff --git a/libxfs/xfs.h b/libxfs/xfs.h
index 30a316d..81d7cd9 100644
--- a/libxfs/xfs.h
+++ b/libxfs/xfs.h
@@ -48,6 +48,10 @@
 #undef ASSERT
 #define ASSERT(ex) assert(ex)
 
+#undef ASSERT_ALWAYS
+#define ASSERT_ALWAYS(ex) \
+	(unlikely(ex) ? (void)0 : abort())
+
 typedef __uint32_t		uint_t;
 typedef __uint32_t		inst_t;		/* an instruction */
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
