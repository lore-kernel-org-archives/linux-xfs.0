Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qB9Nb8tW145586 for <xfs@oss.sgi.com>; Sun, 9 Dec 2012 17:37:08 -0600
Received: from fgwmail6.fujitsu.co.jp (fgwmail6.fujitsu.co.jp [192.51.44.36])
	by cuda.sgi.com with ESMTP id MGHGnOjM04NSGDkt (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 09 Dec 2012 15:39:35 -0800 (PST)
Received: from m4.gw.fujitsu.co.jp (unknown [10.0.50.74])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 630E13EE0AE
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 08:39:33 +0900 (JST)
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 4AF5F45DE4F
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 08:39:33 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 1EC5045DE4D
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 08:39:33 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 029E41DB803B
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 08:39:33 +0900 (JST)
Received: from g01jpexchkw07.g01.fujitsu.local
	(g01jpexchkw07.g01.fujitsu.local [10.0.194.46])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id B53051DB8037
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2012 08:39:32 +0900 (JST)
Message-ID: <50C520C5.9030600@jp.fujitsu.com>
Date: Mon, 10 Dec 2012 08:37:41 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: Change the interpreter of ltp/runtest.sh to bash
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

In some environment, Running 080 fails with the following log.

==========
080	 [failed, exit status 2] - output mismatch (see 080.out.bad)
--- 080.out	2012-11-18 20:26:40.000000000 +0900
+++ 080.out.bad	2012-12-08 21:05:15.000000000 +0900
@@ -1,3 +1,26 @@
 QA output created by 080

-Completed rwtest pass 1 successfully.
+/home/sat/src/xfstests/ltp/rwtest.sh: 90: /home/sat/src/xfstests/ltp/rwtest.sh: 6: not found
+/home/sat/src/xfstests/ltp/rwtest.sh: 177: /home/sat/src/xfstests/ltp/rwtest.sh: [[: not found
+/home/sat/src/xfstests/ltp/rwtest.sh: 190: /home/sat/src/xfstests/ltp/rwtest.sh: [[: not found
+dirname: invalid option -- 'q'
+Try `dirname --help' for more information.
+/home/sat/src/xfstests/ltp/rwtest.sh: 270: /home/sat/src/xfstests/ltp/rwtest.sh: [[: not found
+/home/sat/src/xfstests/ltp/rwtest.sh: 317: /home/sat/src/xfstests/ltp/rwtest.sh: F[0+1]=-q: not found
+dirname: invalid option -- 'c'
+Try `dirname --help' for more information.
+/home/sat/src/xfstests/ltp/rwtest.sh: 270: /home/sat/src/xfstests/ltp/rwtest.sh: [[: not found
+/home/sat/src/xfstests/ltp/rwtest.sh: 317: /home/sat/src/xfstests/ltp/rwtest.sh: F[0+1]=-c: not found
+dirname: invalid option -- 'i'
+Try `dirname --help' for more information.
+/home/sat/src/xfstests/ltp/rwtest.sh: 270: /home/sat/src/xfstests/ltp/rwtest.sh: [[: not found
+/home/sat/src/xfstests/ltp/rwtest.sh: 317: /home/sat/src/xfstests/ltp/rwtest.sh: F[0+1]=-i: not found
+/home/sat/src/xfstests/ltp/rwtest.sh: 270: /home/sat/src/xfstests/ltp/rwtest.sh: [[: not found
+/home/sat/src/xfstests/ltp/rwtest.sh: 317: /home/sat/src/xfstests/ltp/rwtest.sh: F[0+1]=2000: not found
+dirname: invalid option -- 'f'
+Try `dirname --help' for more information.
+/home/sat/src/xfstests/ltp/rwtest.sh: 270: /home/sat/src/xfstests/ltp/rwtest.sh: [[: not found
+/home/sat/src/xfstests/ltp/rwtest.sh: 317: /home/sat/src/xfstests/ltp/rwtest.sh: F[0+1]=-f: not found
+/home/sat/src/xfstests/ltp/rwtest.sh: 270: /home/sat/src/xfstests/ltp/rwtest.sh: [[: not found
+/home/sat/src/xfstests/ltp/rwtest.sh: 317: /home/sat/src/xfstests/ltp/rwtest.sh: F[0+1]=direct,buffered,sync: not found
+/home/sat/src/xfstests/ltp/rwtest.sh: 320: /home/sat/src/xfstests/ltp/rwtest.sh: Bad substitution
==========

It happens because ltp/rwtest.sh assumes /bin/sh is `bash' and it's not
always true (ex. /bin/sh is `dash' in Debian.) This script should
explicitly declare that its interpriter is `bash'.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
---
 ltp/rwtest.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ltp/rwtest.sh b/ltp/rwtest.sh
index 24ee598..da42caa 100755
--- a/ltp/rwtest.sh
+++ b/ltp/rwtest.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 #
 # Copyright (c) 2000 Silicon Graphics, Inc.  All Rights Reserved.
 #
-- 1.7.10.4 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
