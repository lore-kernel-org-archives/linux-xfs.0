Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J92U6i178246 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 03:02:31 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A9A531734A6
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 01:03:29 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	yDJ6Z616tzTOBh5L for <xfs@oss.sgi.com>;
	Tue, 19 Jan 2010 01:03:29 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11709909-1927428
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 19:33:28 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NX9zZ-0003gF-Ex
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 20:03:17 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NX9zY-00083u-Kh
	for xfs@oss.sgi.com; Tue, 19 Jan 2010 20:03:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/3] xfsqa: update 214 golden output
Date: Tue, 19 Jan 2010 20:03:10 +1100
Message-Id: <1263891792-30952-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1263891792-30952-1-git-send-email-david@fromorbit.com>
References: <1263891792-30952-1-git-send-email-david@fromorbit.com>
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

It does not contain the output from the recently added test,
so fails when the test actually succeeds.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 214.out |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/214.out b/214.out
index b6344c2..9a7a3cf 100644
--- a/214.out
+++ b/214.out
@@ -39,3 +39,7 @@ XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 *
 read 90112/90112 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+=== delalloc write 16k; fallocate same range ===
+wrote 16384/16384 bytes at offset 0
+XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
