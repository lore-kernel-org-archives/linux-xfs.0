Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6GLq9uh018846 for <xfs@oss.sgi.com>; Mon, 16 Jul 2012 16:52:09 -0500
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id STPaoN5woHWABqk8 for
	<xfs@oss.sgi.com>; Mon, 16 Jul 2012 14:52:06 -0700 (PDT)
Received: from galadriel.home (unknown [82.235.234.79])
	by smtp3-g21.free.fr (Postfix) with ESMTP id C9550A60F2
	for <xfs@oss.sgi.com>; Mon, 16 Jul 2012 23:52:01 +0200 (CEST)
Date: Mon, 16 Jul 2012 23:51:54 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: xfs_repair failing.
Message-ID: <20120716235154.0d9b7c45@galadriel.home>
Mime-Version: 1.0
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
To: xfs@oss.sgi.com


Hi list,
I have a serious problem with a 60 TB XFS filesystem which looks
seriously hosed. It was repaired once earlier last week, but crashed
again after a repair friday and now xfs_repair fails with this message:

 bad magic # 0x1 in btcnt block 61/27137
 bad magic # 0xfffe68ff in btcnt block 61/201728942  

(xfs_repair 2.9.8)

The filesystem can only be mounted read-only at this point.

I suspect a RAID corruption (Adaptec 52445 with firmware 18252, Hitachi
HUA 3TB drives, RAID 6). The RAID controller have been replaced, but it
doesn't help. Any ideas?

-- 
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
