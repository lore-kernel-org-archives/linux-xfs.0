Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A71D07CA3
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2016 11:36:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 31DD7AC002
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2016 09:36:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HYHDPFHHUeaVu8DY (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 01 Jul 2016 09:36:12 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id EED6213A525
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2016 16:36:11 +0000 (UTC)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH] xfs_repair: don't mark the fs dirty just because memory
	possibly be low
Date: Sat,  2 Jul 2016 00:36:08 +0800
Message-Id: <1467390968-1422-1-git-send-email-zlang@redhat.com>
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
Cc: sandeen@redhat.com, Zorro Lang <zlang@redhat.com>

When I run "xfs_repair -n" on a 500T device with 16G memory,
xfs_repair print warning as below:

  Memory available for repair (11798MB) may not be sufficient.
  At least 64048MB is needed to repair this filesystem efficiently
  If repair fails due to lack of memory, please
  turn prefetching off (-P) to reduce the memory footprint.

And it return 1 at last. But xfs_repair didn't hit any error, it
just feel the memory maybe too low(not real), then return error.
There is no reason to mark the fs dirty just because it thinks it
might *possibly* be low on memory.

do_warn() will set fs_is_dirty=1, if we only want to print warning
message(not real failure), turn to use do_log() will be better.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 repair/xfs_repair.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 9d91f2d..bbf0edc 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -851,16 +851,16 @@ main(int argc, char **argv)
 	  "with the -m option. Please increase it to at least %lu.\n"),
 					mem_used / 1024);
 			}
-			do_warn(
+			do_log(
 	_("Memory available for repair (%luMB) may not be sufficient.\n"
 	  "At least %luMB is needed to repair this filesystem efficiently\n"
 	  "If repair fails due to lack of memory, please\n"),
 				max_mem / 1024, mem_used / 1024);
 			if (do_prefetch)
-				do_warn(
+				do_log(
 	_("turn prefetching off (-P) to reduce the memory footprint.\n"));
 			else
-				do_warn(
+				do_log(
 	_("increase system RAM and/or swap space to at least %luMB.\n"),
 			mem_used * 2 / 1024);
 
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
