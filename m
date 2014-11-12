Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1EBDF7F4E
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 12:57:23 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F3104304043
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 10:57:22 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id iIMubdX1mPwG35AQ for <xfs@oss.sgi.com>;
	Wed, 12 Nov 2014 10:57:20 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/9] xfsdump: don't try to close fd from failed open
Date: Wed, 12 Nov 2014 12:57:10 -0600
Message-Id: <1415818638-32700-2-git-send-email-sandeen@redhat.com>
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

I was going to just return if open() fails, but realized that
failing ioctls on the not-opened fd are ... maybe intentional?
By trying to run the ioctls on the invalid fd, it actually spits
useful error messages to the log, so...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 restore/tree.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/restore/tree.c b/restore/tree.c
index 08e177f..fda4fc5 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -2626,7 +2626,8 @@ setdirattr( dah_t dah, char *path )
 		     path,
 		     strerror(errno));
 	}
-	( void )close( fd );
+	if (fd >= 0)
+		close( fd );
 }
 
 /* deletes orphanage if empty, else warns
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
