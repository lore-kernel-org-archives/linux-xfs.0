Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CAF767F3F
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 12:57:22 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B98F5304043
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 10:57:22 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ZxHaHSYnTVwGwSam for <xfs@oss.sgi.com>;
	Wed, 12 Nov 2014 10:57:21 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 3/9] xfsdump: fix wrong test for hard stack limit change
	failure
Date: Wed, 12 Nov 2014 12:57:12 -0600
Message-Id: <1415818638-32700-4-git-send-email-sandeen@redhat.com>
In-Reply-To: <1415818638-32700-1-git-send-email-sandeen@redhat.com>
References: <1415818638-32700-1-git-send-email-sandeen@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

We test if ( rlimit64.rlim_cur < minstacksz ) to see whether
we failed to increase rlimit64.rlim_max?  Weird.  Fix it.

(Granted, we raise both cur and max together, but it's odd to test
one, and report the other).

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 common/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/common/main.c b/common/main.c
index 8e7451f..326f801 100644
--- a/common/main.c
+++ b/common/main.c
@@ -2077,7 +2077,7 @@ set_rlimits( size64_t *vmszp )
 			( void )setrlimit64( RLIMIT_STACK, &rlimit64 );
 			rval = getrlimit64( RLIMIT_STACK, &rlimit64 );
 			ASSERT( ! rval );
-			if ( rlimit64.rlim_cur < minstacksz ) {
+			if ( rlimit64.rlim_max < minstacksz ) {
 				mlog( MLOG_NORMAL
 				      |
 				      MLOG_WARNING
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
