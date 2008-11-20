Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAK7ENDx032259 for <xfs@oss.sgi.com>; Thu, 20 Nov 2008 01:14:23 -0600
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com
	[134.14.52.130])
	by relay2.corp.sgi.com (Postfix) with SMTP id 00051304088
	for <xfs@oss.sgi.com>; Wed, 19 Nov 2008 23:14:18 -0800 (PST)
Received: from chook.melbourne.sgi.com (chook.melbourne.sgi.com
	[134.14.54.237]) by larry.melbourne.sgi.com
	(950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id SAA26800 for
	<xfs@oss.sgi.com>; Thu, 20 Nov 2008 18:14:17 +1100
Subject: TAKE - xfstest: confirm mkfs.gfs[2] in test 032
Message-Id: <20081120071417.11C5058AE1E9@chook.melbourne.sgi.com>
Date: Thu, 20 Nov 2008 18:14:17 +1100 (EST)
From: bnaujok@sgi.com (Barry Naujok)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

xfstest: confirm mkfs.gfs[2] in test 032

mkfs.gfs[2] asks for confirmation before mkfs'ing; without
this test 032 hangs when mkfs.gfs2 is present.
 
Also, mkfs.gfs needs a few more args to make it go.


Date:  Thu Nov 20 18:13:36 EST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  "Eric Sandeen" <sandeen@sandeen.net>

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:32510a
xfstests/032 - 1.15 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/032.diff?r1=text&tr1=1.15&r2=text&tr2=1.14&f=h
	- confirm mkfs.gfs[2] in test 032


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
