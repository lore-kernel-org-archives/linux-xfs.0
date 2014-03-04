Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4B12A7F4E
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 23:44:00 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 12049304032
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 21:43:59 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id RHnHa8BQkCoqcKAg for <xfs@oss.sgi.com>;
	Mon, 03 Mar 2014 21:43:58 -0800 (PST)
Message-ID: <5315681C.5070704@sandeen.net>
Date: Mon, 03 Mar 2014 23:43:56 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfstests: fix error msg in aio-dio-subblock-eof-read.c
References: <53156389.4060405@redhat.com>
In-Reply-To: <53156389.4060405@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

io_getevents returns the number of events; printing its
return as "bytes read" is ... wrong.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: print as signed so we can easily see errors returned

diff --git a/src/aio-dio-regress/aio-dio-subblock-eof-read.c b/src/aio-dio-regress/aio-dio-subblock-eof-read.c
index a48841d..8f74cec 100644
--- a/src/aio-dio-regress/aio-dio-subblock-eof-read.c
+++ b/src/aio-dio-regress/aio-dio-subblock-eof-read.c
@@ -105,8 +107,8 @@ main(int argc, char **argv)
 	 *  are broken, we may very well see a result of 4k.
 	 */
 	if (ie.res != FILE_SIZE)
-		fail("AIO read of last block in file returned %d bytes, "
-		     "expected %d\n", ret, FILE_SIZE);
+		fail("AIO read of last block in file returned %ld bytes, "
+		     "expected %d\n", ie.res, FILE_SIZE);
 
 	printf("AIO read of last block in file succeeded.\n");
 	return 0;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
