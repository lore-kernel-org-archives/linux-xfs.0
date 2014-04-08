Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A91288118
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 18:26:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A16A58F808E
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 16:26:47 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id GKPddzkov9B30Exu for <xfs@oss.sgi.com>;
	Tue, 08 Apr 2014 16:26:36 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 11/14] xfs_quota: remove impossible tests in printpath
Date: Tue,  8 Apr 2014 18:25:01 -0500
Message-Id: <1396999504-13769-12-git-send-email-sandeen@redhat.com>
In-Reply-To: <1396999504-13769-1-git-send-email-sandeen@redhat.com>
References: <1396999504-13769-1-git-send-email-sandeen@redhat.com>
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

printpath() had some cut & paste tests of "c" - but
nothing had set it yet other than c=0, so testing it
is pointless.  Just remove tests for non-zero "c"
until we might have set it to something interesting.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 quota/path.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/quota/path.c b/quota/path.c
index e9a6834..47fdd93 100644
--- a/quota/path.c
+++ b/quota/path.c
@@ -54,9 +54,9 @@ printpath(
 		c = 0;
 		printf(" (");
 		if (qstat.qs_flags & XFS_QUOTA_UDQ_ENFD)
-			c = printf("%suquota", c ? ", " : "");
+			c = printf("uquota");
 		else if (qstat.qs_flags & XFS_QUOTA_UDQ_ACCT)
-			c = printf("%suqnoenforce", c ? ", " : "");
+			c = printf("uqnoenforce");
 		if (qstat.qs_flags & XFS_QUOTA_GDQ_ENFD)
 			c = printf("%sgquota", c ? ", " : "");
 		else if (qstat.qs_flags & XFS_QUOTA_GDQ_ACCT)
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
