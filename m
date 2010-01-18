Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0IJKvn9124380 for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 13:20:57 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 631E111F7B06
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 11:21:54 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id sYqOESFrmuQyhzwS for
	<xfs@oss.sgi.com>; Mon, 18 Jan 2010 11:21:54 -0800 (PST)
Received: from Liberator.local (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 22390AAE3BE
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 13:21:53 -0600 (CST)
Message-ID: <4B54B4D1.7020500@sandeen.net>
Date: Mon, 18 Jan 2010 13:21:53 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] mkfs: don't warn about topology when mkfsing a file
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

Some tests were failing for me like:

 QA output created by 206
 === truncate file ===
 === mkfs.xfs ===
+warning: unable to probe device toplology for device /mnt/test/fsfile.21615
...

I thought about filtering the tests, but ...

It seems that we shouldn't even be trying to get topology for a
plain file, should we?  And then we won't warn about failure.


Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 689425d..8896035 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -356,6 +356,10 @@ static void blkid_get_topology(const char *device, int *sunit, int *swidth, int
 	blkid_topology tp;
 	blkid_probe pr;
 	unsigned long val;
+	struct stat statbuf;
+
+	if (!stat(device, &statbuf) && S_ISREG(statbuf.st_mode))
+		return;
 
 	pr = blkid_new_probe_from_filename(device);
 	if (!pr)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
