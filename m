Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2598880BE
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 09:37:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9C32AAC004
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 07:36:59 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Cq6NnxBWutOFFoAp for <xfs@oss.sgi.com>;
	Wed, 09 Apr 2014 07:36:54 -0700 (PDT)
Message-ID: <53455B06.7000600@sandeen.net>
Date: Wed, 09 Apr 2014 09:36:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 12/14 V2] xfs_repair: address never-true tests in repair/bmap.c
	on 64 bit
References: <1396999504-13769-1-git-send-email-sandeen@redhat.com>
	<1396999504-13769-13-git-send-email-sandeen@redhat.com>
In-Reply-To: <1396999504-13769-13-git-send-email-sandeen@redhat.com>
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

The test "if (new_naexts > BLKMAP_NEXTS_MAX)" is never true
on a 64-bit platform; new_naexts is an int, and BLKMAP_NEXTS_MAX
is INT_MAX.  So just wrap the whole thing in the #ifdef.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Fix typo in comment in first hunk

 repair/bmap.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/repair/bmap.c b/repair/bmap.c
index 85d66dc..b81efb9 100644
--- a/repair/bmap.c
+++ b/repair/bmap.c
@@ -47,16 +47,16 @@ blkmap_alloc(
 	if (nex < 1)
 		nex = 1;
 
+#if (BITS_PER_LONG == 32)	/* on 64-bit platforms this is never true */
 	if (nex > BLKMAP_NEXTS_MAX) {
-#if (BITS_PER_LONG == 32)
 		do_warn(
 	_("Number of extents requested in blkmap_alloc (%d) overflows 32 bits.\n"
 	  "If this is not a corruption, then you will need a 64 bit system\n"
 	  "to repair this filesystem.\n"),
 			nex);
-#endif
 		return NULL;
 	}
+#endif
 
 	key = whichfork ? ablkmap_key : dblkmap_key;
 	blkmap = pthread_getspecific(key);
@@ -267,15 +267,15 @@ blkmap_grow(
 		ASSERT(pthread_getspecific(key) == blkmap);
 	}
 
+#if (BITS_PER_LONG == 32)	/* on 64-bit platforms this is never true */
 	if (new_naexts > BLKMAP_NEXTS_MAX) {
-#if (BITS_PER_LONG == 32)
 		do_error(
 	_("Number of extents requested in blkmap_grow (%d) overflows 32 bits.\n"
 	  "You need a 64 bit system to repair this filesystem.\n"),
 			new_naexts);
-#endif
 		return NULL;
 	}
+#endif
 	if (new_naexts <= 0) {
 		do_error(
 	_("Number of extents requested in blkmap_grow (%d) overflowed the\n"


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
