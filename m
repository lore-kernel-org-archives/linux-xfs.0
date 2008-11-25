Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAP0rXXK026667 for <xfs@oss.sgi.com>; Mon, 24 Nov 2008 18:53:34 -0600
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com
	[134.14.52.130])
	by relay1.corp.sgi.com (Postfix) with SMTP id 351898F809D
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2008 16:53:29 -0800 (PST)
Received: from chook.melbourne.sgi.com (chook.melbourne.sgi.com
	[134.14.54.237]) by larry.melbourne.sgi.com
	(950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id LAA27681 for
	<xfs@oss.sgi.com>; Tue, 25 Nov 2008 11:53:28 +1100
Subject: TAKE - xfstests: add mode to open call in devzero.c,
	which may have O_CREAT set.
Message-Id: <20081125005328.0D85858C8A4D@chook.melbourne.sgi.com>
Date: Tue, 25 Nov 2008 11:53:27 +1100 (EST)
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

Fedora is catching calls to open which have O_CREAT set w/o a mode.


Date:  Tue Nov 25 11:53:02 EST 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  "Eric Sandeen" <sandeen@sandeen.net>

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:32535a
xfstests/src/devzero.c - 1.9 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/src/devzero.c.diff?r1=text&tr1=1.9&r2=text&tr2=1.8&f=h
	- Fedora is catching calls to open which have O_CREAT set w/o a mode.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
