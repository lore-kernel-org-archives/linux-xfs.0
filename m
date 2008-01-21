Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jan 2008 22:01:44 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0L61aYw020637
	for <xfs@oss.sgi.com>; Sun, 20 Jan 2008 22:01:38 -0800
Subject: TAKE 975550 - xfs_repair - bad freespace btree extent can cause internal corruption and die
Message-Id: <20080121060151.2EAD558C4C0F@chook.melbourne.sgi.com>
Date: Mon, 21 Jan 2008 17:01:51 +1100 (EST)
From: bnaujok@sgi.com (Barry Naujok)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com
Cc: xfs@oss.sgi.com

Verify end of freespace btree extent is valid


Date:  Mon Jan 21 17:01:27 AEDT 2008
Workarea:  chook.melbourne.sgi.com:/home/bnaujok/isms/xfs-cmds
Inspected by:  donaldd@sgi.com

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:30388a
xfsprogs/repair/scan.c - 1.20 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfsprogs/repair/scan.c.diff?r1=text&tr1=1.20&r2=text&tr2=1.19&f=h
	- Verify end of freespace btree extent is valid
