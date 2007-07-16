Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 15 Jul 2007 19:03:06 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6G230bm022215
	for <xfs@oss.sgi.com>; Sun, 15 Jul 2007 19:03:02 -0700
Subject: TAKE 967533 - mkfs.xfs should wipe old AG headers when using -f option
Message-Id: <20070716020257.D07A958C38F1@chook.melbourne.sgi.com>
Date: Mon, 16 Jul 2007 12:02:57 +1000 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Zero existing SB sectors with -f option


Date:  Mon Jul 16 12:02:17 AEST 2007
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  sandeen@sandeen.net

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:29138a
xfsprogs/mkfs/xfs_mkfs.c - 1.81 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/mkfs/xfs_mkfs.c.diff?r1=text&tr1=1.81&r2=text&tr2=1.80&f=h
	- Zero existing SB sectors with -f option
