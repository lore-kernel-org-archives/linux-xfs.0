Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 31EB07F3F
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2014 11:04:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CE1BFAC001
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2014 09:04:09 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 7FhIwAzAFT7intLV for <xfs@oss.sgi.com>;
	Tue, 11 Mar 2014 09:04:08 -0700 (PDT)
Received: from Liberator-2.local (nat-pool-rdu-u.redhat.com [66.187.233.203])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 19E1B60F22FE
	for <xfs@oss.sgi.com>; Tue, 11 Mar 2014 11:04:06 -0500 (CDT)
Message-ID: <531F33F4.40707@sandeen.net>
Date: Tue, 11 Mar 2014 11:04:04 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs_db: hide debug bbmap output
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

Most of xfsprogs building with DEBUG enables extra
checks, asserts, etc, but this bunch of printfs was
extra output that's not generally helpful for most
people's runtime experience - and it breaks xfs/290
with all the noise.

I assume it's for actual debugging use, and not
generally useful, so bury it a bit deeper under
it's own #ifdef.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/db/io.c b/db/io.c
index 9a787c8..89e6030 100644
--- a/db/io.c
+++ b/db/io.c
@@ -500,7 +500,7 @@ set_cur(
 	push_cur();
 
 	if (bbmap) {
-#ifdef DEBUG
+#ifdef DEBUG_BBMAP
 		int i;
 		printf(_("xfs_db got a bbmap for %lld\n"), (long long)d);
 		printf(_("\tblock map"));

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
