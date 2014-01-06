Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AC2207F37
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 14:52:55 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 97F0F30407A
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 12:52:55 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id ILXQDni6Br04WUsP (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 Jan 2014 12:52:54 -0800 (PST)
Message-ID: <52CB1727.3050109@suse.com>
Date: Mon, 06 Jan 2014 15:50:47 -0500
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: aio-stress, use calloc for thread_info array
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
To: xfs@oss.sgi.com
Cc: dchinner@redhat.com

The thread_info array is assumed to be initialized to 0s, but
that causes a segfault when MALLOC_PERTURB_ is set.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---

 ltp/aio-stress.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/ltp/aio-stress.c
+++ b/ltp/aio-stress.c
@@ -1413,9 +1413,9 @@ int main(int ac, char **av)
 	        num_threads);
     }

-    t = malloc(num_threads * sizeof(*t));
+    t = calloc(num_threads, sizeof(*t));
     if (!t) {
-        perror("malloc");
+        perror("calloc");
 	exit(1);
     }
     global_thread_info = t;


-- 
Jeff Mahoney
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
