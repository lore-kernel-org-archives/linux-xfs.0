Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0NLEXLx207249 for <xfs@oss.sgi.com>; Sat, 23 Jan 2010 15:14:33 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 16B3F186AD2
	for <xfs@oss.sgi.com>; Sat, 23 Jan 2010 13:15:33 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id 6b02CljfFykcwBKR for
	<xfs@oss.sgi.com>; Sat, 23 Jan 2010 13:15:33 -0800 (PST)
Received: from Liberator.local (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 540F0A2129D
	for <xfs@oss.sgi.com>; Sat, 23 Jan 2010 15:15:33 -0600 (CST)
Message-ID: <4B5B66F5.7060608@sandeen.net>
Date: Sat, 23 Jan 2010 15:15:33 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] repair: add missing newlines to scan.c
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Commit c83b756da0dac727457022d88d2a0ace30a6dc09 added some new
do_warn's but omitted the "\n" leading to some pretty messy
output when we go down this path.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/repair/scan.c b/repair/scan.c
index c4d2825..85017ff 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -563,13 +563,13 @@ _("%s freespace btree block claimed (state %d), agno %d, bno %d, suspect %d\n"),
 
 			if (b == 0 || !verify_agbno(mp, agno, b)) {
 				do_warn(
-	_("invalid start block %u in record %u of %d btree block %u/%u"),
+	_("invalid start block %u in record %u of %d btree block %u/%u\n"),
 					b, i, name, agno, bno);
 				continue;
 			}
 			if (len == 0 || !verify_agbno(mp, agno, end - 1)) {
 				do_warn(
-	_("invalid length %u in record %u of %d btree block %u/%u"),
+	_("invalid length %u in record %u of %d btree block %u/%u\n"),
 					len, i, name, agno, bno);
 				continue;
 			}


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
