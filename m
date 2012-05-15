Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4FKKmZY211736 for <xfs@oss.sgi.com>; Tue, 15 May 2012 15:20:48 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id DHRan4kU7CQhT8Ls (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 15 May 2012 13:20:47 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] Fix failure in 273 due to lack of inodes
Date: Tue, 15 May 2012 22:20:29 +0200
Message-Id: <1337113229-9714-1-git-send-email-jack@suse.cz>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: sandeen@redhat.com, Jan Kara <jack@suse.cz>

Test 273 fails for me due to lack of inodes (ext? filesystem is not configured
to have enough inodes for being filled up by 4k files). So change the test
to create larger files so that we don't hit this limit.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 273 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

 I'm not sure if this fix isn't also just lurking somewhere in the pipeline
but I didn't find anything...

diff --git a/273 b/273
index 2965132..0bf7167 100755
--- a/273
+++ b/273
@@ -43,7 +43,7 @@ _cleanup()
 . ./common.filter
 
 threads=50
-count=1
+count=2
 
 _threads_set()
 {
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
