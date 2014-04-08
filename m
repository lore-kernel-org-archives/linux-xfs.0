Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5216280D3
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 18:25:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4A55530408E
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 16:25:25 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id qYCtFwYbupvjs5un for <xfs@oss.sgi.com>;
	Tue, 08 Apr 2014 16:25:16 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 07/14] xfs_logprint: fix leak in error path of
	xlog_print_record()
Date: Tue,  8 Apr 2014 18:24:57 -0500
Message-Id: <1396999504-13769-8-git-send-email-sandeen@redhat.com>
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

In 2 error paths we returned without freeing the allocated buf.
Collapse them into a compound test & free buf on the way out.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 logprint/log_misc.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 52f1e85..a022df4 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -942,11 +942,12 @@ xlog_print_record(
 	     */
 	    if (be32_to_cpu(rhead->h_cycle) !=
 			be32_to_cpu(*(__be32 *)ptr)) {
-		if (*read_type == FULL_READ)
-		    return -1;
-		else if (be32_to_cpu(rhead->h_cycle) + 1 !=
-			be32_to_cpu(*(__be32 *)ptr))
-		    return -1;
+		if ((*read_type == FULL_READ) ||
+		    (be32_to_cpu(rhead->h_cycle) + 1 !=
+				be32_to_cpu(*(__be32 *)ptr))) {
+			free(buf);
+			return -1;
+		}
 	    }
 	}
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
