Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9EADA7F4E
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 23:24:31 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 46209AC005
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 21:24:30 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id XgbR6YfWT5I2Fdr2 for
	<xfs@oss.sgi.com>; Mon, 03 Mar 2014 21:24:27 -0800 (PST)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s245OQkl022137
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 4 Mar 2014 00:24:26 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id s245OPMP024256
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 4 Mar 2014 00:24:25 -0500
Message-ID: <53156389.4060405@redhat.com>
Date: Mon, 03 Mar 2014 23:24:25 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: fix error msg in aio-dio-subblock-eof-read.c
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

io_getevents returns the number of events; printing its
return as "bytes read" is ... wrong.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

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
+		fail("AIO read of last block in file returned %lu bytes, "
+		     "expected %d\n", ie.res, FILE_SIZE);
 
 	printf("AIO read of last block in file succeeded.\n");
 	return 0;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
