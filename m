Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 17FC87F63
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 14:15:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F2BF98F8054
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 12:15:30 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id r9KW5gKSW2MZXykn for <xfs@oss.sgi.com>;
	Wed, 09 Apr 2014 12:15:26 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 31DBA6535989
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 14:15:26 -0500 (CDT)
Message-ID: <53459C4E.9030902@sandeen.net>
Date: Wed, 09 Apr 2014 14:15:26 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs_io: fix random pread/pwrite to honor offset
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

xfs_io's pread & pwrite claim to support a random IO mode
where it will do random IOs between offset & offset+len.

However, offset was ignored, and we did the IOs between 0
and len instead.

Clang caught this by pointing out that the calculated/normalized
"offset" variable was never read.

(NB: If the range is larger than RAND_MAX, these functions don't
work, but that's always been true, so I'll leave it for another
day...)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I haven't tested this w/ xfstests but I don't see anyone who calls
pread/pwrite with "-R" (and it's not documented in the manpage!)

diff --git a/io/pread.c b/io/pread.c
index a42baed..465c22b 100644
--- a/io/pread.c
+++ b/io/pread.c
@@ -246,7 +246,7 @@ read_random(
 
 	*total = 0;
 	while (count > 0) {
-		off = ((random() % range) / buffersize) * buffersize;
+		off = ((offset + (random() % range)) / buffersize) * buffersize;
 		bytes = do_pread(fd, off, buffersize, buffersize);
 		if (bytes == 0)
 			break;
diff --git a/io/pwrite.c b/io/pwrite.c
index a2f0a81..f8a0b1e 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -129,7 +129,7 @@ write_random(
 
 	*total = 0;
 	while (count > 0) {
-		off = ((random() % range) / buffersize) * buffersize;
+		off = ((offset + (random() % range)) / buffersize) * buffersize;
 		bytes = do_pwrite(file->fd, off, buffersize, buffersize);
 		if (bytes == 0)
 			break;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
