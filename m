Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAQ6NL0Y158514 for <xfs@oss.sgi.com>; Mon, 26 Nov 2012 00:23:22 -0600
Received: from fgwmail5.fujitsu.co.jp (fgwmail5.fujitsu.co.jp [192.51.44.35])
	by cuda.sgi.com with ESMTP id 4bDQXYp60VlsbFVr (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 25 Nov 2012 22:25:36 -0800 (PST)
Received: from m1.gw.fujitsu.co.jp (unknown [10.0.50.71])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 3D1343EE0BC
	for <xfs@oss.sgi.com>; Mon, 26 Nov 2012 15:25:34 +0900 (JST)
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 250E845DE58
	for <xfs@oss.sgi.com>; Mon, 26 Nov 2012 15:25:34 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 0DAEE45DE56
	for <xfs@oss.sgi.com>; Mon, 26 Nov 2012 15:25:34 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 00EEE1DB804B
	for <xfs@oss.sgi.com>; Mon, 26 Nov 2012 15:25:34 +0900 (JST)
Received: from g01jpexchkw31.g01.fujitsu.local
	(g01jpexchkw31.g01.fujitsu.local [10.0.193.114])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id B4D9B1DB804A
	for <xfs@oss.sgi.com>; Mon, 26 Nov 2012 15:25:33 +0900 (JST)
Message-ID: <50B30B41.8040400@jp.fujitsu.com>
Date: Mon, 26 Nov 2012 15:25:05 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: Remove the description about nodelaylog mount option
	from, the xfs document.
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
To: xfs ML <xfs@oss.sgi.com>

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

nodelaylog mount option is removed by commit 93b8a585. But there still be
the description about it in the xfs document. This patch removes it.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
 Documentation/filesystems/xfs.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
index 3fc0c31..860b845 100644
--- a/Documentation/filesystems/xfs.txt
+++ b/Documentation/filesystems/xfs.txt
@@ -43,7 +43,7 @@ When mounting an XFS filesystem, the following options are accepted.
        Issue command to let the block device reclaim space freed by the
        filesystem.  This is useful for SSD devices, thinly provisioned
        LUNs and virtual machine images, but may have a performance
-       impact.  This option is incompatible with the nodelaylog option.
+       impact.
 
   dmapi
        Enable the DMAPI (Data Management API) event callouts.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
